function submitInfo(){
	var  formData=getFormData();
	$.ajax({
		url : web_ctx+"/manage/office/review/add",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				backPageAndRefresh();
				window.location.href=web_ctx+"/manage/office/review/toList"
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

function getFormData() {
	var json = $("#replyForm").serializeJson();
	var formData = $.extend(true, {}, json);
	var html = ue.getContent();
	formData["content"]=html;
	return formData;
}




