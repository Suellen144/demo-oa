var noticeObj = null;
	
$(function(){
    getTop3Notice();
    initTodo();
    initNotice();
});

//公告栏数据
function getTop3Notice(){
	$.ajax({
		url: base+'/manage/office/noitce/getTop5Notice',
        dataType: 'JSON',
        contentType: 'application/json;charset=utf-8;',
        data:{},
        success: function(data) {
        	var html = "";
            $.each(data,function(i,val){    
            	if(i<3){
            		html +='<li><a href="javascript:void(0)" data-id="'+val.id+'" '+
	            	' onclick="viewNotice('+val.id+',this)" value="'+val.isRead+'">'+val.title+'</a></li>';
            	}
            })
            $("#notice ul").empty();
            $("#notice ul").append(html);
        }
    });
}

function initTodo() {
	var userId = $("#userId").val();
    var marketAssistant = false;
    if(userId == '225'){
    	marketAssistant = true;//当前用户是市场部部门助手
    }
    $.ajax({
    	url: base+"/manage/office/pendflow/getTodoList?timetamp="+new Date().getTime(),
        dataType: "json",
        success: function(data) {
	        if(!isNull(data) && data.length > 0) {
	        	if(marketAssistant){
		            var count = 0;
		            for (var i = 0; i < data.length; i++) {
		            	if(!isNull(data[i].processName) && 
		            		(data[i].processName == "通用报销流程" ||  data[i].processName == "出差报销流程" ) &&
		            		data[i].business.assistantStatus != '1'){
		            		count = count +1;
		                }
		            }
		            if((getKpi() == "" || getKpi() == null) && (approve || deptId == 2)){
		            	$("#taskQuantity").text(count + 1);
		            }else{
		                $("#taskQuantity").text(count);
		            }
		        }else{
		        	if((getKpi() == "" || getKpi() == null) && (approve || deptId == 2)){
		        		$("#taskQuantity").text(data.length + 1);
		            }else{
		                $("#taskQuantity").text(data.length);
		            }
		        }
	        }else {
	        	if((getKpi() == "" || getKpi() == null) && (approve || deptId == 2)){
	        		$("#taskQuantity").text(1);
	            }else{
	            	$("#taskQuantity").text("0");
	            }
	        }
        }, 
        error: function(data) {
        	bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
        }
    });
}

// 查看当前用户绩效考核状态，当月没有查上月
function getKpi(){
	var status = "";
    $.ajax({
    	url: base+'/manage/ad/kpi/getStatus?timetamp='+new Date().getTime(),
        dataType: 'JSON',
        async: false,
        contentType: 'application/json;charset=utf-8;',
        data:{"deptId":deptId,"time":new Date()},
        success: function(data) {
        	status = data;
        }
    });
    return status;
}
    
//待阅通知个数统计
function initNotice(){
	$.ajax({
		url: base+"/manage/office/noitce/getNoticeCount?timetamp="+new Date().getTime(),
        success: function(data) {
        	var url = "javascript:forward('"+base+"/manage/office/noitce/toList');";
            var count = "";
            if(!isNull(data) && data > 0){
            	count = data;
            }else{
                count = 0 ;
            }
            $("#noticeQuantity").text(count);
        },
        error: function(data) {
        	bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
        }
    });
}
