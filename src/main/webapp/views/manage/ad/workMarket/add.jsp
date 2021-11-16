<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
table {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}

#table1 th {
	border: none;
}
td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
	height:100%;
}

input{
	text-align: center;
}
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
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
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">拜访工作登记表</li>
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
						<input type="hidden" name="id" value="" >
						<input type="hidden" name = "status" value="" id="status" readonly>
						<input type="hidden" name="userId" id="userId" value="${sessionScope.user.id }" >
						<table id="table1">
							<thead>
								<tr><th colspan="12">拜访工作登记表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="2" class="td_weight"><span>姓名</span></td>
									<td colspan="2"><input type="text" name="name"  id ="name" value="${sessionScope.user.name }"readonly></td>
									<td colspan="1" class="td_weight"><span>单位</span></td>
									<td colspan="3">
										<c:if test="${sessionScope.user.dept.name ne '总经理'}">
											<input type="text" name="deptName"  id ="deptName" style="font-size: 15px;" type="text"  value="广东睿哲科技股份有限公司${sessionScope.user.dept.name }" readonly>
										</c:if>
									<td colspan="2" class="td_weight"><span>申请时间</span></td>
									<td colspan="2"><input type="text" name="applyTime"  id ="applyTime" value="" readonly></td>
									
								</tr>
								<tr>
									<td class="td_weight" width= "9%"><span>日期</span></td>
									<td class="td_weight" width= "13%"><span>开始时间</span></td>
									<td class="td_weight" width="13%"><span>结束时间</span></td>
									<td class="td_weight" width="14%"><span>拜访单位</span></td>
									<td class="td_weight" width="8%"><span>客户姓名</span></td>
									<td class="td_weight" width="8%"><span>职务</span></td>
									<td class="td_weight" width="9%"><span>联系方式</span></td>
									<td class="td_weight" width="7%"><span>优先级</span></td>
									<td class="td_weight" width="7%"><span>负责人</span></td>
									<td class="td_weight" width="4%"><span>拜访内容</span></td>
									<td class="td_weight" width="4%"><span>备注</span></td>
									<td class="td_weight" width=9%><span>操作</span></td>
								</tr>
										<tr name="node">
											<td style="height:100%;"><input type="text" name="workDate" id="workDate" class="workDate" size="18" readonly></td>
											<td style="height:100%;"><input type="text" name="startTime" id="startTime" class="starttime" size="18" readonly></td>
											<td style="height:100%;"><input type="text" name="endTime" id="endTime" class="endtime"  size="18" readonly ></td>
											<td style="height:100%;"><input type="text" name="company" id="company" class="input" value = ""></td>
											<td style="height:100%;">
											<input type="text" name="clientName" id="clientName" class="input" value = "" ></td>
											
											<td style="height:100%;"><input type="text" name="clientPosition" id="clientPosition" class="input" value = ""></td>
											<td style="height:100%;"><input type="text" name="clientPhone" id="clientPhone" class="input" value = "" ></td>
											<td style="height:100%;">
												<select id="level" name="level" class="form-control"  class="input" style="height:100%;width:100%;text-align-last:center;border: 0px">
													<option></option>
													<custom:dictSelect type="拜访优先级"/>
												</select>
											</td>
											
											<td style="height:100%;" onclick="openDialog(this)" >
												<input type="hidden" name="responsibleUserId" id="responsibleUserId" class="input" value = "" >
												<input type="text" name="responsibleUserName" id="responsibleUserName" readonly class="input" value = "" >
												</td>
											
											<td style="height:100%;"><textarea  name="content" id="content" class="input" value = ""></textarea></td>
											<td style="height:100%;"><textarea type="text" name="remark" id="remark" class="input" value = "" ></textarea></td>
											
											
											<td style="height:100%;">
												<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right:6px"></a>			
												<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</td>
										</tr>
							</tbody>
						</table>
					<!-- 	<div style="width:90%; text-align:center;">
							<button type="button" class="btn btn-primary" onclick="save()" >提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div> -->
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<select id="addLevel" class="form-control" style="display: none;">
	<custom:dictSelect type="拜访优先级"/>
</select>
<div id="userDialog"></div>


<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/workMarket/js/add.js"></script>
<script type="text/javascript"src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
</body>
</html>