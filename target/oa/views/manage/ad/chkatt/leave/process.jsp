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
	background-color: white;
}
#table1 td, #table2 td {
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span, #table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
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
			<li class="active">行政管理</li>
			<li class="active">请假管理</li>
			<li class="active">请假处理</li>
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
						<input type="hidden" id="id" name="id" value="${map.business.id }">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId }">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
						<input type="hidden" id="isOk" name="isOk" value="${map.business.isOk }">
						
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">		
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请' and map.task.name ne '部门经理') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>		
					
					
					
					
						<table id="table1">
							<c:choose>
								<c:when test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
									<thead>
										<c:choose>
											<c:when test="${map.business.status eq '5' }">
												<tr><th colspan="20">请假详情表</th></tr>
											</c:when>
											<c:otherwise>
												<tr><th colspan="20">请假申请表</th></tr>
											</c:otherwise>
										</c:choose>
									</thead>
									<tbody>
										<tr>
											<td style="width:15%;"><span>姓名</span></td>
											<td style="width:35%;"><input type="text" name="" id="userName" value="${map.business.applicant.name }" readonly></td>
											<td style="width:15%;"><span>单位</span></td>
											<td style="width:40%;line-height:inherit;text-align:left;">
												<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
													<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title}"/></select>
													<c:if test="${map.business.applicant.dept.name ne '总经理'}">
														<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${map.business.applicant.dept.name}" readonly>
													</c:if>
												</c:if>
												<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
													<input name="title" value="10" type="hidden">
													<custom:getDictKey type="流程所属公司" value="10"/>
													<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${map.business.applicant.dept.name }" readonly>
												</c:if>
											</td>
										</tr>
										<tr>
											<td><span>请假类别</span></td>
											<td><select  style="width: 100%" name="leaveType"><custom:dictSelect type="请假类型" selectedValue="${map.business.leaveType }"/></select></td>
											<td><span>申请时间</span></td>
											<td><input type="text" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime}" pattern="yyyy-MM-dd" />" readonly></td>
										</tr>
										<tr>
											<td><span>请假时间</span></td>
											<td colspan="20" style="padding-right:30px;">
												自
												<input id="startTime" name="startTime" size="18" class="starttime" style="width:26%;" value="<fmt:formatDate value="${map.business.startTime}" pattern="yyyy-MM-dd HH:mm" />" onchange="checkDate()" readonly>
												至
											    <input id="endTime" name="endTime" size="18" class="endtime" style="width:26%;" value="<fmt:formatDate value="${map.business.endTime}" pattern="yyyy-MM-dd HH:mm" />" onchange="checkDate()" readonly>
											           共
											    <input id="days" name="days" value="${map.business.days }" style="width:3em;" readonly="readonly">
											    <label id="label_days">天</label>
											    <input id="hours" name="hours" value="<fmt:formatNumber value='${map.business.hours }' pattern='#.#' />" style="width:3em;" readonly="readonly">
											    <label id="label_hours">小时</label>
											</td>
										</tr>
										<tr>
											<td><span>请假事由</span></td>
											<td colspan="20"><textarea name="reason" rows="7" cols="70" placeholder="请假事由">${map.business.reason }</textarea></td>
										</tr>
										<tr>
											<td><span>附件</span></td>
												<td  colspan="2" style="border-right-style:hidden;">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly></a>
												<td>
												<input type="file" id="file" name="file" style="display:none;">
												<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
												</td>
											</td> 
										</tr>
									</tbody>
								</c:when>
								
								
								<c:otherwise>
									<thead>
									<c:choose>
										<c:when test="${map.business.status eq '5' }">
											<tr><th colspan="20">请假详情表</th></tr>
										</c:when>
										<c:otherwise>
											<tr><th colspan="20">请假申请表</th></tr>
										</c:otherwise>
									</c:choose>
									</thead>
									<tbody>
										<tr>
											<td style="width:15%;"><span>姓名</span></td>
											<td style="width:35%;"><input type="text" value="${map.business.applicant.name }" readonly></td>
											<td style="width:15%;"><span>单位</span></td>
											<td style="width:40%;line-height:inherit;text-align:left;">
												<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
												<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
												<c:if test="${map.business.applicant.dept.name ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${map.business.applicant.dept.name}" readonly>
												</c:if>
												</c:if>
												<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
													<input name="title" value="10" type="hidden">
													<custom:getDictKey type="流程所属公司" value="10"/>
													<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${map.business.applicant.dept.name}" readonly>
												</c:if>
											</td>
										</tr>
										<tr>
											<td><span>请假类别</span></td>
											<td><input type="text" value="<custom:getDictKey type="请假类型" value="${map.business.leaveType }"/>" readonly></td>
											<td><span>申请时间</span></td>
											<td><input type="text" value="<fmt:formatDate value="${map.business.applyTime}" pattern="yyyy-MM-dd" />" readonly></td>
										</tr>
										<tr>
											<td><span>请假时间</span></td>
											<td colspan="20" style="padding-right:30px;">
												自
												<input type="text" size="18" style="width:26%; text-align:center;" value="<fmt:formatDate value="${map.business.startTime}" pattern="yyyy-MM-dd HH:mm" />" readonly>
												至
											    <input type="text" size="18" style="width:26%; text-align:center;" value="<fmt:formatDate value="${map.business.endTime}" pattern="yyyy-MM-dd HH:mm" />" readonly>
											           共
											    <input id="days" type="text" value="${map.business.days }" style="width:3em; text-align:center;" readonly>
											    <label id="label_days">天</label>
											    <input id="hours" type="text" value="<fmt:formatNumber value='${map.business.hours }' pattern='#.#' />" style="width:3em; text-align:center;" readonly>
											    <label id="label_hours">小时</label>
											</td>
										</tr>
										<tr>
											<td><span>请假事由</span></td>
											<td colspan="20"><textarea rows="7" cols="70" placeholder="请假事由" readonly>${map.business.reason }</textarea></td>
										</tr>
										<tr>
											<td><span>附件</span></td>
											<td colspan="20">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'><input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly></a>
											</td>
										</tr>
									</tbody>
								</c:otherwise>
							</c:choose>
							<tfoot>
								<c:if test="${(map.isHandler and map.task.name ne '提交申请' and map.task.name ne '销假') }">
									<tr>
										<td colspan="34">
											<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
										</td>
									</tr>
								</c:if>
							</tfoot>
						</table>
						<div style="width: 90%; text-align: center;margin:auto;margin-top:5px;">
							<c:if test="${map.business.userId eq sessionScope.user.id and (map.business.status ne 10 
								and map.business.status ne 0 and map.business.status ne 5 and map.business.status ne 1
								and map.business.status ne 7 and map.business.status ne 8 and map.business.status ne 9
								)}">
								<button id="recallBtn" type="button" class="btn btn-warning" onclick="approve('撤销申请')">撤回申请</button>
							</c:if>
							<c:forEach items="${sessionScope.user.positionList }" var="position">
								<c:if test="${position.name eq '人事经理' }">
									<c:if test="${map.business.status eq 10  and map.task.name eq 'HR'}">
										<button id="recallBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">确认撤销</button>
									</c:if>
								</c:if>
							</c:forEach>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '部门经理' }">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${(map.isHandler and map.task.name ne '提交申请' and map.task.name ne '销假' and sessionScope.user.id ne '225' and map.business.status ne 10) }">
								<!-- 当前登录人是管理者  -->
								<c:if test="${map.isHandler and map.business.userId ne sessionScope.user.id and map.business.userId ne'19' or sessionScope.user.id eq '19' or sessionScope.user.id eq '6' or sessionScope.user.id eq '2' or sessionScope.user.id eq '3' or sessionScope.user.id eq '27'
								or sessionScope.user.id eq '28' or sessionScope.user.id eq '30' or sessionScope.user.id eq '463' or sessionScope.user.id eq '484' or sessionScope.user.id eq '129'}">
									<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
									<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
								</c:if>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' and map.business.status ne 10}">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.task.name eq '销假' and map.isHandler }">
								<button type="button" class="btn btn-primary" onclick="approve('销假')">销假</button>
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
		</div>
	</section>
</div>

<!-- 流程图模态框（Modal） -->
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

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/leave/js/process.js"></script>
<script type="text/javascript">
var variables = ${map.jsonMap.variables};

var canEdit = false;
<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
	canEdit = true;
</c:if>
</script>
</body>
</html>