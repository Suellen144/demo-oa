$(function() {
	var menuList = getMenu();
	var tableHtml = buildTable(menuList);
	$("#treetable tbody").html(tableHtml);
	
	$("#treetable").treetable({ expandable: true });
	$("#treetable").treetable("expandAll");
	
	initTrEvent();
});

function getMenu() {
	var menuList = [];
	$.ajax({
		url: web_ctx+"/manage/sys/menu/getMenuList",
		async: false,
		dataType: "json",
		success: function(data) {
			menuList = data;
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return menuList;
}

function buildTable(menuList) {
	var html = [];
	
	$(menuList).each(function(index, obj) {
		if(obj.enabled != 0) {
			if(obj.children == null 
					|| typeof obj.children == "undefined") {
				html.push(buildTr(obj));
			} else {
				var childHtml = buildTable(obj.children);
				html.push(buildTr(obj));
				html.push(childHtml);
			}
		}
	});
	
	return html.join("");
}

function buildTr(menu) {
	var html = [];
	html.push('<tr data-tt-id="'+menu.id+'" data-tt-parent-id="'+menu.parentId+'">');
	if(juedeMenu(menu.id)) {
		html.push('<td nowrap><label class="checkbox-inline"><input type="checkbox" onclick="checkMenu(this)" style="vertical-align:middle; margin-top:0;" id="'+menu.id+'" pids="'+menu.parentsId+'" checked>'+menu.name+'</label></td>');
	} else {
		html.push('<td nowrap><label class="checkbox-inline"><input type="checkbox" onclick="checkMenu(this)" style="vertical-align:middle; margin-top:0;" id="'+menu.id+'" pids="'+menu.parentsId+'">'+menu.name+'</label></td>');
	}
	html.push('<td><div>');
	html.push(buildPermission(menu.permissionList));
	html.push('</div></td>');

	if(dpModule[menu.name]) {
		html.push('<td><a href="javascript:void(0);" onclick="showModel('+menu.id+')" style="font-size:1.3em;">数据授权</a></td></tr></div>');
	} else {
		html.push('<td></td></tr></div>');
	}
	
	return html.join('');
}

function buildPermission(permissionList) {
	if(permissionList == null || typeof(permissionList) == "undefined" || permissionList.length < 1) {
		return "";
	}
	
	var html = [];
	$.each(permissionList, function(index, obj) {
		if(juedePermission(obj.id)) {
			var element = '<label class="checkbox-inline"><input type="checkbox" onclick="checkParent(this)" style="vertical-align:middle; margin-top:0;" id="'+obj.id+'" checked> '+permissMap[obj.code]+'</label>';
		} else {
			var element = '<label class="checkbox-inline"><input type="checkbox" onclick="checkParent(this)" style="vertical-align:middle; margin-top:0;" id="'+obj.id+'"> '+permissMap[obj.code]+'</label>';
		}
		html.push(element);
	});
	
	return html.join("");
}

function checkParent(checkbox) {
	var that = checkbox;
	var inputcheck = $(that).parent().parent().find("input[type='checkbox']:checked").length;
	if($(that).prop("checked") == true){		
		$(that).parent().parent().parent().prev().find(".checkbox-inline input").prop("checked",inputcheck > 0?true:false);
	}else{
		$(that).parent().parent().parent().prev().find(".checkbox-inline input").prop("checked",inputcheck == 0?false:true);		
	}
}


function checkMenu(checkbox) {
	var that = checkbox;
	// 选中，往上的父节点都要选中状态
	if(checkbox.checked) {
		var pidsText = $(checkbox).attr("pids");
		var pids = pidsText.split(",");
		$(pids).each(function(index, pid) {
			$("#treetable tbody").children("tr").each(function(index, tr) {
				if($(tr).children("td:first").find("input[type='checkbox']").attr("id") == pid) {
					$(tr).children("td:first").find("input[type='checkbox']").prop("checked", true);
				}
			});
		});
	} else { // 取消选择，往下的子节点都要取消选择
		var id = $(checkbox).attr("id");
		$("#treetable tbody").children("tr").each(function(index, tr) {
			var pids = $(tr).children("td:first").find("input[type='checkbox']").attr("pids").split(",");
			$(pids).each(function(index, pid) {
				if(id == pid) {
					$(tr).children("td:first").find("input[type='checkbox']").prop("checked", false);
				}
			});
		});
		$(that).parent().parent().next().find(".checkbox-inline input").each(function(index,ele){
			$(ele).attr("checked",false);
		})
	}
}

function juedeMenu(menuid) {
	var flag = false;
	$(role.menuList).each(function(index, menu) {
		if(menuid == menu.id) {
			flag = true;
			return ;
		}
	});
	
	return flag;
}

function juedePermission(permissionid) {
	var flag = false;
	$(role.permissionList).each(function(index, permission) {
		if(permissionid == permission.id) {
			flag = true;
			return ;
		}
	});
	
	return flag;
}

function doAuthority() {
	var menuidList = [];
	var permissionidList = [];
	var dataPermission = getDataPermission();
	
	$("#treetable tbody").children("tr").each(function(index, tr) {
		if($(tr).children("td:first").find("input[type='checkbox']").prop("checked")) {
			menuidList.push($(tr).children("td:first").find("input[type='checkbox']").attr("id"));
		}
	});
	
	$("#treetable tbody").children("tr").each(function(index, tr) {
		var checkboxList = $($(tr).children("td")[1]).find("input[type='checkbox']");
		$(checkboxList).each(function(index, checkbox) {
			if($(checkbox).prop("checked")) {
				permissionidList.push($(checkbox).attr("id"));
			}
		});
	});
	
	$.ajax({
		url: "saveAuthority",
		type: "post",
		async: false,
		data: {"menuidList": menuidList, "permissionidList": permissionidList, "roleId": role.id, "dataPermissionList": JSON.stringify(dataPermissionList)},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", "授权成功！", 400, function() {
					window.location.href = "toList";
				});
			} else {
				bootstrapAlert("提示", "授权失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

/*--------- 数据权限 ------------*/

$(document).ready(function(){
	$.fn.zTree.init($("#deptTree"), setting);
});

//获取部门信息
var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: true
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
			url: web_ctx+"/manage/sys/dept/getDeptListOnJson"
		},
		callback: {
			onAsyncSuccess: expandAll
		}
};

//展开树
function expandAll() {
	var treeObj = $.fn.zTree.getZTreeObj("deptTree"); 
	treeObj.expandAll(true);	
	initCheckedClick();
}

function showModel(menuId) {
	var deptIds = "";
	if(dataPermissionList != null && dataPermissionList.length > 0) {
		$(dataPermissionList).each(function(index, dataPermission) {
			if(menuId == dataPermission.menuId) {
				deptIds = dataPermission.deptIds;
				return ;
			}
		});
	}
	
	initTreeChecked(deptIds);
	$("#menuId").val(menuId);
	$("#authorityModal").modal("show");
}

// 设置部门树选中状态
function initTreeChecked(deptIds) {
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	zTree.checkAllNodes(false);
	if(deptIds != null && deptIds.length > 0) {
		var ids = deptIds.split(",");
		$(ids).each(function(index, id) {
			var node = zTree.getNodeByParam("id", id);
			if( !isNull(node) ) {
				zTree.checkNode(node, true, false);
				zTree.updateNode(node);
			}
		});
	}
}

// 设置点击节点名设置复选框的选中状态
function initCheckedClick() {
	$("a[treenode_a]").click(function() {
		$(this).prev("span[treenode_check]").trigger("click");
	});
}

// 保存所选择的数据权限
function setDataPermission() {
	var deptIds = getDataPermission().join(",");
	var flag = true;
	if(dataPermissionList != null && dataPermissionList.length > 0) {
		$(dataPermissionList).each(function(index, dataPermission) {
			if($("#menuId").val() == dataPermission.menuId) {
				flag = false;
				dataPermission.deptIds = deptIds;
				return ;
			}
		});
	} 
	
	if(flag) {
		var dataPermission = {
				"roleId": role.id,
				"menuId": $("#menuId").val(),
				"deptIds": deptIds
		};
		dataPermissionList.push(dataPermission);
	}
}

// 获取数据权限数据
function getDataPermission() {
	var result = [];
	var zTree = $.fn.zTree.getZTreeObj("deptTree");  
    var nodes = zTree.getChangeCheckedNodes(true); 
   
    $(nodes).each(function(index, node) {
    	result.push(node.id);
    });
    
    // 筛选父部门，如果选中父部门并且子部门也全部选中，则保留该父部门ID作为返回结果
    $(nodes).each(function(index, node) {
    	if(typeof node.children != "undefined" 
    		&& node.children != null
    		&& node.children.length > 0) {

    		// count记录该父部门下有多少子部门是选中状态
    		var count = 0;
    		$(node.children).each(function(index, nodeChild) {
    			if($.inArray(nodeChild.id, result) != -1) {
    				count++;
    			}
    		});
    		// 如果选中的子部门数量(index) 不等于 原来的子部门数量，则移除该父部门
    		if( count < (node.children.length) ) {
    			var offset = $.inArray(node.id, result);
    			if(offset != -1) {
    				result.splice(offset, 1);
    			}
    		}
    	}
    });
    
	return result;
}

function initTrEvent() {
	$("#treetable tbody tr").click(function() {
		$(this).css("background-color", "#b4b4b4");
		var obj = this;
		$("#treetable tbody tr").each(function(index, tr) {
			if( tr != obj ) {
				$(this).css("background-color", "inherit");
			}
		});
	});
}