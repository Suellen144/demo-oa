var currTd = null;
$(function() {
	initDatetimepicker();
	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
});

function initDatetimepicker() {
	$(".starttime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true,
        autoclose: true,
        bootcssVer:3
    }).on('changeDate',function(e){  
        var startTime = e.date;  
        $(".endtime").datetimepicker('setStartDate',startTime);  
    });
	
	$(".endtime").datetimepicker({
		language:"zh-CN",
		CustomFormat: "yyyy-MM-dd HH24':'mm",
        showMeridian: true ,
        bootcssVer:3,
        autoclose: true
    });
	
}

function checkForm(formData) {
	var text = [];
	$(formData).each(function(index,formData){
		 if(formData.startTime.length>=1){
			if(formData.startTime[0] == "" || formData.endTime[0] == "" ||formData.reason[0] == "" ||formData.place[0] == "") {
				text.push("必须至少登记一条数据！且需填写完整！<br/>");
				return false;
			}
			for(i=1;i<formData.startTime.length;++i){
				if(formData.startTime[i] == "" && formData.endTime[i] == "" && formData.reason[i] == "" && formData.place[i] == "") {
					return false;
				}
				else if(formData.startTime[i] == "" || formData.endTime[i] == "" || formData.reason[i] == "" || formData.place[i] == ""){
					text.push("非空白行必须填写完整！<br/>");
					return false;
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
	html.push('<td colspan="1"><input type="text" name="startTime" id="startTime"class="starttime" readonly></td>');
	html.push('<td colspan="1"><input type="text" name="endTime" id="endTime" class="endtime" readonly ></td>');
	html.push('<td colspan="1"><input type="text" name="reason" class="input" value = ""></td>');
	html.push('<td colspan="1"><input type="text" name="place" class="input" value = "" ></td>');
	html.push('<td colspan="2">');
	html.push('<a href="javascript:void(0);" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}

function getFormJson() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	
	formData["startTime"] = [];
	formData["endTime"] = [];
	formData["reason"] = [];
	formData["place"] = [];
	
	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var startTime = $(this).find("input[name='startTime']").val();
		var endTime = $(this).find("input[name='endTime']").val();
		var reason = $(this).find("input[name='reason']").val();
		var place = $(this).find("input[name='place']").val();
			formData["startTime"].push(startTime);
			formData["endTime"].push(endTime);
			formData["reason"].push(reason);
			formData["place"].push(place);
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
				bootstrapAlert("提示", "登记失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}





