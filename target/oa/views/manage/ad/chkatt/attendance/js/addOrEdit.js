$(function() {
	if($("#id").val() == "") {
		initFileUpload();
	}
});


function checkForm() {
	var checkMsg = [];
	var fileName = $("#showName").val();
	if(isNull(fileName)) {
		checkMsg.push("请先选择一个Excel文件！");
	}
	
	return checkMsg;
}

function save() {
	
	var checkMsg = checkForm();
	if(!isNull(checkMsg)) {
		openBootstrapShade(false);
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	openBootstrapShade(true);
	$.ajax({
		url: "save",
		type: "post",
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				bootstrapAlert("提示", "入库成功！", 400, function() {
					window.location.href = "toList";
				});
			} else {
				bootstrapAlert("提示", "入库失败！请检查文件格式！", 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("错误提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function upload() {
	if(fileData != null) {
		fileData.submit();
	} else {
		save();
	}
}



function initFormValidate() {
	$("#form1").validate({
		rules: {
			name: {
				required: true
			},
			account: {
				required: true
			},
			password: {
				required: true
			}
		},
		messages: {
			name: {
				required: "姓名不能为空！"
			},
			account: {
				required: "帐号不能为空！"
			},
			password: {
				required: "密码不能为空！"
			}
		},submitHandler:function(form) {
			if(!checkAccount()) {
				save();
			}
		}
	});
}

var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "filemanage/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
	};
	
	urlParam = urlEncode(params);
	$('#file1').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50000000, // 50 MB
        add: function (e, data) {
        	fileData = data;
        	$("#showName").val(data.files[0].name);
        },
        done: function (e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file1").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
        		$("#name").val(result.name);
        		$("#showName").val(result.originName);
        		$("#filePath").val(result.path);
        		$("#originName").val(result.originName);
        		save();
        	}
        	 else {
         		bootstrapAlert("提示", "入库失败，错误信息：" + result.execResult.result, 400, null);
         	}
        }
    });
}

var urlEncode = function(param, key, encode) {
	if (param == null)
		return '';
	var paramStr = '';
	var t = typeof (param);
	if (t == 'string' || t == 'number' || t == 'boolean') {
		paramStr += '&'
				+ key
				+ '='
				+ ((encode == null || encode) ? encodeURIComponent(param)
						: param);
	} else {
		for ( var i in param) {
			var k = key == null ? i : key
					+ (param instanceof Array ? '[' + i + ']' : '.' + i);
			paramStr += urlEncode(param[i], k, encode);
		}
	}
	return paramStr;
};