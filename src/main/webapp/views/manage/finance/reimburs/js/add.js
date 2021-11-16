var projectObj = null;
$(function() {
	initDatetimepicker();
	/*initSelect();*/
	initInputMask();
	initFileUpload();
	inittextarea();
	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept
	});

});

function initDatetimepicker() {
	$("input[name='date']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}

function showhelp() {
	$("#helpModal").modal("show");
}


//初始化文本域
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

//初始化输入框约束
function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "money" || name == "actReimburse") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
		else if (name == "bankAccount") {
			$(input).inputmask("Regex", { regex: "\\d+\\?\\d{0,0}" });
		}
	});
}

function openProject(obj) {
	if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		
		if( tr.length > 0 && !isNull($(tr).find("textarea[name='projectName']").val()) ) {
			$(obj).siblings("input[name='projectId']").val( $(tr).find("input[name='projectId']").val() );
			$(obj).val( $(tr).find("textarea[name='projectName']").val() );
			return ;
		}
	}
	
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function openDept() {
	$("#deptDialog").openDeptDialog();
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).next("input[name='projectId']").val(data.id);
		$(projectObj).val(data.name);
	}
	validationRed();
}

function getDept(data) {
	if(!isNull(data)) {
		$("#deptId").val(data.id);
		$("#deptName").val(data.name);
	}
}

function toUppercase(value) {
	$("#costcn").inputmask("Regex", { regex: ".*" });
	if(!isNull(value)) {		
		$("#costcn").text(digitUppercase(value));
		$("#cost").val(value);
	} else {
		$("#costcn").text("零元整");
		$("#cost").val("0");
	}
}

function toLowercase(obj) {
	$("#costcn").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	var value = $("#cost").val();
	$("#costcn").val(value);
	$(obj).trigger("select");
}

function actReimburseCount() {
	var count = 0;
	var total = 0;
	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		var value = "";
		if( !isNull(actReimburse) ) {
			value = actReimburse;
			total = digitTool.add(total, parseFloat(value));
		} else {
			value = $(tr).find("input[name='money']").val();
		}
		
		if(isNull(value)) {
			value = "0";
		}
		count = digitTool.add(count, parseFloat(value));
	});
	
	if(total == 0) {
		$("#actReimburseTotal").text("");
	} else {
		$("#actReimburseTotal").text(total);
	}
	toUppercase(count);
	validationRed();
}

function validationRed(){
	var str="";
	var strTo=0;
	var map = {};
	//var id=$("#id").val();
	$("tr[name='node']").each(function(index, tr) {
		var projectId=$(tr).find("input[name='projectId']").val();
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		if($(tr).find("select[name='type']").val() == 37){
		//如果包含，则取出 map中的value进行叠加
		if(str.indexOf(projectId) != -1){
			actReimburse=numAdd(actReimburse,map[projectId]);
			map[projectId]=actReimburse;
		}else{
			str=str+","+projectId;
			map[projectId]=actReimburse;
		}
		$.ajax({
			url: web_ctx+"/manage/finance/reimburs/getProjectById?id="+projectId,
			type: "POST",
			dataType: "json",
			success: function(data) {
				if(data !=null){
					if(data.researchCostLinesBalance<actReimburse){
						$(tr).find("input[name='actReimburse']").css("color","red");
						$(tr).find("input[name='actReimburse']")[0].title="超出攻关费"+accSub(actReimburse,data.researchCostLinesBalance)+"元";
					}else{
						$(tr).find("input[name='actReimburse']").css("color","");
						$(tr).find("input[name='actReimburse']")[0].title="";
					}
				}else{
					$(tr).find("input[name='actReimburse']").css("color","");
					$(tr).find("input[name='actReimburse']")[0].title="";
				}
			},error: function(data) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		}else if($(tr).find("select[name='type']").val() == 36){
			strTo=numAdd(strTo,actReimburse);
			$.ajax({
				url: web_ctx+"/manage/finance/reimburs/getGroupBusinessSum?state=1",
				type: "POST",
				dataType: "json",
				success: function(data) {
					if(data !=null){
						if(numAdd(data[0],strTo)>data[1]){
							$(tr).find("input[name='actReimburse']").css("color","red");
							$(tr).find("input[name='actReimburse']")[0].title="超出业务费"+accSub(numAdd(data[0],strTo),data[1])+"元";
						}else{
							$(tr).find("input[name='actReimburse']").css("color","");
							$(tr).find("input[name='actReimburse']")[0].title="";
						}
					}
				},error: function(data) {
					openBootstrapShade(false);
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
		}else{
			$(tr).find("input[name='actReimburse']").css("color","");
			$(tr).find("input[name='actReimburse']")[0].title="";
		}
	});
}

function accSub(arg1,arg2){
	var r1,r2,m,n;
	try{
	r1=arg1.toString().split(".")[1].length
	}catch(e){
	r1=0
	}try{
	r2=arg2.toString().split(".")[1].length
	}catch(e){
		r2=0
		}
	m=Math.pow(10,Math.max(r1,r2));
	n=(r1>=r2)?r1:r2;
	return ((arg1*m-arg2*m)/m).toFixed(n);
	}
function numAdd(num1, num2) {
   var baseNum, baseNum1, baseNum2; 
   try { 
      baseNum1 = num1.toString().split(".")[1].length; 
   } catch (e) {  
     baseNum1 = 0;
   } 
   try {
       baseNum2 = num2.toString().split(".")[1].length; 
   } catch (e) {
     baseNum2 = 0; 
   } 
   baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
   var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;//精度
   return ((num1 * baseNum + num2 * baseNum) / baseNum).toFixed(precision);; 
};
function moneyCount() {
	var total = 0;
	$("input[name='money']").each(function(index, input) {
		var value = $(input).val();
		if(isNull(value)) {
			value = "0";
		}
		total = digitTool.add(total, parseFloat(value));
	});
	
	if(total == 0) {
		$("#moneyTotal").val("");
	} else {
		$("#moneyTotal").val(total);
	}
}

function moneyBlur(obj) {
	var td = $(obj).parent("td");
	var actReimbruseObj = $(td).next("td").find("input[name='actReimburse']");
	if( isNull($(actReimbruseObj).val()) ) {
		var value = $(obj).val();
		$(actReimbruseObj).val(value);
	}
	$(actReimbruseObj).trigger("keyup");
}

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		/*$(obj).attr("onclick", "node('del', this)");*/
		/*$(obj).text("删除");*/
		initDatetimepicker();
		initInputMask();
		inittextarea();
		
		//项目、事由、类别默认复制上一行的报销内容
	
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td><input type="text" name="date" class="date" readonly></td>');
	html.push('<td><input type="text" name="place" class="input" ></td>');
	html.push('<td>');
	html.push('<textarea name="projectName" onclick="openProject(this)" readonly></textarea>');
	html.push('<input type="hidden" name="projectId" value=""></td>');
	html.push('<td><textarea name="reason" class="input" autocomplete="off" onfocus="reasonChange(this)" ></textarea></td>');
	html.push('<td><input type="text" name="money" style="text-align:right;"   value="" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)"></td>');
	html.push('<td><input type="text" name="actReimburse" style="text-align:right;" value="" onkeyup="actReimburseCount()" onfocus="this.select()"></td>');
	html.push('<td>');
	html.push('<select name="type" onchange="validationRed()">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</td>');
	html.push('<td><textarea name="detail"></textarea></td>');
/*	html.push('<td>');
	html.push('<select name="investId" style="width:100%;">');
	html.push('<option value=""></option>');
	$(investList).each(function(index, invest) {
		html.push('<option value="'+invest.id+'">'+invest.value+'</option>');
	});
	html.push('</select>');
	html.push('</td>');*/
	html.push('<td>');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	
	return html.join("");
}

function reasonChange(obj){
	if(isNull($(obj).val())){
		var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		
	/*	if(tr.length >0 && !isNull( $(tr).find("textarea[name='reason']").val())){
			$(obj).val( $(tr).find("textarea[name='reason']").val() );
		}*/
	}
}

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["reimburseAttachList"] = [];

	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var date = $(this).find("input[name='date']").val();
		var place = $(this).find("input[name='place']").val();
		var projectId = $(this).find("input[name='projectId']").val();
		var reason = $(this).find("textarea[name='reason']").val();
		var type = $(this).find("select[name='type']").val();
		var money = $(this).find("input[name='money']").val();
		var actReimburse = $(this).find("input[name='actReimburse']").val();
		var detail = $(this).find("textarea[name='detail']").val();
		var investId = $(this).find("select[name='investId']").val();
		
		// 其中一个有值就算有效表单数据
		if(!isNull(date) || !isNull(place)
				|| !isNull(reason) || !isNull(money) 
				|| !isNull(detail) || !isNull(projectId)
				|| !isNull(investId)) {
			var data = {};
			data["date"] = date;
			data["place"] = place;
			data["projectId"] = projectId;
			data["reason"] = reason;
			data["type"] = type;
			data["money"] = money;
			data["actReimburse"] = actReimburse;
			data["detail"] = detail;
			data["investId"] = investId;
			
			formData["reimburseAttachList"].push(data);
		}
	});

	return formData;
}

function checkForm(formData) {
	var checkMsg = [];
/*	if(isNull(formData["reimburseAttachList"])) {
		checkMsg.push("至少有一条报销项！");
	}*/
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if(isNull(data["date"])) {
			checkMsg.push("日期不能为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if(isNull(data["place"])) {
			checkMsg.push("地点不能为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if(isNull(data["money"]) && isNull(data["actReimburse"])) {
			checkMsg.push("金额与实报不能同时为空！");
			return false;
		}
	});
	$(formData["reimburseAttachList"]).each(function(index, data) {
		if(isNull(data["projectId"])) {
			checkMsg.push("项目不能为空！");
			return false;
		}
	});
	
	return checkMsg;
}



/*save仅作表单保存*/
function save() {
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	var issubmit = $("#issubmit").val("0");
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	$.ajax({
		url: "validationByName?name="+formData["name"],
		type: "post",
		dataType: "json",
		success: function(data) {
			if(data.code == 1){
				if(fileData != null) { // 已选择文件，则先上传文件
					openBootstrapShade(true);
					fileData.submit();
				} else {
					openBootstrapShade(true);
					saveForm(formData);
				}
			}else{
				bootstrapAlert("提示", "报销人不存在于系统", 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function submitinfo() {
	var checkMsg ={};
	var formData = getFormJson();
	checkMsg = checkForm(formData);
	var issubmit = $("#issubmit").val("1");
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	$.ajax({
		url: "validationByName?name="+formData["name"],
		type: "post",
		dataType: "json",
		success: function(data) {
			if(data.code == 1){
				if(fileData != null) { // 已选择文件，则先上传文件
					openBootstrapShade(true);
					fileData.submit();
				} else {
					openBootstrapShade(true);
					submitForm(formData);
				}
			}else{
				bootstrapAlert("提示", "报销人不存在于系统", 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function saveForm(formData) {
	$.ajax({
		url: "save",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				submitBankInfo();
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
				submitBankInfo();
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

//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "reimburs/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
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
        		
        		var formData = getFormJson();
        		if($("#issubmit").val()=="0"){
        			saveForm(formData);
        		}
        		else{
        			submitForm(formData);
        		}
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}

function initSelect() {
	var isDigit = /^\d+(\d\s)?.*\d+$/;
	$(".select2").select2({ tags: true, allowClear: true, placeholder: "请选择一项或输入值后回车" });
	$(".select2").on("select2:select", function(evt) {
		var name = $(this).prev("input[type='hidden']").attr("name");
		if(name == "bankAccount") {
			var selValue = $(this).val();
			if(!isNull(selValue) && isDigit.test(selValue)) {
				$(this).prev("input[type='hidden']").val(selValue);
			} else {
				$(this).prev("input[type='hidden']").val("");
				$(this).select2('val', '');
			}
		} else {
			$(this).prev("input[type='hidden']").val($(this).val());
		}
	});
	
	$(".select2").on("change", function(evt) {
		var selValue = $(this).val();
		if(isNull(selValue)) {
			$(this).prev("input[type='hidden']").val("");
		}
	});
	
	$("#payee").next(".select2").trigger('select2:select');
	$("#bankAccount").next(".select2").trigger('select2:select');
	$("#bankAddress").next(".select2").trigger('select2:select');
	$(".select2-selection__rendered").css("text-align", "left");
}

//提交收款人、银行的相关信息作为历史数据
function submitBankInfo() {
	var json = {
		"payee": $("#payee").val(),
		"bank": $("#bank").val(),
		"bankAccount": $("#bankAccount").val(),
		"bankAddress": $("#bankAddress").val()
	};
	
	$.ajax({
		url: web_ctx+"/manage/finance/travelReimburs/saveBankInfo",
		type: "post",
		data: json
	});
}

/*提供给Iframe父页面调用的方法*/
function check(formData) {
	var checkMsg = [];
	
	if(isNull(formData["reimburseAttachList"])) {
		checkMsg.push("至少有一条报销项！");
	}
	return checkMsg;
}

function checknull(){
	var formData = getFormJson();
	checkMsg = check(formData);
	return  checkMsg;
}

function checkall(){
	var formData = getFormJson();
	checkMsg = checkForm(formData);
	return checkMsg.join("<br />");
}

