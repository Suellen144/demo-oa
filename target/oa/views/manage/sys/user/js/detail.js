$(function() {
	initInputMask();
	makeFormValidator();
	initFileUpload();
});

function initInputMask() {
	$("#phone").inputmask({ "mask": "9{11}" });
	$("#qq").inputmask({ "mask": "9{6,}" });
	$("#idcard").inputmask({ "mask": "*{18}" });
}


function save() {
	var formData = $("#form").serializeJson();
	var chkMsg = checkForm(formData);
	if( !isNull(chkMsg) ) {
		bootstrapAlert("提示", chkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	$.ajax({
		url: web_ctx + "/manage/ad/record/saveForUser",
		type: "post",
		data: formData,
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", "保存成功！", 400, null);
			} else {
				bootstrapAlert("提示", "保存失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("错误提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
var qq =/^\d{6,14}$/;
var email = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/;
function checkForm(formData) {
	var text = [];
	
	if( !isNull(formData["phone"]) && !phone.test(formData["phone"]) ) {
		text.push("请填写正确的11位手机号码！");
	}
	if( !isNull(formData["qq"]) && !qq.test(formData["qq"]) ) {
		text.push("请填写6到14位的QQ号！");
	}
	if( !isNull(formData["email"]) && !email.test(formData["email"]) ) {
		text.push("请填写正确的邮箱地址！");
	}
	
	return text;
}




/***********************************
 * 		修改密码
 ***********************************/
function makeFormValidator() {
	$("#form1").validate({
		rules: {
			origin_pwd: {
				required: true
			},
			new_pwd: {
				required: true
			}
		},
		messages: {
			origin_pwd: {
				required: "原始密码不能为空！"
			},
			new_pwd: {
				required: "新密码不能为空！"
			}
		},submitHandler:function(form) {
			if(checkPassword()) {
				savePwd();
			}
		}
	});
}

function savePwd() {
	$.ajax({
		url: web_ctx + "/manage/sys/user/modifyPassword",
		type: "post",
		data: {"account":$("#account").val(), "password":$("#new_pwd").val()},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#password").val(hex_md5($("#new_pwd").val()));
				$("#origin_pwd").val("");
				$("#new_pwd").val("");
				$("#re_pwd").val("");
			}
			bootstrapAlert("提示", data.result, 400, null);
		},
		error: function(data) {
			bootstrapAlert("错误提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
}

function checkPassword() {
	var flag = true;
	var pwd = $("#password").val();
	var orgPwd = $("#origin_pwd").val();
	var newPwd = $("#new_pwd").val();
	var rePwd = $("#re_pwd").val();

	var org = hex_md5(orgPwd);
	if(pwd != org) {
		$("#origin_pwd_error").text("原始密码错误！");
		$("#origin_pwd_error").show();
		flag = false;
	}
	if(newPwd != rePwd) {
		$("#re_pwd_error").text("两次密码不一致！");
		$("#re_pwd_error").show();
		flag = false;
	}
	
	return flag;
}


/***********************************
 * 		上传头像
 ***********************************/
function uploadHeaderImg() {
	if( !isNull(fileData) ) {
		fileData.submit();
	} else {
		bootstrapAlert("提示", "请选择头像图片！", 400, null);
	}
}

var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "headPicture",
		"deleteFile": $("#photo").val()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        acceptFileTypes: /(gif|jpe?g|png)$/i,
        maxFileSize: 3 * 1024 * 1024, // 3 MB
        messages: {
        	maxFileSize: '头像图片大小最大为3M！',
        	acceptFileTypes: '头像类型只能是：gif、png、jpg、jpeg'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#imgName").text(data.files[0].name);
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
        		// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
    			$("#file").fileupload("option", "formData", urlParam);
        		
        		updateUserPhoto(result);
        	} else {
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}

function updateUserPhoto(imgData) {
	$.ajax({
		url: web_ctx + "/manage/sys/user/saveForDetail",
		type: "post",
		data: { "account": $("#account").val(), "photo": imgData.path },
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#imgName").text(imgData.originName);
        		$("#photo").val(imgData.path);
        		$("#headImg").attr("src", web_ctx+imgData.path);
        		
        		// 刷新导航部分的头像
        		window.parent.document.getElementById("mainHeadImg").src = web_ctx+imgData.path;
        		window.parent.document.getElementById("secondHeadImg").src = web_ctx+imgData.path;
			} else {
				bootstrapAlert("提示", "头像上传失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("错误提示", "网络错误，头像上传失败。请稍后重试！", 400, null);
		}
	});
}