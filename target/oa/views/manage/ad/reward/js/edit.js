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
});


function save() {
    $("#status").val("");
    var formData = getFormData();
    if( hasDecryptPermission ) {
        var now = new Date().pattern("yyyyMMdd");
        $.ajax({
            url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
            type: 'GET',
            success: function(data) {
                if(data.code == 1) {
                    openBootstrapShade(true);
                    submitForm(formData);
                }else{
                    bootstrapAlert('提示','请先导入文件', 400, null);
                }
            }
        });
    }
}


function submitinfo() {
    $("#status").val(1);
    var formData = getFormData();
    bootstrapConfirm("提示", "提交后无法修改，确定嘛？", 300, function() {
        if( hasDecryptPermission ) {
            var now = new Date().pattern("yyyyMMdd");
            $.ajax({
                url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
                type: 'GET',
                success: function(data) {
                    if(data.code == 1) {
                        openBootstrapShade(true);
                        submitForm(formData);
                    }else{
                        bootstrapAlert('提示','请先导入文件', 400, null);
                    }
                }
            });
        }


    },null);

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
                    $("tr[name='node']").each(function(index, tr){
                        if($(tr).find("input[name='salary']").val() != null && $(tr).find("input[name='salary']").val() != ""){
                            $(tr).find("input[name='salary']").val(fmoney($(tr).find("input[name='salary']").val(),2));
                        }
                    });
                    countmoney();
                    /*Amount();*/
                } else {
                    if(data.code == -1) {
                        bootstrapAlert('提示', data.result, 400, null);
                    }
                    if(data.code == 0){
                        /*   bootstrapAlert('提示','请先导入	文件', 400, null);*/
                    }
                    disabledEncryptPageText();
                }
            }
        });
    } else {
        disabledEncryptPageText();
    }
}

function Amount(){
	var money0 = 0,money1 = 0,money2 = 0,money3 = 0;
	$(".box-body #form1").find('tbody').each(function(i){			
		var index = $(this).attr('data-index');
		if(index == i){
			var peo = 0,money = 0;
			$(this).find('tr').each(function(j){ 					
				if(i == $(this).attr('data-i')){
					peo++;
					money += parseInt(rmoney($(this).find("input[name='salary']").val()));
					money0 += parseInt(rmoney($(this).find("input[name='salary']").val()));
					money1 += parseInt(rmoney($(this).find("input[name='money']").val()));
					money2 += parseInt(rmoney($(this).find("input[name='otherreward']").val()));
					money3 += parseInt(rmoney($(this).find("input[name='totalbonus']").val()));
				}					
			})
			$(this).find(".subtotal").find('td').eq(4).find('input').val(fmoney(money/peo));
			
		}
		$(".summaryT").find('td').eq(4).find('input').val(fmoney(money0))
		$(".summaryT").find('td').eq(7).find('input').val(fmoney(money1))
		$(".summaryT").find('td').eq(8).find('input').val(fmoney(money2))
		$(".summaryT").find('td').eq(9).find('input').val(fmoney(money3))
		
	})
}


function encryptPageText(encryptionKey) {
    $("input[name='salary'],input[name='businessreward'],input[name='otherreward'],input[name='coefficient'],input[name='totalbonus']").each(function(index, input) {
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


function submitForm(formData) {
    $.ajax({
        url: "update",
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



function countmoney(){
    var temp = 0;
    $("tr[name='node']").each(function(index, tr) {
        var val = rmoney($(tr).find("input[name='salary']").val());
        var percent = $(tr).find("input[name='coefficient']").val();
        var date =  new Date("December 31, 2017");
        var entrytime = new Date($(tr).find("input[name='entrytime']").val()).getTime();
        var date3 = date - entrytime;
        var days=(Math.floor(date3/(24*3600*1000))+2)/365;
        var day = parseFloat(days);
        try {
            if(days >1 ){
                var count = val*percent;
            }
            else{
                var count = val*percent*day;
            }
            if(isNaN(count) || isNull(count)){
                count = 0;
            }
            $(tr).find("input[name='money']").val(fmoney(count,2));
            var money = $(tr).find("input[name='salary']").val();
            temp  = digitTool.add(temp,rmoney(money));
            $("#totalsalary").val(fmoney(temp,2));
            countAll();
        } catch(e) {}
    });
}


function countAll() {
    var temp1 = 0; //基数
    var temp2 = 0 ; //薪酬
    var temp3 = 0;//业务
    var temp4  = 0; //其他
    var total = 0;
    $("tr[name='node']").each(function(index, tr){
        var money = rmoney($(tr).find("input[name='money']").val());
        temp2  = digitTool.add(temp2,money);
        $("#totalmoney").val(fmoney(temp2,0));
        var businessreward = $(tr).find("input[name='businessreward']").val();
        temp3  = digitTool.add(temp3,businessreward);
        $("#totalbusiness").val(fmoney(temp3,0));
        var otherreward = $(tr).find("input[name='otherreward']").val();
        temp4  = digitTool.add(temp4,otherreward);
        $("#totalother").val(fmoney(temp4,0));
        var temp =	parseFloat(money)+parseFloat(businessreward)+parseFloat(otherreward);
        if(!isNull(temp) && !isNaN(temp)){
            $(tr).find("input[name='totalreward']").val(fmoney(temp,0));
        }
        var totalreward = $(tr).find("input[name='totalreward']").val();
        total  = digitTool.add(total,rmoney(totalreward));
        $("#total").val(fmoney(total,0));

    });
}


function getFormData(){
    var json = $("#form1").serializeJson();
    var formData = $.extend(true, {}, json);
    formData["adrewardAttachList"] = [];
    $("tbody").find("tr[name='node']").each(function(index, tr){
        var id = $(this).find("input[name='Attachid']").val();
        var userId = $(this).find("input[name='AttachuserId']").val();
		var dpetId = $(this).find("input[name='AttachdeptId']").val();
		var wages = rmoney($(this).find("input[name='salary']").val());
		var score = $(this).find("input[name='score']").val();
        var coefficient = rmoney($(this).find("input[name='coefficient']").val());
        var businessreward = rmoney($(this).find("input[name='money']").val());
        var otherreward = rmoney($(this).find("input[name='otherreward']").val());
        var totalreward = rmoney($(this).find("input[name='totalbonus']").val());
        var remark = $(this).find("input[name='remark']").val();
        console.log(id,userId,dpetId,wages,score,coefficient,businessreward,otherreward,totalreward,remark);

        // 其中一个有值就算有效表单数据
        if(!isNull(userId) || !isNull(dpetId)) {
            var data = {};
            data["id"] = id;
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


function exportExcel() {
    if( hasDecryptPermission ) {
        var now = new Date().pattern("yyyyMMdd");
        $.ajax({
            url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
            type: 'GET',
            success: function(data) {
                if(data.code == 1) {
                    openBootstrapShade(true);
                    var params = $("#rewardId").val();
                    // params = urlEncode(params);
                    // params = params.substring(1);
                    var url = web_ctx + "/manage/ad/reward/exportExcel?id=" + params;
                    $("#excelDownload").attr("src", url);
                }else{
                    bootstrapAlert('提示','请先导入文件', 400, null);
                }
            }
        });
    }
}