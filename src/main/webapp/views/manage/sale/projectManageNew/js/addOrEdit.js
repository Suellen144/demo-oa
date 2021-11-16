var currTd = null;
var boot = true;
var index=0;
$(function(){	
	$("#submitDate").val(new Date().pattern("yyyy-MM-dd"));
	
	initDatetimepicker();
	initMenu();
	initFileUpload();
	initInputBlur();
	$("#userByDeptDialog").initUserDialog({
		 "callBack" : getData
	 });
	
	$("#userDialog").initUserByDeptDialog({
		 "callBack" : getData2
	 });
	
	 //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/sale/projectManage/getList",
		type: "post",
		data: {projectId:$("#id").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tbodyInfoTr").append("<tr name='node1' class='node1'><td style='width:33%'>"+data[i].principal.name+"<input type='hidden' id='uId' " +
							"name='uId' value='"+data[i].principal.id+"' data-sorting='"+index+"'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td><"+
											"<td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()' " +
											"  title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
				}else{
					$("#tbodyInfoTr").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog2(this)'><input type='text' name='uName'" +
							" value='"+data[i].principal.name+"' style='text-align:center'  readonly><input type='hidden' id='uId' name='uId' value='"+data[i].principal.id+"' " +
									" data-sorting='"+index+"' style='text-align:center'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td>" +
													"<td style='width:33%'><input type='text'  name='commissionProportion' " +
											"value='"+data[i].commissionProportion+"%' onkeyup='initInputBlur()'  title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
				}
				index++;
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
});

function initInputBlur(){
	$("#size").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='resultsProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='commissionProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	//var size=initInputMask($("#size").val());
	//$("#size").val(size);
}
function fun(n) {
    re = "/(\d{1,3})(?=(\d{3})+(?:$|\.))/g";
    n1 = n.replace(re, "$1,");
    return n1;
}
function onchanges(obj) {
	if(obj.value.indexOf("%") != -1){
		obj.value=obj.value.replace(/%/g,'')+"%";
	}else{
		obj.value=obj.value+"%";
	}
	cumulative();
};
function cumulative(){
	var commissionProportion=$("input[name='commissionProportion']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
	
	/*var resultsProportion=$("input[name='resultsProportion']")
	var sum1=0;
	for(var i=0;i<resultsProportion.length;i++){
		if(resultsProportion[i].value!=null && resultsProportion[i].value!=undefined && resultsProportion[i].value!=''){
			sum1+=parseFloat(resultsProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative1").html(sum1+"%");*/
}

function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userId']").val(data.id);
        $(currTd).find("input[name='userName']").val(data.name);
        $("#dutyDeptId").val(data.dept.id);
        $("#deptName").val(data.dept.name);
        
        myFunction()
    }
}

function getData2(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='uId']").val(data.id); 
        $(currTd).find("input[name='uName']").val(data.name);
    }
}

function getDeptName() {
    var deptName = "";
    return deptName;
}

// 下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url, '_blank');
	}
}

// 删除附件
function deleteAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if (!isNull(attachUrl)) {
		bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
			$.ajax({
				url : web_ctx + "/manage/sale/projectManage/deleteAttach",
				data : {
					"path" : $("#attachments").val(),
					"id" : $("#id").val()
				},
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.code == 1) {
						bootstrapAlert("提示", "删除成功 ！", 400, function() {
							window.location.reload();
						});
					} else {
						bootstrapAlert("错误提示", "附件路径错误或不存在，无法删除！", 400, null);
					}
				},
				error : function(data) {
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}

			});
		}, null);
	} else {
		bootstrapAlert("提示", "无附件！", 400, null);
	}
}

function initDatetimepicker() {
	$(".projectDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function myFunction(){
	var name = $("#table1 tbody").eq(0).find('tr #userName').val()
	var id = $("#table1 tbody").eq(0).find('tr #userId').val()
	if(boot){	
		$("#tbodyInfoTr").append('<tr name="node1" class="node1">'
    							+ '<td style="width:33%">'
    							+ '<input id="uId" name="uId" type="text" value="'+ id +'" style="display:none;" data-sorting="'+index+'">'
    							+ '<input type="text" id="uName" name="uName" value="'+ name +'" readonly/></td>'
    						/*	+ '<td style="width:33%"><input type="text" id="resultsProportion" name="resultsProportion" onkeyup="initInputBlur()"  style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
    							+ '<td style="width:33%"><input type="text" id="commissionProportion" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
    							+ '</tr>')
    	boot = false;
	}else{
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uId']").val(id);
		$("#tbodyInfoTr tr").eq(0).find('td').eq(0).find("input[name='uName']").val(name);
	}   	 
}

//保存信息
function save(){
	var formData = getFormData();
	var issubmit = $("#issubmit").val("0"); //区分保存和提交
	
	var checkMsg= checkForm(formData);
	if(! isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	$.ajax({
		url: web_ctx + "/manage/sale/projectManage/findByProjectManageName",//項目名称不能重复
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data:  JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				$("#name").val("");
				bootstrapAlert("提示", data.result, 400, null);
			}else{
				if(fileData != null) { // 已选择文件，则先上传文件
					openBootstrapShade(true);
					fileData.submit();
				} else {
					openBootstrapShade(true);
					saveInfo(formData);
				}
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function saveInfo(formData){
	$.ajax({
		url: "saveInfo",
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

function submitInfo() {	
	var formData = getFormData();
		bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		
		var issubmit = $("#issubmit").val("1");
		var checkMsg= checkForm(formData);
		if(! isNull(checkMsg)) {
			bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
			return ;
		}
		$.ajax({
			url: web_ctx + "/manage/sale/projectManage/findByProjectManageName",//項目名称不能重复
			type: "post",
			contentType: "application/json;charset=UTF-8",
			data:  JSON.stringify(formData),
			dataType: "json",
			success: function(data) {
				if(data.code == 1) {
					$("#name").val("");
					bootstrapAlert("提示", data.result, 400, null);
				}else{
					if(fileData !=null){ //已选择文件，则先上传文件
						openBootstrapShade(true);
						fileData.submit();
					}else{
				        openBootstrapShade(true);
				        submit(formData);
					}
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	})
}

function submit(formData){
	$.ajax({
		url: "submit",
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
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["projectMemberList"] = [];
	$("#tbodyInfoTr tr").each(
		function(index, tr) {
			var id = $(this).find("input[name='businessId']").val();
			var userId = $(this).find("input[name='uId']").val();
			/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
			var commissionProportion = $(this).find("input[name='commissionProportion']").val();
			var sorting=$(this).find("input[name='uId']").attr("data-sorting");
			if (!isNull(userId)  || !isNull(commissionProportion)) {
				var memberList = {};
				if(id!=null && id !='' && id!=undefined && id !='undefined'){
				memberList["id"]= id;
				}
				memberList["userId"] = userId;
				memberList["sorting"] = sorting;
				/*memberList["resultsProportion"] = resultsProportion.replace(/%/g,'');*/
				memberList["commissionProportion"] = commissionProportion.replace(/%/g,'');
				formData["projectMemberList"].push(memberList);
			}
		});
	formData["size"]=commafyback(formData["size"]);
	formData["businessId"]="";
	return formData;
}

function checkForm(formData) {
	var text = [];
	var projecName = $.trim($("#name").val());
	var userName = $.trim($("#userName").val());
	if(isNull(userName)) {
		text.push("请选择项目负责人！");
	}

	/*$("tr[name='node1']").each(function(business, tr) {
	    debugger;
		var value = $(tr).find("input[name='resultsProportion']").val();
		if (value == "" || value == null || value == "%") {
			text.push("业绩比例不能为空！<br/>");
			return false
		}
	});*/

	$("tr[name='node1']").each(function(business, tr) {
		var value = $(tr).find("input[name='commissionProportion']").val();
		if (value == "" || value == null || value == "%") {
			text.push("提成比例不能为空！<br/>");
			return false
		}
	});


	/*$("tr[name='node']").each(function(business, tr) {
		var resultsProportion = $(tr).find("input[name='resultsProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		if(!isNull(resultsProportion) || !isNull(uName) || !isNull(commissionProportion)) {
			if (resultsProportion == "" || resultsProportion == null || resultsProportion == "%") {
				text.push("业绩比例不能为空！<br/>");
				return false
			}
		}
	});*/

	$("tr[name='node']").each(function(business, tr) {
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
		/*var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
		if( !isNull(uName) || !isNull(commissionProportion)) {
			if (commissionProportion == "" || commissionProportion == null || commissionProportion == "%") {
				text.push("提成比例不能为空！<br/>");
				return false
			}
		}
	});
	$("tr[name='node']").each(function(business, tr) {
		debugger;
		var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
		var uName = $(tr).find("input[name='uName']").val();
		/*var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
		if( !isNull(uName) || !isNull(commissionProportion)) {
			if (uName == "" || uName == null) {
				text.push("成员名字不能为空！<br/>");
				return false
			}
		}
	});

	if(isNull(projecName)) {
		text.push("请填写项目名称！");
	}

	return text;
}

function openDialog(obj) {	
	currTd = obj;
    $("#userByDeptDialog").openUserDialog();
}

function openDialog2(obj) {	
	currTd = obj;
	$("#userDialog").openUserByDeptDialog();	
}

function initMenu(){
	$.contextMenu({
	    selector: "#table2 .node", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
	        	dataTR='<tr name="node" class="node">'
					+ '<td onclick="openDialog2(this)"  style="width:33%"><input type="text" name="uName"   style="text-align:center" readonly/><input type="hidden" name="uId" data-sorting="'+index+'"></td>'
					/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
					+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
					+ '</tr>';
		        	$("#tbodyInfoTr").append(dataTR)
	          	}
	        },
	        verygood: {name: "删除", callback: function(key, opt){
	        	var activeClass = $('.context-menu-active');
	        	var userName = $('#table1').find(activeClass).children().eq(0).children("input[name='uName']").val();	        	
	        	if ((this).hasClass('trnode')) {
	        		return;
	        	}else if(userName != "" ){
	        	//	if(confirm('确认删除吗？')){
	        			$(this).remove();
		        //	}
	        	}else{
	        		$('#table1').find(activeClass).remove();
	        		var firstTr = $("#table1").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        }
	      }
	   }
	});
	
	$.contextMenu({
	    selector: "#table2 .node1", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog2(this)"  style="width:33%"><input type="text" name="uName"   style="text-align:center" readonly/><input type="hidden" name="uId" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tbodyInfoTr").append(dataTR);				  				  
	          	}
	        }
	      }
	});
}

/*
 * 初始化相关操作
 *初始化金额，两位数
 
function initInputMask() {	
	$("#invoiceMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#totalMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#applyMoney").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("#bankAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
}*/

//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "pay/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
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
        		if($("#issubmit").val()=="0"){
        			saveInfo(formData);
        		}
        		else{
        			submit(formData);
        		}
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}
/*
 * 添加千分位
 */
function initInputMask(val){
	if (/[^0-9\.]/.test(val))
        return "0.00";
    if (val == null || val == "null" || val == "")
        return "0.00";
    val = val.toString().replace(/^(\d*)$/, "$1.");
    val = (val + "00").replace(/(\d*\.\d\d)\d*/, "$1");
    val = val.replace(".", ",");
    var re = /(\d)(\d{3},)/;
    while (re.test(val))
        val = val.replace(re, "$1,$2");
    val = val.replace(/,(\d\d)$/, ".$1");
    return val;
}
/*
 * 去除千分位
 */
function commafyback(num) { 
var x = num.split(','); 
return parseFloat(x.join("")); 
} 

