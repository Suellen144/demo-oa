<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
<style>
#table1 {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}
#table1 td:not(.select2) {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	text-align:center;
	border: none;
	outline: medium;
}

#table1 thead th {
	border: none;
}

#table1 th {
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

.td_weight {
	font-weight: bold;
}

</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">档案管理</li>
			<li class="active">新增历史部门</li>
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
						<table id="table1" style="width: 98%">
							<input type="hidden" id="userId" name="userId" value = "${userId}"> 
							<thead>
								<tr><th colspan="20">${user.name}薪酬表 </th></tr>
							</thead>
							<tbody>
								<tr>
									<td class="td_weight" style="width:9%;"><span>开始日期</span></td>
									<td class="td_weight" style="width:9%;"><span>结束日期</span></td>
									<td class="td_weight" style="width:8%;"><span>薪水</span></td>
									<td class="td_weight" style="width:18%;"><span>备注</span></td>
									<td class="td_weight" style="width:6%;"><span>操作</span></td>
								</tr>
								<c:if test="${isEdit eq true }">
									<c:forEach items="${salaryHistories}" var="salaryHistorie">
										<tr name="node">
											<input type="hidden" id="id" name="id" value = "${salaryHistorie.id}"> 
											<td style="width:9%;"><input type="text" name="startTime"  class="date" value='<fmt:formatDate value="${salaryHistorie.startTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
											<td style="width:9%;"><input type="text" name="endTime"  class="date" value='<fmt:formatDate value="${salaryHistorie.endTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
											<td style="width:8%;">
												<input  name="salaryBack"  type="hidden" value="${salaryHistorie.salary}" >
												<input id="salary"  name="salary"  type="text" value="${salaryHistorie.salary}" style="border:0px;width:100%;height:100%;padding:12px;" >
											</td>
											<td style="width:18%;"><textarea name="remark" id="remark" value="">${salaryHistorie.remark }</textarea></td>
											<td style="width:6%;">
												<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> 
												<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${isEdit eq false }">
									<tr name="node">
										<input type="hidden" id="id" name="id" value = ""> 
										<td style="width:9%;"><input type="text" name="startTime"  class="date" value='<fmt:formatDate value="${deptHistorie.startTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
										<td style="width:9%;"><input type="text" name="endTime"  class="date" value='<fmt:formatDate value="${deptHistorie.endTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
										<td style="width:8%;">
											<input  name="salaryBack"  type="hidden" >
											<input id="salary" name="salary"  type="salary" value="" style="border:0px;width: 100%;height: 100%;padding: 12px" >
										</td>
										<td style="width:18%;"><textarea name="remark" id="remark" ></textarea></td>
										<td style="width:6%;">
											<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> 
											<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
										</td>
									</tr>
								</c:if>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="34" style="text-align:center;border:none;" >
										<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
										<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
									</td>
								</tr>
							</tfoot>
						</table>
					</form>
				</div>
			</div>
		</div>
	</section>
<div id="deptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script>
var hasDecryptPermission = false;
<shiro:hasPermission name="fin:travelreimburse:decrypt">
	hasDecryptPermission = true;
</shiro:hasPermission>
</script>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/salaryManage/js/addOrEditSalaryHistory.js"></script>
</body>
</html>