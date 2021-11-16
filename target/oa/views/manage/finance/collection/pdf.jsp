<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
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
	margin-top:20px;
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
.hidden{
	display: none;
}
</style>
</head>
<body>
<div class="wrapper">
	<!-- Main content -->
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class=" box-primary tbspace">
					<form id="form1">
						<input type="hidden" id="barginProcessInstanceId" value="${map.business.barginManage.processInstanceId}">
						<button type="button" id="button1" onclick="hiddenvalues()">隐藏</button>
						<button type="button" id="button2" onclick="showvalues()">显示</button>
						<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>
						<table id="table1">
							<thead>
								<tr><th colspan="20">睿哲科技收款单</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:15%;"><span>发起人</span></td>
									<td style="width:10%;">${map.business.applicant.name }</td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
											<div style="float: left;height:20px;font-size: 15px;">
												<div style="float: left;">
												<select name="title"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
												</div>
												<div style="float: left;width:50px;height:20px;font-size: 15px;">
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${map.business.applicant.dept.name }" readonly>
													</c:if>
												</div>
												<div style="clear: both"></div>
											</div>
									</td>
									<td><span>提交时间</span></td>
									<td>
										<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />
									</td>
									<td><span>合同总金额</span></td>
									<td id="totalPay" contenteditable=true onkeyup="initInputBlur()">
										<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00' />
									</td>
								</tr>
								<tr>
									<input type="hidden" id="barginId">
									<td><span>合同编号</span></td>
									<td id ="barginCode">
										${map.business.barginManage.barginCode }
									</td>
									<td><span>合同名称</span></td>
									<td id ="barginName">
										${map.business.barginManage.barginName }
									</td>
									<td><span>项目名称</span></td>
									<td colspan="4" onclick="openProject(this)" name="projectname">
										${map.business.projectManage.name }
									</td>
									<input type="hidden" id="projectManageId"  name="projectId" value="${map.business.projectId }" readonly>
								</tr>
								<tr>
									<td><span>申请金额</span></td>
									<td contenteditable=true id="applyPay" onkeyup="initInputBlur()">
										<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />
									</td>	
									<td><span>申请比例</span></td>
									<td id="applyProportion">
										${map.business.applyProportion}
									</td>
									<td><span>付款单位</span></td>
									<td contenteditable=true>
										${map.business.payCompany}
									</td>
									<td><span>开具发票</span></td>
									<td>
										<select name="isInvoiced" id="isInvoiced" style="width:100%;" onchange = "initinvoiced(this)" value="${map.business.isInvoiced}">
											<custom:dictSelect type="发票开具" selectedValue="${map.business.isInvoiced}" />	
										</select>
									</td>
								</tr>
								<tr name="relevancy">
									<td><span>收款类型</span></td>
									<td colspan="1" style="text-align:left;">
										<select  style="width: 100%" name="collectionType"><custom:dictSelect type="费用性质" selectedValue="${map.business.collectionType }"/></select>
									</td>
									<td><span>关联合同</span></td>
									<td colspan="10" style="text-align:left;">
									<input type="button" value="请选择合同" onclick="openBargin()" style="border:none;">
									<!-- <input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;"> -->
									</td>
								</tr>
									<tr name="showOrhidden" class="hidden">
									<td><span>收款类型</span></td>
									<td colspan="20" style="text-align:left;">
										<select  style="width: 100%" name="collectionType"><custom:dictSelect type="费用性质" selectedValue="${map.business.collectionType }"/></select>
									</td>
								</tr>
								<tr>
										<td><span>备注</span></td>
										<td colspan="12" contenteditable=true>
											${map.business.reason }
										</td>
								</tr>
								</tbody>
								<tr id="invoice">
									<td ><span>开票金额</span></td>
									<td colspan="3" contenteditable=true>
										<fmt:formatNumber value='${map.business.bill}' pattern='0.00' />
									</td>
									<td><span>开票日期</span></td>
									<td colspan="3" id="billDate" name="billDate" >
										<input type="text" id="billDate" name="billDate" class="billDate" placeholder="必填项" readonly value="<fmt:formatDate value="${map.business.billDate }" pattern="yyyy-MM-dd" />" ></input>
									</td>
								</tr>
								<tr>
									<td  colspan="3" name="checkout"><span>收款日期</span></td>
									<td  colspan="3"><span>收款金额</span></td>
									<td  colspan="3" name="operation"><span>操作</span></td>
								</tr>
								<tbody id="node">
								<c:if test="${not empty map.business.collectionAttachList }">
								<c:forEach items="${map.business.collectionAttachList }" var="business" varStatus="varStatus">
								<tr name="node">
									<input type="hidden" name="businessId" value="${business.id}" readonly>
									<td colspan="3" style="height:100%;text-align:center;" name="checkout" >
											<input type="text" style="text-align:center;" id="collectionDate"  name="collectionDate" class="collectionDate" 	value="<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />"   readonly>
									</td>
									<td  colspan="3" style="text-align:center;" onkeyup = "initCompareBillWithBillCollection()" contenteditable=true>
										${business.collectionBill}
									</td>
									<td colspan="3" style="text-align:center;" name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)">
									<img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
								</tr>
								</c:forEach>
								</c:if>
								<c:if test="${empty map.business.collectionAttachList }">
								<tr name="node">
									<input type="hidden" name="businessId" value="${business.id}" readonly>
									<td colspan="3" style="height:100%;text-align:center;" name="checkout" >
										<input type="text" style="text-align:center;" id="collectionDate"  name="collectionDate" class="collectionDate" 	value="<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />"   readonly>
									</td>
									<td  colspan="3" style="text-align:center;" name="collectionBill" onkeyup = "initCompareBillWithBillCollection()" contenteditable=true> 
									</td>
									<td colspan="3" style="text-align:center;" name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)">
									<img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
								</tr>
								</c:if>
								</tbody>
						</table>
						
						
					<%-- 	<c:if test="${map.business.isInvoiced eq '1'}"> --%>
						<table id="table2">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:10%;"><span>购货单位名称</span></td>
									<td style="width:15%;" contenteditable=true>${map.business.invoiced.payname}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;" contenteditable=true>${map.business.invoiced.paynumber}</td>
									<td><span>地址</span></td>
									<td colspan="5" contenteditable=true>${map.business.invoiced.payaddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;" contenteditable=true>${map.business.invoiced.payphone}</td>
								<td><span>开户行</span></td>
								<td contenteditable=true>${map.business.invoiced.bankAddress}</td>
								<td style="width:15%;"><span>账号</span></td>
								<td colspan="5" contenteditable=true>${map.business.invoiced.bankNumber}</td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td><span>规格型号</span></td>
									<td style="width:7.5%;"><span>单位</span></td>
									<td><span>数量</span></td>
									<td><span>单价</span></td>
									<td style="width:7.5%;"><span>金额</span></td>
									<td><span>税率</span></td>
									<td name="taxbreak" style="width:7.5%;"><span>税额</span></td>
									<td name="taxbreak" style="width:7.5%;"><span>价税小计</span></td>
									<td style="width:6%;" name="operation"><span>操作</span></td>
								</tr>
								<tbody id="add">
								<c:if test="${not empty map.business.invoicedAttachList }">
								<c:forEach items="${map.business.invoicedAttachList }" var="invoiced" varStatus="varStatus">
								<tr name="add">
									<input type="hidden" name="attachId" value="${invoiced.id }">
									<td contenteditable=true>
										${invoiced.name}
									</td>
									<td contenteditable=true>
										${invoiced.model}
									</td>
									<td contenteditable=true>
										${invoiced.unit}
									</td>
									<td name="number" onkeyup="coutmoney()" contenteditable=true>
										${invoiced.number}
									</td>
									<td name="price">
										${invoiced.price}
									</td>
									<td name="money">
										${invoiced.money}
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;">
											<option <c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
											<option <c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
											<option <c:if test="${invoiced.excise eq 16 }">selected</c:if>>16</option>
											<option <c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
										</select>
									</td>
									<td name="taxbreak">
										${invoiced.exciseMoney}
									</td>
									<td name="levied" onkeyup="coutmoney()" contenteditable=true>
										${invoiced.levied }
									</td>
									<td style="text-align:center;width:6%;" name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:forEach>
								</c:if>
								<c:if test="${empty map.business.invoicedAttachList }">
									<tr name="add">
									<td contenteditable=true></td>
									<td contenteditable=true></td>
									<td contenteditable=true></td>
									<td name="number" onkeyup="coutmoney()" contenteditable=true></td>
									<td name="price"></td>
									<td name="money"></td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;">
											<option selected="selected">0</option>
											<option>6</option>
											<option>16</option>
											<option>17</option>
										</select>
									</td>
									<td  name="taxbreak">
									</td>
									<td  name="levied" onkeyup="coutmoney()" contenteditable=true>
									</td>
									<td style="text-align:center;width:6%;" name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:if>
								</tbody>
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td name="total"></td>
								<td></td>
								<td name="totalexcisemoney" id="showHI"></td>
								<td id="showH"></td>
								<td id="showHII"></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9"  name="totalexcise"></td>
								</tr>
								<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;">${map.business.invoiced.collectionCompany}</td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;">${map.business.invoiced.collectionNumber}</td>
									<td><span>地址</span></td>
									<td colspan="5">${map.business.invoiced.collectionAddress}</td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;">${map.business.invoiced.collectionContact}</td>
								<td><span>开户行</span></td>
									<td>${map.business.invoiced.collectionBank}</td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="5">${map.business.invoiced.collectionAccount}</td>
								</tr>
							</tbody>
						</table>
						<%-- </c:if> --%>
						<table id="table9">
							<tbody>
								<tr>
									<td id="fuhe">审核：</td>
									<td id="ceo"  style="text-align:center;">审批：</td>
									<td  style="text-align:center;">收款人：</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
		</div>
</div>
<div id="barginDialog"></div>
<div id="projectDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="barginDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
    	<div class="modal-content" style="height:100%;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel">合同详情</h4>
         	</div>
	        <div class="modal-body" style="height:75%;">
	        	<iframe id="barginDetailFrame" name="barginDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
			</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/pdf.js"></script>

</body>
</html>