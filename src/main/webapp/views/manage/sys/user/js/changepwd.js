$(function() {
});

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

//修改密码
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