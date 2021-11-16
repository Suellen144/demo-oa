<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
	<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css">
	<style>
		#table1,#table2{
			table-collapse: collapse;
			border: none;
			margin: 5px 20px;
		}
		#table1 td:not(.select2), #table2 td {
			border: solid #999 1px;
			padding: 5px;
			text-align: center;
		}
		#table1 td input[type="text"], #table2 td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
		}


		#table1 td input[name="name"],input[name="applyTime"],input[name="place"],input[name="date"]
		,input[name="payee"],input[name="bankAddress"]{
			text-align:center;
		}

		#table1 td input[name="money"],input[name="actReimburse"]{
			text-align:right;
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

		#table1 td span:not(.select2 span), #table2 td span {
			padding: 0px 15px;
			text-align: center;
		}
		#table1 th, #table2 th {
			border: solid #999 1px;
			text-align: center;
			font-size: 1.5em;
		}

		textarea {
			resize: none;
			border: none;
			outline: medium;
			width:100%;
		}

		textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
			padding-top:10px;
			text-align:left;
		}

		.td_right {
			text-align: right;
		}
		.td_weight {
			font-weight: bold;
		}
		
		.tdselect .bootstrap-select .dropdown-toggle span{max-width:100px}
		ul.dropdown-menu{max-height: 200px!important;}
		button.dropdown-toggle{width:165px!important;}
	</style>
</head>
<body style="background-color:#ecf0f5; min-width:1110px; overflow:auto;font-size:small;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">报销</li>
			<li class="active">通用报销</li>
			<li class="active">报销处理</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="col-md-16">
		<div class="box box-primary tbspace">
			<div class="box-body">
				<form id="form1">
					<select id="type_hidden" style="display:none;">
						<custom:dictSelect type="通用报销类型"/>
					</select>
				    <input type="hidden" id="isSend" name="isSend" value="${map.business.isSend }">
                    <input type="hidden" id="initMoney" name="initMoney" value="${map.business.initMoney }">
                    <input type="hidden" id="processInstanceId" name="" value="${map.business.processInstanceId}">
					<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
					<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
					<input type="hidden" id="id" name="id" value="${map.business.id}">
					<input type="hidden" id="cost" name="cost" value="<fmt:formatNumber value='${map.business.cost }' pattern='#.##' />">
					<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
					<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
					<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
					<input type="hidden" id="userId" name="userId" value="${map.business.userId }">
					<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId }">
					<input type="hidden" id="encrypted" name=encrypted value="${map.business.encrypted }">
					<input type="hidden" id="assistantStatus" name="assistantStatus" value="${map.business.assistantStatus}">
					<input type="hidden" id="operStatus" value="">
					<input type="hidden" id="createDateStr" name="createDateStr" value="${map.business.createDateStr}">
                   	<input type="hidden" id="isOk" name="isOk" value="${map.business.isOk}">
					<c:choose>
						<c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:when>
						<c:otherwise>
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:otherwise>
					</c:choose>

					<div style="text-align: center;font-weight: bolder;font-size: large;">
						<thead>
							<tr>
								<th colspan="20">通 用 报 销 单</th>
								<i class="icon-question-sign" style="cursor:pointer"  onclick="showhelp()"> </i>
								<span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(报销单号：${map.business.orderNo })</span>
							</tr>
	
							<shiro:hasPermission name="fin:reimburse:encrypt">
								<c:if test="${map.business.encrypted ne 'y' }">
									<i class="icon-eye-close"  style="cursor:pointer"  onclick="lock()"> </i>
								</c:if>
							</shiro:hasPermission>
						</thead>
					</div>

					<table id="table1">
						<c:choose>
							<c:when test="${ ((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
									((map.task.name eq '经办' or map.task.name eq '提交申请'  or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) or (sessionScope.user.id == 2 or sessionScope.user.id  == 3 )}">
								<tbody>
								<tr>
									<td class="td_weight"><span>报销人</span></td>
									<td><input type="text" id="name" name="name" value="${map.business.name }" ></td>
									<td class="td_weight"><span>报销单位</span></td>
									<td colspan="2" style="font-size:14px; text-align:left;white-space:nowrap ;">
										<select name="title" ><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
										<c:choose>
											<c:when test="${empty(map.business.dept.alias)}">
												<input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
											</c:when>
											<c:otherwise>
												<input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
											</c:otherwise>
										</c:choose>
									</td>
									<td colspan="2" class="td_weight"><span>提交日期</span></td>
									<td colspan="3"><input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly></td>
								</tr>
								<tr>
									<td class="td_weight"><span>领款人</span></td>
									<td id = "selectpayee"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
									<td class="td_weight"><span>银行卡号</span></td>
									<td colspan="2"><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
									<td colspan="2" class="td_weight"><span>开户行名称</span></td>
									<td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
								</tr>
								<tr>
									<td class="td_weight"><span>日期</span></td>
									<td class="td_weight"><span>地点</span></td>
									<td class="td_weight"><span>项目</span></td>
									<td class="td_weight"><span>事由</span></td>
									<td class="td_weight"><span>金额</span></td>
									<td class="td_weight"><span>实报</span></td>
									<td class="td_weight"><span>类别</span></td>
									<td class="td_weight"><span>明细</span></td>
									<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')  and map.isHandler and sessionScope.user.id ne '225' ) }">
										<td class="td_weight"><span>费用归属</span></td>
									</c:if>
									<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id}">
										<td class="td_one td_weight"><span>操作</span></td>
									</c:if>
								</tr>
								<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
									<tr name="node">
										<td  style="width:11%;">
											<input type="text" name="date" class="date" value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
											<input type="hidden" name="reimburseAttachId" value="${business.id }">
										</td>
										<td style="width:8%;"><input type="text" name="place" class="input" value="${business.place }" ></td>
										<td style="width:15%;">
											<textarea name="projectName" onclick="openProject(this)" readonly>${business.project.name }</textarea>
											<input type="hidden" name="projectId" value="${business.project.id }">
										</td>
										<td style="width:15%;"><textarea name="reason" autocomplete="off" class="input" >${business.reason }</textarea></td>
										<td style="width:5%;">
											<input type="text" name="money"  style="text-align:right;" value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">
										</td>
										<td style="width:8%;">
											<input type="text" name="actReimburse" style="text-align:right;" value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" onkeyup="actReimburseCount()" onfocus="this.select()">
										</td>
										<td style="width:5%;">
											<select name="type" value="${business.type }" onchange="validationRed()">
												<custom:dictSelect type="通用报销类型" selectedValue="${business.type }" />
											</select>
										</td>
										<td style="width:18%;"><textarea name="detail">${business.detail }</textarea></td>
										<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler and sessionScope.user.id ne '225') }">
											<td style="width:10%;" class='tdselect'>
												<%-- <select style="width:100%;" name="investId" value="${business.investId }"  multiple="multiple"></select> --%>
												<select style="width:100%;" name="investId" class="selectpicker show-tick form-control " multiple data-live-search="false" data-selected-text-format="count > 3" data-v="${business.investIdStr eq '' or business.investIdStr == null?business.investId:business.investIdStr}"></select>
											</td>
										</c:if>
										<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id}">
											<td style="width:6%;">
												<c:if test="${varStatus.last }">
													<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
													<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
												</c:if>
												<c:if test="${!varStatus.last }">
													<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
													<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
												</c:if>
											</td>
										</c:if>
									</tr>
								</c:forEach>
								<tr>
									<td class="td_right td_weight"><span>实报金额：</span></td>
									<td colspan="18">
										<div style="display:flex">
											<div style="display:flex">
												<span>¥</span>
												<span id="actReimburseTotal"></span>
											</div>
											<div>
												&nbsp;&nbsp;
												<span id="costcn"></span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td class="td_weight" colspan="1">附件</td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
										</a>
										<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
											<td colspan="1">
												<input type="file" id="file" name="file" style="display:none;">
												<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
											</td>
										</c:if>
									</td>
									<td colspan="10">
										<c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
											<c:if test="${not empty(map.business.attachments)}">
												<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
											</c:if>
											<c:if test="${empty(map.business.attachments)}">
												<input type="file" id="file" name="file" style="display:none;">
												<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
											</c:if>
										</c:if>
									</td>
								</tr>
								<!-- 									<tr id="reimbursetotal"> -->
								<!-- 									</tr> -->
								</tbody>
							</c:when>

							<c:otherwise>
								<tbody>
									<shiro:hasPermission name="fin:reimburse:modify">
										<tr>
											<td class="td_weight"><span>报销人</span></td>
											<td><input type="text" id="name" name="name" value="${map.business.name }" ></td>
											<td  class="td_weight"><span>报销单位</span></td>
											<td colspan="2"  style="font-size:14px;text-align:left;white-space:nowrap ;">
												<select name="title" ><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
												<c:choose>
													<c:when test="${empty(map.business.dept.alias)}">
														<input  type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
													</c:when>
													<c:otherwise>
														<input  type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
													</c:otherwise>
												</c:choose>
											</td>
											<td colspan="2" class="td_weight"><span>提交日期</span></td>
											<td colspan="3"><input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly></td>
										</tr>
										<tr>
											<td class="td_weight"><span>领款人</span></td>
											<td id = "selectpayee"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
											<td class="td_weight"><span>银行卡号</span></td>
											<td colspan="2"><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
											<td colspan="2" class="td_weight"><span>开户行名称</span></td>
											<td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
										</tr>
										<tr>
											<td class="td_weight"><span>日期</span></td>
											<td class="td_weight"><span>地点</span></td>
											<td class="td_weight"><span>项目</span></td>
											<td class="td_weight"><span>事由</span></td>
											<td class="td_weight"><span>金额</span></td>
											<td class="td_weight"><span>实报</span></td>
											<td class="td_weight"><span>类别</span></td>
											<td class="td_weight"><span>明细</span></td>
											<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')  and map.isHandler and sessionScope.user.id ne '225' ) }">
												<td class="td_weight"><span>费用归属</span></td>
											</c:if>
											<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id}">
												<td class="td_one td_weight"><span>操作</span></td>
											</c:if>
										</tr>
										<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
											<tr name="node">
												<td  style="width:11%;">
													<input type="text" name="date" class="date" value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
													<input type="hidden" name="reimburseAttachId" value="${business.id }">
												</td>
												<td style="width:8%;"><input type="text" name="place" class="input" value="${business.place }" ></td>
												<td style="width:15%;">
													<textarea name="projectName" onclick="openProject(this)" readonly>${business.project.name }</textarea>
													<input type="hidden" name="projectId" value="${business.project.id }">
												</td>
												<td style="width:15%;"><textarea name="reason" autocomplete="off" class="input" >${business.reason }</textarea></td>
												<td style="width:5%;">
													<input type="text" name="money"  style="text-align:right;" value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" readonly onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">
												</td>
												<td style="width:8%;">
													<input type="text" name="actReimburse" style="text-align:right;" value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" readonly onkeyup="actReimburseCount()" onfocus="this.select()">
												</td>
												<td style="width:5%;">
													<select name="type" value="${business.type }">
														<custom:dictSelect type="通用报销类型" selectedValue="${business.type }" />
													</select>
												<td style="width:18%;"><textarea name="detail">${business.detail }</textarea></td>
												<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler and sessionScope.user.id ne '225') }">
													<td style="width:10%;">
														<%-- <select style="width:100%;" name="investId" value="${business.investId }"></select> --%>
														<select style="width:100%;" name="investId" class="selectpicker show-tick form-control " multiple data-live-search="false" data-selected-text-format="count > 3" data-v="${business.investIdStr eq '' or business.investIdStr == null?business.investId:business.investIdStr}"></select>
													</td>
												</c:if>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id}">
													<td style="width:6%;">
														<c:if test="${varStatus.last }">
															<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
															<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
														</c:if>
														<c:if test="${!varStatus.last }">
															<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
															<a href="javascript:void(0);" style="font-size: x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
														</c:if>
													</td>
												</c:if>
											</tr>
										</c:forEach>
										<tr>
											<td class="td_right td_weight"><span>实报金额：</span></td>
											<td colspan="18">
												<div style="display:flex">
													<div style="display:flex">
														<span>¥</span>
														<span id="actReimburseTotal"></span>
													</div>
													<div>
														&nbsp;&nbsp;
														<span id="costcn"></span>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td class="td_weight" colspan="1">附件</td>
											<td colspan="6" style="border-right-style:hidden;">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
													<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
												</a>
													<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
											<td colspan="1"><input type="file" id="file" name="file" style="display:none;">
												<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
											</td>
											</c:if>
											</td>
											<td colspan="10">
												<c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11' or map.business.status eq '1' )) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
													<c:if test="${not empty(map.business.attachments)}">
														<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
													</c:if>
													<c:if test="${empty(map.business.attachments)}">
														<input type="file" id="file" name="file" style="display:none;">
														<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
													</c:if>
												</c:if>
											</td>
										</tr>
									</shiro:hasPermission>
									<shiro:lacksPermission name = "fin:reimburse:modify">
										<tr>
											<td class="td_weight"><span>报销人</span></td>
											<td><input type="text" id="name" name="name" value="${map.business.name }" readonly></td>
											<td class="td_weight"><span>报销单位</span></td>
											<td colspan="2"  style="font-size:14px; text-align:left;white-space:nowrap ;">
												<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
												<c:choose>
													<c:when test="${empty(map.business.dept.alias)}">
														<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
													</c:when>
													<c:otherwise>
														<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
													</c:otherwise>
												</c:choose>
											</td>
											<td colspan="2" class="td_weight"><span>提交日期</span></td>
											<td colspan="3"><input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" readonly ></td>
										</tr>
										<tr>
											<td class="td_weight"><span>领款人</span></td>
											<td><input type="text" id="payee" name="payee" style="text-align: center" value="${map.business.payee }" readonly></td>
											<td class="td_weight"><span>银行卡号</span></td>
											<td colspan="2"><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }" readonly></td>
											<td colspan="2" class="td_weight"><span>开户行名称</span></td>
											<td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }" readonly></td>
										</tr>
										<tr>
											<td class="td_weight"><span>日期</span></td>
											<td class="td_weight"><span>地点</span></td>
											<td class="td_weight"><span>项目</span></td>
											<td class="td_weight"><span>事由</span></td>
											<td class="td_weight"><span>金额</span></td>
											<td class="td_weight"><span>实报</span></td>
											<td class="td_weight"><span>类别</span></td>
											<td class="td_weight" colspan="2"><span>明细</span></td>
											<shiro:hasPermission name="fin:reimburse:seeall">
												<td class="td_weight"><span>费用归属</span></td>
											</shiro:hasPermission>
										</tr>
										<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
											<tr name="node">
												<td style="width:11%;">
													<input type="text" name="date"  readonly value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />">
													<input type="hidden" name="reimburseAttachId" value="${business.id }">
												</td>
												<td style="width:8%;"><input type="text" name="place" class="input" value="${business.place }" readonly></td>
												<td style="width:12%;">
													<textarea name="projectName" readonly>${business.project.name }</textarea>
													<input type="hidden" name="projectId" value="${business.project.id }">
												</td>
												<td style="width:19%;"><textarea name="reason" autocomplete="off" readonly>${business.reason }</textarea></td>
												<td style="width:5%;">
													<input type="text" name="money" class="input" value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" readonly>
												</td>
												<td style="width:5%;">
													<input type="text" name="actReimburse" value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" readonly>
												</td>
												<td style="width:7%;">
													<input type="text" class="input" value="<custom:getDictKey type="通用报销类型" value="${business.type}" />" style="text-align: center"  readonly>
													<input type="hidden" name="typevalue" value="${business.type }">
													<input type="hidden" name="type" value="${business.type }">
												<td style="width:25%;" colspan="2"><textarea name="detail" readonly>${business.detail }</textarea></td>
												<shiro:hasPermission name="fin:reimburse:seeall">
													<td style="width:10%;">
														<%-- <select style="width:100%;" name="investId" value="${business.investId }"></select> --%>
														<select style="width:100%;" name="investId" class="selectpicker show-tick form-control"  multiple data-live-search="false" data-selected-text-format="count > 3" data-v="${business.investIdStr eq '' or business.investIdStr == null?business.investId:business.investIdStr}"></select>
													</td>
												</shiro:hasPermission>
											</tr>
										</c:forEach>
										<tr>
											<td class="td_right td_weight"><span>实报金额：</span></td>
											<td colspan="18">
												<div style="display:flex">
													<div style="display:flex">
														<span>¥</span>
														<span id="actReimburseTotal"></span>
													</div>
													<div>
														&nbsp;&nbsp;
														<span id="costcn"></span>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td class="td_weight" colspan="1">附件</td>
											<td colspan ="7" style="border-right-style:hidden;">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
													<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
												</a>
											</td>
											<td colspan="10">
												<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
													<c:if test="${not empty(map.business.attachments)}">
														<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
													</c:if>
												</c:if>
											</td>
										</tr>
									</shiro:lacksPermission>
								</tbody>
							</c:otherwise>
						</c:choose>
						<tfoot>
						<c:if test="${map.isHandler and map.task.name ne '提交申请' }">
							<tr>
								<td colspan="34">
									<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
								</td>
							</tr>
						</c:if>
						<tr>
							<td colspan="34" style="text-align:center;border:none;padding-top:10px">
								<%-- <button type="button" class="btn btn-primary" onclick="viewProcess(${map.business.processInstanceId})">查看流程图</button> --%>
								<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '部门经理' }">
									<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交</button>
									<button type="button" class="btn btn-primary" onclick="approve(5)">取消申请</button>
								</c:if>
								<c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '部门经理' }">
									<button type="button" class="btn btn-primary" onclick="save()">保存修改</button>
								</c:if>

								<c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') 
									or (map.initiator.dept.id eq '3' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '20' and map.task.name ne '部门经理') or (map.initiator.dept.id  eq '35' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '36' and map.task.name ne '部门经理') 
									or (map.initiator.dept.id eq '37' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '38' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '39' and map.task.name ne '部门经理')) 
									and map.isHandler and map.task.name ne '提交申请' }">
									<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
									<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
								</c:if>
								<%-- <c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '部门经理'  and sessionScope.user.id ne '225' and map.isHandler and map.business.assistantStatus eq '1'}"> --%>
								<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '部门经理'  and sessionScope.user.id ne '225' and map.isHandler }">
									<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
									<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
								</c:if><!-- 排除时用 ((map.business.assistantStatus eq '1' and map.initiator.id ne '61' and  map.initiator.id ne '87') or (map.initiator.id eq '61' or  map.initiator.id eq '87'))-->


								<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
									<button id="svaeBtn" type="button" class="btn btn-primary" onclick="save()">保存修改</button>
									<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">保存并提交</button>
									<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
								</c:if>
								<c:if test="${(sessionScope.user.id == 2 or  sessionScope.user.id == 3) and map.task.name ne '提交申请'  and !map.isHandler }" >
									<button type="button" class="btn btn-primary" onclick="save()">保存</button>
								</c:if>
								<c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
									<button type="button" class="btn btn-primary" onclick="print(${map.business.processInstanceId })">打印</button>
								</c:if>
								<c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and (sessionScope.user.id eq '8' or sessionScope.user.id eq '477' )}">
									<button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
								</c:if>
								<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39'
									) && map.task.name eq '部门经理' && map.business.assistantStatus ne '1'}">
									<shiro:hasPermission name="fin:reimburse:assistantAffirm">
										<button type="button" class="btn btn-danger" onclick="disagree()">不同意</button>
										<button type="button" class="btn btn-warning" onclick="assistantConfirm()">助手确认</button>
									</shiro:hasPermission>
								</c:if>
								<%-- <c:forEach items="${sessionScope.user.positionList }" var="position">
                         				<c:if test="${ position.name eq '财务'  && (map.business.isSend eq '0' || map.business.isSend eq null) && map.business.status eq '6'  }">
                        					 <button type="button" class="btn btn-default" onclick="sendMail()">发送邮件</button>
                        				 </c:if>
                        		 </c:forEach> --%>
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</td>
						</tr>
						</tfoot>
					</table>
				</form>
			</div>
		</div>
	</section>

	<section class="col-md-12">
		<div class="box box-primary tbspace">
			<div class="box-body">
				<table id="table2" style="width:97%;">
					<thead>
					<tr><th colspan="20">处 理 流 程</th></tr>
					<tr>
						<td class="td_weight" style="width:10%;">环节</td>
						<td class="td_weight" style="width:9%">操作人</td>
						<td class="td_weight" style="width:15%">操作时间</td>
						<td class="td_weight" style="width:10%">操作结果</td>
						<td class="td_weight" style="width:56%">操作备注</td>
					</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
	</section>
</div>


<div id="deptDialog"></div>
<div id="projectDialog"></div>
<!-- 帮助文本模态框（Modal） -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
		<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">通用报销填写规范</h4>
			</div>
			<div class="modal-body">
				<p>
					双箭头符号⇌  单箭头符号→
				</p>
				<p>
						<span style="font-family: 宋体, SimSun"><span
								style="font-size: 12px;">1</span><span style="font-size: 12px;">、</span><span
								style="font-size: 19px;">外勤的费用同一天在同一个城市产生的公交地铁打的可写在一起</span><span
								style="font-size: 19px">,</span><span style="font-size: 19px;">在明细写清楚路线金额（</span><span
								style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
								style="font-size: 19px; color: rgb(51, 51, 51);">→</span><span
								style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
								style="font-size: 19px">+</span><span style="font-size: 19px;">交通工具</span><span
								style="font-size: 19px">+</span><span style="font-size: 19px;">某公司某客户）</span><span
								style="font-size: 19px">, </span><span style="font-size: 19px;">大家选择滴滴出行的，报销时请提供纸质的滴滴发票与行程单，行程单的金额必须与发票金额一致，行程单上须显示具体的起点与终点地址，不同时间、不同城市的分开填写路线金额。城际交通是同一天的写在一起，地点用双箭头标示，不是同一天的分开填写，地点之间用单箭头标示。</span></span>
				</p>
				<p>
						<span style="font-family: 宋体, SimSun"><span
								style="font-size: 19px;"><img
								src="http://www.reyzar.com/images/upload/20171011/1507707545581.png"
								_src="http://www.reyzar.com/images/upload/20171011/1507707545581.png" /></span></span>
				</p>
				<p>
						<span style="font-family: 宋体, SimSun"><span
								style="font-size: 19px;"><br /></span></span>
				</p>
				<p>
					<br />
				</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<!-- 模态框（Modal） -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; max-height: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					流程图
				</h4>
			</div>
			<div class="modal-body">
				<div id="imgcontainer"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->

	<%@ include file="../../common/footer.jsp"%>
	<!-- 全局变量 -->
	<script type="text/javascript">
        base = "<%=base%>";
	</script>
	<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>

	<!-- File upload widget -->
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

	<shiro:hasPermission name="fin:reimburse:decrypt">
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
	</shiro:hasPermission>

	<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
	<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>

	<script type="text/javascript" src="<%=base%>/views/manage/finance/reimburs/js/process.js"></script>
	<script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-select.js"></script>
	<script>
        var hasDecryptPermission = false;
        <shiro:hasPermission name="fin:reimburse:decrypt">
        hasDecryptPermission = true;
        </shiro:hasPermission>
        
        var seeall;
        <shiro:hasPermission name="fin:reimburse:seeall">
        seeall = true;
        </shiro:hasPermission>
        var variables = ${map.jsonMap.variables};
        // 操作表单
        var formElement = false;
        var disableElement = null;
        var editInvest = false;
        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
        formElement = true;
        </c:if>
        <c:if test="${((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '部门经理'  or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
        editInvest = true;
        </c:if>

        var submitPhase = ""; // 提交阶段，用于判断是重新提交申请、财务修改还是没有表单操作
        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
        submitPhase = "resubmit";
        </c:if>
        <c:if test="${(map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler }">
        submitPhase = "othersubmit";
        </c:if>
	</script>
</body>
</html>