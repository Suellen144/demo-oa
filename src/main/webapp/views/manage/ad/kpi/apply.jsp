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
		border:0;
		background-color:transparent;
		/*scrollbar-arrow-color:yellow;
        scrollbar-base-color:lightsalmon;
        overflow: hidden;*/
		/* color: #666464;*/
		height: auto;
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
</style>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div style="text-align: left;margin-bottom:3px;margin-left:15px;">
			<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toshow()">历史考评</button></td>
		</div>
		<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
			<div class="box box-primary box-solid">
				<!-- <div class="box-header with-border">
                       <h3>绩效考核</h3>
                </div> -->
				<div class="box-body">
					<form id="form">
						<input id="status" name="satus"  type="hidden" value = "${status}"readonly>
						<table>
							<thead>
							<tr><th colspan="10" style="text-align:center; border:none; font-size: 1.5em;">绩效考核表</th></tr>
							</thead>
							<tbody>
							<tr style="background-color:#d2d6de;height:35px;">
								<td class="td_weight"><span>部门</span></td>
								<td class="td_weight"><span>姓名</span></td>
								<td class="td_weight"><span>考核月份</span></td>
								<td class="td_weight"><span>自我评分</span></td>
								<td class="td_weight"><span>自我评价</span></td>
								<td class="td_weight"><span>部门评分</span></td>
								<td class="td_weight"><span>部门评价</span></td>
								<td class="td_weight"><span>部门奖惩</span></td>
							</tr>
							<c:forEach items="${kpiAttachs1 }" var="kpiAttach">
								<tr name = "node" id = "market">
									<input name="Id"  type="hidden" value = "${kpiAttach.id}"readonly>
									<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
									<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
									<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
									<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
									<td style="width:7%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
									<td style="width:7%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
									<td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td>
									<td style="width:6%;"><input type="text" id="userScore" name="userScore" readonly  value="${kpiAttach.userScore}" ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.userEvaluation}" id="userEvaluation" name="userEvaluation" readonly style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
									</td>

									<td style="width:6%;"><input id="managerScore" name="managerScore"  value="${kpiAttach.managerScore}" type="text" onkeyup="avgcount()" ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.managerEvaluation}" id="managerEvaluation" name="managerEvaluation" onclick="inittextarea()" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.managerEvaluation}</textarea>
									</td>
									<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  ></td>
								</tr>
							</c:forEach>
							<c:if test="${not empty kpiAttachs1}">
								<tr>
									<td class="td_weight"><span>部门人数</span></td>
									<td colspan="1">
										<input id="marketSum" name="marketSum" type="text"  readonly >
									</td>
									<td class="td_weight"><span>自评平均分</span></td>
									<td colspan="1">
										<input id="marketPersonalScore" name="marketPersonalScore" type="text" readonly >
									</td>
									<td class="td_weight"><span>部门平均分</span></td>
									<td colspan="1">
										<input id="marketScore" name="marketScore" type="text"  readonly >
									</td>
								</tr>
								<tr style="background-color:#d2d6de;height:35px;">
									<td class="td_weight"><span>部门</span></td>
									<td class="td_weight"><span>姓名</span></td>
									<td class="td_weight"><span>考核月份</span></td>
									<td class="td_weight"><span>自我评分</span></td>
									<td class="td_weight"><span>自我评价</span></td>
									<td class="td_weight"><span>部门评分</span></td>
									<td class="td_weight"><span>部门评价</span></td>
									<td class="td_weight"><span>部门奖惩</span></td>
								</tr>
							</c:if>
							<c:forEach items="${kpiAttachs2 }" var="kpiAttach">
								<c:choose>
									<c:when test="${kpiAttach.userId eq (sessionScope.user.id)}">
										<tr name = "node" id = "engineer">
											<input name="Id"  type="hidden" value = "${kpiAttach.id}"readonly>
											<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
											<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
											<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
											<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
											<td style="width:7%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
											<td style="width:7%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
											<td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td>
											<td style="width:6%;"><input type="text" id="userScore" name="userScore"   value="${kpiAttach.userScore}" ></td>
											<td style="width:20%;">
												<textarea title="${kpiAttach.userEvaluation}" id="userEvaluation" name="userEvaluation"  style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
											</td>
											<td style="width:6%;"><input id="managerScore" name="managerScore"   value="${kpiAttach.managerScore}" type="text" onkeyup="avgcount()"   ></td>
											<td style="width:20%;">
												<textarea title="${kpiAttach.managerEvaluation}"  id="managerEvaluation" name="managerEvaluation" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.managerEvaluation}</textarea>
											</td>
											<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  ></td>
										</tr>
									</c:when>

									<c:otherwise>
										<tr name = "node" id = "engineer">
											<input name="Id"  type="hidden" value = "${kpiAttach.id}"readonly>
											<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
											<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
											<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
											<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
											<td style="width:7%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
											<td style="width:7%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
											<td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td>
											<td style="width:6%;"><input type="text" id="userScore" name="userScore"   readonly value="${kpiAttach.userScore}" ></td>
											<td style="width:20%;">
												<textarea title="${kpiAttach.userEvaluation}"  id="userEvaluation" name="userEvaluation"   readonly style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
											</td>

											<td style="width:6%;"><input id="managerScore" name="managerScore"   value="${kpiAttach.managerScore}" type="text" onkeyup="avgcount()"   ></td>
											<td style="width:20%;">
												<textarea title="${kpiAttach.managerEvaluation}"  id="managerEvaluation" name="managerEvaluation" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.managerEvaluation}</textarea>
											</td>
											<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  ></td>
										</tr>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${not empty kpiAttachs2}">
								<tr>
									<td class="td_weight"><span>部门人数</span></td>
									<td colspan="1">
										<input id="engineerSum" name="engineerSum" type="text"  readonly >
									</td>
									<td class="td_weight"><span>自评平均分</span></td>
									<td colspan="1">
										<input id="engineerPersonalScore" name="engineerPersonalScore" type="text"  readonly >
									</td>
									<td class="td_weight"><span>部门平均分</span></td>
									<td colspan="4">
										<input id="engineerScore" name="engineerScore" type="text" readonly >
									</td>
								</tr>
							</c:if>

							<tr style="background-color:#d2d6de;height:35px;">
								<td class="td_weight"><span>部门</span></td>
								<td class="td_weight"><span>姓名</span></td>
								<td class="td_weight"><span>考核月份</span></td>
								<td class="td_weight"><span>自我评分</span></td>
								<td class="td_weight"><span>自我评价</span></td>
								<td class="td_weight"><span>部门评分</span></td>
								<td class="td_weight"><span>部门评价</span></td>
								<td class="td_weight"><span>部门奖惩</span></td>
							</tr>

							<c:forEach items="${kpiAttachs3 }" var="kpiAttach">
								<tr name = "node" id = "develop">
									<input name="Id"  type="hidden" value = "${kpiAttach.id}"readonly>
									<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
									<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
									<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
									<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
									<td style="width:7%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
									<td style="width:7%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
									<td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td>
									<td style="width:6%;"><input type="text" id="userScore" name="userScore" readonly  value="${kpiAttach.userScore}" ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.userEvaluation}" id="userEvaluation" name="userEvaluation" readonly style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
									</td>

									<td style="width:6%;"><input id="managerScore" name="managerScore"   value="${kpiAttach.managerScore}" type="text" onkeyup="avgcount()"  ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.managerEvaluation}"  id="managerEvaluation" name="managerEvaluation" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;">${kpiAttach.managerEvaluation}</textarea>
									</td>
									<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  ></td>
								</tr>
							</c:forEach>
							<c:if test="${not empty kpiAttachs3}">
								<tr>
									<td class="td_weight"><span>部门人数</span></td>
									<td colspan="1">
										<input id="developSum" name="developSum" type="text"  readonly >
									</td>
									<td class="td_weight"><span>自评平均分</span></td>
									<td colspan="1">
										<input id="developPersonalScore" name="developPersonalScore" type="text"   readonly >
									</td>
									<td class="td_weight"><span>部门平均分</span></td>
									<td colspan="4">
										<input id="developScore" name="developScore" type="text" readonly >
									</td>
								</tr>
							</c:if>
							<c:forEach items="${kpiAttachs4 }" var="kpiAttach">
								<tr name = "node" id = "admin">
									<input name="Id"  type="hidden" value = "${kpiAttach.id}"readonly>
									<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
									<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
									<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
									<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
									<td style="width:7%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
									<td style="width:7%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
									<td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td>
									<td style="width:6%;"><input type="text" id="userScore" name="userScore" readonly  value="${kpiAttach.userScore}" ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.userEvaluation}"  id="userEvaluation" name="userEvaluation" readonly style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
									</td>
									<td style="width:6%;"><input id="managerScore" name="managerScore"   value="${kpiAttach.managerScore}" type="text"  onkeyup="avgcount()" ></td>
									<td style="width:20%;">
										<textarea title="${kpiAttach.managerEvaluation}"  id="managerEvaluation" name="managerEvaluation" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;"  >${kpiAttach.managerEvaluation}</textarea>
									</td>
									<td style="width:6%;"><input id="ceoScore" name="ceoScore"   value="${kpiAttach.ceoScore}" type="text" onkeyup="avgcount()"  ></td>
									<td style="width:6%;"><input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  ></td>
								</tr>
							</c:forEach>
							<c:if test="${not empty kpiAttachs4}">
								<tr>
									<td class="td_weight"><span>部门人数</span></td>
									<td colspan="1">
										<input id="adminSum" name="adminSum" type="text" readonly >
									</td>
									<td class="td_weight"><span>自评平均分</span></td>
									<td colspan="1">
										<input id="adminPersonalScore" name="adminPersonalScore" type="text"  readonly >
									</td>
									<td class="td_weight"><span>部门平均分</span></td>
									<td colspan="4">
										<input id="adminScore" name="adminScore" type="text"  readonly >
									</td>
								</tr>
							</c:if>
							</tbody>
						</table>
						<div style="width:100%; text-align:center;margin-top:5px;">
							<button id="save_btn" type="button" class="btn btn-primary"  onclick="save()" >保存</button>
							<button id="apprve_btn" type="button" class="btn btn-primary"  onclick="approve()" >提交</button>
						</div>
					</form>
				</div>
			</div>
		</section>
	</section>
</div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/kpi/js/apply.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>
</body>
</html>