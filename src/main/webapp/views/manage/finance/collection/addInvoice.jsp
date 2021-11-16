<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
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

#table3 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
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

#table2 td input[type="text"] {
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

#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 td span {
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
#table1 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table2 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table3 th {
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
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">收款管理</li>
			<li class="active">申请开票</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
						<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
						<input type="hidden" id="attachments" name="attachments" value="${finInvoiced.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${finInvoiced.attachName}">
						<input type="hidden" id="barginProcessInstanceId" value="">
						<input type="hidden" id="barginManageId" name="barginManageId" value="${finInvoiced.barginManageId}">
						<input type="hidden" id="isSubmit" name="isSubmit" value="">
						<input type="hidden" id="isNewProject" name="isNewProject" value="1">
						<input type="hidden" id="createBy" name="createBy" value="${finInvoiced.createBy}">
						<input type="hidden" id="createDate" name="createDate" value="<fmt:formatDate value="${finInvoiced.createDate}" pattern="yyyy-MM-dd" />">
						<input type="hidden" id="id" name="id" value="${finInvoiced.id}">
						<table id="table1">
							<thead>
								<tr><th colspan="20">开票申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:15%;"><span>申请人</span></td>
									<td style="width:10%;"><input type="text" id="userName2" value="${sessionScope.user.name }" readonly>
									<input type="hidden" id="applyUserId" name="applyUserId" value="${sessionScope.user.id }" readonly></td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
											<div style="float: left;height:20px;font-size: 15px;">
												<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
												<div style="float: left;">
													<select name="applyUnit" disabled="disabled"><custom:dictSelect
															type="流程所属公司" /></select>
												</div>
												</c:if>
												<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
												<div style="float: left;">
												<input name="applyUnit" value="10" type="hidden">
												<custom:getDictKey type="流程所属公司" value="10"/>
												</div>
												</c:if>
												<div style="float: left;height:20px;font-size: 15px;">
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${sessionScope.user.dept.name }" readonly>
													</c:if>
												</div>
												<div style="clear: both"></div>
											</div>
									</td>
									
									<td><span>开票金额</span></td>
									<td colspan="3">
										<input type="text" id="invoiceAmount"  name="invoiceAmount" value="${finInvoiced.invoiceAmount}" onkeyup="initInputBlur()">
									</td>
								</tr>
								<tr>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="${finInvoiced.barginManage.barginName}" readonly>
										<%--<input type="text" id="barginCode" value="${finInvoiced.barginManage.barginCode}" readonly>--%>
									</td>
									<td><span>项目名称</span></td>
									<td>
										<input  type="text" id="projectManageName" value="${finInvoiced.saleProjectManage.name}" readonly>
									</td>
									<td ><span>开票时间</span></td>
									<td colspan="3" >
										<input id="finInvoicedDate" name="finInvoicedDate" value='<fmt:formatDate value="${finInvoiced.finInvoicedDate}" pattern="yyyy-MM-dd" />' type="text" class="startTime" style="width: 60%;" readonly>
									</td>
								</tr>
								
								<tr>
									<td><span>项目负责人</span></td>
									<td colspan="1" style="text-align:left;">
                                        <input id="userId2" name="userId2" type="text" value="${finInvoiced.saleProjectManage.principal.id}" style="display:none;">
										<input id="userName" type="text"  value="${finInvoiced.saleProjectManage.principal.name}" readonly>
									</td>
									<td><span>收票人</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketUser" name="ticketUser" value="${finInvoiced.ticketUser}">
									</td>
									<td><span>收票电话</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketPhone" name="ticketPhone" value="${finInvoiced.ticketPhone}">
									</td>
									<td><span>寄送方式</span></td>
									<td colspan="1" style="text-align:left;">
										<select id="sendWay" name="sendWay"  style="width:100%;">
											<option value="0" <c:if test="${finInvoiced.sendWay == '0'}"> selected </c:if>></option>
											<option value="1" <c:if test="${finInvoiced.sendWay == '1'}"> selected </c:if>>邮送</option>
											<option value="2" <c:if test="${finInvoiced.sendWay == '2'}"> selected </c:if>>亲送</option>
										</select>
									</td>
								</tr>
								<tr>
									<td><span>合同金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="totalMoney"  value="${finInvoiced.barginManage.totalMoney}" readonly>
									</td>
									<td><span>已开票金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceAmountTo"  value="${finInvoiced.invoiceAmountTo}" readonly>
									</td>
									<td><span>已开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="alreadyInvoiceProportion" name="alreadyInvoiceProportion" readonly>
									</td>
									<td><span>本次开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceProportion" name="invoiceProportion" readonly>
									</td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${finInvoiced.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${finInvoiced.attachName }" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file" name="file" style="display: none;">
										<c:if test="${not empty finInvoiced.attachments }">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${finInvoiced.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
								<!-- <tr>
									<td><span>备注</span></td>
									<td colspan="20" style="text-align:left;">
										<textarea name ="reason"></textarea>
									</td>
								</tr> -->
								</tbody>
						</table>
						<div>
						<table id="table2">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:13%;"><span>购货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="payname" value="${finInvoiced.payname }"></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="paynumber" name="paynumber" value="${finInvoiced.paynumber }"></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="payaddress" value="${finInvoiced.payaddress }" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="payphone" name="payphone" value="${finInvoiced.payphone}" ></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="bankAddress" value="${finInvoiced.bankAddress}" ></td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="5"><input type="text" name="bankNumber" id="bankNumber" value="${finInvoiced.bankNumber }"></td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td style="width:12%;"><span>规格型号</span></td>
									<td style="width:12%;"><span>单位</span></td>
									<td style="width:5%;"><span>数量</span></td>
									<td style="width:8%;"><span>单价</span></td>
									<td style="width:9%;"><span>金额</span></td>
									<td style="width:5%;"><span>税率(%)</span></td>
									<td style="width:8%;"><span>税额</span></td>
									<td style="width:8%;"><span>价税小计</span></td>
									<td style="width:5%;"><span>操作</span></td>
								</tr>
								<c:if test="${not empty finInvoiced.invoicedAttachList }">
								<c:forEach items="${finInvoiced.invoicedAttachList }" var="invoiced" varStatus="varStatus">
								<tr name="add">
									<input type="hidden" name="attachId" value="${invoiced.id }">
									<td>
										<input type="text" name="name" value="${invoiced.name }" >
									</td>
									<td>
										<input type="text"  name="model" value="${invoiced.model }" >
									</td>
									<td>
										<input type="text" name="unit" value="${invoiced.unit }"  >
									</td>
									<td>
										<input type="text" name="number" value="${invoiced.number }" onkeyup="coutmoney()" >
									</td>
									<td>
										<input type="text"  name="price" value="${invoiced.price }"  readonly>
									</td>
									<td>
										<input type="text"  name="money" value="${invoiced.money }" readonly >
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;width: 100%;">
											<option <c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
											<option <c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
											<option <c:if test="${invoiced.excise eq 13 }">selected</c:if>>13</option>
											<option <c:if test="${invoiced.excise eq 16 }">selected</c:if>>16</option>
											<option <c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
										</select>
										<%-- <input type="text" name="excise" value="${invoiced.excise }" onkeyup="initexcise()"> --%>
									</td>
									<td>
										<input type="text" name="exciseMoney" value="${invoiced.exciseMoney }"  readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="${invoiced.levied }"  onkeyup="coutmoney()">
									</td>
									<td style="text-align:center;width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:forEach>
								</c:if>
								<c:if test="${empty finInvoiced.invoicedAttachList }">
									<tr name="add">
									<td>
										<input type="text" name="name" value="" >
									</td>
									<td>
										<input type="text"  name="model" value="" >
									</td>
									<td>
										<input type="text" name="unit" value=""  >
									</td>
									<td>
										<input type="text" name="number" value="" onkeyup="coutmoney()" >
									</td>
									<td>
										<input type="text"  name="price" value="" readonly>
									</td>
									<td>
										<input type="text"  name="money" value="" readonly >
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;">
											<option selected="selected">0</option>
											<option>6</option>
											<option>13</option>
											<option>16</option>
											<option>17</option>
										</select>
										<!-- <input type="text" name="excise" value="" onkeyup="initexcise()"> -->
									</td>
									<td>
										<input type="text" name="exciseMoney" value="0"  readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="0"  onkeyup="coutmoney()">
									</td>
									<td style="text-align:center;width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:if>
								
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td><input type="text" name="total" value="" readonly></td>
								<td></td>
								<td><input type="text" name="totalexcisemoney"  value="" readonly></td>
								<td></td>
								<td></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9"><input type="text" name="totalexcise" value="" readonly></td>
								</tr>
								<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="collectionCompany" value="${finInvoiced.collectionCompany}"></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="collectionNumber" name="collectionNumber" value="${finInvoiced.collectionNumber }"></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="collectionAddress" value="${finInvoiced.collectionAddress }" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="collectionContact" name="collectionContact" value="${finInvoiced.collectionContact }"></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="collectionBank"value="${finInvoiced.collectionBank }" ></td>
									<td style="width:15%;"><span>账号</span></td>
									<!-- <td>
										<input type="hidden" name="collection">
									</td> -->
								<td colspan="5"><input type="text" id="collectionAccount" name="collectionAccount" value="${finInvoiced.collectionAccount }"></td>
								</tr>
								<tr>
									<td colspan="10"><textarea name="remark" placeholder="备注">${finInvoiced.remark }</textarea></td>
								</tr>
							</tbody>
						</table>
						</div>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
							<table id="table3" style="text-align: center;width:98%;">
							<thead>
								<tr  name='node3' class='node1'>
								<td style='width:33%'>姓名</td>
								<%--<td style='width:33%'>业绩比例</td>--%>
								<td style='width:33%'>业绩分配</td>
								</tr>
							</thead>
							<tbody id="tableTbody" >
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
							</table>
						<div style="width: 80%; text-align: center;margin:auto;padding-top:5px;">
							<button type="button" class="btn btn-primary" onclick="submitinfo()" >提交</button>
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="barginDialog"></div>
<div id="projectDialog"></div>
<div id="userDialog"></div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/addInvoice.js"></script>
</body>
</html>