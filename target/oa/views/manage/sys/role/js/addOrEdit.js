$(function() {
	initFormValidate();
});

function initFormValidate() {
	$("#form1").validate({
		rules: {
			name: {
				required: true,
				maxlength :12
			}
		},
		messages: {
			name: {
				required: "角色名不能为空！",
				maxlength:"请不要超过12个字符"
			}
		}
	});
}

function goBack() {
	backPageAndRefresh();
}