$(function() {
	$("#userDialog").initUserDialog({
		"callBack": getData
	});
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept,
		"isCheck": true,
		"isGetChildren": true
	});
	
	var projectId = $("#id").val();
	initSelect();
	inittextarea();
	
});

//查看具体合同详情
function gotoSee(processId) {
        toProcess(processId);
}


function toProcess(processInstanceId){

    var param = {
        "processInstanceId": processInstanceId,
        "page": "manage/sale/barginManage/process"
    }

    window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}



/**
 * 初始化Select选择值
 * */
function initSelect() {

	var location = $("#location_rep").val();

	if(location != "") {
		$("#location").find("option").each(function(index, obj) {
			if(location == $(this).val()) {
				$(this).prop("selected", true);
				return ;
			}
		});
	}
}

var flag = "";
var obt = "";
function openDialog(num,obj) {
	if(num == "1"){
		flag ="project";
	}else {
		flag ="bargin";
		obt = obj;
	}
	$("#userDialog").openUserDialog();
}
function getData(data) {
	if(data != null && typeof data != "undefined") {
		if(flag == "project"){
			$("#userName").val(data.name);
			$("#userId").val(data.id);
		}else{
			
			$(obt).val(data.name);
			$(obt).next().val(data.id);
			var test = $("#barginUserId").val();
			
		}
	}
}


function removePrincipal() {
	$("#userId").val("");
	$("#userName").val("");
}


function openDept() {
	$("#deptDialog").openDeptDialog($("#deptIds").val());
}
function getDept(deptList) {
	if( !isNull(deptList)) {
		var idList = [];
		var nameList = [];
		$(deptList).each(function(index, dept) {
			idList.push(dept.id);
			nameList.push(dept.name);
		});
		
		$("#deptIds").val(idList.join(","));
		$("#deptName").val(nameList.join(","));
	}
}
function removeDept() {
	$("#deptIds").val("");
	$("#deptName").val("");
}

function save() {
	
	var formData = getFormData();
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	submitForm(formData);
}

/*function ajaxName(formData){
	var name = $.trim($("#name").val()) ;
	$.ajax({
		url: "ajaxName",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", data.result, 400, null);
				$("#name").val("");
			} else {
				isUsered(formData);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}*/

function submitForm(formData){
	$.ajax({
		url: "saveInfoOld",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function getFormData() {
	var formData = $("#form1").serializeJson();
	return formData;
}

function checkForm(formData) {
	var text = [];
	var  name = $("#name").val();
	var type = $("#type").val();
	if(isNull(name)) {
		text.push("请填写项目名称！");
		
	}else if(isNull(type)){
		text.push("请填写项目类型！");
		
	}
	return text;
}

function operation(status) {
	var tip ="";
	if(status == "1"){
		tip = "启动";
		
		
	}else if(status == "0"){
		tip = "关闭";
		
		
	}else if(status == "-1"){
		tip = "注销";
		 
	}
	
	var id = $("#id").val();
	bootstrapConfirm("提示", "是否确认"+tip+"？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "setStatus",    
	        "dataType": "json",   
	        "data": {"id":id,"status":status},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		
	        		var test = typeof data.result;
	        		if((typeof data.result)=="string"){
	        			backPageAndRefresh();
	        		}else{
	        			bootstrapAlert("提示", "该项目有关联报销单，请点击确定，修改与之关联的报销单！", 400, function() {
	        				window.location.href =web_ctx + "/manage/sale/projectManage/cancel?id="+data.result;
						});
	        		}
	        		
	        	} else {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}

function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

function remove() {
	var id = $("#id").val();
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id":id},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		backPageAndRefresh();
	        	} else {
	        		bootstrapAlert("提示", "删除出错", 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
	
}