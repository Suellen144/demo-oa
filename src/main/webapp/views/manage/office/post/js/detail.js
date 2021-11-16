function showReply(id){
		$.ajax({
			url : web_ctx+"/manage/office/review/showReply",
			type : "post",
			data : {"id":id},
			dataType : "json",
			success : function(data) {
				if (data!=null && data!="") {
					var replyArray=eval(data);
					buildUl(replyArray);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error : function(data, textstatus) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
	
	function buildUl(data){
		var html = [];
		var content="";
		for(var i=0;i<data.length;i++){
			
			html.push('<div style="height:100%;width:100%">');
			html.push('<li class="list-group-item" style="min-height:100px;height: auto">');
			html.push('<div style="height:auto;margin-top:8px;">');
			html.push('<div style="float: left;width: 6%;margin-bottom: 5px">');
			html.push('<img width="50px" height="50px" src="'+data[i].user.photo+'" class="img-rounded">');
			html.push('</div>');
			html.push('<div style="width: 90%;float: right;">');
			html.push('<strong>'+data[i].user.name+'</strong></a>&nbsp;&nbsp;');
			html.push('<small class="text-muted">'+(new Date(data[i].replyTime)).pattern("yyyy-MM-dd HH:mm:ss") +'</small>');
			html.push('<a style="margin-left:5%" href="javascript:addInReply('+data[i].id+','+data[i].userId+')">回复</a>');
			html.push('<br/>');
			html.push('<div>');
			html.push('<p>'+data[i].content+'</p>');
			html.push('</div>');
			html.push('</div>');
			if(data[i].inReplies.length>0){
				html.push('<div style="width:70%;margin-left:30%;">');
				html.push('<ul>');
				for(var j=0;j<data[i].inReplies.length;j++){
					var indexreply=data[i].inReplies[j];
				html.push('<li  style="min-height:70px;height: auto">');
				html.push('<div style="width: 90%;margin-left:12%">');
				html.push('<strong>'+indexreply.unickName+'</strong>&nbsp;&nbsp;回复&nbsp;&nbsp;<strong>'+indexreply.runickname+'</strong>&nbsp;&nbsp;');
				html.push('<small class="text-muted">'+(new Date(indexreply.replyTime)).pattern("yyyy-MM-dd HH:mm:ss") +'</small>');
				html.push('<a style="margin-left:5%" href="javascript:addInReply('+indexreply.replyId+','+indexreply.userId+')">回复</a>');
				html.push('<br/>');
				html.push('<div>');
				html.push('<p>'+indexreply.content+'</p>');
				html.push('</div>');
				html.push('</div>');
				html.push('</li>');
				}
				html.push('</ul>');
				html.push('</div>');
			}
			html.push('</li>');
			html.push('</div>');
		} 
		content+=html.join("");
		$("#replyUl").html(content);
	}
	
	function  addReply(id){
		$("#myModal").find("input[name='postId']").val(id);
		$("#myModal").modal();
	}
	
	function addInReply(replyId,userId){
		$("#myModal1").find("input[name='replyId']").val(replyId);
		$("#myModal1").find("input[name='ruserId']").val(userId);
		$("#myModal1").modal();
	}
	
	function submitReply(){
		var  formData=getFormData();
		$.ajax({
			url : web_ctx+"/manage/office/review/addReply",
			type : "post",
			contentType : "application/json",
			data : JSON.stringify(formData),
			dataType : "json",
			success : function(data) {
				openBootstrapShade(false);
				if (data.code == 1) {
					backPageAndRefresh();
					window.location.href=web_ctx+"/manage/office/review/toList"
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error : function(data, textstatus) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}

	function getFormData() {
		var json = $("#replyForm").serializeJson();
		var formData = $.extend(true, {}, json);
		var html = ue.getContent();
		formData["content"]=html;
		return formData;
	}
	
	function submitInReply(){
		var  formData=getInreplyFormData();
		$.ajax({
			url : web_ctx+"/manage/office/review/addInReply",
			type : "post",
			contentType : "application/json",
			data : JSON.stringify(formData),
			dataType : "json",
			success : function(data) {
				openBootstrapShade(false);
				if (data.code == 1) {
					backPageAndRefresh();
					window.location.href=web_ctx+"/manage/office/review/toList"
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error : function(data, textstatus) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}

	function getInreplyFormData() {
		var json = $("#inReplyForm").serializeJson();
		var formData = $.extend(true, {}, json);
		var html = ue1.getContent();
		formData["content"]=html;
		return formData;
	}
	
	
	