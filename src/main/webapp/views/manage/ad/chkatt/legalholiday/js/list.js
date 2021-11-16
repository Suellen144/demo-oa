var datatable = null;
$(function() {
	datatable =$("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/legalHoliday/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
});


$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});


function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
}

function drawTable() {
	if(datatable != null) {
		datatable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
	    {"mData": 'dateBelongs'},  
	    {"mData": 'startDate'},  
	    {"mData": 'endDate'},
	    {"mData": 'legal'},
	    {"mData": 'numberDays'}  
	    
    ]
	return columns;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	$('td:eq(2)', nRow).html(new Date(aData.startDate).pattern("yyyy-MM-dd"));
	$('td:eq(3)', nRow).html(new Date(aData.endDate).pattern("yyyy-MM-dd"));
	$('td:eq(4)', nRow).html(new Date(aData.legal).pattern("yyyy-MM-dd"));
	buildOperate(nRow, aData);
	
    return nRow;
}

function toAdd() {
	window.location.href = "toAdd";
}



function viewDetail(id) {
	$.ajax( {   
        "type": "GET",    
        "url": "view",    
        "dataType": "json", 
        "data": {"id":id},
        "success": function(data) {
        	$("#modal-body").html(buildDetail(data));
        	$("#legWorkModal").modal("show");
        	var button = [];
        	button.push('<button type="button" class="btn btn-primary" onclick="toAddOrEdit('+id+')">编辑</button>');
        	button.push('<button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>');
        	button.push('<button type="button" class="btn btn-default" id = "delete" onclick = "deleteAttach(&quot;'+id+'&quot;)">删除</button>');
        	$("#button").html(button);
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
	
}


function buildDetail(data){
	var html = [];
	var button = [];
	html.push(' <h4 class="modal-title" id="myModalLabel" style="text-align:center;">放假详情</h4>')
	html.push('<table id="legWorksTable" class="table table-bordered" style="width:95%;">')
	html.push('<tr>');
	html.push('<td class="td_weight"><span>名称</span></td>')
	html.push('<td class="td_weight"><span>所属日期</span></td>');
	html.push('<td class="td_weight"><span>开始时间</span></td>');
	html.push('<td class="td_weight"><span>结束时间</span></td>');
	html.push('<td class="td_weight"><span>法定</span></td>');
	html.push('<td class="td_weight"><span>放假天数</span></td>');
	html.push('<td class="td_weight"><span>假前调班</span></td>');
	html.push('<td class="td_weight"><span>假后调班</span></td>');
	html.push('</tr>');
	$(data).each(function(index, obj) {
		var startTime = "";
		var endTime = "";
		var beforTime = "";
		var afterTime = "";
		var legal="";
		var name = obj.name;
		var number = obj.numberDays;
		var dateBelongs = "";
		dateBelongs = new Date(obj.dateBelongs).pattern("yyyy-MM");
		startTime = new Date(obj.startDate).pattern("yyyy-MM-dd");
		endTime = new Date(obj.endDate).pattern("yyyy-MM-dd");
		legal = new Date(obj.legal).pattern("yyyy-MM-dd");
		if(obj.beforeLeave!=null){
			beforTime = new Date(obj.beforeLeave).pattern("yyyy-MM-dd");
		}
		if(obj.afterLeave!=null){
			afterTime = new Date(obj.afterLeave).pattern("yyyy-MM-dd");
		}
		html.push('<tr>');
		html.push('<td colspan="1"><input type="text" name="name" size="18"  value="'+name+'" ></td>');
		html.push('<td colspan="1"><input type="text" name="dateBelongs"  class="dateBelongs" value="'+dateBelongs+'"  size="18" readonly ></td>');
		html.push('<td colspan="1"><input type="text" name="startDate" class="startDate" size="18" value="'+startTime+'" readonly></td>');
		html.push('<td colspan="1"><input type="text" name="endDate"  class="endDate"  size="18" value="'+endTime+'" readonly ></td>');
		html.push('<td colspan="1"><input type="text" name="legal"  class="legal"  size="18" value="'+legal+'" readonly ></td>');
		html.push('<td colspan="1"><input type="text" name="numberDays" class="input"  value="'+number+'"></td>');
		html.push('<td colspan="1"><input type="text" name="beforeLeave"  class="beforeLeave" value="'+beforTime+'"  size="18" readonly ></td>');
		html.push('<td colspan="1"><input type="text" name="afterLeave"  class="afterLeave" value="'+afterTime+'" size="18" readonly></td>');
		html.push('</tr>');
});
	return html.join('');
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "viewDetail(\""+aData.id+"\")");
	$(nRow).css("cursor", "pointer");
}


function deleteAttach(id){
	var temp  = id;
	bootstrapConfirm("提示", "确定要删除吗？", 300, function() {
		$.ajax({
			"url": "delete?id="+temp,
			"dataType": "json",   
			"type": "post",
			"cache":false,
			success: function(data) {
				if(!isNull(data) && data.code == 1) {
					$("#legWorkModal").modal("hide");
					datatable.draw();
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

function toAddOrEdit(id){
	window.location.href = web_ctx + "/manage/ad/legalHoliday/toAddOrEdit?id="+id;
}

