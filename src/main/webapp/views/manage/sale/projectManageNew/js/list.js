var dataTable = null;
var projectObj = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/projectManage/getAllProject",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack
	});
//	drawTable();
	initDatetimepicker();
});

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'principal'},
        {"mData": 'size'},
        {"mData": 'totalMoney'},
        {"mData": 'confirmAmount'},
        {"mData": 'actReimburse2'},
        {"mData": 'actReimburse'},
        {"mData": 'projectDate'},
        {"mData": 'projectEndDate'}
        /*,
        {"mData": 'status'}*/
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
$("#status").change(function(){
	drawTable();
});
var status='1';
function getSearchData() {
	var params = {};
	params.status = $.trim($("#status").val());
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	if(!isNull(params.startTime)) {
		params.startTime += " 0:0:0";
	}
	if(!isNull(params.endTime)) {
		params.endTime += " 23:59:59";
	}	
	
	if(params.status == '2'){
		status=params.status;
		$("#replace1")[0].textContent="申请时间";
		$("#replace2")[0].textContent="审批环节";
	}else{
		status=params.status;
		$("#replace1")[0].textContent="立项时间";
		$("#replace2")[0].textContent="结束时间";
	}
	return params;
}

function drawTable() {
	$("#status").val($("#status").val());
	
	if(dataTable != null) {
		dataTable.draw();
	}
}

// /*添加回车响应事件*/
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey == 13){
	    //openBootstrapShade(true)
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
	$('td:eq(0)', nRow).html(aData.name);
	// 负责人
	if(aData.principal != null) {
		$('td:eq(1)', nRow).html(aData.principal.name);
	}
	//规模初始化
	if(aData.size != null){
		$('td:eq(2)', nRow).html(formatCurrency(aData.size));
	}
	
	if(aData.totalMoney != null){
		$('td:eq(3)', nRow).html(formatCurrency(aData.totalMoney));
	}else{
		$('td:eq(3)', nRow).html("0.00");
	}
    // 收入
    if(aData.confirmAmount != null) {
        $('td:eq(4)', nRow).html(formatCurrency(aData.confirmAmount));
    }else{
	    $('td:eq(4)', nRow).html("0.00");
    }
    // 支出
    if(aData.actReimburse2 != null) {
        $('td:eq(5)', nRow).html(formatCurrency(aData.actReimburse2));
    }else{
    	$('td:eq(5)', nRow).html("0.00");
    }
    // 攻关费用余额
    var sum=0.00;
    if(aData.actReimburse != null ) {
    	if(aData.researchCostLines !=null){
    		sum=aData.researchCostLines*1-aData.actReimburse;
    	}
    }else{
    	sum=aData.researchCostLines-0;
    }
    if(sum<0){
    	$('td:eq(6)', nRow)[0].style.color="red";
	}
    $('td:eq(6)', nRow).html(formatCurrency(sum));
	//如果搜索状态为 审批中，则把立项时间列改成申请时间列，结束时间列改成审批环节
	if(status == '2'){
		// 申请时间
		if(aData.submitDate != null) {
			$('td:eq(7)', nRow).html(new Date(aData.submitDate).pattern("yyyy-MM-dd"));
		}else{
			$('td:eq(7)', nRow).html("");
		}
		// 审批环节
		if(aData.statusNew == "1") {
			$('td:eq(8)', nRow).html('项目负责人审批');
		}else if(aData.statusNew == "2") {
			$('td:eq(8)', nRow).html('部门经理审批');
		} else if(aData.statusNew == "3") {
			$('td:eq(8)', nRow).html('财务审批');
		} else if(aData.statusNew == "4") {
			$('td:eq(8)', nRow).html('总经理审批');
		} else  if(aData.statusNew == "5") {
			$('td:eq(8)', nRow).html('已归档');
		} else if(aData.statusNew == "6") {
			$('td:eq(8)', nRow).html('取消申请');
		} else if(aData.statusNew == "7" || aData.status == "8" || aData.status == "9" || aData.status == "10") {
			$('td:eq(8)', nRow).html('提交申请');
		} else if(aData.statusNew == null || aData.status== "") {
			$('td:eq(8)', nRow).html('未提交');
		}
	}else{
		// 立项时间
		if(aData.projectDate != null) {
			$('td:eq(7)', nRow).html(new Date(aData.projectDate).pattern("yyyy-MM-dd"));
		}else {
			$('td:eq(7)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
		}
		// 结束时间
		if(aData.projectEndDate != null) {
			$('td:eq(8)', nRow).html(new Date(aData.projectEndDate).pattern("yyyy-MM-dd"));
		}
	}
	$('td:eq(0)', nRow)[0].style.textAlign = "left";
	$('td:eq(1)', nRow)[0].style.textAlign = "center";
	$('td:eq(2)', nRow)[0].style.textAlign = "right";
	$('td:eq(3)', nRow)[0].style.textAlign = "right";
	$('td:eq(4)', nRow)[0].style.textAlign = "right";
	$('td:eq(5)', nRow)[0].style.textAlign = "right";
	$('td:eq(6)', nRow)[0].style.textAlign = "right";
	$('td:eq(7)', nRow)[0].style.textAlign = "center";
	if(status == '2'){
		$('td:eq(8)', nRow)[0].style.textAlign = "left";
	}else {
		$('td:eq(8)', nRow)[0].style.textAlign = "center";
	}
	// 操作
	var htmlText = buildOperate(nRow,aData);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow,aData) {	
	var html = [];
	if(aData.statusNew != null){
		if(aData.processInstanceId != null){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
		}else{
			$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/sale/projectManage/toProcess?id="+aData.id+"'");
		}
	}else{
		//$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/sale/projectManage/findInfo?id="+aData.id+"'");
		$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/sale/projectManage/toEdit?id="+aData.id+"'");
	}
	
	$(nRow).css("cursor", "pointer");
	return html.join("");
}

// /*获取浏览器信息*/
function getBrowserInfo() {
    return $.extend(true, {}, browserInfo);
}

function toAdd() {
	window.location.href = web_ctx + "/manage/sale/projectManage/toEdit";
	//window.location.href = "toAdd";
}

function toAddOrEdit(id) {
	window.location.href = web_ctx + "/manage/sale/projectManage/toAddOrEdit?id=" + id;
}

// /*获取表单数据 */
function getFormData() {
	var json = $("#searchForm").serializeJson();
	var formData = $.extend(true,{},json);
	return formData;
}

//导出excel 表 --全部搜索字段
function exportExcel (){
	var params = getFormData();
		params = urlEncode(params);
		params = params.substring(1);
		var url = web_ctx +  "/manage/sale/projectManage/exportExcelOne?" + params;
		$("#excelDownload").attr("src", encodeURI(url));
		// bootstrapAlert("数据导出中","请稍等一下");
}

//时间格式化
Date.prototype.format = function(fmt) {
    var o = {
        "M+" : this.getMonth()+1,                 //月份
        "d+" : this.getDate(),                    //日
        "h+" : this.getHours(),                   //小时
        "m+" : this.getMinutes(),                 //分
        "s+" : this.getSeconds(),                 //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S"  : this.getMilliseconds()             //毫秒
    };
    if(/(y+)/.test(fmt)) {
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }
    for(var k in o) {
        if(new RegExp("("+ k +")").test(fmt)){
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        }
    }
    return fmt;
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

//反转金钱格式化
function rmoney(s)
{
    return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

function toProcess(processInstanceId){
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/sale/projectManageNew/mobileprocess"
        }
	}else {
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/sale/projectManageNew/process"
        }
	}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}
