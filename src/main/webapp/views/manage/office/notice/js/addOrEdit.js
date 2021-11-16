$(function() {
	initFileUpload();
	initDatetimepicker();
//	initCkeditor();
	initVisible();
	inittextarea();
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept,
		"isCheck": true,
		"isGetChildren": true
	});
	
	$("#deptDialog2").initDeptDialog({
		"callBack": getDept2
	});
});


function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

function initCkeditor() {
	var bodyHeight = $(window).height();
	var height = bodyHeight * 0.5; // 百分之六十
	
	CKEDITOR.replace("contentCK", 
		{
			toolbar :
	            [
					//样式       格式      字体    字体大小
					['Styles','Font','FontSize'],
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

function initDatetimepicker() {
	$("#publishTime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true,
        autoclose: true,
        minuteStep: 5,
        bootcssVer:3
    });
}

function initVisible() {
	if( isNull($("#id").val()) ) {
		var deptName = [];
		var deptIds = [];
		$(parentDeptList).each(function(index, dept) {
			deptName.push(dept.name);
			deptIds.push(dept.id);
		});
		$("#deptName").val(deptName.join(", "));
		$("#deptIds").val(deptIds.join(","));
	} else {
		var deptList = [];
		var deptIds = $("#deptIds").val().split(",");
		$(deptIds).each(function(index, id) {
			deptList.push(deptMap[id]);
		});
		var res = sendScope(deptList);
		$("#deptName").val(res.deptName.join(", "));
	}
}

function openDept() {
	$("#deptDialog").openDeptDialog($("#deptIds").val());
}

function getDept(deptList) {
	var deptIds = [];
	var deptName = [];
	
	if( !isNull(deptList) && deptList.length > 0 ) {
		var res = sendScope(deptList);
		deptIds = res.deptIds;
		deptName = res.deptName;
	} else { // 没有选择任何部门，则默认显示全部公司
		$(parentDeptList).each(function(index, dept) {
			deptName.push(dept.name);
			deptIds.push(dept.id);
		});
	}
	
	$("#deptName").val(deptName.join(", "));
	$("#deptIds").val(deptIds.join(","));
}

// 计算抄送范围的部门字符串
function sendScope(deptList) {
	var deptName = [];
	var deptIds = [];
	var deptNameTree = {};
	
	$(deptList).each(function(index, dept) {
		deptIds.push(dept.id);
		
		if(dept.level == 1) { // 树的第一级为公司，只做添加
			deptNameTree[dept.id] = { "id": dept.id, "name": dept.name, "children": [] };
		} else if(dept.level == 2) { // 树的第二级为部门，需要跟公司挂钩
			var parent = deptMap[dept.parentId];
			if( isNull(deptNameTree[parent.id]) ) {
				deptNameTree[parent.id] = { "id": parent.id, "name": parent.name, "children": [{"id": dept.id, "name": dept.name, "children": []}] };
			} else {
				var children = deptNameTree[parent.id].children;
				children.push({ "id": dept.id, "name": dept.name, "children": [] });
			}
		} else { // 树的其他级，需要挂钩到部门，最终挂钩到公司
			var nodeLinks = dept.nodeLinks.split(",");
			nodeLinks = nodeLinks.slice(2); // 获取从公司到当前选择机构的路径链接
			
			var prevDept = null; // 始终保存上一级树
			$(nodeLinks).each(function(index, link) {
				if( index == 0 ) { // 索引为0，则是树的第一级，为公司
					var parent = deptNameTree[link];
					if( isNull(parent) ) {
						var tempDept = deptMap[link];
						var temp = { "id": tempDept.id, "name": tempDept.name, "children": [] };
						deptNameTree[tempDept.id] = temp;
						prevDept = temp;
					} else {
						prevDept = parent;
					}
				} else {
					var isHas = false; // 上一级部门（prevDept）的 children 是否已经存在当前树
					var children = prevDept.children;
					var tempDept = deptMap[link];
					
					$(children).each(function(index, child) {
						if(child.id == tempDept.id) {
							isHas = true;
							prevDept = child;
						}
					});
					if( !isHas ) {
						var temp = { "id":tempDept.id, "name": tempDept.name, "children": [] };
						children.push(temp);
						prevDept = temp;
					}
				}
			});
		}
	});
	
	// 构建每一个以公司为单位的树的部门名称，比如xxx公司(a部门,b部门), yyy公司(a部门,b部门)
	for(var key in deptNameTree) {
		var value = deptNameTree[key];
		var tempDeptName = [];
		buildDeptName(tempDeptName, value);
		deptName.push(tempDeptName.join(""));
	}
	
	return {"deptName": deptName, "deptIds": deptIds};
}

function buildDeptName(deptName, dept) {
	if( isNull(dept.children) ) {
		deptName.push(dept.name);
	} else {
		deptName.push(dept.name);
		deptName.push("(");
		$(dept.children).each(function(index, child) {
			if(index > 0) {
				deptName.push(",");
			}
			deptName.push(buildDeptName(deptName, child));
		});
		deptName.push(")");
	}
}

function openDept2() {
	$("#deptDialog2").openDeptDialog();
}

function getDept2(dept) {
	if( !isNull(dept) ) {
		if( dept.level != 0 ) {
			$("#publishersName").val(dept.name);
			$("#publishersName").attr("originName", dept.originName);
			$("#publisherId").val(dept.id);
		} else {
			bootstrapAlert("提示", "请选择发布部门！", 400, null);
		}
	}
}

function save() {
//	var content = CKEDITOR.instances.contentCK.getData();
//	$("#content").attr("value", content);
	$("#content").attr("value", ue.getContent());
	var formData = $("#form1").serializeJson();
	var checkMsg = checkForm(formData);
	if( !isNull(checkMsg) ) {
		openBootstrapShade(false);
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(true);
	if(fileData != null) { // 已选择文件，则先上传文件
		fileData.submit();
	} else {
		submitForm();
	}
}


function del(processInstanceId) {
	bootstrapConfirm("提示", "确定要删除吗？", 300, function() {
		var compResult = deleteProcessInstance(processInstanceId);
		if(compResult.code == 1) {
			delNotice( $("#id").val() );
		} else {
			bootstrapAlert("提示", "删除流程时失败，失败信息：" + compResult.result, 400, null);
		}
	});
}


function delNotice(id) {
	$.ajax({
		url: web_ctx+"/manage/office/noitce/delete?id="+id,
		type: "get",
		dataType: "json",
		success: function(data) {
			if(!isNull(data) && data.code == 1) {
				window.parent.parent.initTodo();
				
				backPageAndRefresh();
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
		},
		error: function(e) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function submitForm() {
	 $.ajax({
		url: "save",
		type: "post",
		/*contentType: "application/json;charset=utf-8;",
		data: JSON.stringify($("#form1").serializeJson()),*/
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				window.parent.parent.initTodo();
				window.parent.parent.initNotice();
				
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", "提交失败，请重新提交！", 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function checkForm(formData) {
	var text = [];
	if( isNull(formData["title"]) ) {
		text.push("标题不能为空！");
	}
	if( isNull(formData["content"]) ) {
		text.push("内容不能为空！");
	}
	
	return text;
}

//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "notice/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        //acceptFileTypes: /(\.|\/)(gif|jpe?g|png|zip)$/i,
        maxFileSize: 30 * 1024 * 1024, // 30 MB
        autoUpload: false,
        disableValidation: false,
        messages: {
        	maxFileSize: '附件大小最大为30M！'
            //acceptFileTypes: 'File type not allowed'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#showName").val(data.files[0].name);
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
        		$("#showName").val(result.originName);
        		$("#attachments").val(result.path);
        		$("#attachName").val(result.originName);
        		
        		submitForm();
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        },
    });
}

function changeType(obj) {
	var value = $(obj).val();
	if(value == 1) {
		$("#saveBtn").text("提交审核");
	} else {
		$("#saveBtn").text("立即发布");
	}
}

// 预览
function preview() {
	var formData = $("#form1").serializeJson();
//	var content = CKEDITOR.instances.contentCK.getData();
	
	$("#modal_title").text(formData.title);
//	$("#modal_content").html(content);
	$("#modal_content").html(ue.getContent());
	var createDate = new Date().pattern("yyyy-MM-dd");
	if( !isNull($("#publishTime").val()) ) {
		var publishTime = new Date($("#publishTime").val());
		var now = new Date();
		if( now < publishTime ) {
			createDate = publishTime.pattern("yyyy-MM-dd");
		}
	}
	$("#modal_createDate").val( createDate );
	
	// 附件
	if( !isNull(formData.showName) ) {
		$("#modal_attachName").val(formData.showName);
		$("#modal_attachName").parents("tr").show();
	} else {
		$("#modal_attachName").parents("tr").hide();
	}
	
	// 签发人
	if( formData.type == "1" ) {
		$("#modal_type").val("通知");
		$("#modal_approver_span").show();
	} else {
		$("#modal_type").val("提示");
		$("#modal_approver_span").hide();
	}
	
	// 抄送范围
	if(isNull(formData.deptName)) {
		var deptName = [];
		$(parentDeptList).each(function(index, dept) {
			deptName.push(dept.name);
		});
		$("#modal_deptName").val(deptName.join(","));
	}
	else{
		$("#modal_deptName").text(formData.deptName.split(", ").join("\r\n"));
	}
	
	// 发布部门
	var companyName = "";
	var deptName = "";
	var dept = deptMap[$("#publisherId").val()];
	if( !isNull(dept) ) {
		var nodeLinks = dept.nodeLinks.split(",");
		if( nodeLinks.length > 3 ) {
			companyName = deptMap[nodeLinks[2]].name; // 数组的第3位是公司
		}
		deptName = dept.name;
	}
	
	if( !isNull($("#publishersName").attr("originName")) && 
			($("#publishersName").attr("originName").indexOf("总经理") > -1
			|| $("#publishersName").attr("originName").indexOf("副总经理") > -1) ) {
		deptName = "";
	}
	$("#modal_dept").val(companyName + " " + deptName);
	
	$("#noticeModal").modal("show");
}