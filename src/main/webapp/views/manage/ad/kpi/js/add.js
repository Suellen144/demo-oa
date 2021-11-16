$(document).ready(function(){
	$("#userScore").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	inittextarea();
	if($("#status").val() != "" || !isNull($("#status").val())){
		$("#userScore").attr("readonly","readonly");
		$("#userEvaluation").attr("readonly","readonly");
		$("#save_btn")[0].style.display = "none";
		$("#approve_btn")[0].style.display = "none";
	}
});


function toShow(){
	window.location.href = "toShow";
}


function getFormJson() {	
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["kpiAttachsList"] = [];
	$("tbody").each(function(index, tr){
		var userId = $(this).find("input[name='userId']").val(); 
		var deptId =  $(this).find("input[name='deptId']").val(); 
		var status =  $(this).find("input[name='status']").val(); 
		var userScore = $(this).find("input[name='userScore']").val(); 
		var userEvaluation = $(this).find("textarea[name='userEvaluation']").val(); 
		var managerScore = $(this).find("input[name='managerScore']").val();
		var managerEvaluation = $(this).find("textarea[name='managerEvaluation']").val(); 
		var ceoScore =  $(this).find("textarea[name='ceoScore']").val(); 
		var ceoPraisedPunished =  $(this).find("input[name='ceoPraisedPunished']").val(); 
		
		var data = {};
		data["userId"] = userId;
		data["deptId"] = deptId;
		data["status"] = status;
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
	var text = [];
	$(formData).each(function(index,ele){		
		 if(isNull(ele.userEvaluation)){
				text.push("必须填写自我评价！<br/>");
		}
		if(isNull(ele.userScore)){     
				text.push("必须填写自评分！<br/>");         
		}
		if(ele.userScore >100){
			text.push("评分不允许大于100！<br/>");      
		}
	});
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}


function save() {
		var formData = getFormJson();
		if(!checkForm(formData)) {
			return ;
		}
		$.ajax({
			url: "save",
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


function approve() {
	if(!checkForm(getFormJson())) {
		return ;
	}
	$("#status").val("1");	
	bootstrapConfirm("提示", "当前自我考核提交后不可更改，确定提交吗？", 300, function(){
	$.ajax({
		url: "save",
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



function goBack() {
	window.history.back(-1);
}





