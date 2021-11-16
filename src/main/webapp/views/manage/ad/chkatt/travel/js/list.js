var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/travel/getTravelList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": ''},
	    {"mData": 'applicant'},
        {"mData": 'createDate'},
        {"mData": 'status'},
    ]
	
	return columns;
}

$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});

function getSearchData() {
	var params = {};
/*	params.beginDate = $.trim($("#beginDate").val());
	params.endDate = $.trim($("#endDate").val());*/
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	
/*	if(!isNull(params.beginDate)) {
		params.beginDate += " 0:0:0";
	}
	if(!isNull(params.endDate)) {
		params.endDate += " 23:59:59";
	}*/
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

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	var eq = 0;
	/*$('td:eq('+eq+')', nRow).html(!isNull(aData.applicant.dept) ? aData.applicant.dept.name : '');*/
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	$('td:eq('+(eq+1)+')', nRow).html(aData.applicant.name);
	$('td:eq('+(eq+2)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	if(aData.status == 0) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('待审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+3)+')', nRow).html('已归档');
	} else if(aData.status == 3) {
		$('td:eq('+(eq+3)+')', nRow).html('取消申请');
	} else if(aData.status == 4 ||aData.status == 5) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+3)+')', nRow).html('待确认');
	}
	
	buildOperate(nRow, aData);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
	$(nRow).css("cursor", "pointer");
}


function toAdd() {
	window.location.href = "toAdd";
}

function toProcess(processInstanceId) {
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/travel/mobileprocess"
        }
	}else {
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/travel/process"
        }
	}

	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}