$(function(){
	initDatetimepicker();
	inittextarea();
	$("#deptDialog").initDeptDialog({
		"callBack": getDept
	});
	
})

function initDatetimepicker() {
	$(".date").datetimepicker({
		language: "zh-CN",
		format: 'yyyy-mm-dd',
        showMeridian: true,
        autoclose: true,
        todayBtn: true,
        bootcssVer:3,
        minView: 2
    });
}

function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

var nameObj = "";
function openDept(obj){
	nameObj = obj;
	$("#deptDialog").openDeptDialog();
}

function getDept(data) {
	if(!isNull(data) && !isNull(nameObj)) {
		$(nameObj).next("input[name='deptId']").val(data.id);
		
		$.ajax({
			url:web_ctx+"/manage/sys/dept/findUpDept",
			type: "get",
			dataType: "json",
			contentType:"application/json;charset:UTF-8",
			data:{"id":data.id},
			success:function(data){
				if(data.code==1){
					$(nameObj).val(data.result);
				} else{
					bootstrapAlert("提示",data.result, 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		inittextarea();
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node"><input type="hidden" id="id" name="id" value =""> ');
	html.push('<td style="width:9%;"><input type="text" name="startTime" class="date" value="" readonly style="width: 100%;height: 100%;padding: 12px"></td>');
	html.push('<td style="width:9%;"><input type="text" name="endTime" class="date" value="" readonly style="width: 100%;height: 100%;padding: 12px"></td>');
	html.push('<td style="width:8%;">');
	html.push('<input  onclick="openDept(this)" name="dept"  type="text" value="" style="width: 100%;height: 100%;padding: 12px" readonly>');
	html.push('</td>');
	html.push('<td style="width:18%;"><textarea name="remark" id="remark" ></textarea></td>');
	html.push('<td style="width:6%;">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	
	html.push('</tr>');
	
	return html.join("");
}

function save(){
	var formData = getFormJson();
	var checkMsg = checkForm(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}
	
	openBootstrapShade(true);
	saveInfo(formData);
}

function saveInfo(formData){
	$.ajax({
		url:web_ctx+"/manage/ad/record/saveBatchDeptHistory",
		type: "POST",
		dataType: "json",
		contentType:"application/json;charset:UTF-8",
		data:JSON.stringify(formData),
		success:function(data){
			if(data.code==1){
				backPageAndRefresh();
			} else{
				bootstrapAlert("提示",data.result, 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function getFormJson(){
	var formData = {};
	var userId = $("#userId").val();
	$("tbody").find("tr[name='node']").each(function(index, tr) {
		var id = $(this).find("input[name='id']").val();
		var startTime = $(this).find("input[name='startTime']").val();
		var endTime = $(this).find("input[name='endTime']").val();
		var dept = $(this).find("input[name='dept']").val();
		var remark = $(this).find("textarea[name='remark']").val();
		
		// 其中一个有值就算有效表单数据
		if(!isNull(startTime) || !isNull(endTime) || !isNull(dept)|| !isNull(remark) )  {
			var data = {};
			data["id"] = id;
			data["userId"] = userId;
			data["startTime"] = startTime;
			data["endTime"] = endTime;
			data["dept"] = dept;
			data["remark"] = remark;
			
			formData[index]=data;
		}
	});

	return formData;
}

function checkForm(formData) {
	var checkMsg = [];
	var dept = 0;
	var date = 0;
	for ( var key in formData) {
		var s = formData[key];
		if(isNull(s.startTime)) {
			date = date +1;
		}
		
		if(isNull(s.dept)) {
			dept = dept +1;
		}
	}
	if(date > 0){
		checkMsg.push("任命时间不能为空！");
	}

	if(dept > 0){
		checkMsg.push("部门不能为空！");
	}
	return checkMsg;
}
