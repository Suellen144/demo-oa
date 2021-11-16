/*******************************************************************************
 * 全局变量 *
 ******************************************************************************/
var fileData = null;
var index=0;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交" : save,
	"同意" : agree,
	"不同意" : disagree,
	"重新申请" : reApply,
	"取消申请" : cancelApply,
};

/*
 * 审批状态 0： 重新申请 1：项目负责人审批 2：部门主管审批 3：财务审批 4：总经理审批 5：已归档  6：取消申请 7：项目负责人不同意 8：部门主管不同意
 * 9：财务不同意 10：总经理不同意 
 */
// 同意后的下一状态
var approvedStatus = {
	"0" : "1",
	"1" : "2",
	"2" : "3",
	"3" : "4",
	"4" : "5"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0" : "6",
	"1" : "7",
	"2" : "8",
	"3" : "9",
	"4" : "10",
};
// 环节与状态的映射
var nodeOnStatus = {
	"0" : "提交申请",
	"1" : "项目负责人",
	"2" : "部门主管",
	"3" : "财务",
	"4" : "总经理",
	"5" : "已归档",
	"6" : "取消申请",
	"7" : "提交申请",
	"8" : "提交申请",
	"9" : "提交申请",
	"10" : "提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
	"提交" : "提交成功",
	"重新申请" : "申请成功",
	"同意" : "通过",
	"不同意" : "不通过",
	"取消申请" : "取消申请",
};

$(function() {
	inittextarea();
	initTaskComment();
	initFileUpload();
	initInputMask();
	initMoneyFormat();
	
	$("#userDialog").initUserByDeptDialog({
		 "callBack" : getData2
	 });
	 //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/sale/projectManage/getListHistory",
		type: "post",
		data: {projectIdHistory:$("#id").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tbodyInfoTr").append("<tr name='node1' class='node1'><td style='width:33%'><input type='text' id='uName' name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  " +
							"name='uId' value='"+data[i].principal.id+"' data-sorting='"+index+"'><input type='hidden'  " +
							"name='businessId' value='"+data[i].id+"'></td>" +
											"<td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"%'" +
											"   style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}else{
					$("#tbodyInfoTr").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog2(this)'><input type='text'  name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  name='uId' value='"+data[i].principal.id+"' " +
									" data-sorting='"+index+"' style='text-align:center'><input type='hidden'  " +
							"name='businessId' value='"+data[i].id+"'></td>" +
													"<td style='width:33%'><input type='text'  name='commissionProportion' " +
											"value='"+data[i].commissionProportion+"%'  style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}
				index++;
				$("#tbodyInfoTr1").append("<tr><td style='width:33%'><input type='text'" +
						" value='"+data[i].principal.name+"' style='text-align:center'  readonly></td>" +
												"<td style='width:33%'><input type='text'  name='commissionProportion' " +
										"value='"+data[i].commissionProportion+"%'  style='text-align:center' readonly/></td></tr>");
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
});

function onchanges(obj) {
	if(obj.value.indexOf("%") != -1){
		obj.value=obj.value.replace(/%/g,'')+"%";
	}else{
		obj.value=obj.value+"%";
	}
	cumulative();
};
function cumulative(){
	var commissionProportion=$("input[name='commissionProportion']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
	
	/*var resultsProportion=$("input[name='resultsProportion']")
	var sum1=0;
	for(var i=0;i<resultsProportion.length;i++){
		if(resultsProportion[i].value!=null && resultsProportion[i].value!=undefined && resultsProportion[i].value!=''){
			sum1+=parseFloat(resultsProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative1").html(sum1+"%");*/
}
function openDialog2(obj) {	
	currTd = obj;
	$("#userDialog").openUserByDeptDialog();	
}
function getData2(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='uId']").val(data.id); 
        $(currTd).find("input[name='uName']").val(data.name);
    }
}
function getDeptName() {
    var deptName = $("#dutyDeptId").val();
    return deptName;
}
function fmoney(s, n) {
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + '').replace(/[^\d\.-]/g, '')).toFixed(n) + '';
	var l = s.split('.')[0].split('').reverse(), r = s.split('.')[1];
	var t = '';
	for (var i = 0; i < l.length; i++) {
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? ',' : '');
	}
	return t.split('').reverse().join('') + '.' + r;

}

/*function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}*/

// 金钱格式化
function initMoneyFormat() {
	var totalMoney = $("#totalMoney").val();
	if (totalMoney != null && totalMoney != '') {
		$("#totalMoney").val(fmoney(totalMoney, 0));
	}
	var applyMoney = $("#applyMoney").val();
	if (applyMoney != null && applyMoney != '') {
		$("#applyMoney").val(fmoney(applyMoney, 0));
	}
	var invoiceMoney = $("#invoiceMoney").val();
	if (invoiceMoney != null && invoiceMoney != '') {
		$("#invoiceMoney").val(fmoney(invoiceMoney, 0));
	}
	var actualPayMoney = $("#actualPayMoney").val();
	if (actualPayMoney != null && actualPayMoney != '') {
		$("#actualPayMoney").val(fmoney(actualPayMoney, 0));
	}
}

function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

var approveFalg = "";
function approve(status) {
	approveFalg = status;
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

/*******************************************************************************
 * 表单处理相关函数 *
 ******************************************************************************/
function save() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	/*var issubmit = $("#issubmit").val("0");// 区分保存和提交
	var checkMsg = checkForm(formData);
	if (!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return;
	}*/
	if (fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}
}

function submitForm() {
	var formData = getFormData();
	$.ajax({
		url : web_ctx + "/manage/sale/projectManageHistory/saveInfo",
		type : "post",
		data : JSON.stringify(formData),
		dataType : "json",
		contentType : "application/json",
		success : function(data) {
			if (data.code == 1) {
				var currUserId = $("#currUserId").val();
				var userId = $("#userId").val();
				var oper = $("#operStatus").val();
				var isHandler = $("#isHandler").val();
				var taskName = $("#taskName").val();

				if (oper == "重新申请" || oper == '同意' || oper == '不同意') {
					submitProcess();
				} else {
					backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete : function(data) {
			openBootstrapShade(false);
		}
	});
}

function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["projectMemberHistoryList"] = [];
	$("#tbodyInfoTr tr").each(
		function(index, tr) {
			var id = $(this).find("input[name='businessId']").val();
			var userId = $(this).find("input[name='uId']").val();
			/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
			var commissionProportion = $(this).find("input[name='commissionProportion']").val();
			var sorting=$(this).find("input[name='uId']").attr("data-sorting");
			if (!isNull(userId) || !isNull(commissionProportion)) {
				var memberList = {};
				memberList["id"] = id;
				memberList["userId"] = userId;
				memberList["sorting"] = sorting;
				/*memberList["resultsProportion"] = resultsProportion.replace(/%/g,'');*/
				memberList["commissionProportion"] = commissionProportion.replace(/%/g,'');
				formData["projectMemberHistoryList"].push(memberList);
			}
		});
	return formData;
}

function checkForm(formData) {
	var text = [];
	var barginCode = $.trim($("#barginCode").val());

	if (isNull(collectCompany)) {
		text.push("请填写收款单位！");
	} 
	
	return text;
}

// 调用发送邮件的方法
function sendMail() {
	var comment = $("#comment").val();
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/projectManageHistory/sendMail",
		"dataType" : "json",
		"data" : {
			"id" : $("#id").val(),
			"contents" : comment
		}
	});
}

function submitProcess() {
	var variables = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variables);
	var operStatus = $("#operStatus").val();
	
	if (compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		$("#currStatus").val(status)
		if (statusResult.code == 1) {
			var text = "操作成功！";
			if (approveFalg == "不同意") {
				//sendMail();
			}
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
			bootstrapAlert("提示", statusResult.result, 400, null);
		}
	} else if (compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}

	validate();
	openBootstrapShade(false);
}

// 取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if (result != null) {
			if (result.code == 1) {
				var statusResult = setStatus("6");
				if (statusResult.code == 1) {
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

function openProject() {
	$("#projectDialog").openProjectDialog();
}

function getProjectData(data) {
	if (!isNull(data) && !$.isEmptyObject(data)) {
		$("#projectManageName").val(data.name);
		$("#projectManageId").val(data.id);
	}
}

/*
 *  审批状态 0： 重新申请 1：项目负责人审批 2：部门主管审批 3：财务审批 4：总经理审批 5：已归档  6：取消申请 7：项目负责人不同意 8：部门主管不同意
 * 9：财务不同意 10：总经理不同意 
 */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();

	if ($("#operStatus").val() == "同意") {
		status = approvedStatus[currStatus];
	} else if ($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	} else {
		status = "1";
	}

	return status;
}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/projectManageHistory/setStatusNew",
		"dataType" : "json",
		"async" : false,
		"data" : {
			"id" : id,
			"status" : status
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

/*function setStatusNew(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/projectManageHistory/setStatusNew",
		"dataType" : "json",
		"async" : false,
		"data" : {
			"id" : id,
			"status" : status
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
}*/

function getVariables() {
	var commentList = variables.commentList;
	if (isNull(commentList)) {
		commentList = [];
	}

	var operStatus = $("#operStatus").val();
	var form = {
		"node" : getNodeInfo(),
		"approver" : $("#approver").val(),
		"comment" : operStatus != "提交" ? $("#comment").val() : "",
		"approveResult" : "",
		"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
	};
	form["approveResult"] = nodeOnOper[operStatus];
	commentList.push(form);
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
			|| operStatus == "提交" || operStatus == "结束流程" ? true : false;

	return variables;
}

function updateBarginInfo(id, unpayMoney, payMoney, payUnreceivedInvoice,
		payReceivedInvoice) {
	var json = {
		"id" : id,
		"unpayMoney" : unpayMoney,
		"payMoney" : payMoney,
		"payUnreceivedInvoice" : payUnreceivedInvoice,
		"payReceivedInvoice" : payReceivedInvoice
	};

	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/barginManage/updateBarginInfo",
		"dataType" : "json",
		"contentType" : "application/json;charset=UTF-8",
		"data" : JSON.stringify(json),
		"success" : function(data) {
			if (data != null && data.code != 1) {
				bootstrapAlert("提示", "操作失败！", 400, null);
			}
		},
		"error" : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function findBarginById(id) {
	var barginResult = {};
	$
			.ajax({
				"type" : "POST",
				"url" : web_ctx + "/manage/sale/barginManage/findById",
				"dataType" : "json",
				"data" : {
					"id" : id
				},
				"async" : false,
				"success" : function(data) {
					barginResult["unpayMoney"] = data.result.unpayMoney;
					barginResult["payMoney"] = data.result.payMoney;
					barginResult["payUnreceivedInvoice"] = data.result.payUnreceivedInvoice;
					barginResult["payReceivedInvoice"] = data.result.payReceivedInvoice;
				},
				"error" : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
	return barginResult;
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
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/finance/pay/deleteAttach",
				data : {
					"path" : $("#attachments").val(),
					"id" : $("#id").val()
				},
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
						});
					} else {
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
				error : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}

			});
		}, null);
	} else {
		bootstrapAlert("提示", "无附件！", 400, null);
	}
}

// 文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path" : "pay/" + date.getFullYear() + (date.getMonth() + 1)
				+ date.getDate(),
		"deleteFile" : $("#attachments").val()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload(
			{
				url : web_ctx + '/fileUpload?' + urlParam,
				dataType : 'json',
				formData : params,
				maxFileSize : 50 * 1024 * 1024, // 50 MB
				messages : {
					maxFileSize : '附件大小最大为50M！'
				},
				add : function(e, data) {
					var $this = $(this);
					data.process(function() {
						return $this.fileupload('process', data);
					}).done(function() {
						fileData = data;
						$("#showName").val(data.files[0].name);
					}).fail(
							function() {
								var errorMsg = [];
								$(data.files).each(function(index, file) {
									errorMsg.push(file.error);
								});
								bootstrapAlert("提示", errorMsg.join("<br/>"),
										400, null);
							});
				},
				done : function(e, data) {
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

/*
 * 初始化相关操作
 */
function inittextarea() {
	autosize(document.querySelectorAll('textarea'));
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if (isNull(commentList)) {
		commentList = [];
	}

	for (var i = commentList.length - 1; i >= 0; i--) {
		if(commentList.length>=2){
			if(commentList[0].approver == commentList[1].approver && commentList[i].node =='项目负责人'){
				continue;
			}
		}
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
			html.push(new Date(commentList[i].approveDate)
					.pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g, "/")))
					.pattern("yyyy-MM-dd HH:mm"));
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

function initInputMask() {
	// $("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#actualPayMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#bankAccount").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0}"
	});
}

function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/pay/pdf"
	}
	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}