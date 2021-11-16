/******************************
 * 		全局变量			  	  *
 ******************************/
var fileData = null;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交": save,
	"同意": agree,
	"不同意": disagree,
	"重新申请": reApply,
	"取消申请": cancelApply,
};


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意  10:出纳不同意
 * */
//同意后的下一状态
var approvedStatus = {
	"0": "1",
	"1": "2",
	"2": "3",
	"3": "4",
	"4": "5"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0": "6",
	"1": "7",
	"2": "8",
	"3": "9",
	"4": "10",
};
// 环节与状态的映射
var nodeOnStatus = {
	"0": "提交申请",
	"1": "部门经理",
	"2": "财务",
	"3": "总经理",
	"4": "出纳",
	"5": "已归档",
	"6": "取消申请",
	"7": "提交申请",
	"8": "提交申请",
	"9": "提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "通过",
	"不同意": "不通过",
	"取消申请": "取消申请",
};

$(function() {	
	//inittextarea();
	initTaskComment();
	initFileUpload();
	initInputMask();
	initInputBlur();
	if($("#currStatus").val() == "4"){
		initDatetimepicker();
	}
	
	
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	var barginManageId = $("#barginManageId").val();
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	if(!isNull(barginManageId) && typeof barginManageId != 'undefined' && !isNull(barginProcessInstanceId) && typeof barginProcessInstanceId != 'undefined'){
		$("#viewBarginBtn").show();
	}
	
	initInvoiceMoney();
});

function change(obj){
	
	if($(obj).val() == '1'){
		$(".showOrHidden").show();
		initInputMask();
	}else if($(obj).val() == '0' || $(obj).val() == ''){
		$(".showOrHidden").hide();
	}
}

function initInvoiceMoney(){
	if($("#invoiceCollect").val() == "1"){
		$(".showOrHidden").show();
		initInputMask();
	}
}


function openBargin() {
	$("#barginDialog").openBarginDialog();
}


function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {

		$("#barginManageId").val("");
		$("#barginProcessInstanceId").val("");
		$("#barginCode").val("");
		$("#barginName").val("");
		$("#totalMoney").val("");
		$("#projectManageName").val("");
		$("#projectManageId").val("");
		$("#unpayMoney").val("");
		var s = $("#unpayMoney").val();
		
		var unpayMoney =data.unpayMoney > 0 ? data.unpayMoney.toFixed(2) : "" ;
		$("#unpayMoney").val(unpayMoney);
		$("#barginManageId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalMoney").val(data.totalMoney);
		if(data.projectManage != null && data.projectManage != ""){
			$("#projectManageName").val(data.projectManage.name);
			$("#projectManageId").val(data.projectManage.id);
		}
		
		if(data.processInstanceId != null && data.processInstanceId != "" && data.processInstanceId != "undefined"){
			$("#tip").remove();
			$("#viewBarginBtn").show();
		}else{
			$("#tip").remove();  
			
			document.getElementById("viewBarginBtn").style.display = "none";
		        
			$("#viewBarginBtn").before('<font id="tip" style="border:none;color: rgb(54, 127, 169)">选取成功！</font>');
		}
	}
}

//查看合同详细
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	alert(barginProcessInstanceId);
	//原正式数据库手动status为5，流程实例ID为null
	var url = "";
	if(barginProcessInstanceId != null && barginProcessInstanceId != ""){
		var param = {
				"processInstanceId": barginProcessInstanceId,
				"page": "manage/sale/barginManage/viewDetail"
			}
		url = web_ctx + "/activiti/process?" + urlEncode(param);
	}
	
	$("#barginDetailFrame").attr("src", url);
	$("#barginDetailModal").modal("show");
}

function approve(status) {
	$("#operStatus").val(status);
	oper2Method[status].call();
}

function agree() {
	save();
}

function disagree() {
	save();
}

function reApply() {
	save();
}

function cancelApply() {
	cancelProcess();
}

/******************************
 * 		表单处理相关函数		  	  *
 ******************************/
function save() {
	var actualPayMoney = $("#actualPayMoney").val();
	if(isNull(actualPayMoney) && typeof (actualPayMoney) != 'undefined'){
		var applyMoney = $("#applyMoney").val();
		$("#actualPayMoney").val(applyMoney)
	}
	
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	var issubmit = $("#issubmit").val("0");//区分保存和提交
	
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	if(fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/finance/pay/saveInfo",
		type: "post",
		data: JSON.stringify(formData),
		dataType: "json",
		contentType: "application/json",
		success: function(data) {
			if(data.code == 1) {
				var currUserId =$("#currUserId").val();
				var userId =$("#userId").val();
				var oper = $("#operStatus").val();
				var isHandler = $("#isHandler").val();
				var taskName = $("#taskName").val();
						
				if(oper == "重新申请" ||  oper == '同意' || oper == '不同意') {
					submitProcess();
				} else {	
						backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function(data) {
			openBootstrapShade(false);
		}
	});
}

function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  barginCode = $.trim($("#barginCode").val());
	var  invoiceCollect = $.trim($("#invoiceCollect").val());
	var totalMoney = $("#totalMoney").val();
	var applyMoney = $("#applyMoney").val();
	var applyProportion = $("#applyProportion").val();
	var invoiceMoney = $("#invoiceMoney").val();
	
	var collectCompany = $("#collectCompany").val();
	var bankAddress = $("#bankAddress").val();
	var bankAccount = $("#bankAccount").val();
	
	if(isNull(collectCompany)) {
		text.push("请填写收款单位！");
		
	}else if(isNull(bankAddress)){
		text.push("请填写开户行！");
	
	}else if(isNull(bankAccount)){
		text.push("请填写账号！");
	
	}else if(isNull(applyMoney)){
		text.push("请填写申请金额！");
	
	}else if(isNull(invoiceCollect)){
		text.push("请选择发票是否已收！");
	
	}
	
	if(!isNull(invoiceCollect) && invoiceCollect== '1' && isNull(invoiceMoney)){
		text.push("请填写发票金额！");
	
	}
	var currUserId =$("#currUserId").val();
	var userId =$("#userId").val();
	var taskName = $("#taskName").val();
	
	/*var unpayMoney = $("#unpayMoney").val();
	if(!isNull(applyMoney)&& !isNull(unpayMoney) && typeof (unpayMoney) != 'undefined'){
		if(digitTool.subtract(applyMoney , unpayMoney) > 0 ){
			$("#applyMoney").val(unpayMoney);
			$("#applyProportion").val("");
			
			text.push("申请金额不能大于未付款金额！");
		}
	}*/
	
	
	var actualInvoiceStatus = $("#actualInvoiceStatus").val();
	var actualPayMoney = $("#actualPayMoney").val();
	var oper = $("#operStatus").val();
	
	/*var isHandler = $("#isHandler").val();
	var taskName = $("#taskName").val();
	
	if(isHandler && taskName == "出纳" && oper == "同意"){
		if(isNull(actualPayMoney)) {
			text.push("请填写实际付款金额！");
		}else{
			if(digitTool.subtract(actualPayMoney , unpayMoney) > 0){
				$("#actualPayMoney").val("");
				text.push("实际付款金额不能大于未付款金额！");
			}
		}
	}
		*/
	return text;
}

function submitProcess() {
	var variables = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variables);
	
	if(compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		if(statusResult.code == 1) {
			var text = "操作成功！";
    		if($("#operStatus").val() == "提交") {
    			text = "提交成功 ！";
    		} else if($("#operStatus").val() == "重新申请") {
    			text = "重新申请成功 ！";
    		} else if($("#operStatus").val() == "取消申请") {
    			text = "取消申请成功 ！";
    		}
    		
    		window.parent.initTodo();
    		backPageAndRefresh();

    	} else {
    		bootstrapAlert("提示", statusResult.result, 400, null);
    	}
		
		if($("#operStatus").val() == "同意" && $("#isHandler").val() &&  $("#taskName").val() == "出纳") {
			//出纳同意，将实际已付款金额和实际未付款金额保存到合同数据库
			updateBargin();
		}
	} else if(compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
	
	openBootstrapShade(false);
}

//取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if(result != null) {
			if(result.code == 1) {
				var statusResult = setStatus("6");
				if(statusResult.code == 1) {
						window.parent.initTodo();
						backPageAndRefresh();
				/*	});*/
				} else {
					bootstrapAlert("提示", statusResult.result, 400, null);
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意 
 * */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	
	if($("#operStatus").val() == "同意") {
			status = approvedStatus[currStatus];
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	}else {
		status = "1";
	}
	
	return status;
}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/finance/pay/setStatus",    
        "dataType": "json",
        "async": false,
        "data": {"id": id, "status": status},
        "success": function(data) {
        	result = data;
        },
        "error": function(data) {
        	result.code = -1;
        	result.result = "网络错误，请稍后重试！";
        }
	} );
	
	return result;
}

function getVariables() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	
	var operStatus = $("#operStatus").val(); 
	var form = {
			"node": getNodeInfo(),
			"approver": $("#approver").val(),
			"comment": operStatus != "提交" ? $("#comment").val() : "",
			"approveResult": "",
			"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
	};
	form["approveResult"] = nodeOnOper[operStatus];
	commentList.push(form);
	
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = 
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" || operStatus == "结束流程" ? true : false;
	
	return variables;
}


function updateBargin(){
	 
	var id =$("#barginManageId").val(); 
	
	var bargin = findBarginById(id);
		var actualPayMoney = $("#actualPayMoney").val();
		var invoiceMoney = $("#invoiceMoney").val();
		
		if(isNull(actualPayMoney) || typeof (actualPayMoney) == 'undefined'){
			actualPayMoney = $("#applyMoney").val();
		}
		
		var unpayMoney = digitTool.subtract(bargin.unpayMoney,actualPayMoney);
		var payMoney = digitTool.add(bargin.payMoney,actualPayMoney);
		
		if(isNull(invoiceMoney) || typeof invoiceMoney == "undefined"){
			var payUnreceivedInvoice = bargin.payUnreceivedInvoice;
			var payReceivedInvoice = bargin.payReceivedInvoice;
		}else{
			var payUnreceivedInvoice = digitTool.subtract(bargin.payUnreceivedInvoice,invoiceMoney);
			var payReceivedInvoice = digitTool.add(bargin.payReceivedInvoice,invoiceMoney);
		}
	    
	   updateBarginInfo(id,unpayMoney,payMoney,payUnreceivedInvoice,payReceivedInvoice);
	
}

function updateBarginInfo(id,unpayMoney,payMoney,payUnreceivedInvoice,payReceivedInvoice){
	var json =  {"id":id,
        	"unpayMoney":unpayMoney,
        	"payMoney":payMoney,
        	"payUnreceivedInvoice":payUnreceivedInvoice,
        	"payReceivedInvoice":payReceivedInvoice};
	
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/sale/barginManage/updateBarginInfo",
        "dataType": "json",
        "contentType": "application/json;charset=UTF-8",
        "data":JSON.stringify(json),
	        "success": function(data) {   
	        	if(data != null && data.code != 1) {
	        		bootstrapAlert("提示", "操作失败！", 400, null);
	        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}


function findBarginById(id){
	var barginResult = {};
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/sale/barginManage/findById",    
        "dataType": "json",
        "data": {"id": id},
        "async": false,
        "success": function(data) {
        	barginResult["unpayMoney"] = data.result.unpayMoney;
        	barginResult["payMoney"] = data.result.payMoney;
        	barginResult["payUnreceivedInvoice"] = data.result.payUnreceivedInvoice;
        	barginResult["payReceivedInvoice"] = data.result.payReceivedInvoice;
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	return barginResult;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
	var currStatus = $("#currStatus").val();
	if(isNull(currStatus) || $("#operStatus").val() == "重新申请" || $("#operStatus").val() == "取消申请") {
		currStatus = "0";
	}
	
	return nodeOnStatus[currStatus];
}

//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

//删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/finance/pay/deleteAttach",
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
		"path": "pay/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
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
        		
        		var formData = getFormData();
        		submitForm(formData);
        		
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}



/*
 * 初始化相关操作
 */
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	for(var i=commentList.length-1;i>=0;i--){
		var html = [];
		html.push("<li class='clearfix'>");
		html.push("<div class='col-xs-12'>");
        html.push("<div class='mFormMsg'>");
		html.push("<div class='mFormToggle'>")
        html.push("<div class='mFormToggleConn'>")
        html.push("<div class='mFormXSToggleConn'>")
		html.push("<div class='mFormXSName'>环节</div>")
		html.push("<div class='mFormXSMsg'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].node+"' disabled>")
		html.push("</div>")
		html.push("</div>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName'>操作人</div>")
        html.push("<div class='mFormXSMsg'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].approver+"' disabled>")
        html.push("</div>");
		html.push("</div>");
		html.push("</div>")
        html.push("<div class='mFormToggleConn'>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName'>操作时间</div>")
        html.push("<div class='mFormXSMsg'>")
        var approveDate = commentList[i].approveDate + "";
        if( !dateRep.test(approveDate) ) {
            approveDate = new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm");
            html.push("<input type='text' class='longInput' value='"+approveDate+"' disabled>")
        }else{
            approveDate = new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm")
            html.push("<input type='text' class='longInput' value='"+approveDate+"' disabled>")
        }
        html.push("</div>")
        html.push("</div>")
        html.push("<div class='mFormXSToggleConn'>")
		html.push("<div class='mFormXSName'>操作结果</div>")
        html.push("<div class='mFormXSMsg'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].approveResult+"' disabled>")
        html.push("</div>");
        html.push("</div>");
        html.push("</div>");
        html.push("<div class='mFormToggleConn'>");
        html.push("<div class='mFormXSToggleConn'>");
        html.push("<div class='mFormXSName'>操作备注</div>");
        html.push("<div class='mFormXSMsg'>");
        html.push("<input type='text' class='longInput' value='"+commentList[i].comment+"' disabled>");
        html.push("</div>");
        html.push("</div>");
        html.push("</div>");
		html.push("</div>");
        html.push("</div>");
        html.push("</div>");
		html.push("</li>")
		$("#mForm").append(html.join(""));
		}
}
function initDatetimepicker(){
	
	$("input[name='actualPayDate']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
	    pickDate: true,
	    pickTime: false,
	    bootcssVer:3,
	    autoclose: true,
	});
}

function initInputMask() {
	$("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#actualPayMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#bankAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
}

function initInputBlur(){
	var totalMoney = $("#totalMoney").val();
	var applyMoney = $("#applyMoney").val();
	if(!isNull(totalMoney) && parseInt(totalMoney)> 0 && !isNull(applyMoney) && parseInt(applyMoney) > 0){
		$("#applyProportion").val((digitTool.divide(applyMoney,totalMoney)* 100).toFixed(2)+ "%");
	}else{
		$("#applyProportion").val("");
	}
}

function changeImage(obj){
	$(obj).find(".mFormArr").toggleClass("current")
}
