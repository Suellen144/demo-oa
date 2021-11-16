$(document).ready(function(){
	initData();
	initInputMask();
	inittextarea();
	
	var formData = getFormJson();
	var checkMsg = checkAll(formData);
	if(isNull($("#ceoT").val())){
        $("tbody").find("tr[name='node']").find("input").each(function(index, input) {
            var name = $(input).attr("name");
            if(name == "userScore"|| name == "managerScore"||name == "ceoScore"||name == "ceoPraisedPunished") {
                $(input).attr("readonly","readonly");
            }
        });

        $("tbody").find("tr[name='node']").find("textarea").each(function(index, input) {
            var name = $(input).attr("name");
            if(name == "userEvaluation" || name == "ceoEvaluation" ||name == "managerEvaluation") {
                $(input).attr("readonly","readonly");
            }
        });
	}
});

var userKey = [];
var ceoKey = [];
var marketKey = [] ;
var marketSumKey = [];
var marketPersonalScoreKey = [];
var ceoavgKey = [];
var tr1Key = [];
var tr2Key = [];
function initData() {
	var dataTR="";
	$.ajax({
		url: web_ctx + "/manage/ad/kpi/findDataByDeptId",
		type: "get",
		contentType: "application/json;charset=UTF-8",
		data: {"deptId":$("#companyId").val()},
		dataType: "json",
		async:false,
		success:function(data){
			$.each(data,function(key,val){
				dataTR +='<tr style="background-color:#d2d6de;height:35px;" id="tr1'+key+'">'
					+'<td class="td_weight"><span>部门</span></td>'
					+'<td class="td_weight"><span>姓名</span></td>'
					+'<td class="td_weight"><span>自我评分</span></td>'
					+'<td class="td_weight"><span>自我评价</span></td>'
					+'<td class="td_weight"><span>公司评分</span></td>'
					+'<td class="td_weight"><span>公司评价</span></td>'
					+'<td class="td_weight"><span>公司奖惩</span></td>'
					+'</tr>';
				$.ajax({
					url: web_ctx + "/manage/ad/kpi/findDataByDeptId2",
					type: "get",
					contentType: "application/json;charset=UTF-8",
					data: {"deptId":data[key].id,"date":$("#CollDate").val(),"time":$("#CollTime").val()},
					dataType: "json",
					async:false,
					success:function(data1){
						$.each(data1,function(key1,val1){
							var userEvaluationS = data1[key1].userEvaluation;
							if(isNull(userEvaluationS)) {
								userEvaluationS = "";
							}
							var managerEvaluationS = data1[key1].managerEvaluation;
							if(isNull(managerEvaluationS)) {
                                managerEvaluationS = "";
							}
							dataTR += '<tr name = "node" id = "market'+key+'">'
								+'<input name="Id"  type="hidden" value = "'+(data1[key1].id)+'"readonly>'
								+'<input name="userId"  type="hidden" value = "'+(data1[key1].userId)+'"readonly>'
								+'<input name="kpiId"  type="hidden" value = "'+(data1[key1].kpiId)+'"readonly>'
								+'<input name="dept"  type="hidden" value = "'+(data1[key1].deptId)+'"readonly>'
								+'<input name="attachdate"  type="hidden" value="'+(data1[key1].date)+'" readonly>'
								+'<td style="width:13%;"><input id="deptName" name="deptname"  type="text" value = "'+(data1[key1].deptName)+'"readonly></td>'
								+'<td style="width:7%;"><input id="userName" name="username"  type="text" value = "'+(data1[key1].userName)+'" readonly></td>'
								+'<td style="width:6%;"><input type="text" id="userScore'+key+'" name="userScore" readonly  value="'+(data1[key1].userScore)+'" ></td>'
								+'<td style="width:20%;"><textarea title="'+userEvaluationS+'" id="userEvaluation" name="userEvaluation" readonly style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" >'+userEvaluationS+'</textarea></td>'
								+'<td style="width:6%;"><input id="ceoScore'+key+'" name="ceoScore"  value="'+(data1[key1].ceoScore)+'" type="text" onkeyup="avgcount()" ></td>'
								+'<td style="width:20%;"><textarea title="'+managerEvaluationS+'" id="managerEvaluation" name="managerEvaluation" onclick="inittextarea()" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >'+managerEvaluationS+'</textarea></td>'
								+'<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="'+(data1[key1].ceoPraisedPunished)+'" type="text"  ></td>'
								+'</tr>'
						})
					}
				});
				dataTR += '<tr id="tr2'+key+'">'
					+'<td class="td_weight"><span>部门人数</span></td>'
					+'<td colspan="1"><input id="marketSum'+key+'" name="marketSum'+key+'" type="text"  readonly ></td>'
					+'<td class="td_weight"><span>自评平均分</span></td>'
					+'<td colspan="1"><input id="marketPersonalScore'+key+'" name="marketPersonalScore'+key+'" type="text" readonly ></td>'
					+'<td class="td_weight"><span>公司平均分</span></td>'
					+'<td colspan="2"><input id = "ceoavg'+key+'"  type="text" readonly ></td>'
					+'</tr>'
				userKey.push("userScore"+key) ;
				ceoKey.push("ceoScore"+key) ;
				marketKey.push("market"+key) ;
				marketSumKey.push("marketSum"+key);
				marketPersonalScoreKey.push("marketPersonalScore"+key);
				ceoavgKey.push("ceoavg"+key);
                tr1Key.push("tr1"+key);
                tr2Key.push("tr2"+key);
			})
		}
	});
	dataTR += '<tr>'
		+'<td class="td_weight"><span>公司人数</span></td>'
		+'<td colspan="1"><input id="sumsocre" name="sumsocre" type="text" readonly ></td>'
		+'<td class="td_weight"><span>自评总平均分</span></td>'
		+'<td colspan="1"><input id="personavgscore" name="personavgscore" type="text"  readonly ></td>'
		+'<td class="td_weight"><span>公司总平均分</span></td>'
		+'<td colspan="2"><input id="ceoavgscore" name="ceoavgscore" type="text"  readonly ></td>'
		+'</tr>'
	$("#kpiDate").append(dataTR);
	avgcount();
}


function avgcount(){
	var persontotal = 0;
	var ceototal = 0;
	var persontotalKey = [];
	var ceototalKey = [];
	for(var b = 0;b <userKey.length; b++){
		$(("tr[id="+marketKey[b]+"]")).each(function(index, tr) {
			var userScore = 0
			var userScore2 = parseFloat($(tr).find(("input[id="+userKey[b]+"]")).val());
			if(userScore2 == "null"){
				userScore += 0;
			}else {
				userScore += userScore2;
			}
			var ceoscore = 0;
			var ceoscore2 = parseFloat($(tr).find(("input[id="+ceoKey[b]+"]")).val());
			if(ceoscore2 == "null"){
				userScore += 0;
			}else {
				ceoscore += ceoscore2;
			}
			var person = 0;
			var ceo = 0;
			if(isNull(userScore)){
				person = 0;
			}
			else{
				person = userScore;
			}
			persontotal = digitTool.add(persontotal, parseFloat(person));

			if(isNull(ceoscore)){
				ceo = 0;
			}
			else {
				ceo = ceoscore;
			}
			ceototal = digitTool.add(ceototal, parseFloat(ceo));


		});
		persontotalKey.push(persontotal);
		ceototalKey.push(ceototal);
		persontotal = 0;
		ceototal = 0;
	}

	var person = 0;
	var ceo = 0;
	for(var e = 0;e <marketSumKey.length; e++){
		$("#"+marketSumKey[e]).val($(("tr[id="+marketKey[e]+"]")).length);
		$("#"+ceoavgKey[e]).val(digitTool.divide(ceototalKey[e],$(("tr[id="+marketKey[e]+"]")).length).toFixed(1));
		$("#"+marketPersonalScoreKey[e]).val(digitTool.divide(persontotalKey[e],$(("tr[id="+marketKey[e]+"]")).length).toFixed(1));
		person += persontotalKey[e];
		ceo += ceototalKey[e];
		if($("#"+marketSumKey[e]).val() == 0) {
			$("#"+tr1Key[e]).hide();
            $("#"+tr2Key[e]).hide();
		}
	}
	$("#sumsocre").val($("tr[name='node']").length);
	$("#personavgscore").val(digitTool.divide(person,(($("tr[name='node']").length))).toFixed(1));
	$("#ceoavgscore").val(digitTool.divide(ceo,($("tr[name='node']").length)).toFixed(1));
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
		if(isNull(data["ceoScore"])) {
			checkMsg.push("公司评分不能为空！");
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
		if($("#ceoT").val() == "ceo"){
			bootstrapConfirm("提示", "确定提交吗？", 300, function(){
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
		}else{
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

}



function goBack() {
	window.history.back(-1);
}





