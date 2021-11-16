var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/office/contacts/getContactsList",
		"pageSize": 10000,
		"orderable": true, // 开启排序
		"defaultOrders": [[0,'desc'],[1,'desc']], // 第1、2列默认降序排序
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack
	});
	
	$(document).keydown(function(event){
		if(event.which == 13){
			drawTable();
			return false; // 防止刷新整个页面
		}
	});
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'dept'},  //部门
	    {"mData": 'name'},  //姓名
	    {"mData": 'position', orderable: false},  //职位，不需要排序的列加上 orderable:false
	    {"mData": 'phone', orderable: false},  //手机
	    {"mData": 'email', orderable: false},  //邮箱
	    {"mData": 'qq', orderable: false}  //QQ
    ]
	return columns;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if( !isNull(aData.deptName) && aData.deptName.indexOf("总经理") <= -1 ) {
		$('td:eq(0)', nRow).html(aData.deptName);
	} else {
		$('td:eq(0)', nRow).html("");
	}
	$('td:eq(1)', nRow).html(aData.name);
	$('td:eq(2)', nRow).html(aData.position);
	if(aData.phone == null){
		$('td:eq(3)', nRow).html("");
	}
	else{
		$('td:eq(3)', nRow).html(aData.phone);
	}
	if(aData.email == null){
		$('td:eq(4)', nRow).html("");
	}
	else{
		$('td:eq(4)', nRow).html(aData.email);
	}
	
	if(aData.qq == null){
		$('td:eq(5)', nRow).html("");
	}
	else{
		$('td:eq(5)', nRow).html(aData.qq);
	}
    return nRow;
}


function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}
