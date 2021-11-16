var currTd = null;
var index=0;
$(function() {
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	if($("#barginManageId").val() != null && $("#barginManageId").val() != ""){
		$("#viewBarginBtn").show();
	}
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	  /* 用户 */
    $("#userDialog").initUserDialog({
        "callBack": getData
    });

	initDatetimepicker();
	initInputMask();
	coutmoney();
    initFileUpload();
    initMenu();
    initInputBlur();
    //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/finance/invoiceProjectMembers/getList",
		type: "post",
		data: {finInvoicedId:$("#id").val(),barginManageId:$("#barginManageId").val()},
		dataType: "json",
		success: function(data) {
            for (var i = 0; i < data.length; i++) {
                if (i == 0) {
                    $("#tableTbody").append("<tr name='node1' class='node1'><td style='width:33%'>" + data[i].sysUser.name + "<input type='hidden'  " +
                        "name='userIdParticipate' value='" + data[i].sysUser.id + "' data-sorting='" + index + "'><input type='hidden'  name='businessId' value='" + data[i].id + "'></td>" +
                        "<td style='width:33%'><input type='text' name='commissionProportion' value='" + data[i].commissionProportion + "%' onkeyup='initInputBlur()'" +
                        "  title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
                } else {
                    $("#tableTbody").append("<tr name='node' class='node'><td style='width:33%'  onclick='openDialog(this)'><input type='text' name='userName'" +
                        " value='" + data[i].sysUser.name + "' style='text-align:center'  readonly><input type='hidden'  name='userIdParticipate' value='" + data[i].sysUser.id + "' " +
                        " data-sorting='" + index + "' style='text-align:center'><input type='hidden'  name='businessId' value='" + data[i].id + "'></td>" +
                        "<td style='width:33%'><input type='text'  name='commissionProportion' " +
                        "value='" + data[i].commissionProportion + "%' onkeyup='initInputBlur()' title='0%' style='text-align:center' onblur='onchanges(this)'/></td></tr>");
                }
                index++;
            }
            if(isNull(data)){
                myFunction();
            }
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
    $("#invoiceAmount").val(initInputMask2($("#invoiceAmount").val()));
	if(!isNull($("#totalMoney").val()) && !isNull($("#invoiceAmountTo").val()) && $("#totalMoney").val() != "0" ){
		$("#alreadyInvoiceProportion").val((digitTool.divide($("#invoiceAmountTo").val(), $("#totalMoney").val()) * 100).toFixed(2) + "%");
	}else{
		$("#alreadyInvoiceProportion").val("0%");
	}
	initInputBlur1();
});

function initInputBlur1() {
	var totalmoney = rmoney($("#totalMoney").val());
	var invoiceAmount = rmoney($("#invoiceAmount").val());
	if (!isNull(totalmoney) && !isNull(invoiceAmount) && totalmoney != "0") {
		$("#invoiceProportion").val(
				(digitTool.divide(invoiceAmount, totalmoney) * 100).toFixed(2) + "%");
	}else{
		$("#invoiceProportion").val("0%");
	}

}
function openDialog(obj) {
    currTd = obj;
    $("#userDialog").openUserDialog();
}
function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
    	$(currTd).find("input[name='userName']").val(data.name);
        $(currTd).find("input[name='userIdParticipate']").val(data.id);
    }
}

var boot = true;
function myFunction(){
    var name = null;
    var id = null;
	var name1 = $("#table1 tbody").eq(0).find('tr #userName').val()
    var name2 = $("#table1 tbody").eq(0).find('tr #userName2').val()
    var id1 = $("#table1 tbody").eq(0).find('tr #userId2').val()
    var id2 = $("#table1 tbody").eq(0).find('tr #applyUserId').val()
    if(isNull(name1)) {
        name = name2
        id = id2
    } else {
        name = name1
        id = id1
    }
	if(boot){
		$("#tableTbody").append('<tr name="node1" class="node1">'
			+ '<td style="width:33%">'
			+ '<input id="userIdParticipate" name="userIdParticipate" type="text" value="'+ id +'" style="display:none;" data-sorting="'+index+'">'
			+ '<input type="text" id="userName" name="userName" value="'+ name +'" style="text-align:center" readonly/></td>'
			/*+ '<td style="width:33%"><input type="text" id="resultsProportion" name="resultsProportion" onkeyup="initInputBlur()"  style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
			+ '<td style="width:33%"><input type="text" id="commissionProportion" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
			+ '</tr>')
		boot = false;
	}else{
		$("#tableTbody tr").eq(0).find('td').eq(0).find("input[name='uId']").val(id);
		$("#tableTbody tr").eq(0).find('td').eq(0).find("input[name='uName']").val(name);
	}
}

var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectId']").val(data.id);
		$(projectObj).find("input[name='projectManageName']").val(data.name);
	}
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

function initMenu(){
	$.contextMenu({
	    selector: "#table3 .node", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:33%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text"  name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);				  				  
	          	}
	        },
	        verygood: {name: "删除", callback: function(key, opt){
	        	var activeClass = $('.context-menu-active');
	        	var userName = $('#table2').find(activeClass).children().eq(0).children("input[name='userName']").val();
	        
	        	if(userName != ""){
	        			$(this).remove();
	        	}else{
	        		$('#table2').find(activeClass).remove();
	        		var firstTr = $("#table2").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        	cumulative();
	        }
	      }
	   }
	});
	$.contextMenu({
	    selector: "#table3 .node1", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
	        	index++;
		        	dataTR='<tr name="node" class="node">'
						+ '<td onclick="openDialog(this)"  style="width:33%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate" data-sorting="'+index+'"></td>'
						/*+ '<td  style="width:33%"><input type="text"  name="resultsProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'*/
						+ '<td  style="width:33%"><input type="text" name="commissionProportion" onkeyup="initInputBlur()" style="text-align:center" title="0%" onblur="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);				  				  
	          	}
	        }
	      }
	});
}


function countAll() {
	var sum = 0;
	var sum1 = 0;
	var sum3=0;
	$("tr[name='add']").each(function(index, tr) {
		temp = rmoney($(tr).find("input[name='money']").val());
		totalTemp= rmoney($(tr).find("input[name='levied']").val());
		if (temp == "" || temp == null) {
			temp = 0;
		}
		temp1 = rmoney($(tr).find("input[name='exciseMoney']").val());
		if (temp1 == "" || temp1 == null) {
			temp1 = 0;
		}
		sum = digitTool.add(sum, parseFloat(temp));
		sum1 = digitTool.add(sum1, parseFloat(temp1));
		sum3=digitTool.add(sum3, parseFloat(totalTemp));
	});
	var tr = $("#table2").find("#totalCount");
	$(tr).find("input[name='total']").val(fmoney(sum, 0));
	$(tr).find("input[name='totalexcisemoney']")
			.val(fmoney(sum1.toFixed(2), 0));
	var nexttr = $(tr).next();
	$(nexttr).find("input[name='totalexcise']").val(
			fmoney((sum3).toFixed(2), 0));
}

function initInputMask() {
    $("#applyPay").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "collectionBill") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
	});
	
	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "number") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}
	});
	
	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		/*if(name == "price" || name == "money" || name =="excise" || name =="exciseMoney") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}*/
		if (name == "levied") {
			$(input).inputmask("Regex", { regex: "^-?\\d+\\.?\\d{0,2}"});
		}
	});
	/*$("#collectionNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });*/
	/*$("#paynumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });*/
	$("#bankNumber").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
	$("#collectionAccount").inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
}



function coutmoney() {
	$("tr[name='add']").each(
			function(index, tr) {
				var levied = rmoney($(tr).find("input[name='levied']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if(!isNull(levied)){
					$(tr).find("input[name='money']").val(
							fmoney((levied / (1 + excise)).toFixed(2), 0));
				}else{
					$(tr).find("input[name='money']").val(0);
				}
				coutexcise(tr);
			});
}

function coutexcise(tr) {
	var number = $(tr).find("input[name='number']").val();
	var money = rmoney($(tr).find("input[name='money']").val());
	var excise = $(tr).find("select[name='excise']").val() / 100;
	if (money != null && money != "") {
		if (excise != 0 && money!=0) {
			$(tr).find("input[name='exciseMoney']").val(
					fmoney((money * excise).toFixed(2), 0));
		} else {
			$(tr).find("input[name='exciseMoney']").val(0);
		}
		if (number != null && number != "") {
			$(tr).find("input[name='price']").val(
					fmoney((money / number).toFixed(2), 0));
		} else {
			$(tr).find("input[name='price']").val(0);
		}

	}
	countAll();
}

function initexcise() {
	$("tr[name='add']").each(
			function(index, tr) {
				var money = rmoney($(tr).find("input[name='money']").val());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if (excise == 0 || money==0) {
					$(tr).find("input[name='exciseMoney']").val(0);
				}else if (money != null && money != "" && excise != null
						&& excise != "") {
					$(tr).find("input[name='exciseMoney']").val(
							fmoney(money * excise, 0));
				}
			});
	coutmoney();
	// countAll();
}


function fmoney(s, n){
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + '').replace(/[^\d\.-]/g, '')).toFixed(n) + '';
	var l = s.split('.')[0].split('').reverse(), r = s.split('.')[1];
	var t = '';
	for (var i = 0; i < l.length; i++) {
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? ',' : '');
	}
	return t.split('').reverse().join('') + '.' + r;

}

function rmoney(s) {
	return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

function initInputBlur(){
	$("#invoiceAmount").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='resultsProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	$("input[name='commissionProportion']").inputmask("Regex", { regex: "\\d+\\.?\\d{0}" });
	initInputBlur1();
}



/*function coutmoney(){
	$("tr[name='add']").each(function(index, tr) {
		var number = $(tr).find("input[name='number']").val();
		var price = $(tr).find("input[name='price']").val();
		$(tr).find("input[name='money']").val(digitTool.multiply(price,number));
		coutexcise(tr);
	});
}

function coutexcise(tr){
	var money = $(tr).find("input[name='money']").val();
	var excise = $(tr).find("input[name='excise']").val()/100;
	if (money != null && money != "" && excise != null && excise != "") {
		$(tr).find("input[name='exciseMoney']").val(money*excise);
	}
	countAll();
}


function initInputBlur(){
	var totalmoney = $("#totalPay").val();
	var applyPay = $("#applyPay").val();
	if(!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0"){
		$("#applyProportion").val(digitTool.divide(applyPay,totalmoney).toFixed(4)* 100+ "%");
	}

}


function initexcise(){
	$("tr[name='add']").each(function(index, tr) {
		var money = $(tr).find("input[name='money']").val();
		var excise = $(tr).find("input[name='excise']").val()/100;
		if (money != null && money != "" && excise != null && excise != "") {
			$(tr).find("input[name='exciseMoney']").val(money*excise);
		}
	});
    countAll();
}
*/




function openBargin() {
	$("#barginDialog").openBarginDialog();
}


function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").val(data.processInstanceId);
		$("#barginCode").val(data.barginCode);
		$("#barginName").val(data.barginName);
		$("#totalPay").val(fmoney(data.totalMoney,0));
		if(data.projectManage != null && data.projectManage != ""){
			$("#projectManageName").val(data.projectManage.name);
			$("#projectId").val(data.projectManage.id);
		}
		
		if(data.processInstanceId != null && data.processInstanceId != "" && data.processInstanceId != "undefined"){
			$("#tip").remove();
			$("#viewBarginBtn").show();
		}else{
			$("#tip").remove();  
			
			document.getElementById("viewBarginBtn").style.display = "none";
		        
			$("#viewBarginBtn").before('<font id="tip" style="border:none;color: rgb(54, 127, 169)">选取成功！</font>');
		}
		
	}
}


function initDatetimepicker() {
	$("#finInvoicedDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}

function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		initInputMask();
	}
}

function add(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
        coutmoney();
        initexcise();

	} else {
		var html = getAddHtml();
		$(obj).parents("tr").after(html);
		initInputMask();
	}
}



//收款登记行
function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('	<td colspan="3"><input type="text" style="text-align:center;" name="collectionDate" class="collectionDate" value=""  readonly></td>');
	html.push('	<td colspan="3"><input type="text" name="collectionBill" value="" ></td>');
	html.push('<td colspan="3" style="text-align:center;">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
	
}


//发票详情行
function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td><input type="text"  name="name" value="" > </td>');
	html.push('<td><input type="text"  name="model" value="" > </td>');
	html.push('<td><input type="text" name="unit" value=""  ></td>');
	html.push('<td><input type="text" name="number" value=""  onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="price" value="" readonly></td>');
	html.push('<td><input type="text" name="money" value="0"  readonly></td>');
	html.push('<td><select name="excise" onchange="initexcise()" style="width: 100%;">');
	html.push('<option selected="selected">0</option>');
	html.push('<option>6</option>');
	html.push('<option>13</option>');
	html.push('<option>16</option>');
	html.push('<option>17</option>');
	html.push('</select></td>');
	html.push('<td><input type="text" name="exciseMoney" value="0"  readonly ></td>');
	html.push('<td><input type="text"  name="levied" value="" onkeyup="coutmoney()"></td>')
	html.push('<td style="text-align:center;">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}


function submitinfo() {
	bootstrapConfirm("提示", "是否确定提交？", 300, function() {
		var formData = getFormData();
		$("#isSubmit").val(1);
		if(!checkForm(formData)) {
			return ;
		}

		if(fileData !=null){ //已选择文件，则先上传文件
			openBootstrapShade(true);
			fileData.submit();
		}else{
	        openBootstrapShade(true);
	        submitForm(formData);
		}
	})
}

//保存表单信息
function save() {
	//bootstrapConfirm("提示", "是否确定保存？", 300, function() {
		var formData = getFormData();
	    $("#isSubmit").val(0);
		if(!checkForm(formData)) {
			return ;
		}
	    if(fileData !=null){ //已选择文件，则先上传文件
	        openBootstrapShade(true);
	        fileData.submit();
	    }else{
	        openBootstrapShade(true);
	        saveForm(formData);
	    }
	//})
}


//保存表单
function saveForm(formData) {
	$.ajax({
		url: "saveInfo",
		type: "post",
		contentType: "application/json",
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
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function submitForm(formData) {
	$.ajax({
		url: "submitinfo",
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


function getFormData() {
	if(!isNull($("#invoiceAmount").val())){
		$("#invoiceAmount").val(rmoney($("#invoiceAmount").val()));
	}
	
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	var applyUnit=$("select[name='applyUnit']").val();
	formData["applyUnit"]=applyUnit;
	formData["invoicedAttachList"] = [];
	$("tbody").find("tr[name='add']").each(function(index, tr) {
		var name = $(this).find("input[name='name']").val();
		var model = $(this).find("input[name='model']").val();
		var unit = $(this).find("input[name='unit']").val();
		var number = $(this).find("input[name='number']").val();
		var price = $(this).find("input[name='price']").val();
		var money = $(this).find("input[name='money']").val();
		var excise = $(this).find("select[name='excise']").val();
		var exciseMoney = $(this).find("input[name='exciseMoney']").val();
		var levied = $(this).find("input[name='levied']").val();
		if( !isNull(name) || !isNull(model)) {
			var invoiceAttach = {};
			invoiceAttach["name"]= name;
			invoiceAttach["model"]= model;
			invoiceAttach["unit"]= unit;
			invoiceAttach["number"]= number;
			invoiceAttach["price"]= price;
			invoiceAttach["money"]= money;
			invoiceAttach["excise"]= excise;
			invoiceAttach["exciseMoney"]= exciseMoney;
			invoiceAttach["levied"]= levied;
			formData["invoicedAttachList"].push(invoiceAttach);
		}
	});
	formData["finInvoiceProjectMembersList"] = [];
	$("#tableTbody tr").each(function(index, tr) {
		var id = $(this).find("input[name='businessId']").val();
		var userIdParticipate = $(this).find("input[name='userIdParticipate']").val();
		var sorting=$(this).find("input[name='userIdParticipate']").attr("data-sorting");
		var commissionProportion = $(this).find("input[name='commissionProportion']").val();
		/*var resultsProportion = $(this).find("input[name='resultsProportion']").val();*/
		if( !isNull(userIdParticipate)) {	
			var FinInvoiceProjectMembers = {};
			if(id!=null && id !='' && id!=undefined && id !='undefined'){
				FinInvoiceProjectMembers["id"]= id;
			}
			FinInvoiceProjectMembers["userId"]= userIdParticipate;
			FinInvoiceProjectMembers["sorting"] = sorting;
			FinInvoiceProjectMembers["commissionProportion"]= commissionProportion.replace(/%/g,'');
			/*FinInvoiceProjectMembers["resultsProportion"]= resultsProportion.replace(/%/g,'');*/
			formData["finInvoiceProjectMembersList"].push(FinInvoiceProjectMembers);
		}
	});
	formData["businessId"]="";
	return formData;
}

var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
		if(isNull(formData["invoiceAmount"])){
			text.push("开票金额不能为空！<br/>");
		}
		/*if(isNull(formData["payCompany"])){
			text.push("付款单位不能为空！<br/>");
		}*/

		if(isNull(formData["payname"])){
			text.push("购货单位不能为空！<br/>");
		}
		if(isNull(formData["paynumber"])){
			text.push("纳税人识别号不能为空！<br/>");
		}

		if(isNull(formData["bankAddress"]) || isNull(formData["bankNumber"])){
			text.push("开户行和账号不能为空！<br/>");
		}
		if(formData["invoicedAttachList"].length <= 0) {
			text.push("至少有一条发票项！");
		}
		else{
			$(formData["invoicedAttachList"]).each(function(index, attach) {
				if(isNull(attach["name"])) {
					text.push("名称不能为空！");
					return false;
				}
				/*if(isNull(attach["model"])) {
					text.push("型号不能为空！");
					return false;
				}*/
				
				if(isNull(attach["levied"])){
					text.push("价税小计不能为空！");
					return false;
				}
				if(isNull(attach["number"])) {
					text.push("数量不能为空！");
					return false;
				}
				if(isNull(attach["price"])) {
					text.push("单价不能为空！");
					return false;
				}
				if(isNull(attach["money"])) {
					text.push("金额不能为空！");
					return false;
				}
				if(isNull(attach["excise"])) {
					text.push("税率不能为空！");
					return false;
				}
			});
			
		}
   /* $("tr[name='node1']").each(function(business, tr) {
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


/*    $("tr[name='node']").each(function(business, tr) {
        var resultsProportion = $(tr).find("input[name='resultsProportion']").val();
        var uName = $(tr).find("input[name='userName']").val();
        var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
        if(!isNull(resultsProportion) || !isNull(uName) || !isNull(commissionProportion)) {
            if (resultsProportion == "" || resultsProportion == null ||resultsProportion == "%") {
                text.push("业绩比例不能为空！<br/>");
                return false
            }
        }
    });*/

    $("tr[name='node']").each(function(business, tr) {
        var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
        var uName = $(tr).find("input[name='userName']").val();
       /* var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
        if(!isNull(uName) || !isNull(commissionProportion)) {
            if (commissionProportion == "" || commissionProportion == null || commissionProportion == "%") {
                text.push("提成比例不能为空！<br/>");
                return false
            }
        }
    });

    $("tr[name='node']").each(function(business, tr) {
        var commissionProportion = $(tr).find("input[name='commissionProportion']").val();
        var uName = $(tr).find("input[name='userName']").val();
       /* var resultsProportion = $(tr).find("input[name='resultsProportion']").val();*/
        if(!isNull(uName) || !isNull(commissionProportion)) {
            if (uName == "" || uName == null) {
                text.push("成员名字不能为空！<br/>");
                return false
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

//下载附件
function downloadAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        var url = web_ctx + attachUrl;
        window.open(url,'_blank');
    }
}

//删除附件
function deleteAttach(obj) {
    var attachUrl = $(obj).attr("value");
    if(!isNull(attachUrl)) {
        bootstrapConfirm("提示", "确定要删除该附件吗？", 300, function() {
            $.ajax({
                url: web_ctx+"/manage/sale/finInvoiced/deleteAttach",
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
        bootstrapAlert("提示", "无附件！", 400, null);
    }
}


//文件上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
    var date = new Date();
    var params = {
        "path": "collection/" + date.getFullYear() + (date.getMonth()+1) + date.getDate(),
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
                if($("#isSubmit").val() == 1){
                    submitForm(formData);
				}else{
                    saveForm(formData);
				}
                openBootstrapShade(false);
            } else {
                openBootstrapShade(false);
                bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
            }
        }
    });
}

/*
 * 初始化相关操作
 *初始化金额，两位数
 */
function initInputMask2(val){
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
//    if (type == 0) {
//        var a = val.split(".");
//        if (a[1] == "00") {
//            val = a[0];
//        }
//    }
    return val;
}








