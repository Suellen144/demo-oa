$(function() {
	var id = $("#id").val();
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/office/pendflow/getPendflowList",    
        "dataType": "json",
        "success": function(data) {
        	if(data.code == 1) {
        		var html = buildHtml(data.result);
        		$("#dataTable").html(html);
        	} else {
        		bootstrapAlert("提示", "获取待办列表错误！错误信息：" + data.result, 400, null);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
});

var tableMap = {
	'travelReimburse': 'fin_travelreimburse',
	'reimburse': 'fin_reimburse'
}


function compare(property){
    return function(a,b){
        var value1 = a.task.createTime;
        var value2 = b.task.createTime;
        return value2 - value1;
    }
}

function initKpi(){
	var date = new Date();    
	var status = null;
	date.pattern("yyyy-MM");
	$.ajax({
		url: web_ctx+'/manage/ad/kpi/getStatus',
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





function buildHtml(list) {
	var html = [];
	var dataMap = {};
	if(list.length > 0) {
		var kpi = initKpi();
		list.sort(compare('task'));
			var count = 0;
        	if($("#userId").val()=='225'){
			$(list).each(function(index, json) {
                if((json.processName == "通用报销流程" ||  json.processName == "出差报销流程") && json.business.assistantStatus != '1'){
					count = count +1;
					html.push('<div  class="todoLiBox" onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');">');
					html.push(' <div class="todoLiHead">');
                	html.push('<img src="../../../static/images/todolist.png"> ');
                	html.push('<span>');
                	html.push(json.processName);
                    html.push('</span>');
                    html.push('<i>')
					html.push(new Date(json.task.createTime).pattern("yyyy-MM-dd HH:mm"))
                    html.push('</i>')
					html.push('</div>');
                    html.push(' <div class="todoLiConn clearfix">');
                    html.push('<div class="todoLiConnL">');
                    html.push('<div class="todoLiConnTit">');
                    html.push('申请人');
                    html.push('</div>');
                    html.push(' <div class="todoLiConnMsg">');
                    html.push(json.initiator.name);
                    html.push('</div> ');
					html.push('</div> ');
                    html.push('<div class="todoLiConnR">');
					html.push('<div class="todoLiConnTit">');
                    html.push('单号');
                    html.push('</div> ')
                    html.push(' <div class="todoLiConnMsg" id='+json.processInstanceId+'>');
                    html.push('--');
                	html.push('</div>')
					html.push('</div>')
					html.push('</div>')
					html.push('</div>')
                }
				/*	初始化报销单号*/
                if( !isNull(tableMap[json.processKey]) ) {
                    if( isNull(dataMap[json.processKey]) ) {
                        dataMap[json.processKey] = {};
                        dataMap[json.processKey]['column'] = 'process_instance_id';
                        dataMap[json.processKey]['tableName'] = tableMap[json.processKey];
                    }
                    if( isNull(dataMap[json.processKey]['dataList']) ) {
                        dataMap[json.processKey]['dataList'] = [];
                    }
                    dataMap[json.processKey]['dataList'].push(json.processInstanceId);
                }
                /*	初始化报销单号*/
			});
                if (count == 0) {
                    html.push('<div  class="todoLiBox" ');
                    html.push(' <div class="todoLiHead">');
                    html.push('<img src="../../../static/images/todolist.png"> ');
                    html.push('<span>');
                    html.push("无待办流程");
                    html.push('</span>');
                    html.push('<i>')
                    html.push("")
                    html.push('</i>')
                    html.push('</div>');
                    html.push(' <div class="todoLiConn clearfix">');
                    html.push('<div class="todoLiConnL">');
                    html.push('<div class="todoLiConnTit">');
                    html.push('</div>');
                    html.push(' <div class="todoLiConnMsg">');
                    html.push("");
                    html.push('</div> ');
                    html.push('</div> ');
                    html.push('<div class="todoLiConnR">');
                    html.push('<div class="todoLiConnTit">');
                    html.push('</div> ')
                    html.push(' <div class="todoLiConnMsg">');
                    html.push('</div>')
                    html.push('</div>')
                    html.push('</div>')
                    html.push('</div>')
                }
        	}
        	else{
                $(list).each(function(index, json) {
                        html.push('<div  class="todoLiBox" onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');">');
                        html.push(' <div class="todoLiHead">');
                        html.push('<img src="../../../static/images/todolist.png"> ');
                        html.push('<span>');
                        html.push(json.processName);
                        html.push('</span>');
                        html.push('<i>')
                        html.push(new Date(json.task.createTime).pattern("yyyy-MM-dd HH:mm"))
                        html.push('</i>')
                        html.push('</div>');
                        html.push(' <div class="todoLiConn clearfix">');
                        html.push('<div class="todoLiConnL">');
                        html.push('<div class="todoLiConnTit">');
                        html.push('申请人');
                        html.push('</div>');
                        html.push('<div class="todoLiConnMsg">');
                        html.push(json.initiator.name);
                        html.push('</div> ');
                        html.push('</div> ');
                        html.push('<div class="todoLiConnR">');
                        html.push('<div class="todoLiConnTit">');
	                        html.push('单号');
                        html.push('</div> ')
                        html.push(' <div class="todoLiConnMsg" id='+json.processInstanceId+'>');
                        html.push('--');
                        html.push('</div>')
                        html.push('</div>')
                        html.push('</div>')
                        html.push('</div>')
                    /*	初始化报销单号*/
                    if( !isNull(tableMap[json.processKey]) ) {
                        if( isNull(dataMap[json.processKey]) ) {
                            dataMap[json.processKey] = {};
                            dataMap[json.processKey]['column'] = 'process_instance_id';
                            dataMap[json.processKey]['tableName'] = tableMap[json.processKey];
                        }
                        if( isNull(dataMap[json.processKey]['dataList']) ) {
                            dataMap[json.processKey]['dataList'] = [];
                        }
                        dataMap[json.processKey]['dataList'].push(json.processInstanceId);
                    }
                    /*	初始化报销单号*/
                });
			}
	}else{
        html.push('<div  class="todoLiBox" ');
        html.push(' <div class="todoLiHead">');
        html.push('<img src="../../../static/images/todolist.png"> ');
        html.push('<span>');
        html.push("无待办流程");
        html.push('</span>');
        html.push('<i>')
        html.push("")
        html.push('</i>')
        html.push('</div>');
        html.push(' <div class="todoLiConn clearfix">');
        html.push('<div class="todoLiConnL">');
        html.push('<div class="todoLiConnTit">');
        html.push('</div>');
        html.push(' <div class="todoLiConnMsg">');
        html.push("");
        html.push('</div> ');
        html.push('</div> ');
        html.push('<div class="todoLiConnR">');
        html.push('<div class="todoLiConnTit">');
        html.push('</div> ')
        html.push(' <div class="todoLiConnMsg">');
        html.push('</div>')
        html.push('</div>')
        html.push('</div>')
        html.push('</div>')
	}

    if( !$.isEmptyObject(dataMap) ) {
        initOrderNo(dataMap);
    }
	return html.join("");
}

//初始化单号
function initOrderNo(dataMap) {
	var list = [];
	for(var key in dataMap) {
		list.push(dataMap[key]);
	}
	
	$.ajax({
		url: web_ctx+'/manage/office/pendflow/getOrderNo',
		type: 'POST',
		dataType: 'JSON',
		contentType: 'application/json;charset=utf-8;',
		data: JSON.stringify(list),
		success: function(data) {
			if(data.code == 1) {
				$(data.result).each(function(index, obj) {
					if( !isNull(obj.PROCESS_INSTANCE_ID) && !isNull(obj.ORDER_NO) ) {
						$("#"+obj.PROCESS_INSTANCE_ID).text(obj.ORDER_NO);
					}
				});
			}
		}
	});
}

/*--------- 以下参数值必填 ---------*/
if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
    var params = {
        "leave": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/leave/mobileprocess" // 要跳转的处理页面
        },
        "travel": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/travel/mobileprocess"
        },
        "travelReimburse": {
            "processInstanceId": "",
            "page": "manage/finance/travelReimburs/mobileprocess"
        },
        "reimburse": {
            "processInstanceId": "",
            "page": "manage/finance/reimburs/mobileprocess"
        }
        ,
        "notice": {
            "processInstanceId": "",
            "page": "manage/office/notice/process"
        },
        "overtime": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/overtime/mobileprocess"
        },
        "seal": {
            "processInstanceId": "",
            "page": "manage/ad/seal/mobileprocess"
        },
        "bargin": {
            "processInstanceId": "",
            "page": "/manage/sale/barginManage/process"
        },
        "collection": {
            "processInstanceId": "",
            "page": "/manage/finance/collection/process"
        },
        "pay": {
            "processInstanceId": "",
            "page": "/manage/finance/pay/mobileprocess"
        },
        "salary": {
            "processInstanceId": "",
            "page": "/manage/ad/salary/process"
        },
        "entryApply": {
            "processInstanceId": "",
            "page": "/manage/ad/entry/apply/process"
        },
        "usercar": {
            "processInstanceId": "",
            "page": "/manage/ad/car/process"
        },
    };

}else {
    var params = {
        "leave": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/leave/process" // 要跳转的处理页面
        },
        "travel": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/travel/process"
        },
        "travelReimburse": {
            "processInstanceId": "",
            "page": "manage/finance/travelReimburs/process"
        },
        "reimburse": {
            "processInstanceId": "",
            "page": "manage/finance/reimburs/process"
        }
        ,
        "notice": {
            "processInstanceId": "",
            "page": "manage/office/notice/process"
        },
        "overtime": {
            "processInstanceId": "",
            "page": "manage/ad/chkatt/overtime/process"
        },
        "seal": {
            "processInstanceId": "",
            "page": "manage/ad/seal/process"
        },
        "bargin": {
            "processInstanceId": "",
            "page": "/manage/sale/barginManage/process"
        },
        "collection": {
            "processInstanceId": "",
            "page": "/manage/finance/collection/process"
        },
        "pay": {
            "processInstanceId": "",
            "page": "/manage/finance/pay/process"
        },
        "salary": {
            "processInstanceId": "",
            "page": "/manage/ad/salary/process"
        },
        "entryApply": {
            "processInstanceId": "",
            "page": "/manage/ad/entry/apply/process"
        },
        "usercar": {
            "processInstanceId": "",
            "page": "/manage/ad/car/process"
        },
    };
}


function gotoProcess(type, processInstanceId) {
	var param = params[type];
	param["processInstanceId"] = processInstanceId;
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function gotoKpi() {
	window.location.href =web_ctx+"/manage/ad/kpi/toList";
}

function getProcessId(){
	var idlist = [];
	$("input[type='checkbox']").each(function(index, checkbox){
		if($(checkbox).prop('checked') ==true){
			idlist.push($(checkbox).val());
		}
	});
	return idlist;
}

function checked(){
	$("input[type='checkbox']").each(function(index, checkbox){
		$(checkbox).prop("checked",true);
	});
	
	$("#check").hide();
	$("#uncheck").show();
	
}

function unchecked(){
	$("input[type='checkbox']").each(function(index, checkbox){
		$(checkbox).prop("checked",false);
	});
	
	$("#check").show();
	$("#uncheck").hide();
}

function approveall(){
	var idlist = [];
	idlist = getProcessId();
	for(i=0;i<idlist.length;i++){
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/office/pendflow/completeTask",    
        "data": {"processId": idlist[i]},
        "success": function(data) {
        	if(data.code == 1) {
        		openBootstrapShade(true);
        		window.parent.initTodo();
        		window.location.reload();
        	} else {
        		bootstrapAlert("提示", "审批错误！" + data.result, 400, null);
        	}
        },
        "error": function(data) {
        	openBootstrapShade(false);
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	}
	
}


