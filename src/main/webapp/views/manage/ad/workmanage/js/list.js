var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id" : "dataTable",
		"url" : web_ctx + "/manage/ad/workmanage/getList",
		"columns" : initColumn(),
		"search" : getSearchData,
		"rowCallBack" : rowCallBack,
	});
	initDatetimepicker();
});

function initDatetimepicker() {

	$("input[name='workDate']").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});
}

function initColumn() {
	var columns = [ // 这个属性下的设置会应用到所有列
	/* {"mData": 'userId'}, */

	{
		"mData" : 'type'
	}, {
		"mData" : 'dept'
	}, {
		"mData" : 'applicant'
	}, {
		"mData" : 'applyTime'
	}, {
		"mData" : 'status'
	}, ]

	return columns;
}

function getSearchData() {
	var params = {};
	params.type = $.trim($("#type").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.workDate = $.trim($("#workDate").val());
	return params;
}

// 添加回车响应事件
$(document).keydown(function(event) {
	var curkey = event.which;
	if (curkey == 13) {
		drawTable();
		return false;
	}
});

function clearForm() {
	$("#searchForm").clear();
}

function drawTable() {
	if (dataTable != null) {
		dataTable.draw();
	}
}

/**
 * 服务端返回数据后开始渲染表格时调用
 */
function rowCallBack(nRow, aData, iDisplayIndex) {

	if (iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}

	var eq = 3;
	if (aData.type == 1) {
		$('td:eq(0)', nRow).html("商务");
	} else {
		$('td:eq(0)', nRow).html("拜访");
	}
	if (aData.dept.name == "总经理") {
		$('td:eq(1)', nRow).html("");
	} else {
		$('td:eq(1)', nRow).html(aData.dept.name);
	}
	$('td:eq(2)', nRow).html(aData.applicant.name);
	if (aData.status == "") {
		$('td:eq(3)', nRow).html("未提交");
	}else if(aData.status == "3"){
		$('td:eq(3)', nRow).html("已退回");
	}else {
		$('td:eq(3)', nRow).html("已提交");
	}
	$('td:eq(' + (eq + 1) + ')', nRow).html(
			new Date(aData.applyTime).pattern("yyyy-MM-dd"));
	buildOperate(aData, nRow);
	return nRow;
}

/**
 * 构造操作详情HTML
 */
function buildOperate(aData, tr) {
	$(tr).css("cursor", "pointer");
	$(tr).attr("value", aData.id);
	$(tr).attr("onclick",
			"viewDetail(" + aData.id + ",this," + aData.type + ")");
	if ((aData.type == 1 || aData.type == 2) && (aData.status == "3" || aData.status == "")
			&& aData.userId == user) {
		$(tr).attr("canEdit", "y");
	} else if ((aData.type == 1 || aData.type == 2) && aData.status == 1) {
		if (hasEditPermission) {
			$(tr).attr("canCheck", "y");
		} else {
			$(tr).attr("canView", "y");
		}
	}
}

function viewDetail(id, tr, type) {
	if (type == '1') {
		$.ajax({
			"type" : "GET",
			"url" : web_ctx + "/manage/ad/workBiness/getWorkBiness",
			"dataType" : "json",
			"data" : {
				"id" : id
			},
			"success" : function(data) {
				if (!isNull(data)) {
					showBinessDetail(data, tr);
				} else {
					bootstrapAlert("提示", "获取详细信息失败！", 400, null);
				}
			},
			"error" : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}

	if (type == '2') {
		$.ajax({
			"type" : "GET",
			"url" : web_ctx + "/manage/ad/workMarket/getWorkMarket",
			"dataType" : "json",
			"data" : {
				"id" : id
			},
			"success" : function(data) {
				if (!isNull(data)) {
					showMarketDetail(data, tr);
				} else {
					bootstrapAlert("提示", "获取详细信息失败！", 400, null);
				}
			},
			"error" : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}

var flag = false;
// 商务表
function showBinessDetail(data, tr) {
	var html = [];
	$("#name").text(data.applicant.name);
	$("#applyTime").text(new Date(data.applyTime).pattern("yyyy-MM-dd"));
	$("#deptName").text(data.dept.name);

	$(data["buinsessAttachsList"])
			.each(
					function(index, attach) {

						html.push('<tr>');
						html.push('<td style="text-align: center;">');
						html.push(new Date(attach.workDate)
								.pattern("yyyy-MM-dd"));
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.workTime);
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(new Date(attach.payDate)
								.pattern("yyyy-MM-dd"));
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.responsibleUserName);
						html.push('</td>');
						html
								.push('<td style="height:auto;white-space:pre-line;width:auto;word-break:break-all;">');
						html.push(attach.content);
						html.push('</td>');
						html.push('<td>');
						html.push(attach.remark);
						html.push('</td>');
						html.push('</tr>');
					});
	$("#buinsessAttachsList").html(html.join(""));
	$("#backTr").remove();
	var sum = [];
	sum.push('<tr id="backTr">');
	sum.push('<td colspan="8">');
	sum.push('<table style="width:100%; margin:1em 0px;margin-top: 0px;margin-bottom: 0px;" class="table4">');
	sum.push('<thead>');
	sum.push('<tr style="text-align: center;">');
	sum.push('<td  colspan="8" class="td_weight"><span style="font-size:16px;">退回原因</span></td>');
	sum.push('</tr>');
	sum.push('<tr style="text-align: center;">');
	sum.push('<td class="td_weight" style="width:8%;"><span>时间</span></td>');
	sum.push('<td class="td_weight" style="width:8%;"><span>内容</span></td>');
	sum.push('<td class="td_weight" style="width:10%;"><span>操作人</span></td>');
	sum.push('</tr>');
	sum.push('</thead>');
	$(data["buinsessBacksList"]).each(function(index, backs) {
		sum.push('<tr>');
		sum.push('<td  style="text-align: center;">');
		sum.push(new Date(backs.createDate).pattern("yyyy-MM-dd"));
		sum.push('</td>');
		sum.push('<td  style="text-align: center;">');
		sum.push(backs.content);
		sum.push('</td>');
		sum.push('<td  style="text-align: center;">');
		sum.push(backs.sysUser.name);
		sum.push('</td>');
		sum.push('</tr>');
	});
	sum.push('</table>');
	sum.push('</td>');
	sum.push('</tr>');
	if (data["buinsessBacksList"].length > 0) {
		$("#table1").append(sum.join(""));
	}
	// 设置模态框高度
	var bodyHeight = $(window).height();
	var modalHeight = bodyHeight * 0.7;
	$("#workBinessModal").find(".modal-body").css("max-height", modalHeight);
	// 设置模态框按钮组
	var button = [];
	if (!isNull($(tr).attr("canCheck"))) {
		/*
		 * button.push('<button type="button" class="btn btn-primary"
		 * onclick="toAddOrEditBiness('+$(tr).attr("value")+')">审核</button>');
		 */
	}
	if (!isNull($(tr).attr("canEdit"))) {
		$("#lastTr").remove();
		button.push('<button type="button" class="btn btn-primary" onclick="toAddOrEditBiness('
						+ $(tr).attr("value") + ')">编辑</button>');
	}
	if (!isNull($(tr).attr("canCheck"))) {
		$("#lastTr").remove();
		button
				.push('<button type="button" class="btn btn-warning" onclick="toRejectProcessBiness('
						+ $(tr).attr("value") + ')">退回</button>');
		$("#table1")
				.append(
						"<tr id='lastTr'><td colspan='20'><textarea id='contentBuinsess' rows='4' style='width: 100%' placeholder='请填写退回批注'></textarea></td></tr>");
		flag = true;
	}
	button
			.push('<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
	$("#workBinessModal").find(".modal-footer").html(button.join(""));

	$("#workBinessModal").modal("show");
}

// 退回工作汇报商务
function toRejectProcessBiness(id) {
	var contents = $("#contentBuinsess").val();
	
	bootstrapConfirm("退回提示", "是否驳回工作汇报", 400, function(){
		$.ajax({
			"type" : "POST",
			"url" : web_ctx + "/manage/ad/workBiness/rejectProcess",
			"dataType" : "json",
			"data" : {
				"id" : id,
				"contents" : contents
			},
			"success" : function(data) {
				if (!isNull(data)) {
					bootstrapAlert("提示", "退回成功");
					window.location.reload();
				} else {
					bootstrapAlert("提示", "驳回工作汇报失败！", 400, null);
				}
			},
			"error" : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null)
		
}

var flagM = false;
function showMarketDetail(data, tr) {

	var html = [];
	$("#applyName").text(data.applicant.name);
	$("#applyDate").text(new Date(data.applyTime).pattern("yyyy-MM-dd"));
	$("#applyDeptName").text('睿哲科技股份有限公司' + data.dept.name);

	var applyTime = $("#applyDate").val();
	var deptName = $("#applyDeptName").val();

	$(data["marketAttachsList"])
			.each(
					function(index, attach) {

						var level = '';
						if (attach.level == "2") {
							level = '高';
						} else if (attach.level == "1") {
							level = '中';
						} else if (attach.level == "0") {
							level = '低';
						}

						html.push('<tr>');
						html
								.push('<td style="text-align: center;" rowspan="2" >');
						html.push(new Date(attach.workDate)
								.pattern("yyyy-MM-dd"));
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(new Date(attach.startTime)
								.pattern("yyyy-MM-dd HH:mm"));
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(new Date(attach.endTime)
								.pattern("yyyy-MM-dd HH:mm"));
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.company);
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.clientName);
						html.push('</td>');

						html.push('<td style="text-align: center;">');
						html.push(attach.clientPosition);
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.clientPhone);
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(level);
						html.push('</td>');
						html.push('<td style="text-align: center;">');
						html.push(attach.responsibleUserName);
						html.push('</td>');
						html.push('<td>');
						html.push(attach.remark);
						html.push('</td>');
						html.push('</tr>');

						html.push('<tr>');
						/*
						 * html.push('<td style="text-align: center;font-weight: bold;">');
						 * html.push('拜访内容'); html.push('</td>');
						 */
						html
								.push('<td style="height:auto;white-space:pre-line;width:auto;word-break:break-all;" colspan="9">');
						html.push(attach.content);
						html.push('</td>');
						html.push('</tr>');
					});
	$("#marketAttachsList").html(html.join(""));

	$("#marketbackTr").remove();
	var sum = [];
	sum.push('<tr id="marketbackTr">');
	sum.push('<td colspan="10">');
	sum.push('<table style="width:100%; margin:1em 0px;margin-top: 0px;margin-bottom: 0px;" class="table2">');
	sum.push('<thead>');
	sum.push('<tr style="text-align: center;">');
	sum.push('<td  colspan="8" class="td_weight"><span style="font-size:16px;">操作历史</span></td>');
	sum.push('</tr>');
	sum.push('<tr style="text-align: center;">');
	sum.push('<td class="td_weight" style="width:8%;"><span>时间</span></td>');
	sum.push('<td class="td_weight" style="width:8%;"><span>内容</span></td>');
	sum.push('<td class="td_weight" style="width:10%;"><span>操作人</span></td>');
	sum.push('</tr>');
	sum.push('</thead>');
	$(data["marketBacksList"]).each(function(index, backs) {
		sum.push('<tr>');
		sum.push('<td  style="text-align: center;">');
		sum.push(new Date(backs.createDate).pattern("yyyy-MM-dd"));
		sum.push('</td>');
		sum.push('<td  style="text-align: center;">');
		sum.push(backs.content);
		sum.push('</td>');
		sum.push('<td  style="text-align: center;">');
		sum.push(backs.sysUser.name);
		sum.push('</td>');
		sum.push('</tr>');
	});
	sum.push('</table>');
	sum.push('</td>');
	sum.push('</tr>');
	if (data["marketBacksList"].length > 0) {
		$("#table3").append(sum.join(""));
	}
	
	// 设置模态框高度
	var bodyHeight = $(window).height();
	var modalHeight = bodyHeight * 0.7;
	$("#workMarketModal").find(".modal-body").css("max-height", modalHeight);

	// 设置模态框按钮组
	var button = [];
	/*
	 * if( !isNull($(tr).attr("canCheck")) ) { button.push('<button
	 * type="button" class="btn btn-primary"
	 * onclick="toAddOrEditMarket('+$(tr).attr("value")+')">审核</button>'); }
	 */
	if (!isNull($(tr).attr("canEdit"))) {
		$("#mlastTr").remove();
		button.push('<button type="button" class="btn btn-primary" onclick="toAddOrEditMarket('
						+ $(tr).attr("value") + ')">编辑</button>');
	}
	if (!isNull($(tr).attr("canCheck"))) {
		$("#mlastTr").remove();
		button.push('<button type="button" class="btn btn-warning" onclick="toRejectProcessMarket('
						+ $(tr).attr("value") + ')">退回</button>');
		$("#table3").append("<tr id='mlastTr'><td colspan='20'><textarea id='contentMarket' rows='4' style='width: 100%' placeholder='请填写批注'></textarea></td></tr>");
		flagM = true;
	}
	button.push('<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
	$("#workMarketModal").find(".modal-footer").html(button.join(""));

	$("#workMarketModal").modal("show");
}

// 退回工作汇报中拜访
function toRejectProcessMarket(id) {
	var contents = $("#contentMarket").val();
	bootstrapConfirm("退回提示", "是否驳回工作汇报", 400, function(){
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/ad/workMarket/rejectProcess",
		"dataType" : "json",
		"data" : {
			"id" : id,"contents":contents
		},
		"success" : function(data) {
			if (!isNull(data)) {
				bootstrapAlert("提示", "退回成功");
				window.location.reload();
			} else {
				bootstrapAlert("提示", "驳回工作汇报失败！", 400, null);
			}
		},
		"error" : function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	},null);
}

function toAdd() {
	window.location.href = "toAdd";
}

function toAddOrEditBiness(id) {
	window.location.href = web_ctx + "/manage/ad/workBiness/toEdit?id=" + id;
}

function toAddOrEditMarket(id) {
	window.location.href = web_ctx + "/manage/ad/workMarket/toEdit?id=" + id;
}
