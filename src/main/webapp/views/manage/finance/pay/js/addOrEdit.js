$(function() {
	if($("#id").val() == null || $("#id").val() == ""){
		$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	}
	
	
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	$("#projectDialog").initProjectDialog({
		"callBack": getProjectData
	});
	
	if($("#barginManageId").val() != null && $("#barginManageId").val() != ""){
		$("#viewBarginBtn").show();
	}
	
	if($("#barginTotalMoney").val() > 0){
			$("#totalMoney").attr("readonly","readonly");
	}else{
		 document.getElementById("totalMoney").removeAttribute("readOnly");
	}
	

	initInputMask();
	initInputBlur();
	initFileUpload();
	initInvoiceMoney();
	var barginManageId =$("#barginManageId").val(); 
	if( barginManageId != null &&  barginManageId != ""){
		//查看合同按钮是否显示，原来没有审核的合同不显示
		viewBarginBtnShow(barginManageId);
	}
	
	
});

function viewBarginBtnShow(id){
	
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/sale/barginManage/findById",    
        "dataType": "json",
        "data": {"id": id},
        "success": function(data) {
        	var processInstanceId = data.result.processInstanceId;
        	if(!isNull(processInstanceId) && typeof processInstanceId != "undefined" && data.result.status == '5'){
        		$("#viewBarginBtn").show();
        	}else{
        		document.getElementById("viewBarginBtn").style.display = "none";
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	
}
function openBargin() {
	$("#barginDialog").openBarginDialog();
}

var payUnreceivedInvoice = 0;
function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		
		$("#barginManageId").val("");
		$("#barginProcessInstanceId").val("");
		$("#barginCode").val("");
		$("#barginName").val("");
		$("#totalMoney").val("");
		$("#projectManageName").val("");
		$("#projectManageId").val("");
		
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
		
		if($("#totalMoney").val() > 0){
			$("#totalMoney").attr("readonly","readonly");
		}else{
			 document.getElementById("totalMoney").removeAttribute("readOnly");
		}
		
	}
}


//查看合同详情
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	
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


function openProject(){
	$("#projectDialog").openProjectDialog();
}


function getProjectData(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#projectManageName").val(data.name);
		$("#projectManageId").val(data.id);
	}
}


function change(obj){
	
	if($(obj).val() == '1'){
		
		$("#invoice").show();
		$("#money").show();
		initInputMask();
	}else if($(obj).val() == '0' || $(obj).val() == ''){
		$("#invoice").hide();
		$("#money").hide();
	}
}

function initInvoiceMoney(){
	if($("#invoiceCollect").val() == "1"){
		$("#invoice").show();
		$("#money").show();
		initInputMask();
	}
}

//保存信息
function save(){
	var formData = getFormData();
	var issubmit = $("#issubmit").val("0");//区分保存和提交
	
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
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





function submitInfo() {
	
	var formData = getFormData();
	var issubmit = $("#issubmit").val("1");
	
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	if(fileData != null) { // 已选择文件，则先上传文件
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submit(formData);
	}		
}


function submit(formData){
	$.ajax({
		url: "submit",
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


function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  invoiceCollect = $.trim($("#invoiceCollect").val());
	var applyMoney = $("#applyMoney").val();
	var invoiceMoney = $("#invoiceMoney").val();
	
	var collectCompany = $("#collectCompany").val();
	var bankAddress = $("#bankAddress").val();
	var bankAccount = $("#bankAccount").val();
  	var projectManageId =$("#projectManageId").val();
	var reimburseType=$("#reimburseType").val();

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
	
	}else if(isNull(reimburseType)){
		text.push("请选择费用类型！");
	
	}else if(isNull(projectManageId)){
        text.push("请关联所属项目！");

    }
	
	if(!isNull(invoiceCollect) && invoiceCollect == '1' && isNull(invoiceMoney)){
		text.push("请填写发票金额！");
	
	}

	
	/*if(!isNull(applyMoney) && !isNull(unpayMoney) && typeof (unpayMoney) != 'undefined'){
		if(digitTool.subtract(applyMoney , unpayMoney) > 0){
			$("#applyMoney").val(unpayMoney);
			$("#applyProportion").val("");
			text.push("申请金额不能大于未付款金额！");
		}
	}*/
	
	return text;
}

function del() {
	var formData = getFormData();
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",
	        "contentType": "application/json;charset=UTF-8",
	        "data": JSON.stringify(formData),
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		backPageAndRefresh();
	        	} else {
	        		bootstrapAlert("提示", "删除出错", 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
	
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


/*
 * 初始化相关操作
 *初始化金额，两位数
 */
function initInputMask() {
	
		$("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
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


