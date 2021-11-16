$(function() {
	initDatetimepicker();
	initInputMask();
	inittextarea();
	initFileUpload();
	inittotal();
	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept
	});
	
})
var indexTr="";
function openDept(obj) {
	indexTr=$(obj).parent();
	$("#deptDialog").openDeptDialog();
	
}

function getDept(data) {
    if(!isNull(data)) {
        $(indexTr).find("input[name='deptsId']").val(data.id);
        $(indexTr).find("input[name='deptsName']").val(data.name);
    }
}



var projectObj = null;
function openProject(obj) {
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	var projectName = $(obj).find("input[name='projectName']").val();
	if( isNull(projectName) ) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		
		if( tr.length > 0 && !isNull($(tr).find("input[name='projectName']").val()) ) {
			$(obj).find("input[name='projectManageId']").val( $(tr).find("input[name='projectManageId']").val() );
			$(obj).find("input[name='projectName']").val( $(tr).find("input[name='projectName']").val() );
			return ;
		}
	}
	
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectManageId']").val(data.id);
		$(projectObj).find("input[name='projectName']").val(data.name);
	}
}

//初始化输入框约束
function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "money") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
		if(name == "receivedAccount") {
			$(input).inputmask("Regex", { regex: "\\d+" });
		}
	});
}

//初始化文本域
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

function initDatetimepicker() {
	$("input[name='date']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("input[name='voucherTime']").datetimepicker({
		minView: 3,
		language:"zh-CN",
		format: "yyyy-mm",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        startView: 3, 
        autoclose: true,
    });
	
}


function inittotal(){
	var total = 0;
	var money = 0;
	$("tr[name='node']").each(function(index, tr){
			temp = $(tr).find("input[name='money']").val();
			if (temp == "" || temp == null) {
				temp = 0;
			}
			total = digitTool.add(total, parseFloat(temp));
	});
	$("#total").text(fmoney(total,0));
//	total.toFixed(2)
}

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		inittotal();
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		initInputMask();
		inittextarea();
		$("tbody").find("tr[name='node']").find("input").each(function(index, input){
			var name = $(input).attr("name");
			if(name == "date") {
				if ($(input).val() != null && $(input).val() != "") {
					temp = $(input).val();
				}
				if ($(input).val() == null || $(input).val() == "") {
					$(input).val(temp);
				}
			}
			
		});
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node"><input type="hidden"  name="attachId" value="">');
	html.push('<td><input type="text" name="date" class="date" readonly></td>');
	html.push('<td colspan="2" onclick="openProject(this)"><input name="projectName" style="width: 100%;border: none;text-align: center;" readonly>');
	html.push('<input type="hidden" name="projectManageId" value=""></td>');
	html.push('<td colspan="2"><textarea name="reason" class="input"></textarea></td>');
	html.push('<td><input type="text" name="money"  onkeyup="inittotal()" style="text-align:right;"   value=""></td>');
	html.push('<td>');
	html.push('<select name="type" style="width: 100%;height: 100%;">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</td>');
/*	html.push('<td>');
	html.push('<select name="costProperty" style="width: 100%;height: 100%;">');
	html.push($("#costType_hidden").html());
	html.push('</select>');
	html.push('</td>');*/
	html.push('<td>');
	html.push('<input type="text"  name="deptsName" value="" onclick="openDept(this)" readonly/>');
	html.push('<input type="hidden" name="deptsId"  value="">');
	html.push('</td>');
	html.push('<td><input type="text" name="receivedCompany" style="width: 100%;border: none;text-align: center;">');
	html.push('<td><input type="text" name="receivedAccount" style="width: 100%;border: none;text-align: center;">');
	html.push('<td>');
	html.push('<a href="javascript:void(0);" name="add" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a>');
	html.push('<a href="javascript:void(0);" name="del" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png" style="margin-right: 6px"></a>');
	html.push('</td>');
	html.push('</tr>');
	
	return html.join("");
}

//保存信息
function save(){
	var formData = getFormJson();
	var issubmit = $("#issubmit").val("0");//区分保存和提交
	
	var checkMsg= checkForm(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	if(fileData != null) { // 已选择文件，则先上传文件
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		saveInfo(formData);
	}
}

function saveInfo(formData){
	$.ajax({
		url: "saveInfo",
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

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["commonPayAttachs"] = [];
	if ($("#voucherTime").val() != null && $("#voucherTime").val() != "") {
		formData["voucherTime"] = $("#voucherTime").val()+"-01";
	}
	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var id = $(this).find("input[name='attachId']").val();
		var date = $(this).find("input[name='date']").val();
		var projectManageId = $(this).find("input[name='projectManageId']").val();
		var reason = $(this).find("textarea[name='reason']").val();
		var type = $(this).find("select[name='type']").val();
		var money = $(this).find("input[name='money']").val();
		var deptId=$(tr).find("input[name='deptsId']").val();
		var receivedCompany = $(this).find("input[name='receivedCompany']").val();
		var receivedAccount = $(this).find("input[name='receivedAccount']").val();
		// 其中一个有值就算有效表单数据
		if(!isNull(id) || !isNull(date) || !isNull(projectManageId)
				|| !isNull(reason) || !isNull(type) 
				|| !isNull(money) || !isNull(receivedCompany)
				|| !isNull(receivedAccount)) {
			var data = {};
			data["id"] = id;
			data["date"] = date;
			data["projectManageId"] = projectManageId;
			data["reason"] = reason;
			data["type"] = type;
			data["money"] = money;
			data["deptId"] = deptId;
			data["receivedCompany"] = receivedCompany;
			data["receivedAccount"] = receivedAccount;

			formData["commonPayAttachs"].push(data);
		}
	});

	return formData;
}

function checkForm(formData) {
	var checkMsg = [];
	if(isNull(formData["voucherTime"])) {
		checkMsg.push("制表日期不能为空！");
		return checkMsg;
	}
	if(isNull(formData["commonPayAttachs"])) {
		checkMsg.push("至少有一条银行常规付款申请！");
	}
	$(formData["commonPayAttachs"]).each(function(index, data) {
		
		if(isNull(data["date"])) {
			checkMsg.push("时间不能为空！");
			return checkMsg;
		}
		
		if(isNull(data["projectManageId"])) {
			checkMsg.push("项目不能为空！");
			return checkMsg;
		}
		
		if(isNull(data["money"])) {
			checkMsg.push("金额不能为空！");
			return checkMsg;
		}
		
		if(isNull(data["receivedCompany"])) {
			checkMsg.push("收款单位不能为空！");
			return checkMsg;
		}
	/*	if(isNull(data["receivedAccount"])) {
			checkMsg.push("收款账号不能为空！");
			return checkMsg;
		}*/

	});
	return checkMsg;
}

//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)&& attachUrl.indexof(".txt") > -1) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}else{
		
	}
}


//删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/finance/commonPay/deleteAttach",
				data: {"path":$("#attachments").val(), "id":$("#id").val()},
				type: "post",
				dataType: "json",
				success: function(data) {
					if(data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
	        			});
					}
					else{
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
			    error: function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			       }
				
			});
		}, null);
	}
	else{
		bootstrapAlert("提示", "无附件！", 400, null);
	}
}


//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "commonPay/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
        	maxFileSize: '附件大小最大为50M！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#showName").val(data.files[0].name);
            	console.log(data.files[0].name);
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
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
        		
        		var formData = getFormJson();
        		if($("#issubmit").val()=="0"){
        			saveInfo(formData);
        		}
        		else{
        			submit(formData);
        		}
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}

function del(id) {
	$.ajax({
		url:"/manage/finance/commonPay/delete",
		type:"post",
		data:{
			"id":id,
		},
		dataType:"json",
		success:function (data) {
            if(data.code == 1) {
                backPageAndRefresh();
            } else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
		error:function () {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	});
}