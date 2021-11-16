var currTd = null;

$(function() {
	$("#userDialog").initUserDialog({
		"callBack": getUserData
	});
	
	initTable();
});

function openDialog(td) {
	currTd = td;
	$("#userDialog").openUserDialog($(td).attr("handlerId"));
}

function getUserData(user) {
	if( !isNull(currTd) ) {
		if( !isNull(user) && !$.isEmptyObject(user) ) {
			$(currTd).text(user.name);
			$(currTd).attr("handlerId", user.id);
		} else {
			$(currTd).text("");
			$(currTd).removeAttr("handlerId");
		}
	}
}

function initTable() {
	$.ajax({
		url: 'getAllData',
		type: 'GET',
		dataType: 'JSON',
		success: function(dataList) {
			var dataMap = convertToMap(dataList);
			initSubTable(dataMap);
		},
		error: function(e, errmsg) {
			bootstrapAlert("提示", "获取数据出错，请稍后重试！", 400, null);
		}
	});
}

// convert list to map format.
// map format key(process) value(data)
function convertToMap(dataList) {
	var result = {};
	$(dataList).each(function(index, data) {
		var nodeMap = {};
		$(data.nodeList).each(function(index, node) {
			nodeMap[node.node] = node;
		});
		data["nodeMap"] = nodeMap;
		result[data.process+data.companyId] = data;
	});
	
	return result;
}

function initSubTable(dataMap) {
	if( !isNull(dataMap) && !$.isEmptyObject(dataMap) ) {
		$("table.tab_table tbody td[name='firstTd']").each(function(index, td) {
			var process = $(td).attr("process");
			var companyId = $(td).attr("companyId");
			
			var data = dataMap[process+companyId];
			if( !isNull(data) && !$.isEmptyObject(data) ) {
				$(td).attr("id", data.id);
				var nodeMap = data["nodeMap"];
				$(td).siblings("td").each(function(index, sibling) {
					var node = nodeMap[$(sibling).attr("node")];
					if( !isNull(data) && !$.isEmptyObject(data) ) {
						if( !isNull(node.handler) ) {
							$(sibling).text(node.handler.name);
						}
						$(sibling).attr("nodeId", node.id);
						$(sibling).attr("handlerId", node.handlerId);
						$(sibling).attr("processTodId", data.id);
					}
				});
			}
		});
	}
}

function save(id) {
	var processTodoList = getProcessTodoData(id);
	
	$.ajax({
		url: 'save',
		type: 'POST',
		contentType: 'application/json;charset=UTF-8;',
		dataType: 'JSON',
		data: JSON.stringify(processTodoList),
		success: function(data) {
			bootstrapAlert("提示", data.result, 400, function() {
				if(data.code == 1) {
					refreshPage();
				}
			});
		},
		error: function(e, errmsg) {
			bootstrapAlert("提示", "保存数据错误，请稍后重试！", 400, null);
		}
	});
}

function getProcessTodoData(id) {
	var table = $("#"+id).find("table.tab_table");

	var processTodoList = [];
	$(table).find("tbody.tab_tbody tr").each(function(index, tr) {
		var processTodo = {};
		$(tr).find("td").each(function(index, td) {
			if(index == 0) { // 第一个TD保存流程待办的数据
				processTodo["id"] = $(td).attr("id");
				processTodo["companyId"] = $(td).attr("companyId");
				processTodo["process"] = $(td).attr("process");
			} else { // 其他TD保存流程待办节点的数据
				var node = {};
				node["id"] = $(td).attr("nodeId");
				node["processTodoId"] = processTodo["id"];
				node["node"] = $(td).attr("node");
				node["handlerId"] = $(td).attr("handlerId");
				
				var nodeList = processTodo["nodeList"];
				if( isNull(nodeList) ) {
					nodeList = [];
				}
				nodeList.push(node);
				processTodo["nodeList"] = nodeList;
			}
		});
		processTodoList.push(processTodo);
	});
	
	return processTodoList;
}