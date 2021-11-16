$(function() {
	var menuJson = getMenu();
	var tableHtml = buildTable(menuJson);
	$("#treetable tbody").html(tableHtml);
	
	$("#treetable").treetable({ expandable: true });
	$("#treetable").treetable("expandAll");
	
	$("#treetable").on("mousedown", "tr", function() {
	    $(".selected").not(this).removeClass("selected");
	    $(this).toggleClass("selected");

	});
});

function getMenu() {
	var menuJson = [];
	$.ajax({
		url: "getMenuList",
		async: false,
		dataType: "json",
		success: function(data) {
			menuJson = data;
			sortMenu(menuJson.children);
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return menuJson;
}

function buildTable(menuList) {
	var html = [];
	
	$(menuList).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = buildTable(obj.children);
			html.push(buildTr(obj));
			html.push(childHtml);
		}
	});
	
	return html.join("");
}

function buildTr(menu) {
	var html = [];
	
	html.push('<tr data-tt-id="'+menu.id+'" data-tt-parent-id="'+menu.parentId+'">');
	html.push('<td nowrap>'+menu.name+'</td>');
	html.push('<td nowrap>'+menu.url+'</td>');
	html.push('<td>'+(typeof menu.sort=="undefined"?0:menu.sort)+'</td>');
	html.push('<td>'+(menu.enabled == 1?'启用':'禁用')+'</td>');
	html.push('<td>'+menu.permission+'</td>');
	html.push('<td>');
	if(menu.id != 1) {
		if(!isNull(canEdit)) {
			html.push('	<a href="toAddOrEdit?id='+menu.id+'&isEdit=true">编辑</a>');
		}
		if(!isNull(canDel)) {
			html.push('	<a href="javascript:;" onclick="del('+menu.id+')">删除</a>');
		}
		if(!isNull(canAdd)) {
			html.push('	<a href="toAddOrEdit?id='+menu.id+'">添加子菜单</a>');
		}
	} else {
		if(!isNull(canAdd)) {
			html.push('	<a href="toAddOrEdit?id='+menu.id+'">添加子菜单</a>');
		}
	}
	html.push('</td></tr>');
	
	return html.join('');
}

function sortMenu(menuList) {
	menuList.sort( compare("sort") );
	$(menuList).each(function(index, menu) {
		if(menu.children != null && menu.children.length > 0) {
			sortMenu(menu.children);
		}
	});
}

function compare(propertyName) {
	return function(object1, object2) {
		var value1 = object1[propertyName];
		var value2 = object2[propertyName];
		if (value2 < value1) {
			return -1;
		} else if (value2 > value1) {
			return 1;
		} else {
			return 0;
		}
	}
}

var idForDel = null;
function del(id) {
	idForDel = id;
	
	bootstrapConfirm("提示", "确定删除吗？", 300, function() {
		window.location.href = "delete?id=" + idForDel;
	}, null);
}