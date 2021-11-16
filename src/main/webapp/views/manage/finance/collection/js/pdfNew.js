var currTd = null;
$(function() {
	initDatetimepicker();
	initInputMask();
	//initinvoiced();
	initInputBlur();
	/*initCompareBillWithBillCollection();*/
	coutmoney();
	initMenu();
	initAdd();
	$("#barginDialog").initBarginDialog({
		"callBack": getBargin
	});
	
	if($("#barginId").val() != null && $("#barginId").val() != ""){
		$("#viewBarginBtn").show();
	}
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});
	if(!isNull($("#bill").val())){
    	$("#bill").val(fmoney($("#bill").val(),0))
    }
    $("#totalPay").val(fmoney($("#totalPay").val(),0));
	$("#applyPay").val(fmoney($("#applyPay").val(),2))
	countAll();
	$.ajax({
	 	url: web_ctx + "/manage/finance/collectionMembers/getList",
		type: "post",
		data: {finCollectionId:$("#id").val(),barginManageId:$("#barginId").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
				if(i==0){
					$("#tableTbody").append("<tr name='node1' class='node1'><td style='width:50%'>"+data[i].sysUser.name+"<input type='hidden'  name='userIdParticipate' value='"+data[i].sysUser.id+"'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td><td style='width:50%'><input type='text'  name='commissionProportionParticipate' value='"+data[i].commissionProportion+"%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}else{
					$("#tableTbody").append("<tr name='node2' class='node2'><td style='width:50%'  onclick='openDialog(this)'><input type='text' name='userName' value='"+data[i].sysUser.name+"' style='text-align:center'  readonly><input type='hidden'  name='userIdParticipate' value='"+data[i].sysUser.id+"'   style='text-align:center'><input type='hidden'  name='businessId' value='"+data[i].id+"'></td>" +
							"<td style='width:50%'><input type='text'  name='commissionProportionParticipate' value='"+data[i].commissionProportion+"%' title='0%' style='text-align:center' onchange='onchanges(this)'/></td></tr>");
				}
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
});

$(".linkage").change(function(){
	var commissionBase=$("#commissionBase").val();
	var commissionProportion=$("#commissionProportion").val();
	//var allocations=$("#allocations").val();
	if(isNull(commissionBase) || isNull(commissionProportion)){
		return;
	}
	$("#allocations").val(commissionBase*(commissionProportion.replace(/%/g,'')/100));
	});

function initMenu(){
	$.contextMenu({
	    selector: "#table2 .node2", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
		        	dataTR='<tr name="node2" class="node2">'
						+ '<td onclick="openDialog(this)"  style="width:50%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate"></td>'
						+ '<td  style="width:50%"><input type="text"  name="commissionProportionParticipate" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'
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
	    selector: "#table2 .node1", //给table2表格的行添加右键功能
	    items: {
	        add: {name: "新增", callback: function(key, opt){
		        	dataTR='<tr name="node2" class="node2">'
						+ '<td onclick="openDialog(this)"  style="width:50%"><input type="text" name="userName"   style="text-align:center" readonly/><input type="hidden" name="userIdParticipate"></td>'
						+ '<td  style="width:50%"><input type="text" name="commissionProportionParticipate" style="text-align:center" title="0%" onchange="onchanges(this)"/></td>'
						+ '</tr>';
			    	    $("#tableTbody").append(dataTR);				  				  
	          	}
	        }
	      }
	});
}

function onchangeCommission() {
	var commissionProportionVal =0;
	if($("#commissionProportion").val().indexOf("%") != -1){
		commissionProportionVal=$("#commissionProportion").val().replace(/%/g,'');
	}
	if(commissionProportionVal > 100) {
		layer.msg('提成比例不能大于100', { offset: '150px' })
		$("#commissionProportion").val('');
		$("#allocations").val('');
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
	var commissionProportion=$("input[name='commissionProportionParticipate']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
}

/*项目选择*/
var projectObj = null;
function openProject(obj) {
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
}

function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).find("input[name='projectId']").val(data.id);
		$("td[name='projectname']").text(data.name);
	}
}

//比较开票金额和收款总金额
function initCompareBillWithBillCollection() {
	var total = 0;
	var collectionBill = 0;
	$("tr[name='node']").each(function (business,tr) {
        temp = $(tr).find("input[name='collectionBill']").val();
        if (temp == "" || temp == null){
            temp = 0;
        }
        total = digitTool.add(total,parseFloat(temp));
    });
	if($("#bill").val() == total){
		$("#billHidden").show();
	}else{
        $("#billHidden").hide();
	}
}

function initInputBlur(){
	var totalmoney = rmoney($("#totalPay").val());
	var applyPay = rmoney($("#applyPay").val());
	if(!isNull(totalmoney) && !isNull(applyPay) && totalmoney != "0"){
		$("#applyProportion").val(digitTool.divide(applyPay,totalmoney).toFixed(4)* 100+ "%");
	}

}



function initAdd() {
		var nodes = $("#add").find("tr[name='add']");
		if(nodes.length == 0) {
			var html = getAddHtml();
			 $("#add").append(html);
			 initDatetimepicker();
			 initInputMask();
		}
}


function initNode(){
	var collection = $("#node").find("tr[name='node']");
	if(collection.length == 0) {
		var html = getNodeHtml();
		 $("#node").append(html);
		 initDatetimepicker();
		 initInputMask();
	}
}

function initInputMask() {
	$("tr[name='node']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "collectionBill") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
		}
	});
	
	$("tr[name='add']").find("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(/*name == "price" || name == "money" || name =="excise" || name =="exciseMoney" ||*/name == "number") {
			$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,0}" });
		}
		if (name == "levied") {
			/*$(input).inputmask("Regex", { regex: "^[+-]?[1-9]?[0-9]\.[0-9]{2}%$"});*/
			$(input).inputmask("Regex", { regex: "^-?\\d+\\.?\\d{0,2}"});
		}
	});
	
	$("#bill").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	
}


function coutmoney() {
	$("tr[name='add']").each(
			function(index, tr) {
				var levied = rmoney($(tr).find("td[name='levied']").text());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				$(tr).find("td[name='money']").text(
						fmoney((levied / (1 + excise)).toFixed(2), 0));
				coutexcise(tr);
			});
}

function coutexcise(tr) {
	var number = $(tr).find("td[name='number']").text();
	var money = rmoney($(tr).find("td[name='money']").text());
	var excise = $(tr).find("select[name='excise']").val() / 100;
	if (money != null && money != "") {
		if (excise != 0) {
			$(tr).find("td[name='taxbreak']").text(
					fmoney((money * excise).toFixed(2), 0));
		} else {
			$(tr).find("td[name='taxbreak']").text(0);
		}
		if (number != null && number != "") {
			$(tr).find("td[name='price']").text(
					fmoney((money / number).toFixed(2), 0));
		} else {
			$(tr).find("td[name='price']").text(0);
		}

	}
	countAll();
}

function initexcise() {
	$("tr[name='add']").each(
			function(index, tr) {
				var money = rmoney($(tr).find("td[name='money']").text());
				var excise = $(tr).find("select[name='excise']").val() / 100;
				if (excise == 0) {
					$(tr).find("td[name='taxbreak']").text(0);
				}
				if (money != null && money != "" && excise != null
						&& excise != "") {
					$(tr).find("td[name='taxbreak']").text(
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

function countAll() {
	var sum = 0;
	var sum1 = 0;
	$("tr[name='add']").each(function(index, tr) {
		temp = rmoney($(tr).find("td[name='money']").text());
		if (temp == "" || temp == null) {
			temp = 0;
		}
		temp1 = rmoney($(tr).find("td[name='taxbreak']").text());
		if (temp1 == "" || temp1 == null) {
			temp1 = 0;
		}
		sum = digitTool.add(sum, parseFloat(temp));
		sum1 = digitTool.add(sum1, parseFloat(temp1));
	});
	var tr = $("#table2").find("#totalCount");
	$(tr).find("td[name='total']").text(fmoney(sum, 0));
	$(tr).find("td[name='totalexcisemoney']")
			.text(fmoney(sum1.toFixed(2), 0));
	var nexttr = $(tr).next();
	$("td[name='totalexcise']").text(
			fmoney((sum + sum1).toFixed(2), 0));
}

function initDatetimepicker() {
	$(".collectionDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$(".billDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
}

function openBargin() {
	$("#barginDialog").openBarginDialog();
}


function getBargin(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		
		$("#barginId").val(data.id);
		$("#barginProcessInstanceId").text(data.processInstanceId);
		$("#barginCode").text(data.barginCode);
		$("#barginName").text(data.barginName);
		$("#totalPay").text(data.totalMoney);
		if(data.projectManage != null && data.projectManage != ""){
			$("td[name=projectname]").text(data.projectManage.name);
			$("#projectManageId").val(data.projectManage.id);
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
	initInputBlur();
}


//查看合同详情
function viewBargin() {
	var barginProcessInstanceId = $("#barginProcessInstanceId").val();
	
	var url = "";
	if(barginProcessInstanceId != null && barginProcessInstanceId != ""){
		var param = {
				"processInstanceId": barginProcessInstanceId,
				"page": "manage/sale/barginManage/viewDetail"
			}
		url = web_ctx + "/activiti/process?" + urlEncode(param);
	}
	
	$("#barginDetailFrame").attr("src", url);
	$("#barginDetailModal").modal("show");
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
	html.push('	<td colspan="3" name="checkout"><input type="text" style="text-align:center;" name="collectionDate" class="collectionDate" value=""  readonly></td>');
	html.push('	<td colspan="3" contenteditable="true" >');
	html.push('<td colspan="3" style="text-align:center;" name="operation">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
	
}


//发票详情行
/*function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td><input type="text"  name="name" value="" > </td>');
	html.push('<td><input type="text"  name="model" value="" > </td>');
	html.push('<td><input type="text" name="unit" value=""  ></td>');
	html.push('<td><input type="text" name="number" value=""  onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="price" value="" onkeyup="coutmoney()"></td>');
	html.push('<td><input type="text" name="money" value=""  readonly></td>');
	html.push('<td><input type="text" name="excise" value=""  onkeyup="initexcise()" ></td>');
	html.push('<td  name="taxbreak"><input type="text" name="exciseMoney" value=""  onkeyup="initexcise()" ></td>');
	html.push('<td style="text-align:center;" name="operation">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}*/

function getAddHtml() {
	var html = [];
	html.push('<tr name="add">');
	html.push('<td contenteditable="true" ></td>');
	html.push('<td contenteditable="true" ></td>');
	html.push('<td contenteditable="true" ></td>');
	html.push('<td contenteditable="true" onkeyup="coutmoney()" name="number"></td>');
	html.push('<td name="price"></td>');
	html.push('<td name="money"></td>');
	html.push('<td><select name="excise" onchange="initexcise()">');
	html.push('<option selected="selected">0</option>');
	html.push('<option>6</option>');
	html.push('<option>17</option>');
	html.push('</select></td>');
	html.push('<td name="taxbreak"></td>');
	html.push('<td name="levied" onkeyup="coutmoney()" contenteditable="true"></td>')
	html.push('<td style="text-align:center;" name="operation">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	return html.join("");
}



function cancel(){
	cancelProcess();
}


function hiddenvalues(){
	 $("td[name='checkout']").each(function(index, td) {
		 $(this).attr("colSpan",5);
		});
	 $("td[name='taxbreak']").each(function(index, td) {
		 $(this).attr("colSpan",2);
			
		});
	 $("td[name='operation']").each(function(index, td) {
			$(this).addClass("hidden");
		});
	 $("tr[name='relevancy']").each(function(index, td) {
			$(this).addClass("hidden");
	 });
	 $("tr[name='showOrhidden']").each(function(index, td) {
			$(this).removeClass("hidden");
	 });
}

function showvalues(){
	 $("td[name='checkout']").each(function(index, td) {
		 $(this).attr("colSpan",3);
		});
	 $("td[name='taxbreak']").each(function(index, td) {
		 $(this).attr("colSpan",1);
		});
	 $("td[name='operation']").each(function(index, td) {
		 $(this).removeClass("hidden");
		});
	 $("tr[name='relevancy']").each(function(index, td) {
			$(this).removeClass("hidden");
	 });
	 $("tr[name='showOrhidden']").each(function(index, td) {
		 $(this).addClass("hidden");
	 });
}

function hiddenall(){
	bootstrapConfirm("提示", "执行此操作后无法再次更改表格，确定吗？", 300, function() {
		hiddenvalues();
		$("#button1")[0].style.display = 'none';
		$("#button2")[0].style.display = 'none';
		$("#button3")[0].style.display = 'none';
		 $("td").each(function(){
			 $(this).attr("contenteditable","false")
		 });
		 $("td").each(function(){
			 $(this).removeAttr("onclick");
		 });
		 $("textarea").attr("readonly","readonly");
		 $("select").attr("disabled","disabled");
		 $(".collectionDate").datetimepicker("disable").attr("readonly","readonly");
		 $(".billDate").datetimepicker("disable").attr("readonly","readonly");
	});
	
}


