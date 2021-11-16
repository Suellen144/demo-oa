var currTd = null;
var index = 0;
/*
 * 审批状态 0：提交申请  1:项目负责人审批 2：部门经理审批 3：财务审批 4：总经理审批 5：财务总监审批 6：审批通过 7：取消申请 8：项目负责人不同意 9：部门经理不同意 10：财务不同意
 * 11：总经理不同意 12：财务总监不同意 13：财务审批
 */
// 同意后的下一状态
var approvedStatus = {
	"0" : "1",
	"1" : "2",
	"2" : "3",
	"3" : "4",
	"4" : "13",
	"13" : "5",
	"5" : "6"
};

// 不同意后的下一状态
var notApprovedStatus = {
	"0" : "7",
	"1" : "8",
	"2" : "9",
	"3" : "10",
	"4" : "11",
	"13" : "10",
	"5" : "12",
};

// 环节与状态的映射
var nodeOnStatus = {
	"0" : "提交申请",
	"1" : "项目负责人",
	"2" : "部门经理",
	"3" : "财务",
	"4" : "总经理",
	"13" : "财务",
	"5" : "财务总监",
	"6" : "审批通过",
	"7" : "取消申请",
	"8" : "提交申请",
	"9" : "提交申请",
	"10" : "提交申请",
	"11" : "提交申请",
	"12" : "提交申请",
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
	initDatetimepicker();
	initInputMask();
	initTaskComment();
    inittextarea();
//	initinvoiced();
	initInputBlur();
	initFileUpload();
//	initCompareBillWithBillCollection();
	coutmoney();
	initMenu();
	confirmWayOnchange();
	if (editInvest) {
		initNode();
	}

	initAdd();
	$("#barginDialog").initBarginDialog({
		"callBack" : getBargin
	});

//	if ($("#barginId").val() != null && $("#barginId").val() != "") {
//		$("#viewBarginBtn").show();
//	}

	$("#projectDialog").initProjectDialog({
		"callBack" : getProject
	});

	$("tr[name='add']").each(function(index, tr) {
		var levied = rmoney($(tr).find("input[name='levied']").val());
		if (!isNull(levied)) {
			$(tr).find("input[name='levied']").val(fmoney(levied, 0));
		}
	});
	$("tr[name='node']").each(
			function(index, tr) {
				var collectionBill = $(tr).find("input[name='collectionBill']")
						.val();
				if (!isNull(collectionBill)) {
					$(tr).find("input[name='collectionBill']").val(
							fmoney(collectionBill, 0));
				}
			});
	if (!isNull($("#bill").val())) {
		$("#bill").val(fmoney($("#bill").val(), 0))
	}
	$("#totalPay").val(fmoney($("#totalPay").val(), 0));
	$("#applyPay").val(fmoney($("#applyPay").val(), 2))
	countAll();
	/*initUnCollection();*/
	  /* 用户 */
    $("#userDialog").initUserDialog({
        "callBack": getData
    });
	 //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/finance/invoiceProjectMembers/getList",
		type: "post",
		data: {finInvoicedId:$("#id").val(),barginManageId:$("#barginManageId").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tableTbody").append("<tr name='node1' class='node1'><td style='width:33%'>"+data[i].sysUser.name+"<input type='hidden'  " +
							"name='userIdParticipate' value='"+data[i].sysUser.id+"' data-sorting='"+index+"'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td>" +
											"<td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()'" +
											"  title='0%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}else{
					$("#tableTbody").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog(this)'><input type='text' name='userName'" +
							" value='"+data[i].sysUser.name+"' style='text-align:center'  readonly><input type='hidden'  name='userIdParticipate' value='"+data[i].sysUser.id+"' " +
									" data-sorting='"+index+"' style='text-align:center'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td>" +
													"<td style='width:33%'><input type='text'  name='commissionProportion' " +
											"value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()' title='0%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}
				index++;
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	if($("#confirmAmount").val() == null || $("#confirmAmount").val() == ''){
		$("#confirmAmount").val($("input[name='total']").val());
	}
	if($("#resultsAmount").val() == null || $("#resultsAmount").val() == ''){
		$("#resultsAmount").val($("input[name='total']").val());
	}
	$("#invoiceAmount").val(initInputMask($("#invoiceAmount").val()));
	if(!isNull($("#totalMoney").val()) && !isNull($("#invoiceAmountTo").val()) && $("#totalMoney").val() != "0" ){
		$("#alreadyInvoiceProportion").val((digitTool.divide($("#invoiceAmountTo").val(), $("#totalMoney").val()) * 100).toFixed(2) + "%");
	}else{
		$("#alreadyInvoiceProportion").val("0%");
	}
	initInputBlur1();
});

function initInputBlur1() {
	var totalmoney = rmoney($("#totalMoney").val());
	var invoiceAmount = rmoney($("#invoiceAmount").val());
	if (!isNull(totalmoney) && !isNull(invoiceAmount) && totalmoney != "0") {
		$("#invoiceProportion").val(
				(digitTool.divide(invoiceAmount, totalmoney) * 100).toFixed(2) + "%");
	}

}

function confirmWayOnchange() {
	var confirmWayVal = $("#confirmWay").val();
	if(confirmWayVal == '1') {
		$("#shareStartDate").attr("readonly","readonly");
		$("#shareEndDate").attr("readonly","readonly");
	}else {
		$("#shareStartDate").attr("readonly","");
		$("#shareEndDate").attr("readonly","");
	}
}

function openDialog(obj) {
    currTd = obj;
    $("#userDialog").openUserDialog();
}
function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userName']").val(data.name);
        $(currTd).find("input[name='userIdParticipate']").val(data.id);
    }
}
function onchanges(obj) {
	/*obj.inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });*/
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

/*	var resultsProportion=$("input[name='resultsProportion']")
	var sum1=0;
	for(var i=0;i<resultsProportion.length;i++){
		if(resultsProportion[i].value!=null && resultsProportion[i].value!=undefined && resultsProportion[i].value!=''){
			sum1+=parseFloat(resultsProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative1").html(sum1+"%");*/
}

function initMenu(){
	$.contextMenu({
	    selector: "#table5 .node", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:33%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text"  name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);
	          	}
	        },
	        verygood: {name: "删除", callback: function(key, opt){
	        	var activeClass = $('.context-menu-active');
	        	var userName = $('#table2').find(activeClass).children().eq(0).children("input[name='userName']").val();

	        	if(userName != ""){
	        			$(this).remove();
	        	}else{
	        		$('#table2').find(activeClass).remove();
	        		var firstTr = $("#table2").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        	cumulative();
	        }
	      }
	   }
	});
	$.contextMenu({
	    selector: "#table5 .node1", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:33%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);
	          	}
	        }
	      }
	});
}

/* 项目选择 */
var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if (!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectId']").val(data.id);
		$(projectObj).find("input[name='projectname']").val(data.name);
	}
}

/*******************************************************************************
 * 表单操作相关函数 *
 ******************************************************************************/
// 比较开票金额和收款总金额
//function initCompareBillWithBillCollection() {
//	var total = 0;
//	var collectionBill = 0;
//	$("tr[name='node']").each(function(business, tr) {
//		temp = rmoney($(tr).find("input[name='collectionBill']").val());
//		if (temp == "" || temp == null) {
//			temp = 0;
//		}
//		total = digitTool.add(total, parseFloat(temp));
//	});
//	if (!isNull($("#applyPay").val())) {
//		if (rmoney($("#applyPay").val()) == total) {
//			$("#billHidden").show();
//		} else {
//			$("#billHidden").hide();
//		}
//	}
//
//}


function inittextarea(){
    autosize(document.querySelectorAll('textarea'));
}

/*function initUnCollection(){
	var total = 0;
	var totalPay = rmoney($("#totalPay").val());
	$("tr[name='node']").each(function(business, tr) {
		temp = rmoney($(tr).find("input[name='collectionBill']").val());
		if (temp == "" || temp == null) {
			temp = 0;
		}
		total = digitTool.add(total, parseFloat(temp));
	});
	$("#uncollected").val(fmoney((totalPay-total),0));
}*/

//function initinvoiced() {
//	if ($("#isInvoiced").val() == '1') {
//		$("#table2").show();
//		$("#invoice").show();
//	} else {
//		$("#table2").hide();
//		$("#invoice").hide();
//	}
//}

function initInputBlur(){
	//$("#invoiceAmount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	//$("#confirmAmount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	//$("#resultsContribution").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("#resultsAmount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='resultsProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='commissionProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
}

function initAdd() {
	var nodes = $("#add").find("tr[name='add']");
	if (nodes.length == 0) {
		var html = getAddHtml();
		$("#add").append(html);
		initDatetimepicker();
		initInputMask();
	}
}

function initNode() {
	var collection = $("#node").find("tr[name='node']");
	if (collection.length == 0) {
		var html = getNodeHtml();
		$("#node").append(html);
		initDatetimepicker();
		initInputMask();
	}
}

/*******************************************************************************
 * 流程处理相关函数 *
 ******************************************************************************/

function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variablesTemp);

	if (compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		$("#currStatus").val(status)
		if (statusResult.code == 1) {
			if(approveStatus=="3"){
				sendMail();
			}
			backPageAndRefresh();
			window.parent.initTodo();
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

//调用发送邮件的方法
function sendMail() {
	var comment=$("#comment").val();
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/finInvoiced/sendMail",
		"dataType" : "json",
		"data" : {
			"id" : $("#id").val(),
			"contents" : comment
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
		"emailUid" : $("#emailUid").val(),
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

/*
 * 审批状态 0：提交申请  1:项目负责人审批 2：部门经理审批 3：财务审批 4：总经理审批 5：财务总监审批 6：审批通过 7：取消申请 8：项目负责人不同意 9：部门经理不同意 10：财务不同意
 * 11：总经理不同意 12：财务总监不同意  
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

// 更改流程状态标识
function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/finInvoiced/setStatus",
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
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
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
		"data" : JSON.stringify(variables)
	});
}

var approveStatus = -1;
var isOk = 0;
function approve(status) {
	approveStatus = status;
	if (status == 1) {
		$("#operStatus").val("提交");
		if (fileData != null) {
			fileData.submit();
		} else {
			saveinfo();
		}
	} else if (status == 2) {
		$("#operStatus").val("同意");
		openBootstrapShade(true);
		isOk = 2;
		submitinfo();
	} else if (status == 3) {
		$("#operStatus").val("不同意");
		openBootstrapShade(true);
		isOk = 3;
		submitinfo();
	} else if (status == 4) {
		$("#operStatus").val("重新申请");
		isOk = 2;
		submitinfo();
	} else if (status == 5) {
		$("#operStatus").val("取消申请");
		cancel();
	}
}

function initInputMask() {
	if (editInvest) {
		$("tr[name='node']").find("input").each(function(index, input) {
			var name = $(input).attr("name");
			if (name == "collectionBill") {
				$(input).inputmask("Regex", {
					regex : "\\d+\\.?\\d{0,2}"
				});
			}
		});
	}

	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if (name == "number") {
			$(input).inputmask("Regex", {
				regex : "\\d+\\.?\\d{0,0}"
			});
		}
		/*
		 * if (name == "levied") { $(input).inputmask("Regex", { regex:
		 * "^-?\\d+\\.?\\d{0,2}"}); }
		 */
	});
	/*
	 * if(editflag){ $("#bill").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}"
	 * }); }
	 */
	if(editflag){
		$("#bill").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}"});
	}
	/*
	 * $("#payphone").inputmask({ "mask": "9{11}" });
	 * $("#collectionContact").inputmask({ "mask": "9{11}" });
	 */
	$("#bankNumber").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,0}"
	});
	$("#collectionAccount").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,0}"
	});
}

function coutmoney() {
	$("tr[name='add']").each(
			function(index, tr) {
				var levied = rmoney($(tr).find("input[name='levied']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if (!isNull(levied)) {
					$(tr).find("input[name='money']").val(
							fmoney((levied / (1 + excise)).toFixed(2), 0));
				} else {
					$(tr).find("input[name='money']").val(0);
				}
				coutexcise(tr);
			});
}

function coutexcise(tr) {
	var number = $(tr).find("input[name='number']").val();
	var money = rmoney($(tr).find("input[name='money']").val());
	var excise = $(tr).find("select[name='excise']").val() / 100;
	if (money != null && money != "") {
		if (excise != 0 && money != 0) {
			$(tr).find("input[name='exciseMoney']").val(
					fmoney((money * excise).toFixed(2), 0));
		} else {
			$(tr).find("input[name='exciseMoney']").val(0);
		}
		if (number != null && number != "") {
			$(tr).find("input[name='price']").val(
					fmoney((money / number).toFixed(2), 0));
		} else {
			$(tr).find("input[name='price']").val(0);
		}

	}
	countAll();
}

function initexcise() {
	$("tr[name='add']").each(
			function(index, tr) {
				var money = rmoney($(tr).find("input[name='money']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if (excise == 0 || money == 0) {
					$(tr).find("input[name='exciseMoney']").val(0);
				} else if (money != null && money != "" && excise != null
						&& excise != "") {
					$(tr).find("input[name='exciseMoney']").val(
							fmoney(money * excise, 0));
				}
			});
	coutmoney();
	// countAll();
}

function countAll() {
	var sum = 0;
	var sum1 = 0;
	var sum3=0;
	$("tr[name='add']").each(function(index, tr) {
		temp = rmoney($(tr).find("input[name='money']").val());
		totalTemp= rmoney($(tr).find("input[name='levied']").val());
		if (temp == "" || temp == null) {
			temp = 0;
		}
		temp1 = rmoney($(tr).find("input[name='exciseMoney']").val());
		if (temp1 == "" || temp1 == null) {
			temp1 = 0;
		}
		sum = digitTool.add(sum, parseFloat(temp));
		sum1 = digitTool.add(sum1, parseFloat(temp1));
		sum3=digitTool.add(sum3, parseFloat(totalTemp));
	});
	var tr = $("#table2").find("#totalCount");
	$(tr).find("input[name='total']").val(fmoney(sum, 0));
	$(tr).find("input[name='totalexcisemoney']")
			.val(fmoney(sum1.toFixed(2), 0));
	var nexttr = $(tr).next();
	$(nexttr).find("input[name='totalexcise']").val(
			fmoney((sum3).toFixed(2), 0));
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

function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

function initDatetimepicker() {

	$("#finInvoicedDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("#shareStartDate").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});
	
	$("#shareEndDate").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});

	$("#shareStartDateResults").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});
	
	$("#shareEndDateResults").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});
}

function openBargin() {
	$("#barginDialog").openBarginDialog();
}

function getBargin(data) {
	if (!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(fmoney(data.totalMoney, 0));
		if (data.projectManage != null && data.projectManage != "") {
			$("#projectManageName").val(data.projectManage.name);
			$("#projectManageId").val(data.projectManage.id);
		}

		if (data.processInstanceId != null && data.processInstanceId != ""
				&& data.processInstanceId != "undefined") {
			$("#tip").remove();
			$("#viewBarginBtn").show();
		} else {
			$("#tip").remove();

			document.getElementById("viewBarginBtn").style.display = "none";

			$("#viewBarginBtn")
					.before(
							'<font id="tip" style="border:none;color: rgb(54, 127, 169)">选取成功！</font>');
		}

	}
	initInputBlur();
}

function node(oper, obj) {
	if (oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input")
				.each(function(index, input) {
					$(this).trigger("keyup");
				});
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		initInputMask();
	}
}

function add(oper, obj) {
	if (oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input")
				.each(function(index, input) {
					$(this).trigger("keyup");
				});
		countAll();
	} else {
		var html = getAddHtml();
		$(obj).parents("tr").after(html);
		initInputMask();
	}
}

// 收款登记行
function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html
			.push('	<td colspan="3"><input type="text" style="text-align:center;" name="collectionDate" class="collectionDate" value=""  readonly></td>');
	html
			.push('	<td colspan="3"><input type="text" style="text-align:center;" name="collectionBill" onkeyup = "initCompareBillWithBillCollection()" value="" ></td>');
	html.push('<td colspan="3" style="text-align:center;">');
	html
			.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'
					+ base
					+ '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'
					+ base + '/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");

}

// 发票详情行
function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td><input type="text"  name="name" value="" > </td>');
	html.push('<td><input type="text"  name="model" value="" > </td>');
	html.push('<td><input type="text" name="unit" value=""  ></td>');
	html
			.push('<td><input type="text" name="number" value=""  onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="price" value="" readonly></td>');
	html.push('<td><input type="text" name="money" value=""  readonly></td>');
	html
			.push('<td><select name="excise"  style= "width: 100%" onchange="initexcise()">');
	html.push('<option selected="selected">0</option>');
	html.push('<option>6</option>');
	html.push('<option>13</option>');
	html.push('<option>16</option>');
	html.push('<option>17</option>');
	html.push('</select></td>');
	html
			.push('<td><input type="text" name="exciseMoney" value=""  readonly ></td>');
	html
			.push('<td><input type="text"  name="levied" value="" onkeyup="coutmoney()"></td>')
	html.push('<td style="text-align:center;">');
	html
			.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="添加" src="'
					+ base
					+ '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="删除" src="'
					+ base + '/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}

function submitinfo() {
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if (checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		openBootstrapShade(false);
		return false;
	} else {
		submitForm(formData);
	}

}

function save() {
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if (checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return false;
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}

}

function saveinfo() {
	isOk = 2;
	var formData = getFormData();
	console.log(formData)
	var checkMsg = checkForm(formData);
	if (checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return false;
	} else {
		$.ajax({
			url : web_ctx + "/manage/sale/finInvoiced/saveInfo",
			type : "post",
			contentType : "application/json;charset=UTF-8",
			data : JSON.stringify(formData),
			dataType : "json",
			success : function(data) {
				if (data.code == 1) {
					openBootstrapShade(false);
					backPageAndRefresh();
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
}

function cancel() {
	cancelProcess();
}



function submitForm(formData) {
	$.ajax({
		url : web_ctx + "/manage/sale/finInvoiced/saveInfo",
		type : "post",
		contentType : "application/json;charset=UTF-8",
		data : JSON.stringify(formData),
		dataType : "json",
		success : function(data) {
			openBootstrapShade(false);
			if (data.code == 1) {
				submitProcess();
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

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if (isNull(commentList)) {
		commentList = [];
	}
	/* $(commentList).each(function(index, comment) { */
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
		html
				.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(commentList[i].comment) ? "" : commentList[i].comment);
		html.push("</td>");
		$("#table3").find("tbody").append(html.join(""));
	}

	/* }); */
}

function getFormData() {
	
	if(!isNull($("#invoiceAmount").val())){
		$("#invoiceAmount").val(rmoney($("#invoiceAmount").val()));
	}
	$("select[name='confirmWay']").attr("disabled",false);
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);

	formData["collectionAttachList"] = [];
	formData["invoicedAttachList"] = [];

	$("tbody").find("tr[name='node']").each(
			function(index, tr) {
				var id = $(this).find("input[name='businessId']").val();
				var collectionDate = $(this).find(
						"input[name='collectionDate']").val();
				var collectionBill = $(this).find(
						"input[name='collectionBill']").val();
				if (!isNull(collectionDate) || !isNull(collectionBill)) {

					var collectionAttach = {};
					collectionAttach["id"] = id;
					collectionAttach["collectionDate"] = collectionDate;
					collectionAttach["collectionBill"] = collectionBill;
					formData["collectionAttachList"].push(collectionAttach);
				}
			});

	$("tbody").find("tr[name='add']").each(function(index, tr) {
		var id = $(this).find("input[name='attachId']").val();
		var name = $(this).find("input[name='name']").val();
		var model = $(this).find("input[name='model']").val();
		var unit = $(this).find("input[name='unit']").val();
		var number = $(this).find("input[name='number']").val();
		var price = $(this).find("input[name='price']").val();
		var money = $(this).find("input[name='money']").val();
		var excise = $(this).find("select[name='excise']").val();
		var exciseMoney = $(this).find("input[name='exciseMoney']").val();
		var levied = $(this).find("input[name='levied']").val();
		if (!isNull(name) || !isNull(model)) {
			var invoiceAttach = {};
			invoiceAttach["id"] = id;
			invoiceAttach["name"] = name;
			invoiceAttach["model"] = model;
			invoiceAttach["unit"] = unit;
			invoiceAttach["number"] = number;
			invoiceAttach["price"] = price;
			invoiceAttach["money"] = money;
			invoiceAttach["excise"] = excise;
			invoiceAttach["exciseMoney"] = exciseMoney;
			invoiceAttach["levied"] = levied;
			formData["invoicedAttachList"].push(invoiceAttach);
		}

	});
	formData["collectionBill"]=0;
	
	var finRevenueRecognition = {};
	finRevenueRecognition["id"]=$("#finRevenueRecognitionId").val();
	finRevenueRecognition["confirmAmount"]=$("#confirmAmount").val();
	finRevenueRecognition["confirmWay"]=$("select[name='confirmWay']").val();
	finRevenueRecognition["shareStartDate"]=$("#shareStartDate").val();
	finRevenueRecognition["shareEndDate"]=$("#shareEndDate").val();
	finRevenueRecognition["resultsContribution"]=$("#resultsContribution").val();
	formData["finRevenueRecognition"]=finRevenueRecognition;
	
	formData["finInvoiceProjectMembersList"] = [];
	$("#tableTbody tr").each(function(index, tr) {
		var id = $(this).find("input[name='businessId']").val();
		var userIdParticipate = $(this).find("input[name='userIdParticipate']").val();
		var sorting=$(this).find("input[name='userIdParticipate']").attr("data-sorting");
		var commissionProportion = $(this).find("input[name='commissionProportion']").val();
		/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
		if( !isNull(userIdParticipate)) {	
			var FinInvoiceProjectMembers = {};
			FinInvoiceProjectMembers["id"]= id;
			FinInvoiceProjectMembers["userId"]= userIdParticipate;
			FinInvoiceProjectMembers["sorting"] = sorting;
			FinInvoiceProjectMembers["commissionProportion"]= commissionProportion.replace(/%/g,'');
			/*FinInvoiceProjectMembers["resultsProportion"]= resultsProportion.replace(/%/g,'');*/
			formData["finInvoiceProjectMembersList"].push(FinInvoiceProjectMembers);
		}
	});
	formData["invoiceAmount"]=commafyback($("#invoiceAmount").val());
	return formData;
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if(isOk == 2) {
		if (isNull(formData["invoiceAmount"])) {
			text.push("开票金额不能为空！<br/>");
		}
		var confirmWay = $("select[name='confirmWay']").val();
		if (confirmWay == 2) {
			var shareStartDate = $("#shareStartDate").val();
			var shareEndDate = $("#shareEndDate").val();
			if (shareStartDate == null || shareStartDate == '') {
				text.push("收入确认分摊期限不能为空！<br/>");
			}
			if (shareEndDate == null || shareEndDate == '') {
				text.push("收入确认分摊期限不能为空！<br/>");
			}
		}
		if (editInvest) {
			if (isNull(formData["resultsContribution"])) {
				text.push("收入确认不能为空！<br/>");
			}
		}

	/*	$("tr[name='node']").each(function (business, tr) {
			var resultsProportion = $(tr).find("input[name='resultsProportion']").val();
			var uName = $(tr).find("input[name='userName']").val();
			var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
			if (!isNull(resultsProportion) || !isNull(uName) || !isNull(commissionProportion)) {
				if (resultsProportion == "" || resultsProportion == null || resultsProportion == "%") {
					text.push("业绩比例不能为空！<br/>");
					return false
				}
			}
		});*/

		$("tr[name='node']").each(function (business, tr) {
			var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
			var uName = $(tr).find("input[name='userName']").val();
			/*var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
			if (!isNull(uName) || !isNull(commissionProportion)) {
				if (commissionProportion == "" || commissionProportion == null || commissionProportion == "%") {
					text.push("提成比例不能为空！<br/>");
					return false
				}
			}
		});

		$("tr[name='node']").each(function (business, tr) {
			var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
			var uName = $(tr).find("input[name='userName']").val();
			/*var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
			if (!isNull(uName) || !isNull(commissionProportion)) {
				if (uName == "" || uName == null) {
					text.push("成员名字不能为空！<br/>");
					return false
				}
			}
		});
	} else if(isOk == 3){
		return text;
	}

	return text;
}

/*******************************************************************************
 * 打印相关
 ******************************************************************************/
function print(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/collection/printInvoice"
	}

	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}

function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/collection/pdf"
	}

	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
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
				url : web_ctx + "/manage/sale/finInvoiced/deleteAttach",
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
		"path" : "invoice/" + date.getFullYear() + (date.getMonth() + 1)
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
						if ($("#operStatus").val() == "提交") {
							saveinfo();
						} else {
							submitForm(formData);
						}

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
 *初始化金额，两位数
 */
function initInputMask(val){
	if (val == null || val == "null" || val == "")
		return "0.00";
	if (/[^0-9\.]/.test(val))
        return "0.00";
    val = val.toString().replace(/^(\d*)$/, "$1.");
    val = (val + "00").replace(/(\d*\.\d\d)\d*/, "$1");
    val = val.replace(".", ",");
    var re = /(\d)(\d{3},)/;
    while (re.test(val))
        val = val.replace(re, "$1,$2");
    val = val.replace(/,(\d\d)$/, ".$1");
//    if (type == 0) {
//        var a = val.split(".");
//        if (a[1] == "00") {
//            val = a[0];
//        }
//    }
    return val;
}
/*
 * 去除千分位
 */
function commafyback(num) {
	if (num == null || num == "null" || num == "")
		return "0.00";
	num=num+"";
	if(num.indexOf(",") == -1){
		return num;
	}
	var x = num.split(','); 
	return parseFloat(x.join("")); 
} 
