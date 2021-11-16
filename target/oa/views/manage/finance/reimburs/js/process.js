var projectObj = null;
var investList = [];

// 同意后的下一状态
var approvedStatus = {
	"0": "1",
	"1": "13",
	"2": "3",
	"3": "4",
	"4": "5",
	"5": "6",
	"11": "4",
	"13" : "2"
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0": "7",
	"1": "8",
	"2": "9",
	"3": "10",
	"4": "11",
	"5": "12",
	"11": "10", // 总经理不同意后流程到达复核人，所以 11 与 3 等同看待
	"13":"14"
};
// 环节与状态的映射
var nodeOnStatus = {
	"0": "提交申请",
	"1": "部门经理",
	"2": "经办",
	"3": "复核",
	"4": "总经理",
	"5": "出纳",
	"6": "审批通过",
	"7": "取消申请",
	"8": "提交申请",
	"9": "提交申请",
	"10": "提交申请",
	"11": "复核",
	"12": "提交申请",
	"13": "总经理助理",
    "14": "提交申请"
};
//环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "通过",
	"不同意": "不通过",
	"取消申请": "取消申请"
};

$(function() {
	initInput();
	initTaskComment();
	actReimburseCount();
	moneyCount();
	inittextarea();
	initDecryption();
	updatereimbursetotal();
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept
	});
	
	if(formElement || editInvest) {
		initInput();
		/*initSelect();*/
		initDatetimepicker();
		/*initBankInfo();*/
		initInputMask();
		initFileUpload();
		initInvest();
	}
	else{
		initInvest();
	}
	
	var assistantStatus = $("#assistantStatus").val();
	if(!isNull(assistantStatus) && assistantStatus == '1'){
		$("#submitBtn").hide();
	}
	
	$('#investId').selectpicker({
        'selectedText': 'cat',
        'width':'auto'
    });
});

function validationRed(){
	var currStatus=$("#currStatus").val();
	if(currStatus !=6){
	var str="";
	var strTo=0;
	var map = {};
	var id=$("#id").val();
	$("tr[name='node']").each(function(index, tr) {
		var projectId=$(tr).find("input[name='projectId']").val();
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		if($(tr).find("select[name='type']").val() == 37 || $(tr).find("input[name='type']").val() == 37){
		//strTo=numAdd(actReimburse,strTo);
		//如果包含，则取出 map中的value进行叠加
		if(str.indexOf(projectId) != -1){
			actReimburse=numAdd(actReimburse,map[projectId]);
			map[projectId]=actReimburse;
		}else{
			str=str+","+projectId;
			map[projectId]=actReimburse;
		}
		$.ajax({
			url: web_ctx+"/manage/finance/reimburs/getProjectById?id="+projectId+"&reimbursid="+id,
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
		}else if($(tr).find("select[name='type']").val() == 36 || $(tr).find("input[name='type']").val() == 36){
			strTo=numAdd(strTo,actReimburse);
			$.ajax({
				url: web_ctx+"/manage/finance/reimburs/getGroupBusinessSum?state=1&id="+id,
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

function openProject(obj) {
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
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

function showhelp() {
	$("#helpModal").modal("show");
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj) && !$.isEmptyObject(data)) {
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

function initDatetimepicker() {
	$("input.date").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}

//初始化文本域
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

/*用于报销项目去重*/
function unique(array){
	  var n = []; //一个新的临时数组
	  //遍历当前数组
	  for(var i = 0; i < array.length; i++){
	    //如果当前数组的第i已经保存进了临时数组，那么跳过，
	    //否则把当前项push到临时数组里面
	    if (n.indexOf(array[i]) == -1) n.push(array[i]);
	  }
	  return n;
}

/*更新通用报销合计*/
function updatereimbursetotal(){
	var cost = []; //项目费用数据
	var receive = [];
	var other = [];
	var projectName = [];	
	var temp = [];
	var key; 	 //项目索引Key
	var sum = [];
	//差旅统计map
	var costmap = {};
	//招待统计map
	var receivemap = {};
	//其他统计map
	var othermap = {};
	costmap["key"] = "value";
	receivemap["key"] = "value";
	sum.push("<tr>")
	sum.push("<td colspan='2'>项目</td>")
	sum.push("<td colspan='2'>差旅统计</td>")
	sum.push("<td colspan='3'>招待统计</td>")
	sum.push("<td colspan='3'>其它费用统计</td>")
	sum.push("</tr>")
	$("tr[name='node']").each(function(index, tr) {
		 project = $(tr).find("textarea[name='projectName']").val();
		 if(project != ""){
			 temp.push(project);
		 }
	});
	projectName = unique(temp);

	$("tr[name='node']").each(function(index, tr) {
		 project = $(tr).find("textarea[name='projectName']").val();
		 actReimburse = $(tr).find("input[name='actReimburse']").val(); 
		 type = $(tr).find("select[name='type']").val(); 
		 if (type == undefined) {
			 type = $(tr).find("input[name='typevalue']").val(); 
		}
		 if (type == "4") {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(costmap[key] == undefined){
				 costmap[key] = cost[index];
			 }
			 else {
				 total = digitTool.add(costmap[key],cost[index]);
				 costmap[key] = total;
			 }
		}
		 else if (type == "2" || type == "1" || type == "36" || type == "37") {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(receivemap[key] == undefined){
				 receivemap[key] = receive[index];
			 }
			 else {
				 total = digitTool.add(receivemap[key],receive[index]);
				 receivemap[key] = total;
			 }
		}
		 else {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(othermap[key] == undefined){
				 othermap[key] = other[index];
			 }
			 else {
				 total = digitTool.add(othermap[key],other[index]);
				 othermap[key] = total;
			 }
		}
	});
	
	$(projectName).each(function(index,value){
		sum.push("<tr>")
		sum.push("<td colspan='2'>"+value+"</td>");
		if(costmap[value] == undefined){
			sum.push("<td colspan='2'>"+'0'+"</td>");
		}
		else {
			sum.push("<td  colspan='2'>"+costmap[value]+"</td>");
		}
		if(receivemap[value] == undefined){
			sum.push("<td  colspan='3'>"+'0'+"</td>");
		}
		else{
			sum.push("<td  colspan='3'>"+receivemap[value]+"</td>");
		}
		if(othermap[value] == undefined){
			sum.push("<td  colspan='3'>"+'0'+"</td>");
		}
		else{
			sum.push("<td  colspan='3'>"+othermap[value]+"</td>");
		}
		sum.push("</tr>")
	});
	$("#table1").append(sum);
}

/*function initrecive(){
	
	$("tr[name='node']").each(function(i, tr) {
		 project = $(tr).find("textarea[name='projectName']").val();
		 actReimburse = $(tr).find("input[name='actReimburse']").val(); 
		 type = $(tr).find("select[name='type']").val(); 
		 if (type == "2") {
			 key = project;
			 receive.push(actReimburse);
			 if(receivemap[key] == undefined){
				 receivemap[key] = receive[i];
			 }
			 else {
				 total = digitTool.add(receivemap[key],receive[i]);
				 receivemap[key] = total;
			 }
			
		}
	});
}*/

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

function initInput() {
	// 初始化核报金额
	var cost = $("#cost").val();
	$("#costcn").val(digitUppercase(cost));
	
	// 初始化合计
	var total = 0;
	$("input[name='money']").each(function(index, input) {
		var value = $(input).val();
		if(!isNull(value)) {
			value = clearZero(value);
			$(input).val(value);
			total = digitTool.add(total, parseFloat(value));
		}
	});
	$("#total").val(total);
}

//如果value后缀只有一个.0，则去掉.0
var suffixZero = /.*\.0$/;
function clearZero(value) {
	if(suffixZero.test(value)) {
		return value.replace(".0", "");
	} else {
		return value;
	}
}

function toUppercase(value) {
	$("#costcn").inputmask("Regex", { regex: ".*" });
	if(!isNull(value)) {		
		$("#costcn").val(digitUppercase(value));
		$("#cost").val(value);
	} else {
		$("#costcn").val("零元整");
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
		var ftotal = fmoney(total,0);
		$("#actReimburseTotal").text(ftotal);
	}
	toUppercase(count);
	validationRed();
}

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

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["reimburseAttachList"] = [];

	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var id = $(this).find("input[name='reimburseAttachId']").val();
		var date = $(this).find("input[name='date']").val();
		var place = $(this).find("input[name='place']").val();
		var projectId = $(this).find("input[name='projectId']").val();
		var reason = $(this).find("textarea[name='reason']").val();
		var type;
		if(!isNull($(this).find("select[name='type']").val())){
			type = $(this).find("select[name='type']").val()
		}
		else{
			type = $(this).find("input[name='type']").val()
		}
		var money = $(this).find("input[name='money']").val();
		var actReimburse = $(this).find("input[name='actReimburse']").val();
		var detail = $(this).find("textarea[name='detail']").val();
		var selectId = $(this).find("select[name='investId']").val();
		var investId = null;
		var investIdStr= null;
		if(selectId != null && selectId.length>0){
			for(var i=0;i<selectId.length;i++){
				if(selectId[i]!=null && selectId[i]!=''){
					if(investIdStr == null){
						investIdStr=selectId[i];
						investId= selectId[i];
					}else
						investIdStr+=','+selectId[i];
				}
			}
		}else{
			investId = selectId;
		}
		// 其中一个有值就算有效表单数据
		if(!isNull(date) || !isNull(place)
				|| !isNull(reason) || !isNull(money) 
				|| !isNull(detail) || !isNull(projectId)
				|| !isNull(investId)|| !isNull(investIdStr)) {
			var data = {};
			data["id"] = id;
			data["date"] = date;
			data["place"] = place;
			data["projectId"] = projectId;
			data["reason"] = reason;
			data["type"] = type;
			data["money"] = money;
			data["actReimburse"] = actReimburse;
			data["detail"] = detail;
			data["investId"] = investId;
			data["investIdStr"] = investIdStr;
			
			formData["reimburseAttachList"].push(data);
		}
		formData["investId"] = '';
	});
	return formData;
}

function checkForm(formData) {
	var checkMsg = [];
	
	if(isNull(formData["reimburseAttachList"])) {
		checkMsg.push("至少有一条报销项！");
	}
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

var statusFlag = -1;
function approve(status) {
	statusFlag = status;
	if(status == 1) {
		bootstrapConfirm("提示", "是否确定提交？", 300, function() {
			$("#operStatus").val("提交");
			update();
		},null);
	} else if(status == 2) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("同意");
			if(editInvest) {
				update();
			} else {
				update();
				submitProcess();
			}
		},null);
	} else if(status == 3) {
		bootstrapConfirm("提示", "是否确定操作？", 300, function() {
			$("#operStatus").val("不同意");
			if(editInvest) {
				update();
			} else {
				submitProcess();
			}
		},null);
	} else if(status == 4) {
		bootstrapConfirm("提示", "是否确认保存并提交？", 300, function() {
			$("#operStatus").val("重新申请");
			update();
		},null);
	} else if(status == 5) {
		$("#operStatus").val("取消申请");
		cancelProcess();
	}
}

function update() {
	//先验证表单（checkForm）
	if($("#operStatus").val() == "重新申请"){
		$("#assistantStatus").val("");
	}
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	
	if(fileData != null) {
		openBootstrapShade(true);
		fileData.submit();
	} else {
		submitForm(formData);
	}
}

function save(){
	//先验证表单（checkForm）
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	
	if(fileData != null) {	
		openBootstrapShade(true);
		fileData.submit();
	} else {
		openBootstrapShade(true);
		submitForm(formData);
	}
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx+"/manage/finance/reimburs/saveOrUpdate",
		type: "POST",
		contentType: "application/json;charset=utf-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				/*submitBankInfo();*/
				if($("#operStatus").val() == ""){
					bootstrapAlert("提示", "保存成功！", 400, function() {
	        			backPageAndRefresh();
	        		});
				}
				if($("#operStatus").val() == "提交") {
					backPageAndRefresh();
        		/*	bootstrapAlert("提示", "提交成功 ！", 400, function() {
        				backPageAndRefresh();
        			});*/
        		} else if($("#operStatus").val() == "重新申请") {
        			submitProcess();
        		} else if(($("#operStatus").val() == "同意" || $("#operStatus").val() == "不同意") && editInvest == true) {
        			submitProcess();
        		}
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

function getStatusById(){
	var result = "";
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/manage/finance/reimburs/getStatusById",    
        "dataType": "json",
        "data": {"id": $("#id").val()},       
        "async" : false,
        "success": function(data) { 
        	result = data;
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	return result;
}

function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var processInstanceId = $("#processInstanceId").val();
	var data1 = findTask(processInstanceId);
	var userTask = data1.result[0].task.name;
	console.log("当前任务处理人：" + data1.result[0].task.name)
	var status = getNextStatus();
	console.log("当前任务的下一状态：" + status)
	var compResult = completeTask(taskId, variablesTemp);
	if(compResult.code == 1) {
		var status = getNextStatus();
		$("#currStatus").val(status);
		setStatus(status);
	} else if(compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
	/**
	 * 判断流程是否已结束
	 */
	var process = processState(processInstanceId);
	if(process.result.length > 0){
		console.log("流程执行中");
		var data2 = findTask(processInstanceId);
		var userTask2 = data2.result[0].task.name;
		console.log("任务处理人：" + data2.result[0].task.name);
		if(userTask != userTask2){
			console.log("任务已执行");
			/**
			 * 查询当前单的状态
			 */
			var resultTemp = getStatusById();
			if(resultTemp.status != status){
				console.log("任务已执行，但状态未修改");
				$.ajax({   
			        "type": "POST",    
			        "url": web_ctx+"/manage/finance/reimburs/setStatus",    
			        "dataType": "json",
			        "data": {"id": $("#id").val(), "status": status},
			        "success": function(data) { 
			        	var text = "操作成功！";
			        	if(statusFlag=="3"){
			        		sendMail();
			        	}
		        		if($("#operStatus").val() == "提交") {
		        			text = "提交成功 ！";
		        		} else if($("#operStatus").val() == "重新申请") {
		        			text = "重新申请成功 ！";	
		        		} else if($("#operStatus").val() == "取消申请") {
		        			text = "取消申请成功 ！";
		        		}
		        		
		        		window.parent.initTodo();
		        		backPageAndRefresh();
		        		bootstrapAlert("提示", text, 400, function() {
		        			backPageAndRefresh();
		        		});
			        },
			        "error": function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			        }
				});
			}
		}
	}else{
		var resultTemp = getStatusById();
		if(resultTemp.status != 6){
			console.log("流程已结束");
			$.ajax({   
		        "type": "POST",    
		        "url": web_ctx+"/manage/finance/reimburs/setStatus",    
		        "dataType": "json",
		        "data": {"id": $("#id").val(), "status": 6},
		        "success": function(data) { 
		        	var text = "操作成功！";
		        	if(statusFlag=="3"){
		        		sendMail();
		        	}
	        		
	        		window.parent.initTodo();
	        		backPageAndRefresh();
	        		bootstrapAlert("提示", text, 400, function() {
	        			backPageAndRefresh();
	        		});
		        },
		        "error": function(data) {
		        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
			});
		}
	}
	validate5();
	openBootstrapShade(false);
}

//调用发送邮件的方法
function sendMail() {
	var comment=$("#comment").val();
	$.ajax({
		"type" : "POST",
		"url" : web_ctx + "/manage/finance/reimburs/sendMail",
		"dataType" : "json",
		"data" : {
			"id" : $("#id").val(),
			"contents" : comment
		}
	});
}

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
        		submitForm(formData);
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        },
        processfail: function (e, data) {
            var currentFile = data.files[data.index];
            if (data.files.error && currentFile.error) {
                console.log(currentFile.error);
            }
        }
    });
}

// 获取流程变量，对于流程走向有效果
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
	form["approveResult"] = nodeOnOper[operStatus];
	commentList.push(form);
	
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = 
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" ? true : false;
	
	return variables;
}

/**
 * 获取流程下一审批状态
 * 审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理不同意 9：经办不同意 10：复核不同意 11：总经理不同意 12：出纳不同意
 */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	if($("#operStatus").val() == "同意") {
		var date1 = $("#createDateStr").val() ;
    	var date2 = '2019-08-22 18:40:00';
    	if(currStatus == 1) {
    		if(new Date(date1).getTime() < new Date(date2).getTime()) {
    			status = 2;
        	}else {
        		if($("#isOk").val() == "true") {
        			status = 13;
        		}else {
        			status = 2;
        		}
        	}
    	}else {
    		status = approvedStatus[currStatus];
    	}
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	} else {
		if($("#isOk").val() == "true") {
			status = "1";
		}else {
			status = "13";
		}
	}
	
	return status;
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

//查看流程图
function viewProcess(processInstanceId) {
	var url = web_ctx+"/activiti/getImgByProcessInstancdId?processInstanceId="+processInstanceId;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("client_type", "DESKTOP_WEB");
    xhr.onload = function() {
        if (this.status == 200) {
            var blob = this.response;
            var img = document.createElement("img");
            $(img).width("100%");
            img.onload = function(e) {
                window.URL.revokeObjectURL(img.src); 
            };
            img.src = window.URL.createObjectURL(blob);
            $("#imgcontainer").html(img);
            $("#imgModal").modal("show");
        } else if(this.status == 500) {
        	bootstrapAlert("提示", this.statusText, 400, null);
        }
    }
    xhr.send();
}

//  取消流程
function cancelProcess() {
	var taskId = $("#taskId").val();
	var id = $("#id").val();
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		setTaskVariables();
		var result = endProcessInstance(taskId);
		if(result != null) {
			if(result.code == 1) {
				setStatus(7);
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}

function setStatus(status) {
    var id=$("#id").val();
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/finance/reimburs/setStatus",    
        "dataType": "json",
        "data": {"id": id, "status": status},
        "success": function(data) { 
        	 if (data.code == 1) {
                 var text = "操作成功！";
                 if ($("#operStatus").val() == "提交") {
                     text = "提交成功 ！";
                 } else if ($("#operStatus").val() == "重新申请") {
                     text = "重新申请成功 ！";
                 } else if ($("#operStatus").val() == "取消申请") {
                     text = "取消申请成功 ！";
                 }
                 window.parent.initTodo();
                 backPageAndRefresh();
             }else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
}

function setTaskVariables() {
	var taskId = $("#taskId").val();
	var variables = getVariables();
	variables["taskId"] = taskId;
	
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx+"/activiti/setTaskVariables",
        "contentType": "application/json",
        "dataType": "json",
        "async": false,
        "data": JSON.stringify(variables),
        "success": function(data) { 
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
}

function assistantConfirm(){
	update();
	assistantAffirm();
}

//市场助手在部门经理审批前确认
function assistantAffirm(){
	bootstrapConfirm("提示", "是否确定？", 300, function() {
		var taskId = $("#taskId").val();
		var commentList = variables.commentList;
		if(isNull(commentList)) {
			commentList = [];
		}
		
		var form = {
				"node": '市场助手',
				"approver": $("#approver").val(),
				"comment": $("#comment").val(),
				"approveResult": "确认",
				"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
		};
		commentList.push(form);
		variables["commentList"] = commentList; // 批注列表
		variables["taskId"] = taskId;
		
		$.ajax( {   
	        "type": "POST",    
	        "url": web_ctx+"/activiti/setTaskVariables",
	        "contentType": "application/json",
	        "dataType": "json",
	        "data": JSON.stringify(variables),
	        "success": function(data) { 
	        	if(data.code == '1'){
	        		setAssistantAffirm();
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
		} );
	}, null);
}

//助手不同意
function disagree(){
	bootstrapConfirm("提示", "是否确定？", 300, function() {
		var taskId = $("#taskId").val();
		$("#operStatus").val("不同意");
		variables["approved"] = false;
		var commentList = variables.commentList;
		if(isNull(commentList)) {
			commentList = [];
		}
		var form = {
				"node": '市场助手',
				"approver": $("#approver").val(),
				"comment": $("#comment").val(),
				"approveResult": "不同意",
				"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
		};
		commentList.push(form);
		variables["commentList"] = commentList; // 批注列表
		variables["taskId"] = taskId;
		var compResult = completeTask(taskId, variables);
		if(compResult.code == 1) {
			var status = getNextStatus();
			$.ajax( {   
		        "type": "POST",    
		        "url": web_ctx+"/manage/finance/reimburs/setStatus",    
		        "dataType": "json",
		        "data": {"id": $("#id").val(), "status": status},
		        "success": function(data) { 
		        	var text = "操作成功！";
	        		if($("#operStatus").val() == "提交") {
	        			text = "提交成功 ！";
	        		} else if($("#operStatus").val() == "重新申请") {
	        			text = "重新申请成功 ！";	
	        		} else if($("#operStatus").val() == "取消申请") {
	        			text = "取消申请成功 ！";
	        		}
	        		window.parent.initTodo();
	        		backPageAndRefresh();
		        },
		        "error": function(data) {
		        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
			});
		}else if(compResult.code == 0) {
			bootstrapAlert("提示", compResult.result.statusText, 400, null);
		}else{
			bootstrapAlert("提示", compResult.result.toString(), 400, null);
		}
		
	});
}

//更改确认状态
function setAssistantAffirm(){
	$.ajax({
		url: web_ctx+"/manage/finance/reimburs/setAssistantAffirm",
		data: {"id":$("#id").val(),"assistantStatus":'1'},
		type: "post",
		dataType: "json",
		async: false,
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			}
		},
	    error: function(data) {
	        bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	    }
	});
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
				url: web_ctx+"/manage/finance/reimburs/deleteAttach",
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
	}else{
		bootstrapAlert("提示", "无附件！", 400, null);
	}
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

/*	$(commentList).each(function(index, comment) {
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		html.push(comment.node);
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approver);
		html.push("</td>");
		html.push("<td>");
		var approveDate = comment.approveDate + "";
		if( !dateRep.test(approveDate) ) {
			html.push(new Date(comment.approveDate).pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
		}
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approveResult);
		html.push("</td>");
		html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(comment.comment) ? "" : comment.comment);
		html.push("</td>");
		
		$("#table2").find("tbody").append(html.join(""));
	});*/
	
	for(var i = commentList.length - 1;i >= 0;i --){
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

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		var html;
		var status = $("#currStatus").val();
		if(seeall && status > 7){
			html = getOtherHtml();
			
		}else if(seeall){
			html = getNodeHtml();
		}
		else{
			html = getOtherHtml();
		}
		 
		$(obj).parents("tr").after(html);
/*		$(obj).attr("onclick", "node('del', this)");
		$(obj).text("删除");*/
		initDatetimepicker();
		inittextarea();
		initInputMask();
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
	html.push('<td><textarea name="reason"  onfocus="reasonChange(this)" class="input" autocomplete="off" ></textarea></td>');
	html.push('<td ><input type="text" name="money"  style="text-align:right;"  value="" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)"></td>');
	html.push('<td ><input type="text" name="actReimburse" style="text-align:right;"   value="" onkeyup="actReimburseCount()" onfocus="this.select()"></td>');
	html.push('<td>');
	html.push('<select name="type">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</td>');
	html.push('<td><textarea type="text" name="detail"></textarea></td>');
	html.push('<td>');
	html.push('<select name="investId" style="width:100%;">');
	html.push('<option value=""></option>');
	$(investList).each(function(index, invest) {
		html.push('<option value="'+invest.id+'">'+invest.value+'</option>');
	});
	html.push('</select>');
	html.push('</td>');
	html.push('<td>');
	html.push('<a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a>  <a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
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

function getOtherHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td><input type="text" name="date" class="date" readonly></td>');
	html.push('<td><input type="text" name="place" class="input" ></td>');
	html.push('<td>');
	html.push('<textarea name="projectName" onclick="openProject(this)" readonly></textarea>');
	html.push('<input type="hidden" name="projectId" value=""></td>');
	html.push('<td><textarea name="reason" onfocus="reasonChange(this)"  class="input" ></textarea></td>');
	html.push('<td ><input type="text" name="money" value="" style="text-align:right;"   onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)"></td>');
	html.push('<td ><input type="text" name="actReimburse" value=""  style="text-align:right;"   onkeyup="actReimburseCount()" onfocus="this.select()"></td>');
	html.push('<td>');
	html.push('<select name="type">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</td>');
	html.push('<td><textarea name="detail"></textarea></td>');
	html.push('<td>');
	html.push('<a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a>  <a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	
	return html.join("");
}

//初始化select2
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
	
	$(".select2-selection__rendered").css("text-align", "left");
}

// 初始化银行相关数据
function initBankInfo() {
	$.ajax( {   
        "type": "GET",    
        "url": web_ctx+"/manage/finance/travelReimburs/getBankInfo?userId="+$("#userId").val(),    
        "dataType": "json",
        "success": function(data) { 
        	if(!isNull(data)) {
        		$(data).each(function(index, value) {
        			if(value.type == "0") {
        				$("#payeeSelect").append("<option value='"+value.value+"'>"+value.value+"</option>");
        			} else if(value.type == "1") {
        				$("#bankAddressSelect").append("<option value='"+value.value+"'>"+value.value+"</option>");
        			} else if(value.type == "2") {
        				$("#bankAccountSelect").append("<option value='"+value.value+"'>"+value.value+"</option>");
        			}
        		});
        		
        		$("#payeeSelect").val($("#payee").val()).trigger("change");
        		$("#bankAccountSelect").val($("#bankAccount").val()).trigger("change");
        		$("#bankAddressSelect").val($("#bankAddress").val()).trigger("change");

        	}
        }
	} );
}

function initInvest() {
	$.ajax( {   
        "type": "GET",    
        "url": web_ctx + "/manage/finance/reimburs/getInvestList?date="+new Date().getTime(),    
        "dataType": "json",
        "success": function(data) { 
        	if(!isNull(data)) {
        		/*var area = document.getElementById("investId");
                area.options.length = 0;
                for (var item in data) {
                	area.options.add(new Option(data[item].value, data[item].id));
                }
                $('.selectpicker').selectpicker('refresh');
                $('.selectpicker').selectpicker('render');*/

        		//investList = data;
        		$("tr[name='node']").find("select[name='investId']").each(function(index, select) {
        			$(select)[0].options.length = 0;
        			//if($(select).attr('data-v') == null || $(select).attr('data-v') =='')
        			//$(select)[0].options.add(new Option('', '-1'));
        			for (var item in data) {
        				$(select)[0].options.add(new Option(data[item].value, data[item].id));
                    }
        			var s="";
        			if($(select).attr('data-v') != null && $(select).attr('data-v') !='')
        			 s=$(select).attr('data-v').split(",");
        			$(this).selectpicker('val', s);//默认选中
        			$(this).selectpicker('refresh');
        			/*var investValue = $(select).attr("value");
        			var html = [];
        			html.push('<option value="-1"></option>');
        			$(investList).each(function(index, invest) {
        				html.push('<option value="'+invest.id+'" '+(investValue==invest.id?"selected":"")+'>'+invest.value+'</option>');
        			});
        			$(select).append(html.join(""));*/
        		});
        		
        		 $('.selectpicker').selectpicker('refresh');
                 $('.selectpicker').selectpicker('render');
        	}
        }
	});
}

/*//提交收款人、银行的相关信息作为历史数据
function submitBankInfo() {
	var json = {
		"userId": $("#userId").val(),
		"payee": $("#payee").val(),
		"bankAccount": $("#bankAccount").val(),
		"bankAddress": $("#bankAddress").val()
	};
	
	$.ajax({
		url: web_ctx+"/manage/finance/travelReimburs/saveBankInfo",
		type: "post",
		data: json
	});
}*/

/************* 加解密操作 Begin **************/
//如果有解密权限，则解密当前已加密的数据
function initDecryption() {
	if( 'y' == $("#encrypted").val() ) {
		if("resubmit" == submitPhase) {
			$("textarea[name='reason'],textarea[name='detail']").each(function(index, textarea) {
				$(textarea).text("");
			});
			$("#encrypted").val("n");
		} else {
			if( hasDecryptPermission ) {
				var now = new Date().pattern("yyyyMMdd");
				$.ajax({
					url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
					type: 'GET',
					success: function(data) {
						if(data.code == 1) {
							var tempKey = data.result;
							var encryptionKey = aesUtils.decryptECB(tempKey, now);
							encryptPageText(encryptionKey);
						} else {
							if(data.code == -1) {
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
	}
}

function encryptPageText(encryptionKey) {
	$("textarea[name='reason'],textarea[name='detail']").each(function(index, textarea) {
		var val = $(textarea).val();
		try {
			val = aesUtils.decryptECB(val, encryptionKey);
			if( !isNull(val) ) {
				$(textarea).val(val);
			}
			$(textarea).css("background-color", "#ccc");
			$(textarea).parent().css("background-color", "#ccc");
		} catch(e) {}
	});
}
function disabledEncryptPageText() {
	$("tr[name='node']").each(function(index, tr) {
		var id = $(tr).find("input[name='reimburseAttachId']").val();
		if( !isNull(id) ) {
			$(tr).find("textarea[name='reason']").prop("readonly", true);
			$(tr).find("textarea[name='detail']").prop("readonly", true);
		}
	});
}

function lock() {
	var params = {};
	var reimburseAttachList = getUnLockData();
	params['id'] = $('#id').val();
	params['reimburseAttachList'] = reimburseAttachList;

	$.ajax({
		url: web_ctx+'/manage/finance/reimburs/lock',
		type: 'POST',
		contentType: 'application/json;charset=utf-8;',
		dataType: 'JSON',
		data: JSON.stringify(params),
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert('提示', data.result, 400, function() { refreshPage(); });
			} else {
				bootstrapAlert('提示', data.result, 400, null);
			}
		},
		error: function(err, errMsg) {
			bootstrapAlert('提示', '加密失败，请联系管理员！', 400, null);
		}
	});
}
function getUnLockData() {
	var dataList = [];
	$("tr[name='node']").each(function(index, tr) {
		var data = {};
		data['id'] = $(tr).find("input[name='reimburseAttachId']").val();
		data['reason'] = $(tr).find("textarea[name='reason']").val();
		data['detail'] = $(tr).find("textarea[name='detail']").val();
		
		dataList.push(data);
	});
	
	return dataList;
}
/************* 加解密操作 End **************/


/****************
 *	打印相关 
 ****************/
function print(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/reimburs/print"
	}
	
	window.open( web_ctx + "/activiti/process?" + urlEncode(param) );
}

function exportpdf(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/reimburs/pdf"
	}
	
	window.open( web_ctx + "/activiti/process?" + urlEncode(param) );
}