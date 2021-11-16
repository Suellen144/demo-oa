var fileData = null;

$(function() {
	initDatetimepicker();
	initInputMask();
	initFileUpload();
});

function initDatetimepicker() {
	$(".starttime, .endtime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true,
        autoclose: true,
        minuteStep: 30,
        bootcssVer:3
    });
}

function save() {
	var formData = $("#form1").serializeJson();
	if(!checkForm(formData)) {
		return ;
	}
	
	openBootstrapShade(true);
	if(fileData != null) {
		fileData.submit();
	} else {
		submitForm(formData);
	}
}

function submitForm(formData) {
	$.ajax({
		url: "save",
		type: "post",
		data: formData,
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				/*bootstrapAlert("提示", "提交成功！", 400, function() {*/
					openBootstrapShade(true);
					backPageAndRefresh();
				/*});*/
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function(data) {
			openBootstrapShade(false);
		}
	});
}

function checkForm(formData) {
	var text = [];
	
	var st = $("#startTime").val();
	var et = $("#endTime").val();
	
	if(isNull(st)) {
		text.push("开始时间不能为空！<br/>");
	}
	if(isNull(et)) {
		text.push("结束时间不能为空！<br/>");
	}
	if(!isNull(st) && !isNull(et) && st >= et) {
		text.push("开始时间不能大于或等于结束时间！<br/>");
	}
	if(isNull(formData["days"]) && isNull(formData["hours"])) {
		text.push("请假时长不能为空，请填写“天”或“小时”！<br/>");
	}
	if(isNull(formData["reason"])) {
		text.push("请假事由不能为空！<br/>");
	}
/*	if(!isNull(formData["days"]) && formData["days"] == 0) {
		text.push("请假天数不能是0！");
	}
	if(!isNull(formData["hours"]) && formData["hours"] == 0) {
		text.push("请假小时数不能是0！");
	}*/
	
	if(formData["days"] == 0 && formData["hours"] == 0) {
		text.push("天数和小时数不能同时为0！");
	}
	
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

function resetForm() {
	fileData = null;
}

//初始化输入框约束
function initInputMask() {
	$("#days").inputmask("Regex", { regex: "\\d+" });
	$("#hours").inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
}

//文件上传
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "leave/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 3 * 1024 * 1024, // 3 MB
        messages: {
        	maxFileSize: '附件大小最大为3M！'
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
        done: function(e, data) {
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
        		
        		var formData = $("#form1").serializeJson();
        		submitForm(formData);
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        },
        processfail: function (e, data) {
            var currentFile = data.files[data.index];
            if (data.files.error && currentFile.error) {
                // there was an error, do something about it
                console.log(currentFile.error);
            }
        },
        complete: function() {
        	openBootstrapShade(false);
        }
    });
}

function checkDate(){
	var startTime=$("#startTime").val();
	var endTime=$("#endTime").val();
	if(!isNull(startTime) && !isNull(endTime)  ){
		$.ajax({
			url: "checkDate",
			type: "post",
			data: {"startTime":startTime,"endTime":endTime},
			success: function(data) {
				if(data.code == 1) {
						//设置请假时长
					var map=data.result;
					$("#days").val(map['day']);
					$("#hours").val(map['hour']);
				} else if(data.code == 2){
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		})
	}
}