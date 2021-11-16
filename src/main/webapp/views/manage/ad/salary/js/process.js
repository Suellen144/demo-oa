
// 同意后的下一状态
/* 审批状态 0：提交申请 1：经理补充 2：经理补充 3：经理补充 4：经理补充 5：总经理审批 6：审批通过 7：取消申请 */
var approvedStatus = {
	"0": "1",
	"1": "2",
	"2": "3",
	"3": "4",
	"4": "5",
	"5": "6",
};
// 不同意后的下一状态
var notApprovedStatus = {
	"0": "7",
	"1": "2",
	"2": "3",
	"3": "4",
	"5": "6",
};
// 环节与状态的映射
var nodeOnStatus = {
	"0": "提交",
	"1": "部门经理",
	"2": "部门经理",
	"3": "部门经理",
	"4": "部门经理",
	"5": "总经理",
	"6": "审批通过",
	"7": "取消申请",
};
//环节与操作结果的映射
var nodeOnOper = {
	"提交": "提交成功",
	"重新申请": "申请成功",
	"同意": "已填报",
	"同意并加密":"通过",
	"不同意": "不通过",
	"取消申请": "取消申请"
};

$(function() {
	initTaskComment();
	initInputMask();
	initDecryption();
    initdate();
	$("tr[name='node']").each(function(index, tr){
		$(tr).find("input[name='number']").val(index+1);
	/*	$(tr).find("input").each(function(i){
			   var input_size = $(this).val().length;
			   this.size=input_size;
			});*/
	});
});



function initdate() {
    $("tr[name='node']").each(function(index, tr){
        var id = $(tr).find("input[name='AttachuserId']").val();
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

function initInputMask() {
	$("tbody").find("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "personAmplitude" || name == "manageAmplitude" || name == "finallyAmplitude") {
			$(input).inputmask("Regex", { regex: "^-?\\d+\\.?\\d{0,1}" });
		}
	});
}


function getFormData(){
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["salaryAttachList"] = [];
	$("tbody").find("tr[name='node']").each(function(index, tr){
		var id = $(this).find("input[name='Attachid']").val();
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
			data["id"] = id;
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



function checkForm(formData) {
/*	var checkMsg = [];
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
	});*/
}

function approve(status) {
	if(status == 1) {
		$("#operStatus").val("提交");
		update();
	} else if(status == 2) {
		$("#operStatus").val("同意");
			update();
	} else if(status == 5) {
		$("#operStatus").val("取消申请");
		cancelProcess();
	}
	else if(status == 6) {
		$("#operStatus").val("同意并加密");
        bootstrapConfirm("提示", "提交后无法修改，确定嘛？", 300, function() {
            if( hasDecryptPermission ) {
                var now = new Date().pattern("yyyyMMdd");
                $.ajax({
                    url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
                    type: 'GET',
                    success: function(data) {
                        if(data.code == 1) {
                            openBootstrapShade(true);
                            update();
                        }else{
                            bootstrapAlert('提示','请先导入文件', 400, null);
                        }
                    }
                });
            }


        },null);
	}
}

function update() {
	var formData = getFormData();
		submitForm(formData);
}

function save(){
	var formData = getFormData();
	if( hasDecryptPermission ) {
		var now = new Date().pattern("yyyyMMdd");
		$.ajax({
			url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
			type: 'GET',
			success: function(data) {
				if(data.code == 1) {
					openBootstrapShade(true);
					if($("#encrypted").val() != 'y'){
						locksave();
					}
					saveForm(formData);
				}
				if(data.code == 0){
					openBootstrapShade(true);
					saveForm(formData);
				}
				else {
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


function submitForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/ad/salary/saveOrUpdate", 
		type: "POST",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {	
			openBootstrapShade(false);
			if(data.code == 1) {
				if($("#operStatus").val() == "提交") {
					lock();
					backPageAndRefresh();
        		}
				else if(($("#operStatus").val() == "同意" || $("#operStatus").val() == "不同意")) {
	        			submitProcess();
	        		}
				else if(($("#operStatus").val() == "同意并加密")) {
					if($("#encrypted").val() != 'y'){
						lock();
                        submitProcess();
					}
					else {
						submitProcess();
					}
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


function saveForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/ad/salary/saveOrUpdate", 
		type: "POST",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {	
			openBootstrapShade(false);
			if(data.code == 1) {
        		}
			else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}




function submitProcess() {
	var variablesTemp = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variablesTemp);
	if(compResult.code == 1) {
		var status = getNextStatus();
		$.ajax( {   
	        "type": "POST",    
	        "url": web_ctx+"/manage/ad/salary/setStatus",    
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
        		
        		window.top.initTodo();
        		backPageAndRefresh();
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
		} );
	} else if(compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
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
 */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	if($("#operStatus").val() == "同意") {
		status = approvedStatus[currStatus];
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	}else if($("#operStatus").val() == "同意并加密") {
		status = approvedStatus[currStatus];
	} else {
		status = "1";
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
	var id = $("#id").val();
	var processInstanceId = $("#processInstanceId").val();
	var variables = getVariables();
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function(){
	var result = endProcessOfParallel(processInstanceId, variables);
	if(result != null) {
		if(result.code == 1) {
			setStatus(id);
		} else {
			bootstrapAlert("提示", result.result, 400, null);
		}
	} else {
		bootstrapAlert("提示", "结束流程失败，请联系管理员！", 400, null);
	}
	},null);
}

function setStatus(id) {
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/ad/salary/setStatus",    
        "dataType": "json",
        "data": {"id": id, "status": "7"},
        "success": function(data) { 
        	if(data.code == 1) {
        		bootstrapAlert("提示", "取消申请成功！", 400, function() {
        			backPageAndRefresh();
        		});
        	} else {
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



var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	
	for(var i=commentList.length-1;i>=0;i--){
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
					/*		if(data.code == 0){
								if(hasDecryptPermission && $("#currStatus").val() == "5"){
									bootstrapAlert("提示", "请先导入密钥，以方便页面计算和加密操作！", 400, null);
								}
							}*/
							disabledEncryptPageText();
						}
					}
				});
			} else {
				disabledEncryptPageText();
			}
}




function encryptPageText(encryptionKey) {
	$("tr[name='node']").each(function(index, tr) {
		var val = $(tr).find("input[name='salary']").val();
		try {
			val = aesUtils.decryptECB(val, encryptionKey);
			if( !isNull(val) ) {
				 $(tr).find("input[name='salary']").val(val);
			}
		} catch(e) {}
	});

}


function disabledEncryptPageText() {
	$("tr[name='node']").each(function(index, tr) {
			$(tr).find("input[name='salary']").prop("readonly", true);
	});
	
	$("tr[name='node']").each(function(index, tr) {
		$(tr).find("input[name='finallySalary']").prop("readonly", true);
	});
}

function countmoney(){
	$("tr[name='node']").each(function(index, tr) {
		var val = rmoney($(tr).find("input[name='salary']").val());
		var temp1 = $(tr).find("input[name='finallyAmplitude']").val();
		var percent = 1+$(tr).find("input[name='finallyAmplitude']").val()/100;
		$(tr).find("input[name='salary']").val(fmoney($(tr).find("input[name='salary']").val(),2));
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
			 $(tr).find("input[name='finallySalary']").val(fmoney(((count.toFixed(0)/100).toFixed(0)*100),2));
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





function lock() {
	var params = {};
	var salaryAttachList = getUnLockData();
	params['id'] = $('#id').val();
	params['salaryAttachList'] = salaryAttachList;

	$.ajax({
		url: web_ctx+'/manage/ad/salary/lock',
		type: 'POST',
		contentType: 'application/json;charset=utf-8;',
		dataType: 'JSON',
		data: JSON.stringify(params),
		success: function(data) {
			if(data.code == 1) {
			} else {
				bootstrapAlert('提示', data.result, 400, null);
			}
		},
		error: function(err, errMsg) {
			bootstrapAlert('提示', '加密失败，请联系管理员！', 400, null);
		}
	});
}


function locksave() {
	var params = {};
	var salaryAttachList = getUnLockData();
	params['id'] = $('#id').val();
	params['salaryAttachList'] = salaryAttachList;

	$.ajax({
		url: web_ctx+'/manage/ad/salary/lock',
		type: 'POST',
		contentType: 'application/json;charset=utf-8;',
		dataType: 'JSON',
		data: JSON.stringify(params),
		success: function(data) {
			if(data.code == 1) {
				/*bootstrapAlert('提示', data.result, 400, function() { refreshPage(); });*/
				refreshPage();
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
		data['id'] = $(tr).find("input[name='Attachid']").val();
		data['finallySalary'] = rmoney($(tr).find("input[name='finallySalary']").val());
		dataList.push(data);
	});
	
	return dataList;
}

/************* 加解密操作 End **************/

//导出Excel
function exportExcel() {
    if( hasDecryptPermission ) {
        var now = new Date().pattern("yyyyMMdd");
        $.ajax({
            url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date="+new Date().getTime(),
            type: 'GET',
            success: function(data) {
                if(data.code == 1) {
                    var params = $("#id").val();
                    var url = web_ctx + "/manage/ad/salary/exportExcel?id=" + params;
                    $("#excelDownload").attr("src", url);
                }else{
                    bootstrapAlert('提示','请先导入文件', 400, null);
                }
            }
        });
    }
}