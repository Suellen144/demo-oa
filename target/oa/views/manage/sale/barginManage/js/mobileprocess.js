/******************************
 * 		全局变量			  	  *
 ******************************/
var fileData = null;
var oper2Method = { // 按钮操作与其对应的调用函数
	"提交": save,
	"同意": agree,
	"确认": agree,
	"不同意": disagree,
	"重新申请": reApply,
	"取消申请": cancelApply,
};


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意  10:会计不同意 12：财务总监审批 13：财务总监不同意  14：项目负责人审批 15：项目负责人不同意
 * */
//同意后的下一状态
var approvedStatus = {
		"0": "14",
		"1": "3",
		//"2": "12",
		"3": "4",
		"4": "5",
		"12": "3",
		"14": "1"
};
// 不同意后的下一状态
var notApprovedStatus = {
		"0": "6",
		"1": "7",
		//"2": "8",
		"3": "9",
		"4": "10",
		"12": "13",
		"14":"15"
};
// 环节与状态的映射
var nodeOnStatus = {
		"0": "提交申请",
		"1": "部门经理",
		//"2": "财务",
		"3": "总经理",
		"4": "出纳",
		"5": "已归档",
		"6": "取消申请",
		"7": "提交申请",
		"8": "提交申请",
		"9": "提交申请",
		"10": "提交申请",
		"12": "财务总监",
		"13": "提交申请",
		"14":"项目负责人",
		"15":"提交申请"
};
// 环节与操作结果的映射
var nodeOnOper = {
		"提交": "提交成功",
		"重新申请": "申请成功",
		"同意": "通过",
		"确认": "确认",
		"不同意": "不通过",
		"取消申请": "取消申请",
};

$(function() {
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	
	inittextarea();
	initTaskComment();
	initFileUpload();
	initInputMask();
	initDatetimepicker();
	
	if($("#currStatus").val() != null && $("#currStatus").val() != ""  && $("#currStatus").val() == "5"){
		findPayInfo();
        findCollectionInfo();
	}
	
});
var barginManageId = $("#id").val();
function findPayInfo(){
	var status = "5";
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/finance/pay/findPayInfo",//查找与合同关联的已审批完的付款信息
        "dataType": "json",
        "data": {
        	"barginManageId": barginManageId,
			"status": status},
        "success": function(data) {
        	if(data.code == 1) {
				if(data.result != null && data.result != "" && data.result.length >0 ){
					var html = [];

					//插入表头
					html.push('<ul class="mForm">');
				   //计算已收发票金额
					var actualPayTotalMoney = 0;
					var index=0
					for (var i in data.result) {
						var payType = '';
						if(data.result[i].payType == '1'){
							 payType = '货款';
						}else if(data.result[i].payType == '0'){
							payType = '预付款';
						}

						var actualPayMoney = data.result[i].actualPayMoney.toFixed(2);
						var invoiceMoney = data.result[i].invoiceMoney.toFixed(2);

						actualPayTotalMoney = digitTool.add(actualPayTotalMoney,actualPayMoney).toFixed(2);
						html.push('<li class="clearfix parentli" name="node">');
						html.push('<div class="col-xs-12">');
						html.push('<div class="mFormName">付款详情</div>');
						html.push('<div class="mFormMsg firstMsg">');
						html.push('<div class="mFormShow secondMsg" style="height:40px" onclick="changeImage(this)"');
						html.push('href="#intercityCost'+index+'" data-toggle="collapse"');
						html.push('data-parent="#accordion">');
						html.push('<div class="mFormArr current">');
						html.push('<img src="'+base+'/static/images/arr.png" alt="">');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormToggle panel-collapse collapse thirdMsg"');
						html.push('id="intercityCost'+index+'">');
						html.push('<div class="mFormToggleConn">');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">付款类型</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text"  class="longInput" value="'+payType+'" readonly>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">收款单位</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text"  class="longInput" value="'+data.result[i].collectCompany+'">');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormToggleConn">');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">发票金额</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text" class="longInput" value="'+invoiceMoney+'" readonly>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">实际付款金额</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text" class="longInput" value="'+actualPayMoney+'">');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</li>');
						index++;
					}
					html.push('</ul>');
					$("#pay").append(html.join(""));
					var tr = $(".totalMoney").parents(".mFormXSToggleConn").next();
					$(tr).find('input').val(actualPayTotalMoney);
					$("#showOrHidden").css('display','none');
					$("#showOrhidden").css('display','block');
			}
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	
}

/**
 * 把毫秒级时间转换成字符串
 * 格式：yyyy年MM月dd日
 * @param date
 * @returns {string}
 */
function dateFormat(date) {
    var dateStr = new Date(date);
    // 重写toString方法
    Date.prototype.toLocaleString = function() {
        return this.getFullYear() + "年" + (this.getMonth() + 1) + "月" + this.getDate() + "日";
    };
    return dateStr.toLocaleString();
}


/**
 * 查询合同相关的收款详情
 * @type {*}
 */
var barginId = $("#id").val();
function findCollectionInfo() {
	var status = "5";
	$.ajax({
		"type":"Post",
		"url":web_ctx+"/manage/finance/collection/findCollectionInfo",
		"dataType":"JSON",
		"data":{
			"barginId":barginId,
			"status":status
		},
		success:function (data) {
			if(data.code == 1){
				if(data.result !=null && data.result!="" && data.result.length>0){
                    var html = [];
                    var id = [];
                    
                	html.push('<ul class="mForm">');
                	var index=0;
                    $.each(data.result,function (n,v) {
                    	id = data.result[n].processInstanceId;
                      /*  html.push('<tr><td>'+dateFormat(data.result[n].billDate)+'</td><td>'+data.result[n].payCompany+'</td><td style="text-align: center";>'
							+data.result[n].bill +'</td><td>'+data.result[n].applyProportion
							+'</td><td><input type="button"  name="detail" class="btn btn-primary" style="text-align: center"  value="查看收款明细" onclick="getCollection('+id+')" ></td></tr>');*/
                        html.push('<li class="clearfix parentli" name="node">');
						html.push('<div class="col-xs-12">');
						html.push('<div class="mFormName">收款详情</div>');
						html.push('<div class="mFormMsg firstMsg">');
						html.push('<div class="mFormShow secondMsg" style="height:40px" onclick="changeImage(this)"');
						html.push('href="#intercityCostI'+index+'" data-toggle="collapse"');
						html.push('data-parent="#accordion">');
						html.push('<div class="mFormArr current">');
						html.push('<img src="'+base+'/static/images/arr.png" alt="">');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormSeconMsg mFormOpe">');
						html.push('<input type="button" id="viewBarginBtn" value="查看收款明细"');
						html.push('onclick="getCollection('+id+')" style="border: none;">');
						html.push('</div>');
						html.push('<div class="mFormToggle panel-collapse collapse thirdMsg"');
						html.push('id="intercityCostI'+index+'">');
						html.push('<div class="mFormToggleConn">');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">开票日期</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text"  class="longInput" value="'+dateFormat(data.result[n].billDate)+'" readonly>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">付款单位</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text"  class="longInput" value="'+data.result[n].payCompany+'">');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormToggleConn">');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">开票金额</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text" class="longInput" value="'+data.result[n].bill+'" readonly>');
						html.push('</div>');
						html.push('</div>');
						html.push('<div class="mFormXSToggleConn">');
						html.push('<div class="mFormXSName">申请比例</div>');
						html.push('<div class="mFormXSMsg">');
						html.push('<input type="text" class="longInput" value="'+data.result[n].applyProportion+'">');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</div>');
						html.push('</li>');
						index++;
                    })
                    html.push('</ul>');
                    $("#collection").append(html.join(""));
				}
			}
        },
		error:function (data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	});
}

//点击收款详情弹出模态框
function getCollection(processInstanceId) {
	var param = {
		"processInstanceId":processInstanceId,
		"page":"manage/finance/collection/process"
	}
	var url = web_ctx + "/activiti/process?" + urlEncode(param);
	$("#collectionFrame").attr("src",url);
	$("#collectionModal").modal("show");
}

function approve(status) {
	$("#operStatus").val(status);
	oper2Method[status].call();
}

function agree() {
	var currUserId =$("#currUserId").val();
	var userId =$("#userId").val();
	if(currUserId == userId){
		save();
	}else{
		submitProcess();
	}
}

function disagree() {
	submitProcess();
}

function reApply() {
	save();
}

function cancelApply() {
	cancelProcess();
}

function invalid(){
	var result = setStatus('11')//作废合同
	if(result.code == 1) {
		backPageAndRefresh();
	}
}

//获取项目名称
var projectObj = "";
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}


function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$("#projectManageId").val(data.id);
		$(projectObj).val(data.name);
	}
}

/******************************
 * 		表单处理相关函数		  	  *
 ******************************/
function save() {
	var formData = $("#form1").serializeJson();
	var issubmit = $("#issubmit").val("0");//区分保存和提交
	
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/findByBarginName",//合同名称不能重复
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data:  JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#barginName").val("");
				bootstrapAlert("提示", data.result, 400, null);
			}else{
				openBootstrapShade(true);
				if(fileData != null) {
					fileData.submit();
				} else {
					submitForm(formData);
				}
				openBootstrapShade(false);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
}

function submitForm(formData) {
	$.ajax({
		url: web_ctx + "/manage/sale/barginManage/saveInfo",
		type: "post",
		data: JSON.stringify(formData),
		dataType: "json",
		contentType: "application/json",
		success: function(data) {
			if(data.code == 1) {
				var currUserId =$("#currUserId").val();
				var userId =$("#userId").val();
				var oper = $("#operStatus").val();
				if(oper == "重新申请" || (currUserId == userId  && oper == '同意')) {
					submitProcess();
				} else {	
						backPageAndRefresh();
				}
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		},
		complete: function(data) {
			openBootstrapShade(false);
		}
	});
}

function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  barginName = $.trim($("#barginName").val());
	var barginType = $("#barginType").val();
	
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	
	
	if(isNull(barginName)) {
		text.push("请填写合同名称！");
		
	}else if(isNull(barginType)){
	
		text.push("请填写合同类型！");
	
	}
	
	if(!isNull(startTime) && !isNull(endTime) && startTime >= endTime) {
		text.push("合同期限开始时间不能大于或等于结束时间！<br/>");
	}

	return text;
}

function submitProcess() {
	var variables = getVariables();
	var taskId = $("#taskId").val();
	var compResult = completeTask(taskId, variables);
	
	if(compResult.code == 1) {
		var status = getNextStatus();
		var statusResult = setStatus(status);
		if(statusResult.code == 1) {
			var text = "操作成功！";
    		if($("#operStatus").val() == "提交") {
    			text = "提交成功 ！";
    		} else if($("#operStatus").val() == "重新申请") {
    			text = "重新申请成功 ！";
    		} else if($("#operStatus").val() == "取消申请") {
    			text = "取消申请成功 ！";
    		}
    		
    		window.parent.initTodo();
    		backPageAndRefresh();

    	} else {
    		bootstrapAlert("提示", statusResult.result, 400, null);
    	}
	} else if(compResult.code == 0) {
		bootstrapAlert("提示", compResult.result.statusText, 400, null);
	} else {
		bootstrapAlert("提示", compResult.result.toString(), 400, null);
	}
	validate();
	openBootstrapShade(false);
}

//取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		var id = $("#id").val();
		var taskId = $("#taskId").val();
		var variables = getVariables();

		var result = endProcessInstance(taskId, variables);
		if(result != null) {
			if(result.code == 1) {
				var statusResult = setStatus("6");
				var delResult=del();
				if(statusResult.code == 1 && delResult.code==1) {
						window.parent.initTodo();
						backPageAndRefresh();
				/*	});*/
				} else {
					bootstrapAlert("提示", statusResult.result, 400, null);
				}
			} else {
				bootstrapAlert("提示", result.result, 400, null);
			}
		}
	}, null);
}


//取消流程的同时，删除该合同数据
function del() {
	var formData = getFormData();
	var result = {};
		$.ajax( {   
	        "type": "POST",    
	        "url": web_ctx + "/manage/sale/barginManage/delete",    
	        "dataType": "json",
	        "async": false,
	        "contentType": "application/json;charset=UTF-8",
	        "data": JSON.stringify(formData),
	        "success": function(data) {   
	        	result = data;
	        },
	        "error": function(data) {
	        	result.code = -1;
	        	result.result = "网络错误，请稍后重试！";
	        }
	    });
		return result;
}


/*
 * 审批状态
 * 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意  10：出纳不同意
 * */
function getNextStatus() {
	var status = null;
	var currStatus = $("#currStatus").val();
	var barginType = $("#barginType").val();
	if($("#operStatus").val() == "同意") {
		if(currStatus == "1") {
			if(!isNull(barginType) && ( barginType == "B"||  barginType == "S")) {
				status = approvedStatus[currStatus];
			} else {
				status = "3";
			}
		} else {
			status = approvedStatus[currStatus];
		}
	} else if($("#operStatus").val() == "不同意") {
		status = notApprovedStatus[currStatus];
	}else {
		status = "14";
	}
	
	return status;
}

function setStatus(status) {
	var id = $("#id").val();
	var result = {};
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/sale/barginManage/setStatus",    
        "dataType": "json",
        "async": false,
        "data": {"id": id, "status": status},
        "success": function(data) {
        	result = data;
        },
        "error": function(data) {
        	result.code = -1;
        	result.result = "网络错误，请稍后重试！";
        }
	} );
	
	return result;
}


function getVariables() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	
	var operStatus = $("#operStatus").val(); 
	var form = {
			"node": getNodeInfo(),
			"approver": $("#approver").val(),
			"comment": operStatus != "提交" ? $("#comment").val() : "",
			"approveResult": "",
			"approveDate": new Date().pattern("yyyy-MM-dd HH:mm")
	};
	
	if($("#isHandler").val() && $("#taskName").val() == '出纳' && operStatus == "同意" ){
		form["approveResult"] = "确认";
	}else if($("#isHandler").val() && $("#taskName").val() == '出纳' && operStatus == "不同意" ){
		form["approveResult"] = "退回";
	}else{
		form["approveResult"] = nodeOnOper[operStatus]; 
	}
	
	commentList.push(form);
	
	variables["commentList"] = commentList; // 批注列表
	variables["approved"] = 
		operStatus == "同意" || operStatus == "重新申请" || operStatus == "提交" || operStatus == "结束流程" ? true : false;
	
	var barginType = $("#barginType").val();
	if(!isNull(barginType) && (barginType == 'L' || barginType == 'C' || barginType == 'M')){
		variables["toCeo"] = true;
	} else {
		variables["toCeo"] = false;
	}
	
	return variables;
}

/**
 * 获取流程节点
 */
function getNodeInfo() {
	var currStatus = $("#currStatus").val();
	if(isNull(currStatus) || $("#operStatus").val() == "重新申请" || $("#operStatus").val() == "取消申请") {
		currStatus = "0";
	}
	
	return nodeOnStatus[currStatus];
}


//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "bargin/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
		"deleteFile": $("#attachments").val()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
        	maxFileSize: '附件大小最大为50M！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		fileData = data;
            	$("#showName").val(data.files[0].name);
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
        		// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
    			$("#file").fileupload("option", "formData", urlParam);
        		$("#showName").val(result.originName);
        		$("#attachments").val(result.path);
        		$("#attachName").val(result.originName);
        		
        		var formData = getFormData();
        		submitForm(formData);
        		
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}


//删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url: web_ctx+"/manage/sale/barginManage/deleteAttach",
				data: {"path":$("#attachments").val(), "id":$("#id").val()},
				type: "post",
				dataType: "json",
				success: function(data) {
					if(data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
	        			});
					}
					else{
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
			    error: function(data) {
			        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			       }
				
			});
		}, null);
	}
	else{
		bootstrapAlert("提示", "附件未保存，提交保存后方可删除附件！", 400, null);
	}
}



/*
 * 初始化相关操作
 */
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}
	for(var i=commentList.length-1;i>=0;i--){
		var html = [];
		html.push("<li class='clearfix'>");
		html.push("<div class='col-xs-12'>");
        html.push("<div class='mFormMsg'>");
		html.push("<div class='mFormToggle'>")
        html.push("<div class='mFormToggleConn'>")
        html.push("<div class='mFormXSToggleConn'>")
		html.push("<div class='mFormXSName'>环节</div>")
		html.push("<div class='mFormXSMsg'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].node+"' disabled>")
		html.push("</div>")
		html.push("</div>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName'>操作人</div>")
        html.push("<div class='mFormXSMsg'>")
        if(commentList[i].approver == "徐卓"){
			if(i == 1){
                html.push("<input type='text' class='longInput' value='陈琦' disabled>")
			}
			else{
                html.push("<input type='text' class='longInput' value='徐卓' disabled>")
			}
		}
		else{
			  html.push("<input type='text' class='longInput' value='"+commentList[i].approver+"' disabled>")
		}
        html.push("</div>");
		html.push("</div>");
		html.push("</div>")
        html.push("<div class='mFormToggleConn'>")
        html.push("<div class='mFormXSToggleConn'>")
        html.push("<div class='mFormXSName'>操作时间</div>")
        html.push("<div class='mFormXSMsg'>")
        var approveDate = commentList[i].approveDate + "";
        if( !dateRep.test(approveDate) ) {
            approveDate = new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm");
            html.push("<input type='text' class='longInput' value='"+approveDate+"' disabled>")
        }else{
            approveDate = new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm")
            html.push("<input type='text' class='longInput' value='"+approveDate+"' disabled>")
        }
        html.push("</div>")
        html.push("</div>")
        html.push("<div class='mFormXSToggleConn'>")
		html.push("<div class='mFormXSName'>操作结果</div>")
        html.push("<div class='mFormXSMsg'>")
        html.push("<input type='text' class='longInput' value='"+commentList[i].approveResult+"' disabled>")
        html.push("</div>");
        html.push("</div>");
        html.push("</div>");
        html.push("<div class='mFormToggleConn'>");
        html.push("<div class='mFormXSToggleConn'>");
        html.push("<div class='mFormXSName'>操作备注</div>");
        html.push("<div class='mFormXSMsg'>");
        html.push("<input type='text' class='longInput' value='"+commentList[i].comment+"' disabled>");
        html.push("</div>");
        html.push("</div>");
        html.push("</div>");
		html.push("</div>");
        html.push("</div>");
        html.push("</div>");
		html.push("</li>")
		$("#mForm").append(html.join(""));
		}
}




function initDatetimepicker() {
	
	$("input[name='startTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("input[name='endTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}


//初始化金额，两位数
function initInputMask() {
	
		$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#receivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		$("#unreceivedMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
}

//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

function changeImage(obj){
	$(obj).find(".mFormArr").toggleClass("current")
}


