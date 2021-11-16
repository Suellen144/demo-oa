var dataTable = null;
$(function() {
	initDatetimepicker();
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/barginManage/getListNew",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});

function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
		{"mData": 'barginCode'},
		{"mData": 'barginName'},
		{"mData": 'projectManage.name'},
		{"mData": 'company'},
		{"mData": 'totalMoney'},
		{"mData": 'userName'},
		{"mData": 'startTime'},
		/*{"mData": 'barginType'}, */
        {"mData": 'status'}      		
    ]
	return columns;
}
$("#status").change(function(){
	drawTable();
});
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
        autoclose: true,
    });
	
	$("input[name='endTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
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
	$('td:eq(0)',nRow).html(aData.barginCode);
	
	if(aData.barginName == null){
		$('td:eq(1)',nRow).html("");
	}else{
        /*$('td:eq(0)',nRow).html(aData.barginName);*/
		$('td:eq(1)',nRow).html("<div title='"+ aData.barginName +"' style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:400px;'>"+ aData.barginName +"<div>");
	}
	
	if(aData.projectManageId == null){
		$('td:eq(2)',nRow).html("");
	}else{
		/*$('td:eq(5)',nRow).html(aData.projectManage.name);*/
		$('td:eq(2)',nRow).html("<div title='"+ aData.projectManage.name +"' style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:300px;'>"+ aData.projectManage.name +"<div>");
		
	}
	$('td:eq(3)',nRow).html("<div title='"+ aData.company +"' style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:300px;'>"+aData.company+"<div>");
	if(aData.totalMoney == 0){
		$('td:eq(4)',nRow).html(0.0);
	}else{
        $('td:eq(4)',nRow).html(formatCurrency(aData.totalMoney));
	}
	if(aData.userName != null ){
		$('td:eq(5)', nRow).html(aData.userName);
	}else{
		$('td:eq(5)', nRow).html("");
	}
	if(aData.startTime!=null && aData.startTime != ''){
		$('td:eq(6)', nRow).html(new Date(aData.startTime).pattern("yyyy-MM-dd"));
	}else{
		$('td:eq(6)', nRow).html("");
	}
	
//	if(aData.barginType == "B") {
//		$('td:eq(7)', nRow).html('采购合同');
//	} else if(aData.barginType == "S") {
//		$('td:eq(7)', nRow).html('销售合同');
//	} else if(aData.barginType == "C") {
//		$('td:eq(7)', nRow).html('合作协议');
//	} else if(aData.barginType == "L") {
//		$('td:eq(7)', nRow).html('劳动合同');
//	} else if(aData.barginType == "M") {
//		$('td:eq(7)', nRow).html('备忘录');
//	} else if(aData.barginType == "E") {
//		$('td:eq(7)', nRow).html('融投资协议');
//	}	
	if(aData.status == "14") {
		$('td:eq(7)', nRow).html('项目负责人审批');
	} else if(aData.status == "1") {
		$('td:eq(7)', nRow).html('部门经理审批');
	} else if(aData.status == "2") {
		$('td:eq(7)', nRow).html('财务审批');
	} else if(aData.status == "12") {
		$('td:eq(7)', nRow).html('财务总监审批');
	} else if(aData.status == "3") {
		$('td:eq(7)', nRow).html('总经理审批');
	} else if(aData.status == "4") {
		$('td:eq(7)', nRow).html('出纳确认');
	}else if(aData.status == "5") {
		$('td:eq(7)', nRow).html('已归档');
	} else if(aData.status == "6") {
		$('td:eq(7)', nRow).html('取消申请');
	} else if(aData.status == "7" || aData.status == "8" || aData.status == "9" || aData.status == "10") {
		$('td:eq(7)', nRow).html('提交申请');
	} else if(aData.status == null || aData.status== "") {
		$('td:eq(7)', nRow).html('未提交');
	} else if(aData.status == "11") {
		$('td:eq(7)', nRow).html('已作废');
	} 
	$('td:eq(0)', nRow)[0].style.textAlign = "center";
	$('td:eq(1)', nRow)[0].style.textAlign = "left";
	$('td:eq(2)', nRow)[0].style.textAlign = "left";
	$('td:eq(3)', nRow)[0].style.textAlign = "left";
	$('td:eq(4)', nRow)[0].style.textAlign = "right";
	$('td:eq(5)', nRow)[0].style.textAlign = "center";
	$('td:eq(6)', nRow)[0].style.textAlign = "center";
//	$('td:eq(7)', nRow)[0].style.textAlign = "center";
	$('td:eq(7)', nRow)[0].style.textAlign = "left";
	// 操作
	var htmlText = buildOperate(nRow,aData);
	$('td:eq(9)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意 
 * 
 **/
function buildOperate(nRow,aData) {
	var html = [];
	//新项目管理模块--如果是新项目管理模块新增的，则跳转至新增页面
	if(aData.isNewProject == 1){
		if( aData.processInstanceId != null  && aData.status != null){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+","+aData.isNewProject+",'"+aData.barginType+"')");
		}else if ( aData.processInstanceId == null  && aData.status == "5" && $("#currUserId").val() != aData.userId){
			//原来数据库的数据，手动变成已归档状态,他人只可以看
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/view?id="+aData.id+"'");
		}else{
			//原来数据库的数据，手动变成已归档状态，申请人自己可更改
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/toAddOrEdit?id="+aData.id+"'");
		}
	}else{
		if( aData.processInstanceId != null  && aData.status != null){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
			
		}else if ( aData.processInstanceId == null  && aData.status == "5" && $("#currUserId").val() != aData.userId){
			//原来数据库的数据，手动变成已归档状态,他人只可以看
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/view?id="+aData.id+"'");
		}else{
			//原来数据库的数据，手动变成已归档状态，申请人自己可更改
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/toAddOrEdit?id="+aData.id+"'");
		}
	}
	
	$(nRow).css("cursor", "pointer");
	return html.join("");
}


//添加回车响应事件
$(document).keydown(function(event){
	if(event.which == 13) {
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

function toProcess(processInstanceId,isNewProject,barginType) {
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/sale/barginManage/mobileprocess"
        }
    }else {
    	var page="";
    	if(isNewProject == 1){
    		if(barginType == 'S'){
    			//销售合同跳转
    			page="manage/sale/barginManage/processMarketNew";
    		}else if(barginType == 'B'){
    			//采购合同跳转
    			page="manage/sale/barginManage/processMarketProcurement";
    		}else if(barginType == 'C'){
    			//合作协议跳转 原合同页面，合作协议项目管理模块未做更改
    			page="manage/sale/barginManage/processMarketAgreement";
    		}else{
    			page="manage/sale/barginManage/process";
    		}
    	}else{
    		page="manage/sale/barginManage/process";
    	}
        var param = {
            "processInstanceId": processInstanceId,
            "page": page
        }
    }
    parent.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function toAddOrEdit(id){
	parent.location.href = web_ctx + "/manage/sale/barginManage/toAddOrEdit";
}
//金钱格式化
function formatCurrency(num) {
    num = num.toString().replace(/\$|\,/g,'');
    if(isNaN(num))
        num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
            num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + num + '.' + cents);
}
