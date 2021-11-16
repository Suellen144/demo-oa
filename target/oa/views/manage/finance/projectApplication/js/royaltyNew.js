var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/projectApplication/getRoyalyListNew",
		"columns": initColumn(),
		"paging": false,
		"pageSize": 10000,
		"info":false,
		"search": getSearchData,
		"rowCallBack": rowCallBack,
		"oLanguage":{
			"sZeroRecords": "没有检索到数据",
			"sProcessing": "正在加载数据..."
		}
	});
	$("#dataTable2 th:eq(3)").text('');
	initDatetimepicker();
});


function initDatetimepicker() {
	$("#stopTime").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		pickDate: true,
		pickTime: false,
		autoclose: true,
	});
}

$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'deptId'},
        {"mData": 'userName'},
        {"mData": 'adRecord'},
        {"mData": 'allocations'},
        /*{"mData": 'performanceRank'},*/
    ]
	return columns;
}

function getSearchData() {
	var params = {};
	params.stopTime = $.trim($("#stopTime").val() +" 23:59:59");
	if($("#stopTime").val() != "" && $("#stopTime").val() != "") {
		$("#dataTable2 th:eq(3)").text($.trim($("#stopTime").val()));
	}else {
		$("#dataTable2 th:eq(3)").text('');
	}
	return params;
}

function rowCallBack(nRow, aData, iDisplayIndex) {
	console.log(aData);
	if(aData.deptId == '4'){
		$('td:eq(0)', nRow).html('行政部');
	}else if(aData.deptId == '5') {
		$('td:eq(0)', nRow).html('研发部');
	}else if(aData.deptId == '6') {
		$('td:eq(0)', nRow).html('工程部');
	}else if(aData.deptId == '35' ||aData.deptId == '36'||aData.deptId == '37'||aData.deptId == '38'||aData.deptId == '39'||aData.deptId == '3') {
		$('td:eq(0)', nRow).html('市场部');
	}
	if(aData.adRecord != null) {
		$('td:eq(2)', nRow).html(aData.adRecord.position);
	}

	if(aData.allocations != null){
		$('td:eq(3)', nRow).html(formatCurrency(aData.allocations));
	}
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	//如果是项目管理模块新增，则跳转至项目管理模块的收款申请页面
	if(aData.isNewProject == 1){
		if(aData.status == null){
			$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/collection/toAddNew?id="+aData.id+"'");
		}else{
			$(nRow).attr("onclick", "toProcess(\""+aData.processInstanceId+"\",1)");
		}
	}else{
		if(aData.status == null){
			$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/collection/edit?id="+aData.id+"'");
		}else{
			$(nRow).attr("onclick", "toProcess(\""+aData.processInstanceId+"\")");
		}
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
	$("#dataTable2 th:eq(3)").text("");
}

function toProcess(processInstanceId,isNewProject) {
	var page = "";
	if(isNewProject == 1){
		page="manage/finance/collection/processNew";
	}else{
		page="manage/finance/collection/process";
	}
	var param = {
			"processInstanceId": processInstanceId,
			"page": page
	}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function toAdd() {
	window.location.href = "toAdd";
}

//时间格式化
Date.prototype.format = function(fmt) {
	var o = {
		"M+" : this.getMonth()+1,                 //月份
		"d+" : this.getDate(),                    //日
		"h+" : this.getHours(),                   //小时
		"m+" : this.getMinutes(),                 //分
		"s+" : this.getSeconds(),                 //秒
		"q+" : Math.floor((this.getMonth()+3)/3), //季度
		"S"  : this.getMilliseconds()             //毫秒
	};
	if(/(y+)/.test(fmt)) {
		fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	}
	for(var k in o) {
		if(new RegExp("("+ k +")").test(fmt)){
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
		}
	}
	return fmt;
}

//金钱格式化
function formatCurrency(num) {
	num = num.toString().replace(/\$|\,/g,'');
	if(isNaN(num))
		num = "0";
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*100+0.50000000001);
	cents = num%100;
	num = Math.floor(num/100).toString();
	if(cents<10)
		cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
		num = num.substring(0,num.length-(4*i+3))+','+
			num.substring(num.length-(4*i+3));
	return (((sign)?'':'-') + num + '.' + cents);
}

//反转金钱格式化
function rmoney(s)
{
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

function toProcess(processInstanceId){
	if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
		browser.versions.iPhone || browser.versions.iPad){
		var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/sale/projectManageNew/mobileprocess"
		}
	}else {
		var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/sale/projectManageNew/process"
		}
	}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}