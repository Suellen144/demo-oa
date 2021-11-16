<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 {
	width: 85%;
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}
#table1 td, #table2 td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span, #table2 td span {
	padding: 0px 15px;
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
}

.td_weight {
	font-weight: bold;
}

.nest_td {
	padding: 0px !important;
}
.nest_td table {
	width: 100% !important;
}
.nest_td td {
	border: none !important;
}
.nest_td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
td.nest_td_left {
	border-right: solid #999 1px !important;
	width: 30% !important;
}
</style>
</head>
<body>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<table id="table1">
							<thead>
								<tr><th colspan="20">
									出差申请表
								</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:25%;" class="td_weight"><span>出差人员</span></td>
									<td style="width:25%;"><input type="text" name="userName" value="${map.business.applicant.name }" readonly></td>
									<td style="width:20%;" class="td_weight"><span>提交日期</span></td>
									<td colspan="2"><input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td class="td_weight"><span>单位</span></td>
									<td style="width:20%;line-height:inherit;text-align:left;">
										<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
										<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
										<c:if test="${map.business.applicant.dept.name ne '总经理'}">
										<input type="text" style="margin-left:-5px;height:20px;width:auto;" value="${map.business.applicant.dept.name}" readonly>
										</c:if>
										</c:if>
										<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  style="height:20px;width:auto;" value="${map.business.applicant.dept.name}" readonly>
										</c:if>
									</td>
									<td class="td_weight"><span>费用预算</span></td>
									<td colspan="2"><input type="text" id="budget" name="budget" value="<fmt:formatNumber value="${map.business.budget }" pattern="#.##" />" readonly></td>
								</tr>
								<tr>
									<td class="td_weight"><span>出差日期</span></td>
									<td colspan="2" class="nest_td">
										<table>
											<tr>
												<td class="nest_td_left td_weight"><span>出差地点</span></td>
												<td class="td_weight"><span>出差事由</span></td>
											</tr>
										</table>
									</td>
									<td class="td_weight"><span>交通工具</span></td>
								</tr>
								<c:forEach items="${map.business.travelAttachList }" var="business" varStatus="varStatus">
									<tr name="node">
										<input type="hidden" name="travelAttachId" value="${business.id }">
										<td style="padding: 0px;">
											<input name="beginDate" type="text" class="beginDate" style="width:43%; text-align:center;" value="<fmt:formatDate value="${business.beginDate }" pattern="yyyy-MM-dd" />" readonly>
											至
										    <input name="endDate" type="text" class="endDate" style="width:43%; text-align:center;" value="<fmt:formatDate value="${business.endDate }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td colspan="2" class="nest_td">
											<table>
												<tr>
													<td class="nest_td_left"><input type="text" name="place" value="${business.place }" readonly></td>
													<td><input type="text" name="task" value="${business.task }" readonly></td>
												</tr>
											</table>
										</td>
										<td>
											<input type="text" value="<custom:getDictKey type="出差管理交通工具" value="${business.vehicle }"/>" readonly />
										</td>
									</tr>
								</c:forEach>
								
								<tr>
									<td>备注</td>
									<td colspan="20"><textarea id="comment" name="comment" rows="2" style="width:100%;" readonly>${map.business.comment }</textarea></td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="20">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'><input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly></a>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
		</div>
	</section>
	
	<section class="col-md-12">
		<div class="box box-primary tbspace">
			<table id="table2">
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
	</section>
</div>

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
            <!-- <button type="button" class="btn btn-primary">选择</button> -->
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/travel/js/view.js"></script>
<script>
var variables = JSON.parse('${map.jsonMap.variables}');
//操作表单
var formElement = null;
var disableElement = null;
<c:if test="${map.task.name eq '提交申请' and map.business.userId eq sessionScope.user.id }">
formElement = 
{
	"budget": "input",	
	"reason": "input",
	"place": "select",
	"task": "input",
	"comment": "input"
};
disableElement = {
	"applyTime": "input",
	"userName": "input",
	"deptName": "input"
};
</c:if>
</script>
</body>
</html>