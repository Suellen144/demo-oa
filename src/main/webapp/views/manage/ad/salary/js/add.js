$(function() {
	initDecryption();
	$("tr[name='node']").each(function(index, tr){
		$(tr).find("input[name='number']").val(index+1);
	});
	 initInputMask();
	 initdate();
	 
	 //初始化在职状态
	 initWorkingState();
	 
	 //初始化页面数据
 	 initAddData();
});

function initWorkingState(){
	$.ajax({
	    url:base + "/manage/ad/salary/workingStateselectVal",
	    type: "get",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	    	$("#workingStateselectVal").append('<option value="">' + "请选择" + '</option>');
	        //请求成功时
	    	$.each(result,function(key,val){
	    	    $("#workingStateselectVal").append('<option value="'+(result[key].value)+'">'+(result[key].name)+'</option>');
	    	});
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	})
}

function selectWorkingState(obj){
	/*var url=base + "/manage/ad/salary/toAdd?selectVal="+$(obj).val();
	window.location.href=url;*/
	$.ajax({
	    url:base + "/manage/ad/salary/initAddPageData",
	    type: "get",
	    data:{"selectVal":$(obj).val()},
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	    	$("#tbodyInfo").html("");
	    	var dataTR="";
	    	var index=0;
	    	$.each(result,function(key,val){
	    		dataTR='<tr name = "node">'
	    			+'<td style="width:3%;"><input  type="text" name ="number" value = "'+(index+1)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.dept+'" readonly></td>'
	    			+'<input name="AttachuserId"  type="hidden" value = "'+result[key].record.userId+'" readonly>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.name+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.position+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value="'+fmtDate(result[key].record.entryTime)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" name="salary" value = "'+(result[key].salary==null?"":result[key].salary.salary)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  name="score" type="text"  value="'+keepTwoDecimal(result[key].record.score==null?"":result[key].record.score)+'" readonly></td>'
	    			+'<td style="width:7%;"><input type="text" name="lastdate"	value="" readonly></td>'
	    			+'<td style="width:6%;"><input type="text" name="lastproportion"	value="" readonly></td>'
	    			+'<td style="width:7%;"><input  name="personAmplitude" readonly  type="text" value = "'+(result[key].personAmplitude==null?"":result[key].personAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="manageAmplitude"  readonly type="text" value = "'+(result[key].manageAmplitude==null?"":result[key].manageAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="finallyAmplitude"  type="text" onkeyup="countmoney()" value = "'+(result[key].finallyAmplitude==null?"":result[key].finallyAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="finallySalary"  type="text" value = "'+(result[key].finallySalary==null?"":result[key].finallySalary)+'"></td>'
	    			+'<td style="width:7%;"><input  name="remark"  type="text" value = "'+(result[key].remark==null?"":result[key].remark)+'"></td>'
	    			+'</tr>'
	    		$("#tbodyInfo").append(dataTR);	
	    		index++;
	    	});
	    	
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	})
}

function initAddData(){
	$.ajax({
	    url:base + "/manage/ad/salary/initAddPageData",
	    type: "get",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	    	$("#tbodyInfo").html("");
	    	var dataTR="";
	    	var index=0;
	    	$.each(result,function(key,val){
	    		dataTR='<tr name = "node">'
	    			+'<td style="width:3%;"><input  type="text" name ="number" value = "'+(index+1)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.dept+'" readonly></td>'
	    			+'<input name="AttachuserId"  type="hidden" value = "'+result[key].record.userId+'" readonly>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.name+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value = "'+result[key].record.position+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" value="'+fmtDate(result[key].record.entryTime)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  type="text" name="salary" value = "'+(result[key].salary==null?"":result[key].salary.salary)+'" readonly></td>'
	    			+'<td style="width:7%;"><input  name="score" type="text"  value="'+keepTwoDecimal(result[key].record.score==null?"":result[key].record.score)+'" readonly></td>'
	    			+'<td style="width:7%;"><input type="text" name="lastdate"	value="" readonly></td>'
	    			+'<td style="width:6%;"><input type="text" name="lastproportion"	value="" readonly></td>'
	    			+'<td style="width:7%;"><input  name="personAmplitude" readonly  type="text" value = "'+(result[key].personAmplitude==null?"":result[key].personAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="manageAmplitude"  readonly type="text" value = "'+(result[key].manageAmplitude==null?"":result[key].manageAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="finallyAmplitude"  type="text" onkeyup="countmoney()" value = "'+(result[key].finallyAmplitude==null?"":result[key].finallyAmplitude)+'"></td>'
	    			+'<td style="width:7%;"><input  name="finallySalary"  type="text" value = "'+(result[key].finallySalary==null?"":result[key].finallySalary)+'"></td>'
	    			+'<td style="width:7%;"><input  name="remark"  type="text" value = "'+(result[key].remark==null?"":result[key].remark)+'"></td>'
	    			+'</tr>'
	    		$("#tbodyInfo").append(dataTR);	
	    		index++;
	    	});
	    	
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	})
}


function fmtDate(obj){
    var date =  new Date(obj);
    var y = 1900+date.getYear();
    var m = "0"+(date.getMonth()+1);
    var d = "0"+date.getDate();
    return y+"-"+m.substring(m.length-2,m.length)+"-"+d.substring(d.length-2,d.length);
}

//四舍五入保留1位小数
function keepTwoDecimal(num) {
  var result = parseFloat(num);
  if (isNaN(result)) {
    return "";
  }
  result = Math.round(num * 10) / 10;
  return result;
}

function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "personAmplitude" || name == "manageAmplitude" || name == "finallyAmplitude") {
			$(input).inputmask("Regex", { regex: "(100|([1-9]?[0-9]?))%" });
		}
	});
}


function initdate() {
    $("tr[name='node']").each(function(index, tr){
        var id = $(tr).find("input[name='AttachuserId']").val();
		if(id == 43 || id == 44 || id == 56 || id == 3 || id == 5 || id == 8){
            $(tr).find("input[name='lastdate']").val("2017-08-14");
		}
		if(id == 43){
            $(tr).find("input[name='lastproportion']").val("6");
		}
        if(id == 44){
            $(tr).find("input[name='lastproportion']").val("30");
        }
        if(id == 56){
            $(tr).find("input[name='lastproportion']").val("50");
        }
        if(id == 3){
            $(tr).find("input[name='lastproportion']").val("47");
        }
        if(id == 5){
            $(tr).find("input[name='lastproportion']").val("25");
        }
        if(id == 8){
            $(tr).find("input[name='lastproportion']").val("14");
        }
    });

}


function save() {
		var checkMsg ={};
		var formData = getFormData();
		checkMsg = checkForm(formData);
		if(!isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
			return ;
		}
		else{
			openBootstrapShade(true);
			submitForm(formData);
		}
	
		
}


function countmoney(){
    $("tr[name='node']").each(function(index, tr) {
        var val = rmoney($(tr).find("input[name='salary']").val());
        var temp1 = $(tr).find("input[name='finallyAmplitude']").val();
        var percent = 1+$(tr).find("input[name='finallyAmplitude']").val()/100;
        $(tr).find("input[name='salary']").val(fmoney($(tr).find("input[name='salary']").val()));
        if(percent == '1' && temp1 != '0'){
            percent = 1+$(tr).find("input[name='manageAmplitude']").val()/100;
            if(percent == '1'){
                percent = 1+$(tr).find("input[name='personAmplitude']").val()/100;
            }
        }
        try {
            var count = val*percent;
            if(isNaN(count) || isNull(count)){
                count = "";
            }
            $(tr).find("input[name='finallySalary']").val(fmoney(((count.toFixed(0)/100).toFixed(0)*100)));
        } catch(e) {}
    });

    count();
}

function count(){
    var temp = 0 ;
    var sum = 0;
    $("tr[name='node']").each(function(index, tr) {
        var val = rmoney($(tr).find("input[name='salary']").val());
        temp  = digitTool.add(temp,val);
        $("#sumsalary").val(fmoney(temp,0));
        $("#avgsalary").val(fmoney(digitTool.divide(temp ,$("tr[name='node']").length).toFixed(0)));

        var val2 = rmoney($(tr).find("input[name='finallySalary']").val());
        sum =  digitTool.add(sum,val2);
        $("#finsumsalary").val(fmoney(sum,0));
        $("#finavgsalary").val(fmoney(digitTool.divide(sum,$("tr[name='node']").length).toFixed(0)));
    });

}


/************* 加解密操作 Begin **************/
//如果有解密权限，则解密当前已加密的数据
function initDecryption() {
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
                            countmoney();
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



function encryptPageText(encryptionKey) {
	$("input[name='salary']").each(function(index, input) {
		var val = $(input).val();
		try {
			val = aesUtils.decryptECB(val, encryptionKey);
			if( !isNull(val) ) {
				$(input).val(val);
			}
		} catch(e) {}
	});
}

function disabledEncryptPageText() {
	$("tr[name='node']").each(function(index, tr) {
			$(tr).find("input[name='salary']").prop("readonly", true);
	});
}


function submitForm(formData) {
	$.ajax({
		url: "save",
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

function checkForm(formData) {
	var checkMsg = [];
	$(formData["salaryAttachList"]).each(function(index, data) {
		 var patt = new RegExp(/^\d+%$/);
		if(!isNull(data["personAmplitude"]) && !patt.test(data["personAmplitude"])){
			checkMsg.push("请输入正确的百分比个人期望幅度值！");
		}
		if(!isNull(data["manageAmplitude"]) && !patt.test(data["manageAmplitude"])){
			checkMsg.push("请输入正确的百分比部门建议幅度值！");
		}
		if(!isNull(data["finallyAmplitude"]) && !patt.test(data["finallyAmplitude"])){
			checkMsg.push("请输入正确的百分比最终幅度值！");
		}
		return checkMsg;
	});
}

function getFormData(){
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["salaryAttachList"] = [];
	$("tbody").find("tr[name='node']").each(function(index, tr){
		var userId = $(this).find("input[name='AttachuserId']").val();
		var deptId = $(this).find("input[name='deptId']").val();
		var personAmplitude = $(this).find("input[name='personAmplitude']").val();
		var manageAmplitude = $(this).find("input[name='manageAmplitude']").val();
		var lastdate = $(this).find("input[name='lastdate']").val();
		var finallyAmplitude = $(this).find("input[name='finallyAmplitude']").val();
		var finallySalary = $(this).find("input[name='finallySalary']").val();
		var score = $(this).find("input[name='score']").val();
		
		// 其中一个有值就算有效表单数据
		if(!isNull(userId) || !isNull(deptId)
				|| !isNull(personAmplitude) || !isNull(manageAmplitude) 
				|| !isNull(lastdate) || !isNull(finallyAmplitude)
				|| !isNull(finallySalary)|| !isNull(score)) {
			var data = {};
			data["userId"] = userId;
			data["deptId"] = deptId;
			data["personAmplitude"] = personAmplitude;
			data["manageAmplitude"] = manageAmplitude;
			data["lastdate"] = lastdate;
			data["finallyAmplitude"] = finallyAmplitude;
			data["finallySalary"] = finallySalary;
			data["finallySalary"] = finallySalary;
			data["score"] = score;
			
			formData["salaryAttachList"].push(data);
		}
		
	});
	
	return formData;
}


function fmoney(s, n) {
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(0) + "";
    var l = s.split(".")[0].split("").reverse(), r = s.split(".")[1];
    t = "";
    for (i = 0; i < l.length; i++) {
        t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
    }
    return t.split("").reverse().join("");
}


function rmoney(s)
{
    return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

