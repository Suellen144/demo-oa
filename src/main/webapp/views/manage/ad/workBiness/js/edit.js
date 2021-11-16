var fileData = null;

$(function() {
	$("#userDialog").initUserDialog({
		"callBack": getData
	});
	initDatetimepicker();
	initInputMask();
	inittextarea();
	
	var status = $("#status").val() ;
	var sessionUserId = $("#sessionUserId").val() ;
	var userId = $("#userId").val() ;
	
	if( status == '1' && hasEditPermission ){
		$("#submitButton").show(); 
	}
	
	if( status != '1' && sessionUserId==userId){
		$("#saveButton").show();
		$("#submitButton").show(); 
	}
});



var currTd = null;
function openDialog(obj) {
	currTd = obj;
	$("#userDialog").openUserDialog();
}


function getData(data) {
	if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
		$(currTd).find("input[name='responsibleUserName']").val(data.name);
		$(currTd).find("input[name='responsibleUserId']").val(data.id);
	}
}

function save() {
	$("#status").val("");
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(true);
	submitForm(formData);
}

function submitinfo(){
    $("#status").val("1");
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	openBootstrapShade(true);
	submitForm(formData);

}

function submitForm(formData) {
	$.ajax({
		url: base+"/manage/ad/workBiness/saveOrUpdate",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


/********* 表单相关函数 ***************/

function checkForm(formData) {
	var text = [];
	
	/*if(formData["buinsessAttachsList"].length <= 0) {
		text.push("至少有一条登记！");
	} else {
		*/
		$(formData["buinsessAttachsList"]).each(function(index, attach) {
			if(isNull(attach["workDate"])) {
				text.push("日期不能为空！");
				return false;
			}
			if(isNull(attach["workTime"])) {
				text.push("时长不能为空！");
				return false;
			}
			if(isNull(attach["payDate"])) {
				text.push("交付日期不能为空！");
				return false;
			}
			if(isNull(attach["content"])) {
				text.push("工作内容不能为空！");
				return false;
			}
		});
	/*}*/
	
	return text;
}

function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["buinsessAttachsList"] = [];
	$("tr[name='node']").each(function(index, tr) {
		var responsibleUserId = $(this).find("input[name='responsibleUserId']").val();
		var responsibleUserName = $(this).find("input[name='responsibleUserName']").val();
		var workDate = $(this).find("input[name='workDate']").val();
		var workTime = $(this).find("input[name='workTime']").val();
		var payDate = $(this).find("input[name='payDate']").val();
		var content = $(this).find("textarea[name='content']").val();
		var remark = $(this).find("textarea[name='remark']").val();
		
		if(!isNull(workDate) || !isNull(workTime)
				|| !isNull(payDate) || !isNull(content) || !isNull(responsibleUserId) || !isNull(responsibleUserName) || !isNull(remark)) {
			var businessAttach = {};
			businessAttach["workDate"] = workDate;
			businessAttach["workTime"] = workTime;
			businessAttach["payDate"] = payDate;
			businessAttach["content"] = content;
			businessAttach["remark"] = remark;
			businessAttach["responsibleUserId"] = responsibleUserId;
			businessAttach["responsibleUserName"] = responsibleUserName;
			formData["buinsessAttachsList"].push(businessAttach);
		}
	});
	
	return formData;
}

/********* 初始化相关函数 **********/

function initDatetimepicker() {
	$(".workDate, .payDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
        bootcssVer:3,
        todayBtn: true
    });
}

function initInputMask() {
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "workTime") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
		}
	});
}

//初始化文本域
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		initInputMask();
		inittextarea();
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td>');
	html.push('<input name="workDate" type="text" class="workDate" text-align: center;" readonly></td>');
	html.push('</td>');
	html.push('<td>');
	html.push('<input name="workTime" type="text" id="workTime" class="workTime">');
	html.push('</td>');
	html.push('<td> <input name="payDate" type="text" class="payDate"  readonly></td>');
	html.push('<td onclick="openDialog(this)"><input type="text" name="responsibleUserName" id="responsibleUserName"   readonly class="input" value = "" >');
	html.push('<input type="hidden" name="responsibleUserId" id="responsibleUserId" class="input" value = "">')
	html.push('</td>');
	html.push('<td><textarea name="content" type="text" style="width:100%;height:10px;"></textarea></td>');
	html.push('<td><textarea name="remark"></textarea></td>')
	html.push('<td>')
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}

//文件上传
function initFileUpload() {
	var date = new Date();
	
	var params = {
		"path": "travel/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 3 * 1024 * 1024, // 3 MB
        messages: {
        	maxFileSize: '附件大小最大为3M！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#showName").val(data.files[0].name);
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function(e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
        		// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
    			$("#file").fileupload("option", "formData", urlParam);
        		$("#showName").val(result.originName);
        		$("#attachments").val(result.path);
        		$("#attachName").val(result.originName);
        		
        		var formData = getFormData();
        		submitForm(formData);
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}