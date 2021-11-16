var currTd = null;
$(function() {
	initDatetimepicker();
	initInputMask();
});



//初始化输入框约束
function initInputMask() {
	$("input[name='numberDays']").inputmask("Regex", { regex: "\\d+" });
}

function initDatetimepicker() {
	$(".startDate, .endDate, .beforeLeave, .afterLeave,.legal").datetimepicker({
		language:"zh-CN",
		format: "yyyy-mm-dd",
        showMeridian: true,
        autoclose: true,
        startView:2,
        minView: 2,
        bootcssVer:3
    })
	
	$(".dateBelongs").datetimepicker({
		language:"zh-CN",
		format: "yyyy-mm",
        showMeridian: true,
        autoclose: true,
        startView:3,
        minView: 3,
        bootcssVer:3
    });
	
}

function checkForm(formData) {
	var text = [];
	$(formData).each(function(index,formData){
		 if(formData.startDate.length>=1){
			if(formData.name[0] == "" ||formData.dateBelongs[0] == "" || formData.startDate[0] == "" ||formData.endDate[0] == "" ||formData.numberDays[0] == "") {
				text.push("必须至少假日一条数据！且需填写完整！<br/>");
				return false;
			}
			for(var i=0;i<formData.startDate.length;i++){
				if(formData.name[i] == "" && formData.dateBelongs[i] == "" && formData.startDate[i] == "" && formData.endDate[i] == "" && formData.legal[i] == "" && formData.numberDays[i] == "") {
					return false;
				}
				else if(formData.name[i] == "" || formData.dateBelongs[i] == "" || formData.startDate[i] == "" || formData.endDate[i] == "" || formData.legal[i] == "" || formData.numberDays[i] == ""){
					text.push("非空白行必须填写完整！<br/>");
					return false;
				}else{
					if(!checkDate(formData.startDate[i],formData.endDate[i])){
						text.push("开始时间必须小于于结束时间！<br/>");
						return false;
					}
				}
			}
		}
	});
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

//新增删除外勤表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		$(obj).attr("onclick", "node('del', this)");
		$(obj).html('<img alt="删除" src="'+base+'/static/images/del.png">');
		initDatetimepicker();
	}
}


function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td colspan="1"><input type="text" name="name" size="18" ></td>');
	html.push('<td colspan="1"><input type="text" name="dateBelongs"  class="dateBelongs"  size="18" readonly ></td>');
	html.push('<td colspan="1"><input type="text" name="startDate" class="startDate" size="18" readonly></td>');
	html.push('<td colspan="1"><input type="text" name="endDate"  class="endDate"  size="18" readonly ></td>');
	html.push('<td colspan="1"><input type="text" name="legal"  class="legal"  size="18" readonly ></td>');
	html.push('<td colspan="1"><input type="text" name="numberDays" class="input"  value = ""></td>');
	html.push('<td colspan="1"><input type="text" name="beforeLeave"  class="beforeLeave"  size="18" readonly ></td>');
	html.push('<td colspan="1"><input type="text" name="afterLeave"  class="afterLeave" size="18" readonly></td>');
	html.push('<td colspan="2">');
	html.push('<a href="javascript:void(0);" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	
	formData["name"] = [];
	formData["dateBelongs"] = [];
	formData["startDate"] = [];
	formData["endDate"] = [];
	formData["legal"] = [];
	formData["numberDays"] = [];
	formData["beforeLeave"] = [];
	formData["afterLeave"] = [];
	
	
	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var name = $(this).find("input[name='name']").val();
		var dateBelongs = $(this).find("input[name='dateBelongs']").val();
		var startDate = $(this).find("input[name='startDate']").val();
		var endDate = $(this).find("input[name='endDate']").val();
		var legal = $(this).find("input[name='legal']").val();
		var numberDays = $(this).find("input[name='numberDays']").val();
		var beforeLeave = $(this).find("input[name='beforeLeave']").val();
		var afterLeave = $(this).find("input[name='afterLeave']").val();
			formData["name"].push(name);
			formData["dateBelongs"].push(dateBelongs);
			formData["startDate"].push(startDate);
			formData["endDate"].push(endDate);
			formData["legal"].push(legal);
			formData["numberDays"].push(numberDays);
			formData["beforeLeave"].push(beforeLeave);
			formData["afterLeave"].push(afterLeave);
	});
	
	return formData;
}


function save() {
	var formData = getFormJson();
	if(!checkForm(formData)) {
		return ;
	}
	$.ajax({
		url: "save",
		type: "post",
		data: JSON.stringify(formData),
		contentType: "application/json",
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				openBootstrapShade(true);
				window.location.href = "toList";
			} else {
				bootstrapAlert("提示", "添加失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}



function checkDate(beginDate,endDate){
	var flag=true;
	if(beginDate>endDate){
		flag=false;
	}
	return flag;
}


