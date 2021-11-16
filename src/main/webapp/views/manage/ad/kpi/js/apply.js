$(document).ready(function(){
	initInputMask();
	inittextarea();
	avgcount();
	
	var formData = getFormJson();
	var checkMsg = checkAll(formData);
	if(!isNull($("#status").val())){ 
		$("#apprve_btn").remove();
		$("#save_btn").remove();
		$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
			var name = $(input).attr("name");
			if(name == "userScore"|| name == "managerScore"||name == "ceoScore"||name == "ceoPraisedPunished") {
				$(input).attr("readonly","readonly");
			}
		});

		$("tbody").find("tr[name='node']").find("textarea").each(function(index, input) {
			var name = $(input).attr("name");
			if(name == "userEvaluation" || name == "managerEvaluation"|| name == "ceoEvaluation") {
				$(input).attr("readonly","readonly");
			}
			
		});
	}
	

});


function avgcount(){
	var total1 = 0;
	var persontotal1 = 0;
	var ceototal1 = 0;
	var total2 = 0;
	var persontotal2 = 0;
	var ceototal2 = 0;
	var total3 = 0;
	var persontotal3 = 0;
	var ceototal3 = 0;
	var total4 = 0;
	var persontotal4 = 0;
	var ceototal4 = 0;
	var total5 = 0;
	var persontotal5 = 0;
	var ceototal5 = 0;
	var i = 0;
	var i1= 0;
	var i2 = 0;
	var j = 0;
	var j1 = 0;
	var j2 = 0;
	var k = 0;
	var k1 = 0;
	var k2 =0;
	var l = 0;
	var l1 = 0;
	var l2 = 0;

	$("tr[id='market']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		var person = 0;
		var ceo = 0;
		if(isNull(userScore)){
			person = 0;
			i++
		}
		else{
			person = userScore;
		}
		persontotal1 = digitTool.add(persontotal1, parseFloat(person));
		
		if(isNull(managerscore)){
					value = 0;
					i1++;
		}
		else {
				value = managerscore;
		}
		total1 = digitTool.add(total1, parseFloat(value));
		
		if(isNull(ceoscore)){
					ceo = 0;
					i2++;
		}
		else {
				ceo = ceoscore;
		}
		ceototal1 = digitTool.add(ceototal1, parseFloat(ceo));
		
	});
	
	$("tr[id='develop']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		var person = 0;
		
		if(isNull(userScore)){
			person = 0;
			j++
		}
		else{
			person = userScore;
		}
		persontotal2 = digitTool.add(persontotal2, parseFloat(person));
		
			if(isNull(managerscore)){
					value = 0;
					j1++;
			}
			else {
				value = managerscore;
			}
			total2 = digitTool.add(total2, parseFloat(value));
		


		if (isNull(ceoscore)) {
			ceo = 0;
			j2++;
		} else {
			ceo = ceoscore;
		}
		ceototal2 = digitTool.add(ceototal2, parseFloat(ceo));
		
	});
	
	$("tr[id='engineer']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		
		var person = 0;
		
		if(isNull(userScore)){
			person = 0;
			k++;
		}
		else{
			person = userScore;
		}
		persontotal3 = digitTool.add(persontotal3, parseFloat(person));
		
			if(isNull(managerscore)){
					value = 0;
					k1++;
			}
			else {
				value = managerscore;
			}
			total3 = digitTool.add(total3, parseFloat(value));
		
			
			if (isNull(ceoscore)) {
				ceo = 0;
				k2++;
			} else {
				ceo = ceoscore;
			}
			ceototal3 = digitTool.add(ceototal3, parseFloat(ceo));
	});
	
	$("tr[id='admin']").each(function(index, tr) {
		var userScore = $(tr).find("input[name='userScore']").val();
		var managerscore = $(tr).find("input[name='managerScore']").val();
		var ceoscore = $(tr).find("input[name='ceoScore']").val();
		var value= 0;
		var person = 0;
		var ceo = 0;
		
		if(isNull(userScore)){
			person = 0;
			l++;
		}
		else{
			person = userScore;
		}
		persontotal4 = digitTool.add(persontotal4, parseFloat(person));
		
		if(isNull(managerscore)){
			value = 0;
			l1++;
		}
		else {
				value = managerscore;
			}
		
		total4 = digitTool.add(total4, parseFloat(value));
		
		if (isNull(ceoscore)) {
			ceo = 0;
			l2++;
		} else {
			ceo = ceoscore;
		}
		ceototal4 = digitTool.add(ceototal4, parseFloat(ceo));
		
	});
	$("#marketSum").val($("tr[id='market']").length);
	if( $("tr[id='market']").length - i1 == 0){
		$("#marketScore").val("0");
	}
	else {
		$("#marketScore").val(digitTool.divide(total1,(($("tr[id='market']").length)-i1)).toFixed(1));
	}
	if( $("tr[id='market']").length - i2 == 0){
		$("#ceoavg1").val("0");
	}
	else{
		$("#ceoavg1").val(digitTool.divide(ceototal1,($("tr[id='market']").length-i2)).toFixed(1));
	}
	if( $("tr[id='market']").length - i == 0){
		$("#marketPersonalScore").val("0");
	}
	else{
		$("#marketPersonalScore").val(digitTool.divide(persontotal1,(($("tr[id='market']").length)-i)).toFixed(1));
	}
	$("#developSum").val($("tr[id='develop']").length);
	if( $("tr[id='develop']").length - j1 == 0){
		$("#developScore").val("0");
	}
	else{
		$("#developScore").val(digitTool.divide(total2,(($("tr[id='develop']").length)-j1)).toFixed(1));
	}
	if( $("tr[id='develop']").length - j == 0){
		$("#developPersonalScore").val("0");
	}
	else{
		$("#developPersonalScore").val(digitTool.divide(persontotal2,(($("tr[id='develop']").length)-j)).toFixed(1));
	}
	
	if( $("tr[id='develop']").length - j2 == 0){
		$("#ceoavg3").val("0");
	}
	else{
		$("#ceoavg3").val(digitTool.divide(ceototal2,($("tr[id='develop']").length-j2)).toFixed(1));


	}
	
	$("#engineerSum").val($("tr[id='engineer']").length);
	if( $("tr[id='engineer']").length - k1 == 0){
		$("#engineerScore").val("0");
	}
	else{
		$("#engineerScore").val(digitTool.divide(total3,(($("tr[id='engineer']").length)-k1)).toFixed(1));
	}
	
	if( $("tr[id='engineer']").length - k == 0){
		$("#engineerPersonalScore").val("0");
	}
	else{
		$("#engineerPersonalScore").val(digitTool.divide(persontotal3,(($("tr[id='engineer']").length)-k)).toFixed(1));
	}
	
	if( $("tr[id='engineer']").length - k2 == 0){
		$("#ceoavg2").val("0");
	}
	else{
		$("#ceoavg2").val(digitTool.divide(ceototal3,($("tr[id='engineer']").length-k2)).toFixed(1));
	}
	
	$("#adminSum").val($("tr[id='admin']").length);
	if( $("tr[id='admin']").length - l1 == 0){
		$("#adminScore").val("0");
	}
	else{
		$("#adminScore").val(digitTool.divide(total4,(($("tr[id='admin']").length)-l1)).toFixed(1));
	}
	
	if( $("tr[id='admin']").length - l == 0){
		
	}
	else{
		$("#adminPersonalScore").val(digitTool.divide(persontotal4,(($("tr[id='admin']").length)-l)).toFixed(1));
	}

	if( $("tr[id='admin']").length - l2 == 0){
		$("#ceoavg4").val("0");
	}
	else{
		$("#ceoavg4").val(digitTool.divide(ceototal4,($("tr[id='admin']").length-l2)).toFixed(1));
	}
	var person = digitTool.add(digitTool.add(persontotal1,persontotal2),digitTool.add(persontotal3,persontotal4));
	var manager = digitTool.add(digitTool.add(total1,total2),digitTool.add(total3,total4));
	var ceo = digitTool.add(digitTool.add(ceototal1,ceototal2),digitTool.add(ceototal3,ceototal4));
	var length = digitTool.add(digitTool.add(i,j),digitTool.add(k,l));
	var length1  = digitTool.add(digitTool.add(i1,j1),digitTool.add(k1,l1));
	var length2  = digitTool.add(digitTool.add(i2,j2),digitTool.add(k2,l2));
	$("#sumsocre").val($("tr[name='node']").length);
	$("#personavgscore").val(digitTool.divide(person,(($("tr[name='node']").length) - length)).toFixed(1));
	$("#ceoavgscore").val(digitTool.divide(ceo,(($("tr[name='node']").length) - length2)).toFixed(1));
	$("#manageravgscore").val(digitTool.divide(manager,(($("tr[name='node']").length) - length1)).toFixed(1));
 	
}




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



function toshow(){
	window.location.href = "toShow";
}



function inittextarea(){
	/*autosize(document.querySelectorAll('textarea'));*/
}


function getFormJson() {	
	var json = $("#form").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["kpiAttachsList"] = [];
	$("tbody").find("tr[name = 'node']").each(function(index, tr){
		var userId = $(this).find("input[name='userId']").val(); 
		var id = $(this).find("input[name='Id']").val(); 
		var deptId = $(this).find("input[name='dept']").val(); 
		var userName = $(this).find("input[name='username']").val(); 
		var deptName = $(this).find("input[name='deptname']").val(); 
		var kpiId =  $(this).find("input[name='kpiId']").val(); 
		var date = $(this).find("input[name='attachdate']").val();
		var userScore = $(this).find("input[name='userScore']").val(); 
		var userEvaluation = $(this).find("textarea[name='userEvaluation']").val(); 
		var managerScore = $(this).find("input[name='managerScore']").val();
		var managerEvaluation = $(this).find("textarea[name='managerEvaluation']").val(); 
		var ceoScore =  $(this).find("input[name='ceoScore']").val(); 
		var ceoPraisedPunished =  $(this).find("input[name='ceoPraisedPunished']").val(); 
		
		var data = {};
		data["id"] = id;
		data["userId"] = userId;
		data["deptId"] = deptId;
		data["date"] = date;
		data["kpiId"] = kpiId;
		data["userName"] = userName;
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
		if(data["ceoScore"] > 100 || data["managerScore"] > 100){
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
			checkMsg.push("部门评分不能为空！");
			return false;
		}
		if(data["ceoScore"] > 100 || data["managerScore"] > 100){
			checkMsg.push("评分不能超过100！");
			return false;
		}
	});
	return checkMsg;
}


function save() {
		var formData = getFormJson();
		var checkMsg = checkForm(formData);
		if(!isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
			return ;
		}
		else{
		$.ajax({
			url: "saveall",
			type: "post",
			contentType: "application/json;charset=UTF-8",
			data: JSON.stringify(formData),
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
	var formData = getFormJson();
	var checkMsg = checkAll(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	else{
	bootstrapConfirm("提示", "当前考核提交后不可更改，确定提交吗？", 300, function(){
	$.ajax({
		url: "approve",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
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



function goBack() {
	window.history.back(-1);
}





