var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/record/getRecordList",
		"pageSize": 10000,
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
		"drawCallBack":initTableDate,
	});
	
	$(document).keydown(function(event){
		if(event.which == 13){
			drawTable();
			return false; // 防止刷新整个页面
		}
	});
	
});

function initColumn() {
	var columns =  [
	    {"mData": null},
	    {"mData": 'dept'},
        {"mData": 'name'},
        {"mData": 'position',},
        {"mData": 'entryTime'},
        {"mData": 'education'},
        {"mData": 'school'},
        {"mData": 'major'},
        {"mData": 'phone'},
        {"mData": 'email'},
        {"mData": 'idcard'},
        {"mData": 'leaveTime'},
        {"mData": 'entrystatus'},
    ]
	return columns;
}
var company="";
function initTableDate(){
	var result=$("select[name='dept'] option:selected").text();
	if(result=="全部"||result=="注销公司"){
		$("#spCompany").text("");
		$("#dataTable").find("tbody tr").each(function(index,tr){
			if(index==0){
				company=$(tr).find("input[name='company']").val();
				$(tr).before('<tr bgcolor="#EDEDED"><td  colspan="12" style="text-align: left;">'+company+'</td></tr>');
			}else{
				var str=$(tr).find("input[name='company']").val();
				$.trim(str);
				if(str!=company){
					$(tr).before('<tr bgcolor="#EDEDED"><td  colspan="12" style="text-align: left;">'+str+'</td></tr>');
					company=str;
				}
			}
		})
	}else{
		$("#spCompany").text($("select[name='dept'] option:selected").text())
	}
}


function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.entryStatus = $.trim($("#entryStatus").val());
	params.dept = $.trim($("#dept").val());
	return params;
}

/* 服务端返回数据后开始渲染表格时调用*/

function rowCallBack(nRow, aData, iDisplayIndex) {
	var result=$("select[name='dept'] option:selected").val();
	if(result!=""){
		if(iDisplayIndex % 2 == 0) {
			nRow.bgColor = "#EDEDED";
		}
	}
	$('td:eq(0)', nRow).text(iDisplayIndex+1);
	if(aData.deptName.indexOf("总经理") > -1) {
		$('td:eq(1)', nRow).text("");
	} else {
		$('td:eq(1)', nRow).text(aData.dapt);
	}
	$('td:eq(3)', nRow).html( !isNull(aData.position) ? aData.position.split(",").length > 1 ?  aData.position.split(",")[0] : aData.position : "" );
	if( !isNull(aData.entryTime) ) {
		$('td:eq(4)', nRow).html(new Date(aData.entryTime).pattern("yyyy-MM-dd"));
	}
	if(buildEntryStatus(aData.entrystatus)=="离职"){
		$('td:eq(9)', nRow).html(aData.qq);
	}
	if( !isNull(aData.leaveTime))
	$('td:eq(11)', nRow).html(new Date(aData.leaveTime).pattern("yyyy-MM-dd"));
	
	$('td:eq(12)', nRow).html(buildEntryStatus(aData.entrystatus));
	var tdResult=$('td:eq(12)', nRow).html()
	$('td:eq(12)', nRow).html(tdResult+"<input type='hidden' name='company' value='"+aData.company+"' name='company'>");
	buildOperate(aData, nRow);
    return nRow;
}


/* 构造操作详情HTML */
function buildOperate(aData,tr) {
	
	$(tr).css("cursor", "pointer");
	$(tr).attr("onclick","location.href='"+web_ctx+"/manage/ad/record/edit?userId="+aData.userId+"'");
}

function buildEntryStatus(entryStatus) {
	var entryStatusText = "";
	if( !isNull(entryStatus) ) {
		switch(entryStatus+"") {
		case '1': entryStatusText = "实习"; break ;
		case '2': entryStatusText = "试用"; break ;
		case '3': entryStatusText = "正式员工"; break ;
		case '4': entryStatusText = "辞职"; break ;
		case '5': entryStatusText = "辞退"; break ;
		case '6': entryStatusText = "协议离职"; break ;
		}
	}
	return entryStatusText;
}


function exportExcel(){
	var params = getSearchData();
		params = urlEncode(params);
		params = params.substring(1);
	var url = web_ctx +  "/manage/ad/record/exportExcel?" + params;
		
		$("#excelDownload").attr("src", url);
	
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function toAdd(){
	window.location.href = "toAdd";
}