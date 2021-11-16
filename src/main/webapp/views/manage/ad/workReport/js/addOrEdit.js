var currTd = null;

$(function() {
	$("#projectDialog").initProjectDialog({
		"callBack": getData
	});
	
	$("tr[name='node']").each(function() {
		regUpdateEvent(this);
	});
	
	initDatetimepicker();
	initInputMask();
	initCkeditor();
	inittextarea();
});


/*******************
 * 	表单相关函数
 * ****************/
function save() {
	bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		var formData = getFormJson();
		if(!checkForm(formData)) {
			return ;
		}

		if(!checkNumber()) {
			return ;
		}
	/*	if (checkdate()) {
			bootstrapAlert("提示", "日期重复，请重新选择！", 400, null);
			return ;
		}*/

		$.ajax({
			url: "saveOrUpdate",
			type: "post",
			contentType: "application/json",
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
	})
}

function checkForm(formData) {
	var text = [];
	var checkFlag = {
		"projectId": false,
		"workTime": false,
		"description": false
	};
	
	if(isNull(formData["workReportAttachList"])) {
		text.push("至少有一条工作汇报条目！");
	}
	$(formData["workReportAttachList"]).each(function(index, attach) {
		if(isNull(attach["projectId"]) && !checkFlag["projectId"]) {
			checkFlag["projectId"] = true;
			text.push("项目不能为空！");
		}
		if(isNull(attach["workTime"]) && !checkFlag["workTime"]) {
			checkFlag["workTime"] = true;
			text.push("工时不能为空！");
		}
		if(isNull(attach["description"]) && !checkFlag["description"]) {
			checkFlag["description"] = true;
			text.push("工作内容不能为空！");
		}
	});

	if(text.length > 0) {
		bootstrapAlert("提示", text.join("<br/>"), 400, null);
		return false;
	} else {
		return true;
	}
}


function getFormJson() {
	var json = {
		"id": $("#id").val(),
		"month": $("#month").val(),
		"number": $("#number").val(),
		"monthSummary": CKEDITOR.instances.monthSummary.getData(),
		"monthPlan": CKEDITOR.instances.monthPlan.getData(),
		"weekPlan": CKEDITOR.instances.weekPlan.getData(),
		"workReportAttachList": []
	};
	$("tr[name='node']").each(function(index, tr) {
		var attach = {};
		
		attach["id"] = $(tr).find("input[name='workReportAttachId']").val();
		attach["projectId"] = $(tr).find("input[name='projectId']").val();
		attach["workDate"] = $(tr).find("input[name='workDate']").val();
		attach["workTime"] = $(tr).find("input[name='workTime']").val();
		attach["description"] = $(tr).find("textarea[name='description']").val();
		if($(tr).find("input[name='isUpdate']").val() == "y") {
			attach["updateDate"] = new Date().pattern("yyyy-MM-dd HH:mm:ss");
		}
		
		json["workReportAttachList"].push(attach);
	});
	
	return json;
}

function checkNumber() {
	var result = true;
	var params = {
		"id": $("#id").val(),
		"userId": $("#userId").val(),
		"month": $("#month").val(),
		"number": $("#number").val(),
		"workDate":$("#workDate1").val()
	};
	$.ajax({
		url: "checkNumber",
		type: "post",
		data: params,
		dataType: "json",
		async: false,
		success: function(data) {
			if(data.code != 1) {
				bootstrapAlert("提示", data.result, 400, null);
				result = false;
			}
		},
		error: function(data) {
			result = false;
		}
	});
	
	return result;
}


//判断日期是否重复
function isRepeat(arr){  
    var hash = {};  
    for(var i in arr) {  
        if(hash[arr[i]])  
             return true;  
        	hash[arr[i]] = true;  
    }  
    return false;  
}  


function checkdate(){
	var datelist = [];
	$("tr[name='node']").each(function(index, tr) {
		var date = $(tr).find("input[name='workDate']").val()
		datelist.push(date);
	});
	return isRepeat(datelist);
	
}










/*******************
 * 	普通操作相关函数
 * ****************/
function openDialog(obj) {
	$("#projectDialog").openProjectDialog();
	currTd = obj;
}

function getData(data) {
	if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
		$(currTd).find("input[name='projectName']").val(data.name);
		$(currTd).find("input[name='projectId']").val(data.id);
		$(currTd).find("input[name='projectName']").trigger("change");
	}
}

function addRow() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<input type="hidden" name="workReportAttachId" value="">');
	html.push('<input type="hidden" name="isUpdate" value="">');
	html.push('<td><input name="workDate" class="workDate" readonly value="'+new Date().pattern("yyyy-MM-dd")+'"></td>');
	html.push('<td onclick="openDialog(this)"><input name="projectName" readonly><input type="hidden" name="projectId"></td>');
	html.push('<td><input name="workTime" value="7.5" onclick="this.select();"></td>');
	html.push('<td style="height:auto;"><textarea id="description" class="input_textarea" style="width:100%;height:20px;resize:none;border:none;overflow:visible;outline:transparent;" name="description"></textarea></td>');
	html.push('<td style="background-color:#f7f7f7;"><input value="" style="background-color:#f7f7f7;" readonly></td>');
	html.push('<td><a style="cursor:pointer;" onclick="delRow(this)">删除</a></td>');
	html.push('</tr>');

	$(".table-bordered").children("tbody").append(html.join(''));
	regUpdateEvent($(".table-bordered").children("tbody").find("tr[name='node']:last"));
	initDatetimepicker();
	initInputMask();
	inittextarea();
}

function delRow(obj) {
	var table = $(".table-bordered");
	var tr = $(obj).parents("tr");
	$(tr, table).remove();
}

function regUpdateEvent(tr) {
	$(tr).find("input[name='workDate'],input[name='projectName'],input[name='workTime'],textarea[name='description']")
		.bind("change", function() {
		if( !isNull($(this).parent().siblings("input[name='workReportAttachId']").val()) ) {
			$(this).parent().siblings("input[name='isUpdate']").val("y");
		}
	});
	
	$(tr).find($(".input_textarea").bind("change",function(){
		  $(this).parent().siblings("input[name='isUpdate']").val("y");
	  }));
}






/*******************
 * 	初始化相关函数
 * ****************/
function initDatetimepicker() {
	$(".workDate").datetimepicker({
		language:"zh-CN",
		format: "yyyy-mm-dd",
        showMeridian: true,
        autoclose: true,
        todayBtn: true,
        bootcssVer:3,
        startView: "month", 
        minView: "month"
    });
}

function initCkeditor() {
	CKEDITOR.replace("weekPlan", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
	
	CKEDITOR.replace("monthSummary", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
	CKEDITOR.replace("monthPlan", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
}

function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}




function initInputMask() {
	$("input[name='workTime']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
}