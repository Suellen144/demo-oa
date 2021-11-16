/**
 * Alert弹框
 * @param title		弹框标题
 * @param message	弹框内容
 * @param width		弹框宽度
 * @param callBack	回调函数
 */
function bootstrapAlert(title,message,width,callBack) {
	//获取当前时间当作唯一标识符
	var startTime = new Date().getTime();
	var html = [];
	html.push(' <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="bootstrapAlert'+startTime+'" >');
	html.push('<div class="modal-dialog"><div class="modal-content" id="footer_id1'+startTime+'"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="display:none;">&times;</button>');
	html.push('<h4 class="modal-title">'+title+'</h4>');
	html.push('</div><div class="modal-body">'+message+'</div>');
	html.push('<div class="modal-footer"><button id="ok" type="button" class="btn btn-default" data-dismiss="modal">确定</button>');
	html.push('</div></div></div></div>');
	
	$("body").append(html.join(''));
	
	//设置关闭按钮触发事件
	$("#bootstrapAlert"+startTime).find('button:eq(1)').click(function(e) {
		$("#bootstrapAlert"+startTime).modal('hide');
		//执行回调函数
		if((typeof callBack)=='function'){
			callBack();
		}
	});

	//设置宽度
	if(width!=undefined && width!=null){
		$("#bootstrapAlert"+startTime).find('.modal-dialog').width(width);
	}
	//设置文字自动换行
	$("#bootstrapAlert"+startTime).find('.modal-body').css({'word-wrap':'break-word','word-break':'break-all'});
	$("#bootstrapAlert"+startTime).modal({backdrop: 'static', keyboard: false}	);
	var div = $("#footer_id1"+startTime);
	if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
		var scrollTop= window.parent.document.childNodes[1].scrollTop;
		div[0].style.top=scrollTop + "px";
	}else{
		div[0].style.top=+ "200px";
	}
	//显示弹框
	$("#bootstrapAlert"+startTime).modal('show');
}


/**
 * 弹出遮罩和进度条
 * @param flag   true:弹出；false:关闭
 * @param message   提示信息
 */
function openBootstrapShade(flag,message){
	if(message==undefined || message==null){
		message = '执行中...请稍候...';
	}
	
	if(flag){
		var html = [];
		html.push('<div id="bootstrapShade" style="width: 100%;height: 100%;display: none;position:absolute;top: 0;left: 0;background: #000;opacity: 0.2;"></div>');
		html.push('<div id="bootstrapProgress"  style="width:500px;height:70px;display: none;position:absolute;top:50%;left:50%;margin-top:-100px;margin-left:-250px;background-color:#ffffff;">');
		html.push('<h5 class="text-info text-center">'+message+'</h5>');
		html.push('<div class="progress progress-striped active">');
		html.push('<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">');
		html.push('<span class="sr-only"></span>');
		html.push('</div>');
		html.push('</div>');
		html.push('</div>');
		html.push('');
		
		$("body").append(html.join(''));
		
		$("#bootstrapProgress").show();//进度条
	    $("#bootstrapShade").show();//遮罩
	}else{
		$("#bootstrapProgress").hide();//进度条
	    $("#bootstrapShade").hide();//遮罩
	    $("#bootstrapProgress").remove();
	    $("#bootstrapShade").remove();
	}
}
/**
 * Confirm弹框
 * @param title		弹框标题
 * @param message	弹框内容
 * @param width		弹框宽度
 * @param okCallBack	回调函数
 * @param cancelCallBack	回调函数
 */
function bootstrapConfirm(title,message,width,okCallBack,cancelCallBack) {
	var divbox = $("body").find("div.modal[name='bootstrapConfirm']");
	if(divbox != null && divbox.length > 0) {
		$("#bootstrapConfirm1").remove();
	}
		//获取当前时间当作唯一标识符
		var startTime = new Date().getTime();
		var html = [];
		html.push(' <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" name="bootstrapConfirm" id="bootstrapConfirm1" >');
		html.push('<div class="modal-dialog"><div class="modal-content" id="footer_id"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="display:none;">&times;</button>');
		html.push('<h4 class="modal-title"></h4>');
		html.push('</div><div class="modal-body"></div>');
		html.push('<div class="modal-footer"><button name="ok" type="button" class="btn btn-primary" data-dismiss="modal">确定</button>');
		html.push('<button name="cancel" type="button" class="btn btn-default" data-dismiss="modal">取消</button>');
		html.push('</div></div></div></div>');
		
		$("body").append(html.join(''));
		
		divbox = $("body").find("div.modal[name='bootstrapConfirm']");
		$(divbox).find("button[name='ok']").click(function() {
			if((typeof okCallBack)=='function'){
				okCallBack.call();
			}
		});
		$(divbox).find("button[name='cancel']").click(function() {
			if((typeof cancelCallBack)=='function'){
				cancelCallBack.call();
			}
		});
	
	
	//设置宽度
	if(width!=undefined && width!=null){
		$(divbox).find('.modal-dialog').width(width);
	}
	//设置文字自动换行
	$(divbox).find(".modal-title").text(title);
	$(divbox).find(".modal-body").text(message);
	$(divbox).find('.modal-body').css({'word-wrap':'break-word','word-break':'break-all'});
	$(divbox).modal({backdrop: 'static', keyboard: false}	);
	var div = $("#footer_id");
	if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
		var scrollTop= window.parent.document.childNodes[1].scrollTop;
		div[0].style.top=scrollTop + "px";
	}else{
		div[0].style.top=+ "200px";
	}
	$(divbox).modal('show');
	
	//设置确认按钮触发事件
	/*$("#bootstrapAlert"+startTime).find('button:eq(1)').click(function(e) {
		$("#bootstrapAlert"+startTime).modal('hide');
		//执行回调函数
		if((typeof okCallBack)=='function'){
			okCallBack();
		}
	});
	//设置取消按钮触发事件
	$("#bootstrapAlert"+startTime).find('button:eq(2)').click(function(e) {
		$("#bootstrapAlert"+startTime).modal('hide');
		//执行回调函数
		if((typeof cancelCallBack)=='function'){
			cancelCallBack();
		}
	});*/
	
}
