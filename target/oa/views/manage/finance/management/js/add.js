

function hidesubmit(){
	$("#submitinfo").hide();
}

function showsubmit(){
	$("#submitinfo").show();
}


function submitinfo(){
    openBootstrapShade(true);
	if(!isNull(travelreimburs_iframe.window.checknull()[0])&& !isNull(reimburs_iframe.window.checknull()[0])) {
		bootstrapAlert("提示", "请至少填写一张报销表!", 400, null);
        openBootstrapShade(false);
		return ;
	}

	if((!isNull(travelreimburs_iframe.window.checkall()) && !$.isEmptyObject(travelreimburs_iframe.window.checkall()))){
			bootstrapAlert("差旅报销", travelreimburs_iframe.window.checkall(), 400, null);
        	openBootstrapShade(false);
		}
	if(!isNull(reimburs_iframe.window.checkall()[0])){
			bootstrapAlert("通用报销", reimburs_iframe.window.checkall(), 400, null);
        	openBootstrapShade(false);
		}
	
	else if ((isNull(reimburs_iframe.window.checkall()[0]))&&(isNull(travelreimburs_iframe.window.checknull()[0])) && (isNull(travelreimburs_iframe.window.checkall())&&(travelreimburs_iframe.window.checktravel().length>0)&& $.isEmptyObject(travelreimburs_iframe.window.checkall()))){
		bootstrapAlert("差旅报销","差旅申请必须关联出差后方可提交!当前只允许保存操作!", 400, null);
        openBootstrapShade(false);
		
	}
	else{
		if(isNull(travelreimburs_iframe.window.checknull()[0]) && isNull(reimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定提交审核？", 300, function() {
				travelreimburs_iframe.window.submitinfo();
			},null);
			openBootstrapShade(false);
		}
		if(isNull(reimburs_iframe.window.checknull()[0]) && !isNull(travelreimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定提交审核？", 300, function() {
				reimburs_iframe.window.submitinfo();
			},null);
			openBootstrapShade(false);
		}
		if(!isNull(reimburs_iframe.window.checknull()[0]) && isNull(travelreimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定提交审核？", 300, function() {
				travelreimburs_iframe.window.submitinfo();
			},null);
			openBootstrapShade(false);
		}
		
	}
	
}

//解决js异步提交导致的单号重复问题
function submit(){
	if(isNull(reimburs_iframe.window.checknull()[0])){
		reimburs_iframe.window.submitinfo();
	}
}

function savereimburse(){
	if(isNull(reimburs_iframe.window.checknull()[0])){
		reimburs_iframe.window.save();
	}
}

function save(){
	openBootstrapShade(true);
	if(!isNull(travelreimburs_iframe.window.checknull()[0])&& !isNull(reimburs_iframe.window.checknull()[0])) {
		bootstrapAlert("提示", "请至少填写一张报销表！", 400, null);
        openBootstrapShade(false);
		return ;
	}

	if((!isNull(travelreimburs_iframe.window.checkall()) && !$.isEmptyObject(travelreimburs_iframe.window.checkall()))){
			bootstrapAlert("差旅报销", travelreimburs_iframe.window.checkall(), 400, null);
			openBootstrapShade(false);
		}
	if(!isNull(reimburs_iframe.window.checkall()[0])){
			bootstrapAlert("通用报销", reimburs_iframe.window.checkall(), 400, null);
        	openBootstrapShade(false);
		}
	
	else if ((isNull(reimburs_iframe.window.checkall()[0])) && (isNull(travelreimburs_iframe.window.checkall())&& $.isEmptyObject(travelreimburs_iframe.window.checkall()))){
		console.log(11111)
		if(isNull(travelreimburs_iframe.window.checknull()[0]) && isNull(reimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定保存？", 200, function() {
				travelreimburs_iframe.window.save();
			},null);
			openBootstrapShade(false);
		}
		if(isNull(reimburs_iframe.window.checknull()[0]) && !isNull(travelreimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定保存？", 200, function() {
				reimburs_iframe.window.save();
			},null);
			openBootstrapShade(false);
		}
		if(!isNull(reimburs_iframe.window.checknull()[0]) && isNull(travelreimburs_iframe.window.checknull()[0])){
			bootstrapConfirm("提示", "是否确定保存？", 200, function() {
				travelreimburs_iframe.window.save();
			},null);
			openBootstrapShade(false);
		}
	}
	
}