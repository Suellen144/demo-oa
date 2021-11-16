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
 .textarea{
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
</style>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
			<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
				<div style="text-align: left;margin-bottom:3px;">
						<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toshow()">历史考评</button></td>
						<c:if test="${sessionScope.user.id eq 3}">
						<td><button id="addBtn" type="button" class="btn btn-primary" onclick="showAll()">当月考评</button></td>
						</c:if>
				</div>
				<div class="box box-primary box-solid">
					<div class="box-body">
						<form id="form">
						 	<input type="hidden" id="id" name="id" value="${kpi.id}">
						 	<input type="hidden" id="status" name="status" value="${kpi.status}">
						 	<input id="deptId" name="deptId"  type="hidden" value = "${kpi.deptId}"readonly>
						 	<input id="time" name="time"  type="hidden" value = "${kpi.time}"readonly>
							<table>
								<thead>
									<tr><th colspan="10" style="text-align:center; border:none; font-size: 1.5em;">绩效考核表(${kpi.time})</th></tr>
								</thead>
								<tbody>
									<tr style="background-color:#d2d6de;height:35px;">
										<td class="td_weight"><span>部门</span></td>
										<td class="td_weight"><span>姓名</span></td>
										<!-- <td class="td_weight"><span>考核月份</span></td> -->
										<td class="td_weight"><span>自我评分</span></td>
										<td class="td_weight"><span>自我评价</span></td>
										<td class="td_weight"><span>提交时间</span></td>
										<td class="td_weight"><span>部门评分</span></td>
										<td class="td_weight"><span>部门评价</span></td>
										<td class="td_weight"><span>奖惩</span></td>
									</tr>
										
										<c:forEach items="${kpiAttachs }" var="kpiAttach">
										<c:choose>
										<c:when test="${kpiAttach.userId eq (sessionScope.user.id)}">
										<tr name = "node">
										<input type="hidden" name="attachId" value="${kpiAttach.id}">
										<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
										<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
										<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
										<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
										<td style="width:12%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
										<td style="width:8%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
										<%-- <td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td> --%>
										<td style="width:6%;"><input type="text" id="userScore1" name="userScore"  value="${kpiAttach.userScore}"  ></td>
										<td style="width:25%;height: 50px;">
												<textarea title="${kpiAttach.userEvaluation}" class="textarea" id="userEvaluation1" name="userEvaluation" style="width:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.userEvaluation}</textarea>
										</td>
											<td style="width: 8%;">
												<input type="text" id="managerTime" name="userTime"  readonly value="<fmt:formatDate value="${kpiAttach.userTime}" pattern="yyyy-MM-dd" />"  >
											</td>
										<td style="width:6%;"><input id="ceoScore" name="ceoScore"  value="${kpiAttach.ceoScore}" type="text"  onkeyup="avgcount()" ></td>
										<td style="width:20%;">
												<textarea title="${kpiAttach.managerEvaluation}" id="managerEvaluation" name="managerEvaluation" placeholder="请输入评语" class="textarea" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.managerEvaluation}</textarea>
										</td>
										<td style="width:5%;">
												<input id="ceoPraisedPunished" type="text"  name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}">
										</td>
										<input id="ceoScore1" name="ceoScore"   value="${kpiAttach.ceoScore}" type="hidden"  >
										
										</tr>
										</c:when>


										<c:otherwise> 
										<tr name = "node">
										<input type="hidden" name="attachId" value="${kpiAttach.id}">
										<input name="userId"  type="hidden" value = "${kpiAttach.userId}"readonly>
										<input name="kpiId"  type="hidden" value = "${kpiAttach.kpiId}"readonly>
										<input name="dept"  type="hidden" value = "${kpiAttach.deptId}"readonly>
										<input name="attachdate"  type="hidden" value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM-dd" />" readonly>
										<td style="width:12%;"><input id="deptName" name="deptname"  type="text" value = "${kpiAttach.deptName}"readonly></td>
										<td style="width:8%;"><input id="userName" name="username"  type="text" value = "${kpiAttach.userName}" readonly></td>
										<%-- <td style="width:8%;"><input type="text"  id="date"  value="<fmt:formatDate value="${kpiAttach.date}" pattern="yyyy-MM" />"  size="18" readonly></td> --%>
										<td style="width:6%;"><input type="text" id="userScore" name="userScore"    value="${kpiAttach.userScore}" readonly ></td>
										<td style="width:25%;">
												<textarea title="${kpiAttach.userEvaluation}"  id="userEvaluation" name="userEvaluation" style="width:100%;height:57px;resize: none;text-align:left;outline:transparent;" readonly >${kpiAttach.userEvaluation}</textarea>
										</td>
											<td style="width: 8%;">
												<input type="text" id="userTime" name="userTime"  readonly  value="<fmt:formatDate value="${kpiAttach.userTime}" pattern="yyyy-MM-dd" />"  >
											</td>
										<td style="width:6%;"><input id="ceoScore" name="ceoScore"  value="${kpiAttach.ceoScore}" type="text"  onkeyup="avgcount()" ></td>
										<td style="width:20%;">
												<textarea title="${kpiAttach.managerEvaluation}"  id="managerEvaluation" name="managerEvaluation" placeholder="请输入评语" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" >${kpiAttach.managerEvaluation}</textarea>
										</td>
										<td style="width:5%;">
										<input id="ceoPraisedPunished" name="ceoPraisedPunished"   value="${kpiAttach.ceoPraisedPunished}" type="text"  >
										</td>
										<input id="ceoScore1" name="ceoScore"   value="${kpiAttach.ceoScore}" type="hidden"  >
										</tr>
										</c:otherwise>
										</c:choose>
										</c:forEach>
										<td class="td_weight"><span>部门人数</span></td>
										<td colspan="2">
											<input id="number" name="number" type="text"  readonly >
										</td>
										<td class="td_weight"><span>自评平均分</span></td>
										<td>
											<input id="personavgScore" name="personavgScore" type="text" readonly >
										</td>
										<td class="td_weight"><span>部门平均分</span></td>
										<td colspan="3">
											<input id="avagScore" name="avagScore" type="text"  readonly >
										</td>
								</tbody>
							</table>
								<div style="width:100%; text-align:center;margin-top:5px;">
									<button id="save_btn" type="button" class="btn btn-primary" onclick="save()" >保存</button>
									<button id="approve_btn" type="button" class="btn btn-primary" onclick="approve()" >提交</button>
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
<script type="text/javascript" src="<%=base%>/views/manage/ad/kpi/js/manager.js"></script> 
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>
</body>
</html>