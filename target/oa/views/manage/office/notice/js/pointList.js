var dataTable = null;
var hasProcessIds = []; // 有需要流程处理的ID集合
var typeMap = {};
var noticeId = null;
var noticeObj = null;

$(function() {
	var isRead = $("#isRead").attr("value");
	$("#isRead").val(isRead);
	initDatetimepicker();
	initNoticeType();
	
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/office/noitce/getPointList",
		"columns": initColumn(),
		"rowCallBack": rowCallBack,
		"search": getSearchData
	});
});

function initDatetimepicker() {
	$("#beginDate, #endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function initColumn() {
	/*var columns =  [ //这个属性下的设置会应用到所有列
	                 {"mData": 'title'},
	                 {"mData": 'user.dept'}, 
	                 {"mData": 'createDate'},

	             ]*/
	if(flag == "true" && userId != '2'){
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'title'},
        {"mData": 'user.dept'}, 
        {"mData": 'createDate'},
        {"mData": 'approveStatus'}
        ]
	}
	else{
		var columns =  [ //这个属性下的设置会应用到所有列
         {"mData": 'title'},
         {"mData": 'user.dept'}, 
         {"mData": 'createDate'},
         ]
	}
	
	return columns;
}

$(document).keydown(function(event){
	if(event.which == 13){
		drawTable();
		return false;
	}
});

function getSearchData() {
	var params = {};
	params.userName = $.trim($("#userName").val());
	params.beginDate = $.trim($("#beginDate").val());
	params.endDate = $.trim($("#endDate").val());
	params.isRead = $.trim($("#isRead").val());
	params.type = $.trim('2');
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	
	if(!isNull(params.beginDate)) {
		params.beginDate += " 0:0:0";
	}
	if(!isNull(params.endDate)) {
		params.endDate += " 23:59:59";
	}

	return params;
}


/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if( !isNull(aData.isRead) ) {
		nRow.bgColor = '#e8e8e8';
		$('td:eq(0)', nRow).attr("value", "1");
	} else {
		nRow.bgColor = 'white';
		$('td:eq(0)', nRow).attr("value", "0");
	}

	buildOperate(aData, $('td:eq(0)', nRow));
	$('td:eq(0)', nRow).html('<span class="auto_truncate col-md-8">' + aData.title + '</span>');
	$('td:eq(0)', nRow).css({"width":"100%", "float":"left", "position":"absolute"});
//	$('td:eq(0)', nRow).addClass("auto_truncate");
	
	
	var deptId = !isNull(aData.publisherId) ? aData.publisherId : aData.user.deptId;
	$('td:eq(1)', nRow).html(getDeptNameByDeptId(deptId));
	
	$('td:eq(2)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
	if(flag = "true" && userId != '2'){
		if(aData.approveStatus == 0){
			$('td:eq(3)', nRow).html('未审批');
		}
		if(aData.approveStatus == 1){
			$('td:eq(3)', nRow).html('已发布');
		}
		if(aData.approveStatus == 2){
			$('td:eq(3)', nRow).html('审批未通过');
		}
	}
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData, td) {

	$(td).css("cursor", "pointer");
	$(td).attr("onclick", "viewNotice("+aData.id+", this)");
	
	if(userId == aData.userId) {
		if(aData.approveStatus == "0") {
			$(td).attr("canEdit", "y");
		}
		if(aData.approveStatus == "2") {
			$(td).attr("canRepublic", "y");
			$(td).attr("canDel", "y");
		}
	}
	
	if( (canDel == "true" && aData.approveStatus == "1") || userId == aData.approver ) {
		$(td).attr("canDel", "y");
	}
}

function viewNotice(id, td) {
	$.ajax({
		url: "getNotice?id="+id,
		type: "get",
		dataType: "json",
		success: function(data) {
			$("#form1")[0].reset();
			$("#attachName").parent("a").attr("href", "javascript:void(0);");
			$("#attachName").parent("a").removeAttr("target");
			noticeObj = td;
			
			if( !$("#details_div").hasClass("collapsed-box") ) {
				$("#details_div").find("button").trigger("click");
			}
			
			if(!isNull(data)) {
				// 设置模态框内容
				$("#title").html(data.title);
				
				$("#type2").val(typeMap[data.type]);
				$("#createBy").val(!isNull(data.user) ? data.user.name : "");
				$("#updateDate").val( new Date(!isNull(data.actualPublishTime)?data.actualPublishTime:data.createDate).pattern("yyyy-MM-dd") );
				$("#content").html(data.content);
				
				if( data.type == 1 ) {
					$("#approver").val(!isNull(data.approver) ? data.approver.name : "");
					$("#approver").parent("td").show();
					$("#approver").parent("td").prev().show();
				} else {
					$("#approver").parent("td").hide();
					$("#approver").parent("td").prev().hide();
				}
				
				// 发布部门
				$("#dept").val(getDeptNameByDeptId(data.publisherId));
				
				// 附件
				if(!isNull(data.attachName)) {
					$("#attachName").parents("tr").show();
					$("#attachName").val(data.attachName);
					$("#attachName").parent("a").attr("href", web_ctx + data.attachments);
					$("#attachName").parent("a").attr("target", "_blank");
				} else {
					$("#attachName").parents("tr").hide();
				}
				
				// 抄送
				if(!isNull(data.deptList)) {
					var deptName = sendScope(data.deptList);
					$("#deptName").text(deptName.join("\r\n"));
				}
				
				// 设置模态框高度
				var bodyHeight = $(window).height();
				var modalHeight = bodyHeight * 0.7;
				$("#noticeModal").find(".modal-body").css("max-height", modalHeight);
				
				// 设置模态框操作按钮
				var button = [];
				if( $(td).parents("tr").find("td:first").attr("value") == "0" && data.approveStatus == "1" ) {
					button.push('<button type="button" class="btn btn-primary" onclick="setReadStatus('+id+')">已阅</button>');
				}
				if( !isNull($(td).attr("canEdit")) ) {
					button.push('<button type="button" class="btn btn-primary" onclick="editNotice('+id+')">编辑</button>');
				}
				if( !isNull($(td).attr("canRepublic")) ) {
					button.push('<button type="button" class="btn btn-primary" onclick="editNotice('+id+')">重新发布</button>');
				}
				if( !isNull($(td).attr("canDel")) ) {
					button.push('<button type="button" class="btn btn-warning" onclick="delNotice('+id+')">删除</button>');
				}
				button.push('<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
				$("#noticeModal").find(".modal-footer").html("");
				$("#noticeModal").find(".modal-footer").append(button.join(" "));
				
				// 显示模态框
				$("#noticeModal").modal("show");
			} else {
				bootstrapAlert("提示", "抱歉，没有此公告数据！", 400, null);
			}
		},
		error: function(e) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function editNotice(id) {
	window.location.href = "toAddOrEdit?id="+id;
}

function delNotice(id) {
	noticeId = id;
	bootstrapConfirm("提示", "确定要删除吗？", 300, function() {
		$.ajax({
			url: "delete?id="+noticeId,
			type: "get",
			dataType: "json",
			success: function(data) {
				if(!isNull(data) && data.code == 1) {
					bootstrapAlert("提示", "删除成功！", 400, function() {
						window.parent.initNotice();
						var tr = $(noticeObj).parents("tr");
						dataTable.row(tr).remove().draw(false);
						$("#noticeModal").modal("hide");
					});
	        	} else {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
			},
			error: function(e) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}

function sendScope(deptList) {
	var deptName = [];
	var deptNameTree = {};
	
	$(deptList).each(function(index, dept) {
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
	
	return deptName;
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

function getDeptNameByDeptId(deptId) {
	var companyName = "";
	var deptName = "";
	var dept = deptMap[deptId];
	if( !isNull(dept) ) {
		var nodeLinks = dept.nodeLinks.split(",");
		if( nodeLinks.length > 3 ) {
			companyName = deptMap[nodeLinks[2]].name; // 数组的第3位是公司
		}
		deptName = dept.name;
		if( dept.name.indexOf("总经理") > -1
				|| dept.name.indexOf("副总经理") > -1 ) {
			deptName = "";
		}
	}
	
	return companyName + " " + deptName;
}

function toAdd() {
	window.location.href = "toAddOrEdit";
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
	$("#beginDate").prop("readonly", true);
	$("#endDate").prop("readonly", true);
}

function setReadStatus(id) {
	$.ajax({
		url: "setReadStatus?id="+id,
		type: "post",
		data: {"noticeId": id},
		dataType: "json",
		success: function(data) {
			if(!isNull(data) && data.code == 1) {
				var td = $(noticeObj).parents("tr").find("td:first");
        		$(td).attr("value", "1");
        		$(td).parent().css("background-color", "#e8e8e8");
        		$("#noticeModal").modal("hide");
        		window.parent.initNotice();
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
		},
		error: function(e) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function initNoticeType() {
	$("#noticeType").find("option").each(function(index, option) {
		typeMap[$(option).attr("value")+""] = $(option).text()+"";
	});
}