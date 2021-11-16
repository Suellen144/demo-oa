<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
</head>
<style>
table {
	border: 1px solid #fefefe;
	text-align: center;
}

textarea {
	resize: none;
	border: none;
	outline: medium;
	width:100%;
}

#table td input[type="barginCode"],input[name="barginName"],input[name="barginUserName"]{
	text-align:center;
}

.input {
	width: 100%;
	height: 100%;
	border: none;
	text-align: center;
	outline: medium;
	resize:none;
	overflow-x: visible;
	overflow-y: visible;
	outline:transparent;
}
th {
	background-color: #ebebeb;
	border: 1px solid #ccc !important;
	text-align: center;
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

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align: justify;
}

/* IE10以上生效 */
select::-ms-expand {
	display: none;
	text-align: justify;
}
.blackColor{
	color: #000000;

}

</style>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">项目管理</li>
			<li class="active">
				<c:if test="${not empty project.id }">编辑</c:if>
				<c:if test="${empty project.id }">新增</c:if>
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
						<h3 class="box-title" style="color: #367fa9;font-weight: bold;">项目详情</h3>
					</div>
					<!-- /.box-header -->

					<form id="form1" class="form-horizontal tbspace">
						<input type="hidden" id="id" name="id" value="${project.id}">
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">项目名称</label>
							<div class="col-sm-8">
								<input class="form-control" id="name" name="name" placeholder="项目名称" value="${project.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">项目类型</label>
							<div class="col-sm-8">
								<select id="type" name="type" class="form-control" ><custom:dictSelect type="项目类型" selectedValue="${project.type}"/></select>
							</div>
						</div>
						<div class="form-group">
							<label for="location" class="col-sm-1 control-label">项目所在地</label>
							<div class="col-sm-8">
								<input type="hidden" id="location_rep" value="${project.location}">
								<select class="form-control" id="location" name="location">
									<option value="0">公司</option>
									<option value="1">其他</option>
								</select>
							</div>
						</div>
						<div class="form-group">
						<label for="describe" class="col-sm-1 control-label">项目描述</label>
						<div class="col-sm-8">
							<textarea class="form-control" id="describe" name="describe" placeholder="项目描述" value="">${project.describe}</textarea>
						</div>
						</div>
						<div class="form-group has-feedback">
							<label for="deptName" class="col-sm-1 control-label">所属机构</label>
							<div class="col-sm-8">
								<c:set var="deptName" value=""></c:set>
								<c:forEach items="${project.deptList }" var="dept" varStatus="status">
									<c:if test="${status.first }">
										<c:set var="deptName" value="${dept.name }"></c:set>
									</c:if>
									<c:if test="${not status.first }">
										<c:set var="deptName" value="${deptName },${dept.name }"></c:set>
									</c:if>
								</c:forEach>

								<input type="hidden" name="deptIds" id="deptIds" value="${project.deptIds }">

								<div class="input-group">
				                    <input type="text" id="deptName" value="${deptName}" class="form-control"  onclick="openDept()" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                    <span class="input-group-addon" onclick="removeDept()" style="color: #367fa9"><i class="fa fa-remove"></i></span>
				                </div>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">负责人</label>
							<div class="col-sm-8">
								<input type="hidden" name="userId" id="userId" value="${project.userId}">

								<div class="input-group">
				                    <input type="text" id="userName" value="${project.principal.name}" class="form-control"  onclick="openDialog('1',this)" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                    <span class="input-group-addon" onclick="removePrincipal()" style="color: #367fa9"><i class="fa fa-remove"></i></span>
				                </div>
							</div>

							<div class="form-group">

							</div>
						</div>
						<c:choose>
							<c:when test="${not empty  project.id  and  (not empty barginManages)}">
								<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">项目合同</label>
							<div class="col-sm-8">
								<table class="table table-bordered" style="text-align: center">
									<thead>
									  	<tr>
											<th>合同编号</th>
											<th>合同名称</th>
											<th>合同类型</th>
											<th>负责人</th>
											<th>合同总金额</th>
											<th>已收金额</th>
											<th>已付金额</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${barginManages}" var="barginManage" varStatus="varStatus">
											<tr name="node" onclick="gotoSee(${barginManage.processInstanceId})">
												<input type="hidden" name="processId"  value="${barginManage.processInstanceId}">
											<td style="height:100%;"><input type="text" name="barginCode" id="barginCode" class="input" value="${barginManage.barginCode}" readonly></td>

											<td style="height:100%;"><input type="text" name="barginName" id="barginName" class="input" value="${barginManage.barginName}" readonly></td>

											<td style="height:100%;">
												<input type="text" name="barginType" id="barginType" class="input" value="<custom:getDictKey type="合同类型" value="${barginManage.barginType}"/>" readonly>
											</td>

											<td style="height:100%;"><input type="text" name="barginName" id="barginName" class="input" value="${barginManage.sysUser.name}" readonly></td>

											<td style="height:100%;"><input type="text" name="totalMoney" id="totalMoney" value="<fmt:formatNumber value='${barginManage.totalMoney}' pattern='0.00' />" class="input"  readonly></td>
											<td style="height:100%;"><input type="text" name="receivedMoney" id="receivedMoney" value="<fmt:formatNumber value='${barginManage.receivedMoney}' pattern='0.00' />" class="input"  readonly></td>
											<td style="height:100%;"><input type="text" name="payMoney" id="payMoney" value="<fmt:formatNumber value='${barginManage.payMoney}' pattern='0.00' />" class="input"  readonly></td>
										    </tr>
								    </c:forEach>
								</tbody>
								</table>
							</c:when>
						</c:choose>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10"  style="margin-left: 35%">
								<c:if test="${ project.status ne '-1'}">
									<button type="button" class="btn btn-primary" onclick="save()">提交</button>
								</c:if>
								<c:if test="${not empty  project.id and project.status eq '0'}">
									<button type="button" class="btn btn-primary" onclick="operation('1')">启动</button>
								</c:if>

								<c:if test="${not empty  project.id and project.status ne '-1'}">
									<button type="button" class="btn btn-danger dropdown-toggle" onclick="operation('-1')">注销</button>
								</c:if>

								<c:if test="${not empty  project.id and ((project.status  eq '1') or (empty project.status))}">
									<button type="button" class="btn btn-warning dropdown-toggle " onclick="operation('0')">关闭</button>
								</c:if>

								<%-- <c:if test="${not empty  project.id}">
									<button type="button" class="btn btn-primary" onclick="remove()">删除</button>
								</c:if> --%>

								<!-- <button type="button" class="btn btn-default" onclick="window.location.reload(true);return false;">重置</button> -->
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
						</div>
						</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="userDialog"></div>
<div id="barginUserName"></div>
<div id="deptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManage/js/addOrEdit.js"></script>
</body>
</html>