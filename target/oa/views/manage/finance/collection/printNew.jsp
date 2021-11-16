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
	<input type="hidden" id="id" value="${map.business.id}">
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
									<td>
										${map.business.projectManage.name }
									</td>
								</tr>
								<tr>
									<td><span>总金额</span></td>
									<td>
										<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00'/>
									</td>
									<td><span>申请金额</span></td>
									<td id="applyPay">
										<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />
									</td>	
									<td ><span>渠道费用</span></td>
									<td>
										<fmt:formatNumber value='${map.business.channelCost}' pattern='0.00'/>
									</td>
								</tr>
								<tr>
									<td><span>提成基数</span></td>
									<td>
										${map.business.commissionBase}
									</td>
									<td><span>提成比例</span></td>
									<td>
										${map.business.commissionProportion}%
									</td>
									<td><span>分配额度</span></td>
									<td>
										${map.business.allocations}
									</td>
								</tr>
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
								</tr>
								<tr>
									<td><span>收款类型</span></td>
									<td>
										<custom:getDictKey type="费用性质" value ="${map.business.collectionType }"/>
									</td>
									<td><span>付款单位</span></td>
									<td>
										${map.business.payCompany}
									</td>
									<td><span>合同总金额</span></td>
									<td id="totalPay">
										<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00' />
									</td>
								</tr>
								<tr>
										<td><span>备注</span></td>
										<td colspan="12">
											${map.business.reason }
										</td>
									</tr>
								<c:if test="${not empty map.business.collectionAttachList }">
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
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 98%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">提成分配方案</span>
						</div>
							<table id="table2" style="text-align: center;width:98%;">
							<thead>
								<tr  name='node1' class='node1'>
								<td >参与人员</td>
								<td >提成比例</td>
								</tr>
							</thead>
							<tbody id="tableTbody" >
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
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
	//initMap();
	//initinvoiced();
	countAll();
	$.ajax({
	 	url: web_ctx + "/manage/finance/collectionMembers/getList",
		type: "post",
		data: {finCollectionId:$("#id").val()},
		dataType: "json",
		success: function(data) {
			for(var i=0;i<data.length;i++){
					$("#tableTbody").append("<tr name='node1' class='node1'><td style='width:50%'>"+data[i].sysUser.name+"</td><td style='width:50%'>"+data[i].commissionProportion+"%</td></tr>");
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
	var commissionProportion=$("input[name='commissionProportionParticipate']")
	var sum=0;
	for(var i=0;i<commissionProportion.length;i++){
		if(commissionProportion[i].value!=null && commissionProportion[i].value!=undefined && commissionProportion[i].value!=''){
			sum+=parseFloat(commissionProportion[i].value.replace(/%/g,''));
		}
	}
	$("#cumulative").html(sum+"%");
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