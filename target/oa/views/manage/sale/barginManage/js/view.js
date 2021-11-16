$(function() {
	//原来数据库的数据，手动变成已归档状态，申请人自己可更改，他人只可以看		
	$("tbody").find("input[type='text']").attr("readonly","readonly");
	$("tbody").find("select").attr("readonly","readonly");
	$("#barginDescribe").attr("readonly","readonly");
	
});

//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

