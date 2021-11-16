/*
function save(){
	var a = isNull(business_iframe.window.checkNull()[0]);
	var b = isNull(market_iframe.window.checkNull()[0]);
	
	var a1 = isNull(business_iframe.window.checkAll()[0]);
	var b1 = isNull(market_iframe.window.checkAll()[0]);
	
	//检查是否两张表单都未填写
	if(!isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		bootstrapAlert("提示", "请至少填写一条工作汇报！", 400, null);
		return ;
		
	}else if (isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])) {
		
		//保存两张表中的数据
		if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
		}else{
			business_iframe.window.save();
		}
		
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
		}else{
			market_iframe.window.save();
		}
		
	}else if (isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		
		//保存business_iframe中的数据
		if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
		}else{
			business_iframe.window.save();
		}
	}else if(!isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])){
		
		//保存market_iframe中的数据
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
		}else{
			market_iframe.window.save();
		}
	}
}


function submitinfo(){
	business_iframe.window.submitinfo();
	market_iframe.window.submitinfo();
}*/



function save(){
	//检查是否两张表单都未填写
	if(!isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		bootstrapAlert("提示", "请至少填写一张表单！", 400, null);
		return ;
		
	}else if (isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])) {
		
		
		if((isNull(business_iframe.window.checkAll()[0]) && $.isEmptyObject(business_iframe.window.checkAll()[0]))
				&& (isNull(market_iframe.window.checkAll()[0]) && $.isEmptyObject(market_iframe.window.checkAll()[0]))){
			openBootstrapShade(true);
			business_iframe.window.save();
			market_iframe.window.save();
			
		}else{
			if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
				bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
			}
			if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
				bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
			}
			
		}
		
	/*	if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
		}else{
			business_iframe.window.save();
		}
		
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
		}else{
			market_iframe.window.save();
		}
		*/
	}else if (isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		
		//保存business_iframe中的数据
		if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
		}else{
			business_iframe.window.save();
		}
	}else if(!isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])){
		
		//保存market_iframe中的数据
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
		}else{
			market_iframe.window.save();
		}
	}
}



function submitwork(){
	if(isNull(market_iframe.window.checknull()[0])){
		market_iframe.window.submitinfo();
	}
}

function savework(){
	if(isNull(market_iframe.window.checknull()[0])){
		market_iframe.window.save();
	}
}


function submitinfo(){
	openBootstrapShade(true);
	//检查是否两张表单都未填写
	if(!isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		bootstrapAlert("提示", "请至少填写一张表单！", 400, null);
		openBootstrapShade(false);
		return ;
		
	}else if (isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])) {
		
		//保存两张表中的数据
		if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
			openBootstrapShade(false);
		}else{
			business_iframe.window.submitinfo();
		}
		
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
			openBootstrapShade(false);
		}else{
			market_iframe.window.submitinfo();
		}
		
	}else if (isNull(business_iframe.window.checkNull()[0])&& !isNull(market_iframe.window.checkNull()[0])) {
		
		//保存business_iframe中的数据
		if((!isNull(business_iframe.window.checkAll()[0]) && !$.isEmptyObject(business_iframe.window.checkAll()[0]))){
			bootstrapAlert("商务工作", business_iframe.window.checkAll(), 400, null);
			openBootstrapShade(false);
		}else{
			business_iframe.window.submitinfo();
		}
	}else if(!isNull(business_iframe.window.checkNull()[0])&& isNull(market_iframe.window.checkNull()[0])){
		
		//保存market_iframe中的数据
		if((!isNull(market_iframe.window.checkAll()[0]) && !$.isEmptyObject(market_iframe.window.checkAll()[0]))){
			bootstrapAlert("拜访工作", market_iframe.window.checkAll(), 400, null);
			openBootstrapShade(false);
		}else{
			market_iframe.window.submitinfo();
		}
	}
}