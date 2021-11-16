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

textarea{
	height:500px;
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
	padding: 5px 1em;
	margin: 0px;
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
			 <div style="text-align: left;margin-bottom:3px;margin-left:14px;">
						<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toShow()">历史考评</button></td>
			</div>
			<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
	   					<h3 class="box-title">绩效考核</h3>
			    	</div>
					<div class="box-body">
						<form id="form">
						
						 	<input type="hidden" id="id" name="id" value="${kpi.id}">
							<table>
								<thead>
									<tr><th colspan="10" style="text-align:center; border:none; font-size: 1.5em;">绩效考核表</th></tr>
								</thead>
								<tbody name="node">
									<tr>
										<td style="width:10%;">姓名</td>
										<input id="userId" name="userId"  type="hidden" value="${sessionScope.user.id }">
										<td style="width:10%;"><input id="name" name="name"  type="text" value="${sessionScope.user.name }" readonly></td>
										
										<td style="width:8%;">单位</td>
										<td style="width:44%;" colspan="3">
											  <input id="deptId" name="deptId" type="hidden" style="padding:0px;text-align:left;" value="${sessionScope.user.dept.id }">
											 <c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											 <input id="dept" name="dept" type="text" style="padding:0px;text-align:left;" value="睿哲科技股份有限公司${sessionScope.user.dept.name }" readonly>
											 </c:if>
											 <c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											  <input id="dept" name="dept" type="text" style="padding:0px;text-align:left;" value="沈阳睿哲科技股份有限公司${sessionScope.user.dept.name }" readonly>
											 </c:if>
										</td>
										</tr>		
							
									<tr>

											<td style="width:11%;">考核月份</td>
											<td colspan="1"><input type="text"  id="date"  value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM" />"  size="18" readonly></td> 
									
											<td style="width:10%;">自评分</td>
											<td><input  type="text" id="userScore" name="userScore"  value="" placeholder="总分100" ></td>
									</tr>
									<tr>
									<td rowspan="2"><p>自我评价</p></td>
									</tr>
								
									<tr>
										<td colspan="10" style = "height:auto;">
											<div colspan="10">
												<textarea id="userEvaluation" name="userEvaluation" rows="14" cols="120" style="width:100%;height:100%;resize: none;text-align:left;outline:transparent;" ></textarea>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="1">公司评分</td>
										<td colspan="1"><input id="ceoScore" name="ceoScore" value="" type="text" readonly></td>
										<td colspan="1">奖惩</td>
										<td colspan="7"><input  type="text" id="ceoPraisedPunished" name="ceoPraisedPunished" value="" readonly ></td>	
									</tr>
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
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/kpi/js/add.js"></script> 
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>
</body>
</html>