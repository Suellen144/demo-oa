<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<style>
body {
	background: none !important;
}
#table {
	table-collapse: collapse;
	border: none;
	width: 96%;
	margin: 0 auto;
}
#table td {
	border: solid #999 1px;
	padding: 5px;
	word-break: break-all;
	text-align: center;
}

select{
   appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}



#table td input[type="text"]{
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align:center;
}

#table td span {
	padding: 0px 6px;
}
#table th {
	text-align: center;
	font-size: 1.5em;
	/* font-weight: bold; */
}

.td_weight {
	/* font-weight: bold; */
	text-align: center;
}

#table2 {
	width: 96%;
	margin: 0 auto;
	margin-top: 1.3em;
}
#table2 td {
	/* font-weight: bold; */
	font-size: 1em;
	width: 13%;
}
.td_left {
	text-align: left !important;
	white-space:pre-line;
}


/******** 打印机样式 ********/
@media print {
	/* portrait： 纵向打印       landscape: 横向 打印  */
	@page {
		size: A5 landscape;
		/* margin: 2cm 0cm 1.4cm 3cm; */
	}
	
	* {
		text-shadow: none !important;
		box-shadow: none !important;
	}
	
	body {
	  	background-color: #FFF;
	  	background-image: none;
	  	width: 100%;
     	margin: 0;
		padding: 0;
	}
	
	#table {
		width: 98%;
		table-collapse: collapse;
		border: none;
		padding: 0;
		margin: 0;
	}
	#table tr {
		/* page-break-after: always; */
		/* page-break-after: avoid; */
	}
	#table th {
		text-align: center;
		/* font-weight: bold; */
		font-size: 12pt;
	}
	#table td {
		font-family: 宋体;
		font-size: 8pt !important;
		border: solid #999 0.5pt;
		padding: 1pt;
		word-break: break-all;
		word-wrap: break-word;
		text-align: center;
	}
	#table td span {
		font-weight: 100;
		padding: 0pt 1pt;
	}
	
	#table th {
		text-align: center;
		/* font-weight: bold; */
		font-size: 12pt;
		font-weight: 100;
	}
	#table td.td_left {
		text-align: left;
	}
	
	#table2 {
		width: 96%;
		margin-top: 1em;
	}
	#table2 td {
		/* font-weight: bold; */
		font-size: 8pt;
		width: 13%;
	}
	.padding_left {
		padding-left: 1em;
	}
	#actReimburseTotal {
	font-weight: 100;
	}
	#costcn {
	font-weight: 100;
	}
}
</style>
</head>
<body>
				
<div class="tbspace">
	<input type="hidden" id="status" value="${map.business.status }">
	<input type="hidden" id="title_val" value="${map.business.title }">
	<input type="hidden" id="encrypted" value="${map.business.encrypted }">
	<select id="title_hidden" style="display:none;"><custom:dictSelect type="流程所属公司"/></select>
	<select id="type_hidden" style="display:none;"><custom:dictSelect type="通用报销类型"/></select>
	<button type="button" id="button1" onclick="hiddenvalues()">隐藏</button>
	<button type="button" id="button2" onclick="showvalues()">显示</button>
	<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>
	<table id="table">
		<thead>
			<tr><th id="" colspan="20" style="padding-bottom:0.5em;font-weight:300;">通用报销单</th></tr>
		</thead>
		<tbody>
			<tr>
				<td class="td_weight"><span>报销人</span></td>
				<td id="name">${map.business.name }</td>
				<td class="td_weight"><span>报销单位</span></td>
				<c:choose>
				<c:when test="${empty(map.business.dept.alias)}"> 
				<td colspan="2" id="title_name">${map.business.dept.name }</td>
				</c:when>
				<c:otherwise> 
				<td colspan="2" id="title_name"></td>
				</c:otherwise>
				</c:choose>
				<td class="td_weight"><span>领款人</span></td>
				<td id="payee">${map.business.payee }</td>
				<td  class="td_weight"><span>提交日期</span></td>
				<td colspan="" id="applyTime"><fmt:formatDate value="${map.business.applyTime }" pattern="yyyy年MM月dd日" /></td>
			</tr>
			<tr>
				<td class="td_weight" style="width:9%"><span>日期</span></td>
				<td class="td_weight" style="width:6%"><span>地点</span></td>
				<td class="td_weight" style="width:12%"><span>项目</span></td>
				<td class="td_weight" style="width:19%"><span>事由</span></td>
				<td class="td_weight" style="width:7%"><span>实报</span></td>
				<td class="td_weight" style="width:9%"><span>类别</span></td>
				<td class="td_weight" colspan="10"><span>明细</span></td>
				<td class="td_weight" name="operation"><span>操作</span></td>
			</tr>
			<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
				<tr name="node">
					<td>
						<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
					</td>
					<td contenteditable="true">${business.place }</td>
					<td contenteditable="true" name="projectName">${business.project.name }</td>
					<td contenteditable="true" name="reason" class="td_left">${business.reason }</td>
					<td contenteditable="true"  name="actReimburse"><fmt:formatNumber value='${business.actReimburse }' pattern='0.00' /></td>
					<td>
						<select name="type" value="${business.type }">
							<custom:dictSelect type="通用报销类型"
								selectedValue="${business.type }" />
						</select>
					</td>
					<input type="hidden" name="type" value="${business.type }">
					<td contenteditable="true" name="detail" class="td_left" colspan ="10">${business.detail }</td>
					<td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
				</tr>
			</c:forEach>
			<tr>
				<td class="td_right td_weight"><span>实报金额：</span></td>
				<td colspan="18">
				<div style="display:flex">
				<div style="display:flex">
				<span style="padding-right: 2px;">¥</span>
				<div id="actReimburseTotal"></div>
				</div>
				<div>
				(
					<span id="costcn"></span>
				 ) 
				</div>
				</div>
				</td>
		</tr>
		</tbody>
	</table>
	
	<table id="table2">
		<tbody>
			<tr>
				<td id="fuhe">审核：</td>
				<td id="ceo"  style="text-align:center;">审批：</td>
				<td style="text-align:center;">领款人：</td>
			</tr>
		</tbody>
	</table>
</div>

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<shiro:hasPermission name="fin:reimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>

<script>
var hasDecryptPermission = false;
<shiro:hasPermission name="fin:reimburse:decrypt">
	hasDecryptPermission = true;
</shiro:hasPermission>
	
var variables = ${map.jsonMap.variables};
var titleMap = {};

$(function() {
	initMap();
	initPage();
	initDatetimepicker();
	edit();
	initDecryption();
});


/*用于报销项目去重*/
function unique(array){
	  var n = []; //一个新的临时数组
	  //遍历当前数组
	  for(var i = 0; i < array.length; i++){
	    //如果当前数组的第i已经保存进了临时数组，那么跳过，
	    //否则把当前项push到临时数组里面
	    if (n.indexOf(array[i]) == -1) n.push(array[i]);
	  }
	  return n;
}

function updatereimbursetotal(){
	var cost = []; //项目费用数据
	var receive = [];
	var other = [];
	var projectName = [];	
	var temp = [];
	var key; 	 //项目索引Key
	var sum = [];
	//差旅统计map
	var costmap = {};
	//招待统计map
	var receivemap = {};
	//其他统计map
	var othermap = {};
	costmap["key"] = "value";
	receivemap["key"] = "value";
	sum.push("<tr>")
	sum.push("<td colspan='2'>项目</td>")
	sum.push("<td colspan='2'>差旅统计</td>")
	sum.push("<td colspan='3'>招待统计</td>")
	sum.push("<td colspan='3'>其它费用统计</td>")
	sum.push("</tr>")
	$("tr[name='node']").each(function(index, tr) {
		 project = $(tr).find("td[name='projectName']").text();
		 if(project != ""){
			 temp.push(project);
		 }
	});
	projectName = unique(temp);

	$("tr[name='node']").each(function(index, tr) {
		 project = $(tr).find("td[name='projectName']").text();
		 actReimburse = $(tr).find("td[name='actReimburse']").text(); 
		 type = $(tr).find("input[name='type']").val(); 
		 if (type == "4") {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(costmap[key] == undefined){
				 costmap[key] = cost[index];
			 }
			 else {
				 total = digitTool.add(costmap[key],cost[index]);
				 costmap[key] = total;
			 }
		}
		 else if (type == "2" || type == "1") {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(receivemap[key] == undefined){
				 receivemap[key] = receive[index];
			 }
			 else {
				 total = digitTool.add(receivemap[key],receive[index]);
				 receivemap[key] = total;
			 }
		}
		 else {
			 key = project;
			 cost.push(actReimburse);
			 receive.push(actReimburse);
			 other.push(actReimburse);
			 if(othermap[key] == undefined){
				 othermap[key] = other[index];
			 }
			 else {
				 total = digitTool.add(othermap[key],other[index]);
				 othermap[key] = total;
			 }
		}
	});
	
	$(projectName).each(function(index,value){
		sum.push("<tr>")
		sum.push("<td colspan='2'>"+value+"</td>");
		if(costmap[value] == undefined){
			sum.push("<td colspan='2'>"+'0.00'+"</td>");
		}
		else {
			sum.push("<td  colspan='2'>"+parseFloat(costmap[value]).toFixed(2)+"</td>");
		}
		if(receivemap[value] == undefined){
			sum.push("<td  colspan='3'>"+'0.00'+"</td>");
		}
		else{
			sum.push("<td  colspan='3'>"+parseFloat(receivemap[value]).toFixed(2)+"</td>");
		}
		if(othermap[value] == undefined){
			sum.push("<td  colspan='3'>"+'0.00'+"</td>");
		}
		else{
			sum.push("<td  colspan='3'>"+parseFloat(othermap[value]).toFixed(2)+"</td>");
		}
		sum.push("</tr>")
	});
	$("#table").append(sum);
}


function hiddenvalues(){
	 $("td[name='operation']").each(function(index, td) {
			td.style.display = "none";
		});
}

function showvalues(){
	 $("td[name='operation']").each(function(index, td) {
			td.style.display = "";
		});
}

function hiddenall(){
	bootstrapConfirm("提示", "执行此操作后无法再次更改表格，确定吗？", 300, function() {
		hiddenvalues();
		$("#button1")[0].style.display = 'none';
		$("#button2")[0].style.display = 'none';
		$("#button3")[0].style.display = 'none';
/* 		updatereimbursetotal(); */
	});
	
}


function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
		var firstTr = $("tbody").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
			$(this).trigger("keyup");
		});
		actReimburseCount();
	} else {
		var html;
			html = getNodeHtml();
		}
		$(obj).parents("tr").after(html);
		initDatetimepicker();
		edit();
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td><input type="text" class="datetimepick"  name="date" readonly></td>');
	html.push('<td name="place" contenteditable="true"></td>');
	html.push('<td name="projectName" contenteditable="true"></td>');
	html.push('<td name="reason" style="text-align:left" contenteditable="true"></td>');
	html.push('<td name="actReimburse" contenteditable="true"></td>');
	html.push('<td>');
	html.push('<select name="type">');
	html.push($("#type_hidden").html());
	html.push('</select>');
	html.push('</td>');
	html.push('<td style="text-align:left" colspan="10" name="detail" contenteditable="true"></td>');
	html.push('<td name="operation">');
	html.push('<a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'add\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a>  <a href="javascript:void(0);" style="font-size:x-large" onclick="node(\'del\', this)"><img alt="删除" src="'+base+'/static/images/del.png"></a>');
	html.push('</td>');
	html.push('</tr>');
	
	return html.join("");
}

function initDatetimepicker() {
	$("input.datetimepick").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		toDay: true,
		bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}


function edit(){
	$("tr[name='node']").find("td[name='money'],td[name='actReimburse']").bind("keyup", function() {
	actReimburseCount(); // 更新总计数据
	});
}

function toUppercase(value) {
	if(!isNull(value)) {		
		$("#costcn").val(digitUppercase(value));
		$("#cost").val(value);
	} else {
		$("#costcn").val("零元整");
		$("#cost").val("0");
	}
}


function actReimburseCount() {
	var count = 0;
	var total = 0;
	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("td[name='actReimburse']").text();
		var value = "";
		if( !isNull(actReimburse) ) {
			value = actReimburse;
			total = digitTool.add(total, parseFloat(value));
		} else {
			value = $(tr).find("td[name='money']").text();
			total = digitTool.add(total, parseFloat(value));
		}
		
		if(isNull(value)) {
			value = "0";
		}
		count = digitTool.add(count, parseFloat(value));
	});
	
	if(total == 0) {
		$("#actReimburseTotal").text("");
	} else {
		$("#actReimburseTotal").text(total.toFixed(2));
	}
	toUppercase(total);
}

function initMap() {
	$("#title_hidden").find("option").each(function(index, option) {
		titleMap[$(option).attr("value")] = $(option).text();
	});
}

function initPage() {
	var title = titleMap[$("#title_val").val()].split("");
	$("#title").prepend(title.join(" ") + " ");
	$("#title_name").prepend(title);
	$("#title_name").prop("contenteditable","true");
	$("#name").prop("contenteditable","true");
	$("#payee").prop("contenteditable","true");
	$("#applyTime").prop("contenteditable","true");

	toUppercase($("#total").text());
	
	// 初始化合计与实报金额
	var moneyTotal = 0;
	var actReimburseTotal = 0;
	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $("td:eq(4)", tr).text();

		if(!isNull(actReimburse)) {
			actReimburseTotal = digitTool.add(actReimburseTotal, parseFloat(actReimburse)).toFixed(2);
		}
	});
	
	$("#actReimburseTotal").text(actReimburseTotal);
	toUppercase(actReimburseTotal);
	
	var status = $("#status").val();
	// 初始化签名
	var node2td = {
		"总经理": (status == "3" || status == "4" || status == "11") ? "" : "ceo",
		"复核": (status == "3" || status == "11") ? "" : "fuhe",
		"部门经理": "manager"
	};
/* 	$(variables.commentList).each(function(index, comment) {
		if( !isNull(comment["node"]) && !isNull(node2td[comment["node"]]) ) {
			if(node2td[comment["node"]] == "ceo")
			{
				$("#" + node2td[comment["node"]]).text("审批人"+"："+comment["approver"]);
			}
			else
			{
				$("#" + node2td[comment["node"]]).text(comment["node"]+"："+comment["approver"]);
			}
		}
		
	
	}); */
}

function toUppercase(value) {
	if(!isNull(value)) {
		$("#costcn").text(digitUppercase(value));
	} else {
		$("#costcn").text("零元整");
	}
}

//如果有解密权限，则解密当前已加密的数据
function initDecryption() {
	if( 'y' == $("#encrypted").val() ) {
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
}
function encryptPageText(encryptionKey) {
	$("td[name='reason'],td[name='detail']").each(function(index, td) {
		var val = $(td).text();
		try {
			val = aesUtils.decryptECB(val, encryptionKey);
			if( !isNull(val) ) {
				$(td).text(val);
			}
		} catch(e) {}
	});
}
function disabledEncryptPageText() {
	/* $("tr[name='node']").each(function(index, tr) {
		$(tr).find("td[name='reason']").prop("contenteditable", false);
		$(tr).find("td[name='detail']").prop("contenteditable", false);
	}); */
}
</script>
</body>
</html>