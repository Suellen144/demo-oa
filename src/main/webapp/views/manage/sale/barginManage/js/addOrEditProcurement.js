var dataTable = null;
$(function() {
	//收票数据渲染
	dataTable= $("#table2").datatable({
			"id": "table2",
			"url": web_ctx + "/manage/sale/ticketConfirmation/getList",
			"columns": initColumn(),
			"paging": false,
			"pageSize": 1000,
			"info":false,
			"rowCallBack": rowCallBack,
			"search": getSearchData,
			"oLanguage":{
		        "sZeroRecords": "没有检索到数据",
		        "sProcessing": "正在加载数据..."
			}
		});
	
	inittextarea();
	initInputMask();
	initDatetimepicker();	
});
function getSearchData() {
	var params = {};
	params.issubmit = 1;
	var barginManageId=$("#barginManageId").val();
	if(barginManageId !=null && barginManageId !=''){
		params.barginManageId = barginManageId;
	}
	return params;
}
function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'ticketDate'},
        {"mData": 'userName'},
	    {"mData": 'ticketLines'}, 
        {"mData": 'rate'},
		{"mData": 'deductionLines'}
    ]
	return columns;
}
function rowCallBack(nRow, aData, iDisplayIndex) {
		/*if(iDisplayIndex % 2 == 0) {
			nRow.bgColor = "#EDEDED";
		}*/
		if(aData.ticketDate != null && aData.ticketDate != ''){
			$('td:eq(0)', nRow).html(dateFormatRefactoring(aData.ticketDate));
		}
		if(aData.userName !=null ){
			$('td:eq(1)', nRow).html(aData.userName);
		}else{
			$('td:eq(1)', nRow).html("");
		}
		if(aData.ticketLines != null){
			$('td:eq(2)', nRow).html(initInputMask(aData.ticketLines));
		}else{
			$('td:eq(2)', nRow).html("");
		}
		$('td:eq(3)', nRow).html(aData.rate);
		if(aData.deductionLines != null){
			$('td:eq(4)', nRow).html(initInputMask(aData.deductionLines));
		}else{
			$('td:eq(4)', nRow).html("");
		}
		if(aData.cumulative == '累计'){
			$('td:eq(0)', nRow).html(aData.cumulative);
			nRow.bgColor = "#EDEDED";
		}
	    return nRow;
	}
function trigger(){
	var rate=$("#rate").val();
	if(rate!=null && rate!=''){
		$("#rate").val(rate+"%");
	}
}
//保存信息
function save(){
//	bootstrapConfirm("提示", "是否确定保存？", 300, function() {
		var formData = getFormData();
		$("#issubmit").val("0");//区分保存和提交
		
		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		submit(formData);
	//})
}
function submitInfo() {
	bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		var formData = getFormData();
		$("#issubmit").val("1");
		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		submit(formData);
	})
}


function submit(formData){
	$.ajax({
		url: "submit",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				//backPageAndRefresh();
				dataTable.draw();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  ticketDate = $.trim($("#ticketDate").val());
	var ticketLines = $("#ticketLines").val();
	if(isNull(ticketDate)) {
		text.push("请填写收票时间！");
	}else if(isNull(ticketLines)){
		text.push("请填写收票额！");
	}
	return text;
}
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}
function del() {
	var formData = getFormData();
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",
	        "contentType": "application/json;charset=UTF-8",
	        "data": JSON.stringify(formData),
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		backPageAndRefresh();
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

/*
 * 初始化相关操作
 */
function initDatetimepicker() {
	$("input[name='ticketDate']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}

//初始化金额，两位数
function initInputMask() {
		$("#ticketLines").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#deductionLines").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
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
/**
 * 把毫秒级时间转换成字符串
 * 格式：yyyy-MM-dd
 * @param date
 * @returns {string}
 */
function dateFormatRefactoring(date) {
    var dateStr = new Date(date);
    // 重写toString方法
    Date.prototype.toLocaleString = function() {
        return this.getFullYear() + "-" + (this.getMonth() + 1) + "-" + this.getDate();
    };
    return dateStr.toLocaleString();
}

