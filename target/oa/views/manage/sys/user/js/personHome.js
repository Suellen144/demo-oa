var noticeObj = null;
	
$(function(){
	initNoticeType();
    // 构建轮播
    /*$('.carousel').carousel({
    	interval: 3000
    });*/
    setInterval(getNowDate,1000)
    getTop5Notice();
    initTodo();
    initNotice();
});
   
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
    
function initTodo() {
	var userId = $("#userId").val();
    var marketAssistant = false;
    /*if(userId == '225'){
    	marketAssistant = true;//当前用户是市场部部门助手
    }*/
    $.ajax({
    	url: base+"/manage/office/pendflow/getTodoList",
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
		            if((getKpi() == "" || getKpi() == null || getKpi() == 3) && (approve || userId == 2)){
		            	$("#taskQuantity").text(count + 1);
		            }else{
		                $("#taskQuantity").text(count);
		            }
		        }else{
		        	if((getKpi() == "" || getKpi() == null || getKpi() == 3) && (approve || userId == 2)){
		        	    if(userId != 525) {
                            $("#taskQuantity").text(data.length + 1);
                        }else {
		        	        if(getKpi() == 3){
                                $("#taskQuantity").text(data.length);
                            }else {
                                $("#taskQuantity").text(data.length + 1);
                            }
                        }
		            }else{
		                $("#taskQuantity").text(data.length);
		            }
		        }
	        }else {
	        	if((getKpi() == "" || getKpi() == null || getKpi() == 3) && (approve || userId == 2)){
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

//待阅通知个数统计
function initNotice(){
	$.ajax({
		url: base+"/manage/office/noitce/getNoticeCount",
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

// 查阅公告
var typeMap = {}
function viewNotice(id, li) {
	$.ajax({
		url : base + "/manage/office/noitce/getNotice?id="+ id,
        type : "get",
        dataType : "json",
        success : function(data) {
        	$("#form1")[0].reset();
            $("#attachName").text("");
            $("#attachName").attr("href", "javascript:void(0);");
            $("#attachName").removeAttr("target");
			noticeObj = li;
			if (!$("#details_div").hasClass("collapsed-box")) {
				$("#details_div").find("button").trigger("click");
            }
            if (!isNull(data)) {
            	// 设置模态框内容
                $("#title").html(data.title); //公告标题
                $("#type2").val(typeMap[data.type]);  //公告类型
                $(".modal-headerT").text(typeMap[data.type]); //公告头
                $("#createBy").find('span').eq(1).text(!isNull(data.user) ? data.user.name: ""); //拟稿人
                var dataT = new Date(!isNull(data.actualPublishTime) ? data.actualPublishTime: data.createDate).pattern("yyyy-MM-dd");
                $("#updateDate").find('span').eq(1).text(dataT) //发布时间
                $("#content").html(data.content); //弹窗内容
                 
                /*签发人*/
                if (data.type == 1) {
                	$("#approver").find('span').eq(1).text(!isNull(data.approver) ? data.approver.name : "");                   	
                    $("#approver").show();
                } else {
                    $("#approver").hide();
                }
                
                /*附件*/
                if (!isNull(data.attachName)) {
                	$(".noticeEnclosure").show();
                    $(".noticeEnclosure").text(data.attachName)
                    $(".noticeEnclosure").attr("href", web_ctx + data.attachments);
                    $(".noticeEnclosure").attr("target", "_blank");
                } else {
                	$("#attachName").parents("tr").hide();
                }

                /*发布部门*/
                var companyName = "";
                var deptName = "";
                var dept = deptMap[data.publisherId];
                if (!isNull(dept)) {
                	var nodeLinks = dept.nodeLinks.split(",");
                    if (nodeLinks.length > 3) {
                    	companyName = deptMap[nodeLinks[2]].name; // 数组的第3位是公司
                    }
                    deptName = dept.name;
                }
                if (data.publishers.name.indexOf("总经理") > -1 || data.publishers.name.indexOf("副总经理") > -1) {
                	deptName = "";
                }
                $("#dept span").text(companyName);
                $("#updateDate").find('span').eq(0).text(deptName)
                    
                /*抄送*/
                var deptList = [];
                if (!isNull(data.deptIds)) {
                	var deptIds = data.deptIds.split(",");
                    $(deptIds).each(function(index, id) {
                    	deptList.push(deptMap[id]);
                    });
                } else {
                	$(parentDeptList).each(
                        function(index, dept) {
                            deptList.push(dept);
                    });
                }
                var res = sendScope(deptList);
                var htmlCC = '';
                $.each(res.deptName,function(i,val){
                	htmlCC += '<p>'+val+'</p>';
                })
                $("#deptName").find('div').html(htmlCC);
					
                // 设置模态框高度
                var bodyHeight = $(window).height();
                var modalHeight = bodyHeight * 0.7;
                $("#noticeModal").find(".modal-body").css("max-height", modalHeight);

                // 显示模态框
                $("#noticeModal").modal("show");
                    setReadStatus(id)
            } else {
            	bootstrapAlert("提示", "抱歉，没有此公告数据！", 400, null);
            }  
        },
        error : function(e) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}
$("#performance").click(function(){
     // 显示模态框
     /*$("#noticeModal1").modal("show");*/
});

// 通知类型
function initNoticeType() {
	$("#noticeType").find("option").each(function(index, option) {
		typeMap[$(option).attr("value")+""] = $(option).text()+"";
    });
}

// 公告栏数据
function getTop5Notice(){
	$.ajax({
		url: base+'/manage/office/noitce/getTop5Notice',
        dataType: 'JSON',
        contentType: 'application/json;charset=utf-8;',
        data:{},
        success: function(data) {
        	var html = "";
            $.each(data,function(i,val){            		 
	            if(val.isRead){               			
	            	html +='<a href="javascript:void(0)" data-id="'+val.id+'" '+
	            	' onclick="viewNotice('+val.id+',this)" value="'+val.isRead+'" '+
	            	' title="'+val.title+'" style=color:#999><p>'+
	            	'<span class="title">'+val.title+'</span>'+
	            	'<span class="time">'+fmtDate(val.createDate)+'</span> </p></a>';           			 
	            }else{
	            	html +='<a href="javascript:void(0)" data-id="'+val.id+'" '+
	            	' onclick="viewNotice('+val.id+',this)"  value="'+val.isRead+'" '+
	            	' title="'+val.title+'"><p><span class="title">'+val.title+'</span>'+
	            	'<span class="time">'+fmtDate(val.createDate)+'</span> </p></a>';            			  
	            }
            })
            $(".main-1-ad .pan-con").empty();
            $(".main-1-ad .pan-con").append(html);
        }
    });
}
    
// 已阅
function setReadStatus(id) {
	$.ajax({
		url : web_ctx + "/manage/office/noitce/setReadStatus?id=" + id,
        type : "post",
        data : {"noticeId" : id},
        dataType : "json",
        success : function(data) {
        	if (!isNull(data) && data.code == 1) {
        		$(noticeObj).attr("value", "true");
            } else {
            	bootstrapAlert("提示", data.result, 400, null);
            }
        },
        error : function(e) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
    getTop5Notice();
}
    
function fmtDate(obj){
	var date =  new Date(obj);
    var y = 1900+date.getYear();
    var m = "0"+(date.getMonth()+1);
    var d = "0"+date.getDate();
    return y+"-"+m.substring(m.length-2,m.length)+"-"+d.substring(d.length-2,d.length);
}

function getNowDate() {   	
	var date = new Date();
    var sign1 = "-";
    var sign2 = ":";
    var year = date.getFullYear() // 年
    var month = date.getMonth() + 1; // 月
    var day  = date.getDate(); // 日
    var hour = date.getHours(); // 时
    var minutes = date.getMinutes(); // 分
    var seconds = date.getSeconds() //秒
    var weekArr = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    var tiemT = ['上午','下午'];
    var tiemC = '';
    var week = weekArr[date.getDay()];
    // 给一位数数据前面加 “0”
    if (month >= 1 && month <= 9) {
    	month = "0" + month;
    }
    if (day >= 0 && day <= 9) {
    	day = "0" + day;
    }
    if (hour >= 0 && hour <= 9) {
    	hour = "0" + hour;
    }
    if (minutes >= 0 && minutes <= 9) {
    	minutes = "0" + minutes;
    }
    if (seconds >= 0 && seconds <= 9) {
    	seconds = "0" + seconds;
    }
    if(hour<12){
    	tiemC = '上午'
    }else{
        tiemC = '下午'
    }
    var currentdate = year + sign1 + month + sign1 + day + " " + hour + sign2 + minutes + sign2 + seconds + " " + week;

    $('.date').text(year + '年' + month + '月' + day + '日');
    $('.date-day').text(week + '  '+ tiemC);
    $('.date-tiem').text(hour + ':' + minutes)            
}
    
// 计算抄送范围的部门字符串
function sendScope(deptList) {
	var deptName = [];
    var deptIds = [];
    var deptNameTree = {};

    $(deptList).each(function(index, dept) {
    	try {
    		deptIds.push(dept.id);
            if (dept.level == 1) { // 树的第一级为公司，只做添加
            	deptNameTree[dept.id] = {
            	    "id" : dept.id,
                    "name" : dept.name,
                    "children" : []
                };
            } else if (dept.level == 2) { // 树的第二级为部门，需要跟公司挂钩
            	var parent = deptMap[dept.parentId];
                if (isNull(deptNameTree[parent.id])) {
                	deptNameTree[parent.id] = {
                        "id" : parent.id,
                         "name" : parent.name,
                         "children" : [{
                             "id" : dept.id,
                              "name" : dept.name,
                              "children" : []
                         }]
                    };
                } else {
                	var children = deptNameTree[parent.id].children;
                    children.push({
                        "id" : dept.id,
                        "name" : dept.name,
                        "children" : []
                    });
                }
            } else { // 树的其他级，需要挂钩到部门，最终挂钩到公司
            	var nodeLinks = dept.nodeLinks.split(",");
                nodeLinks = nodeLinks.slice(2); // 获取从公司到当前选择机构的路径链接

                var prevDept = null; // 始终保存上一级树
                $(nodeLinks).each(function(index, link) {
                	if (index == 0) { // 索引为0，则是树的第一级，为公司
                		var parent = deptNameTree[link];
                        if (isNull(parent)) {
                        	var tempDept = deptMap[link];
                            var temp = {
                                "id" : tempDept.id,
                                "name" : tempDept.name,
                                "children" : []
                            };
                            deptNameTree[tempDept.id] = temp;
                            prevDept = temp;
                        } else {
                        	prevDept = parent;
                        }
                    } else {
                    	var isHas = false; // 上一级部门（prevDept）的 children 是否已经存在当前树
                        var children = prevDept.children;
                        var tempDept = deptMap[link];

                        $(children).each(function(index, child) {
                        	if (child.id == tempDept.id) {
                        		isHas = true;
                                prevDept = child;
                             }
                        });
                        if (!isHas) {
                        	var temp = {
                                "id" : tempDept.id,
                                "name" : tempDept.name,
                                "children" : []
                            };
                            children.push(temp);
                            prevDept = temp;
                        }
                    }
                });
            }
        } catch (e) {
        	console.error(e);
        }
    });
    // 构建每一个以公司为单位的树的部门名称，比如xxx公司(a部门,b部门), yyy公司(a部门,b部门)
    for ( var key in deptNameTree) {
    	var value = deptNameTree[key];
        var tempDeptName = [];
        buildDeptName(tempDeptName, value);
        deptName.push(tempDeptName.join(""));
    }
    return {
	    "deptName" : deptName,
        "deptIds" : deptIds
    };
}
    
    
function buildDeptName(deptName, dept) {
	if (isNull(dept.children)) {
		deptName.push(dept.name);
    } else {
        deptName.push(dept.name);
        deptName.push("(");
        $(dept.children).each(function(index, child) {
	        if (index > 0) {
	        	deptName.push(",");
	        }
	        deptName.push(buildDeptName(deptName, child));
        });
            deptName.push(")");
    }
}
