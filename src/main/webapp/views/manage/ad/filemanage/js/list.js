var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/filemanage/getFileList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'originName'},
	   /* {"mData": 'directoryId'},*/
	    {"mData": 'updateDate'},
	    {"mData": null}
    ]
	
	return columns;
}

function getSearchData() {
	return null;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var htmlText = buildOperate(aData);
	if(aData.updateDate!=null && aData.updateDate!=""){
		$('td:eq(1)', nRow).html(new Date(aData.updateDate).pattern("yyyy-MM-dd HH:mm"));
	}else{
		$('td:eq(1)', nRow).html("");
	}
	
	$('td:eq(2)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	
	var filePath = aData.filePath;
	filePath = filePath.substring(0, filePath.lastIndexOf("/") + 1);
	html.push('<a href="javascript:void(0);" onclick="downloadFile(\''+aData.filePath+'\',\''+aData.originName+'\')">');
	html.push($("#hiddenDownLoad").html());
	html.push('</a>');
	html.push('<input type="hidden" id="id" value="'+aData.id+'">')
	/*html.push('<a href="javascript:void(0);" onclick="deleteFile(\''+aData.filePath+'\',\''+aData.originName+'\')">');
	html.push($("#hiddenDelete").html());
	html.push('</a>');*/
	return html.join("");
}

function toAddOrEdit(id) {
	window.location.href = web_ctx + "/manage/ad/filemanage/toAddOrEdit?id=" + $("#id").val();
}

function drawTable() {
	
	if(dataTable != null) {
		dataTable.draw();
	}
}

function downloadFile(filePath, fileName) {
	var params = {"filePath": filePath, "fileName": fileName};
	var url = web_ctx + "/fileUpload/download?";
	params = urlEncode(params);
	url += params;

	window.open(url, "_blank");
}

function deleteFile(filePath, fileName) {

		bootstrapConfirm("提示", "是否确定删除文件？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/ad/filemanage/deleteFile",
				data: {"filePath": filePath, "fileName": fileName},
				type: "post",
				dataType: "json",
				success: function(data) {
					if(data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
	        			});
					}
					else{
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
			    error: function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			       }
				
			});
		}, null);
	
}


function clearForm() {
	$("#searchForm").clear();
}

var idForDel = null;
var filePathForDel = null;
var sourceForDel = null;
function del(id, filePath, source) {
	idForDel = id;
	filePathForDel = filePath;
	sourceForDel = source;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id":idForDel, "filePath":filePathForDel},
	        "success": function(data) {
	        	if(data != null) {
	        		if(data.code == 1) {
	        			var tr = $(sourceForDel).parents("tr");
	        			dataTable.row(tr).remove().draw(false);
	        		} else {
	        			bootstrapAlert("提示", data.result, 400, null);
	        		}
	        	}
	        },
	        
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}