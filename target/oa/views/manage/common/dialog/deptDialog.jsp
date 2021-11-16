<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
</head>
<body>
	
<ul id="deptTree" class="ztree"></ul>

<%@ include file="../footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.excheck.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/nicescroll/jquery.nicescroll.min.js"></script>
<script>
var deptNode = null;
var isCheck = '<%=request.getParameter("isCheck")%>';
var isGetChildren = '<%=request.getParameter("isGetChildren")%>';

$(function(){
	if("true" == isCheck) {
		isCheck = true;
	} else {
		isCheck = false;
	}
	if("true" == isGetChildren) {
		isGetChildren = true;
	} else {
		isGetChildren = false;
	}
	setting.check.enable = isCheck;
	$.fn.zTree.init($("#deptTree"), setting);
	
	$("html").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
});

var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: false
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
			url: "<%=base%>/manage/sys/dept/getDeptListOnJson"
		},
		callback: {
			onClick: processNodeData,
			onAsyncSuccess: expandAll
		}
};

function processNodeData(event, treeId, treeNode) {
	deptNode = treeNode;
}

function expandAll() {
	var treeObj = $.fn.zTree.getZTreeObj("deptTree"); 
	treeObj.expandAll(true);	
	initCheckedClick();
}

function getDeptNode() {
	var result = null;
	if(isCheck) {
		if(isGetChildren) {
			result = getChildrenNode();
		} else {
			result = getDeptList();
		}
	} else {
		if(deptNode != null) {
			result = $.extend(true, {}, deptNode);
		}
	}
	
	return result;
}

//设置点击节点名设置复选框的选中状态
function initCheckedClick() {
	$("a[treenode_a]").click(function() {
		$(this).prev("span[treenode_check]").trigger("click");
	});
}

// 获取多选时所有的选中部门
function getDeptList() {
	var result = [];
	var zTree = $.fn.zTree.getZTreeObj("deptTree");  
    var nodes = zTree.getChangeCheckedNodes(true); 
    
    $.extend(true, result, nodes);
    $(result).each(function(index, node) {
    	node.children = null;
    });
   
    return result;
}


//设置部门树选中状态
function setTreeChecked(deptIds) {
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	zTree.checkAllNodes(false);
	if(deptIds != null && deptIds.length > 0) {
		var ids = deptIds.split(",");
		$(ids).each(function(index, id) {
			var node = zTree.getNodeByParam("id", id, null);
			if( node != null ) {
				zTree.checkNode(node, true, true);
				zTree.updateNode(node);
			}
		});
	}
}

// 多选时只获取子部门
function getChildrenNode() {
	var result = [];
	var parentsId = {}; // 未选中节点的父部门ID集合（递归获取）
	var childrenId = {}; // 某部门下子部门全选中，则保存其子部门的ID集合
	var excluedId = {}; // 合并parentsId和childrenId，此ID集合内的节点不会被返回
	
	var zTree = $.fn.zTree.getZTreeObj("deptTree");  
    var nodes = zTree.getCheckedNodes(true);
    var uncheckNodes = zTree.getCheckedNodes(false);
   
	// 获取未选中节点的所有父部门包括递归向上父部门的ID
    $(uncheckNodes).each(function(index, node) {
    	if( isNull(parentsId[node.parentId]) ) {
    		var tempIdList = [];
    		getParentsId(node, tempIdList);
    		$(tempIdList).each(function(index, id) {
    			parentsId[id] = id;
    		});
    	}
    	
    	parentsId[node.id] = node.id;
    });
    
    // 获取全选中子部门的ID
    $(nodes).each(function(index, node) {
    	if( isNull(parentsId[node.id]) && node.isParent ) {
    		$(node.children).each(function(index, child) {
    			childrenId[child.id] = child.id;
    		});
    	}
    });
    
	// 筛选父部门，如果选中父部门并且子部门也全部选中，则保留该父部门作为返回结果
    excluedId = $.extend(true, parentsId, childrenId);
    $(nodes).each(function(index, node) {
    	if( isNull(excluedId[node.id]) ) {
    		result.push(node);
    	}
    });
    if( result.length == 1 && result[0].parentId == -1 ) {
    	var temp = [];
    	$(result[0].children).each(function(index, child) {
    		temp.push(child);
    	});
    	result = temp;
    }
	
    return result;
}

function getParentsId(node, idList) {
	if( !isNull(node.getParentNode()) && !$.isEmptyObject(node.getParentNode()) ) {
		idList.push( getParentsId(node.getParentNode(), idList) );	
	}
	return node.id;
	
}
</script>
</body>
</html>