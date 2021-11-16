
var dataTable = null;
var projectId = $("#projectId").val();
$(function() {
	initTable();
});


function initTable(){

	$.ajax( {   
        "type":"post",  
        "url": web_ctx + "/manage/finance/management/initTable", 
        "dataType": "json",   
        "data": {"id":projectId},
        "success": function(data) {   
        	if(data.code == 1) {
        		dataTable = $("#dataTable").datatable({
        			"id": "dataTable",
        			"url": web_ctx + "/manage/finance/management/findAllByProjectId",
        			"columns": initColumn(),
        			"search": getSearchData,
        			"rowCallBack": rowCallBack,
        		});
        	} else {    		
        		setStatus();
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
}


function setStatus(){

		$.ajax( {   
	        "type": "POST",    
	        "url": web_ctx + "/manage/sale/projectManage/setStatus",    
	        "dataType": "json",   
	        "data": {"id":projectId,"status":"-1"},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		
	        		if((typeof data.result)=="string"){
	        			bootstrapAlert("提示", data.result, 400, null);
	        			window.location.href=web_ctx+"/manage/sale/projectManage/toListNew";
	        		}
	        		
	        	} else {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
}



function getSearchData() {
	var params = {};
	params.projectId = projectId;
	return params;
}

function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
	    {"mData": 'kind'},  
        {"mData": 'name'},  //报销人
        {"mData": 'createDate'}, 
        {"mData": 'orderNo'},  //报销单号
        {"mData": 'status'},  //申请状态
        {"mData": 'project.name'},
    ]
	return columns;
}



function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}


/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 1;
	if(aData.kind == 1){
		$('td:eq(0)', nRow).html("差旅报销");
	}
	else{
		$('td:eq(0)', nRow).html("通用报销");
	}
	$('td:eq(1)', nRow).html(aData.name);
	
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	$('td:eq('+(eq+2)+')', nRow).html(aData.orderNo);
	
	//审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理驳回 9：经办驳回 10：复核驳回 11：总经理驳回 12：出纳驳回
	if(aData.status == 0) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+3)+')', nRow).html('经办审批');
	} else if(aData.status == 3 || aData.status == 11) {
		$('td:eq('+(eq+3)+')', nRow).html('复核审批');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+3)+')', nRow).html('总经理审批');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+3)+')', nRow).html('出纳审批');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+3)+')', nRow).html('审批完结');
	} else if(aData.status == 7) {
		$('td:eq('+(eq+3)+')', nRow).html('取消申请');
	} else if(aData.status == 8 || aData.status == 9
			|| aData.status == 10 || aData.status == 12) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	}
	else{
		$('td:eq('+(eq+3)+')', nRow).html('申请待提交');
	}
	buildOperate(aData, nRow);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData,nRow) {
	var ids = aData.id;
	if(aData.kind == 2){
		$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/reimburs/toEdit?id="+aData.id+"&unbound=true'");
	}
	else if(aData.kind == 1){
		$(nRow).attr("onclick","location.href='"+web_ctx+"/manage/finance/travelReimburs/toEdit?id="+aData.id+"&unbound=true'");
	}
	$(nRow).css("cursor", "pointer");

}

function openProject(obj) {	
	
	$("#projectDialog").openProjectDialog();

}

function getProject(data) {
	if(!isNull(data)) {
		$("#newProjectId").val(data.id);
	}
}







