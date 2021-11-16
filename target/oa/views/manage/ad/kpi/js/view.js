$(document).ready(function(){

	inittextarea();
	initInputMask();
	avgcount();
	
	$("tr[name='node']").each(function(index, tr) {
		var score = $(tr).find("input[name='userScore']").val();
		if($(tr).find("input[name='managerScore']").val() == null || $(tr).find("input[name='managerScore']").val() == "" ){
			$(tr).find("input[name='managerScore']").val(score);
			$(tr).find("input[name='managerScore']").val(score);
		}	
	});
	
	if($("#status").val() == 1){
		$("#myScore").attr("readonly","readonly");
		$("#myEvaluation").attr("readonly","readonly");
		$("#save_btn")[0].style.display = "none";
		$("#approve_btn")[0].style.display = "none";
	}
	
});

function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "userScore" || name == "managerScore" || name == "ceoScore") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
		}
		
	});
}


function avgcount(){
	var total = 0;
	$("tr[name='node']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		if(isNull(ceoscore)){
			if(isNull(managerscore)){
				if(isNull(userScore)){
					value = 0;
				}
				else {
					value = userScore;
				}
			}
			else {
				value = managerscore;
			}
			total = digitTool.add(total, parseFloat(value));
		}
		else{
			value = ceoscore;
			total = digitTool.add(total, parseFloat(value));
		}
		
	});
	$("#avagScore").val((total/($("tr[name='node']").length)).toFixed(1));
	
}


function getFormJson() {	
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["kpiAttachsList"] = [];
	$("tbody").find("tr[name = 'node']").each(function(index, tr){
		var attachId = $(this).find("input[name='attachId']").val(); 
		var status = 1;
		var userId = $(this).find("input[name='userId']").val(); 
		var deptId = $(this).find("input[name='dept']").val(); 
		var userName = $(this).find("input[name='username']").val(); 
		var deptName = $(this).find("input[name='deptname']").val(); 
		var kpiId =  $(this).find("input[name='kpiId']").val(); 
		var date = $(this).find("input[name='attachdate']").val();
		var userScore = clearZero($(this).find("input[name='userScore']").val()); 
		var userEvaluation = $(this).find("textarea[name='userEvaluation']").val(); 
		
		var data = {};
		data["id"] = attachId;
		data["userId"] = userId;
		data["deptId"] = deptId;
		data["date"] = date;
		data["status"] = status;
		data["kpiId"] = kpiId;
		data["userName"] = userName;
		data["deptName"] = deptName;
		data["userScore"] = userScore;
		data["userEvaluation"] = userEvaluation;
		
		formData["kpiAttachsList"].push(data);
	});
	
	return formData;
}


function getJson() {	
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["kpiAttachsList"] = [];
	$("tbody").find("tr[name = 'node']").each(function(index, tr){
		var attachId = $(this).find("input[name='attachId']").val(); 
		var userId = $(this).find("input[name='userId']").val(); 
		var deptId = $(this).find("input[name='dept']").val(); 
		var userName = $(this).find("input[name='username']").val(); 
		var deptName = $(this).find("input[name='deptname']").val(); 
		var kpiId =  $(this).find("input[name='kpiId']").val(); 
		var date = $(this).find("input[name='attachdate']").val();
		var userScore = clearZero($(this).find("input[name='userScore']").val()); 
		var userEvaluation = $(this).find("textarea[name='userEvaluation']").val(); 
		
		var data = {};
		data["id"] = attachId;
		data["userId"] = userId;
		data["deptId"] = deptId;
		data["date"] = date;
		data["kpiId"] = kpiId;
		data["userName"] = userName;
		data["deptName"] = deptName;
		data["userScore"] = userScore;
		data["userEvaluation"] = userEvaluation;
		
		formData["kpiAttachsList"].push(data);
	});
	
	return formData;
}


function checkForm(formData) {
	var checkMsg = [];
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(data["managerScore"] > 100){
			checkMsg.push("评分不能超过100！");
			return false;
		}
	});
	return checkMsg;
}


function checkAll(formData) {
	var checkMsg = [];
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(isNull(data["managerScore"])) {
			checkMsg.push("经理评分不能为空！");
			return false;
		}
		else if(data["managerScore"] > 100){
			checkMsg.push("评分不能超过100！");
			return false;
		}
	});
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(isNull(data["managerEvaluation"])) {
			checkMsg.push("经理评价不能为空！");
			return false;
		}
	});
	return checkMsg;
}

function toshow(){
	window.location.href = "toShow";
}


function inittextarea(){
	/*autosize(document.querySelectorAll('textarea'));*/
	autosize($(".textarea"));
}




function save() {
		var formData = getFormJson();
		var checkMsg = checkForm(formData);
		if(!isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
			return ;
		}
		else {
		$.ajax({
			url: "saveone",
			type: "post",
			contentType: "application/json;charset=UTF-8",
			data: JSON.stringify(getJson()),
			dataType: "json",
			success:function(data){
				window.location.href = "toList";
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		}
}


function approve() {
	var checkMsg = checkForm(getFormJson());
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	else {
	bootstrapConfirm("提示", "考核提交后无法再次修改，确定提交吗？", 300, function(){
	$.ajax({
		url: "saveone",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(getFormJson()),
		dataType: "json",
		success:function(data){
			window.location.href = "toList";
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	}, null);
	}
}




var suffixZero = /.*\.0$/;
function clearZero(value) {
	if(suffixZero.test(value)) {
		return value.replace(".0", "");
	} else {
		return value;
	}
}



function goBack() {
	window.history.back(-1);
}





