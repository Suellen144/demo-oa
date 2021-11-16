$(function() {
	var id = $("#id").val();
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/office/pendflow/getPendflowList",    
        "dataType": "json",
        "success": function(data) {
        	if(data.code == 1) {
        		var html = buildHtml(data.result);
        		$("#dataTable").find("tbody").html(html);
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
		/*if($("#userId").val()=='225'){
			var count = 0;
			$(list).each(function(index, json) {
				if((json.processName == "通用报销流程" ||  json.processName == "出差报销流程"  || json.processName == "请假流程"  || json.processName == "外勤流程"
					|| json.processName == "合同流程") && json.business.assistantStatus != '1'){
					count = count +1;
					html.push('<tr>');
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(json.processName);
					html.push('</td>')
					
					html.push('<td id='+json.processInstanceId+'  onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(json.initiator.name);
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(new Date(json.task.createTime).pattern("yyyy-MM-dd HH:mm"));
					html.push('</td>')
					
					html.push('</tr>');
					
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
				}
			});
			if(count == 0){
				html.push('<tr><td colspan="20" style="text-align:center;">无待办流程</td></tr>');
			}
		}else{*/
			/*var kpi = initKpi();*/
			if(kpi == "" && approve){
				html.push('<tr>');
				html.push('<td colspan="20" onclick="gotoKpi()" style="cursor:pointer;">');
				html.push("绩效考核");
				html.push('</td>')
				html.push('</tr>');
			}
			if((kpi == "" || kpi == '3') && userid == 2){
				html.push('<tr>');
				html.push('<td colspan="20" onclick="gotoKpi()" style="cursor:pointer;">');
				html.push("绩效考核");
				html.push('</td>')
				html.push('</tr>');
			}
			
			$(list).each(function(index, json) {
				html.push('<tr>');
				html.push('<tr>');
				if((json.processName == "通用报销流程" ||  json.processName == "出差报销流程") && flag == "true" && json.task.name == "出纳"){
				$("#checkall").show();
				html.push('<td>');
				html.push('<input type="checkbox"  onclick="getProcessId()" value='+json.processInstanceId+'>');
				html.push('</td>')
				}
				else if((json.processName != "通用报销流程" &&  json.processName != "出差报销流程" ) && flag == "true" && json.task.name == "出纳"){
					html.push('<td>');
					html.push('出纳环节');
					html.push('</td>')
				}
				else if ((json.processName != "通用报销流程" &&  json.processName != "出差报销流程" ) && flag == "true" && json.task.name != "出纳"){
					html.push('<td>');
					html.push('行政经理环节');
					html.push('</td>')
				}
				else if ((json.processName == "通用报销流程" ||  json.processName == "出差报销流程") && flag == "true" && json.task.name != "出纳"){
					html.push('<td>');
					html.push('行政经理环节');
					html.push('</td>')
				}
				if(json.validationJump !=null && json.validationJump !=undefined && json.validationJump.length>0){
					html.push('<td onclick="gotoProcess(\'' +json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\','+json.validationJump[0].isNewProcess+');" style="cursor:pointer;">');
					html.push(json.processName);
					html.push('</td>')
					
					html.push('<td id='+json.processInstanceId+'  onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\','+json.validationJump[0].isNewProcess+');" style="cursor:pointer;">');
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\','+json.validationJump[0].isNewProcess+'\','+json.validationJump[0].isNewProcess+');" style="cursor:pointer;">');
					html.push(json.initiator.name);
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\','+json.validationJump[0].isNewProcess+'\','+json.validationJump[0].isNewProcess+');" style="cursor:pointer;">');
					html.push(new Date(json.task.createTime).pattern("yyyy-MM-dd HH:mm"));
					html.push('</td>')
					/*if($("#userId").val() == '27' && (json.processName == "通用报销流程" ||  json.processName == "出差报销流程")){
						if(json.business.assistantStatus == '1'){
							html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\');" style="cursor:pointer;">');
							html.push('已确认');
							html.push('</td>')
						}else{
							html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\');" style="cursor:pointer;">');
							html.push('未确认');
							html.push('</td>')
						}
					}else if($("#userId").val() == '27'){
						html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+', \''+json.validationJump[0].module+'\','+json.validationJump[0].isNewProject+', \''+json.validationJump[0].type+'\');" style="cursor:pointer;">');
						html.push(' ');
						html.push('</td>')
					}*/
				}else{
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(json.processName);
					html.push('</td>')
					
					html.push('<td id='+json.processInstanceId+'  onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(json.initiator.name);
					html.push('</td>')
					
					html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
					html.push(new Date(json.task.createTime).pattern("yyyy-MM-dd HH:mm"));
					html.push('</td>')
					/*if($("#userId").val() == '27' && (json.processName == "通用报销流程" ||  json.processName == "出差报销流程")){
						if(json.business.assistantStatus == '1'){
							html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
							html.push('已确认');
							html.push('</td>')
						}else{
							html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
							html.push('未确认');
							html.push('</td>')
						}
					}else if($("#userId").val() == '27'){
						html.push('<td onclick="gotoProcess(\''+json.processKey+'\', '+json.processInstanceId+');" style="cursor:pointer;">');
						html.push(' ');
						html.push('</td>')
					}*/
				}
				html.push('</tr>');
				
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
			});
		//}
	} else {
		var kpi = initKpi();
		if(kpi == "" && approve){
			html.push('<tr>');
			html.push('<td colspan="20" onclick="gotoKpi()" style="cursor:pointer;">');
			html.push("绩效考核");
			html.push('</td>')
			html.push('</tr>');
		}
		else if((kpi == "" || kpi == '3') && userid == 2){
			html.push('<tr>');
			html.push('<td colspan="20" onclick="gotoKpi()" style="cursor:pointer;">');
			html.push("绩效考核");
			html.push('</td>')
			html.push('</tr>');
		}
		else {
			html.push('<tr><td colspan="20" style="text-align:center;">无待办流程</td></tr>');
		}
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
    "project": {
        "processInstanceId": "",
        "page": "/manage/sale/projectManageNew/process"
    },
    "projectModify": {
        "processInstanceId": "",
        "page": "/manage/sale/projectManageNew/processModify"
    },
    "invoiced": {
        "processInstanceId": "",
        "page": "/manage/finance/collection/processInvoice"
    },
};

function gotoProcess(type, processInstanceId,module,isNewProject,type1,isNewProcess) {
	var param = params[type];
	param["processInstanceId"] = processInstanceId;
	if(type == 'bargin' || type == 'collection' ||  type == 'pay'){
			if(module == 'bargin' && isNewProject == 1){
				if(type1 == 'S'){
					param["page"]="/manage/sale/barginManage/processMarketNew";
				}else if(type1 == 'B'){
					param["page"]="/manage/sale/barginManage/processMarketProcurement";
				}else if(type1 == 'C'){
					param["page"]="/manage/sale/barginManage/processMarketAgreement";
				}
			}else if(module == 'collection' && isNewProject == 1){
				if(isNewProcess == 1) {
					param["page"]="/manage/finance/collection/processNew";
				}else {
					param["page"]="/manage/finance/collection/processNew_bak";	
				}
			}
	}
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


