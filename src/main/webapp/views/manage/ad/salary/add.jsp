<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">绩效考核</li>
	</ol>
</header>

<style>
 table {
	table-collapse: collapse;
	border: none;
	margin: 0px 0px; 
	text-align: center;
	width: 100%;
	
}

#table thead th {
	border: none;
}

#table td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

 td {
	border: solid #999 1px;
	padding: 0px;
	font-size: 1em;
	text-align: center;
} 
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align: center;
	margin: 0px;
	line-height: 25px;
}
td input[type="radio"] {
	margin-left: 0.5em;
	vertical-align: middle;
}
td label {
	font-weight: normal;
}
td p {
	padding: 5px 1em;
	margin: 0px;
}
 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
} 

/* select{ */
/*   appearance:none; */
/*   -moz-appearance:none; */
/*   -webkit-appearance:none; */
/*   border: none; */
/* } */

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}

textarea{
	border-left:0px;
	border-top:0px;
	border-right:0px;
	border-bottom:1px;
}
#ul_user li {
	list-style-type: none;
}
#ul_user li:hover {
	cursor: pointer;
	font-weight: bold;
	font-size: 1.2em;
}

.connectedSortable {
	padding-right: 0px;
}
</style>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
			<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
				<div class="box box-primary box-solid">
					<div class="box-body">
						<form id="form1">
							<div>在职状态：<select id="workingStateselectVal" name="workingStateselectVal" onchange="selectWorkingState(this)"></select></div>
							<input type="text" name="tittle" value="" placeholder="请输入计划标题" style="width:100%;height:100%;font-weight：bolder;font-size:24px;border:none;text-align:center;">
							<table>
								<thead>
									<tr style="background-color:#d2d6de;height:35px;">
										<td class="td_weight"><span>序号</span></td>
										<td class="td_weight"><span>部门</span></td>
										<td class="td_weight"><span>姓名</span></td>
										<td class="td_weight"><span>职位</span></td>
										<td class="td_weight"><span>入职时间</span></td>
										<td class="td_weight"><span>现行月薪</span></td>
										<td class="td_weight"><span>考核分</span></td>
										<td class="td_weight"><span>上期调薪</span></td>
										<td class="td_weight"><span>上期调薪比例(%)</span></td>
										<td class="td_weight"><span>个人期望(%)</span></td>
										<td class="td_weight"><span>部门建议(%)</span></td>
										<td class="td_weight"><span>核准调幅(%)</span></td>
										<td class="td_weight"><span>计划月薪</span></td>
										<td class="td_weight"><span>备注</span></td>
									</tr>
									</thead>
									<tbody id="tbodyInfo">
<%-- 										<c:forEach items="${salaryList}" var="salary"> --%>
<!-- 										<tr name = "node"> -->
<!-- 										<td style="width:3%;"><input  type="text" name = number value = "" readonly></td> -->
<%-- 										<td style="width:7%;"><input  type="text" value = "${salary.record.dept}" readonly></td> --%>
<%-- 										<input name="AttachuserId"  type="hidden" value = "${salary.record.userId}" readonly> --%>
<%-- 										<td style="width:7%;"><input  type="text" value = "${salary.record.name}" readonly></td> --%>
<%-- 										<td style="width:7%;"><input  type="text" value = "${salary.record.position}" readonly></td> --%>
<%-- 										<td style="width:7%;"><input  type="text" value="<fmt:formatDate value="${salary.record.entryTime}" pattern="yyyy-MM-dd" />" readonly></td> --%>
<%-- 										<td style="width:7%;"><input  type="text" name="salary" value = "${salary.salary.salary}" readonly></td> --%>
<%-- 										<td style="width:7%;"><input  name="score" type="text"  value="<fmt:formatNumber value='${salary.record.score}' pattern='#.#' />" readonly></td> --%>
<!-- 										<td style="width:7%;"><input type="text" name="lastdate"	value="" readonly></td> -->
<!-- 										<td style="width:6%;"><input type="text" name="lastproportion"	value="" readonly></td> -->
<%-- 										<td style="width:7%;"><input  name="personAmplitude" readonly  type="text" value = "${salary.personAmplitude}"></td> --%>
<%-- 										<td style="width:7%;"><input  name="manageAmplitude"  readonly type="text" value = "${salary.manageAmplitude}"></td> --%>
<%-- 										<td style="width:7%;"><input  name="finallyAmplitude"  type="text" onkeyup="countmoney()" value = "${salary.finallyAmplitude}"></td> --%>
<%-- 										<td style="width:7%;"><input  name="finallySalary"  type="text" value = "${salary.finallySalary}"></td> --%>
<%-- 										<td style="width:7%;"><input  name="remark"  type="text" value = "${salary.remark}"></td> --%>
<!--  										</tr> -->
<%-- 										</c:forEach> --%>
								</tbody>
							</table>
								<div style="width:100%; text-align:center;margin-top:5px;">
									<button id="save_btn" type="button" class="btn btn-primary" onclick="save()" >提交</button>
									<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
								</div>
						</form>
					</div>
				</div>
			</section>
	</section>
</div>
<script type="text/javascript">
	var base = "<%=base%>";
	var hasDecryptPermission = false;
	<shiro:hasPermission name="fin:travelreimburse:decrypt">
		hasDecryptPermission = true;
	</shiro:hasPermission>
</script>
<%@ include file="../../common/footer.jsp"%>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/salary/js/add.js"></script>
</body>
</html>