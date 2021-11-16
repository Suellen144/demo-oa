$(document).ready(function(){

	inittextarea();
	initInputMask();
	avgcount();
	if($("#status").val() == 1 || $("#status").val() == 2 ||$("#status").val() == 3){
		$("#save_btn")[0].style.display = "none";
		$("#approve_btn")[0].style.display = "none";
		$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
			var name = $(input).attr("name");
			if(name == "userScore"|| name == "managerScore" || name == "ceoScore") {
				$(input).attr("readonly","readonly");
			}
		});
		
		$("tbody").find("tr[name='node']").find("textarea").each(function(index, input) {
			var name = $(input).attr("name");
			if(name == "userEvaluation" || name == "managerEvaluation") {
				$(input).attr("readonly","readonly");
			}
			
		});
	}
	$("#managerTime").val(new Date().pattern("yyyy-MM-dd"));
});

function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "userScore" || name == "managerScore" || name == "ceoScore") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
		}
		
		if(name == "ceoPraisedPunished"){
			$(input).inputmask("Regex", { regex: "^-?\\d+$" });
		}
		
	});
}


function avgcount(){
	var total = 0;
	var persontotal = 0;
	var i = 0;
	var j = 0;
	$("tr[name='node']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		var person = 0;
		if(isNull(userScore)){
			person = 0;
			i++;
		}
		else{
			person = userScore;
		}
		persontotal = digitTool.add(persontotal, parseFloat(person));
		
			if(isNull(ceoscore)){
					value = 0;
					j++;
			}
			else {
				value = ceoscore;
			}
			total = digitTool.add(total, parseFloat(value));
		
	});
	if(($("tr[name='node']").length - j) ==0){
		$("#avagScore").val("0");
	}
	else{
		$("#avagScore").val(digitTool.divide(total,(($("tr[name='node']").length) - j)).toFixed(1));
	}

	$("#number").val(($("tr[name='node']")).length);
	if(($("tr[name='node']").length - i) ==0){
		$("#personavgScore").val("0");
	}
	else{
		$("#personavgScore").val(digitTool.divide(persontotal,(($("tr[name='node']").length) - i)).toFixed(1));
	}

}


function getFormJson() {	
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["kpiAttachsList"] = [];
	$("tbody").find("tr[name = 'node']").each(function(index, tr){
		var attachId = $(this).find("input[name='attachId']").val(); 
		var userId = $(this).find("input[name='userId']").val(); 
		var deptId = $(this).find("input[name='dept']").val(); 
		var userName = $(this).find("input[name='username']").val(); 
		var deptName = $(this).find("input[name='deptname']").val();
		var userTime = $(this).find("input[name='userTime']").val();
		var kpiId =  $(this).find("input[name='kpiId']").val(); 
		var date = $(this).find("input[name='attachdate']").val();
		var userScore = clearZero($(this).find("input[name='userScore']").val()); 
		var userEvaluation = $(this).find("textarea[name='userEvaluation']").val(); 
		var managerScore = clearZero($(this).find("input[name='managerScore']").val());
		var managerEvaluation = $(this).find("textarea[name='managerEvaluation']").val(); 
		var ceoScore = clearZero( $(this).find("input[name='ceoScore']").val()); 
		var ceoPraisedPunished =  $(this).find("input[name='ceoPraisedPunished']").val(); 
		var data = {};
		data["id"] = attachId;
		data["userId"] = userId;
		data["deptId"] = deptId;
		data["date"] = date;
		data["kpiId"] = kpiId;
		data["userName"] = userName;
		data["userTime"] = userTime;
		data["deptName"] = deptName;
		data["userScore"] = userScore;
		data["userEvaluation"] = userEvaluation;
		data["managerScore"] = managerScore;
		data["managerEvaluation"] = managerEvaluation;
		data["ceoScore"] = ceoScore;
		data["ceoPraisedPunished"] = ceoPraisedPunished;
		
		formData["kpiAttachsList"].push(data);
	});
	
	return formData;
}


function checkForm(formData) {
	var checkMsg = [];
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(data["ceoScore"] > 100){
			checkMsg.push("评分不能超过100！");
			return false;
		}
	});
	return checkMsg;
}


function checkAll(formData) {
	var checkMsg = [];
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(isNull(data["ceoScore"])) {
			checkMsg.push("部门评分不能为空！");
			return false;
		}
		else if(data["ceoScore"] > 100){
			checkMsg.push("部门评分不能超过100！");
			return false;
		}
	});
	$(formData["kpiAttachsList"]).each(function(index, data) {
		if(isNull(data["managerEvaluation"])) {
			checkMsg.push("部门评价不能为空！");
			return false;
		}
	});
	if(isNull($("#userScore1").val())) {
		checkMsg.push("自我评分不能为空！");
	} else if($("#userScore1").val() > 100){
		checkMsg.push("自我评分不能超过100！");
	}
	if(isNull($("#userEvaluation1").val())) {
		checkMsg.push("自我评价不能为空！");
	}
	return checkMsg;
}

function toshow(){
	window.location.href = "toShow";
}


function inittextarea(){
	/*autosize(document.querySelectorAll('textarea'));*/
	autosize($(".textarea"));
}


function showAll() {
    window.location.href = "showAll";
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
			url: "update",
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
		}
}


function approve() {
	var checkMsg = checkAll(getFormJson());
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	else {
	bootstrapConfirm("提示", "考核提交后无法再次修改，确定提交吗？", 300, function(){
	$("#status").val("1");
	$.ajax({
		url: "update",
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





