$(function() {
	var currUserId =$("#currUserId").val();
	var userId =$("#userId").val();
	var status =$("#status").val();
	
	if($("#id").val() == null || $("#id").val() == ""){
		$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	}
	
	if($("#id").val() != null && currUserId == userId && status == '5'){
		$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	}
	
	
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	
	inittextarea();
	initInputMask();
	initFileUpload();
	initDatetimepicker();

	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/getParentDeptName",
		type: "post",
		data: {principalDeptId:$("#userDeptId").val()},
		dataType: "json",
		async:false,
		success: function(data) {
			if(data != null) {
				$("#dutyDept").val(data.name);
				$("#dutyDept").show();
			}
		}
	})

	var barginTypeIdValue = $("#barginTypeId").val();
	if(!isNull(barginTypeIdValue) && barginTypeIdValue == 'S'){
		$("#tr1").show();
	}
});
$(document).ready(function (){
//	if($("#isNewProject").val() == '1'){
//		$("#barginType option[value='L']").remove();
//		$("#barginType option[value='E']").remove();
//	}
});
//获取项目名称
var projectObj = "";
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function barginByType() {
	var value = $("#barginType option:selected").val();
	if(value == "S") {
		$("#tr1").show();
	}else {
		$("#tr1").hide();
	}
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$("#projectManageId").val(data.id);
		$(projectObj).val(data.name);
	}
}


//保存信息
function save(){
	//bootstrapConfirm("提示", "是否确定保存？", 300, function() {
		var formData = getFormData();
		var issubmit = $("#issubmit").val("0");//区分保存和提交
		
		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		ajaxBarginName(formData);
	//})
}

function ajaxBarginName (formData){
	$.ajax({
		url: "findByBarginName",//合同名称不能重复
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data:  JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#barginName").val("");
				bootstrapAlert("提示", data.result, 400, null);
			}else{
				openBootstrapShade(true);
				if(fileData != null) { // 已选择文件，则先上传文件
					fileData.submit();
				} else {
					openBootstrapShade(true);
					saveInfo(formData);
				}
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
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
	bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		var formData = getFormData();
		var issubmit = $("#issubmit").val("1");
		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		
		$.ajax({
			url: "findByBarginName",//合同名称不能重复
			type: "post",
			contentType: "application/json;charset=UTF-8",
			data:  JSON.stringify(formData),
			dataType: "json",
			success: function(data) {
				if(data.code == 1) {
					$("#barginName").val("");
					bootstrapAlert("提示", data.result, 400, null);
				}else{
					if(fileData != null) { // 已选择文件，则先上传文件
						openBootstrapShade(true);
						fileData.submit();
					} else {
						openBootstrapShade(true);
						submit(formData);
					}
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	})
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
	var  barginName = $.trim($("#barginName").val());
	var barginType = $("#barginType").val();
	
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	
	var projectManageName = $("#projectManageName").val();
	if(isNull(barginName)) {
		text.push("请填写合同名称！");
		
	}else if(isNull(barginType)){
	
		text.push("请填写合同类型！");
	
	}else if(isNull(projectManageName)){
	
		text.push("请填写所属项目！");
	
	}
	
	if(!isNull(startTime) && !isNull(endTime) && startTime >= endTime) {
		text.push("合同期限开始时间不能大于或等于结束时间！<br/>");
	}
	return text;
}


function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
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


//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "bargin/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 100 * 1024 * 1024, // 100 MB
        messages: {
        	maxFileSize: '附件大小最大为100M！'
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


//删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/sale/barginManage/deleteAttach",
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
		bootstrapAlert("提示", "附件未保存，提交保存后方可删除附件！", 400, null);
	}
}


/*
 * 初始化相关操作
 */
function initDatetimepicker() {
	$("input[name='startTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("input[name='endTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}

//初始化金额，两位数
function initInputMask() {
	
		$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#receivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#unreceivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#channelExpense").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
}


