var fileData = null;

//环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "通过",
	"不同意": "不通过",
	"取消申请": "取消申请"
};


$(function() {
	initTaskComment();
	initInput();
	initFileUpload();
	
	if($("#currStatus").val() == '6') {
		$("#travelResult").attr("readonly",false);
	}
});

/*****
 *	表单处理相关函数 
 * ****/
function update() {
	//先验证表单（checkForm）
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}else {
		openBootstrapShade(true);
		if($("#operStatus").val() == '同意') {
			submitProcess();
			if(fileData != null) {
				fileData.submit();
			} else {
				submitForm2(formData);
			}
		}else {
			if(fileData != null) {
				fileData.submit();
			} else {
				submitForm(formData);
			}
		}
		openBootstrapShade(false);
	}
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx+"/manage/ad/travel/saveOrUpdate",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				if($("#operStatus").val() == "重新申请") {
        			submitProcess();
        		} else {
        			/*bootstrapAlert("提示", "提交成功！", 400, function() {*/
        				backPageAndRefresh();
        		/*	});*/
        		}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function submitForm2(formData) {
	var travelResult = formData["travelResult"];
	var id = $("#id").val();
	$.ajax({
		url: web_ctx+"/manage/ad/travel/updateTravelResult",
		type: "post",
	//	contentType: "application/json;charset=UTF-8",
		data: {"id": $("#id").val(), "travelResult": travelResult},
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
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["travelAttachList"] = [];

	$("tr[name='node']").each(function(index, tr) {
		var id = $("this").find("input[name='travelAttachId']").val();
		var beginDate = $(this).find("input[name='beginDate']").val();
		var endDate = $(this).find("input[name='endDate']").val();
		var place = $(this).find("input[name='place']").val();
		var task = $(this).find("input[name='task']").val();
		var vehicle = $(this).find("select[name='vehicle']").val();
		
		if(!isNull(beginDate) || !isNull(endDate)
				|| !isNull(place) || !isNull(task)) {
			var travelAttach = {};
			travelAttach["id"] = id;
			travelAttach["beginDate"] = beginDate;
			travelAttach["endDate"] = endDate;
			travelAttach["place"] = place;
			travelAttach["task"] = task;
			travelAttach["vehicle"] = vehicle;
			
			formData["travelAttachList"].push(travelAttach);
		}
	});
	
	return formData;
}

function checkForm(formData) {
	var text = [];
	if($("#currStatus").val() == '6') {
		if(isNull(formData["travelResult"])) {
			text.push("请填写出差结果！");
		}
	}
	if(isNull(formData["budget"])) {
		text.push("费用预算不能为空！");
	}
	if(formData["travelAttachList"].length <= 0) {
		text.push("至少有一条出差项！");
	} else {
		$(formData["travelAttachList"]).each(function(index, attach) {
			var st = attach["beginDate"];
			if(isNull(st)) {
				text.push("开始时间不能为空！");
				return false;
			}
			var et = attach["endDate"];
			if(isNull(et)) {
				text.push("结束时间不能为空！");
				return false;
			}
			if(st > et) {
				text.push("开始时间不能大于结束时间！");
				return false;
			}
		});
		
		$(formData["travelAttachList"]).each(function(index, attach) {
			if(isNull(attach["place"])) {
				text.push("出差地点不能为空！");
				return false;
			}
		});
	}
	return text;
}

/*****
 *	流程处理相关函数 
 * ****/
function approve(status) {
	if(status == 1) {
		bootstrapConfirm("提示", "是否确定提交？", 300, function() {
			$("#operStatus").val("提交");
			update();
		},null)
	} else if(status == 2) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("同意");
			update();
	},null)
} else if(status == 3) {
	bootstrapConfirm("提示", "是否确定操作？", 300, function() {
		$("#operStatus").val("不同意");
		submitProcess();
	},null)
} else if(status == 4) {
	bootstrapConfirm("提示", "是否确定操作？", 300, function() {
		$("#operStatus").val("重新申请");
		update();
	},null)
} else if(status == 5) {
		$("#operStatus").val("取消申请");
		cancelProcess();
}
}

function submitProcess() {
	var status = getNextStatus();
	if(status == "2") { // 总经理审批通过，用特殊方法结束流程
		endProcess(status);
	} else {
		var taskId = $("#taskId").val();
		var variables = getVariables();
		var applyTask = "applytask";
		var compResult = {};
		
		if(status == "5") { // 总经理不同意，则回退到重新申请节点
			compResult = backProcessForParallel(taskId, applyTask, variables)
		} else {
			compResult = completeTask(taskId, variables);
		}
		
		if(compResult.code == 1) {
			setStatus(status);
		} else if(compResult.code == 0) {
			bootstrapAlert("提示", compResult.result.statusText, 400, null);
		} else {
			bootstrapAlert("提示", compResult.result.toString(), 400, null);
		}
		validate4();
	}
	openBootstrapShade(false);
}

// 获取流程变量
function getVariables() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	
	var operStatus = $("#operStatus").val(); 
	var form = {
			"node": getNodeInfo(),
			"approver": $("#approver").val(),
			"comment": operStatus != "提交" ? $("#comments").val() : "",
			"approveResult": "",
			"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
	};
	form["approveResult"] = nodeOnOper[operStatus];
	commentList.push(form);
	
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = 
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" ? true : false;
	
	return variables;
}

/*
 * 审批状态
 * 0：提交申请 1：待审批 2：已归档3：取消申请 4：部门经理不同意 5：总经理不同意
 * */
function getNextStatus() {
	var status = null;
	var taskName = $("#taskName").val();
	if($("#operStatus").val() == "同意") {
		if($("#isProcess").val() == "1"){
			if(taskName == "总经理") {
				status = "6";
			} else {
				if($("#currStatus").val() == "6") {
					status = "2";
				}else {
					status = $("#currStatus").val();
				}
			}
		}else {
			if(taskName == "总经理") {
				status = "2";
			}else {
				status = $("#currStatus").val();
			}
		}
	} else if($("#operStatus").val() == "不同意") {
		if(taskName == "部门经理") {
			status = "4";
		} else if(taskName == "总经理") {
			status = "5";
		}
	} else {
		status = "1";
	}
	
	return status;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
	var nodeInfo = "";
	if($("#operStatus").val() == "重新申请" || $("#operStatus").val() == "取消申请" || $("#operStatus").val() == "提交") {
		nodeInfo = "提交申请";
	} else {
		nodeInfo = $("#taskName").val();
	}
	
	return nodeInfo;
}

function endProcess(status) {
	var processInstanceId = $("#processInstanceId").val();
	var variables = getVariables();
	var result = endProcessOfParallel(processInstanceId, variables);
	if(result != null) {
		if(result.code == 1) {
			setStatus(status);
		} else {
			bootstrapAlert("提示", result.result, 400, null);
		}
	} else {
		bootstrapAlert("提示", "结束流程失败，请联系管理员！", 400, null);
	}
}

//取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		endProcess("3");
	}, null);
}

function setStatus(status) {
	var id = $("#id").val();
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/ad/travel/setStatus",    
        "dataType": "json",
        "data": {"id": id, "status": status},
        "success": function(data) { 
        	if(data.code == 1) {
        		var text = "操作成功！";
        		if($("#operStatus").val() == "重新申请") {
					text = "重新申请成功 ！";
				} else if($("#operStatus").val() == "取消申请") {
					text = "取消申请成功 ！";
				}
        		
        		window.parent.initTodo();
				/*bootstrapAlert("提示", text, 400, function() {*/
					backPageAndRefresh();
			/*	});*/
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
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
        "success": function(data) { 
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
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

/*****
 *	普通操作相关函数 
 * ****/

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
		$(obj).attr("onclick", "node('del', this)");
		$(obj).html('<img alt="删除" src="'+base+'/static/images/del.png">');
		initDatetimepicker();
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td style="padding: 0px;">');
	html.push('<input type="text" name="beginDate" class="beginDate" style="width:43%;text-align:center;" readonly> 至 ');
	html.push('<input type="text" name="endDate" class="endDate" style="width:43%;text-align:center;" readonly>');
	html.push('</td>');
	html.push('<td colspan="2" class="nest_td">');
	html.push('<table>');
	html.push('<tr>');
	html.push('<td class="nest_td_left"><input type="text" name="place"></td>');
	html.push('<td><input type="text" name="task"></td>');
	html.push('</tr>');
	html.push('</table>');
	html.push('</td>');
	html.push('<td>');
	html.push('<select name="vehicle">');
	html.push($("#vehicle_hidden").html());
	html.push('</select>');
	html.push('</td>');
	html.push('<td><a href="javascript:void(0);" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png"></a></td>');
	html.push('</tr>');
	
	return html.join("");
}

	


/*****
 *	页面初始化相关函数 
 * ****/
var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

	/*$(commentList).each(function(index, comment) {
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		html.push(comment.node);
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

function initInput() {
	if( !isNull(formElement) ) {
		$("#form1").find("input,select,textarea").each(function(index, ele) {
			var name = $(ele).attr("name");
			if( !isNull(formElement[name]) ) {
				$(ele).removeAttr("readonly");
			}
			if( !isNull(disableElement[name]) ) {
				$(ele).attr("readonly");
				$(ele).css("color", "gray");
			}
			
			if(name == "budget") {
				$(ele).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
			}
		});
		initDatetimepicker();
	}
}

function initDatetimepicker() {
	$(".beginDate, .endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
        todayBtn: true,
        bootcssVer:3
    });
}



function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

//文件上传
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "travel/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
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