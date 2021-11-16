var zTree, PubliczTree,rMenu, currNode;
var rulesRegulationMap = {};
var currPosition = {}; // 保存当前标题对应内容所在的位置
// 当前模式，可以有编辑模式和普通模式。默认为普通模式，只能查看内容，不能做其他操作
var mode = 'edit';

$(function() {
	initOutlineTree();
	initCkeditor();
	initScroll();
	$("#buttom").append("<button type='button' class='btn btn-primary' onclick='approve()'>通过审核</button> " +
			"<button type='button' class='btn btn-primary' onclick='window.history.go(-1) '>返回</button>");
	

});

/****************** 页面以及特效相关 Begin **************************/

// 初始化文章的大纲树型结构
function initOutlineTree() {
	$("#unpubliccontent").html('');
	var publicList = [];
	var unpublicList = [];
	var rootOutline = getRootOutline();
	getOutlineListOnRoot(rootOutline, publicList, unpublicList);
	
	PubliczTree = $.fn.zTree.init($("#publicTree"), getPublicTreeSetting(), publicList);
	var publicname = PubliczTree.getNodes()[0].children;
	$(publicname).each(function(index,ele){
		if(ele.publicStatus == 'n'){
			if(ele.publicTitle == null ){
				ele.isHidden = true;
			}
			else {
				ele.name = ele.publicTitle;
			}
			
		}
	});
	zTree = $.fn.zTree.init($("#unpublicTree"), getTreeSetting(), unpublicList);
	rMenu = $("#rMenu");
	zTree.expandAll(true);
	PubliczTree.expandAll(true);
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

function getOutlineListOnRoot(outline, publicList, unpublicList) {
	if( !isNull(outline.children) && outline.children.length > 0 ) {
		$(outline.children).each(function(index, child) {
			getOutlineListOnRoot(child, publicList, unpublicList);
		});
		
		// 未发布的数据
		if( outline.publicStatus == 'y' ) {
			outline['name'] = outline['publicTitle'];
			outline.children = null;
			unpublicList.push(outline);
			setRulesRegulation(outline);
		} else if( !isNull(outline['unpublicTitle']) ) {
			outline['name'] = outline['unpublicTitle'];
			outline.children = null;
			unpublicList.push(outline);
		}
		
		// 已发布数据
		if( outline.publicStatus == 'y' || !isNull(outline['publicTitle']) ) {
			outline['name'] = outline['publicTitle'];
			outline.children = null;
			publicList.push(outline);
		}
	} 
	
	else {
		// 未发布的数据
		if( outline.publicStatus == 'y' ) {
			outline['name'] = outline['publicTitle'];
			unpublicList.push(outline);
			setRulesRegulation(outline);
		} else if( !isNull(outline['unpublicTitle']) ) {
			outline['name'] = outline['publicTitle'];
			unpublicList.push(outline);
			setRulesRegulation(outline);
		}
		
		// 已发布数据
		if( outline.publicStatus == 'n' || !isNull(outline['publicTitle']) ) {
			if(outline['unpublicTitle'] != "" && outline.publicStatus == 'n' ){
				outline['name'] = outline['unpublicTitle'];
			}
			else {
				outline['name'] = outline['publicTitle'];
			}
			/*outline['name'] = outline['publicTitle'];*/
			if(outline.publicStatus == 'y'){
				publicList.push(outline);
			}
			setPublicRulesRegulation(outline);
		}

	}
}

function setRulesRegulation(outline) {
	var rulesRegulation = outline['rulesRegulation'];
	if( !isNull(rulesRegulation) ) {
		outline['rulesRegulationId'] = rulesRegulation.id;
		rulesRegulationMap[outline.id] = rulesRegulation;
		
		// 初始化规章制度的内容
		var html = [];
		if( mode == 'edit' && rulesRegulation['publicStatus'] == 'n' ) {
			html.push('<div id='+outline.id+' style="position:relative;color:red;margin-bottom:10px;">');
			if(outline.name != null){
			html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.name + '</div>' );
			}
			else{
				html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.unpublicTitle + '</div>' );
			}
			html.push(rulesRegulation.unpublicContent);
			html.push('</div>');
			$("#unpubliccontent").append(html.join(''));
		} else if( !isNull(rulesRegulation['publicContent']) ) {
			html.push('<div id='+outline.id+' style="position:relative;color:red;">');
			html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.unpublicTitle + '</div>' );
			html.push(rulesRegulation.publicContent);
			html.push('</div>');
			$("#unpubliccontent").append(html.join(''));
		}
		
		
	}
}


function setPublicRulesRegulation(outline) {
	var rulesRegulation = outline['rulesRegulation'];
	if( !isNull(rulesRegulation) ) {
		outline['rulesRegulationId'] = rulesRegulation.id;
		rulesRegulationMap[outline.id] = rulesRegulation;
		
		// 初始化规章制度的内容
		var html = [];
		html.push('<div id='+outline.id+' style="position:relative;margin-bottom:10px;">');
		if(outline.publicTitle != null){
			html.push('<div style = "text-align:center;font-size:22px;font-weight:900;margin-bottom:12px; ">'+ outline.publicTitle + '</div>' );
		}
		if( !isNull(rulesRegulation['publicContent']) ) {
			html.push(rulesRegulation.publicContent);
		}
		html.push('</div>');
		$("#content").append(html.join(''));
	}
}

function setFontCss(treeId, treeNode){
	var color;
	if((treeNode.rulesRegulation != null && treeNode.rulesRegulation.publicStatus == 'n') || treeNode.publicStatus == 'n'){
	color = {color: "red" };
	return color;
}
}

// 获取ztree配置
function getTreeSetting() {
	var setting = {
		view: {
			selectedMulti: false,
			fontCss:setFontCss
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
			onClick: leftClick,
		}
	};
	
	if(mode == 'view') {
		delete setting['callback'];
	}
	
	return setting;
}

/*PublcTree配置初始化*/
function getPublicTreeSetting() {
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
			onClick: leftClick
		}
	};
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
		} else if( !isNull(rulesRegulationMap[treeNode.id]) ) {
			type = 'content';
		} else {
			type = 'noncontent';
		}
		
		showRMenu(type, event.clientX, event.clientY-50);
	}
}

function leftClick(event, treeId, treeNode) {
	var rulesRegulationId = treeNode['rulesRegulationId'];
	if( !isNull(rulesRegulationId) ) {
		var position = currPosition[rulesRegulationId];
		
		if( isNull(position) ) {
			var top = $("#"+treeNode.id)[0].offsetTop;
			$("#content").getNiceScroll(0).doScrollTop(top, 300);
			$("#unpubliccontent").getNiceScroll(0).doScrollTop(top-50, 300);
			currPosition = {};
			currPosition[rulesRegulationId] = top;
		} else {
			$("#content").getNiceScroll(0).doScrollTop(position, 300);
			$("#unpubliccontent").getNiceScroll(0).doScrollTop(position-50, 300);
			
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
	var top2 = $("#unpubliccontent").offset().top;
	
	$("#")

	$(window).bind("resize", function() {
		$("#content").height(300);
		$("#unpubliccontent").height(300);
		$("#content").getNiceScroll().resize();
		$("#unpubliccontent").getNiceScroll().resize();
	});
	
	$("#content").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
	
	$("#unpubliccontent").niceScroll({
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
				} else {
					currNode["name"] = newNode['unpublicTitle'];
					currNode["unpublicTitle"] = newNode['unpublicTitle'];
					currNode["publicStatus"] = newNode['publicStatus'];
					zTree.updateNode(currNode);
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
					window.location.reload(true);
					if( !isNull($("#"+currNode.id)[0]) ) {
						rulesRegulationMap[currNode.id] = result;
						$("#"+currNode.id).html(result.unpublicContent);
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



/****************** 审核操作相关 Begin **************************/
function approve() {
	var node = zTree.transformToArray(zTree.getNodes());
	for (var i = 0; i < node.length; i++) {
		$.ajax({
			url: "approve",
			type: "post",
			data: {"id": node[i].id},
			dataType: "json",
			success: function(data) {
				if(data.code == 1) {
						window.location.href = "toPage";
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		
	}
	$(nodes).each(function(index,ele){
	
	});

}

/****************** 审核操作相关 End **************************/