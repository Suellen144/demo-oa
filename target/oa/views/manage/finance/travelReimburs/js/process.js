/*******************************************************************************
 * 全局变量 *
 ******************************************************************************/
var fileData = null; // 选择文件后的文件数据变量
var urlParam = ""; // 文件上传URL参数
var projectObj = null; // 选择项目后的对象
var investList = [];

var type2html = { // 新增节点时，根据类型获取生成HTML的函数
    "intercityCost": getHtmlForIntercityCost,
    "stayCost": getHtmlForStayCost,
    "cityCost": getHtmlForCityCost,
    "receiveCost": getHtmlForReceiveCost,
    "subsidy": getHtmlForSubsidy,
    "business": getHtmlForBusiness,
    "relationship": getHtmlForRelationship
};
var type2value = { // 每个大类节点对应的类型代码
    "intercityCost": "0",
    "stayCost": "1",
    "cityCost": "2",
    "receiveCost": "3",
    "subsidy": "4",
    "business": "5",
    "relationship": "6"
};
var validElements = { // 不同大类节点所需验证的表单元素
    "0": {
        "date": 0,
        "startPoint": 0,
        "destination": 0,
        "projectId": 0,
        // "cost": 0,
        // "actReimburse": 0,
        "reason": 0,
        "costWithAct": 0
    },
    "1": {
        "date": 0,
        "place": 0,
        "projectId": 0,
        // "cost": 0,
        // "actReimburse": 0,
        "reason": 0,
        "costWithAct": 0
    },
    "2": {
        "date": 0,
        "place": 0,
        "projectId": 0,
        // "cost": 0,
        // "actReimburse": 0,
        "reason": 0,
        "costWithAct": 0
    },
    "3": {
        "date": 0,
        "place": 0,
        "projectId": 0,
        // "cost": 0,
        // "actReimburse": 0
        "costWithAct": 0
    },
    "4": {
        "beginDate": 0,
        "endDate": 0,
        "foodSubsidy": 0,
        "trafficSubsidy": 0,
        "reason": 0,
        "projectId": 0
    },
    "5": {
        "date": 0,
        "place": 0,
        "projectId": 0,
        //"cost": 0,
//		"actReimburse": 0
        "reason": 0,
        "costWithAct": 0
    },
    "6": {
        "date": 0,
        "place": 0,
        "projectId": 0,
        //"cost": 0,
//		"actReimburse": 0
        "reason": 0,
        "costWithAct": 0
    }
};
var validElementsZh = { // 验证的表单元素对应的中文名
    "date": "日期",
    "place": "地点",
    "startPoint": "出发地",
    "destination": "目的地",
    "projectId": "项目",
    "cost": "费用",
    "actReimburse": "实报",
    "beginDate": "出发日期",
    "endDate": "离开日期",
    "foodSubsidy": "餐费补贴",
    "trafficSubsidy": "交通补贴",
    "reason": "事由",
    "costWithAct": "费用与实报"
};

/*
 * 审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理不同意
 * 9：经办不同意 10：复核不同意 11：总经理不同意 12：出纳不同意,13:总助审批,14:总助不同意
 */
// 同意后的下一状态
var approvedStatus = {
    "0": "1",
    "1": "13",
    "2": "3",
    "3": "4",
    "4": "5",
    "5": "6",
    "11": "4",
    "13" : "2"
};
// 不同意后的下一状态
var notApprovedStatus = {
    "0": "7",
    "1": "8",
    "2": "9",
    "3": "10",
    "4": "11",
    "5": "12",
    "11": "10", // 总经理不同意后流程到达复核人，所以 11 与 3 等同看待
    "13":"14"
};
// 环节与状态的映射
var nodeOnStatus = {
    "0": "提交申请",
    "1": "部门经理",
    "2": "经办",
    "3": "复核",
    "4": "总经理",
    "5": "出纳",
    "6": "审批通过",
    "7": "取消申请",
    "8": "提交申请",
    "9": "提交申请",
    "10": "提交申请",
    "11": "复核",
    "12": "提交申请",
    "13": "总经理助理",
    "14": "提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
    "提交": "提交成功",
    "重新申请": "申请成功",
    "同意": "通过",
    "不同意": "不通过",
    "取消申请": "取消申请"
};

$(function () {
    var assistantStatus = $("#assistantStatus").val();
    if (ishavatrafficSubsidy.length > 0) {
        $(".trafficSubsidy").show();
    }
    if (ishavatrafficTool.length > 0) {
        $(".trafficT").show();
    }
    if ("resubmit" == submitPhase || "othersubmit" == submitPhase) {
        if ("resubmit" == submitPhase && assistantStatus != '1') {
            initNode();
            hidenone();
        }
        initDialog();
        initDatetimepicker();
        initInputMask();
        /*initFileUpload();*/
        initBrowserInfo();
    }
    initFileUpload();
    initDecryption();
    hidecollapse();
    initInvest();
    initInputKeyUp();
    initTaskComment();
    initSubTotal();
    initcollapse();
    inittextarea();
    initTravel();
    if ($("#travelId").val() != "") {
        $("#viewTravelBtn").show();
    }

    updatereimbursetotal();
    if (!isNull(assistantStatus) && assistantStatus == '1') {
        $("#submitBtn").hide();
    }
    
    $("#travelDialog").initTravelDialog({
		"callBack": getTravel,
		"isCheck": true
	});
    if($("#business").find("tr[name='node']").length>0){
    	validationRed("business");
    }
    if($("#relationship").find("tr[name='node']").length>0){
    	validationRed("relationship");
    }

    
});

function initTravel() {
    var travelId = $("#travelId").val();
    if (!isNull(travelId)) {
        $
            .ajax({
                "type": "get",
                "url": web_ctx
                + "/manage/finance/travelReimburs/getTravelProcessInstanceIds",
                "dataType": "json",
                "data": {
                    "ids": travelId
                },
                "success": function (data) {
                    if (data.code == 1) {
                        var html = [];
                        var travelProcessInstanceIds = data.result;
                        $("#travelProcessInstanceIds").val(
                            travelProcessInstanceIds);

                        for (var i = 0; i < travelProcessInstanceIds.length; i++) {
                            var num = i + 1;
                            html
                                .push('<input type="button"  name="detail"  style="margin-left:6px"  value="查看出差明细（'
                                    + num
                                    + '）" onclick="viewTravel('
                                    + travelProcessInstanceIds[i]
                                    + ')" style="border:none;">');
                        }
                        $("#selectTravel").html(html.join(""));
                    } else {
                        bootstrapAlert("提示", data.result, 400, null);
                    }
                },
                "error": function (data) {
                    bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                }
            });
    }
}

function getTravelname() {
    var name = $("#name").val();
    return name;
}

function getTravelID() {
	var temp = $("#travelId").val()
	if (temp != "" && temp != null) {
		return temp;
	}
}

function showhelp() {
    $("#helpModal").modal("show");
}

function getStatusById(){
	var result = "";
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/manage/finance/travelReimburs/getStatusById",    
        "dataType": "json",
        "data": {"id": $("#id").val()},       
        "async" : false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	return result;
}

/*******************************************************************************
 * 流程处理相关函数 *
 ******************************************************************************/
function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var processInstanceId = $("#processInstanceId").val();
	var data1 = findTask(processInstanceId);
	var userTask = data1.result[0].task.name;
	console.log("当前任务处理人：" + data1.result[0].task.name)
	var status = getNextStatus();
	console.log("当前任务的下一状态：" + status)
	var compResult = completeTask(taskId, variablesTemp);
	if (compResult.code == 1) {
		var status = getNextStatus();
		$("#currStatus").val(status)
	    var id = $("#id").val();
	    setStatus(status);
	  /*  $.ajax({
	    	"type": "POST",
	        "url": web_ctx + "/manage/finance/travelReimburs/setStatus",
	        "dataType": "json",
	        "data": {
	        	"id": $("#id").val(),
	            "status": status
	        },
	        "success": function (data) {
	        	var text = "操作成功！";
	            if (statusFlag == "3") {
	            	sendMail();
	            }
	            if ($("#operStatus").val() == "提交") {
	            	text = "提交成功 ！";
	            } else if ($("#operStatus").val() == "重新申请") {
	            	text = "重新申请成功 ！";
	            } else if ($("#operStatus").val() == "取消申请") {
	                text = "取消申请成功 ！";
	            }
	            window.parent.initTodo();
	        },
	        "error": function (data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });*/
	} else if (compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
	    bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
	/**
	 * 判断流程是否已结束
	 */
	var process = processState(processInstanceId);
	if(process.result.length > 0){
		console.log("流程执行中");
		var data2 = findTask(processInstanceId);
		var userTask2 = data2.result[0].task.name;
		console.log("任务处理人：" + data2.result[0].task.name);
		if(userTask != userTask2){
			console.log("任务已执行");
			/**
			 * 查询当前单的状态
			 */
			var resultTemp = getStatusById();
			if(resultTemp.status != status){
				console.log("任务已执行，但状态未修改");
				$.ajax({   
			        "type": "POST",    
			        "url": web_ctx+"/manage/finance/reimburs/setStatus",    
			        "dataType": "json",
			        "data": {"id": $("#id").val(), "status": status},
			        "success": function(data) { 
			        	var text = "操作成功！";
			        	if(statusFlag=="3"){
			        		sendMail();
			        	}
		        		if($("#operStatus").val() == "提交") {
		        			text = "提交成功 ！";
		        		} else if($("#operStatus").val() == "重新申请") {
		        			text = "重新申请成功 ！";	
		        		} else if($("#operStatus").val() == "取消申请") {
		        			text = "取消申请成功 ！";
		        		}
		        		
		        		window.parent.initTodo();
		        		backPageAndRefresh();
		        		bootstrapAlert("提示", text, 400, function() {
		        			backPageAndRefresh();
		        		});
			        },
			        "error": function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			        }
				});
			}
		}
	}else{
		var resultTemp = getStatusById();
		if(resultTemp.status != 6){
			console.log("流程已结束");
			$.ajax({   
		        "type": "POST",    
		        "url": web_ctx+"/manage/finance/reimburs/setStatus",    
		        "dataType": "json",
		        "data": {"id": $("#id").val(), "status": 6},
		        "success": function(data) { 
		        	var text = "操作成功！";
		        	if(statusFlag=="3"){
		        		sendMail();
		        	}
	        		
	        		window.parent.initTodo();
	        		backPageAndRefresh();
	        		bootstrapAlert("提示", text, 400, function() {
	        			backPageAndRefresh();
	        		});
		        },
		        "error": function(data) {
		        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
			});
		}
	}
	validate5();
	openBootstrapShade(false);
}

// 调用发送邮件的方法
function sendMail() {
    var contents = $("#comment").val();
    $.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/finance/travelReimburs/sendMail",
        "dataType": "json",
        "data": {
            "id": $("#id").val(),
            "contents": contents
        }
    });
}

// 助手不同意
function disagree() {
    bootstrapConfirm("提示", "是否确定？", 300, function () {
        var taskId = $("#taskId").val();
        $("#operStatus").val("不同意");
        variables["approved"] = false;
        var commentList = variables.commentList;
        if (isNull(commentList)) {
            commentList = [];
        }
        var form = {
            "node": '市场助手',
            "approver": $("#approver").val(),
            "comment": $("#comment").val(),
            "approveResult": "不同意",
            "approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
        };
        commentList.push(form);
        variables["commentList"] = commentList; // 批注列表
        variables["taskId"] = taskId;
        var compResult = completeTask(taskId, variables);
        if (compResult.code == 1) {
            var status = getNextStatus();
            var id = $("#id").val();
            setStatus(status);
        } else if (compResult.code == 0) {
            bootstrapAlert("提示", compResult.result.statusText, 400, null);
        } else {
            bootstrapAlert("提示", compResult.result.toString(), 400, null);
        }
    });
}

// 获取流程变量，对于流程走向有效果
function getVariables() {
    var commentList = variables.commentList;
    if (isNull(commentList)) {
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
    variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
    || operStatus == "提交" ? true : false;

    return variables;
}

/**
 * 获取流程下一审批状态 审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请
 * 8：部门经理不同意 9：经办不同意 10：复核不同意 11：总经理不同意 12：出纳不同意 13:总助审批,14:总助不同意
 */
function getNextStatus() {
    var status = null;
    var currStatus = $("#currStatus").val();
    if ($("#operStatus").val() == "同意") {
    	var date1 = $("#createDateStr").val() ;
    	var date2 = '2019-08-22 18:40:00';
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
    	}else {
    		status = approvedStatus[currStatus];
    	}
    } else if ($("#operStatus").val() == "不同意") {
        status = notApprovedStatus[currStatus];
    } else {
    	if($("#isOk").val() == "true") {
    		 status = "1";
    	}else {
    		 status = "13";
    	}
    }

    return status;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
    var currStatus = $("#currStatus").val();
    if (isNull(currStatus) || $("#operStatus").val() == "重新申请"
        || $("#operStatus").val() == "取消申请") {
        currStatus = "0";
    }

    return nodeOnStatus[currStatus];
}

// 查看流程图
function viewProcess(processInstanceId) {
    var url = web_ctx
        + "/activiti/getImgByProcessInstancdId?processInstanceId="
        + processInstanceId;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("client_type", "DESKTOP_WEB");
    xhr.onload = function () {
        if (this.status == 200) {
            var blob = this.response;
            var img = document.createElement("img");
            $(img).width("100%");
            img.onload = function (e) {
                window.URL.revokeObjectURL(img.src);
            };
            img.src = window.URL.createObjectURL(blob);
            $("#imgcontainer").html(img);
            $("#imgModal").modal("show");
        } else if (this.status == 500) {
            bootstrapAlert("提示", this.statusText, 400, null);
        }
    }
    xhr.send();
}

// 取消流程
function cancelProcess() {
    bootstrapConfirm("提示", "确定要取消申请吗？", 300, function () {
        var id = $("#id").val();
        var taskId = $("#taskId").val();
        var variables = getVariables();

        var result = endProcessInstance(taskId, variables);
        if (result != null) {
            if (result.code == 1) {
                setStatus(7);
            } else {
                bootstrapAlert("提示", result.result, 400, null);
            }
        }
    }, null);
}

function setStatus(status) {
    var id=$("#id").val();
    $.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/finance/travelReimburs/setStatus",
        "dataType": "json",
        "data": {
            "id": id,
            "status": status,
        },
        "success": function (data) {
            if (data.code == 1) {
                var text = "操作成功！";
                if ($("#operStatus").val() == "提交") {
                    text = "提交成功 ！";
                } else if ($("#operStatus").val() == "重新申请") {
                    text = "重新申请成功 ！";
                } else if ($("#operStatus").val() == "取消申请") {
                    text = "取消申请成功 ！";
                }
                window.parent.initTodo();
                backPageAndRefresh();
            } else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        "error": function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}

function setTaskVariables() {
    var taskId = $("#taskId").val();
    var variables = getVariables();
    variables["taskId"] = taskId;

    $.ajax({
        "type": "POST",
        "url": web_ctx + "/activiti/setTaskVariables",
        "contentType": "application/json",
        "dataType": "json",
        "async": false,
        "data": JSON.stringify(variables),
        "success": function (data) {
        },
        "error": function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}

function assistantConfirm(){
	update();
	assistantAffirm();
}

// 市场助手在部门经理审批前确认
function assistantAffirm() {
    bootstrapConfirm("提示", "是否确定？", 300, function () {
        var taskId = $("#taskId").val();
        var commentList = variables.commentList;
        if (isNull(commentList)) {
            commentList = [];
        }

        var form = {
            "node": '市场助手',
            "approver": $("#approver").val(),
            "comment": $("#comment").val(),
            "approveResult": "确认",
            "approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
        };
        commentList.push(form);
        variables["commentList"] = commentList; // 批注列表
        variables["taskId"] = taskId;

        $.ajax({
            "type": "POST",
            "url": web_ctx + "/activiti/setTaskVariables",
            "contentType": "application/json",
            "dataType": "json",
            "data": JSON.stringify(variables),
            "success": function (data) {
                if (data.code == '1') {
                    setAssistantAffirm();
                }
            },
            "error": function (data) {
                bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
            }
        });
    }, null);
}

function setAssistantAffirm() {
    $.ajax({
        url: web_ctx + "/manage/finance/travelReimburs/setAssistantAffirm",
        data: {
            "id": $("#id").val(),
            "assistantStatus": '1'
        },
        type: "post",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.code == 1) {
                backPageAndRefresh();
            }
        },
        error: function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }

    });
}

/*******************************************************************************
 * 表单相关函数 *
 ******************************************************************************/
var statusFlag = -1;
function approve(status) {
	statusFlag = status;
	if (status == 1) {
		bootstrapConfirm("提示", "是否确定提交？", 300, function() {
			$("#operStatus").val("提交");
		    update();
		},null);
	} else if (status == 2) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("同意");
		    if (editInvest) {
		    	update();
		    } else {
		    	update();
		        submitProcess();
		    }
		},null);
	} else if (status == 3) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("不同意");
		    if (editInvest) {
		    	update();
		    } else {
		        submitProcess();
		    }
		},null);
	} else if (status == 4) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("重新申请");
		    update();
		},null);
	} else if (status == 5) {
	    $("#operStatus").val("取消申请");
	    cancelProcess();
	}
}

// 先验证表单（checkForm），验证通过后调用fileUpload函数
function update() {
    if ($("#operStatus").val() == "重新申请") {
        $("#assistantStatus").val("");
    }
    var formData = getFormData();
    var checkMsg = checkForm(formData);
    if (!isNull(checkMsg) && !$.isEmptyObject(checkMsg)) {
        bootstrapAlert("提示", buildCheckMsg(checkMsg), 400, null);
        return;
    } else {
        openBootstrapShade(false);
        if (fileData != null) { // 已选择文件，则先上传文件
            fileData.submit();
        } else {
            submitForm(formData);
        }
    }
}

function save() {
    var formData = getFormData();
    var checkMsg = checkForm(formData);
    if (!isNull(checkMsg) && !$.isEmptyObject(checkMsg)) {
        bootstrapAlert("提示", buildCheckMsg(checkMsg), 400, null);
        return;
    } else {
        openBootstrapShade(true);
        if (fileData != null) { // 已选择文件，则先上传文件
            fileData.submit();
        } else {
            submitForm(formData);
        }
    }
}

// 提交表单
function submitForm(formData) {
    $.ajax({
        url: web_ctx + "/manage/finance/travelReimburs/saveOrUpdate",
        type: "POST",
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify(formData),
        dataType: "json",
        success: function (data) {
            openBootstrapShade(false);
            if (data.code == 1) {
                submitBankInfo();
                if($("#operStatus").val() == ""){
					bootstrapAlert("提示", "保存成功！", 400, function() {
	        			backPageAndRefresh();
	        		});
				}
                if ($("#operStatus").val() == "提交") {
                    var date = new Date();
                    $("#applyTime").val(date);
                    backPageAndRefresh();
                } else if ($("#operStatus").val() == "重新申请") {
                    submitProcess();
                } else if (($("#operStatus").val() == "同意" || $("#operStatus")
                        .val() == "不同意")
                    && editInvest == true) {
                    submitProcess();
                }
            } else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        error: function (data) {
            openBootstrapShade(false);
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}

// 获取表单数据
function getFormData() {
    var json = $("#form1").serializeJson();
    var formData = $.extend(true, {}, json);
    formData["travelreimburseAttachList"] = [];
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("intercityCost"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("stayCost"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("cityCost"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("receiveCost"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("subsidy"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("business"));
    formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("relationship"));
    formData["id"] = $("#id").val();
    return formData;
}
function getBranchFormData(id) {
    var json = [];

    $("#" + id)
        .find("tr[name='node']")
        .each(
            function (index, tr) {
                var tempJson = {};
                $(tr)
                    .find("input,select,textarea")
                    .each(
                        function (index, ele) {
                            var name = $(ele).attr("name");
                            var value = $.trim($(ele).val());
                            if (!isNull(name) && !isNull(value)) {
                                tempJson[name] = value;
                            } else if (name == "detail"
                                && value == "") {
                                if (!isNull(tempJson["id"])) {
                                    tempJson["detail"] = "";
                                }
                            }
                            if(!isNull(name)&&"attachInvestId"==name&& !isNull(value)){
                            	var attachInvestId=value.split(',');
                            	   var investId = null;
                            		var investIdStr= null;
                            		if(attachInvestId != null && attachInvestId.length>0){
                            			for(var i=0;i<attachInvestId.length;i++){
                            				if(attachInvestId[i]!=null && attachInvestId[i]!=''){
                            					if(investIdStr == null){
                            						investIdStr=attachInvestId[i];
                            						investId= attachInvestId[i];
                            					}else
                            						investIdStr+=','+attachInvestId[i];
                            				}
                            			}
                            		}else{
                            			investId = attachInvestId;
                            		}
                            		tempJson["attachInvestId"]=investId;
                            		tempJson["attachInvestIdStr"]=investIdStr;
                            }else if(!isNull(name)&&"attachInvestId"==name&&isNull(value)){
                            	tempJson["attachInvestId"]=value;
                        		tempJson["attachInvestIdStr"]=value;
                            }
                        });
                if (!$.isEmptyObject(tempJson)) {
                    if ((type2value[id] == "0"||type2value[id] == "2") && Object.getOwnPropertyNames(tempJson).length == 1) {
                        return;
                    } else {
                        tempJson["type"] = type2value[id];
                        if (tempJson["type"] == "4") {
                            if (tempJson["trafficSubsidy"] != undefined) {
                                tempJson["actReimburse"] = digitTool
                                    .add(
                                        tempJson["foodSubsidy"],
                                        tempJson["trafficSubsidy"])
                            } else {
                                tempJson["actReimburse"] = tempJson["foodSubsidy"]
                            }
                        }
                        json.push(tempJson);
                    }
                }
            });
    if(id == "business" || id == "relationship"){
		validationRed(id);
	}
    return json;
}

function validationRed(id){
	var currStatus=$("#currStatus").val();
	if(currStatus !=6){
	var str="";
	var strTo=0;
	var map = {};
	var id1=$("#id").val();
	$("#"+id).find("tr[name='node']").each(function(index, tr) {
		var projectId=$(tr).find("input[name='projectId']").val();
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		if(id == "relationship"){
		//如果包含，则取出 map中的value进行叠加
		if(str.indexOf(projectId) != -1){
			actReimburse=numAdd(actReimburse,map[projectId]);
			map[projectId]=actReimburse;
		}else{
			str=str+","+projectId;
			map[projectId]=actReimburse;
		}
		$.ajax({
			url: web_ctx+"/manage/finance/reimburs/getProjectById?id="+projectId+"&travelreimburseid="+id1,
			type: "POST",
			dataType: "json",
			success: function(data) {
				if(data !=null){
					if(data.researchCostLinesBalance<actReimburse){
						$(tr).find("input[name='actReimburse']").css("color","red");
						$(tr).find("input[name='actReimburse']")[0].title="超出攻关费"+accSub(actReimburse,data.researchCostLinesBalance)+"元";
					}else{
						$(tr).find("input[name='actReimburse']").css("color","");
						$(tr).find("input[name='actReimburse']")[0].title="";
					}
				}else{
					$(tr).find("input[name='actReimburse']").css("color","");
					$(tr).find("input[name='actReimburse']")[0].title="";
				}
			},error: function(data) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		}else if(id == "business"){
			strTo=numAdd(strTo,actReimburse);
			$.ajax({
				url: web_ctx+"/manage/finance/reimburs/getGroupBusinessSum?state=2&id="+id1,
				type: "POST",
				dataType: "json",
				success: function(data) {
					if(data !=null){
						if(numAdd(data[0],strTo)>data[1]){
							$(tr).find("input[name='actReimburse']").css("color","red");
							$(tr).find("input[name='actReimburse']")[0].title="超出业务费"+accSub(numAdd(data[0],strTo),data[1])+"元";
						}else{
							$(tr).find("input[name='actReimburse']").css("color","");
							$(tr).find("input[name='actReimburse']")[0].title="";
						}
					}
				},error: function(data) {
					openBootstrapShade(false);
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
		}else{
			$(tr).find("input[name='actReimburse']").css("color","");
			$(tr).find("input[name='actReimburse']")[0].title="";
		}
	});
	}
}
function accSub(arg1,arg2){
	var r1,r2,m,n;
	try{
	r1=arg1.toString().split(".")[1].length
	}catch(e){
	r1=0
	}try{
	r2=arg2.toString().split(".")[1].length
	}catch(e){
		r2=0
		}
	m=Math.pow(10,Math.max(r1,r2));
	n=(r1>=r2)?r1:r2;
	return ((arg1*m-arg2*m)/m).toFixed(n);
	}
function numAdd(num1, num2) {
   var baseNum, baseNum1, baseNum2; 
   try { 
      baseNum1 = num1.toString().split(".")[1].length; 
   } catch (e) {  
     baseNum1 = 0;
   } 
   try {
       baseNum2 = num2.toString().split(".")[1].length; 
   } catch (e) {
     baseNum2 = 0; 
   } 
   baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
   var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;//精度
   return ((num1 * baseNum + num2 * baseNum) / baseNum).toFixed(precision);; 
};

/* 用于报销项目去重 */
function unique(array) {
    var n = []; // 一个新的临时数组
    // 遍历当前数组
    for (var i = 0; i < array.length; i++) {
        // 如果当前数组的第i已经保存进了临时数组，那么跳过，
        // 否则把当前项push到临时数组里面
        if (n.indexOf(array[i]) == -1)
            n.push(array[i]);
    }
    return n;
}

/* 更新差旅报销合计 */

function updatereimbursetotal() {
    var cost = []; // 项目费用数据
    var receive = [];
    var projectName = [];
    var temp = [];
    var key; // 项目索引Key
    /* var costmap = new Map(cost); */

    /* var receivemap = new Map(receive); */
    var sum = [];
    var costmap = {};
    var receivemap = {};
    costmap["key"] = "value";
    receivemap["key"] = "value";

    sum.push("<tr>")
    sum.push("<td style='width:20%;border-left-style:hidden;border-top-style:hidden;'>项目</td>")
    sum.push("<td style='width:40%;border-top-style:hidden;'>差旅统计</td>")
    sum.push("<td style='width:40%;border-top-style:hidden;'>招待统计</td>")
    sum.push("</tr>")

    $("tr[name='node']").each(function (index, tr) {
        project = $(tr).find("textarea[name='projectName']").val();
        if (project != "") {
            temp.push(project);
        }
    });
    projectName = unique(temp);

    $("tr[id='node']").each(function (index, tr) {
        project = $(tr).find("textarea[name='projectName']").val();
        actReimburse = $(tr).find("input[name='actReimburse']").val();
        food = $(tr).find("input[name='foodSubsidy']").val();
        traffic = $(tr).find("input[name='trafficSubsidy']").val();
        if (traffic == undefined) {
            money = food;
        } else {
            money = digitTool.add(food, traffic);
        }
        if (!isNaN(money)) {
            actReimburse = money;
        }
        cost.push(actReimburse);
        key = project;
        if (costmap[key] == undefined) {
            costmap[key] = cost[index];
        } else {
            total = digitTool.add(costmap[key], cost[index]);
            costmap[key] = total;
        }
    });
    $("tr[id='receive']").each(function (index, tr) {
        project = $(tr).find("textarea[name='projectName']").val();
        actReimburse = $(tr).find("input[name='actReimburse']").val();
        receive.push(actReimburse);
        key = project;
        if (receivemap[key] == undefined) {
            receivemap[key] = receive[index];
        } else {
            total = digitTool.add(receivemap[key], receive[index]);
            receivemap[key] = total;
        }
    });

    $(projectName).each(function (index, value) {
        sum.push("<tr style='border-top-style:hidden;'>")
        sum.push("<td style='border-left-style:hidden;'>" + value + "</td>");
        if (costmap[value] == undefined) {
            sum.push("<td>" + '0' + "</td>");
        } else {
            sum.push("<td>" + costmap[value] + "</td>");
        }
        if (receivemap[value] == undefined) {
            sum.push("<td>" + '0' + "</td>");
        } else {
            sum.push("<td>" + receivemap[value] + "</td>");
        }
        sum.push("</tr>")
    });
    $("#reimbursetotal").find("thead[name='reimbursetotal']").append(sum);
}

// 检查表单约束
function checkForm(formData) {
    var checkMsg = {};
    var validFields = $.extend(true, [], validElements);
    var dateComp = null;

    // 判断必须验证的字段是否有空值，如果有则 validFields 对应的属性会自增，0值表示该字段验证通过
    $(formData["travelreimburseAttachList"]).each(
        function (index, ele) {
            var fields = validFields[ele["type"]];
            if (!isNull(fields)) {
                for (var key in fields) {
                    var value = ele[key];
                    if (isNull(value) && key != "costWithAct") {
                        fields[key]++;
                    }
                }
            }

            if (ele["type"] == "4") {
                if (!isNull(ele["beginDate"]) && !isNull(ele["endDate"])
                    && ele["endDate"] < ele["beginDate"]) {
                    dateComp = "离开日期不能小于出发日期！";
                }
            } else {
                if (isNull(ele["cost"]) && isNull(ele["actReimburse"])) {
                    fields["costWithAct"]++;
                }
            }
        });

    for (var key1 in validFields) {
        var fieldObj = validFields[key1];
        var msg = {};
        for (var key2 in fieldObj) {
            if (fieldObj[key2] > 0 && isNull(msg[key2])) {
                if (key2 != "costWithAct") {
                    msg[key2] = validElementsZh[key2] + "不能为空！";
                } else {
                    msg[key2] = validElementsZh[key2] + "不能同时为空！";
                }
            }
        }
        if (!$.isEmptyObject(msg)) {
            checkMsg[key1] = [];
            for (var key3 in msg) {
                checkMsg[key1].push(msg[key3]);
            }
        }
    }

    var plainMsgObj = {
        "5": []
    };
    if (formData["travelreimburseAttachList"].length <= 0) {
        plainMsgObj["5"].push("至少有一条报销项！");
    }
    if (isNull(formData["name"])) {
        plainMsgObj["5"].push("出差人员不能为空！");
    }
    /*
     * if(isNull(formData["travelId"])) { plainMsgObj["5"].push("出差申请不能为空！"); }
     */
    if (plainMsgObj["5"].length > 0) {
        checkMsg["5"] = plainMsgObj["5"];
    }
    if (!isNull(dateComp)) {
        if (isNull(checkMsg["4"]) || $.isEmptyObject(checkMsg["4"])) {
            checkMsg["4"] = [];
        }
        checkMsg["4"].push(dateComp);
    }

    return checkMsg;
}

function buildCheckMsg(checkMsg) {
    var html = [];
    for (var key in checkMsg) {
        if (key == "7") {
            html
                .push('<span class="label label-primary label_title">其他</span>')
        } else if (key == "0") {
            html
                .push('<span class="label label-primary label_title">城际交通费</span>');
        } else if (key == "1") {
            html
                .push('<span class="label label-primary label_title">住宿费</span>');
        } else if (key == "2") {
            html
                .push('<span class="label label-primary label_title">市内交通费</span>');
        } else if (key == "3") {
            html
                .push('<span class="label label-primary label_title">接待餐费</span>');
        } else if (key == "4") {
            html
                .push('<span class="label label-primary label_title">补贴</span>');
        }else if (key == "5") {
            html
                .push('<span class="label label-primary label_title">业务费</span>');
        }else if (key == "6") {
            html
                .push('<span class="label label-primary label_title">攻关费</span>');
        }

        var msg = checkMsg[key];
        for (var key2 in msg) {
            html.push('<span class="label label-default label_item">');
            html.push(msg[key2]);
            html.push('</span>');
        }
    }

    return html.join("");
}

function initFileUpload() {
    var date = new Date();
    var params = {
        "path": "travelreimburs/" + date.getFullYear() + (date.getMonth() + 1)
        + date.getDate(),
        "deleteFile": $("#attachments").val()
    };

    urlParam = urlEncode(params);
    $('#file').fileupload(
        {
            url: web_ctx + '/fileUpload?' + urlParam,
            dataType: 'json',
            formData: params,
            maxFileSize: 50 * 1024 * 1024, // 50 MB
            messages: {
                maxFileSize: '附件大小最大为50M！'
            },
            add: function (e, data) {
                var $this = $(this);
                data.process(function () {
                    return $this.fileupload('process', data);
                }).done(function () {
                    fileData = data;
                    $("#showName").val(data.files[0].name);
                }).fail(
                    function () {
                        var errorMsg = [];
                        $(data.files).each(function (index, file) {
                            errorMsg.push(file.error);
                        });
                        bootstrapAlert("提示", errorMsg.join("<br/>"),
                            400, null);
                    });
            },
            done: function (e, data) {
                var result = data.result;
                if (result.execResult.code != 0) {
                    // 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
                    params["deleteFile"] = result.path;
                    urlParam = urlEncode(params);
                    $("#file").fileupload("option", "url",
                        (web_ctx + '/fileUpload?' + urlParam));
                    $("#file").fileupload("option", "formData", urlParam);
                    $("#showName").val(result.originName);
                    $("#attachments").val(result.path);
                    $("#attachName").val(result.originName);

                    var formData = getFormData();
                    submitForm(formData);
                } else {
                    openBootstrapShade(false);
                    bootstrapAlert("提示", "保存文件失败，错误信息："
                        + result.execResult.result, 400, null);
                }
            }
        });
}

// 提交收款人、银行的相关信息作为历史数据
function submitBankInfo() {
    var json = {
        "userId": $("#userId").val(),
        "payee": $("#payee").val(),
        "bankAccount": $("#bankAccount").val(),
        "bankAddress": $("#bankAddress").val()
    };
    $.ajax({
        url: web_ctx + "/manage/finance/travelReimburs/saveBankInfo",
        type: "post",
        data: json
    });
}

/*******************************************************************************
 * 普通操作相关函数 *
 ******************************************************************************/
function openDept() {
    $("#deptDialog").openDeptDialog();
}
function getDept(dept) {
    if (dept != null) {
        $("#deptName").val(dept.name);
        $("#deptId").val(dept.id);
    }
}

function openProject(obj, tab) {

    if (isNull($(obj).val())) { // 项目内容为空，则计算其他项目内容
        var project = null;
        var tr = null;
        if (tab != "intercityCost"
            && $(obj).parents("tr[name='node']").prev().length <= 0
            && isNull($($(obj).parents("tr[name='node']").prev()).find(
                "textarea[name='projectName']").val())
            && !isNull($("#intercityCost").find("tr[name='node']:first")
                .find("textarea[name='projectName']").val())) {
            tr = $("#intercityCost").find("tr[name='node']:first");
        } else {
            tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
        }

        if (tr.length > 0
            && !isNull($(tr).find("textarea[name='projectName']").val())) {
            $(obj).siblings("input[name='projectId']").val(
                $(tr).find("input[name='projectId']").val());
            $(obj).val($(tr).find("textarea[name='projectName']").val());
            return;
        }
    }
    $("#projectDialog").openProjectDialog();
    projectObj = obj;
    if(tab == "business" || tab == "relationship"){
		validationRed(tab);
	}
}
function getProject(data) {
    if (!isNull(data) && !isNull(projectObj) && !$.isEmptyObject(data)) {
        $(projectObj).siblings("input[name='projectId']").val(data.id);
        $(projectObj).val(data.name);
    }
}

function initBrowserInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var re = /(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie"
        : browserInfo.browser;
    browserInfo.version = m[2];
}

function getBrowserInfo() {
    return $.extend(true, {}, browserInfo);
}

function openTravel() {
    $("#travelDialog").openTravelDialog();
    // travelFrame.contentWindow.drawTable();
    /*var browserInfo = getBrowserInfo();
    if (browserInfo.browser == "ie") {
        window.frames["travelFrame"].drawTable();
    } else {
        travelFrame.contentWindow.drawTable();
    }*/
}

function getTravel(travelList) {

    var html = [];
    if (travelList != null && travelList.length > 0) {
        var travelId = [];
        var travelProcessInstanceId = [];
       
        $(travelList)
            .each(
                function (index, travel) {
                    travelId.push(travel.id);
                    travelProcessInstanceId.push(travel.processInstanceId);
                    var num = index + 1;
                    html.push('<input type="button"  name="detail"  style="margin-left:6px"  value="查看出差明细（' + num + '）" onclick="viewTravel('
                            + travel.processInstanceId + ')" style="border:none;">');
                });
        $("#selectTravel").html(html.join(""));
        $("#travelId").val(travelId.join(", "));
        $("#travelProcessInstanceId").val(travelProcessInstanceId.join(","));

    } else {
        $("#travelId").text("");
        $("#travelProcessInstanceId").val("");
    }
}

// 动态添加节点处理函数
function node(oper, type, obj) {
    if (oper == "del") {
        var tr = $(obj).parents("tr:first").remove();
        initSubTotal();
    } else {
        var fun = type2html[type];
        var html = fun.call();
        $(obj).parents("tr:first").after(html);
        /*
         * $(obj).attr("onclick", "node('del', "+type+", this)");
         * $(obj).text("删除");
         */

        setNode($(obj).parents("tr:last"));
    }
}

// 城际交通费用节点
function getHtmlForIntercityCost() {
    var html = [];
    html.push('<tr name="node" id="node">');
    html.push('<input type="hidden" name="id">');
    html.push('	<td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push('	<td><input type="text" name="startPoint"></td>');
    html.push('	<td><input type="text" name="destination"></td>');
    html.push('	<td><select style="width:100%" name="conveyance">' + $("#conveyance_hidden").html() + '</select></td>');
    html.push('	<td><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'intercityCost\')" readonly></textarea></td>');
    html.push('	<td><input type="text" name="cost" style="text-align:right" style="text-align:right;" ></td>');
    html.push('	<td><input type="text" name="actReimburse" style="text-align:right"></td>');
    html.push('	<td><textarea  name="reason" autocomplete="off" onfocus="reasonChange(this, \'intercityCost\')"></textarea></td>');
    html.push('	<td><textarea name="detail"></textarea></td>');
    html.push('	<td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'intercityCost\', this)"><img alt="添加" src="'
            + base
            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'intercityCost\', this)"><img alt="删除" src="'
            + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}
// 住宿费用节点
function getHtmlForStayCost() {
    var html = [];
    html.push('<tr name="node" id="node">');
    html.push('<input type="hidden" name="id">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="place"></td>');
    html.push(' <td><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'stayCost\')" readonly></textarea></td>');
    html.push(' <td><input type="text" name="dayRoom"></td>');
    html.push(' <td><input type="text" name="cost" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="actReimburse" style="text-align:right"></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'stayCost\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    if (seeAll) {
        html.push('<td>');
        html.push('<select name="attachInvestId" style="width:100%;">');
        html.push('<option value=""></option>');
        $(investList).each(
            function (index, invest) {
                html.push('<option value="' + invest.id + '">'
                    + invest.value + '</option>');
            });
        html.push('</select>');
        html.push('</td>');
    }
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'stayCost\', this)"><img alt="添加" src="'
            + base
            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'stayCost\', this)"><img alt="删除" src="'
            + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}
// 市内交通费用节点
function getHtmlForCityCost() {
    var html = [];
    html.push('<tr name="node" id="node">');
    html.push('<input type="hidden" name="id">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="place"></td>');
    if (ishavatrafficTool.length > 0){
        html.push('	<td><select style="width:100%" name="conveyance">'
            + $("#conveyance1_hidden").html() + '</select></td>');
    }
    html.push(' <td><input type="hidden" name="projectId"><textarea type="text" name="projectName" onclick="openProject(this, \'cityCost\')" readonly></textarea></td>');
    html.push(' <td><input type="text" name="cost" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="actReimburse" style="text-align:right"></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'cityCost\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    if (seeAll) {
        html.push('<td>');
        html.push('<select name="attachInvestId" style="width:100%;">');
        html.push('<option value=""></option>');
        $(investList).each(
            function (index, invest) {
                html.push('<option value="' + invest.id + '">'
                    + invest.value + '</option>');
            });
        html.push('</select>');
        html.push('</td>');
    }
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'cityCost\', this)"><img alt="添加" src="'
            + base
            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'cityCost\', this)"><img alt="删除" src="'
            + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}
// 接待餐费节点
function getHtmlForReceiveCost() {
    var html = [];
    html.push('<tr name="node" id="receive">');
    html.push('<input type="hidden" name="id">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="place"></td>');
    html.push(' <td><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'receiveCost\')" readonly></textarea></td>');
    html.push(' <td><input type="text" name="cost" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="actReimburse" style="text-align:right"></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'receiveCost\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    if (seeAll) {
        html.push('<td>');
        html.push('<select name="attachInvestId" style="width:100%;">');
        html.push('<option value=""></option>');
        $(investList).each(
            function (index, invest) {
                html.push('<option value="' + invest.id + '">'
                    + invest.value + '</option>');
            });
        html.push('</select>');
        html.push('</td>');
    }
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'receiveCost\', this)"><img alt="添加" src="'
            + base
            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'receiveCost\', this)"><img alt="删除" src="'
            + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}
// 补贴节点
function getHtmlForSubsidy() {
    var html = [];
    html.push('<tr name="node" id="node">');
    html.push('<input type="hidden" name="id">');
    html.push('<input type="hidden" name="date">');
    html.push('<input type="hidden" name="actReimburse">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="beginDate" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="endDate" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="foodSubsidy" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="trafficSubsidy" style="text-align:right"></td>');
//    if (ishavatrafficSubsidy.length > 0) {
//        html.push(' <td><input type="text" name="trafficSubsidy" style="text-align:right"></td>');
//    }
    html.push(' <td><input type="hidden" name="projectId"><textarea type="text" name="projectName" onclick="openProject(this, \'subsidy\')" readonly></textarea></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'subsidy\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;"  onclick="node(\'add\', \'subsidy\', this)"><img alt="添加" src="'
            + base
            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;"  onclick="node(\'del\', \'subsidy\', this)"><img alt="删除" src="'
            + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}

// 业务费节点
function getHtmlForBusiness() {
    var html = [];
    html.push('<tr name="node" id="receive">');
    html.push('<input type="hidden" name="id">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="place"></td>');
    html.push(' <td><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'business\')" readonly></textarea></td>');
    html.push(' <td><input type="text" name="cost" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="actReimburse" style="text-align:right"  onchange="validationRed(\'business\')"></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'business\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    if (seeAll) {
        html.push('<td>');
        html.push('<select name="attachInvestId" style="width:100%;">');
        html.push('<option value=""></option>');
        $(investList).each(
            function (index, invest) {
                html.push('<option value="' + invest.id + '">'
                    + invest.value + '</option>');
            });
        html.push('</select>');
        html.push('</td>');
    }
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'business\', this)"><img alt="添加" src="'
        + base
        + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'business\', this)"><img alt="删除" src="'
        + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}
// 攻关费用节点
function getHtmlForRelationship() {
    var html = [];
    html.push('<tr name="node" id="receive">');
    html.push('<input type="hidden" name="id">');
    html.push(' <td style="border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
    html.push(' <td><input type="text" name="place"></td>');
    html.push(' <td><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'relationship\')" readonly></textarea></td>');
    html.push(' <td><input type="text" name="cost" style="text-align:right"></td>');
    html.push(' <td><input type="text" name="actReimburse" style="text-align:right"  onchange="validationRed(\'relationship\')"></td>');
    html.push(' <td><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'relationship\')"></textarea></td>');
    html.push(' <td><textarea name="detail"></textarea></td>');
    if (seeAll) {
        html.push('<td>');
        html.push('<select name="attachInvestId" style="width:100%;">');
        html.push('<option value=""></option>');
        $(investList).each(
            function (index, invest) {
                html.push('<option value="' + invest.id + '">'
                    + invest.value + '</option>');
            });
        html.push('</select>');
        html.push('</td>');
    }
    html.push(' <td style="border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'relationship\', this)"><img alt="添加" src="'
        + base
        + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'relationship\', this)"><img alt="删除" src="'
        + base + '/static/images/del.png" ></a></td>');
    html.push('</tr>');

    return html.join("");
}

// 初始化node行的输入框
function setNode(tr) {
    $(tr).find("input[name='cost'],input[name='actReimburse']").inputmask(
        "Regex", {
            regex: "\\d+\\.?\\d{0,2}"
        });
    $(tr).find("input[name='foodSubsidy']").inputmask("Regex", {
        regex: "\\d+\\.?\\d{0,2}"
    });
    $(tr).find("input[name='dayRoom']").inputmask("Regex", {
        regex: "\\d+\\.?\\d{0,1}"
    });

    $(tr).find(".datetimepick").datetimepicker({
        minView: "month",
        language: "zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        bootcssVer: 3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });

    $(tr).find(
        "input[name='cost'],input[name='actReimburse'],"
        + "input[name='foodSubsidy'],input[name='trafficSubsidy']")
        .bind("keyup", function () {
            updateSubTotal(this); // 更新小计数据
            updateTotal(); // 更新总计数据
        });

    $(tr).find("input[name='cost']").blur(function () {
        costBlur(this);
    });

    $(tr).find("input[name='beginDate']").change(function () {
        initdate(this);
    });
    inittextarea();
}

// 更新小计
function updateSubTotal(obj) {
    var tbody = $(obj).parents("tbody:first");
    var name = $(obj).attr("name");

    var total = 0;
    $(tbody).find("tr[name='node']").find("input[name='" + name + "']").each(
        function (index, input) {
            var value = $(input).val();
            if (!isNull(value)) {
                total = digitTool.add(total, parseFloat(value));
            }
        });

    $(tbody).find("tr[name='subTotal']")
        .find("input[name='" + name + "Total']").val(
        total != 0 ? total : "");
}

// 更新总计
function updateTotal() {
    var total = 0.0;
    var traffic = $("tr[name='node']").find("input[name='trafficSubsidy']")
        .val();
    if (traffic == undefined) {
        $("tr[name='node']").find("input[name='foodSubsidy']").each(
            function (index, input) {
                var value = $(input).val();
                if (!isNull(value)) {
                    total = digitTool.add(total, parseFloat(value));
                }
            });
    } else {
        $("tr[name='node']").find(
            "input[name='foodSubsidy'],input[name='trafficSubsidy']").each(
            function (index, input) {
                var value = $(input).val();
                if (!isNull(value)) {
                    total = digitTool.add(total, parseFloat(value));
                }
            });
    }

    $("tr[name='node']").each(function (index, tr) {
        var actReimburse = $(tr).find("input[name='actReimburse']").val();
        var value = "";
        if (!isNull(actReimburse)) {
            value = actReimburse;
        } else {
            value = $(tr).find("input[name='cost']").val();
        }

        if (isNull(value)) {
            value = "0";
        }
        total = digitTool.add(total, parseFloat(value));
    });

    if (total != 0) {
        $("#total").val(total);
        $("#totalcn").val(digitUppercase(total)); // 将总计数字转换为中文大写
        var totalmoney = $("#total").val();
        $("#Total").text(fmoney(totalmoney, 0));
        // $("#Total").text(total);
        $("#Totalcn").text(digitUppercase(total));
    } else {
        $("#total").val("");
        $("#totalcn").val("");
        $("#Total").text("");
        $("#Totalcn").text("");
    }
}

// 费用失去焦点时刷新实报
function costBlur(obj) {
    var td = $(obj).parent("td");
    var actReimbruseObj = $(td).next("td").find("input[name='actReimburse']");
    if (isNull($(actReimbruseObj).val())) {
        var value = $(obj).val();
        $(actReimbruseObj).val(value);
    }
    $(actReimbruseObj).trigger("keyup");
}

// 查看出差详细
function viewTravel(processInstanceId) {
    var param = {
        "processInstanceId": processInstanceId,
        "page": "manage/ad/chkatt/travel/view"
    }

    var url = web_ctx + "/activiti/process?" + urlEncode(param);
    $("#travelDetailFrame").attr("src", url);

    var bodyHeight = $(window).height();
    var modalHeight = bodyHeight * 0.7;
    $("#travelDetailModal").find(".modal-body").css("max-height", modalHeight);
    $("#travelDetailFrame").css("height", modalHeight);

    $("#travelDetailModal").modal("show");
}

// 事由聚焦时
function reasonChange(obj, tab) {
    if (isNull($(obj).val())) { // 项目内容为空，则计算其他项目内容
        var tr = null;
        if (tab != "intercityCost"
            && $(obj).parents("tr[name='node']").prev().length <= 0
            && isNull($($(obj).parents("tr[name='node']").prev()).find(
                "textarea[name='reason']").val())
            && !isNull($("#intercityCost").find("tr[name='node']:first")
                .find("input[name='reason']").val())) {
            tr = $("#intercityCost").find("tr[name='node']:first");
        } else {
            tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
        }

        /*
         * if( tr.length > 0 &&
         * !isNull($(tr).find("textarea[name='reason']").val()) ) { $(obj).val(
         * $(tr).find("textarea[name='reason']").val() ); }
         */
    }
}

// 查看流程图
function viewProcess(processInstanceId) {
    var url = web_ctx
        + "/activiti/getImgByProcessInstancdId?processInstanceId="
        + processInstanceId;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("client_type", "DESKTOP_WEB");
    xhr.onload = function () {
        if (this.status == 200) {
            var blob = this.response;
            var img = document.createElement("img");
            $(img).width("100%");
            img.onload = function (e) {
                window.URL.revokeObjectURL(img.src);
            };
            img.src = window.URL.createObjectURL(blob);
            $("#imgcontainer").html(img);
            $("#imgModal").modal("show");
        } else if (this.status == 500) {
            bootstrapAlert("提示", this.statusText, 400, null);
        }
    }
    xhr.send();
}

// 下载附件
function downloadAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if (!isNull(attachUrl)) {
        var url = web_ctx + attachUrl;
        window.open(url, '_blank');
    }
}

// 删除附件
function deleteAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if (!isNull(attachUrl)) {
        bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function () {
            $.ajax({
                url: web_ctx + "/manage/finance/travelReimburs/deleteAttach",
                data: {
                    "path": $("#attachments").val(),
                    "id": $("#id").val()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == 1) {
                        bootstrapAlert("提示", "删除成功 ！", 400, function () {
                            window.location.reload();
                        });
                    } else {
                        bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
                    }
                },
                error: function (data) {
                    bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                }

            });
        }, null);
    } else {
        bootstrapAlert("提示", "无附件！", 400, null);
    }
}

/*******************************************************************************
 * 各类初始化相关函数 *
 ******************************************************************************/

// 初始化时间输入框
function initDatetimepicker() {
    $("input.datetimepick").datetimepicker({
        minView: "month",
        language: "zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        bootcssVer: 3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

// 某项无填写则隐藏
function hidecollapse() {
    $("div.tittle").each(function (index, tab) {
        if ($(tab).find("table").find("tr[name='node']").length <= 0) {
            $(tab)[0].style.display = 'none';
        }
    });
}

// 初始化文本域
function inittextarea() {
    autosize(document.querySelectorAll('textarea'));
}

function initdate(obj) {
    var temp = $(obj).val();
    var tr = $(obj).parent("td").parent("tr");
    var date = $(tr).find("input[name='date']");
    if (!isNull(temp)) {
        date.val(temp);
    }
}

/* 初始化折叠控件 */
function initcollapse() {
    $('#intercityCost').on('show.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[0].style.display = "none";
    });

    $('#intercityCost').on('hidden.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[0].style.display = "block";
    });

    $('#stayCost').on('show.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[1].style.display = "none";
    });

    $('#stayCost').on('hidden.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[1].style.display = "block";
    });

    $('#cityCost').on('show.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[2].style.display = "none";
    });

    $('#cityCost').on('hidden.bs.collapse', function () {
        var l = document.getElementsByTagName("hr");
        l[2].style.display = "block";
    });
        $('#receiveCost').on('show.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[3].style.display = "none";
        });

        $('#receiveCost').on('hidden.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[3].style.display = "block";
        });

        $('#subsidy').on('show.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[4].style.display = "none";
        });

        $('#subsidy').on('hidden.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[4].style.display = "block";
        });
        
        $('#business').on('show.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[5].style.display = "none";
        });

        $('#business').on('hidden.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[5].style.display = "block";
        });

        $('#relationship').on('show.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[6].style.display = "none";
        });

        $('#relationship').on('hidden.bs.collapse', function () {
            var l = document.getElementsByTagName("hr");
            l[6].style.display = "block";
        });
}

function hidenone() {
    if (getBranchFormData("stayCost").length == 0) {
        $("#stayCost").removeClass("panel-collapse collapse in");
        $("#stayCost").addClass("panel-collapse collapse");
        var l = document.getElementsByTagName("hr");
        l[1].style.display = "block";
    }
    if (getBranchFormData("intercityCost").length == 0) {
        $("#intercityCost").removeClass("panel-collapse collapse in");
        $("#intercityCost").addClass("panel-collapse collapse");
        var l = document.getElementsByTagName("hr");
        l[0].style.display = "block";
    }

    if (getBranchFormData("cityCost").length == 0) {
        $("#cityCost").removeClass("panel-collapse collapse in");
        $("#cityCost").addClass("panel-collapse collapse");
        var l = document.getElementsByTagName("hr");
        l[2].style.display = "block";
    }
        if (getBranchFormData("receiveCost").length == 0) {
            $("#receiveCost").removeClass("panel-collapse collapse in");
            $("#receiveCost").addClass("panel-collapse collapse");
            var l = document.getElementsByTagName("hr");
            l[3].style.display = "none";
            var tittle=$(".tittle");
            tittle[3].style.display = "none";
        }
        if (getBranchFormData("subsidy").length == 0) {
            $("#subsidy").removeClass("panel-collapse collapse in");
            $("#subsidy").addClass("panel-collapse collapse");
            var l = document.getElementsByTagName("hr");
            l[4].style.display = "block";
        }
        if (getBranchFormData("business").length == 0) {
            $("#business").removeClass("panel-collapse collapse in");
            $("#business").addClass("panel-collapse collapse");
            var l = document.getElementsByTagName("hr");
            l[5].style.display = "block";
        }

        if (getBranchFormData("relationship").length == 0) {
            $("#relationship").removeClass("panel-collapse collapse in");
            $("#relationship").addClass("panel-collapse collapse");
            var l = document.getElementsByTagName("hr");
            l[6].style.display = "block";
        }
}

// 初始化弹出选择框
function initDialog() {
    $("#deptDialog").initDeptDialog({
        "callBack": getDept,
        "isCheck": false
    });

    $("#projectDialog").initProjectDialog({
        "callBack": getProject
    });

    $("#travelDialog").initTravelDialog({
        "callBack": getTravel,
        "isCheck": true
    });
}

// 初始化输入框约束
function initInputMask() {
    $("input[name='cost'],input[name='actReimburse']").inputmask("Regex", {
        regex: "\\d+\\.?\\d{0,2}"
    });
    $("input[name='foodSubsidy']").inputmask("Regex", {
        regex: "\\d+\\.?\\d{0,2}"
    });
    $("input[name='dayRoom']").inputmask("Regex", {
        regex: "\\d+\\.?\\d{0,1}"
    });
    $("input[name='bankAccount']").inputmask("Regex", {
        regex: "\\d+\\?\\d{0,0}"
    });
}

// 初始化输入框按键弹起事件
function initInputKeyUp() {
    $(
        "input[name='cost'],input[name='actReimburse'],"
        + "input[name='foodSubsidy'],input[name='trafficSubsidy']")
        .bind("keyup", function () {
            updateSubTotal(this); // 更新小计数据
            updateTotal(); // 更新总计数据
        });

    $("input[name='cost']").blur(function () {
        costBlur(this);
    });
    $("input[name='beginDate']").change(function () {
        initdate(this);
    });
}

// 初始化小计
function initSubTotal() {
    $(
        "input[name='cost'],input[name='actReimburse'],"
        + "input[name='foodSubsidy']").trigger("keyup");
}

// 初始化select2控件（收款人、银行卡号、开户行地址）
function initSelect() {
    var isDigit = /^\d+(\d\s)?.*\d+$/;
    $(".select2").select2({
        tags: true,
        allowClear: true,
        placeholder: "请选择一项或输入值后回车"
    });
    $(".select2").on("select2:select", function (evt) {
        var name = $(this).prev("input[type='hidden']").attr("name");
        if (name == "bankAccount") {
            var selValue = $(this).val();
            if (!isNull(selValue) && isDigit.test(selValue)) {
                $(this).prev("input[type='hidden']").val(selValue);
            } else {
                $(this).prev("input[type='hidden']").val("");
                $(this).select2('val', '');
            }
        } else {
            $(this).prev("input[type='hidden']").val($(this).val());
        }
    });

    $(".select2").on("change", function (evt) {
        var selValue = $(this).val();
        if (isNull(selValue)) {
            $(this).prev("input[type='hidden']").val("");
        }
    });

    $(".select2-selection__rendered").css("text-align", "left");
}

// 初始化银行相关数据
function initBankInfo() {
    $.ajax({
        "type": "GET",
        "url": web_ctx + "/manage/finance/travelReimburs/getBankInfo?userId="
        + $("#userId").val(),
        "dataType": "json",
        "success": function (data) {
            if (!isNull(data)) {
                $(data).each(
                    function (index, value) {
                        if (value.type == "0") {
                            $("#payeeSelect").append(
                                "<option value='" + value.value + "'>"
                                + value.value + "</option>");
                        } else if (value.type == "1") {
                            $("#bankAddressSelect").append(
                                "<option value='" + value.value + "'>"
                                + value.value + "</option>");
                        } else if (value.type == "2") {
                            $("#bankAccountSelect").append(
                                "<option value='" + value.value + "'>"
                                + value.value + "</option>");
                        }
                    });

                $("#payeeSelect").val($("#payee").val()).trigger("change");
                $("#bankAccountSelect").val($("#bankAccount").val()).trigger(
                    "change");
                $("#bankAddressSelect").val($("#bankAddress").val()).trigger(
                    "change");
            }
        }
    });
}

// 初始化费用归属
function initInvest() {
    $.ajax({
            "type": "GET",
            "url": web_ctx + "/manage/finance/reimburs/getInvestList",
            "dataType": "json",
            "success": function (data) {
                if (!isNull(data)) {
                    investList = data;
                    $("tbody").find("select[name='attachInvestId']").each(function (index, select) {
                                /*var investValue = $(select).attr(
                                    "value");
                                var html = [];
                                html.push('<option value="-1"></option>');
                                $(investList)
                                    .each(
                                        function (index,
                                                  invest) {
                                            html.push('<option value="' + invest.id + '" ' + (investValue == invest.id ? "selected" : "") + '>' + invest.value + '</option>');
                                        });
                                $(select).append(html.join(""));*/
                    	
                                $(select)[0].options.length = 0;
                                for (var item in data) {
                    				$(select)[0].options.add(new Option(data[item].value, data[item].id));
                                }
                    			var s="";
                    			if($(select).attr('data-v') != null && $(select).attr('data-v') !='')
                    			 s=$(select).attr('data-v').split(",");
                    			$(this).selectpicker('val', s);//默认选中
                    			$(this).selectpicker('refresh');
	                			$('.selectpicker').selectpicker('refresh');
	                            $('.selectpicker').selectpicker('render');
                            });
                }
            }
        });
}

function initNode() {
    var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost",
        "subsidy","business","relationship"];
    $(elements)
        .each(
            function (index, ele) {
                var nodes = $("#" + ele).find("tr[name='node']");
                if (!isNull(nodes) && nodes.length > 0) {
                    $(nodes)
                        .each(
                            function (index, node) {
                                var td = $(node)
                                    .find("td:last");
                                if (index < nodes.length - 1) { // 不是最后的表格行
                                    $(td)
                                        .append(
                                            '<a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'add\', \''
                                            + ele
                                            + '\', this)"><img alt="添加" src="'
                                            + base
                                            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'del\', \''
                                            + ele
                                            + '\', this)"><img alt="删除" src="'
                                            + base
                                            + '/static/images/del.png" ></a>');
                                } else {
                                    $(td)
                                        .append(
                                            '<a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'add\', \''
                                            + ele
                                            + '\', this)"><img alt="添加" src="'
                                            + base
                                            + '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'del\', \''
                                            + ele
                                            + '\', this)"><img alt="删除" src="'
                                            + base
                                            + '/static/images/del.png" ></a>');
                                }
                            });
                } else {
                    var fun = type2html[ele];
                    var html = fun.call();
                    $("#" + ele).find("tbody").prepend(html);
                }
            });

}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
    var commentList = variables.commentList;
    if (isNull(commentList)) {
        commentList = [];
    }
    /* $(commentList).each(function(index, comment) { */
    for (var i = commentList.length - 1; i >= 0; i--) {
        var html = [];
        html.push("<tr>");
        html.push("<td>");
        html.push(commentList[i].node);
        html.push("</td>");
        html.push("<td>");
        html.push(commentList[i].approver);
        html.push("</td>");
        html.push("<td>");
        var approveDate = commentList[i].approveDate + "";
        if (!dateRep.test(approveDate)) {
            html.push(new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm"));
        } else {
            html.push(new Date(Date.parse(approveDate.replace(/-/g, "/"))).pattern("yyyy-MM-dd HH:mm"));
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

    /* }); */
}

/** *********** 加解密操作 Begin ************* */
// 如果有解密权限，则解密当前已加密的数据
function initDecryption() {
    if ('y' == $("#encrypted").val()) {
        if ("resubmit" == submitPhase) {
            $("textarea[name='reason'],textarea[name='detail']").each(
                function (index, textarea) {
                    $(textarea).text("");
                });
            $("#encrypted").val("n");
        } else {
            if (hasDecryptPermission) {
                var now = new Date().pattern("yyyyMMdd");
                $.ajax({
                    url: web_ctx + '/manage/getEncryptionKey?baseKey=' + now
                    + "&date=" + new Date().getTime(),
                    type: 'GET',
                    success: function (data) {
                        if (data.code == 1) {
                            var tempKey = data.result;
                            var encryptionKey = aesUtils.decryptECB(tempKey,
                                now);
                            encryptPageText(encryptionKey);
                        } else {
                            if (data.code == -1) {
                                bootstrapAlert('提示', data.result, 400, null);
                            }
                            disabledEncryptPageText();
                        }
                    }
                });
            } else {
                disabledEncryptPageText();
            }
        }
    }
}

function encryptPageText(encryptionKey) {
    $("textarea[name='reason'],textarea[name='detail']").each(
        function (index, textarea) {
            var val = $(textarea).val();
            try {
                val = aesUtils.decryptECB(val, encryptionKey);
                if (!isNull(val)) {
                    $(textarea).val(val);
                }
                $(textarea).css("background-color", "#ccc");
                $(textarea).parent().css("background-color", "#ccc");
            } catch (e) {
            }
        });
}
function disabledEncryptPageText() {
    $("tr[name='node']").each(function (index, tr) {
        var id = $(tr).find("input[name='id']").val();
        if (!isNull(id)) {
            $(tr).find("textarea[name='reason']").prop("readonly", true);
            $(tr).find("textarea[name='detail']").prop("readonly", true);
        }
    });
}

function lock() {
    var params = {};
    var travelreimburseAttachList = getUnLockData();
    params['id'] = $('#id').val();
    params['travelreimburseAttachList'] = travelreimburseAttachList;

    $.ajax({
        url: web_ctx + '/manage/finance/travelReimburs/lock',
        type: 'POST',
        contentType: 'application/json;charset=utf-8;',
        dataType: 'JSON',
        data: JSON.stringify(params),
        success: function (data) {
            if (data.code == 1) {
                bootstrapAlert('提示', data.result, 400, function () {
                    refreshPage();
                });
            } else {
                bootstrapAlert('提示', data.result, 400, null);
            }
        },
        error: function (err, errMsg) {
            bootstrapAlert('提示', '加密失败，请联系管理员！', 400, null);
        }
    });
}
function getUnLockData() {
    var dataList = [];
    $("tr[name='node']").each(function (index, tr) {
        var data = {};
        data['id'] = $(tr).find("input[name='id']").val();
        data['reason'] = $(tr).find("textarea[name='reason']").val();
        data['detail'] = $(tr).find("textarea[name='detail']").val();

        dataList.push(data);
    });

    return dataList;
}
/** *********** 加解密操作 End ************* */

/*******************************************************************************
 * 打印相关
 ******************************************************************************/
function print(processInstanceId) {
    var param = {
        "processInstanceId": processInstanceId,
        "page": "manage/finance/travelReimburs/print",
        "entityClass": "com.reyzar.oa.domain.FinTravelReimburs",
        "tableName": "fin_travelreimburs"
    }

    window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}

function exportpdf(processInstanceId) {
    var param = {
        "processInstanceId": processInstanceId,
        "page": "manage/finance/travelReimburs/pdf",
        "entityClass": "com.reyzar.oa.domain.FinTravelReimburs",
        "tableName": "fin_travelreimburs"
    }

    window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}