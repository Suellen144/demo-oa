/******************************
 * 		全局变量		  	 	  *
 ******************************/
var fileData = null; // 选择文件后的文件数据变量
var urlParam = ""; // 文件上传URL参数
var projectObj = null; // 选择项目后的对象
var maxDate = null; // 餐费补贴的最大日期
var minDate = null;
var type2html = { // 新增节点时，根据类型获取生成HTML的函数
	"intercityCost": getHtmlForIntercityCost,
	"stayCost": getHtmlForStayCost,
	"cityCost": getHtmlForCityCost,
	"receiveCost": getHtmlForReceiveCost,
	"subsidy": getHtmlForSubsidy
};
var type2value = { // 每个大类节点对应的类型代码
	"intercityCost": "0",
	"stayCost": "1",
	"cityCost": "2",
	"receiveCost": "3",
	"subsidy": "4"
};
var validElements = { // 不同大类节点所需验证的表单元素
	"0": {
		"date": 0,
		"startPoint": 0,
		"destination": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"1": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"2": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"3": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0
		"reason": 0,
		"costWithAct": 0
	},
	"4": {
		"beginDate": 0,
		"endDate": 0,
		"foodSubsidy": 0,
		"trafficSubsidy": 0,
		"reason": 0,
		"projectId": 0
	}
};
var validElementsZh = { // 验证的表单元素对应的中文名
	"date": "日期",
	"place": "地点",
	"startPoint": "出发地",
	"destination": "目的地",
	"projectId": "项目",
	"cost": "费用",
	"actReimburse": "实报",
	"beginDate": "出发日期",
	"endDate": "离开日期",
	"foodSubsidy": "餐费补贴",
	"trafficSubsidy": "交通补贴",
	"reason": "事由",
	"costWithAct": "费用与实报"
};


$(function() {
	initNode();
	initDialog();
	initSelect();
/*	initFileUpload();*/
	initInputKeyUp();
	initSubTotal();
	initcollapse();
	hidecollapse();
	if($("#travelId").val() != ""){
		$("#viewTravelBtn").show();
	}
	
	$("tfoot").find("input[type='button']").removeAttr('onclick');
});

// 转换数字为中文大写
function converDigit(value) {
	var res = digitUppercase(value);
	$("#bigcost").val(res);
}

//某项无填写则隐藏
function hidecollapse(){
	$("div.tittle").each(function(index,tab){
		if($(tab).find("table").find("tr[name='node']").length<=0){
			$(tab)[0].style.display='none';
		}
	});
}
/******************************
 * 		表单相关函数		  	  *
 ******************************/

function save() {
	var formData = getFormData();
	
	openBootstrapShade(true);

	$.ajax({
		url: "unbound",
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

// 获取表单数据
function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["travelreimburseAttachList"] = [];
	
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("intercityCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("stayCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("cityCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("receiveCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("subsidy"));
	formData["id"]= $("#id").val();
	
	return formData;
}
function getBranchFormData(id) {
	var json = [];
	
	$("#"+id).find("tr[name='node']").each(function(index, tr) {
		var tempJson = {};
		$(tr).find("input,select,textarea").each(function(index, ele) {
			var name = $(ele).attr("name");
			var value = $(ele).val();
			if(!isNull(name) && !isNull(value)) {
				if(name != null && name != "" && name == "id"){
					tempJson[name] = parseInt(value);
				}else{
					tempJson[name] = value;
				}
				
			}
		});
		if(!$.isEmptyObject(tempJson)) {
			if(type2value[id] == "0" && Object.getOwnPropertyNames(tempJson).length == 1) {
				return ;
			} else {
				tempJson["type"] = type2value[id];
				json.push(tempJson);
			}
		}
	});
	
	return json;
}

/******************************
 * 		普通操作相关函数		  *
 ******************************/
function openProject(obj, tab) {

	if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = null;
		if( tab != "intercityCost"
			&& $(obj).parents("tr[name='node']").prev().length <= 0
			&& isNull($($(obj).parents("tr[name='node']").prev()).find("textarea[name='projectName']").val())
			&& !isNull($("#intercityCost").find("tr[name='node']:first").find("textarea[name='projectName']").val()) ) {
			tr = $("#intercityCost").find("tr[name='node']:first");
		} else {
			tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		}

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
		$(projectObj).siblings("input[name='projectId']").val(data.id);
		$(projectObj).val(data.name);
	}
}





function initcollapse(){
	$('#intercityCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[0].style.display ="none";
	});
	
	$('#intercityCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[0].style.display ="block";
	});
	
	$('#stayCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[1].style.display ="none";
	});
	
	$('#stayCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[1].style.display ="block";
	});
	
	$('#cityCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[2].style.display ="none";
	});
	
	$('#cityCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[2].style.display ="block";
	});
	
	$('#receiveCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="none";
	});
	
	$('#receiveCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="block";
	});
	
	$('#subsidy').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[4].style.display ="none";
	});
	
	$('#subsidy').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[4].style.display ="block";
	});
	

}

// 城际交通费用节点
function getHtmlForIntercityCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push('	<td style="width: 8%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push('	<td style="width: 6%;"><input type="text" name="startPoint"></td>');
	html.push('	<td style="width: 6%;"><input type="text" name="destination"></td>');
	html.push('	<td style="width: 6%;"><select name="conveyance" style="width:100%;">'+$("#conveyance_hidden").html()+'</select></td>');
	html.push('	<td style="width: 12%;"><input type="hidden" name="projectId"><textarea  name="projectName" onclick="openProject(this, \'intercityCost\')" readonly></textarea></td>');
	html.push('	<td style="width: 5%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push('	<td style="width: 5%;"><input type="text" name="actReimburse" style="text-align:right;"  ></td>');
	html.push('	<td style="width: 18%;"><textarea name="reason" onfocus="reasonChange(this, \'intercityCost\')"></textarea></td>');
	html.push('	<td><textarea name="detail" colspan="2"></textarea></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 住宿费用节点
function getHtmlForStayCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 7.3%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 12%;"><input type="hidden" name="projectId"><textarea  name="projectName" onclick="openProject(this, \'stayCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 5%;"><input type="text" name="dayRoom"></td>');
	html.push(' <td style="width: 5%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 5%;"><input type="text" name="actReimburse" style="text-align:right;" ></td>');
	html.push(' <td style="width: 15%;"><textarea name="reason" onfocus="reasonChange(this, \'stayCost\')"></textarea></td>');
	html.push(' <td style="width: 30%;" colspan="2"><textarea name="detail"></textarea></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 市内交通费用节点
function getHtmlForCityCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 8%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'cityCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;" ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 25%;"><textarea  name="reason" onfocus="reasonChange(this, \'cityCost\')"></textarea></td>');
	html.push(' <td style="width: 25%;" colspan="2"><textarea name="detail"></textarea></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 接待餐费节点
function getHtmlForReceiveCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 8%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'receiveCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;" ></td>');
	html.push(' <td style="width: 20%;"><textarea name="reason" onfocus="reasonChange(this, \'receiveCost\')"></textarea></td>');
	html.push(' <td style="width: 30%;" colspan="2"><textarea name="detail"></textarea></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 补贴节点
function getHtmlForSubsidy() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 8%; border-left-style:hidden;"><input type="text" name="beginDate" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 9%;"><input type="text" name="endDate" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="foodSubsidy" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="trafficSubsidy" style="text-align:right;" ></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea  name="projectName" onclick="openProject(this, \'subsidy\')" readonly></textarea></td>');
	html.push(' <td style="width: 20%;"><textarea name="reason" onfocus="reasonChange(this, \'subsidy\')"></textarea></td>');
	html.push(' <td style="width: 30%;" colspan="2"><textarea type="text" name="detail"></textarea></td>');
	html.push('</tr>');
	
	return html.join("");
}

// 更新小计
function updateSubTotal(obj) {
	var tbody = $(obj).parents("tbody:first");
	var name = $(obj).attr("name");

	var total = 0;
	$(tbody).find("tr[name='node']").find("input[name='"+name+"']").each(function(index, input) {
		var value = $(input).val();
		if(!isNull(value)) {
			total = digitTool.add(total, parseFloat(value));
		}
	});
	
	$(tbody).find("tr[name='subTotal']").find("input[name='"+name+"Total']").val(total != 0 ? total : "");
}

// 更新总计
function updateTotal() {
	var total = 0.0;
	$("tr[name='node']").find("input[name='foodSubsidy'],input[name='trafficSubsidy']").each(function(index, input) {
		var value = $(input).val();
		if(!isNull(value)) {
			total = digitTool.add(total, parseFloat(value));
		}
	});
	
	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		var value = "";
		if( !isNull(actReimburse) ) {
			value = actReimburse;
		} else {
			value = $(tr).find("input[name='cost']").val();
		}
		
		if(isNull(value)) {
			value = "0";
		}
		total = digitTool.add(total, parseFloat(value));
	});
	
	if(total != 0) {
		$("#total").val(total);
		$("#totalcn").val(digitUppercase(total)); // 将总计数字转换为中文大写
		$("#Total").text(total);
		$("#Totalcn").text(digitUppercase(total));
	} else {
		$("#total").val("");
		$("#totalcn").val("");
		$("#totalcn").text("");
		$("#Totalcn").text("");
	}
}





/******************************
 * 		各类初始化相关函数		  *
 ******************************/


// 初始化弹出选择框
function initDialog() {

	
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});	
	
}

// 初始化select2控件（收款人、银行卡号、开户行地址）
function initSelect() {
	var isDigit = /^\d+(\d\s)?.*\d+$/;
	$(".select2").select2({ tags: true, allowClear: true, placeholder: "请选择一项或输入值后回车" });
	$(".select2").on("select2:select", function(evt) {
		var name = $(this).prev("input[type='hidden']").attr("name");
		if(name == "bankAccount") {
			var selValue = $(this).val();
			if(!isNull(selValue) && isDigit.test(selValue)) {
				$(this).prev("input[type='hidden']").val(selValue);
			} else {
				$(this).prev("input[type='hidden']").val("");
				$(this).select2('val', '');
			}
		} else {
			$(this).prev("input[type='hidden']").val($(this).val());
		}
	});
	
	$(".select2").on("change", function(evt) {
		var selValue = $(this).val();
		if(isNull(selValue)) {
			$(this).prev("input[type='hidden']").val("");
		}
	});
	
	$("#payee").next(".select2").trigger('select2:select');
	$(".select2-selection__rendered").css("text-align", "left");
}

// 初始化输入框按键弹起事件
function initInputKeyUp() {
	$("input[name='cost'],input[name='actReimburse']," +
			"input[name='foodSubsidy'],input[name='trafficSubsidy']").bind("keyup", function() {
		updateSubTotal(this); // 更新小计数据
		updateTotal(); // 更新总计数据
	});
	
	$("input[name='cost']").blur(function() {
		costBlur(this);
	});
}
//初始化小计
function initSubTotal() {
	$("input[name='cost'],input[name='actReimburse']," +
	"input[name='foodSubsidy'],input[name='trafficSubsidy']").trigger("keyup");
}


function initNode() {
	var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy"];
	$(elements).each(function(index, ele) {
		var nodes = $("#"+ele).find("tr[name='node']");
		if(!isNull(nodes) && nodes.length > 0) {
			$(nodes).each(function(index, node) {
				var td = $(node).find("td:last");
			
			});
		}
	});
	
}


// 自动计算补贴
function calSubsidy(obj) {
	var tr = $(obj).parents("tr");
	var foodSubsidy = $(tr).find("input['foodSubsidy']").val();
	var trafficSubsidy = $(tr).find("input['trafficSubsidy']").val();
	
	// 都有值，则不用计算
	if( !isNull(foodSubsidy) && !isNull(trafficSubsidy) ) {
		return ;
	}
}