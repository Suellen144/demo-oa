var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/salary/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'applyTime'},             
        {"mData": 'tittle'}, 
        {"mData": 'status'},
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
/*	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}*/
	$('td:eq(0)', nRow).html(new Date(aData.applyTime).pattern("yyyy-MM-dd"));
	
	$('td:eq('+(eq)+')', nRow).html(aData.tittle);
	/*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：HR审批 3：已归档 4：取消申请 5：部门经理不同意 6：HR不同意 
	 * */
	if(aData.status == 0) {
		$('td:eq('+(eq+1)+')', nRow).html('提交申请');
	} else if(aData.status == 1 || aData.status == 2 || aData.status == 3 || aData.status == 4) {
		$('td:eq('+(eq+1)+')', nRow).html('部门经理填报');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+1)+')', nRow).html('总经理审批');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+1)+')', nRow).html('已归档');
	} else if(aData.status == 7) {
		$('td:eq('+(eq+1)+')', nRow).html('取消申请');
	}
	
	buildOperate(nRow, aData);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "toProcess(\""+aData.processInstanceId+"\")");
	$(nRow).css("cursor", "pointer");
}

function toProcess(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/ad/salary/process"
	}
	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function toAdd() {
	parent.location.href = "toAdd";
}
function toAdd2() {
	window.location.href = web_ctx+"/manage/ad/salary/toAdd2";
}