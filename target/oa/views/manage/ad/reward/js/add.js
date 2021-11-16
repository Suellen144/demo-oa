$(function() {
	initDecryption();
    var now = new Date().getTime();
	$("tr[name='node']").each(function(index, tr){
		$(tr).find("input[name='number']").val(index+1);
        var entrytime = new Date($(tr).find("input[name='entrytime']").val()).getTime();
        var date3 = now - entrytime;
        var days=Math.floor(date3/(24*3600*1000))
		if(days < 90){
           $(tr).find("input[name='name']").parent().parent().find('input').css("background-color", "#d2d6de").attr('disabled','disabled');
		}
	});


  /*  var date3= now - oldTime  //时间差的毫秒数
    var days=Math.floor(date3/(24*3600*1000))
	console.log(days);*/
});


function save() {
		var checkMsg ={};
		var formData = getFormData();
	/*	checkMsg = checkForm(formData);
		if(!isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
			return ;
		}
		else{*/
			openBootstrapShade(true);
			submitForm(formData);
/*		}*/
	
		
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
							boot = true;
							var tempKey = data.result;
							var encryptionKey = aesUtils.decryptECB(tempKey, now);
							encryptPageText(encryptionKey);
                            $("tr[name='node']").each(function(index, tr){
                            	if($(tr).find("input[name='salary']").val() != null && $(tr).find("input[name='salary']").val() != ""){
                                    $(tr).find("input[name='salary']").val(fmoney($(tr).find("input[name='salary']").val(),2));
								}
                            });
                            /*decryptNumber();*/
                            /*countmoney();*/
                            Amount();
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
			/*$(input).css("background-color", "#ccc");
			$(input).parent().css("background-color", "#ccc");*/
		} catch(e) {}
	});
}

function disabledEncryptPageText() {
	$("tr[name='node']").each(function(index, tr) {
			$(tr).find("input[name='salary']").prop("readonly", true);
	});
}


function countmoney(obj){
	var index = $(obj).parent().parent().attr('data-i')
	
    $("tr[name='node']").each(function(index, tr) {
        var val = rmoney($(tr).find("input[name='salary']").val());
        var percent = $(tr).find("input[name='coefficient']").val();
        
        try {
            var count = val*percent;
            if(isNaN(count) || isNull(count)){
                count = 0;
            }
            $(tr).find("input[name='money']").val(fmoney(count,2));
            $(tr).find("input[name='coefficient']").val(parseInt(percent.length>0 ? percent : 0))
            
            
            countAll();
        } catch(e) {}
    });
}

function countAll() {
    $("tr[name='node']").each(function(index, tr){
    var money = rmoney($(tr).find("input[name='money']").val());
    var businessreward = $(tr).find("input[name='businessreward']").val();
    var otherreward = $(tr).find("input[name='otherreward']").val();
    var temp = $(tr).find("input[name='totalreward']").val(parseFloat(money)+parseFloat(businessreward)+parseFloat(otherreward));
    if(!isNull(temp) && !isNaN(temp)){
        $(tr).find("input[name='totalreward']").val(fmoney(temp,2));
    }
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
/*
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
}*/

function getFormData(){
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["adrewardAttachList"] = [];
	$("tbody").find("tr[name='node']").each(function(index, tr){
		var userId = $(this).find("input[name='AttachuserId']").val();
		var dpetId = $(this).find("input[name='AttachdeptId']").val();
		var wages = rmoney($(this).find("input[name='salary']").val());
		var score = $(this).find("input[name='score']").val();
        var coefficient = rmoney($(this).find("input[name='coefficient']").val());
        var businessreward = rmoney($(this).find("input[name='money']").val());
        var otherreward = rmoney($(this).find("input[name='otherreward']").val());
        var totalreward = rmoney($(this).find("input[name='totalbonus']").val());
        var remark = $(this).find("input[name='remark']").val();

		// 其中一个有值就算有效表单数据
		if(!isNull(userId) || !isNull(dpetId)) {
			var data = {};
			data["userId"] = userId;
			data["dpetId"] = dpetId;
			data["wages"] = wages;
			data["score"] = score;
			data["coefficient"] = coefficient;
			data["otherreward"] = otherreward;
			data["businessreward"] = businessreward;
			data["totalreward"] = totalreward;
            data["remark"] = remark;
			formData["adrewardAttachList"].push(data);
		}
		
	});
	
	return formData;
}

function decryptNumber(){
	var MZnum = 0,PZnum = 0;
	$(".box-body #form1").find('tbody').each(function(i){
		var Mnum = 0,Pnum = 0,Fnum = 0,rewardM = 0,otherM = 0,totalM = 0;	
		if($(this).attr('data-index') == i){
			$(this).find('tr').each(function(j){
				if($(this).attr("data-i") == i){
					Mnum += parseInt(commafyback($(this).find('td').eq(5).find('input').val()));
					MZnum += Mnum;						
					Fnum += parseFloat($(this).find('td').eq(6).find('input').val().length > 0 ? $(this).find('td').eq(6).find('input').val() : 0);						
					Pnum++;
					PZnum += Pnum;
					rewardM += parseInt($(this).find('td').eq(8).find('input').val().length > 0 ? $(this).find('td').eq(8).find('input').val() : 0);						
					otherM += parseInt($(this).find('td').eq(9).find('input').val().length > 0 ? $(this).find('td').eq(9).find('input').val() : 0);						
					totalM += parseInt($(this).find('td').eq(10).find('input').val().length > 0 ? $(this).find('td').eq(10).find('input').val() : 0);						
				}	
			})
			$(this).find(".subtotal td").eq(4).find('input').val(fmoney((Mnum/Pnum),2));
			$(this).find(".subtotal td").eq(5).find('input').val((Fnum/Pnum) > 0 ? (Fnum/Pnum).toFixed(1) : '');
			$(this).find(".subtotal td").eq(7).find('input').val(rewardM);
			$(this).find(".subtotal td").eq(8).find('input').val(otherM);
			$(this).find(".subtotal td").eq(9).find('input').val(totalM);
		}	
	})
}


function commafyback(num) { 
	var x = num.split(','); 
	return parseFloat(x.join("")); 
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

