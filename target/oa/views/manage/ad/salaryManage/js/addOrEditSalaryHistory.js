$(function(){
	initDatetimepicker();
	inittextarea();
	/*initInputMask();*/
	initDecryption();
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

//初始化输入框约束
function initInputMask() {
	$("input[name='salary']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
}


/************* 加解密操作 Begin **************/
//如果有解密权限，则解密当前已加密的数据
function initDecryption() {
	if( hasDecryptPermission ) {
		var now = new Date().pattern("yyyyMMdd");
		$.ajax({
			url: web_ctx+'/manage/getEncryptionKey?baseKey='+now,
			type: 'GET',
			success: function(data) {
				if(data.code == 1) {
					var tempKey = data.result;
					var encryptionKey = aesUtils.decryptECB(tempKey, now);
					encryptPageText(encryptionKey);
				} else {
					if(data.code == -1) {
						bootstrapAlert('提示', data.result, 400, null);
					}
					disabledEncryptPageText();
				}
			}
		});
	} else {
		disabledEncryptPageText();
	}
}

function encryptPageText(encryptionKey) {
	var s = $("input[name='salary']");
	$("input[name='salary']").each(function(index,item){
		var val = $(item).val();
		
		    val = aesUtils.decryptECB(val, encryptionKey);
	    if( !isNull(val) ) {
			$(item).val(val);
		}
		
	});
	
}
function disabledEncryptPageText() {
	$("tbody[name='salary']").prop("readonly", true);
}

/************* 加解密操作 End **************/

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		inittextarea();
		/*initInputMask();*/
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node"><input type="hidden" id="id" name="id" value =""> ');
	html.push('<td style="width:9%;"><input type="text" name="startTime" class="date" value="" readonly style="width: 100%;height: 100%;padding: 12px"></td>');
	html.push('<td style="width:9%;"><input type="text" name="endTime" class="date" value="" readonly style="width: 100%;height: 100%;padding: 12px"></td>');
	html.push('<td style="width:8%;">');
	html.push('<input  name="salaryBack"  type="hidden" value="${salaryHistorie.salary}" >');
	html.push('	<input   name="salary"  type="text" value="" style="width: 100%;height: 100%;padding: 12px;border:0px;">');
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
	saveInfo(formData);
}

function saveInfo(formData){
	$.ajax({
		url:web_ctx+"/manage/ad/salaryHistory/saveBatchSalaryHistory?userId="+$("#userId").val(),
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
		var salary = $(this).find("input[name='salary']").val();
		var remark = $(this).find("textarea[name='remark']").val();
		
		// 其中一个有值就算有效表单数据
		if(!isNull(startTime) || !isNull(endTime) || !isNull(salary)|| !isNull(remark) )  {
			var data = {};
			data["id"] = id;
			data["userId"] = userId;
			data["startTime"] = startTime;
			data["endTime"] = endTime;
			data["salary"] = salary;
			data["remark"] = remark;
			
			formData[index]=data;
		}
	});

	return formData;
}

var jusity = /^\d+\.?\d{0,2}$/;
function checkForm(formData) {
	var checkMsg = [];
	var date = 0;
	var salary = 0;
	var salaryJusityt = 0;
	for ( var key in formData) {
		
		var s = formData[key];
		if(isNull(s.startTime)) {
			date = date +1;
		}
		
		if(isNull(s.salary)) {
			salary = salary +1;
		}else{
			if(! jusity.test(s.salary)){
				salaryJusityt = salaryJusityt +1;
			}
		}
	}
	
	if(date > 0){
		checkMsg.push("开始日期不能为空！");
	}

	if(salary > 0){
		checkMsg.push("薪水不能为空！");
	}
	
	if(salaryJusityt > 0){
		checkMsg.push("金额请填写正确的格式！");
	}
	return checkMsg;
}