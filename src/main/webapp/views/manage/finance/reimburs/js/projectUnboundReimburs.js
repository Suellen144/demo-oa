var projectObj = null;
var investList = [];
$(function() {
	moneyCount();
	actReimburseCount();

	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
	
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	

	isEdit();
	

});

function isEdit(){
	
		$("tbody").find("input[type='button']").removeAttr('onclick');
		$("tbody").find("a").removeAttr('onclick');
	
}

function openProject(obj) {
	
	if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		
		if( tr.length > 0 && !isNull($(tr).find("textarea[name='projectName']").val()) ) {
			$(obj).siblings("input[name='projectId']").val( $(tr).find("input[name='projectId']").val() );
			$(obj).val( $(tr).find("textarea[name='projectName']").val() );
			return ;
		}
	}
	
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}


function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).next("input[name='projectId']").val(data.id);
		$(projectObj).val(data.name);
	}
}

//如果value后缀只有一个.0，则去掉.0
var suffixZero = /.*\.0$/;
function clearZero(value) {
	if(suffixZero.test(value)) {
		return value.replace(".0", "");
	} else {
		return value;
	}
}

function toUppercase(value) {
	$("#costcn").inputmask("Regex", { regex: ".*" });
	if(!isNull(value)) {		
		$("#costcn").val(digitUppercase(value));
		$("#cost").val(value);
	} else {
		$("#costcn").val("零元整");
		$("#cost").val("0");
	}
}

function toLowercase(obj) {
	$("#costcn").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	var value = $("#cost").val();
	$("#costcn").val(value);
	$(obj).trigger("select");
}

function actReimburseCount() {
	var count = 0;
	var total = 0;
	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		var value = "";
		if( !isNull(actReimburse) ) {
			value = actReimburse;
			total = digitTool.add(total, parseFloat(value));
		} else {
			value = $(tr).find("input[name='money']").val();
		}
		
		if(isNull(value)) {
			value = "0";
		}
		count = digitTool.add(count, parseFloat(value));
	});
	
	if(total == 0) {
		$("#actReimburseTotal").text("");
	} else {
		$("#actReimburseTotal").text(total);
	}
	toUppercase(count);
}

function moneyCount() {
	var total = 0;
	$("input[name='money']").each(function(index, input) {
		var value = $(input).val();
		if(isNull(value)) {
			value = "0";
		}
		total = digitTool.add(total, parseFloat(value));
	});
	
	if(total == 0) {
		$("#moneyTotal").val("");
	} else {
		$("#moneyTotal").val(total);
	}
}

function moneyBlur(obj) {
	var td = $(obj).parent("td");
	var actReimbruseObj = $(td).next("td").find("input[name='actReimburse']");
	if( isNull($(actReimbruseObj).val()) ) {
		var value = $(obj).val();
		$(actReimbruseObj).val(value);
	}
	$(actReimbruseObj).trigger("keyup");
}

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["reimburseAttachList"] = [];
	
	var reimburseId = $("form").find("input[name='id']").val();
	
	$("tbody").find("tr[name='node']").each(function(index, tr) {
		
		var projectId = $(this).find("input[name='projectId']").val();
		var attachId = $(this).find("input[name='attachId']").val();
		
		
		// 其中一个有值就算有效表单数据
		if( !isNull(projectId)
				|| !isNull(attachId) || !isNull(reimburseId)) {
			var data = {};
			
			data["projectId"] = projectId;
			data["id"] = attachId;
			data["reimburseId"] = reimburseId;
			
			formData["reimburseAttachList"].push(data);
		}
	});

	return formData;
}


/*save仅作表单保存*/
function save() {
	var formData = getFormJson();

	$.ajax({
		url: "unbound",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {

				backPageAndRefresh();
				
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

