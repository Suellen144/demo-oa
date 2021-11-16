var dataTable = null;

$(function() {
	initDatetimepicker()
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/reward/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initDatetimepicker() {
	$(".starttime, .endtime").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'createDate'},
        {"mData": 'title'},
    ]
	
	return columns;
}

function getSearchData() {
	return null;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 1;
	$('td:eq(0)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
	
	$('td:eq('+(eq)+')', nRow).html(aData.title);

	buildOperate(nRow, aData);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
    $(nRow).attr("onclick","location.href='"+web_ctx+"/manage/ad/reward/toEdit?id="+aData.id+"'");
	$(nRow).css("cursor", "pointer");
}

function toAdd() {
	var startTime = $('#searchForm .starttime').val().length > 0 ? $('#searchForm .starttime').val() : "";
	var endTime = $('#searchForm .endtime').val().length > 0 ? $('#searchForm .endtime').val() : "";
	window.location.href = "toAdd?startTime="+startTime+"&endTime="+endTime;
}