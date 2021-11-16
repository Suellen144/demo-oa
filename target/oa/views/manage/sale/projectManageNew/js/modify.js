/*******************************************************************************
 * 全局变量 *
 ******************************************************************************/
var fileData = null;
var boot = true;
var index=0;
$(function() {
	inittextarea();
	initFileUpload();
	initInputMask();
	initMoneyFormat();
	initDatetimepicker();

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
		data: {projectId:$("#projectId").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tbodyInfoTr").append("<tr name='node1' class='node1'><td style='width:33%'><input type='text' id='uName' name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  " +
							"name='uId' id='uId' value='"+data[i].principal.id+"' data-sorting='"+index+"'></td>" +
											"<td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()'" +
											"  title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
					boot = false;
				}else{
					$("#tbodyInfoTr").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog2(this)'><input type='text' name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden'  name='uId' value='"+data[i].principal.id+"' " +
									" data-sorting='"+index+"' style='text-align:center'></td>" +
													"<td style='width:33%'><input type='text'  name='commissionProportion' " +
											"value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()' title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
				}
				index++;
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	 statisticalCalculate();
	 initMenu();
});

function initInputBlur(){
	//$("#momeyNum").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("#size").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='resultsProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='commissionProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
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

function initMenu(){
	$.contextMenu({
	    selector: "#table3 .node", //给table3表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
	        	dataTR='<tr name="node" class="node">'
					+ '<td onclick="openDialog2(this)"  style="width:33%"><input type="text" name="uName"   style="text-align:center" readonly/><input type="hidden" name="uId" data-sorting="'+index+'"></td>'
					/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
					+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
					+ '</tr>';
		        	$("#tbodyInfoTr").append(dataTR)
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
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tbodyInfoTr").append(dataTR);				  				  
	          	}
	        }
	      }
	});
}
var T1=0;var T2=0;var T3=0;var T4=0;var T5=0;
function statisticalCalculate(){
	var projectId=$("#projectId").val();
	 //合同金额计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getContractAmount",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#barginMoney").val(initInputMask(data.totalMoney));
					$("#qdMoney").val(initInputMask(data.channelExpense)); ////渠道费用额度 计算统计  销售类合同 录入的 渠道费用额度 
					notPay(data.channelExpense,$("#qdMoneyUsed").val());
				}else{
					$("#barginMoney").val(0.0);
					$("#qdMoney").val(0.0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T1=1;
				error_T5();
				$("#barginMoney").val(0.0);
				$("#qdMoney").val(0.0);
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
					$("#performanceContribution").val(initInputMask(data.resultsAmount));//业绩贡献 计算统计
				}else{
					$("#income").val(0.0);
					$("#performanceContribution").val(0.0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T2=1;
				error_T5();
				$("#income").val(0.0);
				$("#performanceContribution").val(0.0);
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
					$("#pay").val(0.0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T3=1;
				error_T5();
				$("#pay").val(0.0);
			}
		});
	//攻关费用(已用)计算统计
	 $.ajax({
		 	url: web_ctx + "/manage/sale/projectManage/getClearanceBeen",
			type: "post",
			data: {projectId:projectId},
			dataType: "json",
			success: function(data) {
				if(data !=null){
					$("#ggMoney").val(initInputMask(data.actReimburse));
				}else{
					$("#ggMoney").val(0.0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T4=1;
				error_T5();
				$("#ggMoney").val(0.0);
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
					$("#qdMoneyUsed").val(initInputMask(data.channelCost));
					$("#royaltyQuota").val(initInputMask(data.allocations));//提成额度 计算统计
					notPay($("#qdMoney").val(),data.channelCost);
				}else{
					$("#qdMoneyUsed").val(0.0);
					$("#royaltyQuota").val(0.0);
				}
			},
			error: function(data, textstatus) {
				openBootstrapShade(false);
				T5=1;
				error_T5();
				$("#qdMoneyUsed").val(0.0);
				$("#royaltyQuota").val(0.0);
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
		 $("#qdMoneyResidue").val(initInputMask(channelExpense-channelHave));
	 }else{
		 $("#qdMoneyResidue").val(0.0);
	 }
}
function error_T5(){
	if(T1==1 || T2==1 || T3==1 || T4==1 || T5==1){
		bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	}
}
function initDatetimepicker() {
	$(".projectDate, .projectEndDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userId']").val(data.id);
        $(currTd).find("input[name='userName']").val(data.name);
        $("#dutyDeptId").val(data.dept.id);
        $("#dutyDeptName").val(data.dept.name);
        myFunction()        	        
    }
}
function getData2(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='uId']").val(data.id); 
        $(currTd).find("input[name='uName']").val(data.name);
    }
}

function myFunction(){
	var name = $("#table1 tbody").eq(0).find('tr #userName').val()
	var id = $("#table1 tbody").eq(0).find('tr #userId').val()
	if(boot){	
		$("#tbodyInfoTr").append('<tr name="node1" class="node1">'
    							+ '<td style="width:33%">'
    							+ '<input id="uId" name="uId" type="text" value="'+ id +'" style="display:none;" data-sorting="'+index+'">'
    							+ '<input type="text" id="uName" name="uName" value="'+ name +'" readonly/></td>'
    							/*+ '<td style="width:33%"><input type="text" id="resultsProportion" name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
    							+ '<td style="width:33%"><input type="text" id="commissionProportion" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
    							+ '</tr>')
    	boot = false;
	}else{
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uId']").val(id);
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uName']").val(name);
	}  	 
}

function getDeptName() {
    var deptName = null;
    return deptName;
}

function openDialog(obj) {	
	currTd = obj;
    $("#userByDeptDialog").openUserDialog();
}

function openDialog2(obj) {	
	currTd = obj;
	$("#userDialog").openUserByDeptDialog();	
}

function submitInfo() {	
	var formData = getFormData();
	
	var issubmit = $("#issubmit").val("1");
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	openBootstrapShade(true);
	submit(formData);	
}

function submit(formData){
	$.ajax({
		url: web_ctx + "/manage/sale/projectManageHistory/submit",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
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
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["projectMemberHistoryList"] = [];
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
				formData["projectMemberHistoryList"].push(memberList);
			}
		});
	return formData;
}

function checkForm(formData) {
	var text = [];
	var projecName = $.trim($("#name").val());
	
	if(isNull(projecName)) {
		text.push("请填写项目名称！");
	}
		
	return text;
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


/*******************************************************************************
 * 表单处理相关函数 *
 ******************************************************************************/
function save() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	/*var issubmit = $("#issubmit").val("0");// 区分保存和提交
	var checkMsg = checkForm(formData);
	if (!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return;
	}*/
	if (fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}
}

// 调用发送邮件的方法
function sendMail() {
	var comment = $("#comment").val();
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/finance/pay/sendMail",
		"dataType" : "json",
		"data" : {
			"id" : $("#id").val(),
			"contents" : comment
		}
	});
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

// 下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url, '_blank');
	}
}

// 删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/finance/pay/deleteAttach",
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

function initInputMask() {
	// $("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	// $("#actualPayMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#bankAccount").inputmask("Regex", {
		regex : "\\d+\\.?\\d{0}"
	});
}
/*
 * 去除千分位
 */
function commafyback(num) {
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
function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId" : processInstanceId,
		"page" : "manage/finance/pay/pdf"
	}
	window.open(web_ctx + "/activiti/process?" + urlEncode(param));
}