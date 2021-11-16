/******************************
 * 		全局变量			  	  *
 ******************************/
var fileData = null;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交": save,
	"同意": agree,
	"退回": disagree,
	"不同意": disagree,
	"重新申请": reApply,
	"取消申请": cancelApply,
};


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：总经理审批 3 财务审批 4：已归档 5：取消申请6：部门经理不同意 7：总经理不同意 8:出纳退回
 * */
//同意后的下一状态
var approvedStatus = {
	"0": "1",
	"1": "2",
	"2": "3",
	"3": "4",
};

// 不同意后的下一状态
var notApprovedStatus = {
	"0": "5",
	"1": "6",
	"2": "7",
	"3": "8",
};

// 环节与状态的映射
var nodeOnStatus = {
	"0": "提交申请",
	"1": "部门经理",
	"2": "总经理",
	"3": "出纳",
	"4": "已归档",
	"5": "取消申请",
	"6": "提交申请",
	"7": "提交申请",
	"8": "提交申请",
};

// 环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "通过",
	"不同意": "不通过",
	"退回": "退回",
	"取消申请": "取消申请",
};


$(function() {
	initTaskComment();
	initFileUpload();
});


/******************************
 * 		流程处理相关函数		  	  *
 ******************************/
function approve(status) {
	$("#operStatus").val(status);
	oper2Method[status].call();
}

function agree() {
	submitProcess();
}

function disagree() {
	submitProcess();
}

function reApply() {
	save();
}

function cancelApply() {
	cancelProcess();
}


function submitProcess() {
	bootstrapConfirm("提示", "是否确定操作？", 300, function() {
		var variables = getVariables();
		var taskId = $("#taskId").val();
		var compResult = completeTask(taskId, variables);
		
		if(compResult.code == 1) {
			var status = getNextStatus();
			var statusResult = setStatus(status);
			$("#currStatus").val(status)
			if(statusResult.code == 1) {
				var text = "操作成功！";
	    		if($("#operStatus").val() == "提交") {
	    			text = "提交成功 ！";
	    		} else if($("#operStatus").val() == "重新申请") {
	    			text = "重新申请成功 ！";
	    		} else if($("#operStatus").val() == "取消申请") {
	    			text = "取消申请成功 ！";
	    		}

	    		if($("#operStatus").val()=="不同意"){
	                sendMail();
				}
	    		window.parent.initTodo();
	    		backPageAndRefresh();
	    	} else {
	    		bootstrapAlert("提示", statusResult.result, 400, null);
	    	}
		} else if(compResult.code == 0) {
			bootstrapAlert("提示", compResult.result.statusText, 400, null);
		} else {
			bootstrapAlert("提示", compResult.result.toString(), 400, null);
		}
		validate();
		openBootstrapShade(false);
	},null);
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
	variables["commentList"];
	variables["approved"] = 
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" ? true : false;
	
	return variables;
}

/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：总经理审批 3 财务审批 4：已归档 5：取消申请6：部门经理不同意 7：总经理不同意
 * */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	if($("#operStatus").val() == "同意") {
			status = approvedStatus[currStatus];
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	}else if($("#operStatus").val() == "退回") {
		status = notApprovedStatus[currStatus];
	} else {
		status = "1";
	}
	return status;
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

//查看流程图
function viewProcess(processInstanceId) {
	var url = web_ctx+"/activiti/getImgByProcessInstancdId?processInstanceId="+processInstanceId;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("client_type", "DESKTOP_WEB");
    xhr.onload = function() {
        if (this.status == 200) {
            var blob = this.response;
            var img = document.createElement("img");
            $(img).width("100%");
            img.onload = function(e) {
                window.URL.revokeObjectURL(img.src); 
            };
            img.src = window.URL.createObjectURL(blob);
            $("#imgcontainer").html(img);
            $("#imgModal").modal("show");
        } else if(this.status == 500) {
        	bootstrapAlert("提示", this.statusText, 400, null);
        }
    }
    xhr.send();
}

// 取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if(result != null) {
			if(result.code == 1) {
				var statusResult = setStatus("5");
				if(statusResult.code == 1) {
						window.parent.initTodo();
						backPageAndRefresh();
				} else {
					bootstrapAlert("提示", statusResult.result, 400, null);
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}

/**
 * 当流程处理人打回申请时，给申请人发送邮件
 */
function sendMail() {
    var result = {};
    $.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/ad/seal/sendMail",
        "dataType": "json",
        "data": {
            id:$("#id").val(),
            comment:$("#comment").val(),
        },
        "success":function (data) {
            result.result = "发送成功！";
        },
        "error":function (data) {
            result.code = -1;
            result.result = "网络错误，请稍后重试！";
        }
    });
    return result;
}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/ad/seal/setStatus",    
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

function setTaskVariables() {
	var taskId = $("#taskId").val();
	var variables = getVariables();
	variables["taskId"] = taskId;
	
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/setTaskVariables",
        "contentType": "application/json",
        "dataType": "json",
        "async": false,
        "data": JSON.stringify(variables),
        "success": function(data) {},
        "error": function(data) {}
	} );
}


/******************************
 * 		表单处理相关函数		  	  *
 ******************************/
function save() {
	var formData = $("#form1").serializeJson();
	if(!checkForm(formData)) {
		return ;
	}
	openBootstrapShade(true);
	if(fileData != null) {
		fileData.submit();
	} else {
		submitForm(formData);
	}
	openBootstrapShade(false);
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/ad/seal/update",
		type: "post",
		data: formData,
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				if($("#operStatus").val() == "重新申请") {
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

function checkForm(formData) {
	var text = [];
	if(isNull(formData["reason"])) {
		text.push("用章事由不能为空！<br/>");
	}
	
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

function resetForm() {
	fileData = null;
}


/******************************
 * 		初始化相关函数		  	  *
 ******************************/


//文件上传
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "seal/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 3 MB
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
        		
        		var formData = $("#form1").serializeJson();
        		submitForm(formData);
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

/*	$(commentList).each(function(index, comment) {
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		if(comment.node == "出纳"){
			html.push("执行");
		}
		else{
			html.push(comment.node);
		}
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approver);
		html.push("</td>");
		html.push("<td>");
		
		var approveDate = comment.approveDate + "";
		if( !dateRep.test(approveDate) ) {
			html.push(new Date(comment.approveDate).pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
		}
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approveResult);
		html.push("</td>");
		html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(comment.comment) ? "" : comment.comment);
		html.push("</td>");
		
		$("#table2").find("tbody").append(html.join(""));
	});*/
	
	for(var i=commentList.length-1;i>=0;i--){
		var html = [];
        if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
            browser.versions.iPhone || browser.versions.iPad){
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
		else{
			html.push("<tr>");
			html.push("<td>");
			html.push(commentList[i].node);
			html.push("</td>");
			html.push("<td>");
			html.push(commentList[i].approver);
			html.push("</td>");
			html.push("<td>");
			var approveDate = commentList[i].approveDate + "";
			if( !dateRep.test(approveDate) ) {
				html.push(new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm"));
			} else {
				html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
			}
			html.push("</td>");
			html.push("<td>");
			html.push(commentList[i].approveResult);
			html.push("</td>");
			html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
			html.push(isNull(commentList[i].comment) ? "" : commentList[i].comment);
			html.push("</td>");
			$("#table2").find("tbody").append(html.join(""));
        }
	}
}


function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}