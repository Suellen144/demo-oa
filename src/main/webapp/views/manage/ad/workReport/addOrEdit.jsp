<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
table {
	border: 1px solid #fefefe;
}
th {
	background-color: #ebebeb;
	border: 1px solid #ccc !important;
}
table tr>td {
	border: 1px solid #ccc !important;
}
td>input {
	width: 100%;
	border: none;
	outline: medium;
}

textarea{
	height:20px;
}

</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">工作汇报</li>
			<li class="active">
				<c:if test="${not empty workReport.id }">编辑</c:if>
				<c:if test="${empty workReport.id }">新增</c:if>
			</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">工作汇报</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace">
						<input type="hidden" id="id" name="id" value="${workReport.id }">
					
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">工作汇报</label>
							<div class="col-md-4">
								<c:if test="${not empty workReport.id }">
									<c:set var="currMonth" value="${workReport.month }"></c:set>
								</c:if>
								<c:if test="${empty workReport.id }">
									<c:set var="currMonth" value="${currDate.month+1 }"></c:set>
								</c:if>
								<select id="month" name="month" class="form-control col-md-6" style="width: 20%;">
									<c:forEach begin="1" end="12" var="month">
										<option value="${month }" <c:if test="${month eq currMonth }">selected</c:if> >${month }</option>
									</c:forEach>
								</select>
								<label for="" class="control-label" style="float:left;margin:0px 10px;">月份，第</label>
							    <select id="number" name="number" class="form-control col-md-6" style="width: 18%;">
									<c:forEach begin="1" end="5" var="number">
										<option value="${number }" <c:if test="${number eq workReport.number }">selected</c:if> >${number }</option>
									</c:forEach>
								</select>
								<label for="" class="control-label" style="float:left;margin:0px 10px;">周工作汇报</label>
						    </div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">工作总结</label>
							<button type="button" class="btn btn-primary" style="margin:0px 15px;" onclick="addRow()">新增</button>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label"></label>
							<div class="col-md-9">
								<table class="table table-bordered">
									<thead>
										<tr>
						                  <th style="width:13%;">日期</th>
						                  <th style="width:20%">项目</th>
						                  <th style="width:7%;">工时</th>
						                  <th style="width:40%;">工作内容</th>
						                  <th style="width:14%;">更新时间</th>
						                  <th>操作</th>
						                </tr>									
									</thead>
					            	<tbody>
					            		<c:if test="${not empty workReport.id }">
					            			<c:forEach items="${workReport.workReportAttachList }" var="workReportAttach">
												<tr name="node">
													<input type="hidden" id="userId" name="userId" value="${workReport.userId }">
													<input type="hidden" name="workReportAttachId" value="${workReportAttach.id }">
													<input type="hidden" name="isUpdate" value="">
								                  	<td><input name="workDate" id="workDate1" class="workDate" value="<fmt:formatDate value="${workReportAttach.workDate }" pattern="yyyy-MM-dd" />" readonly></td>
								                  	<td onclick="openDialog(this)">
								                  		<input name="projectName" value="${workReportAttach.project.name }" readonly>
								                  		<input type="hidden" name="projectId" value="${workReportAttach.project.id }">
								                  	</td>
								                  	<td><input name="workTime" value="${workReportAttach.workTime }" onclick="this.select();"></td>
								                  	<td style = "height:auto;"><textarea id="description" name="description" class="input_textarea" style="width:100%;border:none; resize:none; overflow-x: visible;overflow-y: visible;outline:transparent;">${workReportAttach.description }</textarea></td>
								                  	<td style="background-color:#f7f7f7;"><input value="<fmt:formatDate value="${workReportAttach.updateDate }" pattern="yyyy-MM-dd HH:mm" />" style="background-color:#f7f7f7;" readonly></td>
								                	<td><a style="cursor:pointer;" onclick="delRow(this)">删除</a></td>
								                </tr>
					            			</c:forEach>
										</c:if>
										<c:if test="${empty workReport.id }">
											<tr name="node">
												<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
												<input type="hidden" name="workReportAttachId">
												<input type="hidden" name="isUpdate" value="">
							                  	<td><input name="workDate" id="workDate1" class="workDate" value="<fmt:formatDate value="${currDate }" pattern="yyyy-MM-dd" />" readonly></td>
							                  	<td onclick="openDialog(this)">
							                  		<input name="projectName" readonly>
							                  		<input type="hidden" name="projectId">
							                  	</td>
							                  	<td><input name="workTime" value="7.5" onclick="this.select();"></td>
							                 	<td style = "height:auto;"><textarea id="description" class="input_textarea" name="description"  style="width:100%; resize:none;height:20px;border:none;overflow: visible;outline:transparent;">${workReportAttach.description }</textarea></td> 
							                  	<td style="background-color:#f7f7f7;"><input value="" style="background-color:#f7f7f7;" readonly></td>
							                	<td><a style="cursor:pointer;" onclick="delRow(this)">删除</a></td>
							                </tr>
										</c:if>
					                </tbody>
				                </table>
			                </div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">周计划</label>
							<div class="col-md-9">
								<textarea id="weekPlan" name="weekPlan" rows="10" cols="100">${workReport.weekPlan }</textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">月总结</label>
							<div class="col-md-9">
								<textarea id="monthSummary" name="monthSummary" rows="7" cols="100" >${workReport.monthSummary }</textarea>
				            </div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">月计划</label>
							<div class="col-md-9">
								<textarea id="monthPlan" name="monthPlan" rows="7" cols="100" >${workReport.monthPlan }</textarea>
				            </div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="button" onclick="save()" class="btn btn-primary">提交</button>
								<!-- <button type="button" onclick="window.location.reload(true);return false;" class="btn btn-default">重置</button> -->
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="projectDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor/ckeditor.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/workReport/js/addOrEdit.js"></script>
</body>
</html>