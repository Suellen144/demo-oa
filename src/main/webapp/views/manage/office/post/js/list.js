var dataTable = null;
$(function() {
	initTabUl();
});
function initTabUl(){
		var n=document.getElementById("title");
		var tab=$("#forumId").val();
		var html = [];
		var content="";
		for(var i=0;i<n.length;i++){
			html.push('<li class="active"><a ');
					if(tab == n.options[i].value){
						html.push('style="color:#3c8dbc;font-weight: bold;"');
					}
			html.push('href="javascript:showList('+n.options[i].value+')">'+n.options[i].text+'</a>');
			html.push('</li>');
		}
		$("#tabUl").html(html.join(""));
}

function showList(tab){
	$("#forumId").val(tab);
	selectPost();
	
}

function deletePost(id){
	$.ajax({
		url : web_ctx+"/manage/office/review/deletePost",
		type: "post",
		data: {"id":id},
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				backPageAndRefresh();
				window.location.href=web_ctx+"/manage/office/review/toList"
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function selectStatus(status){
	$("#status").val(status);
	selectPost();
	
}

function selectPost(){
	var tab=$("#forumId").val();
	var status=$("#status").val();
	window.location.href=web_ctx+"/manage/office/review/findAll?tab="+tab+"&status="+status;
}



function buildUl(data){
	var content="";
	for(var i=0;i<data.length;i++){
		var html = [];
		html.push('<li class="list-group-item">');
		html.push('<div style="height: 50px">');
		html.push('<div style="float: left;width: 6%;margin: 0px 8px 0px 5px">');
		html.push(' <img width="50px" height="50px" src="'+data[i].user.name+'" class="img-rounded">');
		html.push('</div>');
		html.push(' <div style="width: 80%;float: left;margin-left:15px;">');
		html.push(' <a href="'+web_ctx+'/manage/office/review/findById?id='+data[i].id+'">'+data[i].title+'</a><br/>');
		html.push(' <div>');
		html.push('<a><span class="label label-default" >'+data[i].forum.name+'</span></a>&nbsp;&nbsp;&nbsp;');
		html.push('<a href="'+web_ctx+'/member/'+data[i].user.id+'"><span ><strong>'+data[i].user.name+'</strong></span></a>&nbsp;&nbsp;&nbsp;');
		html.push(' <small class="text-muted">'+(new Date(data[i].applyTime)).pattern("yyyy-MM-dd HH:mm:ss")+'</small>');
		html.push('</div>');
		html.push('</div>');
		html.push('<div style="width: 5%;float: right;text-align: center">');
		html.push('<span class="badge">'+data[i].replyCount+'</span>');
		html.push(' </div>');
		html.push(' </div>');
		html.push('</li>');
		content+=html.join("");
	}
	$("#postUl").html(content);
}



function updateAudit(id,audit){
	$.ajax({
		url : web_ctx+"/manage/office/review/updateAudit",
		type: "post",
		data: {"id":id,"audit":audit},
		dataType: "json",
		success: function(data) {
			/*openBootstrapShade(false);*/
			if(data.code == 1) {
				backPageAndRefresh();
				window.location.href=web_ctx+"/manage/office/review/toList"
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}



function updateStatus(id,status){
	$.ajax({
		url : web_ctx+"/manage/office/review/updateStatus",
		type: "post",
		data: {"id":id,"status":status},
		dataType: "json",
		success: function(data) {
			/*openBootstrapShade(false);*/
			if(data.code == 1) {
				backPageAndRefresh();
				window.location.href=web_ctx+"/manage/office/review/toList"
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}