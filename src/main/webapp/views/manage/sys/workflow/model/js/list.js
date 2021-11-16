/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	html.push('<a href="'+web_ctx+'/processEditor/modeler.html?modelId='+aData.id+'" target="_blank">编辑</a>');
	html.push('<a href="'+web_ctx+'/manage/sys/workflow/model/deploy/'+aData.id+'">部署</a>');
	html.push('导出(<a href="'+web_ctx+'/manage/sys/workflow/model/export/'+aData.id+'/bpmn" target="_blank">BPMN</a>');
	html.push('&nbsp;|&nbsp;<a href="javascript:;" onclick=showSvgTip()>SVG</a>')
	html.push('&nbsp;|&nbsp;<a href="'+web_ctx+'/manage/sys/workflow/model/export/'+aData.id+'/json" target="_blank">JSON)</a>');
	html.push('<a href="'+web_ctx+'/manage/sys/workflow/model/delete/'+aData.id+'">删除</a>');
	
	return html.join("");
}

function deploy(modelId) {
	$.ajax({
		url: "deploy/"+modelId,
		type: "post",
		data: {},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				window.location.href = "toList";
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function del(modelId) {
	$.ajax({
		url: "delete/"+modelId,
		type: "post",
		data: {"modelId": modelId},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				window.location.href = "toList";
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}



function create() {
	if(!$("#name").val()) {
		bootstrapAlert("提示", "name不能为空！", 400, null);
		$("#name").focus();
		return ;
	}
	$("#editorModal").modal("hide");
	$("#form1").submit();
}