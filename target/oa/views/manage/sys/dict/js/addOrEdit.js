$(function() {
	initFormValidate();
});

function initFormValidate() {
	$("#form1").validate({
		rules: {
			name: {
				required: true,
				maxlength :12
			},
			remark: {
				required: true,
				maxlength:30
			},
			value: {
				required: true,
				maxlength:12
			}
		},
		messages: {
			name: {
				required: "数据名称不能为空！",
				maxlength:"请不要超过12个字符"
			},
			remark: {
				required: "数据备注不能为空！",
				maxlength :"请不要超过30个字符"
			},
			value: {
				required: "数据值不能为空！",
				maxlength :"请不要超过30个字符"
			}
		}
	});
}

function goBack() {
	backPageAndRefresh();
}