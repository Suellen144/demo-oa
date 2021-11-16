var type2html = {
	"salaryRecord" : getHtmlForSalaryRecord,
	"stationRecord" : getHtmlForStationRecord,
	"signRecord" : getHtmlForSignRecord,
	"oldworkRecord" : getHtmlForOldworkRecord,
	"educationRecord" : getHtmlForEducationRecord,
	"honorRecord" : getHtmlForHonorRecord
};
var type2value = {
	"salaryRecord" : "0",
	"stationRecord" : "1",
	"signRecord" : "2",
	"oldworkRecord" : "3",
	"educationRecord" : "4",
	"honorRecord" : "5"
};

var rMenu;
$(document).ready(function() {
	cancel();
	makeValidRule();
	initFileUpload();
	initPosition();
	initInputMask();
	initInputKeyUp();
	initDecryption();
	initChecked();
	initSex();
	$("#backBtn").hide();
	$("#save_btn").hide();

	/* inittextarea(); */

	
	 $("#positionDialog").initPositionDialog({ 
		 "callBack": getPosition,
		 "isCheck": true });
	 
	$("#deptDialog").initDeptDialog({
		"callBack" : getDept,
		"isCheck" : false
	});
	$("#userByDeptDialog").initUserByDeptDialog({
		"callBack" : getData
	});

	initnumber();
	rMenu = $("#rMenu");

	deptAndRolesTwo();
});

function inittextarea() {
	autosize(document.querySelectorAll('textarea'));
}

function initnumber() {
	var id = $("#id").val();
	var number = "";
	if (id < 10) {
		number = "000" + id;
	} else if (id >= 10 && id < 99) {
		number = "00" + id;
	} else if (id >= 100 && id < 999) {
		number = "0" + id;
	} else {
		number = id;
	}
	$("#number").val(number);
}

function initSex() {
	if ($("#sex").val() == '0') {
		$("#sexName").val("男");
	}
	if ($("#sex").val() == '1') {
		$("#sexName").val("女");
	}
}
//选中后置空有效期
function selectOnchang(obj){
	var attachUrl = $(obj).attr("value");
	$(this).find("input[name='validity']").val("");
}
function openPosition() {
	$("#positionDialog").openPositionDialog();
}

/*function getPosition(positionList) {
	if (positionList != null && positionList.length > 0) {
		var positionName = [];
		var positionId = [];
		$(positionList).each(function(index, position) {
			positionName.push(position.name);
			positionId.push(position.id);
		});

		$.ajax({
			url : web_ctx + "/manage/ad/position/findUpPosition",
			type : "get",
			dataType : "json",
			contentType : "application/json;charset:UTF-8",
			data : {
				"ids" : positionId
			},
			traditional : true,
			success : function(data) {
				if (data.code == 1) {
					var position = [];
					var result = data.result;
					for (var i = 0; i < result.length; i++) {
						position.push(result[i] + "\r");
					}
					$("#position").text(" ");
					$("#position").text(position.join(","));
				} else {
					bootstrapAlert("提示", "操作失败！", 400, null);
				}
			},
			error : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	} else {
		$("#position").val("");
	}
}*/

var key = "";
function initTd() {
	var tr = $('#tbSal tr:last');
	$("tr[name='salary']").each(function(index, tr) {
		$(tr).find("span[name='total']").attr('readonly', true);
	})
	if ($(tr).find("span[name='total']").text() != "") {
		if (key == "" || key == null) {
			$("tr[name='salary']")
					.each(
							function(index, tr) {
								$(tr)
										.find(
												"input[name='basePay'],input[name='meritPay'],input[name='agePay'],input[name='lunchSubsidy'],input[name='computerSubsidy'],input[name='accumulationFund']")
										.attr('readonly', true);
							})

			$("td[name='tdSalarys']").addClass("displayShow");
			$("td[name='tdSalary']").each(function(index, td) {
				$(td).addClass("displayShow");
			})
		} else {
			$("tr[name='salary']")
					.each(
							function() {
								$(tr)
										.find(
												"input[name='basePay'],input[name='meritPay'],input[name='agePay'],input[name='lunchSubsidy'],input[name='computerSubsidy'],input[name='accumulationFund']")
										.removeAttr('readonly');
							})
			$("td[name='tdSalarys']").removeClass("displayShow");
			$("td[name='tdSalary']").each(function(index, td) {
				$(td).removeClass("displayShow");
			})
		}
	}
}

/** *********** 加解密操作 Begin ************* */
// 如果有解密权限，则解密当前已加密的数据
function initDecryption() {
	if (hasDecryptPermission) {
		var now = new Date().pattern("yyyyMMdd");
		$.ajax({
			url : web_ctx + '/manage/getEncryptionKey?baseKey=' + now,
			type : 'GET',
			success : function(data) {
				if (data.code == 1) {
					var tempKey = data.result;
					var encryptionKey = aesUtils.decryptECB(tempKey, now);
					key = encryptionKey;
					encryptPageText(encryptionKey);
				} else {
					if (data.code == -1) {
						bootstrapAlert('提示', data.result, 400, null);
					}
					disabledEncryptPageText();
				}
			}
		});
	} else {
		disabledEncryptPageText();
	}
}

function encryptPageText(encryptionKey) {

	$("tr[name='salary']").each(function(index, tr) {
		var total = $(tr).find("span[name='total']").text();
		var basePay = $(tr).find("input[name='basePay']").val();
		var meritPay = $(tr).find("input[name='meritPay']").val();
		total = aesUtils.decryptECB(total, encryptionKey);
		basePay = aesUtils.decryptECB(basePay, encryptionKey);
		meritPay = aesUtils.decryptECB(meritPay, encryptionKey);
		if (!isNull(total)) {
			$(tr).find("span[name='total']").text(total);
		}
		if (!isNull(basePay)) {
			$(tr).find("input[name='basePay']").val(basePay);
		}
		if (!isNull(meritPay)) {
			$(tr).find("input[name='meritPay']").val(meritPay);
		}
	})
}
function disabledEncryptPageText() {
	$("#salary").prop("readonly", true);
}

/** *********** 加解密操作 End ************* */

function cancel() {
	$("#form").find("input").attr('readonly', true);
	$("#form").find("textarea").attr('readonly', true);
	$("#form").find("textarea[id='dept']").attr('readonly', false);
	$("#form").find("textarea[id='position']").attr('readonly', false);
	$("#form").find("select").attr('disabled', true);
	$("#form1").find("input").attr('readonly', true);
	$("#form1").find("input[type='checkbox']").attr('disabled', true);
	$("#save_btn").prop("readonly", true);
	$("#reload_btn").prop("readonly", true);
	$("#form1").find("button[name='depeSelect']").hide();
	$("#del_btn").hide();
	$("#re_btn").hide();
	$("#deptselect").hide();
	$("#stionselect").hide();
}

// 编辑
function edit() {
	$("#form").find("input").removeAttr('readonly');
	$("#form1").find("input[name='account']").removeAttr('readonly');
	$("#form").find("textarea").removeAttr('readonly');
	$("#form").find("select").removeAttr('disabled');
	initDatetimepicker();
	$("#save_btn").prop("readonly", false);
	$("#reload_btn").prop("readonly", false);
	$("#recordImg").attr("onclick", "select()");
	$("#form").find("textarea[name='dept']").attr('onclick', 'showModel()');
	$("#form").find("span").show();
	initTd();
	$("#form")
			.find(
					"input[name='number'],input[name='beginDate'],input[name='entryTime'],input[name='endDate'],input[name='changeDate'],input[name='signDate'],input[name='birthday'],input[name='postDate'],input[name='leaveTime'],input[name='school'],input[name='position'],input[name='projectTeam'],input[name='dept'],input[name='company'],input[name='major'],input[name='sexName'],input[name='education']")
			.prop("readonly", true);

	$("#householdAddress").prop("readonly", false);
	$("#form").find("select[name='entrystatus']").prop("readonly", false);
	$("#backBtn").show();
	$("#save_btn").show();
	$("#print_btn").hide();
	$("#export_btn").hide();
	$("#backNoSaveBtn").hide();
	$("#edit_btn").hide();
	$("tbody").find("tr[name='honor']").each(function(index, tr) {
		$(tr).find("input[name='BuSelect']").css('display', 'inline-block');
	})
	$("input[name='scanName']").attr("onclick", "selectScan(this)")
	$("tbody")
			.find(
					"tr[name='honor'],tr[name='education'],tr[name='oldwork'],tr[name='sign'],tr[name='station'],tr[name='salary']")
			.each(function(index, tr) {
				$(tr).mousedown(function(e) {
					if (3 == e.which) {
						rightClick();
					}
				})
			})
			$("#form1").find("input[type='checkbox']").attr('disabled', false);
			$("#form1").find("button[name='depeSelect']").show();
			$("#del_btn").show();
			$("#re_btn").show();
			$("#deptselect").show();
			$("#stionselect").show();
}

function savedata() {
	getSameData();
	var formData = getFormData();
	var sysUserDate = getFormData1();// 获取用户表单的数据
	var roleidList = new Array();
	$("input[name='roleidList[]']").each(function() {
		if ($(this).prop("checked")) {
			roleidList.push($(this).val());
		}
	})
	var positionId = $("input[name='positionId']").val();
	sysUserDate['roleidList'] = roleidList;
	sysUserDate['positionId'] = positionId;
	formData['sysUser'] = sysUserDate;
	if ($("#forever").prop("checked") == true) {
		formData["unlimited"] = '1';
	} else {
		formData["unlimited"] = '0';
	}
	var chkMsg = checkForm(formData);
	if (!isNull(chkMsg)) {
		bootstrapAlert("提示", chkMsg.join("<br/>"), 400, null);
		return;
	} else if ($("#form").valid()) {
		$.ajax({
			url : web_ctx + "/manage/ad/record/savedata",
			type : "POST",
			contentType : "application/json",
			dataType : "json",
			data : JSON.stringify(formData),
			success : function(data) {
				if (data.code == 1) {
					bootstrapAlert("提示", "保存成功！", 400, function() {
						window.location.href = "toList";
					});
				} else if (data.code == 2) {
					bootstrapAlert("提示", "薪酬更改操作，请先倒入密钥！", 400, null);
				} else if (data.code == 3) {
					bootstrapAlert("提示", "密钥错误，请倒入正确密钥！", 400, null);
				} else {
					bootstrapAlert("提示", "保存失败！", 400, null);
				}
			},
			error : function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}

function upload() {
	if (fileData != null) { // 档案图片不为空。上传图片
		fileData.submit();
	} else {
		savedata();
	}
}

function findLastData() {
	var leng = $("#tbStation tr").length;
	var indexTr;
	var resultTime = $("#tbStation tr").eq(leng - 1).find(
			"input[name='postDate']").val();
	for (var i = leng - 1; i >= 0; i--) {
		var tr = $("#tbStation tr").eq(i)
		var result = $(tr).find("select[name='appoint'] option:selected")
				.text()
		var dateFlag = $(tr).find("input[name='postDate']").val()
		if (result != "兼任" && resultTime <= dateFlag) {
			indexTr = tr;
			resultTime = dateFlag;
		}
	}
	return indexTr;
}
function findSignLastData() {
	var leng = $("#tbSign tr").length;
	var indexTr;
	var resultTime = $("#tbSign tr").eq(leng - 1).find(
			"input[name='beginDate']").val();
	for (var i = leng - 1; i >= 0; i--) {
		var tr = $("#tbSign tr").eq(i)
		var dateFlag = $(tr).find("input[name='beginDate']").val()
		if (resultTime <= dateFlag) {
			indexTr = tr;
			resultTime = dateFlag;
		}
	}
	return indexTr;
}

function findEduLastData() {
	var leng = $("#tbEducation tr").length;
	var indexTr;
	var result = $("#tbEducation tr").eq(leng - 1).find(
			"select[name='educationEducation']").val();
	for (var i = leng - 1; i >= 0; i--) {
		var tr = $("#tbEducation tr").eq(i)
		var Flag = $(tr).find("select[name='educationEducation']").val()
		if (result >= Flag) {
			indexTr = tr;
			result = Flag;
		}
	}
	return indexTr;
}

function getSameData() {
	var tr = findLastData();
	if ($(tr).find("input[name='postDate']").val() != "") {
		if ($(tr).find("select[name='postAppointmentDept'] option:selected")
				.text() != "") {
			$("#table1")
					.find("input[name='dept']")
					.val(
							$(tr)
									.find(
											"select[name='postAppointmentDept'] option:selected")
									.text());
			/*$("#deptId")
					.val(
							$(tr)
									.find(
											"select[name='postAppointmentDept'] option:selected")
									.val());
			$("#deptName")
					.text(
							$(tr)
									.find(
											"select[name='postAppointmentDept'] option:selected")
									.text());*/
		}
		if ($(tr).find("select[name='postAppointmentCompany'] option:selected")
				.text() != "") {
			$("#table1")
					.find("input[name='company']")
					.val(
							$(tr)
									.find(
											"select[name='postAppointmentCompany'] option:selected")
									.text());
		}
		if ($(tr).find(
				"select[name='postAppointmentProjectTeam'] option:selected")
				.text() != "") {
			$("#table1")
					.find("input[name='projectTeam']")
					.val(
							$(tr)
									.find(
											"select[name='postAppointmentProjectTeam'] option:selected")
									.text());
		}
		if ($(tr).find("select[name='station'] option:selected").text() != "") {
			$("#table1")
					.find("input[name='position']")
					.val(
							$(tr)
									.find(
											"select[name='station'] option:selected")
									.text());
			/*$("#positionId").val(
					$(tr).find("select[name='station'] option:selected").val());
			$("#positionName")
					.text(
							$(tr)
									.find(
											"select[name='station'] option:selected")
									.text());*/
		}
	}
	var tr1 = findEduLastData();

	if ($(tr1).find("input[name='educationMajor']").val() != "") {
		$("#table1").find("input[name='major']").val(
				$(tr1).find("input[name='educationMajor']").val());
	}
	if ($(tr1).find("input[name='educationSchool']").val() != "") {
		$("#table1").find("input[name='school']").val(
				$(tr1).find("input[name='educationSchool']").val());
	}

	if ($(tr1).find("select[name='educationEducation'] option:selected").text() != "") {
		$("#table1")
				.find("input[name='education']")
				.val(
						$(tr1)
								.find(
										"select[name='educationEducation'] option:selected")
								.text());
	}
	var tr2 = findSignLastData();
	if ($(tr2).find("input[name='beginDate']").val() != "") {
		$("#table1").find("input[name='entryTime']").val(
				$(tr2).find("input[name='beginDate']").val());
	}
}

function select() {
	var ie = navigator.appName == "Microsoft Internet Explorer" ? true : false;
	if (ie) {
		document.getElementById("file").click();
	} else {
		var a = document.createEvent("MouseEvents");
		a.initEvent("click", true, true);
		document.getElementById("file").dispatchEvent(a);
	}
}

// 档案图片上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path" : "recordImg/" + date.getFullYear() + (date.getMonth() + 1)
				+ date.getDate()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload(
			{
				url : web_ctx + '/fileUpload?' + urlParam,
				dataType : 'json',
				formData : params,
				acceptFileTypes : /(gif|jpe?g|png)$/i,
				fileTypes : /(gif|jpe?g|png)$/i,
				maxFileSize : 50000000, // 50 MB
				/*
				 * add: function (e, data) { fileData = data;
				 * $("#imgName").text(data.files[0].name); },
				 */
				done : function(e, data) {
					var result = data.result;
					if (result.execResult.code != 0) {
						params["deleteFile"] = result.path;
						urlParam = urlEncode(params);
						$("#file").fileupload("option", "url",
								(web_ctx + '/fileUpload?' + urlParam));
						$("#file").fileupload("option", "formData", urlParam);
						$("#imgName").text(result.originName);
						$("#photo").val(result.path);
						$("#photPath").val(result.path);
						$("#recordImg").attr("src", web_ctx + result.path);
						// savedata();
					} else {
						bootstrapAlert("提示", "保存文件失败，错误信息："
								+ result.execResult.result, 400, null);
					}
				}
			});
}

// 制定添表单验证规则
function makeValidRule() {
	$("#form").validate({
		rules : {
			entryTime : {
				required : true
			},
			workBeginDate : {
				required : true
			},
		},
		messages : {
			entryTime : {
				required : "入职时间不能为空"
			},
			workBeginDate : {
				required : "合同开始时间不能为空"
			},
		},
		invalidHandler : function(event, validator) {
			var json = $("#form").serializeJson();
			var errors = validator.numberOfInvalids();
			if (errors) {
				var html = [];
				var errorList = validator.errorList;
				$(errorList).each(function(index, error) {
					html.push(error.message);
					html.push("<br/>");
				});
				bootstrapAlert("提示", html.join(""), 400, null);
			}
		},
		submitHandler : function(form) {
			$("label.error").hide();
			savedata();
		},
		showErrors : function(errorMap, errorList) {
		}// 覆盖默认error显示
	});
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})|(16[0-9]{9})$/;
var qq = /^\d{6,14}$/;
var idcard = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
var email = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/;
var emergencyPhone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})|(16[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if (!isNull(formData["emergencyPhone"])
			&& !emergencyPhone.test(formData["emergencyPhone"])) {
		text.push("请填写正确的11位紧急联系号码！");
	}
	if (!isNull(formData["qq"]) && !email.test(formData["qq"])) {
		text.push("请填写正确的个人邮箱地址！");
	}
	if (!isNull(formData["email"]) && !email.test(formData["email"])) {
		text.push("请填写正确的邮箱地址！");
	}
	if (!isNull(formData["idcard"]) && !idcard.test(formData["idcard"])) {
		text.push("请填写正确的18位身份证证号！");
	} else {
		// 获取输入身份证号码
		var ic = $("#idcard").val();
		if (!IdCardValidate(ic)) {
			text.push("请填写正确的18位身份证证号！");
		}
	}
	if (!isNull(formData["entryTime"]) && !isNull(formData["leaveTime"])) {
		if (!checkDate(formData["entryTime"], formData["leaveTime"])) {
			text.push("入职日期不能大于离职日期！");
		}
	}

	if (!isNull(formData["phone"]) && !phone.test(formData["phone"])) {
		text.push("请填写正确的11位手机号码！");
	}

	$(formData["arbeitsvertrags"]).each(
			function(index, arbeitsvertrag) {
				if (arbeitsvertrag["barginType"] != "0"
						&& isNull(arbeitsvertrag["endDate"])) {
					text.push("请填写非劳动合同的结束时间！");
				} else if (isNull(arbeitsvertrag["signDate"])
						|| isNull(arbeitsvertrag["company"])
						|| isNull(arbeitsvertrag["beginDate"])
						|| isNull(arbeitsvertrag["endDate"])
						|| isNull(arbeitsvertrag["barginType"])) {
					text.push("请将劳动合同填写完全！");
				} else if (!checkDate(arbeitsvertrag["beginDate"],
						arbeitsvertrag["endDate"])) {
					text.push("劳动合同开始时间不能大于结束时间！");
				}
			});

	$(formData["payAdjustments"]).each(
			function(index, payAdjustment) {
				if (isNull(payAdjustment["changeDate"])
						|| isNull(payAdjustment["basePay"])
						|| isNull(payAdjustment["meritPay"])
						|| isNull(payAdjustment["total"])) {
					text.push("请将薪酬调整记录填写完全！");
				}

			});

	$(formData["postAppointments"]).each(
			function(index, postAppointment) {
				if (isNull(postAppointment["postDate"])
						|| isNull(postAppointment["company"])
						|| isNull(postAppointment["dept"])
						|| isNull(postAppointment["station"])
						|| isNull(postAppointment["appoint"])) {
					text.push("请将岗位任免填写完全！");
				}

			});

	$(formData["jobRecords"]).each(
			function(index, jobRecord) {
				if (isNull(jobRecord["beginDate"])
						|| isNull(jobRecord["endDate"])
						|| isNull(jobRecord["company"])
						|| isNull(jobRecord["station"])) {
					text.push("请将以往工作记录填写完全！");
				} else if (!checkDate(jobRecord["beginDate"],
						jobRecord["endDate"])) {
					text.push("以往工作记录开始时间不能大于结束时间！");
				}

			});

	$(formData["educations"]).each(
			function(index, education) {
				if (isNull(education["beginDate"])
						|| isNull(education["endDate"])
						|| isNull(education["school"])
						|| isNull(education["department"])
						|| isNull(education["major"])
						|| isNull(education["education"])) {
					text.push("请将教育背景填写完全！");
				} else if (!checkDate(education["beginDate"],
						education["endDate"])) {
					text.push("教育背景开始时间不能大于结束时间！");
				}

			});

	$(formData["certificates"]).each(
			function(index, certificate) {
				if (isNull(certificate["date"])
						|| isNull(certificate["issuingUnit"])
						|| isNull(certificate["scannings"])
						|| isNull(certificate["scanningName"])) {
					text.push("请将荣誉证书填写完全！");
				}
			});

	return text;
}

function checkDate(beginDate, endDate) {
	var flag = true;
	if (beginDate > endDate) {
		flag = false;
	}
	return flag;
}

$("#dept")
		.parent("td")
		.hover(
				function(e) {
					$
							.ajax({
								url : web_ctx
										+ "/manage/ad/record/showDeptHistory",
								type : "POST",
								dataType : "json",
								data : {
									"userId" : $("#userId").val()
								},
								success : function(data) {
									if (data.code == 1) {
										var html = [];
										html
												.push('<tr><th colspan="10" style="text-align:left;font-size: 14px;padding: 4px;background-color:#FFF;">历史部门记录</th></tr>');
										html
												.push("<tr style='font-size: 12px;padding: 4px;'>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD'>任命时间</td>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD'>撤销时间</td>");
										html
												.push("<td style='width:40%;padding: 4px;background-color:#DDDDDD'>部门</td>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD'>备注</td>");
										html.push("</tr>");

										var depts = data.result;
										for (var i = 0; i < depts.length; i++) {
											var remark = isNull(depts[i].remark) ? " "
													: depts[i].remark;
											var endTime = isNull(depts[i].endTime) ? "  "
													: new Date(depts[i].endTime)
															.pattern("yyyy-MM-dd");
											html
													.push("<tr style='font-size: 12px;padding: 4px;background-color:#FFF;'>");
											html
													.push("<td style='padding: 4px;background-color:#FFF;'>"
															+ new Date(
																	depts[i].startTime)
																	.pattern("yyyy-MM-dd")
															+ "</td>");
											html
													.push("<td style='padding: 4px;background-color:#FFF;'>"
															+ endTime + "</td>");
											html
													.push("<td style='padding: 4px;background-color:#FFF;'>"
															+ depts[i].dept
															+ "</td>");
											html
													.push("<td style='text-align:left;height:auto;white-space:pre-line;width:auto;word-break:break-all;padding: 4px;background-color:#FFF;'>"
															+ remark + "</td>");
											html.push("</tr>");
										}
										$("#dept-box-body").html(html);
										$("#dept-div").css({
											"position" : "absolute",
											"left" : e.clientX + "px",
											"top" : e.clientY + "px",
											opacity : "show"
										});
										$("#dept-div").show();
									}
								},
								error : function(data) {
									bootstrapAlert("提示", "网络错误，请稍后重试！", 400,
											null);
								}
							});
				}, function() {
					$("#dept-div").css({
						left : 0,
						top : 0,
						opacity : "hide"
					});
					$("#dept-div").hide();
				});

function getLeft(e) {
	var offset = e.offsetLeft;
	if (e.offsetParent != null) {
		offset += getLeft(e.offsetParent);
	}
}

$("#position")
		.parent("td")
		.hover(
				function(e) {
					$
							.ajax({
								url : web_ctx
										+ "/manage/ad/record/showPositionHistory",
								type : "POST",
								dataType : "json",
								data : {
									"userId" : $("#userId").val()
								},
								success : function(data) {
									if (data.code == 1) {
										var html = [];
										html
												.push('<tr><th colspan="10" style="text-align:left;font-size: 14px;padding: 4px;background-color:#FFF;">历史岗位记录</th></tr>');
										html
												.push("<tr  style='font-size: 12px;padding: 4px;'>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD;'>任命时间</td>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD;'>撤销时间</td>");
										html
												.push("<td style='width:40%;padding: 4px;background-color:#DDDDDD;'>岗位</td>");
										html
												.push("<td style='width:20%;padding: 4px;background-color:#DDDDDD;'>备注</td>");
										html.push("</tr>");

										var positions = data.result;
										for (var i = 0; i < positions.length; i++) {
											var remark = isNull(positions[i].remark) ? " "
													: positions[i].remark;
											var endTime = isNull(positions[i].endTime) ? "  "
													: new Date(
															positions[i].endTime)
															.pattern("yyyy-MM-dd");
											html.push("<tr>");
											html
													.push("<td style='padding: 4px;background-color:#FFF;'>"
															+ new Date(
																	positions[i].startTime)
																	.pattern("yyyy-MM-dd")
															+ "</td>");
											html
													.push("<td style='padding: 4px;background-color:#FFF;'>"
															+ endTime + "</td>");
											html
													.push("<td style='padding: 4px;text-align:left;background-color:#FFF;'>"
															+ positions[i].position
															+ "</td>");
											html
													.push("<td style='text-align:left;height:auto;white-space:pre-line;width:auto;word-break:break-all;padding: 4px;background-color:#FFF;'>"
															+ remark + "</td>");
											html.push("</tr>");
										}
										$("#position-box-body").html(html);
										$("#position-div").css({
											"position" : "absolute",
											"left" : e.clientX,
											"top" : e.clientY,
											opacity : "show"
										});
										$("#position-div").show();
									}
								},
								error : function(data) {
									bootstrapAlert("提示", "网络错误，请稍后重试！", 400,
											null);
								}
							});
				}, function() {
					$("#position-div").css({
						left : 0,
						top : 0,
						opacity : "hide"
					});
					$("#position-div").hide();
				});

function addDeptHistory() {
	var userId = $("#userId").val();
	window.location.href = web_ctx + "/manage/ad/record/addDeptHistory?userId="
			+ userId;
}

function addPositionHistory() {
	var userId = $("#userId").val();
	window.location.href = web_ctx
			+ "/manage/ad/record/addPositionHistory?userId=" + userId;
}

function addSalaryHistory() {
	var userId = $("#userId").val();
	window.location.href = web_ctx
			+ "/manage/ad/record/addSalaryHistory?userId=" + userId;
}

function initChecked() {
	var unlimited = $("#unlimited").val();
	if (!isNull(unlimited) && unlimited == '1') {
		$("#forever").prop("checked", true);
	}
}

function initInputMask() {
	$("#phone").inputmask({
		"mask" : "9{11}"
	});
	$("#emergencyPhone").inputmask({
		"mask" : "9{11}"
	});
	$("#idcard").inputmask({
		"mask" : "*{18}",
		"placeholder" : ""
	});
	// $("input[name='basePay'],input[name='meritPay']").inputmask("Regex", {
	// regex: "\\d+\\.?\\d{0,2}" });
	$("input[name='agePay'],input[name='lunchSubsidy']").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0,2}"
	});
	$("input[name='computerSubsidy'],input[name='accumulationFund']")
			.inputmask("Regex", {
				regex : "\\d+\\.?\\d{0,2}"
			});
}

function initDatetimepicker() {
	$("input.datetimepicker").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		toDay : true,
		pickDate : true,
		pickTime : false,
		bootcssVer : 3,
		autoclose : true
	});

	$(".changeDate,.postDate,.signDate,.beginDate,.endDate,.date")
			.datetimepicker({
				minView : "month",
				language : "zh-CN",
				format : "yyyy-mm-dd",
				toDay : true,
				pickDate : true,
				pickTime : false,
				bootcssVer : 3,
				autoclose : true
			})
			
	$(".validity").datetimepicker({
        minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
        clearBtn: true,
        forceParse:true //强制解析
	}).on('changeDate',function(ev){
		var dd=$(this).find("select[name='isValidity']").val("1");
	})

	$(".become_date,.leaveTime,.birthday").datetimepicker({
		language : "zh-CN",
		format : 'yyyy-mm-dd',
		showMeridian : true,
		autoclose : true,
		todayBtn : true,
		bootcssVer : 3,
		minView : 2
	});

	$(".leaveTime").datetimepicker({
		language : "zh-CN",
		format : 'yyyy-mm-dd',
		showMeridian : true,
		bootcssVer : 3,
		autoclose : true,
		minView : 2
	}).on('changeDate', function(e) {
		var leaveTime = e.date;
		/* $(".entryTime").datetimepicker('setEndDate',leaveTime); */
	});

	$(".work_begin_date").datetimepicker({
		language : "zh-CN",
		format : 'yyyy-mm-dd',
		showMeridian : true,
		bootcssVer : 3,
		autoclose : true,
		minView : 2
	}).on('changeDate', function(e) {
		var work_begin_date = e.date;
		$(".work_end_date").datetimepicker('setStartDate', work_begin_date);
	});

	$(".work_end_date").datetimepicker({
		language : "zh-CN",
		format : 'yyyy-mm-dd',
		showMeridian : true,
		bootcssVer : 3,
		autoclose : true,
		minView : 2
	}).on('changeDate', function(e) {
		var work_end_date = e.date;
		$(".work_start_date").datetimepicker('setEndDate', work_end_date);
	});
}

// 编辑页面的返回
function goBack() {
	bootstrapConfirm("提示", "是否需要保存？", 400, function() {
		upload();
	}, function() {
		window.history.back(-1);
	})
}
/*--------- 部门树 ------------*/

$(document).ready(function() {
	$.fn.zTree.init($("#deptTree"), setting);
});

// 获取部门信息
var setting = {
	view : {
		selectedMulti : false
	},
	check : {
		enable : true,
		chkboxType : {
			"Y" : "s",
			"N" : "s"
		}
	},
	data : {
		simpleData : {
			enable : true,
			idKey : "id",
			pIdKey : "parentId",
			rootPId : -1
		}
	},
	async : {
		type : "get",
		enable : true,
		url : web_ctx + "/manage/sys/dept/getDeptListOnJson"
	},
	callback : {
		onAsyncSuccess : expandAll
	}
};

// 展开树
function expandAll() {
	var treeObj = $.fn.zTree.getZTreeObj("deptTree");
	treeObj.expandAll(true);
	initCheckedClick();
}

function showModel() {
	var dept = $("#dept").val();
	initTreeChecked(dept);
	$("#deptModal").modal("show");
}

// 设置部门树选中状态
function initTreeChecked(dept) {
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	zTree.checkAllNodes(false);
	if (dept != null && dept.length > 0) {
		var depts = dept.split(",");
		$(depts).each(function(index, deptName) {
			var node = zTree.getNodeByParam("name", deptName);
			if (!isNull(node)) {
				zTree.checkNode(node, true, false);
				zTree.updateNode(node);
			}
		});
	}
}

// 设置点击节点名设置复选框的选中状态
function initCheckedClick() {
	$("a[treenode_a]").click(function() {
		$(this).prev("span[treenode_check]").trigger("click");
	});
}

/*// 保存所选择的部门
function setDept() {
	var deptNames = getDept();
	$("#dept").text(deptNames.join(","));
}

// 获取选择的部门
function getDept() {
	var resultId = [];
	var resultName = [];
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	var nodes = zTree.getChangeCheckedNodes(true);

	if (nodes.length == 1) {
		resultId.push(nodes[0].id);
		var topParent = nodes[0].getParentNode().getParentNode();
		if (isNull(topParent) || topParent.parentId == '-1') {
			var parent = nodes[0].getParentNode();
			if (isNull(parent) || parent.parentId == '-1') {
				resultName.push($.trim(nodes[0].name + "\r"));
			} else {
				resultName.push($.trim(nodes[0].getParentNode().name)
						+ nodes[0].name + "\r");
			}

		} else if (topParent.parentId != '-1') {
			resultName.push($.trim(topParent.name)
					+ $.trim(nodes[0].getParentNode().name) + nodes[0].name
					+ "\r");
		}

	} else {
		$.each(nodes, function(index, node) {
			var d = node.getParentNode();
			if (node.getParentNode().parentId == '-1') {
				// 如果上级部门是组织机构且有子目录就不显示当前阶段部门
				if (typeof node.children == "undefined"
						|| node.children == null || node.children.length == 0) {
					resultId.push(node.id);
					resultName.push($.trim(node.name) + "\r");
				}
			} else if (typeof node.children == "undefined"
					|| node.children == null || node.children.length == 0) {
				// 如果有下级部门，当前部门不显示，只显示子部门
				resultId.push(node.id);
				var topParent = node.getParentNode().getParentNode();
				if (isNull(topParent) || topParent.parentId == '-1') {
					var parent = node.getParentNode();
					if (isNull(parent) || parent.parentId == '-1') {
						resultName.push($.trim(node[0].name + "\r"));
					} else {
						resultName.push($.trim(node.getParentNode().name)
								+ node.name + "\r");
					}

				} else if (topParent.parentId != '-1') {
					resultName.push($.trim(topParent.name)
							+ $.trim(node.getParentNode().name) + node.name
							+ "\r");
				}

			}
		});
	}

	return resultName;
}
*/
function initTrEvent() {
	$("#treetable tbody tr").click(function() {
		$(this).css("background-color", "#b4b4b4");
		var obj = this;
		$("#treetable tbody tr").each(function(index, tr) {
			if (tr != obj) {
				$(this).css("background-color", "inherit");
			}
		});
	});
}

// 动态添加节点处理函数
function node(oper, type, obj) {
	if (oper == "del") {
		var tr = $(obj).parents("tr:first").remove();
		initSubTotal();
	} else {
		var fun = type2html[type];
		var html = fun.call();
		$(obj).parents("tr:first").after(html);
		setNode($(obj).parents("tr:last"));
	}
}

// 初始化某node行的输入框
function setNode(tr) {
	$(tr).find(".datetimepicker").datetimepicker({
		minView : "month",
		language : "zh-CN",
		format : "yyyy-mm-dd",
		bootcssVer : 3,
		toDay : true,
		pickDate : true,
		pickTime : false,
		autoclose : true,
	});
	$(tr).find(
			"input[name='basePay'],input[name='meritPay'],"
					+ "input[name='agePay'],input[name='lunchSubsidy'],"
					+ "input[name='computerSubsidy'],"
					+ "input[name='accumulationFund']").bind("keyup",
			function() {
				updateTotal(); // 更新总计数据
			});
	$(tr).find("input[name='beginDate']").change(function() {
		initdate(this);
	});
	inittextarea();
	initInputMask();
	initDatetimepicker();
}

// 初始化输入框按键弹起事件
function initInputKeyUp() {
	$(
			"input[name='basePay'],input[name='meritPay'],"
					+ "input[name='agePay'],input[name='lunchSubsidy'],"
					+ "input[name='computerSubsidy'],"
					+ "input[name='accumulationFund']").bind("keyup",
			function() {
				updateTotal(); // 更新总计数据
			});
	$("input[name='beginDate']").change(function() {
		initdate(this);
	});
}

function initdate(obj) {
	var temp = $(obj).val();
	var tr = $(obj).parent("td").parent("tr");
	var date = $(tr).find("input[name='date']");
	if (!isNull(temp)) {
		date.val(temp);
	}
}

// 更新总计
function updateTotal() {
	$("tr[name='salary']").each(function(index, tr) {
		var sum = 0.0;
		for (var i = 1; i < 7; i++) {
			var money = $(tr).find("td").eq(i).find("input").val();
			sum = digitTool.add(sum, money);
		}
		if (sum != 0) {
			$(tr).find("span[name='total']").text(fmoney(sum, 0));
		}
	});

}

var indexTr = "";
function selectScan(obj) {
	var ie = navigator.appName == "Microsoft Internet Explorer" ? true : false;
	var tr = $(obj).parent().parent();
	indexTr = tr;
	if (ie) {
		$(tr).find("input[name='scanFile']").click();
		// document.getElementById("scanFile").click();
	} else {
		var a = document.createEvent("MouseEvents");
		a.initEvent("click", true, true);

		$(tr).find("input[name='scanFile']").trigger('click');
		initRecordUpload();
		// document.getElementById("scanFile").dispatchEvent(a);
	}
}

// 下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url, '_blank');
	}
}

// 证书扫描件上传
var urlParam1 = "";
function initRecordUpload() {
	var date = new Date();
	var params = {
		"path" : "certificate/" + date.getFullYear() + (date.getMonth() + 1)
				+ date.getDate()
	};

	urlParam1 = urlEncode(params);

	$(indexTr).find("input[name='scanFile']").fileupload(
			{
				url : web_ctx + '/fileUpload?' + urlParam1,
				dataType : 'json',
				formData : params,
				maxFileSize : 50 * 1024 * 1024, // 50 MB
				messages : {
					maxFileSize : '附件大小最大为50M！'
				},
				done : function(e, data) {
					var result = data.result;
					if (result.execResult.code != 0) {
						// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
						/*
						 * params["deleteFile"] = result.path; urlParam1 =
						 * urlEncode(params);
						 */
						$(indexTr).find("input[name='scanfile']").fileupload(
								"option", "url",
								(web_ctx + '/fileUpload?' + urlParam1));
						$(indexTr).find("input[name='scanfile']").fileupload(
								"option", "formData", urlParam1);
						$(indexTr).find("input[name='scanName']").val(
								result.originName);
						$(indexTr).find("input[name='hiddenPath']").val(
								result.path);
						$(indexTr).find("input[name='hiddenName']").val(
								result.originName);
					} else {
						openBootstrapShade(false);
						bootstrapAlert("提示", "保存文件失败，错误信息："
								+ result.execResult.result, 400, null);
					}
				}
			});
}

// 薪酬调整记录
function getHtmlForSalaryRecord() {
	var html = [];
	html.push('<tr name="salary" class="level1">');
	html
			.push('<input type="hidden" name="payAdjustmentId" value=""> <input type="hidden"  name="flag" value="salaryRecord">');
	html
			.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="changeDate" class="changeDate" readonly></td>');
	html
			.push('	<td style="width: 6%;"><input type="text"  name="basePay"></td>');
	html
			.push('	<td style="width: 6%;"><input type="text"  name="meritPay"></td>');
	html.push('	<td style="width: 6%;"><input type="text" name="agePay"></td>');
	html
			.push('	<td style="width: 6%;"><input type="text" name="lunchSubsidy"></td>');
	html
			.push('	<td style="width: 5%;"><input type="text" style="text-align:right;"   name="computerSubsidy"></td>');
	html
			.push('	<td style="width: 5%;"><input type="text"  style="text-align:right;"  name="accumulationFund"></td>');
	html
			.push('	<td style="width: 5%;"><div style="display:flex"><span  id="total"  name="total"></span> </div></td>');
	html
			.push('	<td style="width: 18%;"><textarea  name="payReason"></textarea></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'salaryRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'salaryRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 岗位调整记录
function getHtmlForStationRecord() {
	var html = [];
	html.push('<tr name="station" class="level1">');
	html
			.push('<input type="hidden" name="postAppointmentId" value=""><input type="hidden"  name="flag" value="stationRecord">');
	html
			.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="postDate" class="postDate" readonly></td>');
	html
			.push('	<td style="width: 12%;"><select name="postAppointmentCompany" style="width:100%;test-align-last:center"> <option value=""></option>'
					+ $("#company_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="postAppointmentDept"> <option value=""></option>'
					+ $("#dept_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="postAppointmentProjectTeam"> <option value=""></option>'
					+ $("#projectTeam_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="station"> <option value=""></option>'
					+ $("#station_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="appoint"> <option value=""></option>'
					+ $("#appoint_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 18%;"><textarea  name="postReason"></textarea></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'stationRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'stationRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 劳动合同签约记录
function getHtmlForSignRecord() {
	var html = [];
	html.push('<tr name="sign" class="level1">');
	html
			.push('<input type="hidden" name="arbeitsvertragId" value=""> <input type="hidden"  name="flag" value="signRecord">');
	html
			.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="signDate" class="signDate" readonly></td>');
	html
			.push('	<td style="width: 12%;"><select name="arbeitsvertragCompany" style="width:100%;test-align-last:center"> <option value=""></option>'
					+ $("#company_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 12%;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
	html
			.push('	<td style="width: 10%;"><input type="text" name="endDate" class="endDate" readonly></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="barginType"> <option value=""></option>'
					+ $("#barginType_hidden").html() + '</select></td>');
	html
			.push('	<td style="width: 18%;"><textarea  name="signReason"></textarea></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'signRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'signRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 以往工作记录
function getHtmlForOldworkRecord() {
	var html = [];
	html.push('<tr name="oldwork" class="level1">');
	html
			.push('<input type="hidden" name="jobRecordId" value=""><input type="hidden"  name="flag" value="oldworkRecord">');
	html
			.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
	html
			.push('	<td style="width: 6.8%;"><input type="text" name="endDate" class="endDate" readonly></td>');
	html
			.push('	<td style="width: 27.2%;"><input type="text" name="jobRecordCompany"></td>');
	html
			.push('	<td style="width: 5%;"><input type="text" name="station"></td>');
	html
			.push('	<td style="width: 18%;"><textarea  name="duty"></textarea></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'oldworkRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'oldworkRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 教育背景
function getHtmlForEducationRecord() {
	var html = [];
	html.push('<tr name="education" class="level1">');
	html
			.push('<input type="hidden" name="educationId" value=""><input type="hidden"  name="flag" value="educationRecord">');
	html
			.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
	html
			.push('	<td style="width: 6.8%;"><input type="text" name="endDate" class="endDate" readonly></td>');
	html
			.push('	<td style="width: 12.2%;"><input type="text" name="educationSchool"></td>');
	html
			.push('	<td style="width: 20%;"><input type="text" name="department"></td>');
	html
			.push('	<td style="width: 9%;"><input type="text" name="educationMajor"></td>');
	html
			.push('	<td style="width: 3%;"><select style="width:100%;" name="educationEducation"> <option value=""></option>'
					+ $("#education_hidden").html() + '</select></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'educationRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'educationRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 荣誉/证书
function getHtmlForHonorRecord() {
	var html = [];
	html.push('<tr name="honor" class="clHonor level1">');
	html
			.push('<input type="hidden" name="certificateId" value=""><input type="hidden"  name="flag" value="honorRecord">');
	html.push('<input type="hidden"  name="hiddenPath" value="">');
	html.push('<input type="hidden"  name="hiddenName" value="">');
	html
			.push('	<td style="width: 8%;"><input type="text"  class="date" name="date" readonly></td>');
	html
			.push('	<td style="width: 10%;"><input type="text" name="issuingUnit"></td>');
	html.push('	<td style="width: 10%;"><input type="text" name="honor"></td>');
	html
			.push('	<td style="width: 9%;"><input type="text"  class="validity" name="validity" readonly></td>');
	html
			.push('	<td style="width: 9%;"><select  name="isValidity" onchange="selectOnchang(this)" style="width:98%;"><option value=""></option><option value="0">长期</option><option value="1">否</option></select></td>');
	html
			.push('	<td style="width: 20%;"> <input type="text"  name="scanName"  value="" readonly onclick="selectScan(this)" placeholder="选择扫描件"> <input type="file"  name="scanFile" style="display:none;"></td>');
	// html.push(' <td style="width: 4%;border-right-style:hidden;"><span
	// style="margin-left: 20%"><a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'add\', \'educationRecord\',
	// this)"><img alt="添加" src="'+base+'/static/images/add.png"
	// style="margin-right: 6px"></a> <a href="javascript:void(0);"
	// style="font-size:x-large;" onclick="node(\'del\', \'educationRecord\',
	// this)"><img alt="删除" src="'+base+'/static/images/del.png"
	// ></a></span></td>');
	html.push('</tr>');

	return html.join("");
}

// 身份证校验

function idCardCheck() {
	// 获取输入身份证号码
	var ic = $("#idcard").val();
	if (IdCardValidate(ic)) {
		var ic = String(ic);
		// 获取出生日期
		var birth = ic.substring(6, 10) + "-" + ic.substring(10, 12) + "-"
				+ ic.substring(12, 14);
		if ($("#birthday").val() == "") {
			$("#birthday").val(birth);
		}
		// 获取性别
		var gender = ic.slice(14, 17) % 2 ? "1" : "2"; // 1代表男性，2代表女性
		$("#sex").empty();
		if (gender == 1) {
			// var custom=$("<option>").val(0).text("男");
			$("#sex").val(0);
			$("#sexName").val("男");

		} else {
			// var custom=$("<option>").val(1).text("女");
			$("#sex").val(1);
			$("#sexName").val("女");
		}
	}
	// var sexOption = document.getElementsByName("rabSex");
	// for (var i = 0; i < sexOption.length; i++) {
	// if (sexOption[i].value == gender) {
	// sexOption[i].checked = true;
	// break;
	// }
	// }
	// //获取年龄
	// var myDate = new Date();
	// var month = myDate.getMonth() + 1;
	// var day = myDate.getDate();
	// var age = myDate.getFullYear() - ic.substring(6, 10) - 1;
	// if (ic.substring(10, 12) < month || ic.substring(10, 12) == month &&
	// ic.substring(12, 14) <= day) {
	// age++;
	// }
	// $("#txtAge").val(age);
}

var Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 ]; // 加权因子
var ValideCode = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ]; // 身份证验证位值.10代表X
function IdCardValidate(idCard) {
	idCard = trim(idCard.replace(/ /g, "")); // 去掉字符串头尾空格
	if (idCard.length == 15) {
		return isValidityBrithBy15IdCard(idCard); // 进行15位身份证的验证
	} else if (idCard.length == 18) {
		var a_idCard = idCard.split(""); // 得到身份证数组
		if (isValidityBrithBy18IdCard(idCard)
				&& isTrueValidateCodeBy18IdCard(a_idCard)) { // 进行18位身份证的基本验证和第18位的验证
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}
/**
 * 判断身份证号码为18位时最后的验证位是否正确
 * 
 * @param a_idCard
 *            身份证号码数组
 * @return
 */
function isTrueValidateCodeBy18IdCard(a_idCard) {
	var sum = 0; // 声明加权求和变量
	if (a_idCard[17].toLowerCase() == 'x') {
		a_idCard[17] = 10; // 将最后位为x的验证码替换为10方便后续操作
	}
	for (var i = 0; i < 17; i++) {
		sum += Wi[i] * a_idCard[i]; // 加权求和
	}
	valCodePosition = sum % 11; // 得到验证码所位置
	if (a_idCard[17] == ValideCode[valCodePosition]) {
		return true;
	} else {
		return false;
	}
}
/**
 * 验证18位数身份证号码中的生日是否是有效生日
 * 
 * @param idCard
 *            18位书身份证字符串
 * @return
 */
function isValidityBrithBy18IdCard(idCard18) {
	var year = idCard18.substring(6, 10);
	var month = idCard18.substring(10, 12);
	var day = idCard18.substring(12, 14);
	var temp_date = new Date(year, parseFloat(month) - 1, parseFloat(day));
	// 这里用getFullYear()获取年份，避免千年虫问题
	if (temp_date.getFullYear() != parseFloat(year)
			|| temp_date.getMonth() != parseFloat(month) - 1
			|| temp_date.getDate() != parseFloat(day)) {
		return false;
	} else {
		return true;
	}
}
/**
 * 验证15位数身份证号码中的生日是否是有效生日
 * 
 * @param idCard15
 *            15位书身份证字符串
 * @return
 */
function isValidityBrithBy15IdCard(idCard15) {
	var year = idCard15.substring(6, 8);
	var month = idCard15.substring(8, 10);
	var day = idCard15.substring(10, 12);
	var temp_date = new Date(year, parseFloat(month) - 1, parseFloat(day));
	// 对于老身份证中的你年龄则不需考虑千年虫问题而使用getYear()方法
	if (temp_date.getYear() != parseFloat(year)
			|| temp_date.getMonth() != parseFloat(month) - 1
			|| temp_date.getDate() != parseFloat(day)) {
		return false;
	} else {
		return true;
	}
}
// 去掉字符串头尾空格
function trim(str) {
	return str.replace(/(^\s*)|(\s*$)/g, "");
}

function getFormData() {
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);

	formData["payAdjustments"] = [];
	formData["postAppointments"] = [];
	formData["arbeitsvertrags"] = [];
	formData["jobRecords"] = [];
	formData["educations"] = [];
	formData["certificates"] = [];

	$("tbody")
			.find("tr[name='salary']")
			.each(
					function(index, tr) {
						var id = $(this).find("input[name='payAdjustmentId']")
								.val();
						var recordId = $("#id").val();
						var changeDate = $(this).find(
								"input[name='changeDate']").val();
						var basePay = $(this).find("input[name='basePay']")
								.val();
						var meritPay = $(this).find("input[name='meritPay']")
								.val();
						var agePay = $(this).find("input[name='agePay']").val();
						var lunchSubsidy = $(this).find(
								"input[name='lunchSubsidy']").val();
						var computerSubsidy = $(this).find(
								"input[name='computerSubsidy']").val();
						var accumulationFund = $(this).find(
								"input[name='accumulationFund']").val();
						var payReason = $(this).find(
								"textarea[name='payReason']").val();
						var total = $(this).find("span[name='total']").text();
						if (!isNull(total) || !isNull(changeDate)
								|| !isNull(basePay) || !isNull(meritPay)) {
							var salaryRecord = {};
							salaryRecord["id"] = id;
							salaryRecord["recordId"] = recordId;
							salaryRecord["changeDate"] = changeDate;
							salaryRecord["basePay"] = basePay;
							salaryRecord["meritPay"] = meritPay;
							salaryRecord["agePay"] = agePay;
							salaryRecord["lunchSubsidy"] = lunchSubsidy;
							salaryRecord["computerSubsidy"] = computerSubsidy;
							salaryRecord["accumulationFund"] = accumulationFund;
							salaryRecord["payReason"] = payReason;
							salaryRecord["total"] = total;
							formData["payAdjustments"].push(salaryRecord);

						}
					});

	$("tbody").find("tr[name='station']").each(
			function(index, tr) {
				var id = $(this).find("input[name='postAppointmentId']").val();
				var recordId = $("#id").val();
				var postDate = $(this).find("input[name='postDate']").val();
				var company = $(this).find(
						"select[name='postAppointmentCompany']").val();
				var dept = $(this).find("select[name='postAppointmentDept']")
						.val();
				var projectTeam = $(this).find(
						"select[name='postAppointmentProjectTeam']").val();
				var station = $(this).find("select[name='station']").val();
				var appoint = $(this).find("select[name='appoint']").val();
				var postReason = $(this).find("textarea[name='postReason']")
						.val();

				if (!isNull(postDate) || !isNull(company) || !isNull(dept)
						|| !isNull(projectTeam) || !isNull(station)
						|| !isNull(appoint)) {
					var stationRecord = {};
					stationRecord["id"] = id;
					stationRecord["recordId"] = recordId;
					stationRecord["postDate"] = postDate;
					stationRecord["company"] = company;
					stationRecord["dept"] = dept;
					stationRecord["projectTeam"] = projectTeam;
					stationRecord["station"] = station;
					stationRecord["appoint"] = appoint;
					stationRecord["postReason"] = postReason;
					formData["postAppointments"].push(stationRecord);
				}
			})

	$("tbody").find("tr[name='sign']").each(
			function(index, tr) {
				var id = $(this).find("input[name='arbeitsvertragId']").val();
				var recordId = $("#id").val();
				var signDate = $(this).find("input[name='signDate']").val();
				var company = $(this).find(
						"select[name='arbeitsvertragCompany']").val();
				var beginDate = $(this).find("input[name='beginDate']").val();
				var endDate = $(this).find("input[name='endDate']").val();
				var barginType = $(this).find("select[name='barginType']")
						.val();
				var signReason = $(this).find("textarea[name='signReason']")
						.val();

				if (!isNull(signDate) || !isNull(company) || !isNull(beginDate)
						|| !isNull(endDate) || !isNull(barginType)) {
					var signRecord = {};
					signRecord["id"] = id;
					signRecord["recordId"] = recordId;
					signRecord["signDate"] = signDate;
					signRecord["company"] = company;
					signRecord["beginDate"] = beginDate;
					signRecord["endDate"] = endDate;
					signRecord["barginType"] = barginType;
					signRecord["signReason"] = signReason;
					formData["arbeitsvertrags"].push(signRecord);
				}
			});

	$("tbody").find("tr[name='oldwork']").each(
			function(index, tr) {
				var id = $(this).find("input[name='jobRecordId']").val();
				var recordId = $("#id").val();
				var beginDate = $(this).find("input[name='beginDate']").val();
				var endDate = $(this).find("input[name='endDate']").val();
				var company = $(this).find("input[name='jobRecordCompany']")
						.val();
				var station = $(this).find("input[name='station']").val();
				var duty = $(this).find("textarea[name='duty']").val();

				if (!isNull(beginDate) || !isNull(endDate) || !isNull(station)
						|| !isNull(company)) {
					var oldworkRecord = {};
					oldworkRecord["id"] = id;
					oldworkRecord["recordId"] = recordId;
					oldworkRecord["beginDate"] = beginDate;
					oldworkRecord["endDate"] = endDate;
					oldworkRecord["company"] = company;
					oldworkRecord["station"] = station;
					oldworkRecord["duty"] = duty;
					formData["jobRecords"].push(oldworkRecord);
				}
			});

	$("tbody").find("tr[name='education']")
			.each(
					function(index, tr) {
						var id = $(this).find("input[name='educationId']")
								.val();
						var recordId = $("#id").val();
						var beginDate = $(this).find("input[name='beginDate']")
								.val();
						var endDate = $(this).find("input[name='endDate']")
								.val();
						var school = $(this).find(
								"input[name='educationSchool']").val();
						var department = $(this).find(
								"input[name='department']").val();
						var major = $(this)
								.find("input[name='educationMajor']").val();
						var education = $(this).find(
								"select[name='educationEducation']").val();

						if (!isNull(beginDate) || !isNull(endDate)
								|| !isNull(school) || !isNull(department)
								|| !isNull(major) || !isNull(education)) {
							var educationRecord = {};
							educationRecord["id"] = id;
							educationRecord["recordId"] = recordId;
							educationRecord["beginDate"] = beginDate;
							educationRecord["endDate"] = endDate;
							educationRecord["school"] = school;
							educationRecord["department"] = department;
							educationRecord["major"] = major;
							educationRecord["education"] = education;
							formData["educations"].push(educationRecord);
						}
					});

	$("tbody").find("tr[name='honor']")
			.each(
					function(index, tr) {
						var id = $(this).find("input[name='certificateId']")
								.val();
						var recordId = $("#id").val();
						var date = $(this).find("input[name='date']").val();
						var issuingUnit = $(this).find(
								"input[name='issuingUnit']").val();
						var honor = $(this).find("input[name='honor']").val();
						var validity = $(this).find("input[name='validity']")
								.val();
						var isValidity = $(this).find("select[name='isValidity']").val();
						var hiddenPath = $(this).find(
								"input[name='hiddenPath']").val();
						var hiddenName = $(this).find(
								"input[name='hiddenName']").val();
						if (!isNull(date) || !isNull(issuingUnit)
								|| !isNull(hiddenPath) || !isNull(hiddenName)) {
							var honorRecord = {};
							honorRecord["id"] = id;
							honorRecord["recordId"] = recordId;
							honorRecord["date"] = date;
							honorRecord["issuingUnit"] = issuingUnit;
							honorRecord["honor"] = honor;
							honorRecord["validity"] = validity;
							honorRecord["isValidity"] = isValidity;
							honorRecord["scannings"] = hiddenPath;
							honorRecord["scanningName"] = hiddenName;
							formData["certificates"].push(honorRecord);
						}
					});

	return formData;
}

/*******************************************************************************
 * 打印相关
 ******************************************************************************/
function print(id) {
	window.open(web_ctx + "/manage/ad/record/printById?id=" + id);
}

/*******************************************************************************
 * 导出pdf
 ******************************************************************************/
function pdf(id) {
	window.open(web_ctx + "/manage/ad/record/pdf?id=" + id);
}

/*
 * 右键操作----点击编辑之后才有右键操作
 * 
 */

// 动态添加节点处理函数
function addnode(type, obj) {
	var fun = type2html[type];
	var html = fun.call();
	$(obj).after(html);
	hideRMenu(obj);
	initDatetimepicker();
}

function delnode(obj) {
	var tr = $(obj).remove();
	hideRMenu(obj);
}

function rightClick() {
	$.contextMenu({
		selector : '.level0',
		callback : function(key, options) {
			switch (key) {
			case 'addnode':
				addnode($(this).find("input[name='flag']").val(), $(this));
				break;
			}
		},
		items : {
			"addnode" : {
				name : "新增",
				icon : "add"
			},
		}
	});

	$.contextMenu({
		selector : '.level1',
		callback : function(key, options) {
			switch (key) {
			case 'addnode':
				addnode($(this).find("input[name='flag']").val(), $(this));
				break;
			case 'delnode':
				delnode($(this));
				break;
			}
		},
		items : {
			"addnode" : {
				name : "新增",
				icon : "add"
			},
			"delnode" : {
				name : "删除",
				icon : "delete"
			},
		}
	});
}

/* 隐藏右键菜单 */
function hideRMenu(obj) {
	if (rMenu)
		rMenu.css({
			"visibility" : "hidden"
		});
	$(obj).unbind("mousedown", onBodyMouseDown);
}

function onBodyMouseDown(event) {
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0)) {
		rMenu.css({
			"visibility" : "hidden"
		});
	}
}

function initCheckbox() {
	if (user != null) {
		if (user.roleList == null || typeof user.roleList == "undefined"
				|| 1 > user.roleList.length) {
			return;
		}
		$("#deptAndRoles").find("input[type='checkbox']").each(
				function(index, checkbox) {
					$.each(user.roleList, function(index, role) {
						if ($(checkbox).val() == role.id) {
							$(checkbox).prop("checked", true);
						}
					});
				});
		if(!showuserFlag){
			$("#userDiv").hide();
		}
	}
}

function initPosition() {
	if (user !== null) {
		if (user.positionList == null
				|| typeof user.positionList == "undefined"
				|| 1 > user.positionList.length) {
			return;
		}

		var positionName = [];
		var positionId = [];
		$.each(user.positionList, function(index, position) {
			positionName.push(position.name);
			positionId.push(position.id);
		});

		$("#positionName").text(positionName.join(", "));
		$("#positionId").val(positionId.join(","));
	}
}
function setUserName(obj) {
	$("#userName").val($(obj).val());
}

function getFormData1() {

	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData['photo'] = $("#photPath").val();
	formData['id'] = $("#userid").val();
	return formData;
}
var currTd = null;
function openDialog(obj) {
	currTd = obj;
	$("#userByDeptDialog").openUserByDeptDialog();
}

function getData(data) {
	if (data != null) {
		$("#principalName").val(data.name);
		$("#principalId").val(data.id);
	}
}
function getDeptName() {
	var deptName = $("#deptName").val();
	return deptName;
}

function del() {
	bootstrapConfirm("提示", "确定删除？", 400, function() {
		/*upload();*/
		getSameData();
		var formData = getFormData();
		if ($("#forever").prop("checked") == true) {
			formData["unlimited"] = '1';
		} else {
			formData["unlimited"] = '0';
		}
		var chkMsg = checkForm(formData);
		if (!isNull(chkMsg)) {
			bootstrapAlert("提示", chkMsg.join("<br/>"), 400, null);
			return;
		} else if ($("#form").valid()) {
			$.ajax({
				url : web_ctx + "/manage/ad/record/del",
				type : "POST",
				contentType : "application/json",
				dataType : "json",
				data : JSON.stringify(formData),
				success : function(data) {
					if (data.code == 1) {
						bootstrapAlert("提示", "删除成功！", 400, function() {
							window.location.href = "toList";
						});
					} else if (data.code == 2) {
						bootstrapAlert("提示", "薪酬更改操作，请先倒入密钥！", 400, null);
					} else if (data.code == 3) {
						bootstrapAlert("提示", "密钥错误，请倒入正确密钥！", 400, null);
					} else {
						bootstrapAlert("提示", "保存失败！", 400, null);
					}
				},
				error : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
		}
	}, null)
}

var idForReset = null;
function resetPassword(userId) {
	idForReset = userId;
	
	bootstrapConfirm("提示", "确认初始化密码？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": web_ctx + "/manage/sys/user/resetPassword",    
	        "dataType": "json",   
	        "data": {"userId": idForReset},
	        "success": function(data) {   
	        	if(data != null) {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}

function getPosition(positionList) {
	if(positionList != null && positionList.length > 0) {
		var positionName = [];
		var positionId = [];
		$(positionList).each(function(index, position) {
			positionName.push(position.name);
			positionId.push(position.id);
		});
		$("#positionName").text(positionName.join(", "));
		$("#positionId").val(positionId.join(","));
	} else {
		$("#positionName").text("");
		$("#positionId").val("");
	}
}

function getpositionname() {
	var temp = $("#positionId").val()
	if (temp != "" && temp != null) {
		return temp;
	}
}

function openDept() {
	$("#deptDialog").openDeptDialog();
}

function getDept(dept) {
	if(dept != null) {
		$("#deptName").text("");
		$("#deptName").text(dept.name);
		$("#deptId").val(dept.id);
	}
}

function deptAndRolesTwo() {
	var dataTR="";
	$.ajax({
		url: web_ctx + "/manage/ad/record/findDeptList",
		type: "get",
		contentType: "application/json;charset=UTF-8",
		data: {"parentId": $("#companyId").val()},
		dataType: "json",
		async: false,
		success: function (data) {
			$.each(data,function(key,val){
				dataTR += '<table style="margin-left:60px;table-layout: fixed">'
				dataTR += '<tbody>'
				if(data[key].childrenPosition.length > 0) {
					$.each(data[key].childrenPosition,function(key1,val1){
						if(key1 == 0) {
							dataTR += '<tr>'
							dataTR += '<td style="text-align:left;width: 120px;" ><font style="font-size:15px;font-weight:900;">'+(data[key].name)+'</font></td>'
							dataTR += '<td style="text-align:left;width: 160px;">'+'<input type="checkbox" name="roleidList[]" value="' + data[key].childrenPosition[key1].id + '">' + data[key].childrenPosition[key1].name+'</td>'
						}else{
							if(key1 != 0 && (key1+1) % 5 == 0){
								dataTR += '<td style="text-align:left;width: 160px;">'+'<input type="checkbox" name="roleidList[]" value="' + data[key].childrenPosition[key1].id + '">' + data[key].childrenPosition[key1].name+'</td>'
								dataTR += '</tr>'
							}else if (key1 != 0 && (key1+1) % 5 == 1){
								dataTR += '<tr>'
								dataTR += '<td></td>'
								dataTR += '<td style="text-align:left;width: 160px;">'+'<input type="checkbox" name="roleidList[]" value="' + data[key].childrenPosition[key1].id + '">' + data[key].childrenPosition[key1].name+'</td>'
							}else {
								dataTR += '<td style="text-align:left;width: 160px;">'+'<input type="checkbox" name="roleidList[]" value="' + data[key].childrenPosition[key1].id + '">' + data[key].childrenPosition[key1].name+'</td>'
							}
						}
					})
				}
				if(data[key].children.length > 0) {
					dataTR += '<tr>'
					dataTR += '<td></td>'
					$.each(data[key].children,function(key2,val2){
						dataTR += '<td style="text-align:left;width: 160px;"><font style="font-weight:600;">'+(data[key].children[key2].name)+'</font></td>'
					})
					dataTR += '</tr>'
					dataTR += '<tr>'
					dataTR += '<td></td>'
					$.each(data[key].children,function(key3,val3){
						if(data[key].children[key3].childrenPosition.length > 0) {
							$.each(data[key].children[key3].childrenPosition,function(key4,val4){
								dataTR += '<td style="text-align:left;width: 160px;">'+'<input type="checkbox" name="roleidList[]" value="' + data[key].children[key3].childrenPosition[key4].id + '">' + data[key].children[key3].childrenPosition[key4].name+'</td>'
							})
						}
					})
					dataTR += '</tr>'
				}
				dataTR += '</tbody>'
				dataTR += '</table>'
			})
		}
	})
	$("#deptAndRoles").append(dataTR);
	initCheckbox();
}