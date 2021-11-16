var dataTable = null;
var workReportTr = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/workReport/getWorkReportList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	$("#deptDialog").initDeptDialog({
		"callBack": getData
	});
	initAutocomplete();
});

function initAutocomplete() {
	var data = [];
	$(userList).each(function(index, user) {
		// label与value是必须要的，可以加入其他自定义属性，并在select等事件中通过ui.item.[key]获取值（比如ui.item.label获取label值）
		data[data.length] = { "label": user.name, "value": user.name }; 
	});
	$("#userName").autocomplete({
		minLength: 0,
		source: data,
		select: function(event, ui) {
			event.stopPropagation(); // 阻止事件冒泡，避免影响其他监听事件。比如document监听Enter键按下
		}
    });
	
	// 点击或聚焦输入框时，弹出下拉列表
	$("#userName").bind("click focus", function() {
		var value = $("#userName").val();
		$("#userName").autocomplete("search", value);
	});
}

//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'author'},
	    {"mData": 'month'},
        {"mData": 'number'},
        {"mData": 'status'},
        {"mData": 'createDate'},
        {"mData": 'updateDate'}
    ]
	
	// if(!canDoCheck && !havePermission) {
	// 	columns = columns.splice(1, columns.length-1,columns);
	// } else {
	// 	$("#dataTable").find("thead tr:eq(0)").prepend("<th>姓名</th>");
	// }
    $("#dataTable").find("thead tr:eq(0)").prepend("<th>姓名</th>");
	return columns;
}



function getSearchData() {
	var params = {};
	params.userName = $.trim($("#userName").val());
	params.month = $.trim($("#month").val());
	params.number = $.trim($("#number").val());
	params.status = $.trim($("#status").val());

	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 2;
	// if(canDoCheck || havePermission) {
	// 	eq = 3;
	// 	$('td:eq(0)', nRow).html(aData.author.name);
	// }
    eq = 3;
    $('td:eq(0)', nRow).html(aData.author.name);
	if(aData.status == 0) {
		$('td:eq('+eq+')', nRow).html("未审核");
	} else if(aData.status == 1) {
		$('td:eq('+eq+')', nRow).html("已审核");
	} else {
		$('td:eq('+eq+')', nRow).html("");
	}
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	$('td:eq('+(eq+2)+')', nRow).html(new Date(aData.updateDate).pattern("yyyy-MM-dd HH:mm"));
	
	buildOperate(aData, nRow);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData, tr) {
	$(tr).css("cursor", "pointer");
	$(tr).attr("value", aData.id);
	$(tr).attr("onclick", "viewDetail("+aData.id+", this)")

	if(canDoCheck && aData.status == 0) {
		/*html.push("<a href='javascript:;' onclick='check(\""+aData.id+"\", this)' class='ace_detail'>审核</a>");
		html.push("&nbsp;&nbsp;");*/
		$(tr).attr("canCheck", "y");
	}
	if(canDoCheck || (userId == aData.userId && aData.status == 0)) {
		$(tr).attr("canEdit", "y");
	}
	if(userId == aData.userId && aData.status == 0) {
		$(tr).attr("canDel", "y");
	}
	
}

function toAddOrEdit(id) {
	window.location.href = web_ctx + "/manage/ad/workReport/toAddOrEdit?id=" + id;
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

var idForDel = null;
function del(id) {
	idForDel = id;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id": idForDel},
	        "success": function(data) {   
	        	if(data.code == 1) {
	        		bootstrapAlert("提示", "删除成功！", 400, function() {
	        			dataTable.row(workReportTr).remove().draw(false);
	        			$("#workReportModal").modal("hide");
	        		});
	        	} else {
	        		bootstrapAlert("提示", "删除出错！", 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
	
}

var checkId = null;
function check(id) {
	checkId = id;

	bootstrapConfirm("提示", "是否审核通过？", 400, function() {
		$.ajax( {   
			"type": "POST",    
			"url": "checkStatus",    
			"dataType": "json",   
			"data": {"id": checkId},
			"success": function(data) {
				if(data.code == 1) {
					$(workReportTr).find("td:eq(3)").text("已审核");
					$(workReportTr).removeAttr("canCheck");
					drawTable();
					$("#workReportModal").modal("hide");
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			"error": function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	});
}

function viewDetail(id, tr) {
	$.ajax( {   
        "type": "GET",    
        "url": "getWorkReport",    
        "dataType": "json",   
        "data": {"id": id},
        "success": function(data) {
        	if(!isNull(data)) {
        		showDetail(data, tr);
        	}
        	else {
        		bootstrapAlert("提示", "获取详细信息失败！", 400, null);
        	}
        
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
}
	

function calcTextLineHeight(str) {
	if (str.length > 0) {
		var lines = 1;
		for (var i = 0; i < str.length; i++) {
			if (str[i] === '\n' || str[i] === '\t') {
				lines++;
			}
		}
		return (lines * 30) + 'px';
	} else {
		return 0;
	}
}

function showDetail(data, tr) {
	var html = [];
	workReportTr = tr;
	$(data["workReportAttachList"]).each(function(index, attach) {	
		var textHeight = calcTextLineHeight(attach.description);
		
		html.push('<tr>');
		
		html.push('<td><input type="text" value="');
		html.push(new Date(attach.workDate).pattern("yyyy-MM-dd"));
		html.push('" readonly></td>');
		html.push('<td><input type="text" value="');
		html.push(attach.project.name);
		html.push('" readonly></td>');
		html.push('<td><input type="text" value="');
		html.push(attach.workTime);
		html.push('" readonly></td>');
		html.push('<td style="height:auto;white-space:pre-line;width:auto;word-break:break-all;">');
		html.push(attach.description);
		html.push('</td>');
		html.push('" title="');
		html.push(attach.description);
		html.push('" readonly></td>');
		html.push('</tr>');
	});

	if(havePermission) {
		$("#author_modal").text("<" + data.author.name + ">");
	}
	$("#month_modal").text(data.month);
	$("#number_modal").text(data.number);
	$("#weekPlan").html(data.weekPlan);
	$("#monthSummary").html(data.monthSummary);
	$("#monthPlan").html(data.monthPlan);
	$("#workReportAttach").find();
	$("#workReportAttach").html(html.join(""));
	
	// 设置模态框高度
	var bodyHeight = $(window).height();
	var modalHeight = bodyHeight * 0.7;
	$("#workReportModal").find(".modal-body").css("max-height", modalHeight);
	
	// 设置模态框按钮组
	var button = [];
	if( !isNull($(tr).attr("canCheck")) ) {
		button.push('<button type="button" class="btn btn-primary" onclick="check('+$(tr).attr("value")+')">审核</button>');
	}
	if( !isNull($(tr).attr("canEdit")) ) {
		button.push('<button type="button" class="btn btn-primary" onclick="toAddOrEdit('+$(tr).attr("value")+')">编辑</button>');
	}
	if( !isNull($(tr).attr("canDel")) ) {
		button.push('<button type="button" class="btn btn-warning" onclick="del('+$(tr).attr("value")+')">删除</button>');
	}
	button.push('<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
	$("#workReportModal").find(".modal-footer").html(button.join(""));
	
	$("#workReportModal").modal("show");
}


/********* 导出 工时Excel 模块代码 **********/
function openDialog() {
	$("#deptDialog").openDeptDialog();
}

function getData(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#deptName").val(data.name);
		$("#deptId").val(data.id);
	}
}

function exportToExcel() {
	var params = {
		"deptId": $("#deptId").val(),
		"year": $("#year").val(),
		"month": $("#months").val()
	};
	
	params = urlEncode(params);
	params = params.substring(1);
	var url = "exportExcel?" + params;
	
	$("#excelDownload").attr("src", url);
}