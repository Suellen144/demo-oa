/**
 * @Description 各类搜索框
 * 
 * 使用条件：
 * 1) 必须引入JQuery
 * 2) 页面初始化完毕后初始化搜索框
 * 
 * 
 * 调用形式：
 * 1) $("div").initXXXDialog({...参数}) // 初始化搜索框
 * 2) $("div").openXXXDialog(); // 打开搜索框
 * 3) // 当点击搜索框里的确定后，调用初始化搜索框时传入的回调函数
 */
var browserInfo = {}; // 浏览器名和版本号
var _global_vari__ = {}; // 存放全局变量

;(function( $ ) { 
	$.fn.extend({
		initUserDialog: initUserDialog,
		initIconsDialog: initIconsDialog,
		initDeptDialog: initDeptDialog,
		initProjectDialog: initProjectDialog,
		initProjectDialog2: initProjectDialog2,
		initBarginDialog: initBarginDialog,
		initPositionDialog: initPositionDialog,
		initTravelDialog: initTravelDialog,
        initUserByDeptDialog:initUserByDeptDialog,
		/*initClientDialog: initClientDialog*/
	});
	
})( jQuery );

/**
 * -------------------------------------------------
 * 用户搜索框 START
 * */
function initUserDialog( options ) {
	var options_ = {
		"callBack": null
	};
	$.extend( options_, options );
	_global_vari__.user_options_ = options_;
	
	$(this).html( getUserDialogHTML() );
	$.fn.openUserDialog = openUserDialog; 
}

function getUserDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog" style="">');
    html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择用户');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height: 70%;">');
	html.push('	         	   <iframe name="userFrame" id="userFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/userDialog.jsp"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button type="button" id="user_close" style="display: none;"  class="btn btn-default" data-dismiss="modal">关闭</button>');
    if (browser.versions.mobile){
        html.push('<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getUserData_()">选择</button>');
	}
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

function openUserDialog(selectUser) {
	if( !isNull(selectUser) ) {
		window.frames["userFrame"].setSelectedUser(selectUser);
	}
	$("#userModal").modal("show");
}

function initBrowserInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
    browserInfo.version = m[2];
}
function getBrowserInfo() {
    return $.extend(true, {}, browserInfo);
}
function _getUserData_() {
    // var rowData = window.frames["userFrame"].getRowData();
    // var cloneData = $.extend(true, {}, rowData);

    var cloneData = null;
    initBrowserInfo();
    var browserInfo = getBrowserInfo();
  /*  if (browserInfo.browser == "ie") {
        var rowData = window.frames["userFrame"].getRowData();
    }
    else{*/
 /*   var rowData = window.frames["userFrame"].getRowData();*/
/*    }*/

    var rowData = window.frames["userFrame"].getRowData();
    if($.isArray(rowData)) {
        cloneData = $.extend(true, [], rowData);
    } else {
        cloneData = $.extend(true, {}, rowData);
    }

    if(_global_vari__.user_options_.callBack != null
        && typeof _global_vari__.user_options_.callBack == "function") {
        _global_vari__.user_options_.callBack.call(this, cloneData);
    }
}

/**
 * -------------------------------------------------
 * 用户搜索框 END
 * */


/**
 * -------------------------------------------------
 * 用户根据部门搜索框 START
 * */
function initUserByDeptDialog( options ) {
    var options_ = {
        "callBack": null
    };
    $.extend( options_, options );
    _global_vari__.user_options_d = options_;

    $(this).html( getUserByDeptDialogHTML() );
    $.fn.openUserByDeptDialog = openUserByDeptDialog;
}

function getUserByDeptDialogHTML() {
    var html = [];
    html.push('	<div class="modal fade" id="userModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
    html.push('	   <div class="modal-dialog" style="">');
    html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
    html.push('	         <div class="modal-header">');
    html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
    html.push('	                  &times;');
    html.push('	            </button>');
    html.push('	            <h4 class="modal-title" id="myModalLabel">');
    html.push('	               	选择用户');
    html.push('	            </h4>');
    html.push('	         </div>');
    html.push('	         <div class="modal-body" style="height: 70%;">');
    html.push('	         	   <iframe name="userFrame2" id="userFrame2" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/userByDeptDialog.jsp"></iframe>');
    html.push('	         </div>');
    html.push('	         <div class="modal-footer">');
    html.push('	            <button type="button" id="user_close2" style="display: none;"  class="btn btn-default" data-dismiss="modal">关闭</button>');
    if (browser.versions.mobile){
        html.push('<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getUserByDeptData_()">选择</button>');
    }
    html.push('	         </div>');
    html.push('	      </div>');
    html.push('		</div>');
    html.push(' </div>');

    return html.join('');
}

function openUserByDeptDialog(selectUser) {
    if( !isNull(selectUser) ) {
        window.frames["userFrame2"].setSelectedUser(selectUser);
    }
    $("#userModal2").modal("show");
}

function initBrowserInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
    browserInfo.version = m[2];
}
function getBrowserInfo() {
    return $.extend(true, {}, browserInfo);
}
function _getUserByDeptData_() {
    // var rowData = window.frames["userFrame"].getRowData();
    // var cloneData = $.extend(true, {}, rowData);

    var cloneData = null;
    initBrowserInfo();
    var browserInfo = getBrowserInfo();
    /*  if (browserInfo.browser == "ie") {
          var rowData = window.frames["userFrame"].getRowData();
      }
      else{*/
    /*   var rowData = window.frames["userFrame"].getRowData();*/
    /*    }*/

    var rowData = window.frames["userFrame2"].getRowData();
    if($.isArray(rowData)) {
        cloneData = $.extend(true, [], rowData);
    } else {
        cloneData = $.extend(true, {}, rowData);
    }

    if(_global_vari__.user_options_d.callBack != null
        && typeof _global_vari__.user_options_d.callBack == "function") {
        _global_vari__.user_options_d.callBack.call(this, cloneData);
    }
}

/**
 * -------------------------------------------------
 * 用户搜索框 END
 * */




/**
 * -------------------------------------------------
 * 图标选择框 START
 * */
function initIconsDialog( options ) {
	var options_ = {
		"callBack": null
	};
	$.extend( options_, options );
	_global_vari__.icon_options_ = options_;
	
	$(this).html( getIconsDialogHTML() );
	$.fn.openIconsDialog = openIconsDialog; 
}

function getIconsDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="iconModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	菜单图标集');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe id="iconFrame" name="iconFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/iconsDialog.jsp"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button id="_closeBtn_" type="button" class="btn btn-default" data-dismiss="modal" onclick="_getIconClass_()">关闭</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

function openIconsDialog() {
	$("#iconModal").modal("show");
}

function _getIconClass_() {
	var iconClass = window.frames["iconFrame"].getIconClass();
	if(_global_vari__.icon_options_.callBack != null 
			&& typeof _global_vari__.icon_options_.callBack == "function") {
		_global_vari__.icon_options_.callBack.call(this, iconClass);
	} 
}

/**
 * -------------------------------------------------
 * 图标选择框 END
 * */





/**
 * -------------------------------------------------
 * 部门搜索框 START
 * */
function initDeptDialog( options ) {
	var containerId = $(this).attr("id");
	var options_ = {
		"callBack": null,
		"isCheck": false // 是否允许多选
	};
	$.extend( options_, options );
	_global_vari__[containerId] = {};
	_global_vari__[containerId].dept_options_ = options_;
	
	$(this).html( getDeptDialogHTML(containerId) );
	$.fn.openDeptDialog = openDeptDialog; 
}

function getDeptDialogHTML( containerId ) {
	var html = [];
	html.push('	<div class="modal fade" id="deptModal'+containerId+'" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择部门');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe id="deptFrame'+containerId+'" name="deptFrame'+containerId+'" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/deptDialog.jsp?isCheck='+_global_vari__[containerId].dept_options_["isCheck"]+'&isGetChildren='+_global_vari__[containerId].dept_options_["isGetChildren"]+'"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getDept_(\''+containerId+'\')">确定</button>');
	html.push('	            <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	return html.join('');
}

function openDeptDialog(selectedIdList) {
	var containerId = $(this).attr("id");
	$("#deptModal"+containerId).modal("show");
	if( !isNull(selectedIdList) ) {
		window.frames["deptFrame"+containerId].setTreeChecked(selectedIdList);
	}
	var div = $(".modal-content");
	if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
		var scrollTop= window.parent.document.childNodes[1].scrollTop;
		div[0].style.top=scrollTop + "px";
		if(div[1] !=undefined){
			div[1].style.top=scrollTop + "px";
		}
	}else{
		div[0].style.top=+ "200px";
		if(div[1] !=undefined){
			div[1].style.top=+ "200px";
		}
	}
}

function _getDept_( containerId ) {
	var dept = window.frames["deptFrame"+containerId].getDeptNode();
	if(_global_vari__[containerId].dept_options_.callBack != null 
			&& typeof _global_vari__[containerId].dept_options_.callBack == "function") {
		_global_vari__[containerId].dept_options_.callBack.call(this, dept);
	} 
	
}
/**
 * -------------------------------------------------
 * 部门搜索框 END
 * */



/**
 * -------------------------------------------------
 * 项目搜索框 START
 * */
function initProjectDialog( options ) {
	var options_ = {
		"callBack": null
	};
	$.extend( options_, options );
	_global_vari__.project_options_ = options_;
	
	$(this).html( getProjectDialogHTML() );
	$.fn.openProjectDialog = openProjectDialog; 
}

function initProjectDialog2( options ) {
	var options_ = {
		"callBack": null
	};
	$.extend( options_, options );
	_global_vari__.project_options_ = options_;
	
	$(this).html( getProjectDialogHTML2() );
	$.fn.openProjectDialog = openProjectDialog; 
}

function getProjectDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="projectModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog modal-sm-10">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择项目');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe id="projectFrame" name="projectFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/projectDialog.jsp"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
    if (browser.versions.mobile){
        html.push('<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getProject_();">选择</button>');
    }
	html.push('	            <button type="button"  style="display: none;" id="project_close" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');

	return html.join('');
}

function getProjectDialogHTML2() {
	var html = [];
	html.push('	<div class="modal fade" id="projectModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog modal-sm-10">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择项目');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe id="projectFrame" name="projectFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/projectDialog2.jsp"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
    if (browser.versions.mobile){
        html.push('<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getProject_();">选择</button>');
    }
	html.push('	            <button type="button"  style="display: none;" id="project_close" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');

	return html.join('');
}

$(function() {
	$("#projectModal").on("hidden", function() {
		$(this).removeData("modal");
	});
});

function openProjectDialog() {
	$("#projectModal").modal("show");
	var div = $(".modal-content");
	if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
		var scrollTop= window.parent.document.childNodes[1].scrollTop;
		div[0].style.top=scrollTop + "px";
		if(div[1] !=undefined){
		div[1].style.top=scrollTop + "px";
		}
	}else{
		div[0].style.top=+ "200px";
		if(div[1] !=undefined){
		div[1].style.top=+ "200px";
		}
	}
}

function _getProject_() {
	var rowData = window.frames["projectFrame"].getRowData();
	var cloneData = $.extend(true, {}, rowData);
	if(_global_vari__.project_options_.callBack != null 
			&& typeof _global_vari__.project_options_.callBack == "function") {
		_global_vari__.project_options_.callBack.call(this, cloneData);
	}
}
/**
 * -------------------------------------------------
 * 项目搜索框 END
 * */



/**
 * -------------------------------------------------
 * 合同搜索框 START
 * */
function initBarginDialog( options ) {
	var options_ = {
		"callBack": null,
        "isCheck": false // 是否允许多选
	};
	$.extend( options_, options );
	_global_vari__.bargin_options_ = options_;
	
	$(this).html( getBarginDialogHTML() );
	$.fn.openBarginDialog = openBarginDialog; 
}

function getBarginDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="barginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog modal-sm-10">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择合同');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe id="barginFrame" name="barginFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/barginDialog.jsp?isCheck='+_global_vari__.bargin_options_["isCheck"]+'"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('				<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getBargin_();">选择</button>');
	html.push('	            <button type="button"  style="display: none;" id="bargin_close" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

$(function() {
	$("#barginModal").on("hidden", function() {
		$(this).removeData("modal");
	});
});

function openBarginDialog() {
	$("#barginModal").modal("show");
}

function initBrowserInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
    browserInfo.version = m[2];
}
function getBrowserInfo() {
    return $.extend(true, {}, browserInfo);
}

function _getBargin_() {
    var cloneData = null;
    initBrowserInfo();
    var browserInfo = getBrowserInfo();
    var rowData = window.frames["barginFrame"].getRowData();
    // if (browserInfo.browser == "ie") {
    //     var rowData = window.frames["barginFrame"].getRowData();
    // }
    // else{
    //     var rowData = barginFrame.contentWindow.getRowData();
    // }
    if($.isArray(rowData)) {
        cloneData = $.extend(true, [], rowData);
    } else {
        cloneData = $.extend(true, {}, rowData);
    }
	if(_global_vari__.bargin_options_.callBack != null 
			&& typeof _global_vari__.bargin_options_.callBack == "function") {
		_global_vari__.bargin_options_.callBack.call(this, cloneData);
	}
}
/**
 * -------------------------------------------------
 * 合同搜索框 END
 * */



/**
 * -------------------------------------------------
 * 职位搜索框 START
 * */
function initPositionDialog( options ) {
	var options_ = {
		"callBack": null,
		"isCheck": false, // 是否允许多选
		"isGetChildren": false // 是否只获取子部门
	};
	$.extend( options_, options );
	_global_vari__.position_options_ = options_;
	
	$(this).html( getPositionDialogHTML() );
	$.fn.openPositionDialog = openPositionDialog; 
}

function getPositionDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="positionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择职位');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe name="positionFrame" id="positionFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/positionDialog.jsp?isCheck='+_global_vari__.position_options_["isCheck"]+'"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getPositionData_()">选择</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

function openPositionDialog() {
	$("#positionModal").modal("show");
}

function _getPositionData_() {
	var cloneData = null;
	var rowData = window.frames["positionFrame"].getRowData();
	if($.isArray(rowData)) {
		cloneData = $.extend(true, [], rowData);
	} else {
		cloneData = $.extend(true, {}, rowData);
	}

	if(_global_vari__.position_options_.callBack != null 
			&& typeof _global_vari__.position_options_.callBack == "function") {
		_global_vari__.position_options_.callBack.call(this, cloneData);
	} 
}

/**
 * -------------------------------------------------
 * 职位搜索框 END
 * */





/**
 * -------------------------------------------------
 * 出差管理搜索框 START
 * */
function initTravelDialog( options ) {
	var options_ = {
		"callBack": null,
		"isCheck": false // 是否允许多选
	};
	$.extend( options_, options );
	_global_vari__.travel_options_ = options_;
	
	$(this).html( getTravelDialogHTML() );
	$.fn.openTravelDialog = openTravelDialog; 
}

function getTravelDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="travelModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择出差');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe name="travelFrame" id="travelFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/travelDialog.jsp?isCheck='+_global_vari__.travel_options_["isCheck"]+'"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button type="button" id="travel_close" style="display: none;" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getTravelData_()">选择</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

function openTravelDialog() {
	$("#travelModal").modal("show");
}

function initBrowserInfo() {
	var ua = navigator.userAgent.toLowerCase();
	var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
	var m = ua.match(re);
	browserInfo.browser = m[1].replace(/version/, "'safari");
	browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
	browserInfo.version = m[2];
}


function getBrowserInfo() {
	return $.extend(true, {}, browserInfo);
}

function _getTravelData_() {
	var cloneData = null;
	initBrowserInfo();
	var browserInfo = getBrowserInfo();
	if (browserInfo.browser == "ie") {
        var rowData = window.frames["travelFrame"].getRowData();
    }
    else{
        var rowData = travelFrame.contentWindow.getRowData();
    }
	if($.isArray(rowData)) {
		cloneData = $.extend(true, [], rowData);
	} else {
		cloneData = $.extend(true, {}, rowData);
	}

	if(_global_vari__.travel_options_.callBack != null 
			&& typeof _global_vari__.travel_options_.callBack == "function") {
		_global_vari__.travel_options_.callBack.call(this, cloneData);
	} 
}

/**
 * -------------------------------------------------
 * 出差管理搜索框 END
 * */




/**
 * -------------------------------------------------
 * 客户管理搜索框 START
 * */
function initClientDialog( options ) {
	var options_ = {
		"callBack": null
	};
	$.extend( options_, options );
	_global_vari__.client_options_ = options_;
	
	$(this).html( getClientDialogHTML() );
	$.fn.openClientDialog = openClientDialog; 
}

function getClientDialogHTML() {
	var html = [];
	html.push('	<div class="modal fade" id="clientModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">');
	html.push('	   <div class="modal-dialog">');
	html.push('	      <div class="modal-content" style="height:500px;width:auto;">');
	html.push('	         <div class="modal-header">');
	html.push('	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">');
	html.push('	                  &times;');
	html.push('	            </button>');
	html.push('	            <h4 class="modal-title" id="myModalLabel">');
	html.push('	               	选择客户');
	html.push('	            </h4>');
	html.push('	         </div>');
	html.push('	         <div class="modal-body" style="height:73%;">');
	html.push('	         	   <iframe name="clientFrame" id="clientFrame" style="width:100%;height:100%;border:none;" src="'+web_ctx+'/views/manage/common/dialog/clientDialog.jsp"></iframe>');
	html.push('	         </div>');
	html.push('	         <div class="modal-footer">');
	html.push('	            <button type="button" id="client_close" style="display: none;" class="btn btn-default" data-dismiss="modal">关闭</button>');
	html.push('	            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="_getClientData_()">选择</button>');
	html.push('	         </div>');
	html.push('	      </div>');
	html.push('		</div>');
	html.push(' </div>');
	
	return html.join('');
}

function openClientDialog() {
	$("#clientModal").modal("show");
}

function _getClientData_() {
	var cloneData = null;
	var rowData = window.frames["clientFrame"].getRowData();
	if($.isArray(rowData)) {
		cloneData = $.extend(true, [], rowData);
	} else {
		cloneData = $.extend(true, {}, rowData);
	}

	if(_global_vari__.client_options_.callBack != null 
			&& typeof _global_vari__.client_options_.callBack == "function") {
		_global_vari__.client_options_.callBack.call(this, cloneData);
	} 
}

/**
 * -------------------------------------------------
 * 客户管理搜索框 END
 * */