var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/projectApplication/getProjectList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
//	drawTable();
	initDatetimepicker();
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'principal'},
        {"mData": 'size'},
        {"mData": 'applicant'},
        {"mData": 'submitDate'},
        {"mData": 'applicationType'},
        {"mData": 'statusNew'},
    ]
	
	return columns;
}

function initDatetimepicker() {
	$("#startTime, #endTime").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function getSearchData() {
	var params = {};
	params.applicationType = $.trim($("#applicationType").val());
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	if(!isNull(params.startTime)) {
		params.startTime += " 0:0:0";
	}
	if(!isNull(params.endTime)) {
		params.endTime += " 23:59:59";
	}
	
	return params;
}

function drawTable() {
	$("#name").val($("#name_duplicate").val());
	$("#type").val($("#type_duplicate").val());
	$("#status").val($("#status_duplicate").val());
	
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
	
	// 负责人
	if(aData.principal != null) {
		$('td:eq(1)', nRow).html(aData.principal.name);
	}
	//规模初始化
	if(aData.size != null){
		$('td:eq(2)', nRow).html(initInputMask(aData.size));
	}
	// 申请人
	if(aData.applicantP != null) {
		$('td:eq(3)', nRow).html(aData.applicantP.name);
	}
	// 申请类型
	if(aData.applicationType == "2") {
		$('td:eq(5)', nRow).html("变更申请");
	}else if(aData.applicationType == "1"){
		$('td:eq(5)', nRow).html("新增申请");
	}
	if(aData.submitDate !=null && aData.submitDate != '' ){
		$('td:eq(4)', nRow).html(new Date(aData.submitDate).pattern("yyyy-MM-dd HH:mm"));
	}
	/*
	 * 审批状态
	 * 0： 重新申请 1：项目负责人审批 2:部门经理审批 3：财务审批 4 总经理审批 5：已归档 5：取消申请6：部门经理不同意 7：总经理不同意
	 * */
	if(aData.statusNew == 0 || aData.statusNew == 7 || aData.statusNew == 8 || aData.statusNew == 9 || aData.statusNew == 10) {
		$('td:eq(6)', nRow).html('提交申请');
	} else if(aData.statusNew == 1) {
		$('td:eq(6)', nRow).html('项目负责人审批');
	} else if(aData.statusNew == 2) {
		$('td:eq(6)', nRow).html('部门经理审批');
	} else if(aData.statusNew == 3) {
		$('td:eq(6)', nRow).html('财务审批');
	} else if(aData.statusNew == 4) {
		$('td:eq(6)', nRow).html('总经理审批');
	}else if(aData.statusNew == 5) {
		$('td:eq(6)', nRow).html('已归档');
	}else if(aData.statusNew == 7){
		$('td:eq(6)', nRow).html('取消申请');
	}else{
		$('td:eq(6)', nRow).html('未提交');
	}
	
	// 操作
	var htmlText = buildOperate(nRow,aData);
	//$('td:eq(6)', nRow).html(htmlText);
	
    return nRow;
}

/*
 * 初始化相关操作
 *初始化金额，两位数
 */
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

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow,aData) {
	var html = [];
	if(aData.isNewProject == 1){
		if(aData.statusNew != null){
			if(aData.applicationType == 2){
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+","+aData.applicationType+")");
			}else{
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+","+aData.applicationType+")");
			}
		}else{
			$(nRow).attr("onclick", "toEdit("+aData.id+")");
		}
	}else{
			$(nRow).attr("onclick", "toAddOrEdit("+aData.id+")");
	}
	
	$(nRow).css("cursor", "pointer");
	return html.join("");
}


function toAddOrEdit(id) {
	parent.location.href  = web_ctx + "/manage/sale/projectManage/toAddOrEdit?id=" + id;
}

function toAdd() {
	parent.location.href  = web_ctx + "/manage/sale/projectManage/toEdit";
	//window.location.href = "toAdd";
}
function toEdit(id) {
	parent.location.href  = web_ctx + "/manage/sale/projectManage/toEdit?id="+id;
	//window.location.href = "toAdd";
}

function toAddOrEdit1(id) {
	parent.location.href  = web_ctx + "/manage/sale/barginManage/toAddOrEdit?projectId=" + id;
}

var idForDel = null;
var sourceForDel = null;
function del(id, source) {
	idForDel = id;
	sourceForDel = source;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id":idForDel},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		var tr = $(sourceForDel).parents("tr");
	        		dataTable.row(tr).remove().draw(false);
	        	} else {
	        		bootstrapAlert("提示", "删除出错", 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
	
}


function exportExcel(){
	var params = getSearchData();
	var url = web_ctx +  "/manage/finance/projectApplication/exportExcel?" + params;
	$("#excelDownload").attr("src", url);
}

function toProcess(processInstanceId,applicationType){
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/sale/projectManageNew/mobileprocess"
        }
	}else {
		var page ="";
		if(applicationType == 2){
			page="/manage/sale/projectManageNew/processModify";
		}else{
			page="manage/sale/projectManageNew/process";
		}
		var param = {
            "processInstanceId": processInstanceId,
            "page": page
        }
	}
    parent.location.href  = web_ctx + "/activiti/process?" + urlEncode(param);
}