var zTree, rMenu, currNode,typeid;
var dictList = []; 

/********* 字典树相关操作 ***************/
//获取字典树
var setting = {
		view: {
			selectedMulti: false
		},
		data: {
            simpleData: {
	            enable: true,
	            idKey: "id",
	            pIdKey: "parentId",
	            rootPId: -1
            }
    	},
		async: {
			type: "get",
            enable: true,
			url: web_ctx+"/manage/sys/dict/getTypeWithDataList"
		},
		callback: {
			onAsyncSuccess: expandAll,
			/*onRightClick: rightClick,*/
			onClick: processNodeData
		}
};

/*初始化字典树*/
$(document).ready(function(){
	$.fn.zTree.init($("#dictTree"), setting);
});

/*展开树*/
function expandAll() {
	zTree = $.fn.zTree.getZTreeObj("dictTree");
	rMenu = $("#rMenu");
	zTree.expandAll(true);	
	
	rightClick();
}



/*树单击事件*/
function processNodeData(event, treeId, treeNode) {
	$("#dataTable").clear();
	if(!isNull(treeNode.id)&&treeNode.id!=1){
		typeid=treeNode.id;
		showdata(typeid);
	}
}


/*树节点右键事件*/
function rightClick() {
		$.contextMenu({
	    	selector: 'a.level0',
	           callback: function(key, options) {
	        	   currNode = zTree.getNodeByTId($(this).attr("id").replace("_a", ""));
		           	zTree.selectNode(currNode);
		            switch(key) {
		                case 'addTreeNode': addTreeNode(); break ;
		            }
	        },
	        items: {
	        	"addTreeNode":{ name: "新增类型", icon: "add" },
	        }
	    });
		
		$.contextMenu({
	    	selector: 'a.level1',
	           callback: function(key, options) {
		        	currNode = zTree.getNodeByTId($(this).attr("id").replace("_a", ""));
		           	zTree.selectNode(currNode);
		            switch(key) {
		                case 'adddata': adddata(); break ;
		                case 'editTreeNode': editTreeNode(); break ;
		                case 'delTreeNode': delTreeNode(); break ;
		            }
	        },
	        items: {
	        	"adddata":{ name: "新增数据", icon: "add" },
	        	"editTreeNode":{ name: "编辑类型", icon: "edit" },
	        	"delTreeNode":{ name: "删除类型", icon: "delete" },
	        }
	    });
		/*if(treeNode.parentId==-1) {
			showRMenu("type", event.clientX, event.clientY-50);
		} else {
			showRMenu("data", event.clientX, event.clientY-50);
		}*/
	
}

/*展开右键菜单
function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if (type == "type") {
		$("#m_add").show();
		$("#m_edit").hide();
		$("#m_del").hide();
		$("#d_add").hide();
	} else {
		$("#m_add").hide();
		$("#d_add").show();
		$("#m_edit").show();
		$("#m_del").show();
	}
	rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", onBodyMouseDown);
}*/

/*隐藏右键菜单*/
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}


function onBodyMouseDown(event) {
	if ( !(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0) ) {
		rMenu.css({"visibility" : "hidden"});
	}
}

/*增加树节点（新增类型）*/
function addTreeNode() {
	hideRMenu();
	$("#typeName").text("新增类型");
	$("#form1").find("input").val("");
	$("#parentId").val(currNode.id);
	$("#saveBtn").attr("onclick", "save()");
	$("#typeModal").modal("show");
	
}

/*增加类型数据*/
function adddata() {
	hideRMenu();
	$("#dataName").text("新增数据");
	$("#form2").find("input").val("");
	$("#typeid").val(currNode.id);
	$("#saveBtn").attr("onclick", "savedata()");
	$("#dataModal").modal("show");
	
}

/*编辑类型*/
function editTreeNode() {
	hideRMenu();
	$("#typeName").text("编辑类型");
	$("#id").val(currNode.id);
	$("#name").val(currNode.name);
	$("#remark").val(currNode.remark);
	$("#saveBtn").attr("onclick", "update()");
	$("#typeModal").modal("show");
}

/*删除类型*/
function delTreeNode() {
	hideRMenu();
	bootstrapConfirm("提示", "将删除本类型和类型下所有数据，确定删除？", 300, function() {
		$.ajax({
			url: web_ctx+"/manage/sys/dict/delete",
			dataType: "json",
			data: {"id":currNode.id},
			success: function(data) {
				if(data.code == 1) {
					bootstrapAlert("提示", data.result, 400, function() {
						zTree.removeNode(currNode);
						datatable.draw();
					});
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}



//字典类型save事件
function save() {
	if(!$("#name").val()) {
		bootstrapAlert("提示", "名称不能为空！", 400, null);
	} else {
		$.ajax({
			url:web_ctx+"/manage/sys/dict/save",
			type: "POST",
			dataType: "json",
			data:$("#form1").serializeJson(),
			success:function(data){
				if(data.code==1){
						var newNode = data.result;
						newNode["parentId"] =  newNode.id;
						newNode["name"] =  newNode.name;
						newNode["remark"] = newNode.remark;
						zTree.addNodes(currNode, newNode);
						$("#typeModal").modal("hide");
						location.replace(location.href);
				} else {
					bootstrapAlert("提示", "保存失败！", 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}


/*类型数据保存*/
function savedata() {
	var checkMsg = [];
	if( isNull($("#form2").find("input[name='name']").val()) ) {
		checkMsg.push("数据名不能为空！");
	}
	if( isNull($("#form2").find("input[name='value']").val()) ) {
		checkMsg.push("数据值不能为空！");
	}
	if( !isNull(checkMsg) ) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	
	$.ajax({
		url:web_ctx+"/manage/sys/dict/savedata",
		type: "POST",
		dataType: "json",
		data:$("#form2").serializeJson(),
		success:function(data){
			if(data.code==1){
					var newNode = data.result;
					newNode["typeid"] =  newNode.id;
					newNode["name"] =  newNode.name;
					newNode["value"] =  newNode.value;
					newNode["remark"] = newNode.remark;
					bootstrapAlert("提示", "保存成功！", 400, null);
					$("#dataModal").modal("hide");
					datatable.draw();
				
			} else {
				bootstrapAlert("提示", "保存失败！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

//更新字典类型
function update() {
	
		if(!$("#name").val()) {
			bootstrapAlert("提示", "名称不能为空！", 400, null);
			return ;
		}
		$.ajax({
			url:web_ctx+"/manage/sys/dict/save",
			type: "POST",
			dataType: "json",
			data:$("#form1").serializeJson(),
			success:function(data){
				if(data.code==1){
					var newNode = data.result;
					newNode["name"] =  newNode.name;
					newNode["remark"] = newNode.remark;
					zTree.updateNode(currNode);
					$("#typeModal").modal("hide");
					location.replace(location.href);
				} else {
					bootstrapAlert("提示", "修改失败！", 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
}



/********* 字典数据表相关操作 ***************/
var datatable = null;
$(function() {
	datatable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sys/dict/getDataList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	var htmlText = buildOperate(aData);
	$('td:eq(3)', nRow).html(htmlText);
    return nRow;
}


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'name'},
        {"mData": 'value'},
        {"mData": 'remark'},
        {"mData": null}
    ]
	return columns;
}


function showdata(typeid){
	$("#id").val(typeid);
	datatable.draw();
}


/**
 * 构造操作详情HTML 
 **/ 
function buildOperate(aData) {
	var html = [];
	html.push("<a href='javascript:void(0);' onclick='editData("+aData.id+")' >编辑</a>");
	html.push("&nbsp;&nbsp;");
	html.push("<a href='javascript:;' name='' onclick='del("+aData.id+")'>删除</a>");
	return html.join("");
}



function getSearchData() {
	return {"typeid": $("#id").val()};
}

function editData(id)
{
	$.ajax({
		url: web_ctx+"/manage/sys/dict/getData?id="+id,
		type: "get",
		dataType: "json",
		success: function(data){
			$("#form3").find("input").val("");
			$("#editid").val(data.id);
			$("#edittypeid").val(data.typeid);
			$("#editname").val(data.name);
			$("#editvalue").val(data.value);
			$("#editremark").val(data.remark);
			$("#editModal").modal("show");
		}
	});
}


function updatedata() {
		$.ajax({
			url:web_ctx+"/manage/sys/dict/update",
			type: "POST",
			dataType: "json",
			data:$("#form3").serializeJson(),
			success:function(data){
				if(data.code==1){
					$("#editModal").modal("hide");
					datatable.draw();
				} else {
					bootstrapAlert("提示", "修改失败！", 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
}


var idForDel = null;
var sourceForDel = null;
function del(id, source) {
	idForDel = id;
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "deletedata",    
	        "dataType": "json",   
	        "data": {"id": idForDel},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		start = $("#dataTable").dataTable().fnSettings()._iDisplayStart; 
	        		total = $("#dataTable").dataTable().fnSettings().fnRecordsDisplay(); 
	        		datatable.draw();
	        		if((total-start)==1 && start > 0) { 
		        		$("#dataTable").dataTable().fnPageChange('previous', true); 
	        		}
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
