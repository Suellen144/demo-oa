var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/barginUserAnnual/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	initDatetimepicker();
});


function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'annual'},
		{"mData": 'creatDate'},
		{"mData": 'creatBy'},
		// {"mData": 'Dtail'},

    ]

	return columns;
}

function getSearchData() {
	var params = {};
	var status = "";
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());
	params.status = $.trim($("#status").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	
	if(!isNull(params.startTime)) {
		params.startTime += " 0:0:0";
	}
	if(!isNull(params.endTime)) {
		params.endTime += " 23:59:59";
	}

	return params;
}


function initDatetimepicker() {
	$("input[name='startTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("input[name='endTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}


/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}

	if (aData.annual == ""|| aData.annual == null){
        $('td:eq(0)',nRow).html("");
	}else {
        $('td:eq(0)',nRow).html(aData.annual);
	}

	if (aData.createDate == "" || aData.createDate == null){
        $('td:eq(1)',nRow).html("");
	}else {
        $('td:eq(1)',nRow).html(new Date(aData.createDate).pattern("yyyy-MM"));
	}

	if(aData.createDate == "" || aData.createDate == null){
        $('td:eq(2)',nRow).html("");
	}else {
        $('td:eq(2)',nRow).html(aData.createBy);
	}

	// // 操作
	var htmlText = buildOperate(nRow,aData);
	$('td:eq(3)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情：
 **/
function buildOperate(nRow,aData) {
	var html = [];
	// if( aData.barginId != null){
		$(nRow).attr("onclick", "toDtail("+aData.id+")");
		
	// }else if ( aData.processInstanceId == null  && aData.status == "5" && $("#currUserId").val() != aData.userId){
	// 	//原来数据库的数据，手动变成已归档状态,他人只可以看
	// 	$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/sale/barginManage/view?id="+aData.id+"'");
	// }else{
	// 	//原来数据库的数据，手动变成已归档状态，申请人自己可更改
	// 	$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/sale/barginManage/toAddOrEdit?id="+aData.id+"'");
	// }
	//
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
	$("#startTime").prop("readonly", true);
	$("#endTime").prop("readonly", true);
}


function toDtail(id) {
    window.location.href = web_ctx + "/manage/sale/barginUserAnnualAttach/toAddOrEdit?id="+id;
}


// function toAddOrEdit(id){
//
// 	window.location.href = web_ctx + "/manage/sale/barginManage/toAddOrEdit";
// }

function addNewAnnual() {
	window.location.href = web_ctx + "/manage/sale/barginUserAnnualAttach/toAddOrEdit";
}