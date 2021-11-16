<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<style>
body {
	background: none !important;
}
#table1 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table4 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table3 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table4 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table3 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table4 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}


#table4 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table3 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table2 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table3 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table4 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}



select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}


#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}

#table9 {
	width: 96%;
	margin: 0 auto;
	margin-top:8px;
	background-color: white;
}
#table9 td {
	font-weight: bold;
	font-size: 1em;
	
	width: 13%;
}
.td_left {
	text-align: left !important;
	white-space:pre-line;
}

</style>

</head>
<body>
				
<div class="tbspace">
	<input type="hidden" id="status" value="${map.business.status }">
	<input type="hidden" id="title_val" value="${map.business.title }">
	<input type="hidden" id="isInvoiced" value="${map.business.isInvoiced}">
	<select id="title_hidden" style="display:none;"><custom:dictSelect type="流程所属公司"/></select>
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class=" box-primary tbspace" >
					<form id="form1">
						<table id="table1">
								<thead>
										<tr><th colspan="20">睿哲科技收款单</th></tr>
								</thead>
								<tbody>
								<tr>
									<td style="width:15%;"><span>发起人</span></td>
									<td style="width:10%;">${map.business.applicant.name }</td>
									<td  style="width:10%;"><span>所属单位</span></td>
									 <c:choose>
              							  <c:when test="${empty(map.business.applicant.dept.alias)}">
                    							<td id="title_name">${map.business.applicant.dept.name }</td>
                						  </c:when>
                						  <c:otherwise>
                    							<td id="title_name"></td>
                						  </c:otherwise>
            						</c:choose>
									<td><span>提交时间</span></td>
									<td id="applyTime">
										<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />
									</td>
									<td><span>合同总金额</span></td>
									<td id="totalPay">
										<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00' />
									</td>
								</tr>
								<tr>
									<td><span>合同编号</span></td>
									<td>
										${map.business.barginManage.barginCode }
									</td>
									<td><span>合同名称</span></td>
									<td>
										${map.business.barginManage.barginName }
									</td>
									<td><span>项目名称</span></td>
									<input type="hidden" id="projectManageId"  name="projectId" value="${map.business.projectId }" readonly>
									<td colspan="4">
										${map.business.projectManage.name }
									</td>
								</tr>
								<tr>
									<td><span>申请金额</span></td>
									<td id="applyPay">
										<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />
									</td>	
									<td><span>申请比例</span></td>
									<td id="applyProportion">
										${map.business.applyProportion}
									</td>
									<td><span>付款单位</span></td>
									<td>
										${map.business.payCompany}
									</td>
									<td><span>开具发票</span></td>
									<td>
										<custom:getDictKey type="发票开具" value="${map.business.isInvoiced}"/>
									</td>
								</tr>
								<tr>
									<td><span>收款类型</span></td>
									<td colspan="12">
										<custom:getDictKey type="费用性质" value ="${map.business.collectionType }"/>
									</td>
								</tr>
								<tr>
										<td><span>备注</span></td>
										<td colspan="12">
											${map.business.reason }
										</td>
									</tr>
								<tr id="invoice">
									<td><span>开票金额</span></td>
									<td colspan="3"  id="bill">
										<fmt:formatNumber value='${map.business.bill}' pattern='0.00' />
									</td>
									<td><span>开票日期</span></td>
									<td colspan="3" id="billDate">
										<fmt:formatDate value="${map.business.billDate }" pattern="yyyy-MM-dd" />
									</td>
								</tr>
								<c:if test="${not empty map.business.collectionAttachList }">
								<%-- <tr>
									<td colspan="4" ><span>收款日期</span></td>
									<td colspan="4"><span>收款金额</span></td>
								</tr>
								<tbody id="node">
								
								<tr name="node">
									<td colspan="4" style="height:100%;text-align:center;">
										<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />
									</td>
									<td  colspan="4">
										${business.collectionBill}
									</td>
								</tr> --%>
								<c:forEach items="${map.business.collectionAttachList }" var="business" varStatus="varStatus">
								<tr name="node">
									<td><span>收款金额</span></td>
									<td colspan="3">
										<fmt:formatNumber value='${business.collectionBill}' pattern='0.00' />
									</td>
									<td><span>收款日期</span></td>
									<td colspan="3">
										<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />
									</td>
								</tr>
								</c:forEach>
								</c:if>
						</table>
						
						
					<%-- 	<c:if test="${map.business.isInvoiced eq '1'}"> --%>
						<table id="table2">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:10%;"><span>购货单位名称</span></td>
									<td style="width:15%;">${map.business.invoiced.payname}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;">${map.business.invoiced.paynumber}</td>
									<td><span>地址</span></td>
									<td colspan="4">${map.business.invoiced.payaddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;">${map.business.invoiced.payphone}</td>
								<td><span>开户行</span></td>
									<td>${map.business.invoiced.bankAddress}</td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="4">${map.business.invoiced.bankNumber}</td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td><span>规格型号</span></td>
									<td style="width:15%;"><span>单位</span></td>
									<td><span>数量</span></td>
									<td><span>单价</span></td>
									<td style="width:7.5%;"><span>金额</span></td>
									<td><span>税率</span></td>
									<td style="width:7.5%;"><span>税额</span></td>
									<td><span>税额小计</span></td>
								</tr>
								<c:forEach items="${map.business.invoicedAttachList }" var="invoiced" varStatus="varStatus">
								<tr name="add">
									<td>
										${invoiced.name}
									</td>
									<td>
										${invoiced.model}
									</td>
									<td>
										${invoiced.unit}
									</td>
									<td name="number">
										${invoiced.number}
									</td>
									<td name="price">
										${invoiced.price}
									</td>
									<td name="money">
										${invoiced.money}
									</td>
									<td name="excise">
										${invoiced.excise}
									</td>
									<td name="exciseMoney">
										${invoiced.exciseMoney}
									</td>
									<td name="levied">
										${invoiced.levied}
									</td>
								</tr>
								</c:forEach>
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td id="total"></td>
								<td></td>
								<td id="totalexcisemoney"></td>
								<td></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9" id="totalexcise"></td>
								</tr>
									<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;">${map.business.invoiced.collectionCompany}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;">${map.business.invoiced.collectionNumber}</td>
									<td><span>地址</span></td>
									<td colspan="4">${map.business.invoiced.collectionAddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;">${map.business.invoiced.collectionContact}</td>
								<td><span>开户行</span></td>
									<td>${map.business.invoiced.collectionBank}</td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="4">${map.business.invoiced.collectionAccount}</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<table id="table9">
				<tbody>
					<tr>
						<td id="fuhe">审核：</td>
						<td id="ceo"  style="text-align:center;">审批：</td>
						<td  style="text-align:center;">收款人：</td>
					</tr>
				</tbody>
			</table>
			</div>
		</div>
</div>

<%@ include file="../../common/footer.jsp"%>
<shiro:hasPermission name="fin:reimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript">

$(function(){
	initMap();
	initinvoiced();
	countAll();
})


function countAll() {
    var sum = 0;
    var sum1 = 0;
    $("tr[name='add']").each(function (index, tr) {
        temp = $(tr).find("td[name='money']").text();
        if (temp == "" || temp == null) {
            temp = 0;
        }
        temp1 = $(tr).find("td[name='exciseMoney']").text();
        if (temp1 == "" || temp1 == null) {
            temp1 = 0;
        }
        sum = digitTool.add(sum, parseFloat(temp));
        sum1 = digitTool.add(sum1, parseFloat(temp1));
    });
    $("#total").text(sum);
    $("#totalexcisemoney").text(sum1);
    $("#totalexcise").text(sum + sum1);
}

var titleMap = {};
function initMap() {
	$("#title_hidden").find("option").each(function(index, option) {
		titleMap[$(option).attr("value")] = $(option).text();
	});
}

function initinvoiced(){
	var title = titleMap[$("#title_val").val()].split("");
	$("#title").prepend(title.join(" ") + " ");
	$("#title_name").prepend(title);
	if($("#isInvoiced").val() == '1'){
		$("#table2").show();
		$("#invoice").show();
	}
	else{
		$("#table2").hide();
		$("#invoice").hide();
	}
}

</script>
</body>
</html>