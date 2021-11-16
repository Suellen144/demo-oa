$(function() {
	initFormValidate();
	initLevel();
	initDeptTree();
	
	$("#userDialog").initUserDialog({
		"callBack": getData
	});
});

var userChoice = null;
function openDialog(choice) {
	userChoice = choice;
	$("#userDialog").openUserDialog();
}

function getData(data) {
	if(data != null && typeof data != "undefined") {
		$("#"+userChoice+"Name").text(data.name);
		$("#"+userChoice+"Id").val(data.id);
	}
}

//初始化父级菜单树形下拉框及其相关操作 Begin
function initDeptTree() {
	if( !isNull($("#id").val()) ) {
		var deptData = getDeptData();
		if( !isNull(deptData) ) {
			var deptList = [];
			dept2List(deptData, deptList);

			var setting = {
				view: {
					dblClickExpand: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					onClick: deptClick
				}
			};
			
			$.fn.zTree.init($("#deptTree"), setting, deptList);
		}
		$.fn.zTree.getZTreeObj("deptTree").expandAll(true);
	}
}

function getDeptData() {
	var result = null;
	$.ajax({
		url: 'getDeptList',
		type: 'GET',
		async: false,
		success: function(data) {
			result = data;
		},
		error: function(err, errMsg) {
			bootstrapAlert("提示", "获取菜单数据出错，请联系管理员！", 400, null);
		}
	});
	
	return result;
}
function dept2List(deptData, list) {
	list.push(deptData);
	if( !isNull(deptData.children) ) {
		$(deptData['children']).each(function(index, child) {
			dept2List(child, list);
		});
	}
	
	$(list).each(function(index, data) {
		data['children'] = null;
		data['pId'] = data['parentId'];
	});
}

function showDept(input) {
	if( $("#deptContent").is(":hidden") ) {
		var offset = $(input).offset();
		$("#deptContent").css({left:offset.left + "px", top:offset.top + "px"}).slideDown("fast");
		setSelectedDept($("#parentId").val());
		
		$("body").bind("mousedown", onBodyDown);
	} else {
		hideDept();
	}
}
function hideDept() {
	$("#deptContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "deptBtn" || event.target.id == "deptContent" || $(event.target).parents("#deptContent").length>0)) {
		hideDept();
	}
}
function deptClick(e, treeId, treeNode) {
	var currId = $("#id").val();
	if( currId == treeNode.id || treeNode.nodeLinks.indexOf(currId) > -1 ) {
		bootstrapAlert("提示", "不能选择当前节点或子节点作为父节点！", 400, null);
	} else {
		$("#parentId").val(treeNode.id);
		$("#parentSel").val(treeNode.name);
	}
	hideDept();
}
function setSelectedDept(deptId) {
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	var node = zTree.getNodeByParam('id', deptId);
	if( !isNull(node) ) {
		zTree.selectNode(node, false, true);
	}
}
// 初始化父级菜单树形下拉框及其相关操作 End

function removePrincipal(choice) {
	$("#"+choice+"Id").val("");
	$("#"+choice+"Name").text("");
}

function checkCode() {
	var result = false;
	var params = {
		"id": $("#id").val(),
		"code": $("#code").val()
	};
	
	$.ajax( {   
        "type": "POST",    
        "url": "checkCode",    
        "dataType": "json",   	
        "data": params,
        "async": false,
        "success": function(data) {   
        	if(data.code == 1) {
        		result = true;
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
	return result;
}

function initFormValidate() {
	$("#form1").validate({
		rules: {
			name: {
				required: true
			},
	/*		code: {
				required: true,
				digits: true,
				rangelength:[4,4]
			},*/
		/*	sort: {
				required: true,
				digits: true,
				maxlength: 2
			}*/
		},
		messages: {
			name: {
				required: "部门名不能为空！",
			},
		/*	code: {
				required: "部门代码不能为空！",
				digits: "必须要四位数字！",
				rangelength: "必须要四位数字！"
			},*/
			/*sort: {
				required: "排序序号不能为空！",
				digits: "必须是数字！",
				maxlength: "最多两位数字！"
			}*/
		},
		submitHandler:function(form) {
		/*	if(!checkCode()) {
				return false;
			}*/
			return true;
		}
	});
}
function initLevel() {
	var value = $("#level").attr("value");
	if( !isNull(value) ) {
		$("#level").find("option").each(function(index, option) {
			if( $(option).attr("value") == value ) {
				$(option).prop("selected", true);
				return false;
			}
		});
	}
}