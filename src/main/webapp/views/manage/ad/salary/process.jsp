<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">绩效考核</li>
	</ol>
</header>

<style>
 table {
	table-collapse: collapse;
	border: none;
	margin: 0px 0px; 
	text-align: center;
	width: 100%;
	
}

#table thead th {
	border: none;
}

#table td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

 td {
	border: solid #999 1px;
	padding: 0px;
	font-size: 1em;
	text-align: center;
} 
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align: center;
	padding: 5px 1em;
	margin: 0px;
}
td input[type="radio"] {
	margin-left: 0.5em;
	vertical-align: middle;
}
td label {
	font-weight: normal;
}
td p {
	padding: 5px 1em;
	margin: 0px;
}
 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
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

textarea{
	border-left:0px;
	border-top:0px;
	border-right:0px;
	border-bottom:1px;
}
#ul_user li {
	list-style-type: none;
}
#ul_user li:hover {
	cursor: pointer;
	font-weight: bold;
	font-size: 1.2em;
}

.connectedSortable {
	padding-right: 0px;
}

td{
  white-space:nowrap !important;
}
</style>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
			<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
				<div class="box box-primary box-solid">
					<div class="box-body">
						<form id="form1">
							<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
							<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
							<input type="hidden" id="id" name="id" value="${map.business.id}">
							<input type="hidden" id="userid"  value="${map.business.userId}">
							<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
							<input type="hidden" id="encrypted" name=encrypted value="${map.business.encrypted }">
							<input type="hidden" id="processInstanceId" value="${map.business.processInstanceId }">
							<input type="hidden" id="operStatus" value="">
							<c:choose>
								<c:when
									test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
									<input type="hidden" id="approver" name="approver"
										value="${map.initiator.name }">
								</c:when>
								<c:otherwise>
									<input type="hidden" id="approver" name="approver"
										value="${sessionScope.user.name }">
								</c:otherwise>
							</c:choose>
							<table style="font-size: 12px;">
								<thead>
									<tr><input type="text" name="tittle" value="${map.business.tittle}" placeholder="请输入计划标题"  style="width:100%;line-height:100%;font-weight：bolder;font-size:24px;border:none;text-align:center;"></tr>
								</thead>
									<tr style="background-color:#d2d6de;height:35px;">
										<td class="td_weight"><span>序号</span></td>
										<td class="td_weight"><span>部门</span></td>
										<td class="td_weight"><span>姓名</span></td>
										<td class="td_weight"><span>职位</span></td>
										<td class="td_weight"><span>入职时间</span></td>
										<c:if test="${(sessionScope.user.id eq 2 )or ((sessionScope.user.id eq 8 or sessionScope.user.id eq 3 or sessionScope.user.id eq 5) and map.business.status eq '6')}">
										<td class="td_weight"><span>现行月薪</span></td>
										</c:if>
										<td class="td_weight"><span>考核分</span></td>
										<td class="td_weight"><span>上期调薪</span></td>
										<td class="td_weight"><span>上期调薪比例(%)</span></td>
									<%--	<c:if test="${(sessionScope.user.id eq 2 )or (sessionScope.user.id eq 3) }">--%>
										<td class="td_weight"><span>个人期望(%)</span></td>
										<td class="td_weight"><span>部门建议(%)</span></td>
										<c:if test="${((sessionScope.user.id eq 2  )or (sessionScope.user.id eq 3 and  map.business.status eq '6'))}">
										<td class="td_weight"><span>核准调幅(%)</span></td>
										</c:if>
									<%--	</c:if>--%>
										<c:if test="${sessionScope.user.id eq 2 or ((sessionScope.user.id eq 8 or sessionScope.user.id eq 3 or sessionScope.user.id eq 5) and map.business.status eq '6')}">
										<td class="td_weight"><span>计划月薪</span></td>
										</c:if>
										<td class="td_weight"><span>备注</span></td>
									</tr>
									
									<c:choose>
									<c:when test="${ ( (map.task.name eq '总经理') and sessionScope.user.id eq '2' ) or ( (map.task.name ne '总经理') and sessionScope.user.id eq '2' ) or  ( (map.business.status eq '6') and (sessionScope.user.id eq '5' or sessionScope.user.id eq '8' or sessionScope.user.id eq '3' )) }">
									<tbody>
										<c:forEach items="${map.business.salaryAttachList }" var="salary">
										<tr name = "node">
										<input type="hidden" name="Attachid" value="${salary.id }">
										<td style="width:3%;"><input  type="text" name="number" value = "" readonly></td>
										<td style="width:7%;"><input  type="text" value = "${salary.record.dept}" readonly></td>
										<input  name="AttachuserId"  type="hidden" value = "${salary.userId}" readonly>
										<td style="width:7%;"><input  type="text" value = "${salary.record.name}" readonly></td>
										<td style="width:7%;"><input  type="text" value = "${salary.record.position}" readonly></td>
										<td style="width:7%;"><input  type="text" value="<fmt:formatDate value="${salary.record.entryTime}" pattern="yyyy-MM-dd" />" readonly></td>
										<c:if test="${salary.salaryId eq 1}">
										<td style="width:7%;"><input  type="text" name="salary" style="text-align: right;" value = "${salary.record.salary}" readonly></td>
										</c:if>
										<c:if test="${salary.salaryId ne 1}">
											<td style="width:7%;"><input  type="text" name="salary" style="text-align: right;" value = "${salary.salary.salary}" readonly></td>
										</c:if>
										<td style="width:7%;"><input  name="score" type="text"  value="<fmt:formatNumber value='${salary.score}' pattern='#.#' />" readonly></td>
										<c:if test="${salary.salaryId eq 1}">
											<td style="width:7%;"><input  name="lastdate"  type="text" value="" readonly></td>
										</c:if>
										<c:if test="${salary.salaryId ne 1}">
												<td style="width:7%;"><input  name="lastdate"  type="text" value="<fmt:formatDate value="${salary.lastdate}" pattern="yyyy-MM-dd" />" readonly></td>
										</c:if>
											<c:if test="${salary.salaryId eq 1}">
												<td style="width:6%;"><input  name=""  type="text" value="" readonly></td>
											</c:if>
											<c:if test="${salary.salaryId ne 1}">
												<td style="width:6%;"><input  name="lastproportion"  type="text" value="" readonly></td>
											</c:if>

										<c:if test="${(sessionScope.user.id eq 2 )or (sessionScope.user.id eq 3) }">
										<td style="width:5%;"><input  name="personAmplitude" readonly  type="text" value = "${salary.personAmplitude}"></td>
										<td style="width:5%;"><input  name="manageAmplitude" readonly  type="text" value = "${salary.manageAmplitude}"></td>
										<td style="width:5%;"><input class="salary" name="finallyAmplitude"  type="text" value = "${salary.finallyAmplitude}" onkeyup="countmoney()"></td>
										</c:if>
										<td style="width:7%;"><input  name="finallySalary"  style="text-align: right;" type="text"  readonly value = "${salary.finallySalary}"></td>
										<td style="width:7%;"><input  name="remark"  type="text" value = "${salary.remark}"></td>
										</tr>
										</c:forEach>
									</tbody>
									</c:when>

										<c:otherwise>
											<tbody>
											<c:forEach items="${map.business.salaryAttachList }" var="salary">
												<c:if test="${(salary.record.deptId eq sessionScope.user.dept.id) or ((sessionScope.user.dept.id eq '3') and (salary.record.deptId eq '20')) }">
													<tr name = "node">
														<input type="hidden" name="Attachid" value="${salary.id }">
														<td style="width:3%;"><input  type="text" name="number" value = "" readonly></td>
														<td style="width:4%;"><input  type="text" value = "${salary.record.dept}" readonly></td>
														<input name="AttachuserId"  type="hidden" value = "${salary.record.userId}" readonly>
														<td style="width:7%;"><input  type="text" value = "${salary.record.name}" readonly></td>
														<td style="width:7%;"><input  type="text" value = "${salary.record.position}" readonly></td>
														<td style="width:7%;"><input  type="text" value="<fmt:formatDate value="${salary.record.entryTime}" pattern="yyyy-MM-dd" />" readonly></td>
														<td style="width:7%;"><input  name="score" type="text"  value = "${salary.score}" readonly></td>
														<c:if test="${salary.salaryId eq 1}">
															<td style="width:7%;"><input  name="lastdate"  type="text" value="" readonly></td>
														</c:if>
														<c:if test="${salary.salaryId ne 1}">
															<td style="width:7%;"><input  name="lastdate"  type="text" value="<fmt:formatDate value="${salary.lastdate}" pattern="yyyy-MM-dd" />" readonly></td>
														</c:if>
														<c:if test="${salary.salaryId ne 1}">
															<td style="width:6%;"><input  name="lastproportion"  type="text" value="" readonly></td>
														</c:if>
														<td style="width:7%;"><input  name="personAmplitude"  type="text" value = "${salary.personAmplitude}"></td>
														<td style="width:7%;"><input  name="manageAmplitude"  type="text" value = "${salary.manageAmplitude}"></td>
														<td style="width:7%;"><input  name="remark"  type="text" value = "${salary.remark}"></td>
													</tr>
												</c:if>
											</c:forEach>
											</tbody>
										</c:otherwise>
										
									</c:choose>
									
									
									<c:if test="${sessionScope.user.id eq '2'}">
									<tr>
										<td class="td_weight" colspan="2" style="width: 5%;"><span>现行平均薪酬</span></td>
										<td colspan="2">
											<input id="avgsalary"  type="text"  readonly >
										</td>
										<td class="td_weight"  style="width: 5%;"><span>现行总薪酬</span></td>
										<td colspan="2">
											<input id="sumsalary" type="text"  readonly >
										</td>
										<td class="td_weight" style="width: 5%;"><span>计划平均薪酬</span></td>
										<td colspan="2">
											<input id="finavgsalary"  type="text"  readonly >
										</td>
										<td class="td_weight" style="width: 5%;"><span>计划总薪酬</span></td>
										<td colspan="3">
											<input id="finsumsalary"  type="text"  readonly >
										</td>
									</tr> 
									</c:if>
									
									<tfoot>
									<c:if test="${map.isHandler and map.task.name ne '提交申请' }">
									<tr>
										<td colspan="34">
											<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:100%;height:100%;"></textarea>
										</td>
									</tr>
									</c:if>
									<tr>
										<td colspan="34"
											style="text-align: center; border: none; padding-top: 10px">
											<c:if test="${(map.business.userId eq sessionScope.user.id) and map.business.status eq '1'}">
												<button type="button" id="submitBtn" class="btn btn-primary"
													onclick="approve(1)">提交</button>
												<button type="button" class="btn btn-primary"
													onclick="approve(5)">取消申请</button>
											</c:if> 
											 <c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '总经理'}">
												<button type="button" class="btn btn-primary"
													onclick="approve(2)">提交</button>
											</c:if> 
											 <c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name eq '总经理'}">
												 	<button type="button" class="btn btn-primary"
													onclick="save()">保存</button>
											 		<button type="button" class="btn btn-primary"
													onclick="approve(6)">提交</button>
											 </c:if>
											<button type="button"
													class="btn btn-primary  fa fa-x fa-cloud-download"
													onclick="exportExcel()"></button>

											<button type="button" class="btn btn-default"
												onclick="javascript:window.history.back(-1)">返回</button>
										</td>
									</tr>
								</tfoot>
							</table>
						</form>
					</div>
				</div>
			</section>
	</section>
	<c:if test="${(sessionScope.user.id eq 3) or (sessionScope.user.id eq 2) }">
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
				<table id="table2" style="width:100%;">
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
		</div>
	</section>
	</c:if>
</div>
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
	var hasDecryptPermission = false;
	<shiro:hasPermission name="fin:travelreimburse:decrypt">
		hasDecryptPermission = true;
	</shiro:hasPermission>
</script>
<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/salary/js/process.js"></script>
</body>
</html>