<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>

#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
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
			<li class="active">假日管理</li>
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
						<table id="table1">
							<thead>
								<tr><th colspan="10">假日添加</th></tr>
							</thead>
							<tbody>
								<tr>
									<td class="td_weight" width= "10%"><span>假日名称</span></td>
									<td class="td_weight" width= "13%"><span>所属月份</span></td>
									<td class="td_weight" width= "13%"><span>开始时间</span></td>
									<td class="td_weight" width="13%"><span>结束时间</span></td>
									<td class="td_weight" width="13%"><span>法定</span></td>
									<td class="td_weight" width="10%"><span>法定天数</span></td>
									<td class="td_weight" width="13%"><span>假前调班</span></td>
									<td class="td_weight" width="13%"><span>假后调班</span></td>
								<!-- 	<td class="td_weight" swidth=5%><span>操作</span></td> -->
								</tr>
									<c:forEach begin="1" end="1" var="index">
									<tr name="node">
									<td colspan="1">
										<input type="hidden" name="id" value="${legalHoliday.id }">
									<input type="text" name="name" size="18" value="${legalHoliday.name }"></td>
									<td colspan="1"><input type="text" name="dateBelongs"  class="dateBelongs"  size="18" readonly value="${legalHoliday.dateBelongs}"></td>
									<td colspan="1"><input type="text" name="startDate" class="startDate" size="18" readonly value="<fmt:formatDate value="${legalHoliday.startDate}" pattern="yyyy-MM-dd" />"></td>
									<td colspan="1"><input type="text" name="endDate"  class="endDate"  size="18" readonly value="<fmt:formatDate value="${legalHoliday.endDate}" pattern="yyyy-MM-dd" />"></td>
									<td colspan="1"><input type="text" name="legal"  class="legal"  size="18" readonly value="<fmt:formatDate value="${legalHoliday.legal}" pattern="yyyy-MM-dd" />"></td>
									<td colspan="1"><input type="text" name="numberDays" class="input"  value = "${legalHoliday.numberDays }"></td>
									<td colspan="1"><input type="text" name="beforeLeave"  class="beforeLeave"  size="18" readonly value="<fmt:formatDate value="${legalHoliday.beforeLeave}" pattern="yyyy-MM-dd" />" ></td>
									<td colspan="1"><input type="text" name="afterLeave"  class="afterLeave" size="18" readonly value="<fmt:formatDate value="${legalHoliday.afterLeave}" pattern="yyyy-MM-dd" />"></td>
									<%-- <td colspan="2">
											<c:if test="${index eq 1 }">
												<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a></a>
											</c:if>
											<c:if test="${index lt 1 }">
												<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</c:if>
									</td> --%>
									</tr>
									</c:forEach>
							</tbody>
						</table>
						<div style="width:90%; text-align:center;margin:auto;margin-top:5px;">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
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
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/legalholiday/js/edit.js"></script>
</body>
</html>