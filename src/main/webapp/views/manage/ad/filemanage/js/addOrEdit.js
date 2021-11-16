var zTree, rMenu, currNode;
var deptList = [];
var deptNameMap = {};

//获取部门信息
var setting = {
		view: {
			selectedMulti: false
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
			url: "getDirWithFileInList"
		},
		callback: {
			onClick: processNodeData,
			onAsyncSuccess: expandFirst,
			onRightClick: rightClick
		}
};

$(document).ready(function(){
	$.fn.zTree.init($("#fileTree"), setting);
	makeValidRule();
	initDeptList();
	initInput();
});


//树结构单击事件
function processNodeData(event, treeId, treeNode) {
	if( !isNull(treeNode.isDir) ) {
		currNode = treeNode;
		editDir();
	} else if( !isNull(treeNode.isFile) ) {
		currNode = treeNode;
		editFile();
	} else {
		$("#dirForm").hide();
		$("#fileForm").hide();
		$("#title").text("");
	}
}
//展开树
function expandFirst() {
	zTree = $.fn.zTree.getZTreeObj("fileTree");
	rMenu = $("#rMenu");
	// 展开第一个节点
	var nodes = zTree.getNodes();
	if (nodes.length > 0) {
		zTree.expandNode(nodes[0], true, false, false);
	}
}

function rightClick(event, treeId, treeNode) {
	if (treeNode && !treeNode.noR) {
		currNode = treeNode;
		zTree.selectNode(treeNode);
		if( !isNull(treeNode.isRoot) ) {
			showRMenu("root", event.clientX, event.clientY-50);
		} else if( !isNull(treeNode.isDir) ) {
			showRMenu("dir", event.clientX, event.clientY-50);
		} else if( !isNull(treeNode.isFile) ) {
			showRMenu("file", event.clientX, event.clientY-50);
		}
	}
}

function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if (type == "root") {
		$("#add_dir").show();
//		$("#edit_dir").hide();
		$("#del_dir").hide();
		
		$("#add_file").hide();
//		$("#edit_file").hide();
		$("#del_file").hide();
	} else if(type == "dir") {
		$("#add_dir").show();
//		$("#edit_dir").show();
		$("#del_dir").show();
		
		$("#add_file").show();
//		$("#edit_file").hide();
		$("#del_file").hide();
	} else if(type == "file") {
		$("#add_dir").hide();
//		$("#edit_dir").hide();
		$("#del_dir").hide();
		
		$("#add_file").hide();
//		$("#edit_file").show();
		$("#del_file").show();
	} else {
		$("#add_dir").hide();
//		$("#edit_dir").hide();
		$("#del_dir").hide();
		
		$("#add_file").hide();
//		$("#edit_file").hide();
		$("#del_file").hide();
	}
	
	
	rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", onBodyMouseDown);
}

function onBodyMouseDown(event) {
	if ( !(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0) ) {
		rMenu.css({"visibility" : "hidden"});
	}
}

function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}

/**
 * 目录相关操作
 * */
function addDir() {
	hideRMenu();
	$("#dirForm").clear();
	$("#parentDir").prop("readonly", true);
	$("#title").text("新增目录");
	$("#dirOper").val("add");
	$("#deptName").attr("onclick","openDept()");
	$("#parentDir").val(currNode.name);
	if(currNode.deptIds != null && currNode.deptIds != "" && currNode.parentId != -1){
		ajaxCurrDept(currNode.deptIds);
	}else{
		$("#deptDialog").initDeptDialog({
			"callBack": getDept
		});
	}
	
	$("#dirForm").show();
	$("#fileForm").hide();
}

function editDir() {
	$("#dirForm").clear();
	$("#dirForm").find("input[name='deptName']").val("");
	$("#parentDir").prop("readonly", true);
	$("#deptName").attr("onclick","openDept()");
	$("#parentDir").val(currNode.getParentNode().name);
	$("#dirForm").find("input[name='name']").val(currNode.name);
	$("#dirForm").find("input[name='deptIds']").val(currNode.deptIds);
	$("#dirForm").find("textarea[name='comment']").val(currNode.comment);
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept
	});
	
	if( !isNull(currNode.deptIds) ) {
		var deptName = [];
		var deptIds = currNode.deptIds.split(",");
		$(deptIds).each(function(index, id) {
			if( !isNull(deptNameMap[id]) ) {
				deptName.push(deptNameMap[id]);
			}
		});
		
		$("#dirForm").find("input[name='deptName']").val(deptName.join(","));
	}
	
	$("#title").text("编辑目录");
	$("#dirOper").val("edit");
	$("#dirForm").show();
	$("#fileForm").hide();
}

function delDir() {
	hideRMenu();
	bootstrapConfirm("提示", "子目录以及文件会被删除！确认是否删除目录？", 400, function() {
		$.ajax({
			url: "dirDelete",
			type: "POST",
			dataType: "json",
			data: {"id": currNode.id.replace("dir_", "")},
			success:function(data){
				if(data.code == 1) {
					bootstrapAlert("提示", "删除目录成功！", 400, function() {
						zTree.removeNode(currNode);
						$("#dirForm").hide();
						$("#fileForm").hide();
						$("#title").text("");
						$.fn.zTree.init($("#fileTree"), setting);
						expandFirst();
					});
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	});
}

function saveDir() {
	if( !dirExists() ) {
		var json = $("#dirForm").serializeJson();
		
		if($("#dirOper").val() == "add") {
			json["parentId"] = currNode.id.replace("dir_", "");
			json["parentsId"] = currNode.parentsId + "," + currNode.id.replace("dir_", "");
		} else if($("#dirOper").val() == "edit") {
			json["id"] = currNode.id.replace("dir_", "");
		}
		
		//保存前判断当前选择的部门是否是上级目录所属部门，或是上级目录所属部门的下级部门，不是要求重新选择
		var parentDeptIds = currNode.deptIds;
		var currDeptIds = $("#deptIds").val();
		/*if(parentDeptIds != null && parentDeptIds != "" && currNode.parentId.replace("dir_", "") != -1 && 
				currDeptIds != null && currDeptIds != ""){
			ajaxDept(parentDeptIds,currDeptIds,json);
			
		}else{
			dirSaveOrUpdate(json)
		}*/
		dirSaveOrUpdate(json)
		
	} else {
		bootstrapAlert("提示", "该目录已存在！", 400, null);
	}
}



function ajaxDept(parentDeptIds,currDeptIds,json){
	$.ajax({
		url: "ajaxDepts",
		type: "POST",
		dataType: "json",
		data: {"parentDeptIds":parentDeptIds, "currDeptIds":currDeptIds},
		success:function(data){
			if(data.code != null && data.code != "" && data.code == 1 && data.result.length >0  ) {
				bootstrapAlert("提示", "当前所属部门不在上级目录所属部门的范围内，请重新选择！", 400, function() {
					$("#deptIds").val("");
					$("#deptName").val("");
					
				});
			}else{
				dirSaveOrUpdate(json);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

//查看当前目录是不是第三级部门如：市场部，是，当前目录下新增的目录所属部门默认当前目录部门
function ajaxCurrDept(deptIds){
	var flag=true;
	$.ajax({
		url: "ajaxCurrDept",
		type: "POST",
		dataType: "json",
		data: {"deptIds":deptIds},
		success:function(data){
			if(data.code == 1){
				flag=false;
				$("#deptIds").val(data.result);
				$("#deptName").val(deptNameMap[data.result]);
				$("#deptName").removeAttr("onclick");
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function dirSaveOrUpdate(json){
	$.ajax({
		url: "dirSaveOrUpdate",
		type: "POST",
		dataType: "json",
		data: json,
		success:function(data){
			if(data.code == 1) {
				bootstrapAlert("提示", "保存目录成功！", 400, function() {
					var dir = data.result;
					
					if($("#dirOper").val() == "add") {
						var newNode = {};
						newNode["id"] = "dir_" + dir.id;
						newNode["parentId"] = "dir_" + dir.parentId;
						newNode["parentsId"] = dir.parentsId;
						newNode["deptIds"] = dir.deptIds;
						newNode["name"] = dir.name
						newNode["comment"] = dir.comment;
						newNode["icon"] = web_ctx + "/static/images/dir.png";
						newNode["isDir"] = true;
						newNode = zTree.addNodes(currNode, newNode);
						
						$("#dirOper").val("edit");
						currNode = newNode[0];
						$.fn.zTree.init($("#fileTree"), setting);
						expandFirst();
					} else if($("#dirOper").val() == "edit") {
						/*currNode["id"] = "dir_" + dir.id;
						currNode["parentId"] = "dir_" + dir.parentId;
						currNode["parentsId"] = dir.parentsId;
						currNode["deptIds"] = dir.deptIds;
						currNode["name"] = dir.name
						currNode["comment"] = dir.comment;
						currNode["icon"] = web_ctx + "/static/images/dir.png";
						currNode["isDir"] = true;
						zTree.updateNode(currNode);*/
						$.fn.zTree.init($("#fileTree"), setting);
						expandFirst();
					}
				});
			} else {
				bootstrapAlert("提示", "保存目录出错，请联系管理员！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function resetDeptForm() {
	var oper = $("#dirOper").val();
	if(oper == "add") {
		addDir();
	} else if(oper == "edit") {
		editDir();
	}
}

function dirExists() {
	var result = true;
	if( !isNull(currNode) ) {
		var params = {
			"parentId": currNode.id.replace("dir_", ""),
			"dirName": $("#dirForm").find("#name").val()
		}
		
		$.ajax({
			url: "dirExists",
			type: "POST",
			dataType: "json",
			data: params,
			async: false,
			success:function(data){
				if( !isNull(data) && data.code == 1 && data.result == false ) {
					result = false;
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
	
	return result;
}

function openDept() {
	/*if(currNode.deptIds == null || currNode.deptIds == "" || currNode.parentId ==-1 ){
		$("#deptDialog").openDeptDialog($("#deptIds").val());
	}*/
	if(currNode.parentId ==-1 || currNode.parentId =="dir_1"){
		$("#deptDialog").openDeptDialog($("#deptIds").val());
	}else{
		if(!checkDir(currNode.id.replace("dir_", ""))){
			$("#deptDialog").openDeptDialog($("#deptIds").val());
		}
	}
}

//查看该目录是否是二级目录及其下面是否含有子级目录
function checkDir(id){
	var flag=true;
	$.ajax({
		url: "checkDir",
		type: "POST",
		dataType: "json",
		data: {"id":id},
		async: false,
		success:function(data){
			if( !isNull(data) && data.code == 1 && data.result == false ) {
				flag = false;
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	return flag;
}


function getDept(deptList) {
	if( !isNull(deptList)) {
		$("#deptIds").val(deptList.id);
		$("#deptName").val(deptList.name);
	}
}






/**
 * 文件相关操作
 * */
function addFile() {
	hideRMenu();
	$("#fileForm").clear();
	$("#showName").val("");
	$("#fileDir").prop("readonly", true);
	$("#showName").prop("readonly", true);
	
	$("#title").text("新增文件");
	$("#fileOper").val("add");
	$("#fileDir").val(currNode.name);
	/*$("#fileForm").find("select[name='type']").find("option:first").prop("selected", true);*/
	
	initFileUpload();
	
	$("#dirForm").hide();
	$("#fileForm").show();
	
}

function editFile() {
	$("#fileForm").clear();
	$("#fileDir").prop("readonly", true);
	$("#showName").prop("readonly", true);
	
	initFileUpload(currNode.filePath);
	
	$("#fileDir").val(currNode.getParentNode().name);
	$("#fileForm").find("input[name='showName']").val(currNode.name);
	$("#fileForm").find("textarea[name='comment']").val(currNode.comment);
	
	$("#fileForm").find("input[name='name']").val(currNode.fileName);
	$("#fileForm").find("input[name='originName']").val(currNode.originName);
	$("#fileForm").find("input[name='filePath']").val(currNode.filePath);
	$("#fileForm").find("select[name='type']").val(currNode.type);
	
	
	$("#title").text("编辑文件");
	$("#fileOper").val("edit");
	$("#dirForm").hide();
	$("#fileForm").show();
}

function delFile() {
	hideRMenu();
	
	bootstrapConfirm("提示", "是否删除文件？", 400, function() {
		$.ajax({
			url: "fileDelete",
			type: "POST",
			dataType: "json",
			data: {"id": currNode.id.replace("file_", "")},
			success:function(data){
				if(data.code == 1) {
					bootstrapAlert("提示", "删除文件成功！", 400, function() {
						zTree.removeNode(currNode);
						$("#dirForm").hide();
						$("#fileForm").hide();
						$("#title").text("");
						$.fn.zTree.init($("#fileTree"), setting);
						expandFirst();
					});
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	});
}

function saveFile() {
	var json = $("#fileForm").serializeJson();
	
	if($("#fileOper").val() == "add") {
		json["directoryId"] = currNode.id.replace("dir_", "");
	} else if($("#fileOper").val() == "edit") {
		json["id"] = currNode.id.replace("file_", "");
	}
	
	$.ajax({
		url: "fileSaveOrUpdate",
		type: "POST",
		dataType: "json",
		data: json,
		success:function(data){
			if(data.code == 1) {
				bootstrapAlert("提示", "保存文件成功！", 400, function() {
					var file = data.result;
					
					if($("#fileOper").val() == "add") {
						var newNode = {};
						newNode["id"] = "file_" + file.id;
						newNode["parentId"] = "file_" + file.directoryId;
						newNode["filePath"] = file.filePath;
						newNode["name"] = file.originName;
						newNode["fileName"] = file.name;
						newNode["originName"] = file.originName;
						newNode["type"] = file.type;
						newNode["comment"] = file.comment;
						newNode["icon"] = web_ctx + "/static/images/file.png";
						newNode["isFile"] = true;
						newNode = zTree.addNodes(currNode, newNode);
						
						initFileUpload(newNode[0].filePath);
						$("#fileOper").val("edit");
						currNode = newNode[0];
						$.fn.zTree.init($("#fileTree"), setting);
						expandFirst();
					} else if($("#fileOper").val() == "edit") {
						currNode["id"] = "file_" + file.id;
						currNode["parentId"] = "dir_" + file.directoryId;
						currNode["filePath"] = file.filePath;
						currNode["name"] = file.originName;
						currNode["fileName"] = file.name;
						currNode["originName"] = file.originName;
						currNode["type"] = file.type;
						currNode["comment"] = file.comment;
						currNode["icon"] = web_ctx + "/static/images/file.png";
						currNode["isFile"] = true;
						
						initFileUpload(currNode.filePath);
						zTree.updateNode(currNode);
					}
				});
			} else {
				bootstrapAlert("提示", "保存文件出错，请联系管理员！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function() {
			openBootstrapShade(false);
		}
	});
}

function submitFile() {
	if( !fileExists() ) {
		if(fileData != null) {
			openBootstrapShade(true);
			fileData.submit();
		} else {
			saveFile();
		}
	} else {
		 bootstrapConfirm("提示","该文件已存在，是否覆盖？",400,function(){
			 openBootstrapShade(true);
			 fileData.submit();
			 /*coverFile()；*/
		 	}
		 ,null);
	}	
}

//文件覆盖
function coverFile(){
var json = $("#fileForm").serializeJson();
	json["id"] = fileValue.id;
	json["directoryId"]=fileValue.directoryId;
	/*json["name"]=fileValue.name;
	json["originName"] = fileValue.originName;
	json["filePath"]=fileValue.filePath;*/
	json["deptIds"] = fileValue.deptIds;
	json["type"]=fileValue.type;
	$.ajax({
		url: "fileSaveOrUpdate",
		type: "POST",
		dataType: "json",
		data: json,
		async: false,
		success:function(data){
			if(data.code == 1) {
				bootstrapAlert("提示", "保存文件成功！", 400, function() {
					/*var file = data.result;
					var newNode = {};
						currNode["id"] = "file_" + file.id;
						currNode["parentId"] = "dir_" + file.directoryId;
						currNode["filePath"] = file.filePath;
						currNode["name"] = file.originName;
						currNode["fileName"] = file.name;
						currNode["originName"] = file.originName;
						currNode["type"] = file.type;
						currNode["comment"] = file.comment;
						currNode["icon"] = web_ctx + "/static/images/file.png";
						currNode["isFile"] = true;
						initFileUpload(currNode.filePath);
						zTree.updateNode(currNode);*/
					/*$.fn.zTree.init($("#fileTree"), setting);*/
					/*makeValidRule();
					initDeptList();*/
					initFileUpload(currNode.filePath);
					zTree.updateNode(currNode);
				});
			} else {
				bootstrapAlert("提示", "保存文件出错，请联系管理员！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function() {
			openBootstrapShade(false);
		}
	});
}


function delExists(){
	$.ajax({
		url: "fileDelete",
		type: "POST",
		dataType: "json",
		data: {"id": currNode.id.replace("file_", "")},
		success:function(data){
			if(data.code == 1) {
				bootstrapAlert("提示", "删除文件成功！", 400, function() {
					zTree.removeNode(currNode);
					$("#dirForm").hide();
					$("#fileForm").hide();
					$("#title").text("");
					initFileUpload(currNode.filePath);
					zTree.updateNode(currNode);
				});
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function resetFileForm() {
	var oper = $("#fileOper").val();
	if(oper == "add") {
		addFile();
	} else if(oper == "edit") {
		editFile();
	}
}
var fileValue=""
function fileExists() {
	var result = true;
	if( !isNull(currNode) ) {
		var params = {
			"fileName": $("#showName").val()
		}
		
		if($("#fileOper").val() == "edit") {
			params["parentId"] = currNode.parentId.replace("dir_", "")
			params["id"] = currNode.id.replace("file_", "");
		} else {
			params["parentId"] = currNode.id.replace("dir_", "")
		}
		existsValue=params;
		$.ajax({
			url: "fileExists",
			type: "POST",
			dataType: "json",
			data: params,
			async: false,
			success:function(data){
				if(isNull(data)){
					result = false;
				}else{
					fileValue=data;
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
	
	return result;
}

//制定添表单验证规则
function makeValidRule() {
    $("#dirForm").validate({
        rules: {
            name: {required: true}
        },
        messages: {
        	name: {required: "目录名不能为空！"}
        },
        submitHandler:function(form) {
        	saveDir();
        	return false;
		}
    });
    
    $("#fileForm").validate({
        rules: {
            showName: {required: true}
        },
        messages: {
        	showName: {required: "上传文件不能为空！"}
        },
        submitHandler:function(form) {
        	submitFile();
        	return false;
		}
    });
}

// 缓存部门数据
function initDeptList() {
	$.ajax({
		url:web_ctx + "/manage/sys/dept/getDeptListOnJson",
		type: "GET",
		dataType: "JSON",
		success:function(data) {
			deptList = data;
			$(deptList).each(function(index, dept) {
				deptNameMap[dept.id] = dept.name;
			});
		}
	});
}

//文件上传
var fileData = null;
function initFileUpload(deleteFile) {
	fileData = null;
	var date = new Date();
	var params = {
		"path": "fileManage/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};
	if( !isNull(deleteFile) ) {
		params["deleteFile"] = deleteFile;
	}
	
	var urlParam = "";
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
        	maxFileSize: '文件大小最大为50M！'
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
        		$("#fileForm").find("input[name='filePath']").val(result.path);
        		$("#fileForm").find("input[name='originName']").val(result.originName);
        		$("#fileForm").find("input[name='name']").val(result.name);
        		if(isNull(fileValue)){
        			saveFile();
        		}else{
        			coverFile();
        		}
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}