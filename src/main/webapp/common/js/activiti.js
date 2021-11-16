/**
 * 
 * 封装流程处理函数
 * 
 */

// 完成任务
function completeTask(taskId, variables) {
	var result = {};
	var params = {
			"taskId": taskId,
			"variables": variables
	};
	$.ajax({   
        "type": "POST",    
        "url": web_ctx + "/activiti/completeTask",   
        "contentType": "application/json",
        "data": JSON.stringify(params),
        "async": false,
        "dataType": "json",
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result.code = 0;
        	result.result = data;
        }
	});
	
	return result;
}

// 删除流程实例
function deleteProcessInstance(processInstanceId) {
	var result = null;
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/deleteProcessInstance",    
        "dataType": "json",
        "data": {"processInstanceId":processInstanceId},
        "async": false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result = {"code": -1, "result": "网络错误，请稍后重试！" };
        }
	} );
	
	return result;
}

// 结束流程实例
function endProcessInstance(taskId, variables) {
	var result = null;
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/endProcessInstance",    
        "dataType": "json",
        "contentType": "application/json;charset=UTF-8",
        "data": JSON.stringify({"taskId": taskId, "variables": variables}),
        "async": false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result = {"code": -1, "result": "网络错误，请稍后重试！" };
        }
	} );
	
	return result;
}

// 结束并行的流程实例
function endProcessOfParallel(processInstanceId, variables) {
	var result = null;
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/endProcessOfParallel",    
        "dataType": "json",
        "contentType": "application/json;charset=UTF-8",
        "data": JSON.stringify({"processInstanceId":processInstanceId, "variables": variables}),
        "async": false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result = {"code": -1, "result": "网络错误，请稍后重试！" };
        }
	} );
	
	return result;
}

function backProcessForParallel(taskId, applyTask, variables) {
	var result = null;
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/backProcessForParallel",    
        "dataType": "json",
        "contentType": "application/json;charset=UTF-8",
        "data": JSON.stringify({"taskId":taskId, "applyTask": applyTask, "variables": variables}),
        "async": false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result = {"code": -1, "result": "网络错误，请稍后重试！" };
        }
	} );
	
	return result;
}

function findTask(processInstanceId) {
	var result = {};
	var params = {
			"processInstanceId": processInstanceId
	};
	$.ajax({   
        "type": "POST",    
        "url": web_ctx + "/activiti/getTask",   
        "contentType": "application/json",
        "data": JSON.stringify(params),
        "async": false,
        "dataType": "json",
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result.code = 0;
        	result.result = data;
        }
	});
	return result;
}

function processState(processInstanceId) {
	var result = {};
	var params = {
			"processInstanceId": processInstanceId
	};
	$.ajax({   
        "type": "POST",    
        "url": web_ctx + "/activiti/processState",   
        "contentType": "application/json",
        "data": JSON.stringify(params),
        "async": false,
        "dataType": "json",
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	result.code = 0;
        	result.result = data;
        }
	});
	return result;
}

function getTaskNext(taskId) {
	var result = {};
	$.ajax({
		"type" : "POST",
		//		"url" : web_ctx + "/activiti/getTaskNext",
		"url" : web_ctx + "/manage/finance/pay/getTaskNext",
		"dataType" : "json",
		"async" : false,
		"data" : {
			"taskId" : taskId
		},
		"success" : function(data) {
			result = data;
		},
		"error" : function(data) {
			result.code = -1;
			result.result = "网络错误，请稍后重试！";
		}
	});
	return result;
}

function validate(){
	var taskId = $("#taskId").val();
	var operStatus = $("#operStatus").val();
	//判断是否选择 同意，如果是同意则验证下一步流程是否是自身，如是，则直接同意
	if(operStatus == "同意" || operStatus == "重新申请"){
		var result = getTaskNext(taskId);
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}
		if(result.code == 1){
			operStatus = "同意";
			var form = {
					"node" : result.result.name,
					"approver" : $("#approver").val(),
					"comment" : "系统自动审批",
					"approveResult" : "",
					"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
				};
				form["approveResult"] = nodeOnOper[operStatus];
				commentList.push(form);
				variables["commentList"] = commentList; // 批注列表
				variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
						|| operStatus == "提交" || operStatus == "结束流程" ? true : false;
				compResult = completeTask(result.result.id, variables);	
				var currStatus = $("#currStatus").val();
				var	status = approvedStatus[currStatus];
				setStatus(status);
		} else if(result.code == -1){
			bootstrapAlert("提示", result.result, 400, null);
		}
	}
}

function validate2(){
	var taskId = $("#taskId").val();
	var operStatus = $("#operStatus").val();
	//判断是否选择 同意，如果是同意则验证下一步流程是否是自身，如是，则直接同意
	if(operStatus == "同意"){
		var result = getTaskNext(taskId);
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}
		if(result.code == 1){
			var form = {
					"node" : result.result.name,
					"approver" : $("#approver").val(),
					"comment" : "系统自动审批",
					"approveResult" : "",
					"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
				};
				form["approveResult"] = nodeOnOper[operStatus];
				commentList.push(form);
				variables["commentList"] = commentList; // 批注列表
				variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
						|| operStatus == "提交" || operStatus == "结束流程" ? true : false;
				compResult = completeTask(result.result.id, variables);	
				var currStatus = $("#currStatus").val();
				var	status = approvedStatus[currStatus];
				setStatus(status);
		} else if(result.code == -1){
			bootstrapAlert("提示", result.result, 400, null);
		}
	}
}

function validate3(){
	var taskId = $("#taskId").val();
	var operStatus = $("#operStatus").val();
	//判断是否选择 同意，如果是同意则验证下一步流程是否是自身，如是，则直接同意
	if(operStatus == "重新申请"){
		var result = getTaskNext(taskId);
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}
		if(result.code == 1){
			operStatus = "同意";
			var form = {
					"node" : result.result.name,
					"approver" : $("#approver").val(),
					"comment" : "系统自动审批",
					"approveResult" : "",
					"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
				};
				form["approveResult"] = nodeOnOper[operStatus];
				commentList.push(form);
				variables["commentList"] = commentList; // 批注列表
				variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
						|| operStatus == "提交" || operStatus == "结束流程" ? true : false;
				compResult = completeTask(result.result.id, variables);
				var status = getNextStatus();
				setStatus(status);
		} else if(result.code == -1){
			bootstrapAlert("提示", result.result, 400, null);
		}
	}
}

function validate4(){
	var taskId = $("#taskId").val();
	var operStatus = $("#operStatus").val();
	//判断是否选择 同意，如果是同意则验证下一步流程是否是自身，如是，则直接同意
	if(operStatus == "同意" || operStatus == "重新申请"){
		var result = getTaskNext(taskId);
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}
		if(result.code == 1){
			operStatus = "同意";
			var form = {
					"node" : result.result.name,
					"approver" : $("#approver").val(),
					"comment" : "系统自动审批",
					"approveResult" : "",
					"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
				};
				form["approveResult"] = nodeOnOper[operStatus];
				commentList.push(form);
				variables["commentList"] = commentList; // 批注列表
				variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
						|| operStatus == "提交" || operStatus == "结束流程" ? true : false;
				compResult = completeTask(result.result.id, variables);	
		} else if(result.code == -1){
			bootstrapAlert("提示", result.result, 400, null);
		}
	}
}

function validate5(){
	var taskId = $("#taskId").val();
	var operStatus = $("#operStatus").val();
	//判断是否选择 同意，如果是同意则验证下一步流程是否是自身，如是，则直接同意
	if(operStatus == "同意" || operStatus == "重新申请"){
		var result = getTaskNext(taskId);
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}
		if(result.code == 1){
			operStatus = "同意";
			var form = {
					"node" : result.result.name,
					"approver" : $("#approver").val(),
					"comment" : "系统自动审批",
					"approveResult" : "",
					"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
				};
				form["approveResult"] = nodeOnOper[operStatus];
				commentList.push(form);
				variables["commentList"] = commentList; // 批注列表
				variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
						|| operStatus == "提交" || operStatus == "结束流程" ? true : false;
				compResult = completeTask(result.result.id, variables);	
				var currStatus = $("#currStatus").val();
				var date1 = $("#createDateStr").val() ;
		    	var date2 = '2019-08-22 18:40:00';
		    	var	status = 0;
		    	if(currStatus == 1) {
		    		if(new Date(date1).getTime() < new Date(date2).getTime()) {
		    			status = 2;
		        	}else {
		        		if($("#isOk").val() == "true") {
		        			status = 13;
		        		}else {
		        			status = 2;
		        		}
		        	}
		    	}else{
		    		status = approvedStatus[currStatus];
		    	}
		    	setStatus(status);
		} else if(result.code == -1){
			bootstrapAlert("提示", result.result, 400, null);
		}
	}
}