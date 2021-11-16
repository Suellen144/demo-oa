var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/commonPay/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'dept'}, 
        {"mData": 'user'},
        {"mData": 'voucherTime'},
        {"mData": 'payCompany'},
        {"mData": 'createDate'}
    ]

	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.payCompany = $.trim($("#payCompany").val());
	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if(aData.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}else{
		$('td:eq(0)', nRow).html(aData.dept.name);
	}
	if(aData.user != null){
		$('td:eq(1)', nRow).html(aData.user.name);
	}else{
		$('td:eq(1)', nRow).html("");
	}
	if (aData.voucherTime == "" || aData.voucherTime == null) {
		$('td:eq(2)', nRow).html("");
	}
	else {
		$('td:eq(2)', nRow).html(new Date(aData.voucherTime).pattern("yyyy-MM"));
	}
	if(aData.payCompany == "11"){
		$('td:eq(3)', nRow).html("睿哲科技股份有限公司");
	}
	else if(aData.payCompany == "1"){
		$('td:eq(3)', nRow).html("新疆睿哲网络科技有限公司");
	}
	else if(aData.payCompany == "2"){
		$('td:eq(3)', nRow).html("深圳睿哲网络科技有限公司");
	}
	else if(aData.payCompany == "3"){
		$('td:eq(3)', nRow).html("四川睿哲网络科技有限公司");
	}
	else if(aData.payCompany == "4"){
		$('td:eq(3)', nRow).html("河南润哲网络科技有限公司");
	}
	else if(aData.payCompany == "6"){
		$('td:eq(3)', nRow).html("睿哲科技(香港)办事处");
	}
	else if(aData.payCompany == "7"){
		$('td:eq(3)', nRow).html("福建润哲网络科技有限公司");
	}
	else if(aData.payCompany == "8"){
		$('td:eq(3)', nRow).html("北京睿哲广联科技有限公司");
	}
	else if(aData.payCompany == "9"){
		$('td:eq(3)', nRow).html("睿哲科技(郑州)办事处");
	}
	else if(aData.payCompany == "10"){
		$('td:eq(3)', nRow).html("沈阳睿哲科技有限公司");
	}

	$('td:eq(4)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	// 操作
	var htmlText = buildOperate(nRow,aData);
	$('td:eq(5)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳审批 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意 10：出纳不同意
 **/
function buildOperate(nRow,aData) {
	var html = [];
	$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/finance/commonPay/toAddOrEdit?id="+aData.id+"'");
	
	$(nRow).css("cursor", "pointer");
	return html.join("");
}


//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function toProcess(processInstanceId){
	var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/finance/pay/process"
		}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function toAddOrEdit(id){
	window.location.href = web_ctx + "/manage/finance/commonPay/toAddOrEdit?id="+id;
}

function add(){
	window.location.href = web_ctx + "/manage/finance/commonPay/toAddOrEdit";
}

