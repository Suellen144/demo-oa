$(function() {
	initFormValidate();
});

function save() {
	$.ajax({
		url: "save",
		type: "POST",
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", "提交成功！", 400, function() {
					backPageAndRefresh();
				});
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function initFormValidate() {
	$("#form1").validate({
		rules: {
			value: {
				required: true
			}
		},
		messages: {
			value: {
				required: "费用归属不能为空！"
			}
		},submitHandler:function(form) {
			save();
		}
	});
}