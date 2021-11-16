var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/reimburs/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
	    {"mData": 'applicant'}, 
	    {"mData": 'createDate'},
        {"mData": 'name'},  //报销人
        {"mData": 'orderNo'},  //报销单号
        {"mData": 'status'},  //申请状态
    ]

	return columns;
}

function getSearchData() {
	var params = {};
	params.name = $.trim($("#name").val());
	params.orderNo = $.trim($("#orderNo").val());
	params.status = $.trim($("#status").val());
	return params;
}

//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function clearForm() {
	$("#searchForm").clear();
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 1;
	$('td:eq(0)', nRow).html(aData.applicant.name);
	
	$('td:eq('+eq+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	/*var htmlText = buildOperate(aData);
	$('td:eq('+(eq+4)+')', nRow).html(htmlText);*/
	
	//审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理驳回 9：经办驳回 10：复核驳回 11：总经理驳回 12：出纳驳回
	if(aData.status == 0) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+3)+')', nRow).html('经办审批');
	} else if(aData.status == 3 || aData.status == 11) {
		$('td:eq('+(eq+3)+')', nRow).html('复核审批');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+3)+')', nRow).html('总经理审批');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+3)+')', nRow).html('出纳审批');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+3)+')', nRow).html('审批完结');
	} else if(aData.status == 7) {
		$('td:eq('+(eq+3)+')', nRow).html('取消申请');
	} else if(aData.status == 8 || aData.status == 9
			|| aData.status == 10 || aData.status == 12) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	}
	else{
		$('td:eq('+(eq+3)+')', nRow).html('申请待提交');
	}
	buildOperate(aData, nRow);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData,tr) {
	$(tr).css("cursor", "pointer");
	if(aData.status == null){
			$(tr).attr("onclick","location.href='"+web_ctx+"/manage/finance/reimburs/toEdit?id="+aData.id+"'");
	}
	else{
			$(tr).attr("onclick","toProcess("+aData.processInstanceId+")");
	}	
}

function toAdd() {
	window.location.href = "toAdd";
}

function toEdit(id) {
	window.location.href = "toEdit";
}

function toProcess(processInstanceId) {
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/finance/reimburs/mobileprocess"
        }
    }else{
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/finance/reimburs/process"
        }
    }
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}