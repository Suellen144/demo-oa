$(function() {
//	initCkeditor();
	initUsernames();
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
	$("#applyTime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd",
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

function openuserIds() {
	$("#deptDialog").openDeptDialog($("#userIds").val());
}


function save() {
//	var content = CKEDITOR.instances.contentCK.getData();
//	$("#comment").attr("value", content);
	$("#comment").attr("value", ue.getContent());
	var formData = $("#form1").serializeJson();
	var checkMsg = checkForm(formData);
	if( !isNull(checkMsg) ) {
		openBootstrapShade(false);
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(false);
	saveForm();
}


//预览会议纪要
function preview() {
	var formData = $("#form1").serializeJson();
//	var content = CKEDITOR.instances.contentCK.getData();
	$("#modal_title").text(formData.theme);
//	$("#modal_content").html(content);
	$("#modal_content").html(ue.getContent());
	$("#createBy").val(formData.userName);
	$("#approver").val(formData.presenters);
	$("#type2").val(formData.participant);
	var createDate = new Date().pattern("yyyy-MM-dd");
	$("#modal_createDate").val( createDate );
	$("#meetingModal").modal("show");
}




function submitinfo() {
//	var content = CKEDITOR.instances.contentCK.getData();
//	$("#comment").attr("value", content);
	$("#comment").attr("value", ue.getContent());
	var formData = $("#form1").serializeJson();
	var checkMsg = checkForm(formData);
	if( !isNull(checkMsg) ) {
		openBootstrapShade(false);
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(false);
	submitForm();
}


function del() {
	var id = $("#id").val();
	bootstrapConfirm("提示", "确定要删除吗？", 300, function() {
	$.ajax({
		url: "delete?id="+id,
		type: "get",
		dataType: "json",
		success: function(data) {
			if(!isNull(data) && data.code == 1) {
				backPageAndRefresh();
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
		},
		error: function(e) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	});
}

function submitForm() {
	bootstrapConfirm("提示", "提交后将进行邮件通知，不可再次修改和撤回，确定提交吗？", 300, function(){
		$("#status").val("1");	
		 $.ajax({
			url: "save",
			type: "post",
			data: $("#form1").serializeJson(),
			dataType: "json",
			success: function(data) {
				openBootstrapShade(true);
				if(data.code == 1) {
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
		}, null);
}


function saveForm() {
	$("#status").val("");	
	 $.ajax({
		url: "save",
		type: "post",
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
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


function savename(){
	$("#status").val("");	
	 $.ajax({
		url: "save",
		type: "post",
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
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
	if( isNull(formData["theme"]) ) {
		text.push("主题不能为空！");
	}
	if (isNull(formData["presenters"])) {
		text.push("主持人不能为空！");
	}
	if( isNull(formData["comment"]) ) {
		text.push("内容不能为空！");
	}
	
	return text;
}


function openuserIds(){
	var userIds = [];
	$("#deptModal").modal("show");
	
}


/*--------- 部门人员树 ------------*/

$(document).ready(function(){
	$.fn.zTree.init($("#deptUserTree"), setting);
});

//获取部门信息
var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: true,
			chkboxType: { "Y": "s", "N": "s" }
		},
		data: {
            simpleData: {
	            enable: true,
	            idKey: "id",
	            pIdKey: "parentId",
	            rootPId: -1
            }
    	},
		async: {
			type: "get",
            enable: true,
			url: web_ctx+"/manage/sys/dept/getDeptWithUserInList"
		},
		callback: {
			onAsyncSuccess: expandAll
		}
};

//展开树
function expandAll() {
	var treeObj = $.fn.zTree.getZTreeObj("deptUserTree"); 
	treeObj.expandAll(true);	
}

function getdept() {
	var deptJson = [];
	$.ajax({
		url: "getDeptList?timetamp="+new Date().getTime(),
		async: false,
		dataType: "json",
		success: function(data) {
			deptJson = data;
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return deptJson;
}


function initUsernames(){
	if (userIds != null && userIds != "") {
		var deptJson = [];
		$.ajax({
			url: web_ctx+"/manage/sys/user/findByUserIds",
			type : 'POST',  
			data: { "userIdList": userIds },
			traditional: true,
			async: false,
			dataType: "json",
			success: function(data) {
				deptJson = data;
			},
			error: function() {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		$("#usernames").val(deptJson);
	}
}


//保存所选择的部门
function setDept() {
	var deptNames = getDept();
	var userIds = getDeptId();
	$("#userids").val(userIds);
	$("#usernames").val(deptNames.join(","));
	$("#participant").val(deptNames.join(","));
}

// 获取选择的部门
function getDept() {
	var resultId = [];
	var resultName = [];
	var zTree = $.fn.zTree.getZTreeObj("deptUserTree");  
    var nodes = zTree.getChangeCheckedNodes(true); 
   
    if(nodes.length == 1){
    	resultId.push(nodes[0].id);
		var topParent = nodes[0].getParentNode().getParentNode();
		if(isNull(topParent) || topParent.parentId == '-1'){
			var parent = nodes[0].getParentNode();
			if(isNull(parent) || parent.parentId == '-1'){
				resultName.push($.trim(nodes[0].name+"\r"));
			}else{
				resultName.push(nodes[0].name+"\r");
			}
			
		}else if(topParent.parentId != '-1'){
			resultName.push(nodes[0].name+"\r");
		}
    	
    }else{
	    $.each(nodes,function(index, node) {
	    	var d = node.getParentNode();
	    	if (d != null) {
	    		if(node.getParentNode().parentId == '-1'){
		    		//如果上级部门是组织机构且有子目录就不显示当前阶段部门
		    		if(typeof node.children == "undefined" || node.children == null || node.children.length == 0){
		    			resultId.push(node.id);
		            	resultName.push($.trim(node.name)+"\r");
		    		}
		    	}
		    	else if(typeof node.children == "undefined" || node.children == null || node.children.length == 0){
		    		 //如果有下级部门，当前部门不显示，只显示子部门
		    		resultId.push(node.id);
		    		var topParent = node.getParentNode().getParentNode();
		    		if(isNull(topParent) || topParent.parentId == '-1'){
		    			var parent = node.getParentNode();
		    			if(isNull(parent) || parent.parentId == '-1'){
		    				resultName.push($.trim(node[0].name+"\r"));
		    			}else{
		    				resultName.push(node.name+"\r");
		    			}
		    			
		    		}else if(topParent.parentId != '-1'){
		    			resultName.push(node.name+"\r");
		    		}
		        	
		    	}
			}
	    	else {
	    		/*resultName.push("全体"+"\r");*/
			}
	    
	    });
    }
    
	return resultName;
}


function getDeptId() {
	var resultId = [];
	var resultName = [];
	var zTree = $.fn.zTree.getZTreeObj("deptUserTree");  
    var nodes = zTree.getChangeCheckedNodes(true); 
   
    if(nodes.length == 1){
    	resultId.push(nodes[0].id.replace("user_", ""));
		var topParent = nodes[0].getParentNode().getParentNode();
		if(isNull(topParent) || topParent.parentId == '-1'){
			var parent = nodes[0].getParentNode();
			if(isNull(parent) || parent.parentId == '-1'){
				resultName.push($.trim(nodes[0].name+"\r"));
			}else{
				resultName.push($.trim(nodes[0].getParentNode().name)+nodes[0].name+"\r");
			}
			
		}else if(topParent.parentId != '-1'){
			resultName.push($.trim(topParent.name) + $.trim(nodes[0].getParentNode().name)+nodes[0].name+"\r");
		}
    	
    }else{
	    $.each(nodes,function(index, node) {
	    	var d = node.getParentNode();
			if (d != null) {
				if(node.getParentNode().parentId == '-1'){
		    		//如果上级部门是组织机构且有子目录就不显示当前阶段部门
		    		if(typeof node.children == "undefined" || node.children == null || node.children.length == 0){
		    			if (node.id.indexOf("dept") == -1) {
		    				resultId.push(node.id.replace("user_", ""));
						}
		            	resultName.push($.trim(node.name)+"\r");
		    		}
		    	}else if(typeof node.children == "undefined" || node.children == null || node.children.length == 0){
		    		 //如果有下级部门，当前部门不显示，只显示子部门
		    		if (node.id.indexOf("dept") == -1) {
	    				resultId.push(node.id.replace("user_", ""));
					}
		    		var topParent = node.getParentNode().getParentNode();
		    		if(isNull(topParent) || topParent.parentId == '-1'){
		    			var parent = node.getParentNode();
		    			if(isNull(parent) || parent.parentId == '-1'){
		    				resultName.push($.trim(node[0].name+"\r"));
		    			}else{
		    				resultName.push($.trim(node.getParentNode().name)+node.name+"\r");
		    			}
		    			
		    		}else if(topParent.parentId != '-1'){
		    			resultName.push($.trim(topParent.name) + $.trim(node.getParentNode().name)+node.name+"\r");
		    		}
		        	
		    	}
							
			}
			else{
				
			}
	    	
	    });
    }
    
	return resultId;
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


