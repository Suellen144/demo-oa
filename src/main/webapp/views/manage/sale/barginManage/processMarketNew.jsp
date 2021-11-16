<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 , #table3 ,#table4 ,#table5{
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td , #table3 td ,#table4 td,#table5 td{
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"],#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span, #table2 td span  , #table3 td span,#table4 td span,#table5 td span{
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table2 td{
	width: 20%
}
#table3 td,#table4 td,#table5 td{
	width: 16%
}
#table1 th, #table2 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

#table3 th,#table4 th{
	text-align: center;
	font-size: 1.5em;
}

#table1 thead th ,#table2 thead th,#table3 thead th ,#table4 thead th,#table5 thead th{
	border: none;
}

textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
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
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">流水号管理</li>
			<li class="active">添加合同编号</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					
					<form id="form1" >
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">	
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>		
						
						<input type="hidden" id="isHandler" name="isHandler" value="${map.isHandler}">
						<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
						
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
						<input type="hidden" id="attachments2" name="attachments2" value="${map.business.attachments2}">
						<input type="hidden" id="attachName2" name="attachName2" value="${map.business.attachName2}">
						<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId}">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId}">
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="createBy" name="createBy" value="${map.business.createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${map.business.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						
						<input type="hidden" id="payMoney" name="payMoney" value="${map.business.payMoney}">
						<input type="hidden" id="unpayMoney" name="unpayMoney" value="${map.business.unpayMoney}">
						<input type="hidden" id="payReceivedInvoice" name="payReceivedInvoice" value="${map.business.payReceivedInvoice}">
						<input type="hidden" id="payUnreceivedInvoice" name="payUnreceivedInvoice" value="${map.business.payUnreceivedInvoice}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						
						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
								<tr><th colspan="20">销售合同详情</th></tr>
							</thead>
						</div>
						<table id="table1" style="text-align: center;">
						<c:choose>
							<c:when test="${((map.task.name eq '提交申请' or map.task.name eq '项目负责人') and map.business.userId eq sessionScope.user.id ) or (sessionScope.user.id == 2 or sessionScope.user.id == 3 )}">
							<tbody>
								<tr>
									<td ><span>合同名称</span></td>
									<td colspan="2"><input type="text" name="barginName"  id ="barginName" value="${map.business.barginName}"></td>
									<td ><span>合同类型</span></td>
									<td colspan="7"><select name="barginType"  id ="barginType" value="${map.business.barginType}" style="height:100%;width:100%;text-align-last:center;">
											<custom:dictSelect type="合同类型" selectedValue="${map.business.barginType}"/>
										</select>
									</td>
									<td  ><span>所属项目</span></td>
									<td colspan="8"><input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
										<input type="text" name="projectManageName"  id ="projectManageName" value="${map.business.projectManage.name }" onclick="openProject(this)" style="text-align: left;"  readonly></td>
								</tr>
								<tr>
									<td><span>合同编号</span></td>
									<td colspan="2"><input type="text"  id ="barginCode" value="${map.business.barginCode}" readonly></td>
									<td><span>合同期限</span></td>
									<td colspan="7">
										<input id="startTime" name="startTime" class="startTime"  value='<fmt:formatDate value="${map.business.startTime }" pattern="yyyy-MM-dd" />' type="text" class="startTime" style="width: 43%; text-align: center;" readonly> 
											至
										 <input  id="endTime" name="endTime" class="endTime"  value='<fmt:formatDate value="${map.business.endTime }" pattern="yyyy-MM-dd"/>' type="text" class="endTime" style="width: 43%; text-align: center;" readonly>
									</td>
									<td ><span>合同总金额</span></td>
									<td colspan="8"><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" style="text-align: right;"></td>
								</tr>
								<tr>
									<td ><span>渠道费用额度</span></td>
									<td colspan="2"><input type="text" name="channelExpense"  id ="channelExpense" value="<fmt:formatNumber value='${map.business.channelExpense}' pattern='0.00' />"  style="text-align: right;"></td>
									<td ><span>业绩贡献</span></td>
									<td colspan="7"><input type="text" name="contribution"  id ="contribution" value="<fmt:formatNumber value='${map.business.contribution}' pattern='0.00' />"  style="text-align: right;" readonly></td>
									<td  ><span>提成额度</span></td>
									<td colspan="8"><input type="text" name="commissionAmount"  id ="commissionAmount" value="<fmt:formatNumber value='${map.business.commissionAmount}' pattern='0.00' />"  style="text-align: right;" readonly></td>
								</tr>
								<tr>
									<td><span>签订单位</span></td>
									<td colspan="2"><input type="text" name="company"  id ="company" value="${map.business.company}" style="text-align: left;"></td>
									<td  class="td_weight" style="width: 10%"><span>联系人</span></td>
									<td  colspan="7"><input type="text" name="companyPeople"  id ="companyPeople" value="${map.business.companyPeople}" style="text-align: center;"></td>
									<td  class="td_weight" style="width: 10%"><span>电话</span></td>
									<td colspan="8"><input type="text" name="companyPhone"  id ="companyPhone" value="${map.business.companyPhone}" style="text-align: center;"></td>
								</tr>
								<tr>
									<td  ><span>合同说明</span></td>
									<td colspan="14"><textarea type="text" name="barginExplain"  id ="barginExplain" value="" >${map.business.barginExplain}</textarea></td>
								</tr>
								<tr>
									<td  ><span>合同描述</span></td>
									<td colspan="14"><textarea type="text" name="barginDescribe"  id ="barginDescribe" value="" >${map.business.barginDescribe}</textarea></td>
								</tr>
								<tr>
									<td  ><span>附件</span></td>
									<td colspan="12" style="border-right-style:hidden;">
										<c:if test="${empty map.business.id}">
											<input type="text" id="showName" name="showName" value="" readonly style="text-align: left;">
										</c:if>
										
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly style="text-align: left;">
											</a>
										</c:if>
										
										<td colspan="2">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty map.business.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
											</c:if>
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;"> 
										</td>
									</td>
								</tr>
							</c:when>
								
								
						<c:otherwise>
								<tr>
									<td ><span>合同名称</span></td>
									<td colspan="2"><input type="text" name="barginName"  id ="barginName" value="${map.business.barginName}" style="text-align: center;" readonly></td>
									<td ><span>合同类型</span></td>
									<td colspan="7"><input type="hidden"  id="barginType" name="barginType" value="${map.business.barginType}">
										<custom:getDictKey type="合同类型" value="${map.business.barginType}"/>
									</td>
									<td ><span>所属项目</span></td>
											<td colspan="8"><input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
											<input type="text"  name="projectManageName"  id ="projectManageName" style="text-align: left;" value="${map.business.projectManage.name }"  readonly></td>
								</tr>
								<tr>
									<td  ><span>合同编号</span></td>
									<td colspan="2"><input type="text"  id ="barginCode" value="${map.business.barginCode}" readonly></td>
									<td ><span>合同期限</span></td>
									<td colspan="7" style="width: 25%">
										<input value='<fmt:formatDate value="${map.business.startTime }" pattern="yyyy-MM-dd" />' type="text"  style="width: 43%; text-align: center;" readonly> 
											至
										 <input  value='<fmt:formatDate value="${map.business.endTime }" pattern="yyyy-MM-dd"/>' type="text" style="width: 43%; text-align: center;" readonly>
									</td>
									<td><span>合同总金额</span></td>
									<td colspan="8"><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" style="text-align: right;" readonly></td>
								</tr>
								<tr>
									<td ><span>渠道费用额度</span></td>
									<td colspan="2"><input type="text" name="channelExpense"  id ="channelExpense" value="<fmt:formatNumber value='${map.business.channelExpense}' pattern='0.00' />"  style="text-align: right;"></td>
									<td ><span>业绩贡献</span></td>
									<td colspan="7"><input type="text" name="contribution"  id ="contribution" value="<fmt:formatNumber value='${map.business.contribution}' pattern='0.00' />"  style="text-align: right;" readonly></td>
									<td  ><span>提成额度</span></td>
									<td colspan="8"><input type="text" name="commissionAmount"  id ="commissionAmount" value="<fmt:formatNumber value='${map.business.commissionAmount}' pattern='0.00' />"  style="text-align: right;" readonly></td>
								</tr>
								<tr>
									<td><span>签订单位</span></td>
									<td colspan="2"><input type="text" name="company"  id ="company" value="${map.business.company}" style="text-align: left;"  readonly></td>
									<td  class="td_weight" style="width: 10%"><span>联系人</span></td>
									<td  colspan="7"><input type="text" name="companyPeople"  id ="companyPeople" value="${map.business.companyPeople}" style="text-align: center;"></td>
									<td  class="td_weight" style="width: 10%"><span>电话</span></td>
									<td colspan="8"><input type="text" name="companyPhone"  id ="companyPhone" value="${map.business.companyPhone}" style="text-align: center;"></td>
								</tr>
								<tr>
									<td  ><span>合同说明</span></td>
									<td colspan="12"><textarea type="text" name="barginExplain"  id ="barginExplain" value="" readonly>${map.business.barginExplain}</textarea></td>
								</tr>
								<tr>
									<td><span>合同描述</span></td>
									<td colspan="12"><textarea type="text" name="barginDescribe" readonly  id ="barginDescribe"  value="" >${map.business.barginDescribe}</textarea></td>
								</tr>
								<tr>
									<td  ><span>附件</span></td>
									<td colspan="12" >
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
											</a>
										</c:if>
									</td>
								</tr>
								<c:if test="${not empty map.business.position2 and map.business.status eq '5' or map.business.status eq '11'}">
								<tr>
									<td><span>合同附件</span></td>
									<td colspan="9" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments2 }" target='_blank'>
											<input type="text" id="showName2" name="showName2" value="${map.business.attachName2}" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file2" name="file2" style="display: none;">
										<c:if test="${not empty map.business.attachments2 and not empty map.business.position3}">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach2(this)" value="${map.business.attachments2 }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file2').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
								</c:if>
								<tr id="barginRemarkId">
									<td><span>作废备注</span></td>
									<td colspan="12"><textarea type="text" name="remark" placeholder="请填写合同作废备注"  id ="barginRemark"  value="" >${map.business.remark}</textarea></td>
								</tr>
						</c:otherwise>
					</c:choose>
					<tfoot>
						<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
							<tr>
								<td colspan="34">
									<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
								</td>
							</tr>
						</c:if>
					</tfoot>
					</tbody>
					</table>
					<div style="width: 90%; text-align: center;margin:auto;margin-top:5px;margin-bottom: 30px" >
							<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '项目负责人')}">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '出纳' }">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name eq '出纳' }">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">确认</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">退回</button>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<%--<c:if test="${map.business.status eq '11'}">
								<tr>
									<td>作废备注</td>
									<td><input type="text" id="remark" value="${map.business.remark}"></td>
								</tr>
							</c:if>--%>
							<c:if test="${map.business.status eq '5' && map.business.status ne '11'}">
								<shiro:hasPermission name="sale:bargin:invalid">
									<%--<input type="text" id="reason">--%>
									<button type="button" id="invalid" class="btn btn-warning" onclick="demo()">作废</button>
								</shiro:hasPermission>
							</c:if>
							<c:if test="${map.business.status ne '5' && map.business.status eq '11'}">
								<shiro:hasPermission name="sale:bargin:invalid">
									<%--<input type="text" id="reason">--%>
									<button type="button" id="invalid2" class="btn btn-warning" onclick="noDemo()">取消作废</button>
								</shiro:hasPermission>
							</c:if>
							<c:if test="${not empty map.business.position1 and (map.business.barginConfirm eq '0' or empty map.business.barginConfirm )
							and map.business.status eq '5' or map.business.status eq '11'}">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="confirm()">确认</button>
							</c:if>
                            <c:if test="${not empty map.business.position1 and map.business.barginConfirm eq '1'and map.business.status eq '5' or map.business.status eq '11'}">
                                <button id="reapplyBtn" type="button" class="btn btn-primary" onclick="unConfirm()">取消确认</button>
                            </c:if>
							<c:if test="${map.task.name eq '财务'  or map.task.name eq '总经理'   or  sessionScope.user.id eq '2' or sessionScope.user.id eq '3' or  sessionScope.user.id eq '8'
							 or  sessionScope.user.id eq '477' or sessionScope.user.id eq '225'}">
							<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="save()">保存</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
						<div id="pay"></div>
						<div id="collection"></div>
					</form>
				</div>
			</div>
			<c:if test="${map.business.status eq '5' }">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">发票记录</span>
							<c:if test="${map.business.projectManage.status ne '-1' and map.business.projectManage.status ne '0'}">
								<div style="float: right;position: absolute;margin: auto;right: 0px;top: 6px;">
									<button type="button" class="btn btn-primary" style="float: right;position: absolute;margin: auto;right: 0;" onclick="initiateInvoice()">发票申请</button>
								</div>
							</c:if>
						</div>
					<table id="table3" style="text-align: center;width:90%;">
					<thead>
						<tr>
						<td >开票时间</td>
						<td >开票人</td>
						<td >收票人</td>
						<td >开票额</td>
						<td >寄送方式</td>
						<td >审批环节</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
					<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 29px;line-height: 29px;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">收入确认</span>
						</div>
					<table id="table5" style="text-align: center;width:90%;">
					<thead>
						<tr>
						<td>确认时间</td>
						<!-- <td>确认方式</td> -->
						<td>确认金额</td>
						<td>业绩贡献</td>
						<!-- <td>是否已确认</td>
						<td>确认人</td> -->
						</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
					<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">收款记录</span>
							<c:if test="${not empty map.business.position3 and map.business.projectManage.status ne '-1' and map.business.projectManage.status ne '0'}">
								<div style="float: right;position: absolute;margin: auto;right: 0px;top: 6px;">
									<button type="button" class="btn btn-primary" style="float: right;position: absolute;margin: auto;right: 0;" onclick="initiatePayment()">收款登记</button>
								</div>
							</c:if>
						</div>
					<table id="table4" style="text-align: center;width:90%;">
					<thead>
						<tr>
						<td id="replace1">申请时间</td>
						<td >收款类型</td>
						<td id="replace2">申请金额</td>
						<td >提成额</td>
						<td >渠道费用</td>
						<td >审批环节</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
					</div>
					</div>
					</c:if>
		</div>
	</section>
		<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<table id="table2" style="width:90%;text-align: center;">
						<thead>
							<tr><th colspan="20">合  同  处 理 流 程</th></tr>
							<tr style="text-align: center;font-weight: bold;">
								<td  style="width:10%;">环节</td>
								<td  style="width:9%">操作人</td>
								<td  style="width:15%">操作时间</td>
								<td  style="width:10%">操作结果</td>
								<td  style="width:56%">操作备注</td>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="projectDialog"></div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/processMarketNew.js"></script>
<script type="text/javascript">
	var variables = ${map.jsonMap.variables};
</script>
</body>
</html>