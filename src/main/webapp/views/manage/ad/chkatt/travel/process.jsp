<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 {
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
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
#table1 thead th {
	border: none;
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
			<li class="active">行政管理</li>
			<li class="active">出差管理</li>
			<li class="active">出差处理</li>
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
						<select id="vehicle_hidden" style="display:none;">
							<custom:dictSelect type="出差管理交通工具"/>
						</select>
					
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="taskName" value="${map.task.name }">
						<input type="hidden" id="processInstanceId" value="${map.business.processInstanceId }">
						<input type="hidden" id="operStatus" value="">
						<input type="hidden" id="flagId" value="${map.business.userId }">
						<input type="hidden" id="isProcess" name="isProcess" value="${map.business.isProcess }">
						<c:if test="${map.business.userId eq sessionScope.user.id and ((map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) or fn:length(map.activityTaskList) > 1) }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or map.task.name ne '提交申请' }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>
						
						<table id="table1">
							<thead>
								<c:choose>
									<c:when test="${map.business.status eq '2' }">
										<tr><th colspan="20">出差详情表</th></tr>
									</c:when>
									<c:otherwise>
										<tr><th colspan="20">出差申请表</th></tr>
									</c:otherwise>
								</c:choose>
							</thead>
							<tbody>
								<tr>
									<td style="width:25%;" class="td_weight"><span>出差人员</span></td>

									<c:choose>
										<c:when test="${map.business.travelerName eq null and map.business.status eq '2'}">
											<td style="width:25%;"><input type="text" name="travelerName" value="${map.business.applicant.name }" readonly></td>
										</c:when>
										<c:otherwise>
											<td style="width:25%;"><input type="text" name="travelerName" value="${map.business.travelerName }" readonly></td>
										</c:otherwise>
									</c:choose>
									<td style="width:30%;" class="td_weight"><span>申请日期</span></td>
									
									<td style="width:20%;" colspan="2"><input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td class="td_weight"><span>单位</span></td>
									<td style="width:20%;text-align:left;white-space:nowrap ;font-size:14px">
										<c:choose>
										<c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) }">
											<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
												<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
												<c:if test="${map.business.applicant.dept.name ne '总经理'}">
													<input type="text" style="margin-left:-5px;height:20px;width:auto;" value="${map.business.applicant.dept.name}" readonly>
												</c:if>
											</c:if>
											<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
												<input name="title" value="10" type="hidden">
												<custom:getDictKey type="流程所属公司" value="10"/>
												<input  type="text"  style="height:20px;width:auto;" value="${map.business.applicant.dept.name }" readonly>
											</c:if>
										</c:when>
										<c:otherwise>
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
										</c:otherwise>
										</c:choose>
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
									<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
										<td class="td_weight"><span>操作</span></td>
									</c:if>
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
											<c:choose>
												<c:when test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
													<select name="vehicle">
														<custom:dictSelect type="出差管理交通工具" selectedValue="${business.vehicle }" />
													</select>	
												</c:when>
												<c:otherwise>
													<input type="text" value="<custom:getDictKey type="出差管理交通工具" value="${business.vehicle }"/>" readonly />
												</c:otherwise>
											</c:choose>
										</td>
										<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
											<td>
												<c:if test="${varStatus.last }">
													<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a>
												</c:if>
												<c:if test="${!varStatus.last }">
													<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
												</c:if>
											</td>
										</c:if>
									</tr>
								</c:forEach>
								
								<tr>
									<td class="td_weight">备注</td>
									<td colspan="20"><textarea id="comment" name="comment" rows="2" style="width:100%;" readonly>${map.business.comment }</textarea></td>
								</tr>
									
								<tr>
									<td class="td_weight"><span>附件</span></td>
										<td  colspan="2" style="border-right-style:hidden;">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly></a>
												<td colspan="2">
												<input type="file" id="file" name="file" style="display:none;">
												<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
										</td>
										</td>
								</tr>
								
								<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name ne '提交申请' and map.business.status eq '6' or (map.business.status eq '2'and map.business.isProcess eq '1')}">
									<tr>
										<td class="td_weight">出差确认</td>
										<td colspan="20"><textarea id="travelResult" placeholder="请填写出差结果确认" name="travelResult" rows="2" style="width:100%;" readonly>${map.business.travelResult }</textarea></td>
									</tr>
								</c:if>
							</tbody>
							<tfoot>
								<c:if test="${map.task.name ne '提交申请' and map.isHandler and map.business.status ne '6'}">
									<tr>
										<td colspan="20">
											<textarea id="comments" name="comments" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
										</td>
									</tr>
								</c:if>
							</tfoot>
						</table>
						<div style="width:90%; text-align:center;margin:auto;margin-top:5px;">
							<c:if test="${map.business.userId eq sessionScope.user.id and fn:length(map.activityTaskList) > 1 }">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请' and sessionScope.user.id ne '225' and map.business.status ne '6'}">
								<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请'}">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name ne '提交申请' and map.business.status eq '6' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(2)">确认</button>
							</c:if>
							<button type="button" id="cancel" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
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
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/travel/js/process.js"></script>
<script>
var variables = ${map.jsonMap.variables};
//操作表单
var formElement = null;
var disableElement = null;
<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id }">
formElement = 
{
	"budget": "input",	
	"reason": "input",
	"place": "select",
	"task": "input",
	"comment": "textarea",
	"travelerName":"input"
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