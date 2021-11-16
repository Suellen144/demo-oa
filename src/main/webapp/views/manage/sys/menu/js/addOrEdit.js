$(function() {
	initDialog();
	initMenuTree();
	makeFormValidator();
});

function initDialog() {
	$("#iconDialog").initIconsDialog({
		"callBack": getIconClass
	});
}

// 初始化父级菜单树形下拉框及其相关操作 Begin
function initMenuTree() {
	if( !isNull($("#id").val()) ) {
		var menuData = getMenuData();
		if( !isNull(menuData) ) {
			var menuList = [];
			menu2List(menuData, menuList);
			
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
					onClick: menuClick
				}
			};
			
			$.fn.zTree.init($("#menuTree"), setting, menuList);
		}
		$.fn.zTree.getZTreeObj("menuTree").expandAll(true);
	}
}

function getMenuData() {
	var result = null;
	$.ajax({
		url: 'getMenuList',
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
function menu2List(menuData, list) {
	list.push(menuData);
	if( !isNull(menuData.children) ) {
		$(menuData['children']).each(function(index, child) {
			menu2List(child, list);
		});
	}
	
	$(list).each(function(index, data) {
		data['children'] = null;
		data['pId'] = data['parentId'];
		delete data['url'];
	});
}

function showMenu(input) {
	if( $("#menuContent").is(":hidden") ) {
		var offset = $(input).offset();
		$("#menuContent").css({left:offset.left + "px", top:offset.top + "px"}).slideDown("fast");
		setSelectedMenu($("#parentId").val());
		
		$("body").bind("mousedown", onBodyDown);
	} else {
		hideMenu();
	}
}
function hideMenu() {
	$("#menuContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
		hideMenu();
	}
}
function menuClick(e, treeId, treeNode) {
	var currId = $("#id").val();
	if( currId == treeNode.id || treeNode.parentsId.indexOf(currId) > -1 ) {
		bootstrapAlert("提示", "不能选择当前节点或子节点作为父节点！", 400, null);
	} else {
		$("#parentId").val(treeNode.id);
		$("#parentSel").val(treeNode.name);
	}
	hideMenu();
}
function setSelectedMenu(menuId) {
	var zTree = $.fn.zTree.getZTreeObj("menuTree");
	var node = zTree.getNodeByParam('id', menuId);
	if( !isNull(node) ) {
		zTree.selectNode(node, false, true);
	}
}
// 初始化父级菜单树形下拉框及其相关操作 End


function makeFormValidator() {
	$("#form1").validate({
		rules: {
			sort: {
				digits: true,
				maxlength:5
			},
			name: {
				required: true,
				maxlength :12
			},
			permission: {
				permissionRule: true
			}
		},
		messages: {
			sort: {
				digits: "输入值为0或正整数！",
				maxlength: "请不要超过5位数！"
			},
			name: {
				required: "菜单名不能为空！",
				maxlength: "请不要超过12个字符！"
			}
		
		}
	});
}

function goBack() {
	backPageAndRefresh();
}

function openDialog() {
	$("#iconDialog").openIconsDialog();
}

function getIconClass(iconClass) {
	if(iconClass != null && typeof iconClass != "undefined") {
		$("#icon").val(iconClass);
		$("#icon_li").removeClass();
		$("#icon_li").addClass("col-sm-1 "+iconClass);
	}
}