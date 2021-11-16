var dataTable = null;
$(function() {
	
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/travelReimburs/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
});

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'applicant'}, 
        {"mData": 'createDate'}, //mData 表示发请求时候本列的列明，返回的数据中相同下标名字的数据会填充到这一列
        {"mData": 'name'},  //出差人员
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


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
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
	
/*	var htmlText = buildOperate(aData);*/
/*	$('td:eq('+(eq+4)+')', nRow).html(htmlText);*/
	
	//审批状态 0：申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：驳回 7：审批通过 8：审批不通过 9：取消申请
	if(aData.status == 0) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('部门经理审批');
	} else if(aData.status == 13) {
		$('td:eq('+(eq+3)+')', nRow).html('总经理助理审批');
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
			|| aData.status == 10 || aData.status == 12 ||  aData.status == 14) {
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
/*	var html = [];
	if(aData.status == null){
		html.push("<a href='"+web_ctx+"/manage/finance/travelReimburs/toEdit?id="+aData.id+"'>修改申请</a>");
	}
	else{
		html.push("<a href='javascript:;' onclick='toProcess("+aData.processInstanceId+")'>查看流程</a>");
	}
	return html.join("");*/
	$(tr).css("cursor", "pointer");
	if(aData.status == null){
			$(tr).attr("onclick","location.href='"+web_ctx+"/manage/finance/travelReimburs/toEdit?id="+aData.id+"'");
	}
	else{
			$(tr).attr("onclick","toProcess("+aData.processInstanceId+")");
	}	
	
	
}

function toAdd() {
	window.location.href = "toAdd";
}

function toProcess(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/travelReimburs/process",
		"entityClass": "com.reyzar.oa.domain.FinTravelReimburs",
		"tableName": "fin_travelreimburs"
	}
	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}


function toEdit(id) {
	window.location.href = "toEdit";
}