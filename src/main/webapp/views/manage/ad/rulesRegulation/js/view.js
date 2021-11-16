var zTree, rMenu, currNode;
var rulesRegulationMap = {};
var currPosition = {}; // 保存当前标题对应内容所在的位置
// 当前模式，可以有编辑模式和普通模式。默认为普通模式，只能查看内容，不能做其他操作
var mode = 'view';

$(function() {
	initOutlineTree();
	initCkeditor();
	initScroll();
	
	var node = zTree.transformToArray(zTree.getNodes());
/*	return node[ParentId].name;*/
});

/****************** 页面以及特效相关 Begin **************************/

// 初始化文章的大纲树型结构
function initOutlineTree() {
	$("#content").html('');
	var outlineList = [];
	var rootOutline = getRootOutline();
	getOutlineListOnRoot(rootOutline, outlineList);
	
	zTree = $.fn.zTree.init($("#outlineTree"), getTreeSetting(), outlineList);
	rMenu = $("#rMenu");
	zTree.expandAll(true);
}

// AJAX获取标题大纲的数据
function getRootOutline() {
	var result = {};
	$.ajax({
		url: 'getRootOutline',
		type: 'GET',
		dataType: 'JSON',
		async: false,
		success: function(data) {
			result = data;
		},
		error: function(error) {
			bootstrapAlert("提示", "请求服务器发生错误，请联系管理员！", 400, null);
		}
	});
	return result;
}

function getOutlineListOnRoot(outline, outlineList) {
	if( mode == 'edit' ) { // 编辑模式
		if( !isNull(outline.children) && outline.children.length > 0 ) {
			$(outline.children).each(function(index, child) {
				getOutlineListOnRoot(child, outlineList);
			});
			
			if( outline.publicStatus == 'y' ) {
				outline['name'] = outline['publicTitle'];
				outline.children = null;
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			} else if( !isNull(outline['unpublicTitle']) ) {
				outline['name'] = outline['unpublicTitle'];
				outline.children = null;
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			}
		} else {
			if( outline.publicStatus == 'y' ) {
				outline['name'] = outline['publicTitle'];
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			} else if( !isNull(outline['unpublicTitle']) ) {
				outline['name'] = outline['unpublicTitle'];
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			}
		}
	} else { // 普通模式
		if( !isNull(outline.children) && outline.children.length > 0 ) {
			$(outline.children).each(function(index, child) {
				getOutlineListOnRoot(child, outlineList);
			});
			
			if( outline.publicStatus == 'y' || !isNull(outline['publicTitle']) ) {
				outline['name'] = outline['publicTitle'];
				outline.children = null;
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			}
		} else {
			if( outline.publicStatus == 'y' || !isNull(outline['publicTitle']) ) {
				outline['name'] = outline['publicTitle'];
				outlineList.push(outline);
				
				setRulesRegulation(outline);
			}
		}
	}
	
}

/*function getParentName(ParentId){
	var outlineList = [];
	var rootOutline = getRootOutline();
	zTree = $.fn.zTree.init($("#outlineTree"), getTreeSetting(), outlineList);
	var node = zTree.transformToArray(zTree.getNodes());
	return node[ParentId].name;
}*/
function setRulesRegulation(outline) {
	var rulesRegulation = outline['rulesRegulation'];
	if( !isNull(rulesRegulation) ) {
		outline['rulesRegulationId'] = rulesRegulation.id;
		rulesRegulationMap[outline.id] = rulesRegulation;
		var html = [];
		// 初始化规章制度的内容
		html.push('<div id='+outline.id+' style="position:relative;">');
		if( mode == 'edit' && rulesRegulation['publicStatus'] == 'n' ) {
			if(outline.parentId != 1){
				html.push('<div style = "text-align:center;front-size:22px;front-weight:900;margin-buttom:12px;">')
				html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.name 	+ '</div>' );
			}
			else {
				html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.name + '</div>' );
			}
			html.push(rulesRegulation.unpublicContent);
		} else if( !isNull(rulesRegulation['publicContent']) ) {
			if(outline.parentId != 1){
				html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.name + '</div>' );
			}
			else {
				html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.name + '</div>' );
			}
			html.push(rulesRegulation.publicContent);
		}
		html.push('</div>');
		$("#content").append(html.join(''));
	}
}

// 获取ztree配置
function getTreeSetting() {
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
		callback: {
			onRightClick: rightClick,
			onClick: leftClick
		}
	};
	
	if(mode == 'view') {
		delete setting['callback'].onRightClick;
	}
	
	return setting;
}

function setMode(assignMode) {
	mode = assignMode;
	initOutlineTree();
}

function rightClick(event, treeId, treeNode) {
	if (treeNode && !treeNode.noR) {
		currNode = treeNode;
		zTree.selectNode(treeNode);
		var type = '';
		if(treeNode.parentId == -1) {
			type = 'root';
		} else if( treeNode.isParent ) {
			type = 'outline';
		} else if( !isNull(rulesRegulationMap[treeNode.id])) {
			type = 'content';
		} else {
			type = 'noncontent';
		}
		
		showRMenu(type, event.clientX, event.clientY-50);
	}
}

function leftClick(event, treeId, treeNode) {
	var rulesRegulationId = treeNode['rulesRegulationId'];
	if( isNull(rulesRegulationId) ){
		rulesRegulationId = treeNode['children'][0].rulesRegulationId;
	}
	if( !isNull(rulesRegulationId) ) {
		var position = currPosition[rulesRegulationId];
		
		if( isNull(position) ) {
			if(treeNode['children'].length > 0){
				var top = $("#"+treeNode['children'][0].id)[0].offsetTop;
			}
			else {
				var top = $("#"+treeNode.id)[0].offsetTop;
			}
			$("#content").getNiceScroll(0).doScrollTop(top, 300);
			currPosition = {};
			currPosition[rulesRegulationId] = top;
		} else {
			$("#content").getNiceScroll(0).doScrollTop(position, 300);
		}
		return false;
	}
}

function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if (type == 'root') {
		$("#m_add_title").show();
		$("#m_edit_title").hide();
		$("#m_del_title").hide();
		$("#m_edit_content").hide();
	} else if(type == 'outline') {
		$("#m_add_title").show();
		$("#m_edit_title").show();
		$("#m_del_title").show();
		$("#m_edit_content").hide();
	} else if(type == 'content') {
		$("#m_add_title").hide();
		$("#m_edit_title").show();
		$("#m_del_title").show();
		$("#m_edit_content").show();
	} else if(type == 'noncontent') {
		$("#m_add_title").show();
		$("#m_edit_title").show();
		$("#m_del_title").show();
		$("#m_edit_content").show();
	}
	
	rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", onBodyMouseDown);
}

function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}

function onBodyMouseDown(event) {
	if ( !(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0) ) {
		rMenu.css({"visibility" : "hidden"});
	}
}

function initScroll() {
	var height = $("html").height();
	var top = $("#content").offset().top;
	$("#content").height(height);
/*	$("#content").height(height - top * 2);*/
	

	$(window).bind("resize", function() {
		var height = $("html").height();
		$("#content").height(height - top * 2);
		$("#content").getNiceScroll().resize();
	});
	
	$("#content").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
}

/****************** 页面以及特效相关 End **************************/




/****************** 标题操作相关 Begin **************************/

function addTitle(modalTitle) {
	hideRMenu();
	$("#outlineModalTitle").text(modalTitle);
	$("#title").val("");
	$("#saveBtn").attr("onclick", "saveOrUpdateTitle('save')");
	$("#titleModal").modal("show");
}

function editTitle(modalTitle) {
	hideRMenu();
	$("#outlineModalTitle").text(modalTitle);
	$("#title").val(currNode.name);
	$("#saveBtn").attr("onclick", "saveOrUpdateTitle('update')");
	$("#titleModal").modal("show");
}

function delTitle() {
	hideRMenu();
	
	bootstrapConfirm("提示", "是否删除标题？", 300, function() {
		$.ajax({
			url: "deleteTitle",
			dataType: "JSON",
			data: { "id": currNode.id },
			success: function(data) {
				if(data.code == 1) {
					if( !isNull($("#"+currNode.id)[0]) ) {
						$("#"+currNode.id).remove();
					}
					zTree.removeNode(currNode);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "删除标题出错，请联系管理员！", 400, null);
			}
		});
	}, null);
}

/**
 * 保存或编辑标题
 * */
function saveOrUpdateTitle(oper) {
	var msg = checkForm();
	if(msg.length) {
		bootstrapAlert("提示", msg.join("<br/>"), 400, null);
		return ;
	}
	
	var formData = $("#form").serializeJson();
	var params = { 'unpublicTitle': formData.title };
	if(oper == 'save') {
		params['parentId'] = currNode.id;
	} else {
		params['id'] = currNode.id;
	}
	$.ajax({
		url: 'saveOrUpdateTitle',
		type: 'POST',
		dataType: 'JSON',
		data: params,
		success: function(data) {
			if(data.code == 1) {
				var newNode = data.result;
				if(oper == 'save') {
					newNode["name"] = newNode['unpublicTitle'];
					zTree.addNodes(currNode, newNode);
				/*	window.location.reload(true);*/
				} else {
					currNode["name"] = newNode['unpublicTitle'];
					currNode["unpublicTitle"] = newNode['unpublicTitle'];
					currNode["publicStatus"] = newNode['publicStatus'];
					zTree.updateNode(currNode);
				/*	window.location.reload(true);*/
					
				}
				$("#titleModal").modal("hide");
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "操作标题出错，请联系管理员！", 400, null);
		}
	});
}

function checkForm() {
	var formData = $("#form").serializeJson();
	var text = [];
	if( isNull(formData.title) ) {
		text.push("标题名不能为空！");
	} else if(formData.title.length > 30) {
		text.push("标题不能大于30个字符！");
	}
	
	return text;
}

/****************** 标题操作相关 End **************************/




/****************** 内容操作相关 Begin **************************/

function initCkeditor() {
	var bodyHeight = $(window).height();
	var height = bodyHeight * 0.5; // 百分之六十
	
	CKEDITOR.replace("contentCK", 
		{
			toolbar :
	            [
					//样式       格式      字体    字体大小
					['Styles','Format','Font','FontSize'],
					//文本颜色     背景颜色
					['TextColor','BGColor'],
					//加粗     斜体，     下划线      穿过线      下标字        上标字
					['Bold','Italic','Underline','Strike','Subscript','Superscript'],
					// 数字列表          实体列表            减小缩进    增大缩进
					['NumberedList','BulletedList','-','Outdent','Indent'],
					//左对 齐             居中对齐          右对齐          两端对齐
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					//超链接  取消超链接 锚点
					['Link','Unlink','Anchor'],
					//图片    flash    表格       水平线            表情       特殊字符        分页符
					['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
					
					[ 'Cut' , 'Copy' , 'Paste' , 'PasteText' , 'PasteFromWord' , '-' , 'Print' , 'SpellChecker' ,'Scayt' ],

					//全屏           显示区块
					['Maximize', 'ShowBlocks','-']
	            ],
	         "height": height
		}
	);
}

function editContent() {
	hideRMenu();
	$("#rulesRegulationId").val("");
	var rulesRegulation = rulesRegulationMap[currNode.id];
	if( !isNull(rulesRegulation) ) {
		$("#rulesRegulationId").val(rulesRegulation.id);
		if( rulesRegulation['publicStatus'] == 'y' ) {
			CKEDITOR.instances.contentCK.setData(rulesRegulation['publicContent']);
		} else {
			CKEDITOR.instances.contentCK.setData(rulesRegulation['unpublicContent']);
		}
	} else {
		CKEDITOR.instances.contentCK.setData("");
	}
	$("#contentModal").modal("show");
}



function saveContent() {
	var content = CKEDITOR.instances.contentCK.getData();
	var params = {
		'id': $("#rulesRegulationId").val(),
		'outlineId': currNode.id,
		'unpublicContent': content
	};
	
	$.ajax({
		url: 'saveOrUpdateContent',
		type: 'POST',
		dataType: 'JSON',
		data: params,
		success: function(data) {
			if(data.code == 1) {
				$("#contentModal").modal("hide");
				var result = data.result;
				if( !isNull(result) ) {
					if( !isNull($("#"+currNode.id)[0]) ) {
						rulesRegulationMap[currNode.id] = result;
						$("#"+currNode.id).html('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ currNode.name + '</div>' +result.unpublicContent);
						currNode['rulesRegulationId'] = result.id;
					} else {
						initOutlineTree(); // 如果是新增内容则重新刷新
					}
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "编辑内容出错，请联系管理员！", 400, null);
		}
	});
}

/****************** 内容操作相关 End **************************/