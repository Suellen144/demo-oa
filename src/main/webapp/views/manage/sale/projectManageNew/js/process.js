/*******************************************************************************
 * 全局变量 *
 ******************************************************************************/
var fileData = null;
var index=0;
var boot = false;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交" : save,
	"同意" : agree,
	"不同意" : disagree,
	"重新申请" : reApply,
	"取消申请" : cancelApply,
};

/*
 * 审批状态 0： 重新申请 1：项目负责人审批 2：部门主管审批 3：财务审批 4：总经理审批 5：已归档  6：取消申请 7：项目负责人不同意 8：部门主管不同意
 * 9：财务不同意 10：总经理不同意 
 */
// 同意后的下一状态
var approvedStatus = {
	"0" : "1",
	"1" : "2",
	"2" : "3",
	"3" : "4",
	"4" : "5"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0" : "6",
	"1" : "7",
	"2" : "8",
	"3" : "9",
	"4" : "10",
};
// 环节与状态的映射
var nodeOnStatus = {
	"0" : "提交申请",
	"1" : "项目负责人",
	"2" : "部门经理",
	"3" : "财务",
	"4" : "总经理",
	"5" : "已归档",
	"6" : "取消申请",
	"7" : "提交申请",
	"8" : "提交申请",
	"9" : "提交申请",
	"10" : "提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
	"提交" : "提交成功",
	"重新申请" : "申请成功",
	"同意" : "通过",
	"不同意" : "不通过",
	"取消申请" : "取消申请",
};
$(function() {
	inittextarea();
	initTaskComment();
	initFileUpload();
	initInputMask();
	initMoneyFormat();
	initDatetimepicker();
	initMenu();
	
	if ($("#currStatus").val() == "4") {
		initDatetimepicker();
	}
	$("#userByDeptDialog").initUserDialog({
		 "callBack" : getData
	 });
	
	$("#userDialog").initUserByDeptDialog({
		 "callBack" : getData2
	 });
	 //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/sale/projectManage/getList",
		type: "post",
		data: {projectId:$("#id").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tbodyInfoTr").append("<tr name='node1' class='node1'><td style='width:33%'><input type='text' id='uName' name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  " +
							"name='uId' value='"+data[i].principal.id+"' data-sorting='"+index+"'><input type='hidden'  " +
							"name='businessId' value='"+data[i].id+"'></td>" +
											" <td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()'" +
											"   style='text-align:center' onblur='onchanges(this)'/></td></tr>");
				}else{
					$("#tbodyInfoTr").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog2(this)'><input type='text'  name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  name='uId' value='"+data[i].principal.id+"' " +
									" data-sorting='"+index+"' style='text-align:center'><input type='hidden'  " +
							"name='businessId' value='"+data[i].id+"'></td>" +
													"<td style='width:33%'><input type='text'  name='commissionProportion' " +
											"value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()'  style='text-align:center' onblur='onchanges(this)'/></td></tr>");
				}
				index++;
				if(i==0){
					$("#tbodyInfoTr1").append("<tr name='node1' class='node1'><td style='width:33%'>" +
						"<input type='text' name='uName' value='"+data[i].principal.name+"' style='text-align:center'  readonly>" +
						"<input type='hidden' name='uId' value='"+data[i].principal.id+"'></td>" +
						"<td style='width:33%'><input type='text' id='commissionProportion' name='commissionProportion' " +
						"value='"+data[i].commissionProportion+"%'  style='text-align:center' readonly/></td></tr>");
				}else {
					$("#tbodyInfoTr1").append("<tr name='node' class='node'><td style='width:33%' onclick='openDialog2(this)'>" +
						"<input type='text' name='uName' value='"+data[i].principal.name+"' style='text-align:center'  readonly>" +
						"<input type='hidden' name='uId' value='"+data[i].principal.id+"'></td>" +
						"<td style='width:33%'><input type='text' id='commissionProportion' name='commissionProportion' " +
						"value='"+data[i].commissionProportion+"%'  style='text-align:center' readonly/></td></tr>");
				}
			}
			cumulative();
			initTypeByPosition();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
    //合同数据渲染
     $("#table4").datatable({
		"id": "table4",
		"url": web_ctx + "/manage/sale/projectManage/getBarginManageList",
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
	//项目开支数据渲染
	 $("#table5").datatable({
		"id": "table5",
		"url": web_ctx + "/manage/sale/projectManage/getSpendingList",
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
	 statisticalCalculate();
	 $("#size").val(initInputMask(Number($("#size").val())));

	$.ajax({
		url: web_ctx + "/manage/sale/projectManage/getParentDeptName",
		type: "post",
		data: {principalDeptId:$("#userDeptId").val()},
		dataType: "json",
		async:false,
		success: function(data) {
			if(data != null) {
				$("#dutyDept").val(data.name);
				$("#dutyDept").show();
			}else{
				$("#deptName")[0].style.width='100%';
			}
		}
	})
});
var T1=0;var T2=0;var T3=0;var T4=0;var T5=0;
function statisticalCalculate(){
	var projectId=$("#id").val();
	 //合同金额计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getContractAmount",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#barginMoney").val(initInputMask(data.totalMoney));
					$("#channelExpense").val(initInputMask(data.channelExpense)); ////渠道费用额度 计算统计  销售类合同 录入的 渠道费用额度 
					notPay(data.channelExpense,$("#channelHave").val());
				}else{
					$("#barginMoney").val(initInputMask(0.0));
					$("#channelExpense").val(initInputMask(0.0));
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T1=1;
				error_T5();
				$("#barginMoney").val(initInputMask(0.0));
				$("#channelExpense").val(initInputMask(0.0));
			}
		});
	 //收入计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getIncome",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#income").val(initInputMask(data.confirmAmount));
					$("#results").val(initInputMask(data.resultsAmount));//业绩贡献 计算统计
				}else{
					$("#income").val(initInputMask(0.0));
					$("#results").val(initInputMask(0.0));
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T2=1;
				error_T5();
				$("#income").val(initInputMask(0.0));
				$("#results").val(initInputMask(0.0));
			}
		});
	 //支出计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getExpenditure",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#pay").val(initInputMask(data.actReimburse));
				}else{
					$("#pay").val(initInputMask(0.0));
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T3=1;
				error_T5();
				$("#pay").val(initInputMask(0.0));
			}
		});
	//攻关费用(已用)计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getClearanceBeen",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				var momeyNum=$("#momeyNum").val();
				if(data !=null){
					var sum=0;
					$("input[name='ggMoney']").val(initInputMask(data.actReimburse));
					$("#spending").text(initInputMask(data.actReimburse));
					if(momeyNum!=null && momeyNum !=''){
						sum=momeyNum*1-data.actReimburse;
						$("#balance").text(sum);
						if(sum<0){
							$("#balance")[0].style.color="red";
						}
					}
				}else{
					$("input[name='ggMoney']").val(initInputMask(0.0));
					$("#spending").text(initInputMask(0.0));
					$("#balance").text(momeyNum-0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T4=1;
				error_T5();
				$("input[name='ggMoney']").val(initInputMask(0.0));
				$("#spending").text(initInputMask(0.0));
				$("#balance").text(momeyNum-0);
			}
		});
	//渠道费用（已支付）计算统计 销售类合同每笔收款时确认的渠道费用
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getChannelHave",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#channelHave").val(initInputMask(data.channelCost));
					$("#commission").val(initInputMask(data.allocations));//提成额度 计算统计
					notPay($("#channelExpense").val(),data.channelCost);
				}else{
					$("#channelHave").val(initInputMask(0.0));
					$("#commission").val(initInputMask(0.0));
					$("#channelNot").val(initInputMask(0.0));
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T5=1;
				error_T5();
				$("#channelHave").val(initInputMask(0.0));
				$("#commission").val(initInputMask(0.0));
			}
		});
}
function notPay(channelExpense,channelHave){
	//渠道费用（未支付）计算统计
	if(channelExpense ==null || channelExpense =='' || channelHave ==null || channelHave ==''){
		return;
	}
	channelExpense=commafyback(channelExpense)*1;
	channelHave=commafyback(channelHave)*1;
	 if(channelExpense >= channelHave){
		 $("#channelNot").val(initInputMask(channelExpense-channelHave));
	 }else{
		 $("#channelNot").val(initInputMask(0.0));
	 }
}
function error_T5(){
	if(T1==1 || T2==1 || T3==1 || T4==1 || T5==1){
		bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	}
}
function initInputBlur(){
	$("#momeyNum").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("#size").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='resultsProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='commissionProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
}

function show(){
	var id = $("#id").val();
	$.ajax({
		url: web_ctx + "/manage/sale/projectManage/findCostById",
		type: "post",
		data: {"id" : id},
		dataType: "json",
		success: function(data) {
			var html = '';
			$("#ggtable .tlist").empty();
			$.each(data,function(i,j){
				html += ('<tr name="node" style="border-top: 1px solid #ccc;">'
				+ '<td colspan="4">'+ new Date(j.mtime).pattern("yyyy-MM-dd hh:mm:ss") +'</td>'
	    		+ '<td colspan="4" style="border-left:1px solid #ccc;border-right:1px solid #ccc">'+ j.cost +'</td>'
	    		+ '<td colspan="4">'+ j.sysUser.name +'</td>'
			    + '</tr>');
			})
			$("#ggtable .tlist").append(html);
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	$("#tacklingModal").modal("show");
}
function change(){
	var id = $("#id").val();
	var money = $("#momeyNum").val();
	var momeyNum=$("#momeyNum").val();
	var spending=$("#spending").text();
	if(spending !=null && spending!=''){
		spending=commafyback(spending);
	}
	if(money !=null && money!=''){
		money=Number(money);
	}
	if(momeyNum !=null && momeyNum!=''){
		momeyNum=Number(momeyNum);
	}
	if(spending>momeyNum){
		bootstrapAlert("提示", "额度低于支出", 400, null);
		return;
	}
	$.ajax({
		url: web_ctx + "/manage/sale/projectManage/change",
		type: "post",
		data: {
			"id" : id,
			"money" : money
		},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				//backPageAndRefresh();
				if(momeyNum!=null && momeyNum !=''){
					var sum=momeyNum-spending;
					if(!isNaN(sum) && sum !=''){
						$("#balance").text(initInputMask(sum));
					}
				}
				$.ajax({
					url: web_ctx + "/manage/sale/projectManage/findCostById",
					type: "post",
					data: {"id" : id},
					dataType: "json",
					success: function(data) {
						var html = '';
						$("#ggtable .tlist").empty();
						$.each(data,function(i,j){
							html += ('<tr name="node" style="border-top: 1px solid #ccc;">'
							+ '<td colspan="4">'+ new Date(j.mtime).pattern("yyyy-MM-dd hh:mm:ss") +'</td>'
				    		+ '<td colspan="4" style="border-left:1px solid #ccc;border-right:1px solid #ccc">'+ j.cost +'</td>'
				    		+ '<td colspan="4">'+ j.sysUser.name +'</td>'
						    + '</tr>');
						})
						$("#ggtable .tlist").append(html);
					},
					error: function(data) {
						bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
					}
				});
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}
function getSearchData() {
	var params = {};
	params.projectManageId = $.trim($("#id").val());
	return params;
}
function getSearchData1() {
	var params = {};
	params.projectManageId = $.trim($("#id").val());
	return params;
}

function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'barginName'},
	    {"mData": 'totalMoney'}, 
        {"mData": 'company'},
		{"mData": 'barginType'},
		{"mData": 'startTime'},
		{"mData": 'status'}
    ]
	return columns;
}
function initColumn1() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'kind'},
        {"mData": 'name'},
	    {"mData": 'applyTime'}, 
        {"mData": 'orderNo'},
		{"mData": 'actReimburse'},
		{"mData": 'status'}
    ]
	return columns;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(aData.barginName != null){
		$('td:eq(0)', nRow).html("<div title='"+aData.barginName+"' style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:260px;'>"+aData.barginName+"<div>");
	}
	if(aData.totalMoney != null){
		$('td:eq(1)', nRow).html(initInputMask(aData.totalMoney));
	}else{
		$('td:eq(1)', nRow).html("");
	}
	$('td:eq(2)', nRow).html("<div title='"+aData.company+"' style='height:20px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:260px;'>"+aData.company+"<div>");
	if(aData.barginType != null){
		if(aData.barginType == "B") {
			$('td:eq(3)', nRow).html('采购合同');
		} else if(aData.barginType == "S") {
			$('td:eq(3)', nRow).html('销售合同');
		} else if(aData.barginType == "C") {
			$('td:eq(3)', nRow).html('合作协议');
		} else if(aData.barginType == "L") {
			$('td:eq(3)', nRow).html('劳动合同');
		} else if(aData.barginType == "M") {
			$('td:eq(3)', nRow).html('备忘录');
		} else if(aData.barginType == "E") {
			$('td:eq(3)', nRow).html('融投资协议');
		}
	}else{
		$('td:eq(3)', nRow).html("");
	}
	if(aData.startTime !=null && aData.endTime !=null){
		$('td:eq(4)', nRow).html(dateFormatRefactoring(aData.startTime) +" 至  "+dateFormatRefactoring(aData.endTime));
	}else{
		$('td:eq(4)', nRow).html("");
	}
	if(aData.status == "14") {
		$('td:eq(5)', nRow).html('项目负责人审批');
	}else if(aData.status == "1") {
		$('td:eq(5)', nRow).html('部门经理审批');
	} else if(aData.status == "2") {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == "12") {
		$('td:eq(5)', nRow).html('财务总监审批');
	} else if(aData.status == "3") {
		$('td:eq(5)', nRow).html('总经理审批');
	} else if(aData.status == "4") {
		$('td:eq(5)', nRow).html('出纳确认');
	}else if(aData.status == "5") {
		$('td:eq(5)', nRow).html('已归档');
	} else if(aData.status == "6") {
		$('td:eq(5)', nRow).html('取消申请');
	} else if(aData.status == "7" || aData.status == "8" || aData.status == "9" || aData.status == "10" || aData.status == "13"  || aData.status == "15") {
		$('td:eq(5)', nRow).html('提交申请');
	} else if(aData.status == null || aData.status== "") {
		$('td:eq(5)', nRow).html('未提交');
	} else if(aData.status == "11") {
		$('td:eq(5)', nRow).html('已作废');
	} 
	// 操作
	var htmlText = buildOperate(nRow,aData,0);
	$('td:eq(9)', nRow).html(htmlText);
    return nRow;
}
function rowCallBack1(nRow, aData, iDisplayIndex) {
		if(aData.kind != null ){
			if(aData.kind == 1){
				$('td:eq(0)', nRow).html("差旅报销");
				//审批状态 0：申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：驳回 7：审批通过 8：审批不通过 9：取消申请
				if(aData.status == 0) {
					$('td:eq(5)', nRow).html('提交申请');
				} else if(aData.status == 1) {
					$('td:eq(5)', nRow).html('部门经理审批');
				} else if(aData.status == 2) {
					$('td:eq(5)', nRow).html('经办审批');
				} else if(aData.status == 3 || aData.status == 11) {
					$('td:eq(5)', nRow).html('复核审批');
				} else if(aData.status == 4) {
					$('td:eq(5)', nRow).html('总经理审批');
				} else if(aData.status == 5) {
					$('td:eq(5)', nRow).html('出纳审批');
				} else if(aData.status == 6) {
					$('td:eq(5)', nRow).html('审批完结');
				} else if(aData.status == 7) {
					$('td:eq(5)', nRow).html('取消申请');
				} else if(aData.status == 8 || aData.status == 9
						|| aData.status == 10 || aData.status == 12) {
					$('td:eq(5)', nRow).html('提交申请');
				}
				else{
					$('td:eq(5)', nRow).html('申请待提交');
				}
			}else if(aData.kind == 2){
				$('td:eq(0)', nRow).html("通用报销");
				//审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理驳回 9：经办驳回 10：复核驳回 11：总经理驳回 12：出纳驳回
				if(aData.status == 0) {
					$('td:eq(5)', nRow).html('提交申请');
				} else if(aData.status == 1) {
					$('td:eq(5)', nRow).html('部门经理审批');
				} else if(aData.status == 2) {
					$('td:eq(5)', nRow).html('经办审批');
				} else if(aData.status == 3 || aData.status == 11) {
					$('td:eq(5)', nRow).html('复核审批');
				} else if(aData.status == 4) {
					$('td:eq(5)', nRow).html('总经理审批');
				} else if(aData.status == 5) {
					$('td:eq(5)', nRow).html('出纳审批');
				} else if(aData.status == 6) {
					$('td:eq(5)', nRow).html('审批完结');
				} else if(aData.status == 7) {
					$('td:eq(5)', nRow).html('取消申请');
				} else if(aData.status == 8 || aData.status == 9
						|| aData.status == 10 || aData.status == 12) {
					$('td:eq(5)', nRow).html('提交申请');
				}
				else{
					$('td:eq(5)', nRow).html('申请待提交');
				}
			}else if(aData.kind == 3){
				$('td:eq(0)', nRow).html("付款管理");
				//审批状态0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳审批 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意 10：出纳不同意
				if(aData.status == "1") {
					$('td:eq(5)', nRow).html('部门经理审批');
				}else if(aData.status == "11"){
					$('td:eq(5)', nRow).html('项目负责人审批');
				} else if(aData.status == "2") {
					$('td:eq(5)', nRow).html('财务审批');
				} else if(aData.status == "3") {
					$('td:eq(5)', nRow).html('总经理审批');
				} else if(aData.status == "4") {
					$('td:eq(5)', nRow).html('出纳审批');
				}else if(aData.status == "5") {
					$('td:eq(5)', nRow).html('已归档');
				} else if(aData.status == "6") {
					$('td:eq(5)', nRow).html('取消申请');
				} else if(aData.status == "7" || aData.status == "8" || aData.status == "9" || aData.status == "10" || aData.status == '12') {
					$('td:eq(5)', nRow).html('提交申请');
				} else if(aData.status == null || aData.status== "") {
					$('td:eq(5)', nRow).html('未提交');
				} 
			}
		}
		$('td:eq(1)', nRow).html(aData.name);
		if(aData.applyTime != null){
			$('td:eq(2)', nRow).html(dateFormatRefactoring(aData.applyTime));
		}else{
			$('td:eq(2)', nRow).html("");
		}
			$('td:eq(3)', nRow).html(aData.orderNo);
		if(aData.actReimburse != null){
			$('td:eq(4)', nRow).html(initInputMask(aData.actReimburse));
		}else{
			$('td:eq(4)', nRow).html("");
		}
			// 操作
			var htmlText = buildOperate(nRow,aData,1);
			$('td:eq(9)', nRow).html(htmlText);
	    return nRow;
	}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow,aData,type) {	
	var html = [];
	//类型为0,则是合同跳转
	if(type == 0){
		if( aData.processInstanceId != null  && aData.status != null){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",'"+aData.barginType+"','')");
		}else if ( aData.processInstanceId == null  && aData.status == "5" && $("#currUserId").val() != aData.userId){
			//原来数据库的数据，手动变成已归档状态,他人只可以看
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/view?id="+aData.id+"'");
		}else{
			//原来数据库的数据，手动变成已归档状态，申请人自己可更改
			$(nRow).attr("onclick", "parent.location.href='"+web_ctx+"/manage/sale/barginManage/toAddOrEdit?id="+aData.id+"'");
		}
	}else if(type == 1){
		//报销跳转
		if(aData.kind == 1){
			if( aData.processInstanceId != null  && aData.status != null){
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",'','"+aData.kind+"')");
			}else{
				$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/travelReimburs/toEdit?id="+aData.id+"'");
			}
		}else if(aData.kind == 2){
			if( aData.processInstanceId != null  && aData.status != null){
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",'','"+aData.kind+"')");
			}else{
				$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/reimburs/toEdit?id="+aData.id+"'");
			}
		}else if(aData.kind == 3){
			if( aData.processInstanceId != null  && aData.status != null){
				$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+",'','"+aData.kind+"')");
			}else{
				$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/pay/toAddOrEdit?id="+aData.id+"'");
			}
		}
	}
	$(nRow).css("cursor", "pointer");
	return html.join("");
}
function toProcess(processInstanceId,barginType,kind) {
	var page="";
	if(barginType !=null && barginType !=''){
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
	var entityClass="";
	var tableName ="";
	}else if(kind !=null && kind !=''){
		if(kind == 1){
			page="manage/finance/travelReimburs/process";
			entityClass="com.reyzar.oa.domain.FinTravelReimburs";
			tableName="fin_travelreimburs";
		}else if(kind == 2){
			page="manage/finance/reimburs/process";
		}else if(kind == 3){
			page="manage/finance/pay/process";
		}
	}
    var param = {
        "processInstanceId": processInstanceId,
        "page": page
    }
    if(entityClass !=""){
    	param["entityClass"] = entityClass;
    }
    if(tableName !=""){
    	param["tableName"] = tableName;
    }
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}
function toAddOrEdit() {
	var projectId=$("#id").val();
	window.location.href  = web_ctx + "/manage/sale/barginManage/toAddOrEdit?projectId=" + projectId;
}
function toPayAdd(){
	var projectId = $("#id").val();
	window.location.href = web_ctx + "/manage/finance/pay/toAddOrEdit?projectId="+projectId;
}
function toCollectionAdd(){
	var projectId = $("#id").val();
	window.location.href = web_ctx + "/manage/finance/collection/toAddNew?projectId="+projectId;
}
function onchanges(obj) {
	if(obj.value.indexOf("%") != -1){
		obj.value=obj.value.replace(/%/g,'')+"%";
	}else{
		obj.value=obj.value+"%";
	}
	cumulative();
};
function cumulative(){
	var commissionProportion=$("input[name='commissionProportion']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
	
	/*var resultsProportion=$("input[name='resultsProportion']")
	var sum1=0;
	for(var i=0;i<resultsProportion.length;i++){
		if(resultsProportion[i].value!=null && resultsProportion[i].value!=undefined && resultsProportion[i].value!=''){
			sum1+=parseFloat(resultsProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative1").html(sum1+"%");*/
}
function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userId']").val(data.id);
        $(currTd).find("input[name='userName']").val(data.name);
        $("#dutyDeptId").val(data.dept.id);
        $("#dutyDeptName,#deptName").val(data.dept.name);
        
        myFunction()        	        
    }
}

function getData2(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='uId']").val(data.id); 
        $(currTd).find("input[name='uName']").val(data.name);
    }
}

function getDeptName() {
    var deptName = $("#dutyDeptId").val();
    return deptName;
}

function myFunction(){
	var name = $("#table1 tbody").eq(0).find('tr #userName').val()
	var id = $("#table1 tbody").eq(0).find('tr #userId').val()
	if(boot){	
		$("#tbodyInfoTr,#tbodyInfoTr1").append('<tr name="node1" class="node1">'
    							+ '<td style="width:33%">'
    							+ '<input id="uId" name="uId" type="text" value="'+ id +'" style="display:none;" data-sorting="'+index+'">'
    							+ '<input type="text" id="uName" name="uName" value="'+ name +'" readonly/></td>'
    							+ '<td style="width:33%"><input type="text" id="commissionProportion" name="commissionProportion" onkeyup="initInputBlur()"  style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
    							+ '</tr>')
    	boot = false;
	}else{
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uId']").val(id);
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uName']").val(name);
		$("#tbodyInfoTr1 tr").eq(0).find('td').eq(0).find("input[name='uId']").val(id);
		$("#tbodyInfoTr1 tr").eq(0).find('td').eq(0).find("input[name='uName']").val(name);
	}   	 
}

function openDialog(obj) {
	currTd = obj;
    $("#userByDeptDialog").openUserDialog();
}

function openDialog2(obj) {
	currTd = obj;
	$("#userDialog").openUserByDeptDialog();	
}
function toModify(){
	var id = $("#id").val();
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManageHistory/getHistoryValidationIsApply",
			type: "post",
			data: {id:id},
			dataType: "json",
			success: function(data) {
				if(data){
					window.location.href =  web_ctx +"/manage/sale/projectManage/toModify?id=" + id;
				}else{
					bootstrapAlert("提示", "已有变更正在审批中", 400, null);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
			}
		});

}

function toHistory(){
	var id = $("#id").val();
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManageHistory/getHistoryValidation",
			type: "post",
			data: {id:id},
			dataType: "json",
			success: function(data) {
				if(data){
						window.location.href = web_ctx + "/manage/sale/projectManageHistory/getHistory?id=" + id;
				}else{
					bootstrapAlert("提示", "无申请记录", 400, null);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
			}
		});

}
function initMenu(){
	$.contextMenu({
	    selector: "#table3 .node", //给table3表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
	        	dataTR='<tr name="node" class="node">'
					+ '<td onclick="openDialog2(this)"  style="width:33%"><input type="text" name="uName"   style="text-align:center" readonly/><input type="hidden" name="uId" data-sorting="'+index+'"></td>'
					/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()"  style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
					+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()"   style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
					+ '</tr>';
		        	$("#tbodyInfoTr,#tbodyInfoTr1").append(dataTR)
	          	}
	        },
	        verygood: {name: "删除", callback: function(key, opt){
	        	var activeClass = $('.context-menu-active');
	        	var userName = $('#table1').find(activeClass).children().eq(0).children("input[name='uName']").val();	        	
	        	if ((this).hasClass('trnode')) {
	        		return;
	        	}else if(userName != "" ){
	        	//	if(confirm('确认删除吗？')){
	        			$(this).remove();
		        //	}
	        	}else{
	        		$('#table1').find(activeClass).remove();
	        		var firstTr = $("#table1").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        }
	      }
	   }
	});
	
	$.contextMenu({
	    selector: "#table3 .node1", //给table3表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog2(this)"  style="width:33%"><input type="text" name="uName"   style="text-align:center" readonly/><input type="hidden" name="uId" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()"   style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()"  style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tbodyInfoTr,#tbodyInfoTr1").append(dataTR);
	          	}
	        }
	      }
	});
}


function fmoney(s, n) {
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + '').replace(/[^\d\.-]/g, '')).toFixed(n) + '';
	var l = s.split('.')[0].split('').reverse(), r = s.split('.')[1];
	var t = '';
	for (var i = 0; i < l.length; i++) {
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? ',' : '');
	}
	return t.split('').reverse().join('') + '.' + r;

}

/*function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}*/

// 金钱格式化
function initMoneyFormat() {
	var totalMoney = $("#totalMoney").val();
	if (totalMoney != null && totalMoney != '') {
		$("#totalMoney").val(fmoney(totalMoney, 0));
	}
	var applyMoney = $("#applyMoney").val();
	if (applyMoney != null && applyMoney != '') {
		$("#applyMoney").val(fmoney(applyMoney, 0));
	}
	var invoiceMoney = $("#invoiceMoney").val();
	if (invoiceMoney != null && invoiceMoney != '') {
		$("#invoiceMoney").val(fmoney(invoiceMoney, 0));
	}
	var actualPayMoney = $("#actualPayMoney").val();
	if (actualPayMoney != null && actualPayMoney != '') {
		$("#actualPayMoney").val(fmoney(actualPayMoney, 0));
	}
}

function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

var approveFalg = "";
function approve(status) {
	approveFalg = status;
	$("#operStatus").val(status);
	oper2Method[status].call();
}

function agree() {
	save();
}
var isOk=true;
function disagree() {
	isOk=false;
	save();
}

function reApply() {
	save();
}

function cancelApply() {
	cancelProcess();
}

/*******************************************************************************
 * 表单处理相关函数 *
 ******************************************************************************/
function save() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	var issubmit = $("#issubmit").val("0");// 区分保存和提交
	var checkMsg = checkForm(formData);
	if (!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return;
	}
	if (fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}
}

function submitForm() {
	var formData = getFormData();
	$.ajax({
		url : web_ctx + "/manage/sale/projectManage/saveInfo",
		type : "post",
		data : JSON.stringify(formData),
		dataType : "json",
		contentType : "application/json",
		success : function(data) {
			if (data.code == 1) {
				var currUserId = $("#currUserId").val();
				var userId = $("#userId").val();
				var oper = $("#operStatus").val();
				var isHandler = $("#isHandler").val();
				var taskName = $("#taskName").val();

				if (oper == "重新申请" || oper == '同意' || oper == '不同意') {
					submitProcess();
				} else {
					backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete : function(data) {
			openBootstrapShade(false);
		}
	});
}

function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["projectMemberList"] = [];
	$("#tbodyInfoTr tr").each(
		function(index, tr) {
			var id = $(this).find("input[name='businessId']").val();
			var userId = $(this).find("input[name='uId']").val();
			/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
			var commissionProportion = $(this).find("input[name='commissionProportion']").val();
			var sorting=$(this).find("input[name='uId']").attr("data-sorting");
			if (!isNull(userId) || !isNull(commissionProportion)) {
				var memberList = {};
				memberList["id"] = id;
				memberList["userId"] = userId;
				memberList["sorting"] = sorting;
				/*memberList["resultsProportion"] = resultsProportion.replace(/%/g,'');*/
				memberList["commissionProportion"] = commissionProportion.replace(/%/g,'');
				formData["projectMemberList"].push(memberList);
			}
		});
	var projectMemberList=formData["projectMemberList"];
	if(projectMemberList==null || projectMemberList.length<=0){
		$("#tbodyInfoTr1 tr").each(
				function(index, tr) {
					var id = $(this).find("input[name='businessId']").val();
					var userId = $(this).find("input[name='uId']").val();
					/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
					var commissionProportion = $(this).find("input[name='commissionProportion']").val();
					var sorting=$(this).find("input[name='uId']").attr("data-sorting");
					if (!isNull(userId) || !isNull(commissionProportion)) {
						var memberList = {};
						memberList["id"] = id;
						memberList["userId"] = userId;
						memberList["sorting"] = sorting;
						/*memberList["resultsProportion"] = resultsProportion.replace(/%/g,'');*/
						memberList["commissionProportion"] = commissionProportion.replace(/%/g,'');
						formData["projectMemberList"].push(memberList);
					}
				});
	}
	formData["size"]=commafyback($("#size").val());
	return formData;
}

function checkForm(formData) {
	var text = [];
	var barginCode = $.trim($("#barginCode").val());
	var status=$("#status").val();
	if(status== '-1'){
		var projectEndDate=$("#projectEndDate").val();
		if(projectEndDate == null || projectEndDate == ''){
			text.push("状态选关闭，请填写结束时间！");
		}
	}
	if(isOk){
	/*$("tr[name='node1']").each(function(business, tr) {
		var value = $(tr).find("input[name='resultsProportion']").val();
		if (value == "" || value == null || value == '%') {
			text.push("业绩比例不能为空！<br/>");
			return false
		}
	});*/

	$("tr[name='node1']").each(function(business, tr) {
		var value = $(tr).find("input[name='commissionProportion']").val();
		if (value == "" || value == null  || value == '%') {
			text.push("提成比例不能为空！<br/>");
			return false
		}
	});


	/*$("tr[name='node']").each(function(business, tr) {
		var resultsProportion = $(tr).find("input[name='resultsProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		if(!isNull(resultsProportion) || !isNull(uName) || !isNull(commissionProportion)) {
			if (resultsProportion == "" || resultsProportion == null  || resultsProportion == '%') {
				text.push("业绩比例不能为空！<br/>");
				return false
			}
		}
	});*/

	$("tr[name='node']").each(function(business, tr) {
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
	/*	var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
		if(  !isNull(uName) || !isNull(commissionProportion)) {
			if (commissionProportion == "" || commissionProportion == null || commissionProportion == '%') {
				text.push("提成比例不能为空！<br/>");
				return false
			}
		}
	});

	$("tr[name='node']").each(function(business, tr) {
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
		/*var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
		if( !isNull(uName) || !isNull(commissionProportion)) {
			if (uName == "" || uName == null) {
				text.push("成员名字不能为空！<br/>");
				return false
			}
		}
	});
	}
	return text;
}

// 调用发送邮件的方法
function sendMail() {
	var comment = $("#comment").val();
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/projectManage/sendMail",
		"dataType" : "json",
		"data" : {
			"id" : $("#id").val(),
			"contents" : comment
		}
	});
}

function submitProcess() {
	var variables = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variables);
	var operStatus = $("#operStatus").val();
	
	if (compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		$("#currStatus").val(status);
		if (statusResult.code == 1) {
			var text = "操作成功！";
			if (approveFalg == "不同意") {
				sendMail();
			}
			if ($("#operStatus").val() == "提交") {
				text = "提交成功 ！";
			} else if ($("#operStatus").val() == "重新申请") {
				text = "重新申请成功 ！";
			} else if ($("#operStatus").val() == "取消申请") {
				text = "取消申请成功 ！";
			}

			window.parent.initTodo();
			backPageAndRefresh();

		} else {
			bootstrapAlert("提示", statusResult.result, 400, null);
		}
	} else if (compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}

	validate();
	openBootstrapShade(false);
}

// 取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if (result != null) {
			if (result.code == 1) {
				var statusResult = setStatus("6");
				if (statusResult.code == 1) {
					window.parent.initTodo();
					backPageAndRefresh();
				} else {
					bootstrapAlert("提示", statusResult.result, 400, null);
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}

function openProject() {
	$("#projectDialog").openProjectDialog();
}

function getProjectData(data) {
	if (!isNull(data) && !$.isEmptyObject(data)) {
		$("#projectManageName").val(data.name);
		$("#projectManageId").val(data.id);
	}
}
function initDatetimepicker() {
	$(".projectDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	$(".projectEndDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

/*
 *  审批状态 0： 重新申请 1：项目负责人审批 2：部门主管审批 3：财务审批 4：总经理审批 5：已归档  6：取消申请 7：项目负责人不同意 8：部门主管不同意
 * 9：财务不同意 10：总经理不同意 
 */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	if ($("#operStatus").val() == "同意") {
		status = approvedStatus[currStatus];
	} else if ($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	} else {
		status = "1";
	}

	return status;
}

//function setStatus(status) {
//	var id = $("#id").val();
//	var result = {};
//	$.ajax({
//		"type" : "POST",
//		"url" : web_ctx + "/manage/sale/projectManage/setStatus",
//		"dataType" : "json",
//		"async" : false,
//		"data" : {
//			"id" : id,
//			"status" : status
//		},
//		"success" : function(data) {
//			result = data;
//		},
//		"error" : function(data) {
//			result.code = -1;
//			result.result = "网络错误，请稍后重试！";
//		}
//	});
//
//	return result;
//}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/projectManage/setStatusNew",
		"dataType" : "json",
		"async" : false,
		"data" : {
			"id" : id,
			"status" : status
		},
		"success" : function(data) {
			result = data;
		},
		"error" : function(data) {
			result.code = -1;
			result.result = "网络错误，请稍后重试！";
		}
	});

	return result;
}

function getVariables() {
	var commentList = variables.commentList;
	if (isNull(commentList)) {
		commentList = [];
	}

	var operStatus = $("#operStatus").val();
	var form = {
		"node" : getNodeInfo(),
		"approver" : $("#approver").val(),
		"comment" : operStatus != "提交" ? $("#comment").val() : "",
		"approveResult" : "",
		"approveDate" : new Date().pattern("yyyy-MM-dd HH:mm")
	};
	form["approveResult"] = nodeOnOper[operStatus];
	commentList.push(form);
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = operStatus == "同意" || operStatus == "重新申请"
			|| operStatus == "提交" || operStatus == "结束流程" ? true : false;

	return variables;
}

function updateBarginInfo(id, unpayMoney, payMoney, payUnreceivedInvoice,
		payReceivedInvoice) {
	var json = {
		"id" : id,
		"unpayMoney" : unpayMoney,
		"payMoney" : payMoney,
		"payUnreceivedInvoice" : payUnreceivedInvoice,
		"payReceivedInvoice" : payReceivedInvoice
	};

	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/sale/barginManage/updateBarginInfo",
		"dataType" : "json",
		"contentType" : "application/json;charset=UTF-8",
		"data" : JSON.stringify(json),
		"success" : function(data) {
			if (data != null && data.code != 1) {
				bootstrapAlert("提示", "操作失败！", 400, null);
			}
		},
		"error" : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function findBarginById(id) {
	var barginResult = {};
	$
			.ajax({
				"type" : "POST",
				"url" : web_ctx + "/manage/sale/barginManage/findById",
				"dataType" : "json",
				"data" : {
					"id" : id
				},
				"async" : false,
				"success" : function(data) {
					barginResult["unpayMoney"] = data.result.unpayMoney;
					barginResult["payMoney"] = data.result.payMoney;
					barginResult["payUnreceivedInvoice"] = data.result.payUnreceivedInvoice;
					barginResult["payReceivedInvoice"] = data.result.payReceivedInvoice;
				},
				"error" : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
	return barginResult;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
	var currStatus = $("#currStatus").val();
	if (isNull(currStatus) || $("#operStatus").val() == "重新申请"
			|| $("#operStatus").val() == "取消申请") {
		currStatus = "0";
	}

	return nodeOnStatus[currStatus];
}

// 下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url, '_blank');
	}
}

function del(){
	var id=$("#id").val();
	if (!isNull(id)) {
		bootstrapConfirm("提示", "确定要删除该项目吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/sale/projectManage/deleteById",
				data : {
					"id" : id
				},
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.code == 1) {
						bootstrapAlert("提示", data.result, 400, function() {
							window.history.back(-1); 
						});
					}
				},
				error : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}

			});
		}, null);
	} else {
		bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	}
}

// 删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/sale/projectManage/deleteAttach",
				data : {
					"path" : $("#attachments").val(),
					"id" : $("#id").val()
				},
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
						});
					} else {
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
				error : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}

			});
		}, null);
	} else {
		bootstrapAlert("提示", "无附件！", 400, null);
	}
}

// 文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path" : "pay/" + date.getFullYear() + (date.getMonth() + 1)
				+ date.getDate(),
		"deleteFile" : $("#attachments").val()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload(
			{
				url : web_ctx + '/fileUpload?' + urlParam,
				dataType : 'json',
				formData : params,
				maxFileSize : 50 * 1024 * 1024, // 50 MB
				messages : {
					maxFileSize : '附件大小最大为50M！'
				},
				add : function(e, data) {
					var $this = $(this);
					data.process(function() {
						return $this.fileupload('process', data);
					}).done(function() {
						fileData = data;
						$("#showName").val(data.files[0].name);
					}).fail(
							function() {
								var errorMsg = [];
								$(data.files).each(function(index, file) {
									errorMsg.push(file.error);
								});
								bootstrapAlert("提示", errorMsg.join("<br/>"),
										400, null);
							});
				},
				done : function(e, data) {
					var result = data.result;
					if (result.execResult.code != 0) {
						// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
						params["deleteFile"] = result.path;
						urlParam = urlEncode(params);
						$("#file").fileupload("option", "url",
								(web_ctx + '/fileUpload?' + urlParam));
						$("#file").fileupload("option", "formData", urlParam);
						$("#showName").val(result.originName);
						$("#attachments").val(result.path);
						$("#attachName").val(result.originName);

						var formData = getFormData();
						submitForm(formData);

					} else {
						openBootstrapShade(false);
						bootstrapAlert("提示", "保存文件失败，错误信息："
								+ result.execResult.result, 400, null);
					}
				}
			});
}

/*
 * 初始化相关操作
 */
function inittextarea() {
	autosize(document.querySelectorAll('textarea'));
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	if(variables!=null && variables!=''){
	var commentList = variables.commentList;
	if (isNull(commentList)) {
		commentList = [];
	}

	for (var i = commentList.length - 1; i >= 0; i--) {
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
		html.push(commentList[i].approver);
		html.push("</td>");
		html.push("<td>");
		var approveDate = commentList[i].approveDate + "";
		if (!dateRep.test(approveDate)) {
			html.push(new Date(commentList[i].approveDate)
					.pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g, "/")))
					.pattern("yyyy-MM-dd HH:mm"));
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
}

function initInputMask() {
	// $("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#actualPayMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	/*$("#bankAccount").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0}"
	});*/
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
function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/pay/pdf"
	}
	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
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

//根据职位初始化项目详情只读状态
function initTypeByPosition() {
	if($("#currUserId").val() == "2" || $("#currUserId").val() == "3") {
		$("#name,#size,#projectDate,#commissionProportion").attr("readonly",false);
		$("#projectDate").datetimepicker({
			minView: "month",
			language:"zh-CN",
			format: "yyyy-mm-dd",
			pickDate: true,
			pickTime: false,
			autoclose: true,
		});
		$("#tbodyInfoTr1").find('tr:eq(0)').attr("class","node1");
		$("#tbodyInfoTr1").find('tr:gt(0)').attr("class","node");
	}
}