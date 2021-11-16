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
#table td span {
	padding: 0px 6px;
}
#table th {
	text-align: center;
	font-size: 1.5em;
	font-weight: bold;
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
	}
	
	#table td.td_left {
		text-align: left;
	}
	
	#table2 {
		width: 96%;
		margin-top: 1em;
	}
	#table2 td {
		font-weight: 100; 
		font-size: 8pt;
		width: 13%;
	}
	.padding_left {
		padding-left: 1em;
	}
	#actReimburseTotal {
	font-weight: 100; 
	}
	#orderNo { 
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

	<table id="table">
		<thead>
			<tr><th id="" colspan="20" style="padding-bottom:0.5em;font-weight:300;">通用报销单<span id="orderNo" style="font-size:0.7em;float:right;right:2.5em;line-height:16pt;">(报销单号：${map.business.orderNo })</span></th></tr>
		</thead>
		<tbody>
			<tr>
				<td class="td_weight">报销人</td>
				<td id="name">${map.business.name }</td>
				<td class="td_weight">报销单位</td>
				<c:choose>
				<c:when test="${empty(map.business.dept.alias)}"> 
				<td colspan="2" id="title_name">${map.business.dept.name }</td>
				</c:when>
				<c:otherwise> 
				<td colspan="2" id="title_name"></td>
				</c:otherwise>
				</c:choose>
				<td class="td_weight">领款人</td>
				<td id="payee">${map.business.payee }</td>
				<td  class="td_weight">提交日期</td>
				<td  id="applyTime"><fmt:formatDate value="${map.business.applyTime }" pattern="yyyy年MM月dd日" /></td>
			</tr>
			<tr>
				<td class="td_weight" style="width:9%">日期</td>
				<td class="td_weight" style="width:6%">地点</td>
				<td class="td_weight" style="width:12%">项目</td>
				<td class="td_weight" style="width:19%">事由</td>
				<!-- <td class="td_weight" style="width:7%">金额</td>  -->
				<td class="td_weight" style="width:7%">实报</td>
				<td class="td_weight" style="width:9%">类别</td>
				<td class="td_weight" style="width:8%">费用归属</td>
				<td class="td_weight" colspan="10">明细</td>
			</tr>
			<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
				<tr name="node">
					<td><fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" /></td>
					<td>${business.place }</td>
					<td name="projectName">${business.project.name }</td>
					<td name="reason" class="td_left">${business.reason }</td>
					<%-- <td><fmt:formatNumber value='${business.money }' pattern='0.00' /></td> --%>
					<td name="actReimburse"><fmt:formatNumber value='${business.actReimburse }' pattern='0.00' /></td>
					<td name="type"><custom:getDictKey type="通用报销类型" value="${business.type }"/></td>
					<input type="hidden" name="type" value="${business.type }">
					<td>${business.invest.value }</td>
					<td name="detail" class="td_left" colspan ="10">${business.detail }</td>
				</tr>
			</c:forEach>
		<!-- 	<tr>
				<td colspan="2" class="td_right td_weight">实报金额：</td>
				<td colspan="2" id="costcn" class="td_left"></td>
				<td class="td_right td_weight">合计：</td>
				<td id="moneyTotal"></td>
				<td id="actReimburseTotal" colspan="22" class="td_left"></td>
				<td colspan="20"></td>
			</tr> -->
			<tr>
				<td class="td_right td_weight">实报金额：</td>
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
				<td  style="text-align:center;">领款人：</td>
			</tr>
		</tbody>
	</table>
</div>

<%@ include file="../../common/footer.jsp"%>
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
	initDecryption();
	updatereimbursetotal();
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

/*function updatereimbursetotal(){
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
}*/

function initMap() {
	$("#title_hidden").find("option").each(function(index, option) {
		titleMap[$(option).attr("value")] = $(option).text();
	});
}

function initPage() {
	var title = titleMap[$("#title_val").val()].split("");
	$("#title").prepend(title.join(" ") + " ");
	$("#title_name").prepend(title);

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
					}
				}
			});
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
</script>
</body>
</html>