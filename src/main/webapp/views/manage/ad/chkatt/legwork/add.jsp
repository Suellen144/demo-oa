<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
table {
	table-collapse: collapse;
	border: none;
	margin: auto;
	width:90%;
}

#table1 th {
	border: none;
}
td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align:center;
}

td span {
	padding: 0px 6px;
	text-align: center;
}
th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	resize: none;
	border: none;
	outline: medium;
}

.td_right {
	text-align: right;
}
.td_weight {
	font-weight: bold;
}
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">外勤登记</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-15">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<input type="hidden" name="id" value="${legwork.id}" >
						<input type="hidden" name="userid" value="${sessionScope.user.id }" >
						<table id="table1">
							<thead>
								<tr><th colspan="10">外勤登记表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td class="td_weight"><span>姓名</span></td>
									<td colspan="1"><input type="text" name="applyPeople"  id ="applyPeople" value="${sessionScope.user.name }"readonly></td>
									<td class="td_weight"><span>单位</span></td>
									<td colspan="2">
									<c:if test="${sessionScope.user.dept.name ne '总经理'}">
									<input type="text" id = "dept" value="${sessionScope.user.dept.name }" readonly>
									</c:if>
									</td> 
									
									<!-- <td colspan ="1"><span>申请日期</span></td>
									<td colspan="1"><input type="text" id="applyTime" name="applyTime" readonly ></td> -->
									
								</tr>
								<tr>
									<td class="td_weight" width= "15%"><span>开始时间</span></td>
									<td class="td_weight" width="15%"><span>结束时间</span></td>
									<td class="td_weight" width="50%"><span>事由</span></td>
									<td class="td_weight" width="10%"><span>地点</span></td>
									<td class="td_weight" swidth=5%><span>操作</span></td>
								</tr>
									<c:forEach begin="1" end="1" var="index">
									<tr name="node">
									<td colspan="1"><input type="text" name="startTime" id="startTime"class="starttime" size="18" readonly></td>
									<td colspan="1"><input type="text" name="endTime" id="endTime" class="endtime"  size="18" readonly ></td>
									<td colspan="1"><input type="text" name="reason" class="input"  value = ""></td>
									<td colspan="1"><input type="text" name="place" class="input" value = "" ></td>
									<td colspan="2">
											<c:if test="${index eq 1 }">
												<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a></a>
											</c:if>
											<c:if test="${index lt 1 }">
												<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</c:if>
									</td>
									</tr>
									</c:forEach>
							</tbody>
						</table>
						<div style="width:90%; text-align:center;margin:auto;margin-top:5px;">
							<button type="button" class="btn btn-primary" onclick="save()" >提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="deptDialog"></div>


<%@ include file="../../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/legwork/js/add.js"></script>
</body>
</html>