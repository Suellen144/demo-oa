$(function() {
	sequencecontrol();
	$("#totalMoney").val(initInputMask($("#totalMoney").val()));
	$("#contribution").val(initInputMask($("#contribution").val()));
	$("#commissionAmount").val(initInputMask($("#commissionAmount").val()));
	$("#channelExpense").val(initInputMask($("#channelExpense").val()));

	var barginRemark = $("#barginRemark").val();
	if(!isNull(barginRemark)) {
		$("#barginRemark").attr("readonly",true);
	}

    var currStatus = $("#currStatus").val();
    if(currStatus != '5' && currStatus != '11') {
        $("#barginRemarkId").hide();
    }
});
function sequencecontrol(){
	 //发票数据渲染
	 $("#table3").datatable({
		"id": "table3",
		"url": web_ctx + "/manage/sale/finInvoiced/getList",
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
	//收款数据渲染
	 $("#table4").datatable({
			"id": "table4",
			"url": web_ctx + "/manage/finance/collection/getListNew",
			"columns": initColumn1(),
			"paging": false,
			"pageSize": 1000,
			"info":false,
			"rowCallBack": rowCallBack1,
			"search": getSearchData1,
			"oLanguage":{
		        "sZeroRecords": "没有检索到数据",
		        "sProcessing": "正在加载数据..."
			}
		});
	 //收入确认数据渲染
	 $("#table5").datatable({
			"id": "table5",
			"url": web_ctx + "/manage/finance/revenueRecognition/getList",
			"columns": initColumn2(),
			"paging": false,
			"pageSize": 1000,
			"info":false,
			"rowCallBack": rowCallBack2,
			"search": getSearchData,
			"oLanguage":{
		        "sZeroRecords": "没有检索到数据",
		        "sProcessing": "正在加载数据..."
			}
		});
}
function getSearchData() {
	var params = {};
	params.barginManageId = $.trim($("#id").val());
	return params;
}
function getSearchData1() {
	var params = {};
	params.barginId = $.trim($("#id").val());
	return params;
}
function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'finInvoicedDate'},
	    {"mData": 'applyUserId.name'}, 
        {"mData": 'ticketUser'},
		{"mData": 'invoiceAmount'},
		{"mData": 'sendWay'},
		{"mData": 'status'}
    ]
	return columns;
}
function initColumn1() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'collectionDate'},
        {"mData": 'collectionType'},
	    {"mData": 'applyPay'}, 
        {"mData": 'allocations'},
		{"mData": 'channelCost'},
		{"mData": 'status'}
    ]
	return columns;
}
function initColumn2() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'confirmDate'},
        /*{"mData": 'confirmWay'},*/
	    {"mData": 'confirmAmount'}, 
        {"mData": 'resultsContribution'}
	  /*  ,
		{"mData": 'confirmPeople'},
		{"mData": 'isBeenConfirmed'}*/
    ]
	return columns;
}
/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(aData.finInvoicedDate != null && aData.finInvoicedDate != ''){
		$('td:eq(0)', nRow).html(dateFormatRefactoring(aData.finInvoicedDate));
	}
	if(aData.applyUserName != null){
		$('td:eq(1)', nRow).html(aData.applyUserName);
	}else{
		$('td:eq(1)', nRow).html("");
	}
	$('td:eq(2)', nRow).html(aData.ticketUser);
	if(aData.invoiceAmount != null){
		$('td:eq(3)', nRow).html(initInputMask(aData.invoiceAmount));
	}else{
		$('td:eq(3)', nRow).html("");
	}
	if(aData.sendWay == "1"){
		$('td:eq(4)', nRow).html('邮送');
	}else if(aData.sendWay == "2"){
		$('td:eq(4)', nRow).html('亲送');
	}else{
		$('td:eq(4)', nRow).html('');
	}
	if(aData.status == "1") {
		$('td:eq(5)', nRow).html('项目负责人审批');
	} else if(aData.status == "2") {
		$('td:eq(5)', nRow).html('部门经理审批');
	} else if(aData.status == "3") {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == "4") {
		$('td:eq(5)', nRow).html('总经理审批');
	} else if(aData.status == "13") {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == "5") {
		$('td:eq(5)', nRow).html('财务总监审批');
	} else if(aData.status == "6") {
		$('td:eq(5)', nRow).html('已归档');
	} else if(aData.status == "7") {
		$('td:eq(5)', nRow).html('取消申请');
	} else if(aData.status == "8" || aData.status == "9" || aData.status == "10" || aData.status == "11" || aData.status == "12") {
		$('td:eq(5)', nRow).html('提交申请');
	} else if((aData.status == null || aData.status== "") && aData.collectionCompany != '累计') {
		$('td:eq(5)', nRow).html('未提交');
	}
	if(aData.collectionCompany == '累计'){
		$('td:eq(0)', nRow).html(aData.collectionCompany);
		nRow.bgColor = "#EDEDED";
	}else{
		// 操作
		var htmlText = buildOperate(nRow,aData,0);
		$('td:eq(9)', nRow).html(htmlText);
	}
    return nRow;
}
function rowCallBack1(nRow, aData, iDisplayIndex) {


			/*if(aData.collectionDate != null && aData.collectionDate != ''){
				$('td:eq(0)', nRow).html(dateFormatRefactoring(aData.collectionDate));
			}
			if(aData.collectionBill != null){
				$('td:eq(2)', nRow).html(initInputMask(aData.collectionBill));
			}else{
				$('td:eq(2)', nRow).html("");
			}*/


			if(aData.applyTime != null && aData.applyTime != ''){
				$('td:eq(0)', nRow).html(dateFormatRefactoring(aData.applyTime));
			}
			if(aData.applyPay != null){
				$('td:eq(2)', nRow).html(initInputMask(aData.applyPay));
			}else{
				$('td:eq(2)', nRow).html("");
			}
			/*$("#replace1")[0].textContent="收款时间";
			$("#replace2")[0].textContent="收款金额";*/

		$('td:eq(1)', nRow).html(aData.collectionType);
		if(aData.allocations != null){
			$('td:eq(3)', nRow).html(initInputMask(aData.allocations));
		}else{
			$('td:eq(3)', nRow).html("");
		}
		if(aData.channelCost != null){
			$('td:eq(4)', nRow).html(initInputMask(aData.channelCost));
		}else{
			$('td:eq(4)', nRow).html("");
		}
		
		if(aData.isNewProcess == 1) {
			/*
			 * 新流程审批状态
			 * 0： 重新申请 1：项目负责人审批 2：总经理审批 3 已归档 4：取消申请  5 项目负责人不同意 6：总经理不同意 
			 * */
			if(aData.status == 0 || aData.status == 5 || aData.status == 6 || aData.status == 8) {
				$('td:eq(5)', nRow).html('提交申请');
			} else if(aData.status == 1) {
				$('td:eq(5)', nRow).html('项目负责人审批');
			}  else if(aData.status == 2) {
				$('td:eq(5)', nRow).html('总经理审批');
			} else if(aData.status == 3) {
				$('td:eq(5)', nRow).html('已归档');
			} else if(aData.status == 4) {
				$('td:eq(5)', nRow).html('取消申请');
			}else if(aData.status == 5) {
				$('td:eq(5)', nRow).html('项目负责人不同意');
			}else if(aData.status == 6) {
				$('td:eq(5)', nRow).html('总经理不同意');
			}else if(aData.status == 7) {
				$('td:eq(5)', nRow).html('复核审批');
			}else if(aData.status == 8) {
				$('td:eq(5)', nRow).html('复核不同意');
			}else{
				$('td:eq(5)', nRow).html('未提交');
			}
		}else {
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
			}else if((aData.status == null || aData.status== "") && aData.payCompany != '累计'){
				$('td:eq(5)', nRow).html('未提交');
			}
		}
		
		if(aData.payCompany == '累计'){
			$('td:eq(0)', nRow).html(aData.payCompany);
			nRow.bgColor = "#EDEDED";
		}else{
			// 操作
			var htmlText = buildOperate(nRow,aData,1);
			$('td:eq(9)', nRow).html(htmlText);
		}
	    return nRow;
	}
function rowCallBack2(nRow, aData, iDisplayIndex) {
		if(aData.confirmDate != null && aData.confirmDate != ''){
			$('td:eq(0)', nRow).html(dateFormatRefactoring(aData.confirmDate));
		}
		/*if(aData.confirmWay == 1){
			$('td:eq(1)', nRow).html("一次性确认");
		}else if(aData.confirmWay == 2){
			$('td:eq(1)', nRow).html("分摊");
		}*/
		if(aData.confirmAmount != null){
			$('td:eq(1)', nRow).html(initInputMask(aData.confirmAmount));
		}else{
			$('td:eq(1)', nRow).html("");
		}
		if(aData.resultsContribution != null){
			$('td:eq(2)', nRow).html(initInputMask(aData.resultsContribution));
		}else{
			$('td:eq(2)', nRow).html("");
		}
		/*if(aData.isBeenConfirmed == '1'){
			$('td:eq(4)', nRow).html('已确定');
		}else if(aData.isBeenConfirmed == '0'){
			$('td:eq(4)', nRow).html('未确定');
		}else if((aData.isBeenConfirmed == null || aData.isBeenConfirmed == '')&&aData.cumulative != '累计'){
			$('td:eq(4)', nRow).html('');
		}
		$('td:eq(5)', nRow).html(aData.confirmPeople);*/
		if(aData.cumulative == '累计'){
			$('td:eq(0)', nRow).html(aData.cumulative);
			nRow.bgColor = "#EDEDED";
		}else{
			// 操作
			var htmlText = buildOperate(nRow,aData,2);
			$('td:eq(9)', nRow).html(htmlText);
		}
		
	    return nRow;
	}
/**
 * 构造操作详情HTML 
 * 
 **/
function buildOperate(nRow,aData,type) {
	var html = [];
	//新项目管理模块--如果是新项目管理模块新增的，则跳转至新增页面
	var barginManageId=$("#id").val();
	if(type == 0){
		//发票详情跳转
		if(aData.status !=null && aData.status !=''){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",1)");
		}else{
			$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/sale/finInvoiced/toAddOrEdit?id="+aData.id+"&barginManageId="+barginManageId+"'");
		}
	}else if(type == 1){
		//收款跳转
		if(aData.status !=null && aData.status !=''){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",2)");
		}else{
			$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/collection/toAddNew?id="+aData.id+"&barginManageId="+barginManageId+"'");
		}
	}else if(type == 2){
		//收入确认跳转
	}
	//$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
	$(nRow).css("cursor", "pointer");
	return html.join("");
}
//添加发票跳转
function initiateInvoice(){
	var barginManageId=$("#id").val();
	window.location.href = web_ctx + "/manage/sale/finInvoiced/toAddOrEdit?barginManageId="+barginManageId;
}
//添加收款跳转
function initiatePayment(){
	var barginManageId=$("#id").val();
	window.location.href = web_ctx + "/manage/finance/collection/toAddNew?barginManageId="+barginManageId;
}
/******************************
 * 		全局变量			  	  *
 ******************************/
var fileData = null;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交": save,
	"同意": agree,
	"确认": agree,
	"不同意": disagree,
	"重新申请": reApply,
	"取消申请": cancelApply,
};


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意  10:会计不同意 12：财务总监审批 13：财务总监不同意 14：项目负责人审批 15：项目负责人不同意
 * */
//同意后的下一状态
var approvedStatus = {
	"0": "14",
	"1": "2",
	"2": "12",
	"3": "4",
	"4": "5",
	"12": "3",
	"14": "1"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0": "6",
	"1": "7",
	"2": "8",
	"3": "9",
	"4": "10",
	"12": "13",
	"14":"15"
};
// 环节与状态的映射
var nodeOnStatus = {
	"0": "提交申请",
	"1": "部门经理",
	"2": "财务",
	"3": "总经理",
	"4": "出纳",
	"5": "已归档",
	"6": "取消申请",
	"7": "提交申请",
	"8": "提交申请",
	"9": "提交申请",
	"10": "提交申请",
	"12": "财务总监",
	"13": "提交申请",
	"14":"项目负责人",
	"15":"提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "通过",
	"确认": "确认",
	"不同意": "不通过",
	"取消申请": "取消申请",
};

$(function() {
	inittextarea();
	initTaskComment();
	initFileUpload();
	initFileUpload2();
	initInputMask();
	initInputMask2();
	initDatetimepicker();

//	if($("#currStatus").val() != null && $("#currStatus").val() != ""  && $("#currStatus").val() == "5"){
//		findPayInfo();
//        findCollectionInfo();
//	}
	
	/*if($("#currStatus").val()!=5){
		
	}*/
	

});

var barginManageId = $("#id").val();
function findPayInfo(){
	var status = "5";
	$.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/finance/pay/findPayInfo",//查找与合同关联的已审批完的付款信息
        "dataType": "json",
        "data": {
        	"barginManageId": barginManageId,
			"status": status},
        "success": function(data) {
        	if(data.code == 1) {
				if(data.result != null && data.result != "" && data.result.length >0 ){
					var html = [];

					//插入表头
					html.push('<table id="table3" style="width:90%;text-align: center;>');
					html.push('<thead>');
					html.push('<tr style="text-align: center;font-weight: bold;"><th colspan="20" >付  款  详  情</th></tr>');
					html.push('<tr style="text-align: center;font-weight: bold;" >');
					html.push('<td class="td_weight" style="width:15%;" id="pay">付款类型</td>');
					html.push('<td class="td_weight" style="width:20%">收款单位</td>');
					html.push('<td class="td_weight" style="width:10%">发票金额</td>');
					html.push('<td class="td_weight" style="width:10%">实际付款金额</td>');
					html.push('</tr>');


					//计算已收发票金额
					var actualPayTotalMoney = 0;
					for (var i in data.result) {
						var payType = '';
						if(data.result[i].payType == '1'){
							 payType = '货款';
						}else if(data.result[i].payType == '0'){
							payType = '预付款';
						}
						
						if(data.result[i].payAttachList != null){
							var actualPayMoney = data.result[i].payAttachList[i].payBill.toFixed(2);
						}else{
							var actualPayMoney = data.result[i].actualPayMoney.toFixed(2);
						}
						var invoiceMoney = data.result[i].invoiceMoney.toFixed(2);
						
						actualPayTotalMoney = digitTool.add(actualPayTotalMoney,actualPayMoney).toFixed(2);
						html.push('<tr><td>'+payType+'</td><td style="text-align: center;">'+ data.result[i].collectCompany +'</td><td>'+invoiceMoney +'</td><td style="text-align: right;">'+ actualPayMoney +'</td></tr>');
					}
					html.push('</thead>');
					html.push('<tbody></tbody>');
					html.push('</table>');
					html.push('<br><br>');

					$("#pay").append(html.join(""));

					var trAttr = $("tbody").find("#totalMoney").parent().attr("colspan","2");
					var tr = $("tbody").find("#totalMoney").parent();
					$(tr).after('<td  class="td_weight"><span>已付金额</span></td><td colspan="2"><input type="text"  readonly name="payMoney" style="text-align: right;"  id ="payMoney" value="'+actualPayTotalMoney +'"></td>');
			}
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );

}

/**
 * 把毫秒级时间转换成字符串
 * 格式：yyyy年MM月dd日
 * @param date
 * @returns {string}
 */
function dateFormat(date) {
    var dateStr = new Date(date);
    // 重写toString方法
    Date.prototype.toLocaleString = function() {
        return this.getFullYear() + "年" + (this.getMonth() + 1) + "月" + this.getDate() + "日";
    };
    return dateStr.toLocaleString();
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

/**
 * 查询合同相关的收款详情
 * @type {*}
 */
var barginId = $("#id").val();
function findCollectionInfo() {
	var status = "5";
	$.ajax({
		"type":"Post",
		"url":web_ctx+"/manage/finance/collection/findCollectionInfo",
		"dataType":"JSON",
		"data":{
			"barginId":barginId,
			"status":status
		},
		success:function (data) {
			if(data.code == 1){
				if(data.result !=null && data.result!="" && data.result.length>0){
                    var html = [];
                    var id = [];
                    //插入表头
                    html.push('<table id="table4" style="width:90%;text-align: center;>');
                    html.push('<thead>');
                    html.push('<tr style="text-align: center;font-weight: bold;"><th colspan="20" >收  款  详  情</th></tr>');
                    html.push('<tr style="text-align: center;font-weight: bold;">');
                    html.push('<td class="td_weight" style="width:15%;" id="collection">开票日期</td>');
                    html.push('<td class="td_weight" style="width:20%">付款单位</td>');
                    html.push('<td class="td_weight" style="width:10%">开票金额</td>');
                    html.push('<td class="td_weight" style="width:10%">申请比例</td>');
                    html.push('<td class="td_two" style="width:5%">操  作</td>');

                    html.push('</tr>');


                    $.each(data.result,function (n,v) {
                    	id = data.result[n].processInstanceId;
                        html.push('<tr><td>'+dateFormat(data.result[n].billDate)+'</td><td>'+data.result[n].payCompany+'</td><td style="text-align: center";>'
							+data.result[n].bill +'</td><td>'+data.result[n].applyProportion
							+'</td><td><input type="button"  name="detail" class="btn btn-primary" style="text-align: center"  value="查看收款明细" onclick="getCollection('+id+')" ></td></tr>');
                    })
                    html.push('</thead>');
                    html.push('<tbody></tbody>');
                    html.push('</table>');
                    html.push('<br><br>');
                    $("#collection").append(html.join(""));
				}
			}
        },
		error:function (data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	});
}

//点击收款详情弹出模态框
function getCollection(processInstanceId) {
	var param = {
		"processInstanceId":processInstanceId,
		"page":"manage/finance/collection/process"
	}
	var url = web_ctx + "/activiti/process?" + urlEncode(param);
	$("#collectionFrame").attr("src",url);
	$("#collectionModal").modal("show");
}

function approve(status) {
	$("#operStatus").val(status);
	oper2Method[status].call();
}

function agree() {
	var currUserId =$("#currUserId").val();
	var userId =$("#userId").val();
	if(currUserId == userId){
		save();
	}else{
		var formData = $("#form1").serializeJson();
		var issubmit = $("#issubmit").val("0");//区分保存和提交

		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		submitForm(formData);
	}
}

function disagree() {
	/*submitProcess();*/
	var formData = $("#form1").serializeJson();
	var issubmit = $("#issubmit").val("0");//区分保存和提交

	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	submitForm(formData);
}

function reApply() {
	save();
}

function cancelApply() {
	cancelProcess();
}

function demo(){
	var result = setStatus2('11') //作废合同
	if(result.code == 1) {
		backPageAndRefresh();
	}
}

function noDemo(){
    var result = setStatus2('5') //取消作废
    if(result.code == 1) {
        backPageAndRefresh();
    }
}

//获取项目名称
var projectObj = "";
function openProject(obj) {
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}


function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$("#projectManageId").val(data.id);
		$(projectObj).val(data.name);
	}
}

/******************************
 * 		表单处理相关函数		  	  *
 ******************************/
function save() {
    var barginRemark = $("#barginRemark").val();
    if(!isNull(barginRemark)) {
        $("#barginRemark").val("");
    }
	var formData = $("#form1").serializeJson();
	formData["channelExpense"]=commafyback($("#channelExpense").val());
	var issubmit = $("#issubmit").val("0");//区分保存和提交

	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}

	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/findByBarginName",//合同名称不能重复
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data:  JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#barginName").val("");
				bootstrapAlert("提示", data.result, 400, null);
			}else{
				openBootstrapShade(true);
				if(fileData != null) {
					fileData.submit();
				}if(fileData2 != null) {
                    fileData2.submit();
                } else {
					submitForm(formData);
				}
				openBootstrapShade(false);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});

}

function saveChannelExpense(){
	var formData = $("#form1").serializeJson();
	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/saveInfo",
		type: "post",
		data: JSON.stringify(formData),
		dataType: "json",
		contentType: "application/json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function(data) {
			openBootstrapShade(false);
		}
	});
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/saveInfo",
		type: "post",
		data: JSON.stringify(formData),
		dataType: "json",
		contentType: "application/json",
		success: function(data) {
			if(data.code == 1) {
				var currUserId =$("#currUserId").val();
				var userId =$("#userId").val();
				var oper = $("#operStatus").val();
				if(oper == "重新申请" ||  oper == '同意' ||  oper == '不同意' ) {
					submitProcess();
				} else {
						backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function(data) {
			openBootstrapShade(false);
		}
	});
}

function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  barginName = $.trim($("#barginName").val());
	var barginType = $("#barginType").val();
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();


	if(isNull(barginName)) {
		text.push("请填写合同名称！");

	}else if(isNull(barginType)){

		text.push("请填写合同类型！");
	}

	if(!isNull(startTime) && !isNull(endTime) && startTime >= endTime) {
		text.push("合同期限开始时间不能大于或等于结束时间！<br/>");
	}

	return text;
}

function submitProcess() {
	var variables = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variables);

	if(compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		$("#currStatus").val(status);
		if(statusResult.code == 1) {
			var text = "操作成功！";
    		if($("#operStatus").val() == "提交") {
    			text = "提交成功 ！";
    		} else if($("#operStatus").val() == "重新申请") {
    			text = "重新申请成功 ！";
    		} else if($("#operStatus").val() == "取消申请") {
    			text = "取消申请成功 ！";
    		}

    		if($("#operStatus").val()=="不同意"){
                sendMail();
			}
    		window.parent.initTodo();
    		backPageAndRefresh();

    	} else {
    		bootstrapAlert("提示", statusResult.result, 400, null);
    	}
	} else if(compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
	validate();
	openBootstrapShade(false);
}

//取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if(result != null) {
			if(result.code == 1) {
				var statusResult = setStatus("6");
				var delResult=del();
				if(statusResult.code == 1 && delResult.code==1) {
						window.parent.initTodo();
						backPageAndRefresh();
				/*	});*/
				} else {
					bootstrapAlert("提示", statusResult.result, 400, null);
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}


//取消流程的同时，删除该合同数据
function del() {
	var formData = getFormData();
	var result = {};
		$.ajax( {
	        "type": "POST",
	        "url": web_ctx + "/manage/sale/barginManage/delete",
	        "dataType": "json",
	        "async": false,
	        "contentType": "application/json;charset=UTF-8",
	        "data": JSON.stringify(formData),
	        "success": function(data) {
	        	result = data;
	        },
	        "error": function(data) {
	        	result.code = -1;
	        	result.result = "网络错误，请稍后重试！";
	        }
	    });
		return result;
}

/**
 * 当流程处理人打回申请时，给申请人发送邮件
 */
function sendMail() {
    var result = {};
	$.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/sale/barginManage/sendMail",
        "dataType": "json",
        "data": {
            id:$("#id").val(),
            comment:$("#comment").val(),
        },
		"success":function (data) {
            result.result = "发送成功！";
        },
		"error":function (data) {
            result.code = -1;
            result.result = "网络错误，请稍后重试！";
        }
	});
	return result;
}

/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意  10：出纳不同意
 * */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	var barginType = $("#barginType").val();
	if($("#operStatus").val() == "同意") {
		if(currStatus == "1") {
			if(!isNull(barginType) && ( barginType == "B"||  barginType == "S")) {
				status = approvedStatus[currStatus];
			} else {
				status = "3";
			}
		} else {
			status = approvedStatus[currStatus];
		}
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	}else {
		status = "14";
	}

	return status;
}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/sale/barginManage/setStatus",
        "dataType": "json",
        "async": false,
        "data": {"id": id, "status": status},
        "success": function(data) {
        	result = data;
        },
        "error": function(data) {
        	result.code = -1;
        	result.result = "网络错误，请稍后重试！";
        }
	} );

	return result;
}

function setStatus2(status) {
	var id = $("#id").val();
	if(status == "11") {
        var remark = $("#barginRemark").val();
    }else {
        var remark = null;
    }
	var result = {};
	$.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/sale/barginManage/setStatus2",
        "dataType": "json",
        "async": false,
        "data": {"id": id, "status": status, "remark": remark},
        "success": function(data) {
        	result = data;
        },
        "error": function(data) {
        	result.code = -1;
        	result.result = "网络错误，请稍后重试！";
        }
	} );

	return result;
}


function getVariables() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

	var operStatus = $("#operStatus").val();
	var form = {
			"node": getNodeInfo(),
			"approver": $("#approver").val(),
			"comment": operStatus != "提交" ? $("#comment").val() : "",
			"approveResult": "",
			"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
	};

	if($("#isHandler").val() && $("#taskName").val() == '出纳' && operStatus == "同意" ){
		form["approveResult"] = "确认";
	}else if($("#isHandler").val() && $("#taskName").val() == '出纳' && operStatus == "不同意" ){
		form["approveResult"] = "退回";
	}else{
		form["approveResult"] = nodeOnOper[operStatus];
	}

	commentList.push(form);

	variables["commentList"] = commentList; // 批注列表
	variables["approved"] =
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" || operStatus == "结束流程" ? true : false;

	var barginType = $("#barginType").val();
	if(!isNull(barginType) && (barginType == 'L' || barginType == 'C' || barginType == 'M')){
		variables["toCeo"] = true;
	} else {
		variables["toCeo"] = false;
	}

	return variables;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
	var currStatus = $("#currStatus").val();
	if(isNull(currStatus) || $("#operStatus").val() == "重新申请" || $("#operStatus").val() == "取消申请") {
		currStatus = "0";
	}

	return nodeOnStatus[currStatus];
}


//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "bargin/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
        	maxFileSize: '附件大小最大为50M！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#showName").val(data.files[0].name);
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
        		// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
    			$("#file").fileupload("option", "formData", urlParam);
        		$("#showName").val(result.originName);
        		$("#attachments").val(result.path);
        		$("#attachName").val(result.originName);

        		var formData = getFormData();
        		submitForm(formData);

        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}


//文件上传2
var fileData2 = null;
var urlParam2 = "";
function initFileUpload2() {
	var date = new Date();
	var params2 = {
		"path": "bargin/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments2").val()
	};

	urlParam2 = urlEncode(params2);
	$('#file2').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam2,
		dataType: 'json',
		formData: params2,
		maxFileSize: 50 * 1024 * 1024, // 50 MB
		messages: {
			maxFileSize: '附件大小最大为50M！'
		},
		add: function (e, data) {
			var $this = $(this);
			data.process(function() {
				return $this.fileupload('process', data);
			}).done(function(){
				fileData2 = data;
				$("#showName2").val(data.files[0].name);
			}).fail(function() {
				var errorMsg = [];
				$(data.files).each(function(index, file) {
					errorMsg.push(file.error);
				});
				bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
			});
		},
		done: function (e, data) {
			var result = data.result;
			if(result.execResult.code != 0) {
				// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
				params2["deleteFile"] = result.path;
				urlParam2 = urlEncode(params2);
				$("#file2").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam2));
				$("#file2").fileupload("option", "formData", urlParam2);
				$("#showName2").val(result.originName);
				$("#attachments2").val(result.path);
				$("#attachName2").val(result.originName);

				var formData = getFormData();
				submitForm(formData);

			} else {
				openBootstrapShade(false);
				bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
			}
		}
	});
}

//删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/sale/barginManage/deleteAttach",
				data: {"path":$("#attachments").val(), "id":$("#id").val()},
				type: "post",
				dataType: "json",
				success: function(data) {
					if(data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
	        			});
					}
					else{
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
			    error: function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			       }

			});
		}, null);
	}
	else{
		bootstrapAlert("提示", "附件未保存，提交保存后方可删除附件！", 400, null);
	}
}

//删除附件
function deleteAttach2(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/sale/barginManage/deleteAttach2",
				data: {"path":$("#attachments2").val(), "id":$("#id").val()},
				type: "post",
				dataType: "json",
				success: function(data) {
					if(data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
						});
					}
					else{
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
				error: function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}

			});
		}, null);
	}
	else{
		bootstrapAlert("提示", "附件未保存，提交保存后方可删除附件！", 400, null);
	}
}

//确认合同
function confirm() {
	var result = confirmY() ;
	if(result.code == 1) {
		backPageAndRefresh();
	}
}

//取消确认合同
function unConfirm() {
    var result = confirmN() ;
    if(result.code == 1) {
        backPageAndRefresh();
    }
}

function confirmY() {
	if(fileData2 != null) {
		fileData2.submit();
	}
	var id = $("#id").val();
	var result = {};
	$.ajax( {
		"type": "POST",
		"url": web_ctx + "/manage/sale/barginManage/updateConfirm",
		"dataType": "json",
		"async": false,
		"data": {"id": id,"barginConfirm":"1"},
		"success": function(data) {
			result = data;
		},
		"error": function(data) {
			result.code = -1;
			result.result = "网络错误，请稍后重试！";
		}
	} );

	return result;
}

function confirmN() {
    var id = $("#id").val();
    var result = {};
    $.ajax( {
        "type": "POST",
        "url": web_ctx + "/manage/sale/barginManage/updateConfirm",
        "dataType": "json",
        "async": false,
        "data": {"id": id,"barginConfirm":"0"},
        "success": function(data) {
            result = data;
        },
        "error": function(data) {
            result.code = -1;
            result.result = "网络错误，请稍后重试！";
        }
    } );

    return result;
}

/*
 * 初始化相关操作
 */
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

	for (var i = commentList.length -1; i >= 0; i--) {
		if(commentList.length>=2){
			if(commentList[0].approver == commentList[1].approver && commentList[i].node =='项目负责人'){
				continue;
			}
		}
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		html.push(commentList[i].node);
		html.push("</td>");
		html.push("<td>");
		if(commentList[i].approver == "徐卓"){
			if(i == 1){
                html.push("陈琦");
			}
			else{
                html.push("徐卓");
			}
		}
		else{
            html.push(commentList[i].approver);
		}
		html.push("</td>");
		html.push("<td>");
		var approveDate = commentList[i].approveDate + "";
		if( !dateRep.test(approveDate) ) {
			html.push(new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
		}
		html.push("</td>");
		html.push("<td>");
		html.push(commentList[i].approveResult);
		html.push("</td>");
		html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(commentList[i].comment) ? "" : commentList[i].comment);
		html.push("</td>");

		$("#table2").find("tbody").append(html.join(""));
	}
}

function initDatetimepicker() {

	$("input[name='startTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });

	$("input[name='endTime']").datetimepicker({
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
function initInputMask2() {
		$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#receivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#unreceivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	    $("#channelExpense").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
}
//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

//流程 跳转
function toProcess(processInstanceId,barginType) {
    	var page="";
		if(barginType == 1){
			//发票流程跳转
			page="manage/finance/collection/processInvoice";
		}else if(barginType == 2){
			//收款流程跳转
			page="manage/finance/collection/processNew";
		}
        var param = {
            "processInstanceId": processInstanceId,
            "page": page
        }
    window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

/*
 * 初始化相关操作
 *初始化金额，两位数
 */
function initInputMask(val){
	if (val == null || val == "null" || val == "")
		return "0.00";
	if (/[^0-9\.]/.test(val))
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

/*
 * 去除千分位
 */
function commafyback(num) {
	if (num == null || num == "null" || num == "")
		return "0.00";
	num=num+"";
	if(num.indexOf(",") == -1){
		return num;
	}
	var x = num.split(','); 
	return parseFloat(x.join("")); 
} 