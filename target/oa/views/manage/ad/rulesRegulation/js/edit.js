$(function() {
	if(!isApprove) {
		initCkeditor();
	} else {
		var bodyHeight = $(window).height();
		var height = bodyHeight * 0.6; // 百分之六十
		$(".box-body").height(height);
	}
});

function initCkeditor() {
	var bodyHeight = $(window).height();
	var height = bodyHeight * 0.6; // 百分之六十
	
	CKEDITOR.replace("contentCK", 
		{
			toolbar :
	            [
					//样式       格式      字体    字体大小
					['Styles','Format','Font','FontSize'],
					//文本颜色     背景颜色
					['TextColor','BGColor'],
					//加粗     斜体，     下划线      穿过线      下标字        上标字
					['Bold','Italic','Underline','Strike','Subscript','Superscript'],
					// 数字列表          实体列表            减小缩进    增大缩进
					['NumberedList','BulletedList','-','Outdent','Indent'],
					//左对 齐             居中对齐          右对齐          两端对齐
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					//超链接  取消超链接 锚点
					['Link','Unlink','Anchor'],
					//图片    flash    表格       水平线            表情       特殊字符        分页符
					['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
					//全屏           显示区块
					['Maximize', 'ShowBlocks','-']
	            ],
	         "height": height
		}
	);
}

function save(op) {
	var json = {
		"id": $("#id").val(),
		"privateContent": CKEDITOR.instances.contentCK.getData(),
		"approveStatus": "0"
	}
	
	var text = "提交成功！";
	if(op == '0') {
		json["publicStatus"] = "0";
	} else {
		json["publicStatus"] = "1";
		text = "发布成功！";
	}
	
	$.ajax({
		url: "save",
		type: "post",
		data: json,
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", text, 400, function() {
					window.location.href = "toPage";
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

function approve() {
	$.ajax({
		url: "approve",
		type: "post",
		data: {"id": $("#id").val()},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", "审核成功！", 400, function() {
					window.location.href = "toPage";
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

function preview() {
	$("#rulesRegulationModal").find(".modal-body").html(CKEDITOR.instances.contentCK.getData());
	$("#rulesRegulationModal").modal("show");
}

function previewApprove(obj) {
	var content = $(obj).parent("div").prev().html();
	$("#rulesRegulationModal").find(".modal-body").html(content);
	$("#rulesRegulationModal").modal("show");
}