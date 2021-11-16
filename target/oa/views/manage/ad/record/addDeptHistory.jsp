<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
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
								<tr><th colspan="20">员工部门历史表</th></tr>
							</thead>
							<tbody style="font-size: 14px;">
								<tr>
									<td class="td_weight" style="width:10%;"><span>任命时间</span></td>
									<td class="td_weight" style="width:10%;"><span>撤销时间</span></td>
									<td class="td_weight" style="width:40%;"><span>部门</span></td>
									<td class="td_weight" style="width:30%;"><span>备注</span></td>
									<td class="td_weight" style="width:10%;"><span>操作</span></td>
								</tr>
								<c:if test="${isEdit eq true }">
									<c:forEach items="${deptHistories}" var="deptHistorie">
										<tr name="node">
											<input type="hidden"  name="id" value = "${deptHistorie.id}"> 
											<td style="width:9%;"><input type="text" name="startTime"  class="date" value='<fmt:formatDate value="${deptHistorie.startTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
											<td style="width:9%;"><input type="text" name="endTime"  class="date" value='<fmt:formatDate value="${deptHistorie.endTime }" pattern="yyyy-MM-dd"/>' readonly style="width: 100%;height: 100%;padding: 12px"></td>
											<td style="width:8%;">
												<input id="dept"  name="dept" onclick="openDept(this)"  type="text" value="${deptHistorie.dept}"  style="width: 100%;height: 100%;padding: 12px" readonly>
												<div id="deptContent" class="deptContent">
													<ul id="deptTree" class="ztree" style="margin-top:0; width:auto;"></ul>
												</div>
											</td>
											<td style="width:18%;"><textarea name="remark" id="remark" value="">${deptHistorie.remark }</textarea></td>
											<td style="width:6%;">
												<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> 
												<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${isEdit eq false }">
									<tr name="node">
										<input type="hidden" name="id" value = ""> 
										<td style="width:9%;"><input type="text" name="startTime" class="date" value="" readonly style="width: 100%;height: 100%;padding: 12px"></td>
										<td style="width:9%;"><input type="text" name="endTime"  class="date" value='' readonly style="width: 100%;height: 100%;padding: 12px"></td>
										<td style="width:8%;">
											<input id="dept" onclick="openDept(this)" name="dept"  type="text" value="" style="width: 100%;height: 100%;padding: 12px" readonly>
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
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/record/js/addDeptHistory.js"></script>
</body>
</html>