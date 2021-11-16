var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/collection/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});



function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'applicant'},    
        {"mData": 'applicant'}, 
        {"mData": 'barginManage'},
        {"mData": 'projectManage'}, 
        {"mData": 'payCompany'}, 
        {"mData": 'applyPay'}, 
        {"mData": 'applyTime'},
        {"mData": 'status'},
        
    ]
	return columns;
}

function getSearchData() {
    var status = "";
	var params = {};
    params.fuzzyContent = $.trim($("#fuzzyContent").val());
    params.status = $.trim($("#status").val());
	return params;
}


function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	$('td:eq(1)', nRow).html(aData.applicant.name);
	
	if(aData.barginManage != null){
		$('td:eq(2)', nRow).html(aData.barginManage.barginCode);
	}else{
		$('td:eq(2)', nRow).html();
	}
	if(aData.projectManage != null){
		$('td:eq(3)', nRow).html(aData.projectManage.name);
	}else{
		$('td:eq(3)', nRow).html();
	}
	$('td:eq(4)', nRow).html(aData.payCompany);
	$('td:eq(5)', nRow).html(aData.applyPay);
	$('td:eq(6)', nRow).html(new Date(aData.applyTime).pattern("yyyy-MM-dd"));
	
	
	if(aData.isNewProcess == 1) {
		/*
		 * 新流程审批状态
		 * 0： 重新申请 1：项目负责人审批 2：总经理审批 3 已归档 4：取消申请  5 项目负责人不同意 6：总经理不同意 
		 * */
		if(aData.status == 0 || aData.status == 5 || aData.status == 6 || aData.status == 8) {
			$('td:eq(7)', nRow).html('提交申请');
		} else if(aData.status == 1) {
			$('td:eq(7)', nRow).html('项目负责人审批');
		}  else if(aData.status == 2) {
			$('td:eq(7)', nRow).html('总经理审批');
		} else if(aData.status == 3) {
			$('td:eq(7)', nRow).html('已归档');
		} else if(aData.status == 4) {
			$('td:eq(7)', nRow).html('取消申请');
		}else if(aData.status == 5) {
			$('td:eq(7)', nRow).html('项目负责人不同意');
		}else if(aData.status == 6) {
			$('td:eq(7)', nRow).html('总经理不同意');
		}else if(aData.status == 7) {
			$('td:eq(7)', nRow).html('复核审批');
		}else if(aData.status == 8) {
			$('td:eq(7)', nRow).html('复核不同意');
		}else{
			$('td:eq(7)', nRow).html('未提交');
		}
	}else {
		/*
		 * 审批状态
		 * 0： 重新申请 1：部门经理审批 2：总经理审批 3 财务审批 5：已归档 5：取消申请6：部门经理不同意 7：总经理不同意
		 * */
		if(aData.status == 0 || aData.status == 7 || aData.status == 8 || aData.status == 9 || aData.status == 10|| aData.status == 15) {
			$('td:eq(7)', nRow).html('提交申请');
		} else if(aData.status == 14) {
			$('td:eq(7)', nRow).html('项目负责人审批');
		}  else if(aData.status == 1) {
			$('td:eq(7)', nRow).html('部门经理审批');
		} else if(aData.status == 2) {
			$('td:eq(7)', nRow).html('财务审批');
		} else if(aData.status == 3) {
			$('td:eq(7)', nRow).html('总经理审批');
		}else if(aData.status == 4) {
			$('td:eq(7)', nRow).html('出纳审批');
		}else if(aData.status == 5) {
			$('td:eq(7)', nRow).html('已归档');
		}else if(aData.status == 6){
			$('td:eq(7)', nRow).html('取消申请');
		}else{
			$('td:eq(7)', nRow).html('未提交');
		}
	}
	
	buildOperate(nRow, aData);
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
			$(nRow).attr("onclick", "toProcess(\""+aData.processInstanceId+"\",1,\""+aData.isNewProcess+"\")");
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
}


function toProcess(processInstanceId,isNewProject,isNewProcess) {
	if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
	        browser.versions.iPhone || browser.versions.iPad){
	        var param = {
	            "processInstanceId": processInstanceId,
	            "page": "manage/finance/collection/mobileprocess"
	        }
	    }else{
			var page="";
			if(isNewProject == 1){
				if(isNewProcess == 1) {
					page="manage/finance/collection/processNew";
				}else {
					page="manage/finance/collection/processNew_bak";
				}
			}else{
				page="manage/finance/collection/process";
			}
			var param = {
				"processInstanceId": processInstanceId,
				"page": page
			}
	    }
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}


function toAdd() {
	window.location.href = "toAddNew";
}