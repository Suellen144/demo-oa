var zTree, rMenu, currNode;
var positionList = []; 
//获取部门信息
var setting = {
		view: {
			selectedMulti: false,
            addDiyDom: addDiyDom
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
			url: web_ctx+"/manage/sys/dept/getDeptWithPositionInList"
		},
		callback: {
			onAsyncSuccess: expandAll
		}
};

function addDiyDom(treeId, treeNode) {
    var dom = $("#" + treeNode.tId + "_a");
    $(dom).addClass(treeNode.nodetype);
}

$(document).ready(function(){
	$.fn.zTree.init($("#deptTree"), setting);
});

//展开树
function expandAll() {
	zTree = $.fn.zTree.getZTreeObj("deptTree");
	rMenu = $("#rMenu");
	zTree.expandAll(true);
	
	initRightMenu();
}

function initRightMenu() {
    $.contextMenu({
        selector: 'a.dept',
        callback: function(key, options) {
        	currNode = zTree.getNodeByTId($(this).attr("id").replace("_a", ""));
        	zTree.selectNode(currNode);
            switch(key) {
                case 'add': addTreeNode(); break ;
            }
        },
        items: {
            "add": { name: "新增职位", icon: "add" }
        }
    });

    $.contextMenu({
        selector: 'a.position',
        callback: function(key, options) {
        	currNode = zTree.getNodeByTId($(this).attr("id").replace("_a", ""));
        	zTree.selectNode(currNode);
            switch(key) {
                case 'edit': editTreeNode(); break ;
                case 'del': delTreeNode(); break ;
            }
        },
        items: {
            "edit": { name: "编辑职位", icon: "edit" },
            "del": { name: "删除职位", icon: "del" }
        }
    });
}

function addTreeNode() {
	$("#positionName").text("新增职位");
	$("#form").find("input").val("");
	$("#deptId").val(currNode.id.replace("dept_", ""));
	$("#level").find("option:last").prop("selected", true);
	
	$("#saveBtn").attr("onclick", "save()");
	$("#positionModal").modal("show");
}

function editTreeNode() {
	$("#positionName").text("编辑职位");
	$("#deptId").val(currNode.parentId.replace("dept_", ""));
	$("#id").val(currNode.id.replace("position_", ""));
	$("#name").val(currNode.name);
	$("#enname").val(currNode.enname);
	if(!isNull(currNode.nodelevel)) {
		$("#level").find("option[value="+currNode.nodelevel+"]").prop("selected", true);
	} else {
		$("#level").find("option:last").prop("selected", true);
	}

	$("#saveBtn").attr("onclick", "update()");
	$("#positionModal").modal("show");
}

function delTreeNode() {
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax({
			url: web_ctx+"/manage/ad/position/delete",
			dataType: "json",
			data: {"id":currNode.id.replace("position_", "")},
			success: function(data) {
				if(data.code == 1) {
					bootstrapAlert("提示", data.result, 400, function() {
						zTree.removeNode(currNode);
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

//保存
function save() {
	var msg = checkForm();
	if(msg.length) {
		bootstrapAlert("提示", msg.join("<br/>"), 400, null);
		return ;
	}
	
	$.ajax({
		url:web_ctx+"/manage/ad/position/save",
		type: "POST",
		dataType: "json",
		data:$("#form").serializeJson(),
		success:function(data){
			if(data.code==1){
				var newNode = data.result;
				newNode["id"] = "position_" + newNode.id;
				newNode["icon"] = web_ctx + "/static/images/position.png";
				newNode["nodelevel"] = newNode.level;
				zTree.addNodes(currNode, newNode);
				$("#positionModal").modal("hide");
				
				$.contextMenu({
			        selector: "#" + zTree.getNodeByParam("id", newNode["id"], null).tId + "_a",
			        callback: function(key, options) {
			        	currNode = zTree.getNodeByTId($(this).attr("id").replace("_a", ""));
			        	zTree.selectNode(currNode);
			            switch(key) {
			                case 'edit': editTreeNode(); break ;
			                case 'del': delTreeNode(); break ;
			            }
			        },
			        items: {
			            "edit": { name: "编辑职位", icon: "edit" },
			            "del": { name: "删除职位", icon: "del" }
			        }
			    });
			} else {
				bootstrapAlert("提示", "保存失败！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


// 更新
function update() {
	var msg = checkForm();
	if(msg.length) {
		bootstrapAlert("提示", msg.join("<br/>"), 400, null);
		return ;
	}
	
	if($("#form")){
		$.ajax({
			url:web_ctx+"/manage/ad/position/save",
			type: "POST",
			dataType: "json",
			data:$("#form").serializeJson(),
			success:function(data){
				if(data.code==1){
					var newNode = data.result;
					currNode.name = newNode.name;
					currNode.enname = newNode.enname;
					currNode.nodelevel = newNode.level;
					zTree.updateNode(currNode);
					$("#positionModal").modal("hide");
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

var digits = /^\d{3}$/;
function checkForm() {
	var formData = $("#form").serializeJson();
	var text = [];
	if(isNull(formData.name)) {
		text.push("中文名不能为空！");
	}
	
	return text;
}