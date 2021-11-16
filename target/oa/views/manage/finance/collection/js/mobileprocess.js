var currTd = null;
/*
 * 审批状态 0：提交申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳审批 5：审批通过 6：取消申请 7：部门经理不同意 8：财务不同意
 * 9：总经理不同意 10：出纳不同意
 */
// 同意后的下一状态
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
    "5": "审批通过",
    "6": "取消申请",
    "7": "提交申请",
    "8": "提交申请",
    "9": "提交申请",
    "10": "提交申请",
};
// 环节与操作结果的映射
var nodeOnOper = {
    "提交": "提交成功",
    "重新申请": "申请成功",
    "同意": "通过",
    "不同意": "不通过",
    "取消申请": "取消申请"
};


$(function() {
	initDatetimepicker();
	initInputMask();
	initTaskComment();
	initinvoiced();
	initInputBlur();
	initFileUpload();
	initCompareBillWithBillCollection();
	coutmoney();
	if(editInvest){
		initNode();
	}
	/*initAdd();*/
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	if($("#barginId").val() != null && $("#barginId").val() != ""){
		$("#viewBarginBtn").show();
	}
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	 $("li[name='add']").each(function(index, tr) {
	    	var levied = rmoney($(tr).find("input[name='levied']").val());
			if (!isNull(levied)) {
				$(tr).find("input[name='levied']").val(fmoney(levied, 0));
			}
	    });
	 $("li[name='node']").each(function(index, tr) {
	    	var collectionBill = $(tr).find("input[name='collectionBill']").val();
			if (!isNull(collectionBill)) {
				$(tr).find("input[name='collectionBill']").val(fmoney(collectionBill, 0));
			}
	    	});
	    if(!isNull($("#bill").val())){
	    	$("#bill").val(fmoney($("#bill").val(),0))
	    }
	    $("#totalPay").val(fmoney($("#totalPay").val(),0));
		$("#applyPay").val(fmoney($("#applyPay").val(),0))
	 
	 
	 countAll();
});

/*项目选择*/
var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectId']").val(data.id);
		$(projectObj).find("input[name='projectname']").val(data.name);
	}
}





/*******************************************************************************
 * 表单操作相关函数 *
 ******************************************************************************/
// 比较开票金额和收款总金额
function initCompareBillWithBillCollection() {
	var total = 0;
	var collectionBill = 0;
	$("li[name='node']").each(function (business,tr) {
        temp = rmoney($(tr).find("input[name='collectionBill']").val());
        if (temp == "" || temp == null){
            temp = 0;
        }
        total = digitTool.add(total,parseFloat(temp));
    });
	if(!isNull($("#bill").val())){
		if(rmoney($("#bill").val()) == total){
			$("#billHidden").show();
		}else{
	        $("#billHidden").hide();
		}
	}
	
}

function initinvoiced(){
	if($("#isInvoiced").val() == '1'){
		$("#billnote").show();
		$("#billnote1").show();
	}
	else{
		$("#billnote").hide();
		$("#billnote1").hide();
	}
}

function initInputBlur(){
	var totalmoney = $("#totalPay").val();
	var applyPay = $("#applyPay").val();
	if(!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0"){
		$("#applyProportion").val((digitTool.divide(applyPay,totalmoney)* 100).toFixed(2)+ "%");
	}

}

function initAdd() {
		var nodes = $("#add").find("li[name='add']");
		if(nodes.length == 0) {
			var html = getAddHtml();
			 $("#add").append(html);
			 initDatetimepicker();
			 initInputMask();
		}
}


/*function initNode(){
	var collection = $("#node").find("tr[name='node']");
	if(collection.length == 0) {
		var html = getNodeHtml();
		 $("#node").append(html);
		 initDatetimepicker();
		 initInputMask();
	}
}
*/




/*******************************************************************************
 * 流程处理相关函数 *
 ******************************************************************************/

function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variablesTemp);

	if(compResult.code == 1) {
		var status = getNextStatus();
        var statusResult = setStatus(status);
        if(statusResult.code == 1) {
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
    openBootstrapShade(false);
}
// 获取流程变量，对于流程走向有效果
function getVariables() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	
	var operStatus = $("#operStatus").val(); 
	var form = {
			"node": getNodeInfo(),
			"approver": $("#approver").val(),
			"emailUid": $("#emailUid").val(),
			"comment": operStatus != "提交" ? $("#comment").val() : "",
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
 * 审批状态 0：提交申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳审批 5：审批通过 6：取消申请 7：部门经理不同意 8：财务不同意
 * 9：总经理不同意 10：出纳不同意
 */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	if($("#operStatus").val() == "同意") {
		status = approvedStatus[currStatus];
	} else if($("#operStatus").val() == "不同意") {
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
    $.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/finance/collection/setStatus",
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


// 取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if(result != null) {
			if(result.code == 1) {
                var statusResult = setStatus("6");
                if(statusResult.code == 1){
                    window.parent.initTodo();
                    backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}

function setStatus(status) {
    var id = $("#id").val();
    var result = {};
    $.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/finance/collection/setStatus",
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
        "success": function(data) { 
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
}

var approveStatus=-1;
function approve(status) {
	if(status == 1) {
		/*$("#operStatus").val("提交");
		save();*/
		$("#operStatus").val("提交");
		if(fileData!=null){
			fileData.submit();
		}else{
			save();
		}
	} else if(status == 2) {
		$("#operStatus").val("同意");
			openBootstrapShade(true);
			submitinfo();
	} else if(status == 3) {
		$("#operStatus").val("不同意");
     	   	openBootstrapShade(true);
			submitinfo();
	} else if(status == 4) {
		$("#operStatus").val("重新申请");
		submitinfo();
	} else if(status == 5) {
		$("#operStatus").val("取消申请");
		cancel();
	}
}


function initInputMask() {
	$("li[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "collectionBill") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
	});
	
	$("li[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(/*name == "price" || name == "money" || name =="excise" || name =="exciseMoney" ||*/name == "number") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}
		/*if (name == "levied") {
			$(input).inputmask("Regex", { regex: "^[+-]?[1-9]?[0-9]\.[0-9]{2}%$"});
			$(input).inputmask("Regex", { regex: "^-?\\d+\\.?\\d{0,2}"});
		}*/
	});
	
	$("#bill").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	/*$("#payphone").inputmask({ "mask": "9{11}" });
	$("#collectionContact").inputmask({ "mask": "9{11}" });*/
	/*$("#paynumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	$("#collectionNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });*/
	$("#bankNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	$("#collectionAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	
}

/*function coutmoney(){
	$("li[name='add']").each(function(index, tr) {
		var number = $(tr).find("input[name='number']").val();
		var price = $(tr).find("input[name='price']").val();
		$(tr).find("input[name='money']").val(digitTool.multiply(price,number));
		coutexcise(tr);
	});
}

function coutexcise(tr){
	var money = $(tr).find("input[name='money']").val();
	var excise = $(tr).find("input[name='excise']").val()/100;
	if (money != null && money != "" && excise != null && excise != "") {
		$(tr).find("input[name='exciseMoney']").val(money*excise);
	}
	countAll();
}

function initexcise(){
	$("li[name='add']").each(function(index, tr) {
		var money = $(tr).find("input[name='money']").val();
		var excise = $(tr).find("input[name='excise']").val()/100;
		if (money != null && money != "" && excise != null && excise != "") {
			$(tr).find("input[name='exciseMoney']").val(money*excise);
		}
	});
    countAll();
}
*/
function coutmoney(){
	$("li[name='add']").each(function(index, tr) {
		var number = $(tr).find("input[name='number']").val();
		//var price = $(tr).find("input[name='price']").val();
		var levied = rmoney($(tr).find("input[name='levied']").val());
		var excise = $(tr).find("select[name='excise']").val()/100;
		if(!isNull(levied)){
			$(tr).find("input[name='money']").val(
					fmoney((levied / (1 + excise)).toFixed(2), 0));
		}else{
			$(tr).find("input[name='money']").val(0);
		}
		coutexcise(tr);
	});
}

function coutexcise(tr){
	var number = $(tr).find("input[name='number']").val();
	var money = rmoney($(tr).find("input[name='money']").val());
	var excise = $(tr).find("select[name='excise']").val()/100;
	if (money != null && money != "") {
		if(excise!=0 && money!=0){
			$(tr).find("input[name='exciseMoney']").val(fmoney((money*excise).toFixed(2),0));
		}else{	
			$(tr).find("input[name='exciseMoney']").val(0);
		}
		if(number!=null && number!=""){
			$(tr).find("input[name='price']").val(fmoney((money/number).toFixed(2),0));
		}else{
			$(tr).find("input[name='price']").val(0);
		}
		
	}
	countAll();
}

function initexcise(){
	$("li[name='add']").each(function(index, tr) {
		var money = rmoney($(tr).find("input[name='money']").val());
		var excise = $(tr).find("select[name='excise']").val()/100;
		if(excise==0 || money==0){
			$(tr).find("input[name='exciseMoney']").val(0);
		}else if (money != null && money != "" && excise != null && excise != "") {
			$(tr).find("input[name='exciseMoney']").val(fmoney(money*excise,0));
		}
	});
	coutmoney();
}


function countAll() {
    var sum = 0;
    var sum1 = 0;
    $("li[name='add']").each(function (index, tr) {
        temp = rmoney($(tr).find("input[name='money']").val());
        if (temp == "" || temp == null) {
            temp = 0;
        }
        temp1 = rmoney($(tr).find("input[name='exciseMoney']").val());
        if (temp1 == "" || temp1 == null) {
            temp1 = 0;
        }
        sum = digitTool.add(sum, parseFloat(temp));
        sum1 = digitTool.add(sum1, parseFloat(temp1));
    });
    var tr=$("#billUl");
    $(tr).find("input[name='total']").val(fmoney(sum,0));
    $(tr).find("input[name='totalexcisemoney']").val(fmoney((sum1).toFixed(2),0));
    $(tr).find("input[name='totalexcise']").val(fmoney((sum + sum1).toFixed(2),0));
}


function fmoney(s, n){
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
	$(".collectionDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$(".billDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
}

function openBargin() {
	$("#barginDialog").openBarginDialog();
}

function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(data.totalMoney);
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
	initInputBlur();
}

// 查看合同详情
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	
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



function node(oper, obj) {
	if(oper == "del") {
		$(obj).closest('.parentli').remove();
	} else {
		var html = getNodeHtml();
		$(obj).closest('.parentli').after(html);
		$(obj).attr("onclick", "node('del', this)");
		$(obj).html('<img alt="删除" src="' + base + '/static/images/del.png">');
		initDatetimepicker();
		initInputMask();
	}
}

function add(oper, obj) {
	if(oper == "del") {
		$(obj).closest('.parentli').remove();
		coutmoney();
        initexcise();
	} else {
		var html = getAddHtml();
		$(obj).closest('.parentli').after(html);
		$(obj).attr("onclick", "add('del', this)");
		$(obj).html('<img alt="删除" src="' + base + '/static/images/del.png">');;
		initInputMask();
	}
}


var index=0
// 收款登记行
function getNodeHtml() {
	var html = [];
	html.push('<li class="clearfix parentli" name="node">');
	html.push('<input type="hidden" name="businessId" value="" readonly>');
	html.push('<div class="col-xs-12">');
	html.push('	<div class="mFormName">收款条目</div>');
	html.push('<div class="mFormMsg firstMsg">');
	html.push('<div class="mFormShow secondMsg" onclick="changeImage(this)" href="#intercityCostVV'+index+'" data-toggle="collapse" data-parent="#accordion">');
	html.push('<div class="mFormSeconMsg">');
	html.push('</div>');
	html.push('<div class="mFormSeconMsg">');
	html.push('</div>');
	html.push('<div class="mFormArr current">');
	html.push('<img src="'+base+'/static/images/arr.png" alt="">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormOpe1" onclick="node(\'add\',this)">');
	html.push('<img src="'+base+'/static/images/add.png" alt="添加">');
	html.push('</div>');
	html.push('<div class="mFormToggle panel-collapse collapse thirdMsg" id="intercityCostVV'+index+'">');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">收款日期</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="collectionDate longInput" id="collectionDate" name="collectionDate" class="collectionDate" readonly >');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">收款金额</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput" id="collectionBill" name="collectionBill" onkeyup = "initCompareBillWithBillCollection()">');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</li>');
	index++;
	return html.join("");
	
}


// 发票详情行
function getAddHtml() {
	var html = [];
	html.push('<li class="clearfix parentli" name="add">');
	html.push('<div class="col-xs-12">');
	html.push('<div class="mFormName">货物单详情</div>');
	html.push('<div class="mFormMsg firstMsg">');
	html.push('<div class="mFormShow secondMsg" onclick="changeImage(this)"');
	html.push('href="#intercityCostVIIII'+index+'" data-toggle="collapse"');
	html.push('data-parent="#accordion">');
	html.push('<div class="mFormSeconMsg">');
	html.push('<span></span>');
	html.push('</div>');
	html.push('<div class="mFormArr current">');
	html.push('<img src="'+base+'/static/images/arr.png" alt="">');
	html.push('</div>');
	html.push('</div>');
	html.push('<div class="mFormOpe1" onclick="add(\'add\',this)">');
	html.push('<img src="'+base+'/static/images/add.png" alt="添加">');
	html.push('</div>');
	html.push('<div class="mFormToggle panel-collapse collapse thirdMsg" id="intercityCostVIIII'+index+'">');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push(' <div class="mFormXSName">货物或应税劳务名称</div>');
    html.push(' <div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput" name="name" value="">');
	html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">规格型号</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput"  name="model" value="">');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push(' <div class="mFormXSName">单位</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput" name="unit"  value="" readonly>');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">数量</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput" name="number"  value="" onkeyup="coutmoney()">');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">单价</div>');
    html.push(' <div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput"  name="price"  value="" onkeyup="coutmoney()">');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push('<div class="mFormXSName">金额</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput"  name="money" readonly  value="0">');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
    html.push('<div class="mFormToggleConn">');
    html.push('<div class="mFormXSToggleConn">');
    html.push('<div class="mFormXSName">税率</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<select name="excise" onchange="initexcise()" class="mSelect">');
    html.push('<option selected="selected">0</option>');
    html.push('<option>6</option>');
    html.push('<option>16</option>');
    html.push('<option>17</option>');
    html.push('</select>');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
	html.push('<div class="mFormToggleConn">');
	html.push('<div class="mFormXSToggleConn">');
	html.push(' <div class="mFormXSName">税额</div>');
    html.push(' <div class="mFormXSMsg">');
    html.push('<input type="text" class="longInput" name="exciseMoney"  value="0"  readonly>');
    html.push('</div>');
    html.push('</div>');
    html.push('</div>');
    html.push('<div class="mFormToggleConn">');
    html.push('<div class="mFormXSToggleConn">');
    html.push('<div class="mFormXSName">价税小计</div>');
    html.push('<div class="mFormXSMsg">');
    html.push('<input type="text"  name="levied" class="longInput" value=""  onkeyup="coutmoney()">');
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


function submitinfo() {
	
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
        openBootstrapShade(false);
		return false;
	}
	else{
		submitForm(formData);
	}
	
}

function save(){
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return false;
	}
	else{
		openBootstrapShade(true);
		saveForm(formData);
	}
	
}

function cancel(){
	cancelProcess();
}

function saveForm(formData) {
	$.ajax({
		url: web_ctx+"/manage/finance/collection/save",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data:JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			 if(data.code == 1) {
             	openBootstrapShade(false);
             	backPageAndRefresh();
             } else {
                 bootstrapAlert("提示", data.result, 400, null);
             }
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function submitForm(formData) {
		$.ajax({
			url: web_ctx+"/manage/finance/collection/saveOrUpdate",
			type: "post",
			contentType: "application/json;charset=UTF-8",
			data:JSON.stringify(formData),
			dataType: "json",
			success: function(data) {
				openBootstrapShade(false);
				if(data.code == 1) {
                    submitProcess();
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
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
        html.push("<div class='mFormXSName' style='width:auto'>环节</div>")
        html.push("<div class='mFormXSMsg' style='width:auto;margin-left:20px'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].node+"' disabled>")
        html.push("</div>")
        html.push("</div>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName' style='width:auto'>操作人</div>")
        html.push("<div class='mFormXSMsg' style='width:auto;margin-left:20px'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].approver+"' disabled>")
        html.push("</div>");
        html.push("</div>");
        html.push("</div>")
        html.push("<div class='mFormToggleConn'>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName' style='width:auto'>操作时间</div>")
        html.push("<div class='mFormXSMsg' style='width:auto;margin-left:20px'>")
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
        html.push("<div class='mFormXSName' style='width:auto'>操作结果</div>")
        html.push("<div class='mFormXSMsg' style='width:auto;margin-left:20px'>")
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


function getFormData() {
	
	if((editInvest || editflag) && approveStatus==3){
		$("#bill").val("");
		$("#billDate").val("");
	}
	if(!isNull($("#totalPay").val())){
		$("#totalPay").val(rmoney($("#totalPay").val()));
	}
	if(!isNull($("#applyPay").val())){
		$("#applyPay").val(rmoney($("#applyPay").val()));
	}
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	
	formData["collectionAttachList"] = [];
	formData["invoicedAttachList"] = [];

	$("#node").find("li[name='node']").each(function(index, tr) {
		var id = $(this).find("input[name='businessId']").val();
		var collectionDate = $(this).find("input[name='collectionDate']").val();
		var collectionBill = $(this).find("input[name='collectionBill']").val();
		if( !isNull(collectionDate) || !isNull(collectionBill)) {
			
			var collectionAttach = {};
			collectionAttach["id"]= id;
			collectionAttach["collectionDate"]= collectionDate;
			collectionAttach["collectionBill"]= collectionBill;
			formData["collectionAttachList"].push(collectionAttach);
		}
	});
	$("#add").find("li[name='add']").each(function(index, tr) {
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
		if( !isNull(name) || !isNull(model)) {
			var invoiceAttach = {};
			invoiceAttach["id"]= id;
			invoiceAttach["name"]= name;
			invoiceAttach["model"]= model;
			invoiceAttach["unit"]= unit;
			invoiceAttach["number"]= number;
			invoiceAttach["price"]= price;
			invoiceAttach["money"]= money;
			invoiceAttach["excise"]= excise;
			invoiceAttach["exciseMoney"]= exciseMoney;
			invoiceAttach["levied"]= levied;
			formData["invoicedAttachList"].push(invoiceAttach);
		}
		
	});
	return formData;
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if($("#isInvoiced").val() == '1'){
		if(isNull(formData["applyPay"])){
			text.push("申请金额不能为空！<br/>");
		}
		if(isNull(formData["payCompany"])){
			text.push("付款单位不能为空！<br/>");
		}
		/*if(isNull(formData["barginId"])){
			text.push("请选择相关合同！<br/>");
		}*/
		if(isNull(formData["payname"])){
			text.push("购货单位不能为空！<br/>");
		}
		if(isNull(formData["paynumber"])){
			text.push("纳税人识别号不能为空！<br/>");
		}
		/*if(!isNull(formData["payphone"])&&  !phone.test(formData["payphone"]) ){
			text.push("请填写正确的11位手机号码！<br/>");
		}
		if(!isNull(formData["collectionContact"])&&  !phone.test(formData["collectionContact"]) ){
			text.push("请填写正确的11位手机号码！<br/>");
		}*/
		if(isNull(formData["bankAddress"]) || isNull(formData["bankNumber"])){
			text.push("开户行和账号不能为空！<br/>");
		}
		if(editflag && approveStatus!=3){
			if(isNull(formData["bill"])){
				text.push("开票金额不能为空！<br/>");
			}
			if(isNull(formData["billDate"])){
				text.push("开票日期不能为空！<br/>");
			}
		}
		if(formData["invoicedAttachList"].length <= 0) {
			text.push("至少有一条发票项！");
		}
		
		else{
			$(formData["invoicedAttachList"]).each(function(index, attach) {
				
				if(isNull(attach["levied"])){
					text.push("价税小计不能为空！");
					return false;
				}
				
				if(isNull(attach["name"])) {
					text.push("名称不能为空！");
					return false;
				}
				/*if(isNull(attach["model"])) {
					text.push("型号不能为空！");
					return false;
				}*/
				if(isNull(attach["number"])) {
					text.push("数量不能为空！");
					return false;
				}
				if(isNull(attach["price"])) {
					text.push("单价不能为空！");
					return false;
				}
				if(isNull(attach["money"])) {
					text.push("金额不能为空！");
					return false;
				}
				if(isNull(attach["excise"])) {
					text.push("税率不能为空！");
					return false;
				}
			});
			
		}
	}
	else{
		if(isNull(formData["applyPay"])){
			text.push("申请金额不能为空！<br/>");
		}
		if(editflag  && approveStatus!=3){
			if(isNull(formData["bill"])){
				text.push("开票金额不能为空！<br/>");
			}
			if(isNull(formData["billDate"])){
				text.push("开票日期不能为空！<br/>");
			}
		}
		if(isNull(formData["payCompany"])){
			text.push("付款单位不能为空！<br/>");
		}
		/*if(isNull(formData["barginId"])){
			text.push("请选择相关合同！<br/>");
		}*/
		if(isNull(formData["projectId"])){
			text.push("请选择相关项目！<br/>");
		}
		if(isNull(formData["totalPay"])){
            text.push("总金额不能为空！<br/>");
       }
	}
	
	return text;
}


function changeImage(obj){
	$(obj).find(".mFormArr").toggleClass("current")
}



/*******************************************************************************
 * 打印相关
 ******************************************************************************/
function print(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/collection/print"
	}
	
	window.open( web_ctx + "/activiti/process?" + urlEncode(param) );
}


function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/collection/pdf"
	}
	
	window.open( web_ctx + "/activiti/process?" + urlEncode(param) );
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
                url: web_ctx+"/manage/finance/collection/deleteAttach",
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
        "path": "collection/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
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
                if($("#operStatus").val()=="提交"){
                	save();
				}else{
                    submitForm(formData);
				}

            } else {
                openBootstrapShade(false);
                bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
            }
        }
    });
}



