var currTd = null;
$(function() {
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	if($("#barginManageId").val() != null && $("#barginManageId").val() != ""){
		$("#viewBarginBtn").show();
	}
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	initDatetimepicker();
	initInputMask();
	initinvoiced();
	coutmoney();
    initFileUpload();
});

var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
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
    $("#applyPay").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "collectionBill") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
	});
	
	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "number") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}
	});
	
	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		/*if(name == "price" || name == "money" || name =="excise" || name =="exciseMoney") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}*/
		if (name == "levied") {
			$(input).inputmask("Regex", { regex: "^-?\\d+\\.?\\d{0,2}"});
		}
	});
	/*$("#collectionNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });*/
	/*$("#paynumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });*/
	$("#bankNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	$("#collectionAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
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

function initInputBlur(){
	var totalmoney = rmoney($("#totalPay").val());
	var applyPay = rmoney($("#applyPay").val());
	if(!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0"){
		$("#applyProportion").val((digitTool.divide(applyPay,totalmoney)* 100).toFixed(2)+ "%");
	}

}



/*function coutmoney(){
	$("tr[name='add']").each(function(index, tr) {
		var number = $(tr).find("input[name='number']").val();
		var price = $(tr).find("input[name='price']").val();
		$(tr).find("input[name='money']").val(digitTool.multiply(price,number));
		coutexcise(tr);
	});
}

function coutexcise(tr){
	var money = $(tr).find("input[name='money']").val();
	var excise = $(tr).find("input[name='excise']").val()/100;
	if (money != null && money != "" && excise != null && excise != "") {
		$(tr).find("input[name='exciseMoney']").val(money*excise);
	}
	countAll();
}


function initInputBlur(){
	var totalmoney = $("#totalPay").val();
	var applyPay = $("#applyPay").val();
	if(!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0"){
		$("#applyProportion").val(digitTool.divide(applyPay,totalmoney).toFixed(4)* 100+ "%");
	}

}


function initexcise(){
	$("tr[name='add']").each(function(index, tr) {
		var money = $(tr).find("input[name='money']").val();
		var excise = $(tr).find("input[name='excise']").val()/100;
		if (money != null && money != "" && excise != null && excise != "") {
			$(tr).find("input[name='exciseMoney']").val(money*excise);
		}
	});
    countAll();
}
*/



//?????????????????????
function initinvoiced(obj){
	if($(obj).val() == '1'){
		$("#table2").show();
	}
	else{
		$("#table2").hide();
	}
}



function openBargin() {
	$("#barginDialog").openBarginDialog();
}


function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(fmoney(data.totalMoney,0));
		if(data.projectManage != null && data.projectManage != ""){
			$("#projectManageName").val(data.projectManage.name);
			$("#projectId").val(data.projectManage.id);
		}
		
		if(data.processInstanceId != null && data.processInstanceId != "" && data.processInstanceId != "undefined"){
			$("#tip").remove();
			$("#viewBarginBtn").show();
		}else{
			$("#tip").remove();  
			
			document.getElementById("viewBarginBtn").style.display = "none";
		        
			$("#viewBarginBtn").before('<font id="tip" style="border:none;color: rgb(54, 127, 169)">???????????????</font>');
		}
		
	}
}

//??????????????????
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	
	var url = "";
	if(barginProcessInstanceId != null && barginProcessInstanceId != ""){
		var param = {
				"processInstanceId": barginProcessInstanceId,
				"page": "manage/sale/barginManage/viewDetail"
			}
		url = web_ctx + "/activiti/process?" + urlEncode(param);
	}
	
	$("#barginDetailFrame").attr("src", url);
	$("#barginDetailModal").modal("show");
}


function initDatetimepicker() {
	
	$(".collectionDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$(".billDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	
	
}

function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
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
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
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



//???????????????
function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('	<td colspan="3"><input type="text" style="text-align:center;" name="collectionDate" class="collectionDate" value=""  readonly></td>');
	html.push('	<td colspan="3"><input type="text" name="collectionBill" value="" ></td>');
	html.push('<td colspan="3" style="text-align:center;">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="??????" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="??????" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
	
}


//???????????????
function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td><input type="text"  name="name" value="" > </td>');
	html.push('<td><input type="text"  name="model" value="" > </td>');
	html.push('<td><input type="text" name="unit" value=""  ></td>');
	html.push('<td><input type="text" name="number" value=""  onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="price" value="" readonly></td>');
	html.push('<td><input type="text" name="money" value="0"  readonly></td>');
	html.push('<td><select name="excise" onchange="initexcise()" style="width: 100%;">');
	html.push('<option selected="selected">0</option>');
	html.push('<option>6</option>');
	html.push('<option>13</option>');
	html.push('<option>16</option>');
	html.push('<option>17</option>');
	html.push('</select></td>');
	html.push('<td><input type="text" name="exciseMoney" value="0"  readonly ></td>');
	html.push('<td><input type="text"  name="levied" value="" onkeyup="coutmoney()"></td>')
	html.push('<td style="text-align:center;">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="??????" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="??????" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}


function submitinfo() {
	bootstrapConfirm("??????", "?????????????????????", 300, function() {
		var formData = getFormData();
		$("#isSubmit").val(1);
		if(!checkForm(formData)) {
			return ;
		}

		if(fileData !=null){ //????????????????????????????????????
			openBootstrapShade(true);
			fileData.submit();
		}else{
	        openBootstrapShade(true);
	        submitForm(formData);
		}
	})
}

//??????????????????
function save() {
	//bootstrapConfirm("??????", "?????????????????????", 300, function() {
		var formData = getFormData();
	    $("#isSubmit").val(0);
		if(!checkForm(formData)) {
			return ;
		}
	    if(fileData !=null){ //????????????????????????????????????
	        openBootstrapShade(true);
	        fileData.submit();
	    }else{
	        openBootstrapShade(true);
	        saveForm(formData);
	    }
//	})
}


//????????????
function saveForm(formData) {
	$.ajax({
		url: "save",
		type: "post",
		contentType: "application/json",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("??????", data.result, 400, null);
			}
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("??????", "?????????????????????????????????", 400, null);
		}
	});
}


function submitForm(formData) {
	$.ajax({
		url: "submitinfo",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("??????", data.result, 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("??????", "?????????????????????????????????", 400, null);
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

	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var collectionDate = $(this).find("input[name='collectionDate']").val();
		var collectionBill = $(this).find("input[name='collectionBill']").val();
		if( !isNull(collectionDate) || !isNull(collectionBill)) {	
			
			var collectionAttach = {};
			collectionAttach["collectionDate"]= collectionDate;
			collectionAttach["collectionBill"]= collectionBill;
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
		if( !isNull(name) || !isNull(model)) {
			var invoiceAttach = {};
			invoiceAttach["name"]= name;
			invoiceAttach["model"]= model;
			invoiceAttach["unit"]= unit;
			invoiceAttach["number"]= number;
			invoiceAttach["price"]= price;
			invoiceAttach["money"]= money;
			invoiceAttach["excise"]= excise;
			invoiceAttach["exciseMoney"]= exciseMoney;
			invoiceAttach["levied"]= levied;
			formData["invoicedAttachList"].push(invoiceAttach);
		}
		
	});
	return formData;
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if($("#isInvoiced").val() == '1'){
		if(isNull(formData["applyPay"])){
			text.push("???????????????????????????<br/>");
		}
		if(isNull(formData["payCompany"])){
			text.push("???????????????????????????<br/>");
		}

        if(isNull(formData["projectId"])){
            text.push("????????????????????????<br/>");
        }

		/*if(isNull(formData["barginId"])){
			text.push("????????????????????????<br/>");
		}*/
		if(isNull(formData["payname"])){
			text.push("???????????????????????????<br/>");
		}
		if(isNull(formData["paynumber"])){
			text.push("?????????????????????????????????<br/>");
		}

		if(isNull(formData["bankAddress"]) || isNull(formData["bankNumber"])){
			text.push("?????????????????????????????????<br/>");
		}
		if(formData["invoicedAttachList"].length <= 0) {
			text.push("???????????????????????????");
		}
		else{
			$(formData["invoicedAttachList"]).each(function(index, attach) {
				if(isNull(attach["name"])) {
					text.push("?????????????????????");
					return false;
				}
				/*if(isNull(attach["model"])) {
					text.push("?????????????????????");
					return false;
				}*/
				
				if(isNull(attach["levied"])){
					text.push("???????????????????????????");
					return false;
				}
				if(isNull(attach["number"])) {
					text.push("?????????????????????");
					return false;
				}
				if(isNull(attach["price"])) {
					text.push("?????????????????????");
					return false;
				}
				if(isNull(attach["money"])) {
					text.push("?????????????????????");
					return false;
				}
				if(isNull(attach["excise"])) {
					text.push("?????????????????????");
					return false;
				}
			});
			
		}
	}
	else{
		if(isNull(formData["applyPay"])){
			text.push("???????????????????????????<br/>");
		}
		if(isNull(formData["payCompany"])){
			text.push("???????????????????????????<br/>");
		}

        if(isNull(formData["projectId"])){
            text.push("????????????????????????<br/>");
        }
        if(isNull(formData["totalPay"])){
            text.push("????????????????????????<br/>");
        }
        
       
	}
	
	if(text.length > 0) {
		bootstrapAlert("??????", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

//????????????
function downloadAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        var url = web_ctx + attachUrl;
        window.open(url,'_blank');
    }
}

//????????????
function deleteAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        bootstrapConfirm("??????", "??????????????????????????????", 300, function() {
            $.ajax({
                url: web_ctx+"/manage/finance/collection/deleteAttach",
                data: {"path":$("#attachments").val(), "id":$("#id").val()},
                type: "post",
                dataType: "json",
                success: function(data) {
                    if(data.code == 1) {
                        bootstrapAlert("??????", "???????????? ???", 400, function() {
                            window.location.reload();
                        });
                    }
                    else{
                        bootstrapAlert("????????????", "????????????????????????????????????????????????", 400, null);
                    }
                },
                error: function(data) {
                    bootstrapAlert("??????", "?????????????????????????????????", 400, null);
                }

            });
        }, null);
    }
    else{
        bootstrapAlert("??????", "????????????", 400, null);
    }
}


//????????????
var fileData = null;
var urlParam = "";
function initFileUpload() {
    var date = new Date();
    var params = {
        "path": "collection/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
        "deleteFile": $("#attachments").val()
    };

    urlParam = urlEncode(params);
    $('#file').fileupload({
        url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
            maxFileSize: '?????????????????????50M???'
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
                bootstrapAlert("??????", errorMsg.join("<br/>"), 400, null);
            });
        },
        done: function (e, data) {
            var result = data.result;
            if(result.execResult.code != 0) {
                // ??????????????????????????????????????????????????????????????????????????????????????????????????????
                params["deleteFile"] = result.path;
                urlParam = urlEncode(params);
                $("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
                $("#file").fileupload("option", "formData", urlParam);
                $("#showName").val(result.originName);
                $("#attachments").val(result.path);
                $("#attachName").val(result.originName);

                var formData = getFormData();
                if($("#isSubmit").val() == 1){
                    submitForm(formData);
				}else{
                    saveForm(formData);
				}
                openBootstrapShade(false);
            } else {
                openBootstrapShade(false);
                bootstrapAlert("??????", "????????????????????????????????????" + result.execResult.result, 400, null);
            }
        }
    });
}








