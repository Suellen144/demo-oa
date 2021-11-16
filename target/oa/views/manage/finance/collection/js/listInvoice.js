var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/finInvoiced/getInvoiceList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	initDatetimepicker();
});

function initDatetimepicker() {
	$("#startTime, #endTime").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		pickDate: true,
		pickTime: false,
		autoclose: true,
	});
}
$("#status").change(function(){
	drawTable();
});

$("#status").change(function(){
	var statusVal = $("#status").val();
	if(statusVal == '6') {
		$("#td1,#td2").show();
	}else {
		$("#td1,#td2").hide();
	}
	drawTable();
});


$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});



function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
		{"mData": 'barginManage.barginCode'},
		{"mData": 'barginManage.barginName'},
        {"mData": 'projectName'},
        {"mData": 'invoiceAmount'},
        {"mData": 'applicant.name'},
        {"mData": 'createDate'},
        {"mData": 'status'},
        
    ]
	return columns;
}
var status='1';
function getSearchData() {
	var params = {};
    params.fuzzyContent = $.trim($("#fuzzyContent").val());
    params.status = $.trim($("#status").val());
	params.endTime = $.trim($("#endTime").val());
	params.startTime = $.trim($("#startTime").val());
	if(!isNull(params.startTime)) {
		params.startTime += " 0:0:0";
	}
	if(!isNull(params.endTime)) {
		params.endTime += " 23:59:59";
	}
    params.isNewProject = 1;

	if(params.status == '6') {
		$("#replace")[0].textContent="开票时间";
	}else {
		$("#replace")[0].textContent="申请时间";
	}
	status = $.trim($("#status").val());
	return params;
}


function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}

	if(status == '6'){
		if(aData.finInvoicedDate !=null){
			$('td:eq(5)', nRow).html(new Date(aData.finInvoicedDate).pattern("yyyy-MM-dd"));
		}else{
			$('td:eq(5)', nRow).html("");
		}
	}else {
		if(aData.createDate !=null){
			$('td:eq(5)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
		}else{
			$('td:eq(5)', nRow).html("");
		}
	}

	if(aData.applicant !=null){
		$('td:eq(4)', nRow).html(aData.applicant.name);
	}else{
		$('td:eq(4)', nRow).html("");
	}
	
	if(aData.projectName != null){
		$('td:eq(2)', nRow).html(aData.projectName);
	}else{
		$('td:eq(2)', nRow).html("");
	}
	if(aData.barginManage != null){
		$('td:eq(1)', nRow).html(aData.barginManage.barginName);
		$('td:eq(0)', nRow).html(aData.barginManage.barginCode);
	}else{
		$('td:eq(1)', nRow).html("");
		$('td:eq(0)', nRow).html("");
	}
	if(aData.invoiceAmount!=null){
		$('td:eq(3)', nRow).html(initInputMask(aData.invoiceAmount));
	}else{
		$('td:eq(3)', nRow).html(initInputMask(0.0));
	}
	if(aData.status == "1") {
		$('td:eq(6)', nRow).html('项目负责人审批');
	} else if(aData.status == "2") {
		$('td:eq(6)', nRow).html('部门经理审批');
	} else if(aData.status == "3") {
		$('td:eq(6)', nRow).html('财务审批');
	} else if(aData.status == "4") {
		$('td:eq(6)', nRow).html('总经理审批');
	} else if(aData.status == "5") {
		$('td:eq(6)', nRow).html('出纳确认');
	}else if(aData.status == "6") {
		$('td:eq(6)', nRow).html('已归档');
	} else if(aData.status == "7") {
		$('td:eq(6)', nRow).html('取消申请');
	} else if(aData.status == "8" || aData.status == "9" || aData.status == "10" || aData.status == "11" || aData.status == "12") {
		$('td:eq(6)', nRow).html('提交申请');
	} else if((aData.status == null || aData.status== "") && aData.collectionCompany != '累计') {
		$('td:eq(6)', nRow).html('未提交');
	}

	$('td:eq(0)', nRow)[0].style.textAlign = "center";
	$('td:eq(1)', nRow)[0].style.textAlign = "left";
	$('td:eq(2)', nRow)[0].style.textAlign = "left";
	$('td:eq(3)', nRow)[0].style.textAlign = "right";
	$('td:eq(4)', nRow)[0].style.textAlign = "center";
	$('td:eq(5)', nRow)[0].style.textAlign = "center";
	$('td:eq(6)', nRow)[0].style.textAlign = "left";
	/*
	 * 审批状态
	 * 0：提交申请  1:项目负责人审批 2：部门经理审批 3：财务审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：项目负责人不同意 9：部门经理不同意 10：财务不同意
	 * 11：总经理不同意 12：出纳不同意  
	 * */
	/*if(aData.status == 0 || aData.status == 8 || aData.status == 9 || aData.status == 10 || aData.status == 11|| aData.status == 12) {
		$('td:eq(5)', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq(5)', nRow).html('项目负责人审批');
	}  else if(aData.status == 2) {
		$('td:eq(5)', nRow).html('部门经理审批');
	} else if(aData.status == 3) {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == 4) {
		$('td:eq(5)', nRow).html('总经理审批');
	}else if(aData.status == 5) {
		$('td:eq(5)', nRow).html('已归档');
	}else if(aData.status == 6) {
		$('td:eq(5)', nRow).html('已归档');
	}else if(aData.status == 7){
		$('td:eq(5)', nRow).html('取消申请');
	}else{
		$('td:eq(5)', nRow).html('未提交');
	}*/
	
	buildOperate(nRow, aData);
    return nRow;
}


/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	//发票详情跳转
	if(aData.status !=null && aData.status !=''){
		$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
	}else{
		$(nRow).attr("onclick","parent.location.href='"+web_ctx+"/manage/sale/finInvoiced/toAddOrEdit?id="+aData.id+"&barginManageId="+aData.barginManageId+"'");
	}
	$(nRow).css("cursor", "pointer");
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
	$("#status").val(' ');
	$("#td1,#td2").hide();
	drawTable();
}


function toProcess(processInstanceId) {
    var param = {
        "processInstanceId": processInstanceId,
        "page": "manage/finance/collection/processInvoice"
    }
    parent.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function initInputMask(val){
	if (/[^0-9\.]/.test(val))
        return "0.00";
    if (val == null || val == "null" || val == "")
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
function toAdd() {
	window.location.href = "toAdd";
}