var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/collection/getCollectionListNew",
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

$("#status").change(function(){
	drawTable();
});

function initColumn() {
	if(status == '1') {
		var columns =  [ //这个属性下的设置会应用到所有列
			{"mData": 'barginManage.barginCode'},
			{"mData": 'barginManage.barginName'},
			{"mData": 'projectManage.name'},
			{"mData": 'barginManage.totalMoney'},
			{"mData": 'applyPay'},
		]
	}else {
		var columns =  [ //这个属性下的设置会应用到所有列
			{"mData": 'barginManage'},
			{"mData": 'barginManage'},
			{"mData": 'projectManage'},
			{"mData": 'barginManage'},
			{"mData": 'applyMoney'},
		]
	}
	return columns;
}

var status = '1';
function getSearchData() {
	var params = {};
    params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.status = $.trim($("#status").val());
	if(params.status == '1') {
		$("#replace")[0].textContent="收款金额";
	}else {
		$("#replace")[0].textContent="付款金额";
	}
	status = $.trim($("#status").val());
	return params;
}

function rowCallBack(nRow, aData, iDisplayIndex) {
	if(status == '1') {
		if (aData.barginManage != null) {
			$('td:eq(0)', nRow).html(aData.barginManage.barginCode);
		} else {
			$('td:eq(0)', nRow).html("");
		}

		if (aData.barginManage != null) {
			$('td:eq(1)', nRow).html("<div style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+aData.barginManage.barginName+"<div>");
		} else {
			$('td:eq(1)', nRow).html("");
		}

		if (aData.projectManage != null) {
			$('td:eq(2)', nRow).html("<div style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+aData.projectManage.name+"<div>");
		} else {
			$('td:eq(2)', nRow).html("");
		}
		
		if (aData.barginManage != null) {
			$('td:eq(3)', nRow).html(initInputMask(aData.barginManage.totalMoney));
		} else {
			$('td:eq(3)', nRow).html("");
		}
		if (aData.applyPay != null) {
			$('td:eq(4)', nRow).html(initInputMask(aData.applyPay));
		} else {
			$('td:eq(4)', nRow).html("");
		}
	}else {
		if (aData.barginManage != null) {
			$('td:eq(0)', nRow).html(aData.barginManage.barginCode);
		} else {
			$('td:eq(0)', nRow).html("");
		}

		if (aData.barginManage != null) {
			$('td:eq(1)', nRow).html("<div style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+aData.barginManage.barginName+"<div>");
		} else {
			$('td:eq(1)', nRow).html("");
		}
		
		if (aData.projectManage != null) {
			$('td:eq(2)', nRow).html("<div style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+aData.projectManage.name+"<div>");
		} else {
			$('td:eq(2)', nRow).html("");
		}
		
		if (aData.barginManage != null) {
			$('td:eq(3)', nRow).html(initInputMask(aData.barginManage.totalMoney));
		} else {
			$('td:eq(3)', nRow).html("");
		}
		if (aData.applyMoney != null) {
			$('td:eq(4)', nRow).html(initInputMask(aData.applyMoney));
		} else {
			$('td:eq(4)', nRow).html("");
		}
	}

	$('td:eq(0)', nRow)[0].style.textAlign = "center";
	$('td:eq(1)', nRow)[0].style.textAlign = "left";
	$('td:eq(2)', nRow)[0].style.textAlign = "left";
	$('td:eq(3)', nRow)[0].style.textAlign = "right";
	$('td:eq(4)', nRow)[0].style.textAlign = "right";


	/*if(aData.projectManage != null){
		$('td:eq(4)', nRow).html(aData.projectManage.name);
	}else{
		$('td:eq(4)', nRow).html();
	}	
	/!*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：总经理审批 3 财务审批 5：已归档 5：取消申请6：部门经理不同意 7：总经理不同意
	 * *!/
	if(aData.status == 0 || aData.status == 7 || aData.status == 8 || aData.status == 9 || aData.status == 10|| aData.status == 15) {
		$('td:eq(5)', nRow).html('提交申请');
	} else if(aData.status == 14) {
		$('td:eq(5)', nRow).html('项目负责人审批');
	}  else if(aData.status == 1) {
		$('td:eq(5)', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == 3) {
		$('td:eq(5)', nRow).html('总经理审批');
	}else if(aData.status == 4) {
		$('td:eq(5)', nRow).html('出纳审批');
	}else if(aData.status == 5) {
		$('td:eq(5)', nRow).html('已归档');
	}else if(aData.status == 6){
		$('td:eq(5)', nRow).html('取消申请');
	}else if((aData.status == null || aData.status== "") && aData.payCompany != '累计') {
		$('td:eq(5)', nRow).html('未提交');
	}*/
	
	if(aData.payCompany == '累计'){
		$('td:eq(0)', nRow).html(aData.payCompany);	
		nRow.bgColor = "#EDEDED";
	}else{
		buildOperate(nRow, aData);
	}
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	//如果是项目管理模块新增，则跳转至项目管理模块的收款申请页面
	if(status == '1') {
		if (aData.isNewProject == 1) {
			if (aData.status == null) {
				$(nRow).attr("onclick", "parent.location.href='" + web_ctx + "/manage/finance/collection/toAddNew?id=" + aData.id + "'");
			} else {
				$(nRow).attr("onclick", "toProcess(\"" + aData.processInstanceId + "\",1)");
			}
		} else {
			if (aData.status == null) {
				$(nRow).attr("onclick", "location.href='" + web_ctx + "/manage/finance/collection/edit?id=" + aData.id + "'");
			} else {
				$(nRow).attr("onclick", "toProcess(\"" + aData.processInstanceId + "\")");
			}
		}
	}else {
			if(aData.status != null){
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
			}else{
				$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/finance/pay/toAddOrEdit?id="+aData.id+"'");
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
	$("#status").val('1');
	drawTable();
}

function toProcess(processInstanceId,isNewProject) {
	var page = "";
	if(status =='1') {
		if (isNewProject == 1) {
			page = "manage/finance/collection/processNew";
		} else {
			page = "manage/finance/collection/process";
		}
		var param = {
			"processInstanceId": processInstanceId,
			"page": page
		}
	} else {
		var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/finance/pay/process"
		}
	}
	
	window.parent.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function initInputMask(val){
	if (/[^0-9\.]/.test(val))
        return "0.00";
    if (val == null || val == "null" || val == "")
        return "0.00";
    val = val.toString().replace(/^(\d*)$/, "$1.");
    val = (val + "00").replace(/(\d*\.\d\d)\d*/, "$1");
    val = val.replace(".", ",");
    var re = /(\d)(\d{3},)/;
    while (re.test(val))
        val = val.replace(re, "$1,$2");
    val = val.replace(/,(\d\d)$/, ".$1");
//    if (type == 0) {
//        var a = val.split(".");
//        if (a[1] == "00") {
//            val = a[0];
//        }
//    }
    return val;
}

function toAdd() {
	window.location.href = "toAdd";
}