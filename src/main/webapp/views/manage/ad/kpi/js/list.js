var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/kpi/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	
	$(document).keydown(function(event){
		if(event.which == 13){
			drawTable();
			return false; // 防止刷新整个页面
		}
	});
	
	initDatetimepicker();
	
});

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'deptName'},  //姓名
	    {"mData": 'userName'},
	    {"mData": 'date'},
	    {"mData": 'ceoScore'},
	    {"mData": 'ceoPraisedPunished'},
    ]
	return columns;
}


function initDatetimepicker() {
	$("#beginDate, #endDate").datetimepicker({
		minView: "2",
		language:"zh-CN",
		format: "yyyy-mm",
        pickDate: false,
        pickTime: false,
        autoclose: true,
    });
}


function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.beginDate = $.trim($("#beginDate").val());
	params.endDate = $.trim($("#endDate").val());
	params.selectIsDelete = $.trim($("#selectIsDelete").val());//是否离职查询条件
	if(!isNull(params.beginDate)) {
		params.beginDate += "-01 0:0:0";
		console.log(params.beginDate);
	}
	if(!isNull(params.endDate)) {
		params.endDate += "-31 23:59:59";
	}
	
	return params;
}



/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if(aData.deptName  != null) {
		$('td:eq(0)', nRow).html(aData.deptName);
	}
	
	if( !isNull(aData.userName) ) {
		$('td:eq(1)', nRow).html(aData.userName);
	}
	
	if( !isNull(aData.date) ) {
		$('td:eq(2)', nRow).html(new Date(aData.date).pattern("yyyy-MM"));
	}
	
	if( !isNull(aData.ceoScore) ) {
		$('td:eq(3)', nRow).html(aData.ceoScore);
	}
	
	if( !isNull(aData.ceoPraisedPunished) ) {
		$('td:eq(4)', nRow).html(aData.ceoPraisedPunished);
	}
	buildOperate(nRow,aData);
    return nRow;
}


/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow, aData) {
}




function clearForm() {
	$("#searchForm").clear();
	$("#selectIsDelete").val(0);
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
	}
});
