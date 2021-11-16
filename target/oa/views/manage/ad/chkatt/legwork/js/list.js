var datatable = null;
$(function() {
	datatable =$("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/legwork/getLegworkList",
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
	    {"mData": 'deptName'},
	    {"mData": 'applyPeople'},  //申请人
	    {"mData": 'createDate'}  //登记时间
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
	if(aData.deptName == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.deptName);
	}
	$('td:eq(2)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));

	buildOperate(nRow, aData);
	
    return nRow;
}

function toAdd() {
	window.location.href = "toAddOrEdit";
}



function viewDetail(categorize) {
	$.ajax( {   
        "type": "GET",    
        "url": "viewList",    
        "dataType": "json",   
        "data": {"categorize":categorize},
        "success": function(data) {
        	$("#modal-body").html(buildDetail(data));
        	$("#legWorkModal").modal("show");
        	var userId = $("#userId").val();
        	if(data[0].userId == userId){
        	var button = [];
        	button.push('<button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>');
        	button.push('<button type="button" class="btn btn-default" id = "delete" onclick = "deleteAttach(&quot;'+categorize+'&quot;)">删除</button>');
        	$("#button").html(button);
        	}
        	else{
        		var button = [];
        		button.push('<button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>');
        		$("#button").html(button);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
	
}


function buildDetail(data){
	var html = [];
	var button = [];
	html.push(' <h4 class="modal-title" id="myModalLabel" style="text-align:center;">外勤详情</h4>')
	html.push('<table id="legWorksTable" class="table table-bordered" style="width:95%;">')
	html.push('<tr>');
	html.push('<td class="td_weight"><span>姓名</span></td>')
	html.push('<td class="td_weight"><span>开始时间</span></td>');
	html.push('<td class="td_weight"><span>结束时间</span></td>');
	html.push('<td class="td_weight"><span>事由</span></td>');
	html.push('<td class="td_weight"><span>地点</span></td>');
	html.push('</tr>');
	$(data).each(function(index, obj) {
		var startTime = "";
		var endTime = "";
		var name = obj.applyPeople;
		var place = obj.place;
		var reason = obj.reason;
		startTime = new Date(obj.startTime).pattern("yyyy-MM-dd HH:mm");
		endTime = new Date(obj.endTime).pattern("yyyy-MM-dd HH:mm");
		if(typeof reason == "undefined"){
			reason = "";
		}
		if(typeof place == "undefined"){
			place = "";
		}
		html.push('<tr>');
		html.push('<td style="width:4%;"><input type="text" name="name" value = "'+name+'"readonly></td>');
		html.push('<td style="width:8%;"><input type="text" name="startTime" id="startTime" value = "'+startTime+'"readonly></td>');
		html.push('<td style="width:8%;"><input type="text" name="endTime" id="endTime" class="endtime"  value = "'+endTime+'" readonly ></td>');
		html.push('<td style="width:30%;text-align:left;">'+reason+'</td>');
		html.push('<td style="width:8%;">'+place+'</td>');
		html.push('</tr>');
		
		
});
	return html.join('');
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "viewDetail(\""+aData.categorize+"\")");
	$(nRow).css("cursor", "pointer");
}


function deleteAttach(categorize){
	bootstrapConfirm("提示", "确定要删除吗？", 300, function() {
		$.ajax({
			"url": "delete",
			"dataType": "json",   
		    "data": {"categorize":categorize},
			"type": "post",
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

