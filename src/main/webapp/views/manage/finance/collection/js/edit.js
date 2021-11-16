var currTd = null;
$(function() {
	$("#barginDialog").initBarginDialog({
		"callBack" : getBargin
	});

	if ($("#barginManageId").val() != null && $("#barginManageId").val() != "") {
		$("#viewBarginBtn").show();
	}
	$("#projectDialog").initProjectDialog({
		"callBack" : getProject
	});
	initDatetimepicker();
	initInputMask();
	initinvoiced();
	initFileUpload();
	coutmoney();
	$("tr[name='add']").each(function(index, tr) {
		var levied = rmoney($(tr).find("input[name='levied']").val());
		if (!isNull(levied)) {
			$(tr).find("input[name='levied']").val(fmoney(levied, 0));
		}
	});
	$("#totalPay").val(fmoney($("#totalPay").val(),0));
	$("#applyPay").val(fmoney($("#applyPay").val(),0))

});

var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if (!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectId']").val(data.id);
		$(projectObj).find("input[name='projectManageName']").val(data.name);
	}
}

function countAll() {
	var sum = 0;
	var sum1 = 0;
	var sum3=0;
	$("tr[name='add']").each(function(index, tr) {
		temp = rmoney($(tr).find("input[name='money']").val());
		totalTemp= rmoney($(tr).find("input[name='levied']").val());
		if (temp == "" || temp == null) {
			temp = 0;
		}
		temp1 = rmoney($(tr).find("input[name='exciseMoney']").val());
		if (temp1 == "" || temp1 == null) {
			temp1 = 0;
		}
		sum = digitTool.add(sum, parseFloat(temp));
		sum1 = digitTool.add(sum1, parseFloat(temp1));
		sum3=digitTool.add(sum3, parseFloat(totalTemp));
	});
	var tr = $("#table2").find("#totalCount");
	$(tr).find("input[name='total']").val(fmoney(sum, 0));
	$(tr).find("input[name='totalexcisemoney']")
			.val(fmoney(sum1.toFixed(2), 0));
	var nexttr = $(tr).next();
	$(nexttr).find("input[name='totalexcise']").val(
			fmoney((sum3).toFixed(2), 0));
}


function initInputMask() {
	/*$("#applyPay").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,2}"
	});*/
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if (name == "collectionBill") {
			$(input).inputmask("Regex", {
				regex : "\\d+\\.?\\d{0,2}"
			});
		}
	});

	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if (name == "number") {
			$(input).inputmask("Regex", {
				regex : "\\d+\\.?\\d{0,0}"
			});
		}
	});

	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		
		/* if (name == "levied") { $(input).inputmask("Regex", { regex:
		  "^-?\\d+\\.?\\d{0,2}"}); }*/
		 
	});
	/*
	 * $("#collectionNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	 * $("#paynumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	 */
	$("#bankNumber").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,0}"
	});
	$("#collectionAccount").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,0}"
	});
}

function coutmoney() {
	$("tr[name='add']").each(
			function(index, tr) {
				var levied = rmoney($(tr).find("input[name='levied']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if(!isNull(levied)){
					$(tr).find("input[name='money']").val(
							fmoney((levied / (1 + excise)).toFixed(2), 0));
				}else{
					$(tr).find("input[name='money']").val(0);
				}
				coutexcise(tr);
			});
}

function coutexcise(tr) {
	var number = $(tr).find("input[name='number']").val();
	var money = rmoney($(tr).find("input[name='money']").val());
	var excise = $(tr).find("select[name='excise']").val() / 100;
	if (money != null && money != "") {
		if (excise != 0 && money!=0) {
			$(tr).find("input[name='exciseMoney']").val(
					fmoney((money * excise).toFixed(2), 0));
		} else {
			$(tr).find("input[name='exciseMoney']").val(0);
		}
		if (number != null && number != "") {
			$(tr).find("input[name='price']").val(
					fmoney((money / number).toFixed(2), 0));
		} else {
			$(tr).find("input[name='price']").val(0);
		}

	}
	countAll();
}

function initexcise() {
	$("tr[name='add']").each(
			function(index, tr) {
				var money = rmoney($(tr).find("input[name='money']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if (excise == 0 || money==0) {
					$(tr).find("input[name='exciseMoney']").val(0);
				}else if (money != null && money != "" && excise != null
						&& excise != "") {
					$(tr).find("input[name='exciseMoney']").val(
							fmoney(money * excise, 0));
				}
			});
	coutmoney();
	// countAll();
}


/* 金额使用千分位表示 */
/*function fmoney(s, n) {
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(0) + "";
	var l = s.split(".")[0].split("").reverse(), r = s.split(".")[1];
	t = "";
	for (i = 0; i < l.length; i++) {
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
	}
	return t.split("").reverse().join("");
}*/

function fmoney(s, n){
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + '').replace(/[^\d\.-]/g, '')).toFixed(n) + '';
	var l = s.split('.')[0].split('').reverse(), r = s.split('.')[1];
	var t = '';
	for (var i = 0; i < l.length; i++) {
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? ',' : '');
	}
	return t.split('').reverse().join('') + '.' + r;

}

function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

function initInputBlur() {
	var totalmoney = rmoney($("#totalPay").val());
	var applyPay = rmoney($("#applyPay").val());
	if (!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0") {
		$("#applyProportion").val(
				(digitTool.divide(applyPay, totalmoney) * 100).toFixed(2) + "%");
	}
}

// 是否隐藏发票表
function initinvoiced(obj) {
	if ($(obj).val() == '1') {
		$("#table2").show();
	} else {
		$("#table2").hide();
	}
}

function initinvoiced() {
	if ($("#isInvoiced").val() == '1') {
		$("#table2").show();
	} else {
		$("#table2").hide();
	}
}

function openBargin() {
	$("#barginDialog").openBarginDialog();
}

function getBargin(data) {
	if (!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(data.totalMoney);
		if (data.projectManage != null && data.projectManage != "") {
			$("#projectManageName").val(data.projectManage.name);
			$("#projectManageId").val(data.projectManage.id);
		}

		if (data.processInstanceId != null && data.processInstanceId != ""
				&& data.processInstanceId != "undefined") {
			$("#tip").remove();
			$("#viewBarginBtn").show();
		} else {
			$("#tip").remove();

			document.getElementById("viewBarginBtn").style.display = "none";

			$("#viewBarginBtn")
					.before(
							'<font id="tip" style="border:none;color: rgb(54, 127, 169)">选取成功！</font>');
		}

	}
}

// 查看合同详情
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();

	var url = "";
	if (barginProcessInstanceId != null && barginProcessInstanceId != "") {
		var param = {
			"processInstanceId" : barginProcessInstanceId,
			"page" : "manage/sale/barginManage/viewDetail"
		}
		url = web_ctx + "/activiti/process?" + urlEncode(param);
	}

	$("#barginDetailFrame").attr("src", url);
	$("#barginDetailModal").modal("show");
}

function initDatetimepicker() {

	$(".collectionDate").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});

	$(".billDate").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true,
	});

}

function node(oper, obj) {
	if (oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input")
				.each(function(index, input) {
					$(this).trigger("keyup");
				});
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		initInputMask();
	}
}

function add(oper, obj) {
	if (oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input")
				.each(function(index, input) {
					$(this).trigger("keyup");
				});
		coutmoney();
		initexcise();
	} else {
		var html = getAddHtml();
		$(obj).parents("tr").after(html);
		initInputMask();
	}
}

// 收款登记行
function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html
			.push('	<td colspan="3"><input type="text" style="text-align:center;" name="collectionDate" class="collectionDate" value=""  readonly></td>');
	html
			.push('	<td colspan="3"><input type="text" name="collectionBill" value="" ></td>');
	html.push('<td colspan="3" style="text-align:center;">');
	html
			.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'
					+ base
					+ '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'
					+ base + '/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");

}

// 发票详情行
function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td><input type="text"  name="name" value="" > </td>');
	html.push('<td><input type="text"  name="model" value="" > </td>');
	html.push('<td><input type="text" name="unit" value=""  ></td>');
	html
			.push('<td><input type="text" name="number" value=""  onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="price" value="" readonly></td>');
	html.push('<td><input type="text" name="money" value="0"  readonly></td>');
	html
			.push('<td><select name="excise" onchange="initexcise()" style="width: 100%;">');
	html.push('<option selected="selected">0</option>');
	html.push('<option>6</option>');
	html.push('<option>13</option>');
	html.push('<option>16</option>');
	html.push('<option>17</option>');
	html.push('</select></td>');
	html
			.push('<td><input type="text" name="exciseMoney" value="0"  readonly ></td>');
	html
			.push('<td><input type="text"  name="levied" value="" onkeyup="coutmoney()"></td>')
	html.push('<td style="text-align:center;">');
	html
			.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="添加" src="'
					+ base
					+ '/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="删除" src="'
					+ base + '/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}

function submitinfo() {
	var formData = getFormData();
	var issubmit = $("#issubmit").val("1");
	if (!checkForm(formData)) {
		return;
	}
	if (fileData != null) { // 已选择文件，则先上传文件
		openBootstrapShade(true);
		fileData.submit();
	} else {
		/* openBootstrapShade(true); */
		submitForm(formData);
	}
}

function submitForm(formData) {
	$.ajax({
		url : "submitinfo",
		type : "post",
		contentType : "application/json;charset=UTF-8",
		data : JSON.stringify(formData),
		dataType : "json",
		success : function(data) {
			openBootstrapShade(false);
			if (data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error : function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

// 保存表单信息
function save() {
	var formData = getFormData();
	var issubmit = $("#issubmit").val("0");
	if (!checkForm(formData)) {
		return;
	}
	if (fileData != null) { // 已选择文件，则先上传文件
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		saveForm(formData);
	}
}

// 保存表单
function saveForm(formData) {
	$.ajax({
		url : "save",
		type : "post",
		contentType : "application/json",
		data : JSON.stringify(formData),
		dataType : "json",
		success : function(data) {
			openBootstrapShade(false);
			if (data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error : function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function getFormData() {
	if(!isNull($("#totalPay").val())){
		$("#totalPay").val(rmoney($("#totalPay").val()));
	}
	if(!isNull($("#applyPay").val())){
		$("#applyPay").val(rmoney($("#applyPay").val()));
	}
	
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["collectionAttachList"] = [];
	formData["invoicedAttachList"] = [];

	$("tbody").find("tr[name='node']").each(
			function(index, tr) {
				var collectionDate = $(this).find(
						"input[name='collectionDate']").val();
				var collectionBill = $(this).find(
						"input[name='collectionBill']").val();
				if (!isNull(collectionDate) || !isNull(collectionBill)) {

					var collectionAttach = {};
					collectionAttach["collectionDate"] = collectionDate;
					collectionAttach["collectionBill"] = collectionBill;
					formData["collectionAttachList"].push(collectionAttach);
				}
			});

	$("tbody").find("tr[name='add']").each(function(index, tr) {
		var name = $(this).find("input[name='name']").val();
		var model = $(this).find("input[name='model']").val();
		var unit = $(this).find("input[name='unit']").val();
		var number = $(this).find("input[name='number']").val();
		var price = $(this).find("input[name='price']").val();
		var money = $(this).find("input[name='money']").val();
		var excise = $(this).find("select[name='excise']").val();
		var exciseMoney = $(this).find("input[name='exciseMoney']").val();
		var levied = $(this).find("input[name='levied']").val();
		if (!isNull(name) || !isNull(model)) {
			var invoiceAttach = {};
			invoiceAttach["name"] = name;
			invoiceAttach["model"] = model;
			invoiceAttach["unit"] = unit;
			invoiceAttach["number"] = number;
			invoiceAttach["price"] = price;
			invoiceAttach["money"] = money;
			invoiceAttach["excise"] = excise;
			invoiceAttach["exciseMoney"] = exciseMoney;
			invoiceAttach["levied"] = levied;
			formData["invoicedAttachList"].push(invoiceAttach);
		}

	});
	return formData;
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if ($("#isInvoiced").val() == '1') {
		if (isNull(formData["applyPay"])) {
			text.push("申请金额不能为空！<br/>");
		}
		if (isNull(formData["payCompany"])) {
			text.push("付款单位不能为空！<br/>");
		}
		/*
		 * if(isNull(formData["barginId"])){ text.push("请选择相关合同！<br/>"); }
		 */
		if (isNull(formData["payname"])) {
			text.push("购货单位不能为空！<br/>");
		}
		if (isNull(formData["paynumber"])) {
			text.push("纳税人识别号不能为空！<br/>");
		}
		if (isNull(formData["bankAddress"]) || isNull(formData["bankNumber"])) {
			text.push("开户行和账号不能为空！<br/>");
		}
		if (formData["invoicedAttachList"].length <= 0) {
			text.push("至少有一条发票项！");
		} else {
			$(formData["invoicedAttachList"]).each(function(index, attach) {
				if(isNull(attach["levied"])){
					text.push("价税小计不能为空！");
					return false;
				}
				if (isNull(attach["name"])) {
					text.push("名称不能为空！");
					return false;
				}
				if (isNull(attach["number"])) {
					text.push("数量不能为空！");
					return false;
				}
				if (isNull(attach["price"])) {
					text.push("单价不能为空！");
					return false;
				}
				if (isNull(attach["money"])) {
					text.push("金额不能为空！");
					return false;
				}
				if (isNull(attach["excise"])) {
					text.push("税率不能为空！");
					return false;
				}
			});

		}
	} else {
		if (isNull(formData["applyPay"])) {
			text.push("申请金额不能为空！<br/>");
		}
		if (isNull(formData["payCompany"])) {
			text.push("付款单位不能为空！<br/>");
		}
		if (isNull(formData["projectId"])) {
			text.push("请选择相关项目！<br/>");
		}
		 if(isNull(formData["totalPay"])){
	            text.push("总金额不能为空！<br/>");
	        }
	}

	if (text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

// 文件上传

var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path" : "collection/" + date.getFullYear() + (date.getMonth() + 1)
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

						if ($("#issubmit").val() == "0") {
							saveForm(formData);
						} else {
							submitForm(formData);
						}
					} else {
						openBootstrapShade(false);
						bootstrapAlert("提示", "保存文件失败，错误信息："
								+ result.execResult.result, 400, null);
					}
				}
			});
}

// 下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url, '_blank');
	}
}

function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/finance/collection/deleteAttach",
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
