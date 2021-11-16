var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/clientmanage/getClientsList",
		"pageSize": 10000,
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


$(document).keydown(function(event){
    if(event.which == 13){
        drawTable();
        return false; // 防止刷新整个页面
    }
});

function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'clientName'},  //客户姓名
	    {"mData": 'company'},  //所在单位
	    {"mData": 'clientPosition'},  //客户职位
	    {"mData": 'clientPhone'},  //联系方式
	    {"mData": 'email'},  //邮箱
	    {"mData": 'address'},  //地址
	    {"mData": 'projectManage.name'}  //相关项目
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
	

	$('td:eq(0)', nRow).html(aData.clientName);
	$('td:eq(1)', nRow).html(aData.company);
	if(aData.clientPosition == null){
		$('td:eq(3)', nRow).html("");
	}
	else{
		$('td:eq(3)', nRow).html(aData.clientPosition);
	}
	if(aData.clientPhone == null){
		$('td:eq(3)', nRow).html("");
	}
	else{
		$('td:eq(3)', nRow).html(aData.clientPhone);
	}
	if(aData.email == null){
		$('td:eq(4)', nRow).html("");
	}
	else{
		$('td:eq(4)', nRow).html(aData.email);
	}
	if(aData.address == null){
		$('td:eq(5)', nRow).html("");
	}
	else{
		$('td:eq(5)', nRow).html(aData.address);
	}
	buildOperate(aData, nRow);
    return nRow;
}

function buildOperate(aData,tr) {
	$(tr).css("cursor", "pointer");
	$(tr).attr("onclick","parent.location.href='"+web_ctx+"/manage/ad/clientmanage/toAddOrEdit?id="+aData.id+"'");
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function toAddOrEdit(id) {
	parent.location.href = web_ctx + "/manage/ad/clientmanage/toAddOrEdit?id=" + id;

}

function tooAdd(){
	parent.location.href = web_ctx + "/manage/ad/clientmanage/toAddOrEdit";
}