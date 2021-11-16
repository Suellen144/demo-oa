var projectObj = null;
var investList = [];
var index=0;
var sumCount=10000


// 同意后的下一状态
var approvedStatus = {
	"0" : "1",
	"1" : "2",
	"2" : "3",
	"3" : "4",
	"4" : "5",
	"5" : "6",
	"11" : "4"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0" : "7",
	"1" : "8",
	"2" : "9",
	"3" : "10",
	"4" : "11",
	"5" : "12",
	"11" : "10" // 总经理不同意后流程到达复核人，所以 11 与 3 等同看待
};
// 环节与状态的映射
var nodeOnStatus = {
	"0" : "提交申请",
	"1" : "部门经理",
	"2" : "经办",
	"3" : "复核",
	"4" : "总经理",
	"5" : "出纳",
	"6" : "审批通过",
	"7" : "取消申请",
	"8" : "提交申请",
	"9" : "提交申请",
	"10" : "提交申请",
	"11" : "复核",
	"12" : "提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
	"提交" : "提交成功",
	"重新申请" : "申请成功",
	"同意" : "通过",
	"不同意" : "不通过",
	"取消申请" : "取消申请"
};

$(function() {
	initInput();
	initTaskComment();
	actReimburseCount();
	moneyCount();
	initDecryption();
	updatereimbursetotal();
	$("#projectDialog").initProjectDialog({
		"callBack" : getProject
	});

	$("#deptDialog").initDeptDialog({
		"callBack" : getDept
	});

	if (formElement || editInvest) {
		initInput();
		initDatetimepicker();
		initInputMask();
		initFileUpload();
		initInvest();
	} else {
		initInvest();
	}

	var assistantStatus = $("#assistantStatus").val();
	if (!isNull(assistantStatus) && assistantStatus == '1') {
		$("#submitBtn").hide();
	}
});

function openProject(obj) {
	if (isNull($(obj).val())) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = $(obj).parents("li[name='node']").prev("li[name='node']");

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
}

function openDept() {
	$("#deptDialog").openDeptDialog();
}

function showhelp() {
	$("#helpModal").modal("show");
}

function getProject(data) {
	if (!isNull(data) && !isNull(projectObj) && !$.isEmptyObject(data)) {
		$(projectObj).next("input[name='projectId']").val(data.id);
		$(projectObj).val(data.name);
	}
}

function getDept(data) {
	if (!isNull(data)) {
		$("#deptId").val(data.id);
		$("#deptName").val(data.name);
	}
}

function initDatetimepicker() {
	$("input.date").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});
}

/*// 初始化文本域
function inittextarea() {
	autosize(document.querySelectorAll('textarea'));
}*/

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

/* 更新通用报销合计 */

function updatereimbursetotal() {
	var cost = []; // 项目费用数据
	var receive = [];
	var other = [];
	var projectName = [];
	var temp = [];
	var key; // 项目索引Key
	var sum = [];
	// 差旅统计map
	var costmap = {};
	// 招待统计map
	var receivemap = {};
	// 其他统计map
	var othermap = {};
	costmap["key"] = "value";
	receivemap["key"] = "value";
	$("li[name='node']").each(function(index, tr) {
		project = $(tr).find("textarea[name='projectName']").val();
		if (project != "") {
			temp.push(project);
		}
	});
	projectName = unique(temp);

	$("li[name='node']").each(function(index, tr) {
		project = $(tr).find("textarea[name='projectName']").val();
		actReimburse = $(tr).find("input[name='actReimburse']").val();
		type = $(tr).find("select[name='type']").val();
		if (type == undefined) {
			type = $(tr).find("input[name='typevalue']").val();
		}
		if (type == "4") {
			key = project;
			cost.push(actReimburse);
			receive.push(actReimburse);
			other.push(actReimburse);
			if (costmap[key] == undefined) {
				costmap[key] = cost[index];
			} else {
				total = digitTool.add(costmap[key], cost[index]);
				costmap[key] = total;
			}
		} else if (type == "2" || type == "1") {
			key = project;
			cost.push(actReimburse);
			receive.push(actReimburse);
			other.push(actReimburse);
			if (receivemap[key] == undefined) {
				receivemap[key] = receive[index];
			} else {
				total = digitTool.add(receivemap[key], receive[index]);
				receivemap[key] = total;
			}
		} else {
			key = project;
			cost.push(actReimburse);
			receive.push(actReimburse);
			other.push(actReimburse);
			if (othermap[key] == undefined) {
				othermap[key] = other[index];
			} else {
				total = digitTool.add(othermap[key], other[index]);
				othermap[key] = total;
			}
		}
	});

	$(projectName).each(function(index, value) {
		sum.push('<li class="clearfix">');
		sum.push('<div class="col-xs-12">');
		sum.push('<div class="mFormName">报销项目</div>');
		sum.push('<div class="mFormMsg">');
		sum.push('<div class="mFormShow" href="#intercityCost1' + sumCount+ '" data-toggle="collapse" data-parent="#accordion">');
		sum.push('	<div class="mFormSeconMsg">');
		sum.push('<span>'+value+'</span>');
		sum.push('</div>');
		sum.push('</div>');	
		sum.push('<div class="mFormToggle panel-collapse collapse" id="intercityCost1'+ sumCount + '">');
		sum.push('<div class="mFormToggleConn">');
		sum.push('<div class="mFormXSToggleConn">');
		sum.push('<div class="mFormXSName">项目</div>');
		sum.push('<div class="mFormXSMsg">');
		sum.push('<input type="text"  class="longInput"  value="'+value+'">');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('<div class="mFormXSToggleConn">');
		sum.push('<div class="mFormXSName">差旅统计</div>');
		sum.push('<div class="mFormXSMsg">');
		if(costmap[value] == undefined){
			sum.push('<input type="text"  class="longInput"  value="0">');
		}
		else {
			sum.push('<input type="text"  class="longInput"  value="'+costmap[value]+'">');
		}
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('<div class="mFormToggleConn">');
		sum.push('<div class="mFormXSToggleConn">');
		sum.push('<div class="mFormXSName">招待统计</div>');
		sum.push('<div class="mFormXSMsg">');
		if(receivemap[value] == undefined){
			sum.push('<input type="text"  class="longInput"  value="0">');
		}
		else{
			sum.push('<input type="text"  class="longInput"  value="'+receivemap[value]+'">');
		}
		sum.push('</div>');
		sum.push('</div>');
		sum.push('<div class="mFormXSToggleConn">');
		sum.push('<div class="mFormXSName">其他费用</div>');
		sum.push('<div class="mFormXSMsg">');
		if(othermap[value] == undefined){
			sum.push('<input type="text"  class="longInput"  value="0">');
		}
		else{
			sum.push('<input type="text"  class="longInput"  value="'+othermap[value]+'">');
		}
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</div>');
		sum.push('</li>');
	});
	$("#ulForm li:last").after(sum.join(""));
}

/*
 * function initrecive(){
 * 
 * $("tr[name='node']").each(function(i, tr) { project =
 * $(tr).find("textarea[name='projectName']").val(); actReimburse =
 * $(tr).find("input[name='actReimburse']").val(); type =
 * $(tr).find("select[name='type']").val(); if (type == "2") { key = project;
 * receive.push(actReimburse); if(receivemap[key] == undefined){ receivemap[key] =
 * receive[i]; } else { total = digitTool.add(receivemap[key],receive[i]);
 * receivemap[key] = total; }
 *  } }); }
 */

// 初始化输入框约束
function initInputMask() {
	$("li[name='node']").find("input").each(
			function(index, input) {
				var name = $(input).attr("name");
				if (name == "money" || name == "actReimburse") {
					$(input).inputmask("Regex", {
						regex : "\\d+\\.?\\d{0,2}"
					});
				} else if (name == "bankAccount") {
					$(input).inputmask("Regex", {
						regex : "\\d+\\?\\d{0,0}"
					});
				}
			});
}

function initInput() {
	// 初始化核报金额
	var cost = $("#cost").val();
	$("#costcn").val(digitUppercase(cost));

	// 初始化合计
	var total = 0;
	$("input[name='money']").each(function(index, input) {
		var value = $(input).val();
		if (!isNull(value)) {
			value = clearZero(value);
			$(input).val(value);
			total = digitTool.add(total, parseFloat(value));
		}
	});
	$("#total").val(total);

}

// 如果value后缀只有一个.0，则去掉.0
var suffixZero = /.*\.0$/;
function clearZero(value) {
	if (suffixZero.test(value)) {
		return value.replace(".0", "");
	} else {
		return value;
	}
}

function toUppercase(value) {
	$("#costcn").inputmask("Regex", {
		regex : ".*"
	});
	if (!isNull(value)) {
		$("#costcn").val(digitUppercase(value));
		$("#cost").val(value);
	} else {
		$("#costcn").val("零元整");
		$("#cost").val("0");
	}
}

function toLowercase(obj) {
	$("#costcn").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,2}"
	});
	var value = $("#cost").val();
	$("#costcn").val(value);
	$(obj).trigger("select");
}

function actReimburseCount() {
	var count = 0;
	var total = 0;
	$("li[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		var value = "";
		if (!isNull(actReimburse)) {
			value = actReimburse;
			total = digitTool.add(total, parseFloat(value));
		} else {
			value = $(tr).find("input[name='money']").val();
		}

		if (isNull(value)) {
			value = "0";
		}
		count = digitTool.add(count, parseFloat(value));
	});

	if (total == 0) {
		$("#actReimburseTotal").text("");
	} else {
		$("#actReimburseTotal").text(total);
	}
	toUppercase(count);
}

function moneyCount() {
	var total = 0;
	$("input[name='money']").each(function(index, input) {
		var value = $(input).val();
		if (isNull(value)) {
			value = "0";
		}
		total = digitTool.add(total, parseFloat(value));
	});

	if (total == 0) {
		$("#moneyTotal").val("");
	} else {
		$("#moneyTotal").val(total);
	}
}

function moneyBlur(obj) {
	var td = $(obj).closest(".mFormXSToggleConn");
	var actReimbruseObj = $(td).next(".mFormXSToggleConn").find("input[name='actReimburse']");
	if( isNull($(actReimbruseObj).val()) ) {
		var value = $(obj).val();
		$(actReimbruseObj).val(value);
	}
	var value = $(obj).val();
	$(actReimbruseObj).val(value);
	$(actReimbruseObj).trigger("keyup");
}

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["reimburseAttachList"] = [];

	$("li[name='node']").each(
			function(index, tr) {
				var id = $(this).find("input[name='reimburseAttachId']").val();
				var date = $(this).find("input[name='date']").val();
				var place = $(this).find("input[name='place']").val();
				var projectId = $(this).find("input[name='projectId']").val();
				var reason = $(this).find("textarea[name='reason']").val();
				var type;
				if (!isNull($(this).find("select[name='type']").val())) {
					type = $(this).find("select[name='type']").val()
				} else {
					type = $(this).find("input[name='type']").val()
				}
				var money = $(this).find("input[name='money']").val();
				var actReimburse = $(this).find("input[name='actReimburse']")
						.val();
				var detail = $(this).find("textarea[name='detail']").val();
				var investId = $(this).find("select[name='investId']").val();

				// 其中一个有值就算有效表单数据
				if (!isNull(date) || !isNull(place) || !isNull(reason)
						|| !isNull(money) || !isNull(detail)
						|| !isNull(projectId) || !isNull(investId)) {
					var data = {};
					data["id"] = id;
					data["date"] = date;
					data["place"] = place;
					data["projectId"] = projectId;
					data["reason"] = reason;
					data["type"] = type;
					data["money"] = money;
					data["actReimburse"] = actReimburse;
					data["detail"] = detail;
					data["investId"] = investId;

					formData["reimburseAttachList"].push(data);
				}
			});

	return formData;
}

function checkForm(formData) {
	var checkMsg = [];

	if (isNull(formData["reimburseAttachList"])) {
		checkMsg.push("至少有一条报销项！");
	}
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if (isNull(data["date"])) {
			checkMsg.push("日期不能为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if (isNull(data["place"])) {
			checkMsg.push("地点不能为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if (isNull(data["money"]) && isNull(data["actReimburse"])) {
			checkMsg.push("金额与实报不能同时为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if (isNull(data["projectId"])) {
			checkMsg.push("项目不能为空！");
			return false;
		}
	});

	return checkMsg;
}

function approve(status) {
	if (status == 1) {
		$("#operStatus").val("提交");
		update();
	} else if (status == 2) {
		$("#operStatus").val("同意");
		if (editInvest) {
			update();
		} else {
			update();
			submitProcess();
		}
	} else if (status == 3) {
		$("#operStatus").val("不同意");
		if (editInvest) {
			update();
		} else {
			submitProcess();
		}
	} else if (status == 4) {
		$("#operStatus").val("重新申请");
		update();
	} else if (status == 5) {
		$("#operStatus").val("取消申请");
		cancelProcess();
	}
}

function update() {
	// 先验证表单（checkForm）
	if ($("#operStatus").val() == "重新申请") {
		$("#assistantStatus").val("");
	}
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if (!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return;
	}

	if (fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		submitForm(formData);
	}

}

function save() {
	// 先验证表单（checkForm）
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if (!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return;
	}

	if (fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
		/* bootstrapAlert("提示", "保存成功 ！", 400, null); */
	}
}

function submitForm(formData) {
	$.ajax({
		url : web_ctx + "/manage/finance/reimburs/saveOrUpdate",
		type : "POST",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(formData),
		dataType : "json",
		success : function(data) {
			openBootstrapShade(false);
			if (data.code == 1) {
				submitBankInfo();
				if ($("#operStatus").val() == "提交") {
					backPageAndRefresh();
					/*
					 * bootstrapAlert("提示", "提交成功 ！", 400, function() {
					 * backPageAndRefresh(); });
					 */
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
		error : function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variablesTemp);

	if (compResult.code == 1) {
		var status = getNextStatus();
		$.ajax({
			"type" : "POST",
			"url" : web_ctx + "/manage/finance/reimburs/setStatus",
			"dataType" : "json",
			"data" : {
				"id" : $("#id").val(),
				"status" : status
			},
			"success" : function(data) {
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
				/*
				 * bootstrapAlert("提示", text, 400, function() {
				 * backPageAndRefresh(); });
				 */
			},
			"error" : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	} else if (compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
}

var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path" : "reimburs/" + date.getFullYear() + (date.getMonth() + 1)
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

						var formData = getFormJson();
						submitForm(formData);
					} else {
						openBootstrapShade(false);
						bootstrapAlert("提示", "保存文件失败，错误信息："
								+ result.execResult.result, 400, null);
					}
				},
				processfail : function(e, data) {
					var currentFile = data.files[data.index];
					if (data.files.error && currentFile.error) {
						console.log(currentFile.error);
					}
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
			|| operStatus == "提交" ? true : false;

	return variables;
}

/**
 * 获取流程下一审批状态 审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请
 * 8：部门经理不同意 9：经办不同意 10：复核不同意 11：总经理不同意 12：出纳不同意
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
		} else if (this.status == 500) {
			bootstrapAlert("提示", this.statusText, 400, null);
		}
	}
	xhr.send();
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

// 取消流程
function cancelProcess() {
	var taskId = $("#taskId").val();
	var id = $("#id").val();
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		setTaskVariables();
		var result = endProcessInstance(taskId);
		if (result != null) {
			if (result.code == 1) {
				setStatus(id);
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}

function setStatus(id) {
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/finance/reimburs/setStatus",
		"dataType" : "json",
		"data" : {
			"id" : id,
			"status" : "7"
		},
		"success" : function(data) {
			if (data.code == 1) {
				bootstrapAlert("提示", "取消申请成功！", 400, function() {
					backPageAndRefresh();
				});
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		"error" : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function setTaskVariables() {
	var taskId = $("#taskId").val();
	var variables = getVariables();
	variables["taskId"] = taskId;

	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/activiti/setTaskVariables",
		"contentType" : "application/json",
		"dataType" : "json",
		"async" : false,
		"data" : JSON.stringify(variables),
		"success" : function(data) {
		},
		"error" : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

// 市场助手在部门经理审批前确认
function assistantAffirm() {
	bootstrapConfirm("提示", "是否确定？", 300, function() {
		var taskId = $("#taskId").val();
		var commentList = variables.commentList;
		if (isNull(commentList)) {
			commentList = [];
		}

		var form = {
			"node" : '市场助手',
			"approver" : $("#approver").val(),
			"comment" : $("#comment").val(),
			"approveResult" : "确认",
			"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
		};
		commentList.push(form);
		variables["commentList"] = commentList; // 批注列表
		variables["taskId"] = taskId;

		$.ajax({
			"type" : "POST",
			"url" : web_ctx + "/activiti/setTaskVariables",
			"contentType" : "application/json",
			"dataType" : "json",
			"data" : JSON.stringify(variables),
			"success" : function(data) {
				if (data.code == '1') {
					setAssistantAffirm();
				}
			},
			"error" : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}

function setAssistantAffirm() {
	$.ajax({
		url : web_ctx + "/manage/finance/reimburs/setAssistantAffirm",
		data : {
			"id" : $("#id").val(),
			"assistantStatus" : '1'
		},
		type : "post",
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.code == 1) {
				backPageAndRefresh();
			}
		},
		error : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}

	});
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
				url : web_ctx + "/manage/finance/reimburs/deleteAttach",
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


// 新增或删除一个“行程”表格行
function node(oper, obj) {
	if (oper == "del") {
		$(obj).closest('.parentli').remove();
	} else {
		var html;
		var status = $("#currStatus").val();
		if (seeall && status > 7) {
			html = getOtherHtml();

		} else if (seeall) {
			html = getNodeHtml();
		} else {
			html = getOtherHtml();
		}

		$(obj).closest('.parentli').after(html);
		$(obj).attr("onclick", "node('del', this)");
		$(obj).html('<img alt="删除" src="' + base + '/static/images/del.png">');
		
		initDatetimepicker();
		/*inittextarea();*/
		initInputMask();
	}
}



// 改变出差城市的值
function changeText(obj, value) {
	$($(obj).closest('.parentli')).find('.mFormSeconMsg:eq(1)').text(value)
}

function changeText1(obj, value) {
	var str = $(obj).prev().text();
	var ob = $(($(obj).closest('.parentli')).find('.mFormSeconMsg:eq(0)'))
			.find('span');
	ob.text(value);

}

function getNodeHtml(){
	var html = [];
	html.push('<li class="clearfix parentli" name="node">');
	html.push('<div class="col-xs-12">');
	html.push('<div class="mFormName">报销条目</div>');
	html.push('<div class="mFormMsg firstMsg">');
	html.push('<div class="mFormShow secondMsg" onclick="changeImage(this)" href="#intercityCost1' + index
			+ '" data-toggle="collapse" data-parent="#accordion">');
	html.push('	<div class="mFormSeconMsg">');
	html.push('<span>日期</span>');
	html.push('</div>');
	html.push('<div class="mFormSeconMsg">');
	html.push('地点');
	html.push('</div>');
	html.push('<div class="mFormArr current">');
	html.push('	<img src="' + base + '/static/dist/img/oa/arr.png" alt="">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormOpe" onclick="node(\'add\',this)">');
	html.push('<img src="' + base + '/static/images/add.png" alt="添加">');
	html.push('</div>');
	html.push('<div class="mFormToggle panel-collapse collapse thirdMsg" id="intercityCost1'+ index + '">');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">地点</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<input type="text" name="place" class="longInput"   onchange="changeText(this,value)">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">项目</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<c:choose>');
	html.push('<textarea name="projectName"  onclick="openProject(this)"  readonly></textarea>');
	html.push('<input type="hidden" name="projectId" value="">');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">日期</div>');
	html.push('<div class="mFormXSMsg" style="font-size:12px;color: gray;">');
	html.push('<input type="text" name="date" class="date longInput" onchange="changeText1(this,value)"   readonly>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">类别</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<select name="type" class="mSelect">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">金额</div>');
	html.push('<div class="mFormXSMsg" style="font-size:12px;color: gray;">');
	html.push('<input type="text" name="money" class="longInput"   onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">实报</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<input type="text"  name="actReimburse" class="longInput"  value=""   onkeyup="actReimburseCount()" onfocus="this.select()">');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn" >');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName" >明细</div>');
	html.push('<div class="mFormMsg" style="border-bottom: none">');
	html.push('<textarea name="detail"  autocomplete="off"></textarea>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">费用归属</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<select name="investId"  class="mSelect" style="width:100%;font-size:12px">');
	html.push('<option value=""></option>');
	$(investList).each(function(index, invest) {
		html.push('<option value="'+invest.id+'">'+invest.value+'</option>');
	});
	html.push('</select>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn" style="position: relative;" >');
	html.push('<div class="mFormXSToggleConn" style="position: absolute;top: 0;left: 5px">');
	html.push('<div class="mFormXSName">事由</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<textarea name="reason"></textarea>');
	html.push('</div>');
	html.push('</div>');
 	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</li>');
	index++;
	return html.join("");
}

function getOtherHtml() {
	var html = [];
	html.push('<li class="clearfix parentli" name="node">');
	html.push('<div class="col-xs-12">');
	html.push('<div class="mFormName">报销条目</div>');
	html.push('<div class="mFormMsg firstMsg">');
	html.push('<div class="mFormShow secondMsg" onclick="changeImage(this)" href="#intercityCost1' + index
			+ '" data-toggle="collapse" data-parent="#accordion">');
	html.push('	<div class="mFormSeconMsg">');
	html.push('<span>日期</span>');
	html.push('</div>');
	html.push('<div class="mFormSeconMsg">');
	html.push('地点');
	html.push('</div>');
	html.push('<div class="mFormArr current">');
	html.push('	<img src="' + base + '/static/dist/img/oa/arr.png" alt="">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormOpe" onclick="node(\'add\',this)">');
	html.push('<img src="' + base + '/static/images/add.png" alt="添加">');
	html.push('</div>');
	html.push('<div class="mFormToggle panel-collapse collapse" id="intercityCost1'+ index + '">');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">地点</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<input type="text" name="place" class="longInput"   onchange="changeText(this,value)">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">项目</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<c:choose>');
	html.push('<textarea name="projectName" style="resize: none;" onclick="openProject(this)"  readonly></textarea>');
	html.push('<input type="hidden" name="projectId" value="">');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">日期</div>');
	html.push('<div class="mFormXSMsg" style="font-size:12px;color: gray;">');
	html.push('<input type="text" name="date" class="date longInput" onchange="changeText1(this,value)"   readonly>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">类别</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<select name="type" class="mSelect">>');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">金额</div>');
	html.push('<div class="mFormXSMsg" style="font-size:12px;color: gray;">');
	html.push('<input type="text" name="money" class="longInput"   onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">实报</div>');
	html.push('<div class="mFormXSMsg">');
	html.push('<input type="text"  name="actReimburse" class="longInput"  value=""   onkeyup="actReimburseCount()" onfocus="this.select()">');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormToggleConn" >');
	html.push('<div class="mFormXSToggleConn" style="border-bottom: none">');
	html.push('<div class="mFormXSName" >明细</div>');
	html.push('<div class="mFormMsg" style="border-bottom: none">');
	html.push('<textarea name="detail"  autocomplete="off"></textarea>');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">事由</div>');
	html.push('<div class="mFormMsg" style="border-bottom: none">');
	html.push('<textarea name="reason" onfocus="reasonChange(this)" ></textarea>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</li>');
	index++;
	return html.join("");
}

function reasonChange(obj) {
	if (isNull($(obj).val())) {
		var tr = $(obj).parents("li[name='node']").prev("li[name='node']");

		/*
		 * if(tr.length >0 && !isNull(
		 * $(tr).find("textarea[name='reason']").val())){ $(obj).val(
		 * $(tr).find("textarea[name='reason']").val() ); }
		 */
	}
}



// 初始化select2
function initSelect() {
	var isDigit = /^\d+(\d\s)?.*\d+$/;
	$(".select2").select2({
		tags : true,
		allowClear : true,
		placeholder : "请选择一项或输入值后回车"
	});
	$(".select2").on("select2:select", function(evt) {
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

	$(".select2").on("change", function(evt) {
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
		"type" : "GET",
		"url" : web_ctx + "/manage/finance/travelReimburs/getBankInfo?userId="
				+ $("#userId").val(),
		"dataType" : "json",
		"success" : function(data) {
			if (!isNull(data)) {
				$(data).each(
						function(index, value) {
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

function initInvest() {
	$
			.ajax({
				"type" : "GET",
				"url" : web_ctx
						+ "/manage/finance/reimburs/getInvestList?date="
						+ new Date().getTime(),
				"dataType" : "json",
				"success" : function(data) {
					if (!isNull(data)) {
						investList = data;
						$("li[name='node']")
								.find("select[name='investId']")
								.each(
										function(index, select) {
											var investValue = $(select).attr(
													"value");
											var html = [];
											html
													.push('<option value="-1"></option>');
											$(investList)
													.each(
															function(index,
																	invest) {
																html
																		.push('<option value="'
																				+ invest.id
																				+ '" '
																				+ (investValue == invest.id ? "selected"
																						: "")
																				+ '>'
																				+ invest.value
																				+ '</option>');
															});
											$(select).append(html.join(""));
										});
					}
				}
			});
}

// 提交收款人、银行的相关信息作为历史数据
function submitBankInfo() {
	var json = {
		"userId" : $("#userId").val(),
		"payee" : $("#payee").val(),
		"bankAccount" : $("#bankAccount").val(),
		"bankAddress" : $("#bankAddress").val()
	};

	$.ajax({
		url : web_ctx + "/manage/finance/travelReimburs/saveBankInfo",
		type : "post",
		data : json
	});
}

/** *********** 加解密操作 Begin ************* */
// 如果有解密权限，则解密当前已加密的数据
function initDecryption() {
	if ('y' == $("#encrypted").val()) {
		if ("resubmit" == submitPhase) {
			$("textarea[name='reason'],textarea[name='detail']").each(
					function(index, textarea) {
						$(textarea).text("");
					});
			$("#encrypted").val("n");
		} else {
			if (hasDecryptPermission) {
				var now = new Date().pattern("yyyyMMdd");
				$.ajax({
					url : web_ctx + '/manage/getEncryptionKey?baseKey=' + now
							+ "&date=" + new Date().getTime(),
					type : 'GET',
					success : function(data) {
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
			function(index, textarea) {
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
	$("li[name='node']").each(function(index, tr) {
		var id = $(tr).find("input[name='reimburseAttachId']").val();
		if (!isNull(id)) {
			$(tr).find("textarea[name='reason']").prop("readonly", true);
			$(tr).find("textarea[name='detail']").prop("readonly", true);
		}
	});
}

function lock() {
	var params = {};
	var reimburseAttachList = getUnLockData();
	params['id'] = $('#id').val();
	params['reimburseAttachList'] = reimburseAttachList;

	$.ajax({
		url : web_ctx + '/manage/finance/reimburs/lock',
		type : 'POST',
		contentType : 'application/json;charset=utf-8;',
		dataType : 'JSON',
		data : JSON.stringify(params),
		success : function(data) {
			if (data.code == 1) {
				bootstrapAlert('提示', data.result, 400, function() {
					refreshPage();
				});
			} else {
				bootstrapAlert('提示', data.result, 400, null);
			}
		},
		error : function(err, errMsg) {
			bootstrapAlert('提示', '加密失败，请联系管理员！', 400, null);
		}
	});
}
function getUnLockData() {
	var dataList = [];
	$("li[name='node']").each(function(index, tr) {
		var data = {};
		data['id'] = $(tr).find("input[name='reimburseAttachId']").val();
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
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/reimburs/print"
	}

	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}

function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/reimburs/pdf"
	}

	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}


function changeImage(obj){
	$(obj).find(".mFormArr").toggleClass("current")
}
