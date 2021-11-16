var index=0;
$(function() {
	initDatetimepicker();
    initFileUpload();
	initMenu();
	collectionMembersList($("#barginId").val());
	$("#commissionBase").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#commissionProportion").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#allocations").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#channelCost").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#receiving").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#notReceiving").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#applyPay").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	  /* 用户 */
     $("#userDialog").initUserDialog({
         "callBack": getData
     });

	$("#barginDialog").initBarginDialog({
		"callBack" : getBargin
	});
	if ($("#barginId").val() != null && $("#barginId").val() != "") {
		$("#viewBarginBtn").show();
	}
});

function collectionMembersList(barginId){
	$.ajax({
	 	url: web_ctx + "/manage/finance/collectionMembers/getList",
		type: "post",
		data: {finCollectionId:$("#id").val(),barginManageId:barginId},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tableTbody").append("<tr name='node1' class='node1'><td style='width:50%'><input type='text' name='userName' value='"+data[i].sysUser.name+"' style='text-align:center'  readonly><input type='hidden'  name='userIdParticipate' value='"+data[i].sysUser.id+"' data-sorting='"+index+"'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td><td style='width:50%'><input type='text'  name='commissionProportionParticipate' value='"+data[i].commissionProportion+"%'  title='0%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}else{
					$("#tableTbody").append("<tr name='node' class='node'><td style='width:50%'  onclick='openDialog(this)'><input type='text' name='userName' value='"+data[i].sysUser.name+"' style='text-align:center'  readonly><input type='hidden'  name='userIdParticipate' value='"+data[i].sysUser.id+"'  data-sorting='"+index+"' style='text-align:center'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td>" +
							"<td style='width:50%'><input type='text'  name='commissionProportionParticipate' value='"+data[i].commissionProportion+"%' title='0%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}
				index++;
			}
			if(isNull(data)){
				myFunction();
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

var boot = true;
function myFunction(){
	var principalId = $("#principalId").val();
	var principalName = $("#principalName").val();
	if(boot && !isNull(principalName)){
		$("#tableTbody").append(
			"<tr name='node1' class='node1'>" +
				"<td style='width:50%'>" +
					"<input type='text' name='userName' value='"+principalName+"' style='text-align:center'  readonly>" +
					"<input type='hidden'  name='userIdParticipate' value='"+principalId+"' data-sorting='"+index+"'>" +
					"<input type='hidden'  name='businessId' value='"+principalId+"'>" +
				"</td>" +
				"<td style='width:50%'>" +
					"<input type='text'  name='commissionProportionParticipate' title='0%' style='text-align:center' onchange='onchanges(this)'/>" +
				"</td>" +
			"</tr>");
		boot = false;
	}
}

$(".linkage").change(function(){
	var commissionBase=$("#commissionBase").val();
	var commissionProportion=$("#commissionProportion").val();
	//var allocations=$("#allocations").val();
	if(isNull(commissionBase) || isNull(commissionProportion)){
		return;
	}
	$("#allocations").val(commissionBase*(commissionProportion/100));
	});

function openBargin() {
	$("#barginDialog").openBarginDialog();
}

function getBargin(data) {
	if (!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		collectionMembersList(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(fmoney(data.totalMoney, 0));
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
	initInputBlur();
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


function onchanges(obj) {
	if(obj.value.indexOf("%") != -1){
		obj.value=obj.value.replace(/%/g,'')+"%";
	}else{
		obj.value=obj.value+"%";
	}
	cumulative();
};
function cumulative(){
	var commissionProportion=$("input[name='commissionProportionParticipate']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
}
var currTd = null;
function openDialog(obj) {
    currTd = obj;
    $("#userDialog").openUserDialog();
}
function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userName']").val(data.name);
        $(currTd).find("input[name='userIdParticipate']").val(data.id);
    }
}

function initMenu(){
	$.contextMenu({
	    selector: "#table2 .node", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:50%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						+ '<td  style="width:50%"><input type="text"  name="commissionProportionParticipate" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);				  				  
	          	}
	        },
	        verygood: {name: "删除", callback: function(key, opt){
	        	index--;
	        	var activeClass = $('.context-menu-active');
	        	var userName = $('#table2').find(activeClass).children().eq(0).children("input[name='userName']").val();
	        
	        	if(userName != ""){
	        			$(this).remove();
	        	}else{
	        		$('#table2').find(activeClass).remove();
	        		var firstTr = $("#table2").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        	cumulative();
	        }
	      }
	   }
	});
	$.contextMenu({
	    selector: "#table2 .node1", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:50%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						+ '<td  style="width:50%"><input type="text" name="commissionProportionParticipate" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);				  				  
	          	}
	        }
	      }
	});
}

function initDatetimepicker() {
	
	$("#applyTime,#collectionDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	
}

function submitinfo() {
	bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		var formData = getFormData();
		$("#isSubmit").val(1);
		if(!checkForm(formData)) {
			return ;
		}

		if(fileData !=null){ //已选择文件，则先上传文件
			openBootstrapShade(true);
			fileData.submit();
		}else{
	        openBootstrapShade(true);
	        submitForm(formData);
		}
	})
}

//保存表单信息
function save() {
	//bootstrapConfirm("提示", "是否确定保存？", 300, function() {
		var formData = getFormData();
	    $("#isSubmit").val(0);
		if(!checkForm(formData)) {
			return ;
		}
	    if(fileData !=null){ //已选择文件，则先上传文件
	        openBootstrapShade(true);
	        fileData.submit();
	    }else{
	        openBootstrapShade(true);
	        saveForm(formData);
	    }
	//})
}


//保存表单
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
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
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
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
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
	
/*	formData["collectionAttachList"] = [];
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
		
	});*/
	formData["finCollectionMembers"] = [];
	$("#tableTbody tr").each(function(index, tr) {
		var id = $(this).find("input[name='businessId']").val();
		var userIdParticipate = $(this).find("input[name='userIdParticipate']").val();
		var sorting=$(this).find("input[name='userIdParticipate']").attr("data-sorting");
		var commissionProportionParticipate = $(this).find("input[name='commissionProportionParticipate']").val();
		if( !isNull(userIdParticipate)) {	
			var finCollectionMembers = {};
			if(id!=null && id !='' && id!=undefined && id !='undefined'){
			finCollectionMembers["id"]= id;
			}
			finCollectionMembers["userId"]= userIdParticipate;
			finCollectionMembers["sorting"] = sorting;
			finCollectionMembers["commissionProportion"]= commissionProportionParticipate.replace(/%/g,'');
			formData["finCollectionMembers"].push(finCollectionMembers);
		}
	});
	formData["businessId"]="";
	return formData;
}

function checkForm(formData) {
	var text = [];
		/*if(isNull(formData["collectionDate"])){
			text.push("收款时间不能为空！<br/>");
		}
		*/
		/*$("#tableTbody tr").each(function(index, tr) {
			var userIdParticipate = $(this).find("input[name='userIdParticipate']").val();
			if(isNull(userIdParticipate)) {	
				text.push("参与人员不能为空！<br/>");
			}
		});*/
	
	
	if(isNull(formData["applyPay"])){
		text.push("收款金额不能为空！<br/>");
	}
	if(isNull(formData["payCompany"])){
		text.push("付款单位不能为空！<br/>");
	}
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

//下载附件
function downloadAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        var url = web_ctx + attachUrl;
        window.open(url,'_blank');
    }
}

//删除附件
function deleteAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
            $.ajax({
                url: web_ctx+"/manage/finance/collection/deleteAttach",
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
        bootstrapAlert("提示", "无附件！", 400, null);
    }
}


//文件上传
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
                if($("#isSubmit").val() == 1){
                    submitForm(formData);
				}else{
                    saveForm(formData);
				}
                openBootstrapShade(false);
            } else {
                openBootstrapShade(false);
                bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
            }
        }
    });
}

function checkDate() {
	var applyPay = $("#applyPay").val();
	var channelCost = $("#channelCost").val();
	if(applyPay - channelCost < 0) {
		$("#applyPay").val('');
		$("#channelCost").val('');
		$("#commissionBase").val('');
		$("#allocations").val('');
		$("#commissionProportion").val(0);
		bootstrapAlert("提示", "渠道费用不能大于收款金额", 400, null);
	}else {
		$("#commissionBase").val(applyPay - channelCost);
		var commissionBase=$("#commissionBase").val();
		var commissionProportion=$("#commissionProportion").val();
		//var allocations=$("#allocations").val();
		if(isNull(commissionBase) || isNull(commissionProportion)){
			return;
		}
		$("#allocations").val(commissionBase*(commissionProportion/100));
	}
}
/*
 * 初始化相关操作
 *初始化金额，两位数
 */
function initInputBlur() {	
	$("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#bankAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
}