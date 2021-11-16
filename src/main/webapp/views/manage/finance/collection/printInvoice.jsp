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

#table2,#table5{
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

#table2 td input[type="text"] ,#table5 td input[type="text"]{
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

#table2 td span ,#table5 td span {
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

#table2 th ,#table5 th{
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

#table2 td ,#table5 td {
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
	<input type="hidden" id="title_val" value="${map.business.applyUser.dept.name }">
	<input type="hidden" id="id" value="${map.business.id}">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class=" box-primary tbspace" >
					<form id="form1">
						<table id="table1">
								<thead>
										<tr><th colspan="20">睿哲科技开票单</th></tr>
								</thead>
								<tbody>
								<tr>
									<td style="width:10%;"><span>申请人</span></td>
									<td style="width:20%;">${map.business.applyUser.name }</td>
									<td  style="width:10%;"><span>所属单位</span></td>
                    				<td>
                    				<custom:getDictKey type="流程所属公司" value="${map.business.applyUnit }"/>&nbsp;&nbsp;
                    				<c:choose>
											<c:when test="${empty(map.business.applyUser.dept.alias)}"> 
											<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.applyUser.dept.name}" readonly>
											</c:when>
											<c:otherwise>  
											<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.applyUser.dept.alias}" readonly>
											</c:otherwise>
											</c:choose>
										</td>
									<td><span>开票金额</span></td>
									<td colspan="3">
									<fmt:formatNumber value='${map.business.invoiceAmount}' pattern='0.00' />
									</td>
								</tr>
								<tr>
									<td><span>合同名称</span></td>
									<td>
										${map.business.barginManage.barginName }
									</td>
									<td><span>项目名称</span></td>
									<td>
										${map.business.saleProjectManage.name }
									</td>
									<td><span>开票时间</span></td>
									<td colspan="3">
										<fmt:formatDate value="${map.business.finInvoicedDate}" pattern="yyyy-MM-dd" />
									</td>
								</tr>
								<tr>
									<td><span>项目负责人</span></td>
									<td id="applyPay">
									${map.business.saleProjectManage.principal.name}
									</td>	
									<td><span>收票人</span></td>
									<td id="applyProportion">
										${map.business.ticketUser}
									</td>
									<td><span>收票电话</span></td>
									<td>
										${map.business.ticketPhone}
									</td>
									<td><span>寄送方式</span></td>
									<td>
										<select id="sendWay" name="sendWay"  style="width:100%;">
											<option value="0" <c:if test="${map.business.sendWay == '0'}"> selected </c:if>></option>
											<option value="1" <c:if test="${map.business.sendWay == '1'}"> selected </c:if>>邮送</option>
											<option value="2" <c:if test="${map.business.sendWay == '2'}"> selected </c:if>>亲送</option>
										</select>
									</td>
								</tr>
						</table>
						<table id="table2">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:10%;"><span>购货单位名称</span></td>
									<td style="width:15%;">${map.business.payname}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;">${map.business.paynumber}</td>
									<td><span>地址</span></td>
									<td colspan="4">${map.business.payaddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;">${map.business.payphone}</td>
								<td><span>开户行</span></td>
									<td>${map.business.bankAddress}</td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="4">${map.business.bankNumber}</td>
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
									<td style="width:15%;">${map.business.collectionCompany}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;">${map.business.collectionNumber}</td>
									<td><span>地址</span></td>
									<td colspan="4">${map.business.collectionAddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;">${map.business.collectionContact}</td>
								<td><span>开户行</span></td>
									<td>${map.business.collectionBank}</td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="4">${map.business.collectionAccount}</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
					<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
				</div>
					<table id="table5" style="text-align: center;width:98%;">
					<thead>
						<tr>
						<td >姓名</td>
						<td >业绩比例</td>
						<td >提成比例</td>
						</tr>
					</thead>
					<tbody id="tableTbody" >
					</tbody>
					<tbody>
					<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative1"></span></td><td><span id="cumulative"></span></td></tr>
					</tbody>
					</table>
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
	countAll();
	$("#table2").show();
	 //项目成员
    $.ajax({
	 	url: web_ctx + "/manage/finance/invoiceProjectMembers/getList",
		type: "post",
		data: {finInvoicedId:$("#id").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
					$("#tableTbody").append("<tr><td style='width:33%'>"+data[i].sysUser.name+"</td><td style='width:33%'><input type='text'  " +
									"name='resultsProportion' value='"+data[i].resultsProportion+"'" +
											"  title='0%' style='text-align:center' readonly/></td><td style='width:33%'><input type='text'  " +
									"name='commissionProportion' value='"+data[i].commissionProportion+"'" +
											"  title='0%' style='text-align:center' readonly/></td></tr>");
			}
			cumulative();
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
})
function cumulative(){
	var commissionProportion=$("input[name='commissionProportion']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
	
	var resultsProportion=$("input[name='resultsProportion']")
	var sum1=0;
	for(var i=0;i<resultsProportion.length;i++){
		if(resultsProportion[i].value!=null && resultsProportion[i].value!=undefined && resultsProportion[i].value!=''){
			sum1+=parseFloat(resultsProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative1").html(sum1+"%");
}

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

</script>
</body>
</html>