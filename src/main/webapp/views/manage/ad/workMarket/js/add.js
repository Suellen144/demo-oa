var currTd = null;
$(function() {
	$("#userDialog").initUserDialog({
		"callBack": getData
	});
	initDatetimepicker();
	inittextarea();
	initInputMask();
	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
});

function initInputMask() {
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "clientPhone") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
		}
	});
}


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

function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

function initDatetimepicker() {
	
	$("input[name='workDate']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$(".starttime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true,
        autoclose: true,
        bootcssVer:3
    }).on('changeDate',function(e){  
        var startTime = e.date;  
        $(".endtime").datetimepicker('setStartDate',startTime);  
    });
	
	$(".endtime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true ,
        bootcssVer:3,
        autoclose: true
    });
	
}

//新增删除表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		var trLength = $("tbody").find("tr[name='node']").length;
		if(trLength < 3){
			var html = getNodeHtml();
			$(obj).parents("tr").after(html);
			inittextarea();
			initDatetimepicker();
			initInputMask();
		}
	}
}


function getNodeHtml() {
	var html = [];
	
	html.push('<tr name="node">');
	html.push('<td style="height:100%;"><input type="text" name="workDate" id="workDate" class="workDate" size="18" readonly></td>');
	html.push('<td style="height:100%;"><input type="text" name="startTime" id="startTime" class="starttime" size="18" readonly></td>');
	html.push('<td style="height:100%;"><input type="text" name="endTime" id="endTime" class="endtime"  size="18" readonly ></td>');
	html.push('<td style="height:100%;"><input type="text" name="company" id="company" class="input" value = ""></td>');
	html.push('<td style="height:100%;"><input type="text" name="clientName" id="clientName" class="input" value = "" ></td>');
	html.push('<td style="height:100%;"><input type="text" name="clientPosition" id="clientPosition" class="input" value = ""></td>');
	html.push('<td style="height:100%;"><input type="text" name="clientPhone" id="clientPhone" class="input" value = "" ></td>');
	html.push('<td style="height:100%;">');
	html.push('<select id="level" name="level" class="form-control"  class="input" style="height:100%;width:100%;text-align-last:center;border: 0px"><option></option>');
	html.push($("#addLevel").html());
	html.push('</select></td>');
	html.push('<td style="height:100%;" onclick="openDialog(this)"><input type="hidden" name="responsibleUserId" id="responsibleUserId" class="input" value = "" > <input type="text" name="responsibleUserName" id="responsibleUserName"  readonly class="input" value = "" ></td>');
	html.push('<td style="height:100%;"><textarea  name="content" id="content" class="input" value = ""></textarea></td>');
	html.push('<td style="height:100%;"><textarea name="remark" id="remark" class="input" value = "" ></textarea></td>');
	
	html.push('<td style="height:100%;"><a href="javascript:void(0);" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right:6px"></a>');			
	html.push('<a href="javascript:void(0);" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a></a>');
	html.push('</td>');
	return html.join("");
}


function save() {
	$("#status").val("");
	var formData = getFormJson();
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
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(true);
	submitForm(formData);
}


function submitForm(formData){
	$.ajax({
		url: base+"/manage/ad/workMarket/saveOrUpdate",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", "提交失败！", 400, null);
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
	
	formData["marketAttachsList"] = [];

	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var workDate = $(this).find("input[name='workDate']").val();
		var startTime = $(this).find("input[name='startTime']").val()+":00";
		var endTime = $(this).find("input[name='endTime']").val()+":00";
		var company = $(this).find("input[name='company']").val(); 
		var clientName = $(this).find("input[name='clientName']").val();
		var clientPosition = $(this).find("input[name='clientPosition']").val();
		var clientPhone = $(this).find("input[name='clientPhone']").val();
		var level = $(this).find("select[name='level']").val();
		var responsibleUserId = $(this).find("input[name='responsibleUserId']").val();
		var responsibleUserName = $(this).find("input[name='responsibleUserName']").val();
		var content = $(this).find("textarea[name='content']").val();
		var remark = $(this).find("textarea[name='remark']").val();
		
		if( !isNull(workDate) || (!isNull(startTime)&&startTime !=":00")
				|| (!isNull(endTime)&&endTime !=":00") || !isNull(company) || !isNull(clientName)
				|| !isNull(clientPosition) || !isNull(clientPhone) || !isNull(level)
				|| !isNull(responsibleUserId) || !isNull(content) ||!isNull(remark)) {
			
			var adWorkMarketAttach = {};
			adWorkMarketAttach["workDate"]= workDate;
			adWorkMarketAttach["startTime"]= startTime;
			adWorkMarketAttach["endTime"]= endTime;
			adWorkMarketAttach["company"]=company;
			adWorkMarketAttach["clientName"]=clientName;
			
			adWorkMarketAttach["clientPosition"]=clientPosition;
			adWorkMarketAttach["clientPhone"]=clientPhone;
			adWorkMarketAttach["level"]=level;
			adWorkMarketAttach["responsibleUserId"]=responsibleUserId;
			adWorkMarketAttach["responsibleUserName"]=responsibleUserName;
			adWorkMarketAttach["content"]=content;
			adWorkMarketAttach["remark"]=remark;
			
			formData["marketAttachsList"].push(adWorkMarketAttach);
			
		}
	});
	
	return formData;
}


function checkForm(formData) {
	var text = [];
		$(formData["marketAttachsList"]).each(function(index, attach) {
			if(isNull(attach["workDate"]) || attach["startTime"] == ":00" ||attach["endTime"] == ":00" 
				||isNull(attach["company"])||isNull(attach["clientName"])||isNull(attach["clientPosition"])||isNull(attach["clientPhone"])||isNull(attach["level"])||isNull(attach["responsibleUserId"]) ||isNull(attach["content"]) ) {
				text.push("除备注外，均为必填，请填写完整！");
				return false;
			}
		});
	
	return text;
}


/*提供给Iframe父页面调用的方法*/
function checkNull(){
	var formData = getFormJson();
	var checkMsg = [];
	
	if(formData["marketAttachsList"].length <= 0 ){
		checkMsg.push("至少有一条工作汇报！");
	}
	return checkMsg;
}


function checkAll(){
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	return checkMsg.join("<br />");
}





