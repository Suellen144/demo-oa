<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
#table1, #table2,#table3,#table4,#table5 {
	width: 90%;
	text-align:center;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td, #table3 td, #table4 td, #table5 td {
	border: solid #999 1px;
	padding: 5px;
	width:16.6%;
}
#table1 td input[type="text"],#table3 td input[type="text"],#table4 td input[type="text"],#table5 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span, #table2 td span, #table3 td span, #table4 td span, #table5 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th, #table2 th, #table3 th, #table4 th, #table5 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
#table1 thead th,#table3 thead th,#table4 thead th,#table5 thead th {
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
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">项目管理</li>
			<li class="active">项目立项流程审批</li>
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
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.statusNew }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="operStatus" value="">
						<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						<input type="hidden" id="isHandler" value="${map.isHandler}">
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
						<input type="hidden" id="userDeptId" name="userDeptId" value="${map.business.deptD.id}">
						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
							<c:choose>
								<c:when test="${map.business.statusNew eq '5' }">
									<tr><th colspan="12">项目详情</th></tr>
								</c:when>
								<c:otherwise>
									<tr><th colspan="12">立项申请</th></tr>
								</c:otherwise>
							</c:choose>
							</thead>							
						</div>
						<table id="table1">
						<c:choose>
						<c:when test="${map.business.statusNew eq '5' }">
						<c:if test="${map.business.applicant !=null and map.business.applicant ne ''}">
						<div style="float: right;position: absolute;margin: auto;right: 91px;top: 6px;">
							<button id="cancelBtn" type="button" class="btn btn-primary" onclick="toModify()">变更申请</button>	
							<button id="cancelBtn" type="button" class="btn btn-primary" onclick="toHistory()">变更历史记录</button>
						</div>
						</c:if>
						<tbody>
								<tr>
									<td colspan="2">项目名称</td>
									<td colspan="2">
										<input type="text" id="name" name="name" value="${map.business.name }" readonly>
									</td>
									<td colspan="2">负责人</td>
									<c:choose>
										<c:when test="${sessionScope.user.id eq '2' || sessionScope.user.id eq '3'}">
											<td colspan="2" onclick="openDialog(this)">
										</c:when>
										<c:otherwise>
											<td colspan="2">
										</c:otherwise>
									</c:choose>
										<input id="userId" name="userId" type="text" style="display:none;" value="${map.business.principal.id }">
										<input type="text" id="userName"  name="userName" value="${map.business.principal.name }" readonly>
									</td>


									<td colspan="2">规模(元)</td>
									<td colspan="2"><input type="text" name="size" id="size" value="${map.business.size }"></td>
								</tr>
								<tr>
									<td colspan="2">合同金额</td>
									<td colspan="2">
										<input type="text" id="barginMoney" value="" readonly>
									</td>
									<td colspan="2">收入</td>
									<td colspan="2"><input type="text" id="income" value="" readonly></td>
									<td colspan="2">支出</td>
									<td colspan="2"><input type="text" id="pay" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="2">已使用公关费用</td>
									<c:choose>
									<c:when test="${sessionScope.user.dept.id eq '2' or sessionScope.user.dept.id eq '4' }">
									<td colspan="2" onclick="show()"><input type="text" name="ggMoney" value="" readonly></td>
									</c:when>
									<c:otherwise>
									<td colspan="2"><input type="text" name="ggMoney" value="" readonly></td>
									</c:otherwise>
									</c:choose>
									<td colspan="2">归属部门</td>
									<td colspan="2">
										<input id="dutyDeptId" name="dutyDeptId" type="text" style="display:none;" value="${map.business.deptD.id}">
										<input type="text" id="dutyDeptName" name="dutyDeptName" value="${map.business.deptD.name}" readonly>
									</td>
									<td colspan="2">立项时间</td>
									<td colspan="2">
										<input type="text" id="projectDate" name="projectDate" value="<fmt:formatDate value="${map.business.projectDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="2">结束时间</td>
									<td colspan="2">
										<input type="text" id="projectEndDate" class="projectEndDate" name="projectEndDate" value="<fmt:formatDate value="${map.business.projectEndDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td colspan="2">状态</td>
									<td colspan="2">
									<select id="status" name="status"  style="width:30%; text-align: center;text-align-last: center;">
											<option value="1" <c:if test="${map.business.status == '1'}"> selected </c:if>>活动</option>
											<option value="-1" <c:if test="${map.business.status == '-1'}"> selected </c:if>>关闭</option>
											<option value="0" <c:if test="${map.business.status == '0'}"> selected </c:if>>注销</option>
										</select>
									</td>
									<td colspan="2">渠道费用额度</td>
									<td colspan="2"><input type="text" id="channelExpense" name="channelExpense" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="2">已支付渠道费用</td>
									<td colspan="2"><input type="text" id="channelHave"  value="" readonly></td>
									<td colspan="2">未支付渠道费用</td>
									<td colspan="2"><input type="text" id="channelNot"  value="" readonly></td>
									<td colspan="2">业绩贡献</td>
									<td colspan="2"><input type="text" id="results"  value="" readonly></td>
								</tr>
								<tr>
									<td colspan="2">提成额度</td>
									<td colspan="2"><input type="text" id="commission"  value="" readonly></td>
									<td colspan="2">申请人</td>
									<td colspan="2" id="td2"><input type="text"  value="${map.business.applicantP.name}" readonly>
									<input type="hidden" id="applicant" name="applicant" value="${map.business.applicantP.id}" readonly></td>
									<td colspan="2">申请时间</td>
									<td colspan="2"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${map.business.submitDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td colspan="2">立项原因</td>
									<td colspan="13">
										<textarea id="reason" name="reason" placeholder="立项原因" rows="3" cols="30">${map.business.reason}</textarea>
									</td>
								</tr>
								<tr>
									<td colspan="2">项目描述</td>
									<td colspan="13">
										<textarea id="describe" name="describe" placeholder="项目描述" rows="3" cols="30">${map.business.describe}</textarea>
									</td>
								</tr>
								<tr>
									<td colspan="2">附件</td>
									<td colspan="13" >
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
											</a>
										</c:if>
									</td>
								</tr>
							</tbody>
						</c:when>
						<c:otherwise>
						<c:choose>
							<c:when test="${(map.task.name eq '提交申请' or map.task.name eq '项目负责人') and map.business.applicantP.id eq sessionScope.user.id }">
							<tbody>
								<tr>
									<td><span>项目名称</span></td>
									<td><input type="text" id ="name" name="name" value="${map.business.name}" autocomplete='off'></td>
									<td><span>规模(元)</span></td>
									<td>
										<input type="text" name="size" id="size" value="${map.business.size}">
									</td>
									<td><span>立项时间</span></td>
									<td colspan="7"><input id="projectDate" name="projectDate" size="18" class="projectDate" value='<fmt:formatDate value="${map.business.projectDate }" pattern="yyyy-MM-dd" />' style="width:100%;border:0;text-align: center;" autocomplete='off' readonly></td>
								</tr>
								<tr>
									<td><span>负责人</span></td>
									<td onclick="openDialog(this)">
										<input id="userId" name="userId" type="text" style="display:none;" value="${map.business.userId}">
										<input type="text" id="userName" name="userName" value="${map.business.principal.name}"  autocomplete='off' readonly>
									</td>
									<td><span>负责部门</span></td>
									<td>
										<input id="dutyDeptId" name="dutyDeptId" type="text" style="display:none;" value="${map.business.deptD.id}">
										<input id="dutyDept" name="dutyDept" type="text" style="display:none;width: 30%" value=" " readonly>
										<input type="text" name="deptName" id="deptName" style="width: 32%" value="${map.business.deptD.name}" autocomplete='off' readonly>
									</td>
									<td><span>申请人</span></td>
									<td colspan="7">
										<input id="applicant" name="applicant" type="text" style="display:none;" value="${map.business.applicantP.id }">
										<input type="text" id="" value="${map.business.applicantP.name }" readonly>
									</td>
								</tr>
								<tr>
									<td><span>立项原因</span></td>
									<td colspan="14">
										<textarea id="reason" name="reason" placeholder="立项原因" rows="3" cols="30" readonly>${map.business.reason}</textarea>
									</td>
								</tr>
								<tr>
									<td><span>项目描述</span></td>
									<td colspan="14">
										<textarea id="describe" name="describe" placeholder="项目描述" rows="3" cols="30">${map.business.describe}</textarea>
									</td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="10" style="border-right-style:hidden;">
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
							</tbody>
							</c:when>
						<c:otherwise>
						<tbody>
								<tr>
									<td><span>项目名称</span></td>
									<td><input type="text" id ="name" name="name" value="${map.business.name}" autocomplete='off'></td>
									<td><span>规模(元)</span></td>
									<td>
										<input type="text" name="size" id="size" value="${map.business.size}">
									</td>
									<td><span>立项时间</span></td>
									<td colspan="7"><input id="projectDate" name="projectDate" size="18" class="projectDate" value='<fmt:formatDate value="${map.business.projectDate }" pattern="yyyy-MM-dd" />' style="width:100%;border:0;text-align: center;" autocomplete='off' readonly></td>
								</tr>
								<tr>
									<td><span>负责人</span></td>
								<c:if test="${map.task.name ne '项目负责人'}">
									<td onclick="openDialog(this)">
								</c:if>
								<c:if test="${map.task.name eq '项目负责人'}">
									<td>
								</c:if>
										<input id="userId" name="userId" type="text" style="display:none;" value="${map.business.userId}">
										<input type="text" id="userName" name="userName" value="${map.business.principal.name}"  autocomplete='off' readonly>
									</td>
									<td><span>负责部门</span></td>
									<td>
										<input id="dutyDeptId" name="dutyDeptId" type="text" style="display:none;" value="${map.business.deptD.id}">
										<input id="dutyDept" name="dutyDept" type="text" style="display:none;width: 30%" value=" " readonly>
										<input type="text" name="deptName" id="deptName" style="width: 30%" value="${map.business.deptD.name}" autocomplete='off' readonly>
									</td>
									<td><span>申请人</span></td>
									<td colspan="7">
										<input id="applicant" name="applicant" type="text" style="display:none;" value="${map.business.applicantP.id }">
										<input type="text" id="" value="${map.business.applicantP.name }" readonly>
									</td>
								</tr>
								<%--<tr>
									<td  colspan="2"><span>单位</span></td>
									<td  colspan="2" style="line-height:inherit;text-align:left;">
										<c:if test="${map.business.deptA.name ne '东北办事处' and map.business.deptA.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
											<c:if test="${map.business.deptA.name ne '总经理'}">
												${map.business.deptA.name}
											</c:if>
										</c:if>
										<c:if test="${map.business.deptA.name eq '东北办事处' or map.business.deptA.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											${map.business.deptA.name }
										</c:if>
									</td>
									<td  colspan="2"><span>申请人</span></td>
									<td  colspan="2">
										<input id="applicant" name="applicant" type="text" style="display:none;" value="${map.business.applicantP.id }">
										<input type="text" id="" value="${map.business.applicantP.name }" readonly>
									</td>
									<td  colspan="2"><span>提交时间</span></td>
									<td colspan="2" style="width: 25%"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${map.business.createDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>--%>
								<tr>
									<td><span>立项原因</span></td>
									<td colspan="14">
										<textarea id="reason" name="reason" placeholder="立项原因" rows="3" cols="30">${map.business.reason}</textarea>
									</td>
								</tr>
								<tr>
									<td><span>项目描述</span></td>
									<td colspan="14">
										<textarea id="describe" name="describe" placeholder="项目描述" rows="3" cols="30">${map.business.describe}</textarea>
									</td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="10" style="border-right-style:hidden;">
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
							</tbody>
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
							</c:otherwise>
							</c:choose>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
						<c:choose>
						<c:when test="${map.business.statusNew eq '5' }">
						<table id="table3" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td>姓名</td>
									<%--<td>业绩比例</td>--%>
									<td>业绩分配</td>
								</tr>
								</thead>
							<tbody id="tbodyInfoTr1">
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
						</table>
						</c:when>
						<c:otherwise>
						<table id="table3" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td>姓名</td>
									<%--<td>业绩比例</td>--%>
									<td>业绩分配</td>
								</tr>
								</thead>
							<tbody id="tbodyInfoTr">
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
						</table>
						</c:otherwise>
						</c:choose>
						<c:if test="${map.business.statusNew eq '5' }">
							<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目合同</span>
							<c:if test="${map.business.status ne '-1' and map.business.status ne '0'}">
								<div style="float: right;position: absolute;margin: auto;right: 0px;top: 6px;">
									<button type="button" class="btn btn-primary"  onclick="toAddOrEdit()">添加合同</button>
									<button type="button" class="btn btn-primary"  onclick="toPayAdd()">付款申请</button>
									<%--<button type="button" class="btn btn-primary"  onclick="toCollectionAdd()">收款申请</button>--%>
								</div>
							</c:if>
						</div>
						<table id="table4" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td style="width: 15%">合同名称</td>
									<td style="width: 15%">金额</td>
									<td style="width: 15%">签订方</td>
									<td style="width: 15%">类型</td>
									<td style="width: 15%">有效期</td>
									<td style="width: 15%">审批环节</td>
								</tr>
								</thead>
							<tbody>
							</tbody>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目开支</span>
						</div>
						<table id="table5" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td style="width: 15%">开支类型</td>
									<td style="width: 15%">开支人</td>
									<td style="width: 15%">开支时间</td>
									<td style="width: 15%">报销单号</td>
									<td style="width: 15%">开支金额</td>
									<td style="width: 15%">审批环节</td>
								</tr>
								</thead>
							<tbody id="table5_spending">
							</tbody>
						</table>
						</c:if>
						<div style="width: 100%; text-align: center;margin-top: 6px" class="form-group" >
							<c:if test="${map.business.applicantP.id eq sessionScope.user.id and (map.task.name eq '项目负责人')}">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
							</c:if>
							<c:if test="${map.business.applicant eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.business.statusNew eq '5'}">
							<button type="button" class="btn btn-primary" onclick="save()">保存</button>
							</c:if>
							<c:if test="${(sessionScope.user.dept.id eq '2' or sessionScope.user.dept.id eq '4') and map.business.statusNew eq '5' }">
							<button type="button" class="btn btn-warning" onclick="del()" >删除</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>	
		</div>				
	</section>
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<table id="table2" style="width: 90%">
						<thead>
							<tr><th colspan="20" style="text-align: center;font-weight: bolder;font-size: 1.5em;">处 理 流 程</th></tr>
							<tr style="font-weight: bolder;">
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
<div id="barginDialog"></div>
<div id="userByDeptDialog"></div>
<div id="userDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="tacklingModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:50%;">
		<div class="modal-content" >
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">攻关费用调整</h4>
			</div>
			<div class="modal-body">
				<div style="text-align:center;">
				<table style="margin:auto">
				<tr>
				<td>攻关费用额度 ：</td>
				<td ><input type="text" id="momeyNum" name="momey" value="${map.business.researchCostLines}" style="text-align:center" /></td>
				</tr>
				<tr>
				<td>攻关费用支出 ：</td>
				<td><span id="spending"></span></td>
				</tr>
				<tr>
				<td>攻关费用余额 ：</td>
				<td><span id="balance"></span></td>
				</tr>
				<tr>
				<td colspan="2"><button type="button" id="submitBtn" class="btn btn-primary" onclick="change()" style="margin-right:15px;">确认调整</button></td>
				</tr>
				</table>
				</div>
			<div style="padding-top:20px;height:auto;">
				<table id="ggtable" style="width:100%;border: 1px solid #ccc;text-align: center;line-height: 30px;">
					<tr><td colspan="12">攻关费用额度调整记录</td></tr>
					<tr name="" class="node trnode" style='border-top: 1px solid #ccc;'>
						<td colspan="4">时间</td>
						<td colspan="4" style="border-left:1px solid #ccc;border-right:1px solid #ccc">额度</td>
						<td colspan="4">操作人</td>
					</tr>
					<tbody class="tlist"></tbody>
				</table>
			</div>
		   </div><!-- /.modal-content -->
		</div>
	</div>
</div>
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
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/process.js"></script>
<script type="text/javascript">
	base = "<%=base%>";
	var variables=${map.jsonMap.variables};

	var isCashier = false;
	var userId=${sessionScope.user.id};
	var status=${map.business.statusNew};
	
	if(userId==3&&status==5){
		isCashier = true;
	}
	
	var isCashierTask = false;
	if(status==4){
		isCashierTask = true;
	}
	
	//已归档 
	if(status==5){
		$("#saveBtn").hide();
		$("#updateFormBtn").hide();
	}
	
/* 	var describe = "${map.business.describe}";
	$("#describe").val(describe);  */
</script>
</body>
</html>