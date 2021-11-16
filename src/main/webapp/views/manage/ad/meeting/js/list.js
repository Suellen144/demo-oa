var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/meeting/getList",
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

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'applicant'},     
        {"mData": 'number'},    
//        {"mData": 'applicant'}, 
        {"mData": 'theme'}, 
        {"mData": 'status'}, 
        {"mData": 'applyTime'},
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());

	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	
	var eq = 1;
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	
	$('td:eq(2)', nRow).html(aData.theme);
	if (aData.status == "" || aData.status == null) {
		$('td:eq(3)', nRow).html("待提交");
	}
	else{
		$('td:eq(3)', nRow).html("已提交");
	}
	$('td:eq('+(eq+3)+')', nRow).html(new Date(aData.applyTime).pattern("yyyy-MM-dd"));
	buildOperate(nRow, aData);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	if (aData.status != "1") {
		$(nRow).attr("onclick", "toAddOrEdit(\""+aData.id+"\")");
	}
	else{
		$(nRow).attr("onclick", "showModal(\""+aData.id+"\")");
	}
	
	$(nRow).css("cursor", "pointer");
}


function toAddOrEdit(id){
	window.location.href = "toAddOrEdit?id="+id;
}

function toAdd() {
	window.location.href = "toAddOrEdit";
}


function initUsernames(userIds){
	if (userIds != null && userIds != "") {
		var deptJson = [];
		$.ajax({
			url: web_ctx+"/manage/sys/user/findByUserIds",
			type : 'POST',  
			data: { "userIdList": userIds },
			traditional: true,
			async: false,
			dataType: "json",
			success: function(data) {
				deptJson = data;
			},
			error: function() {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		$("#deptName").val(deptJson);
	}
}

function initDeptName(deptId){
	if (deptId != null && deptId != ""){
		$.ajax({
			url: web_ctx+"/manage/sys/dept/findByDeptId",
			type : 'POST',  
			data: { "deptId": deptId },
			traditional: true,
			async: false,
			dataType: "json",
			success: function(data) {
				$("#dept").val(data.name);
			},
			error: function() {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}

function showModal(id){
	$.ajax({
		url: "getMeeting?id="+id,
		type: "get",
		dataType: "json",
		success: function(data) {
			if(!isNull(data)) {
				// 设置模态框内容
				$("#title").html(data.theme);
				
				$("#type2").val(data.participant);
				$("#createBy").val(!isNull(data.applicant) ? data.applicant.name : "");
				$("#updateDate").val(new Date(!isNull(data.updateDate)?data.updateDate:data.createDate).pattern("yyyy-MM-dd") );
				$("#approver").val(data.presenters);
				$("#content").html(data.comment);
				var userIDs = [];
				userIDs.push(data.userids);
				initUsernames(userIDs);
				initDeptName(data.deptId);
				// 抄送
				if(!isNull(data.deptList)) {
					var deptName = sendScope(data.deptList);
					$("#deptName").text(deptName.join("\r\n"));
				}
				
				// 设置模态框高度
				var bodyHeight = $(window).height();
				var modalHeight = bodyHeight * 0.7;
				$("#noticeModal").find(".modal-body").css("max-height", modalHeight);
				// 显示模态框
				$("#meetingModal").modal("show");
			} else {
				bootstrapAlert("提示", "抱歉，没有此纪要数据！", 400, null);
			}
		},
		error: function(e) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

