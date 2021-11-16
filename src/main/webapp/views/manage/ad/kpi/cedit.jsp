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
	margin: 5px 20px; 
	text-align: center;
	width: 95%;
	
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
	padding: 0px 1em;
	text-align: center;
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
			<section class="col-md-10 connectedSortable ui-sortable">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
	   					<h3 class="box-title">绩效考核</h3>
			    	</div>
					<div class="box-body">
						<form id="form">
							
							<table>
								<thead>
									<tr><th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1.5em;">绩效考核表</th></tr>
								</thead>
								<tbody>
									<input type="hidden" id="id" name="id" value="${kpi.id}">
								 	<input type="hidden" id="userId" name="userId" value="${kpi.userId}"> 
								 	<input type="hidden" id="userName" name="userName" value="${user.name}"> <!-- kpi创造者的用户名 -->
								 	<input type="hidden" id="managerName" name="managerName" value="${manager.name}"> <!-- kpi创造者经理的用户名 -->
								 	<input type="hidden" id="ceoName" name="ceoName" value="${ceo.name}"> <!-- kpi创造者总经理的用户名 -->
								 	<input type="hidden" id="currName" name="currName" value="${sessionScope.user.name}"> <!-- 当前登录用户用户名 -->
								 	
								 	<input type="hidden" id="status" name="status" value="${kpi.status}">
								 	<input type="hidden" id="ue" name="ue" value="${kpi.userEvaluation}">
								 	<input type="hidden" id="isManager" name="isManager" value="${isManager}"> 
									
									<c:choose>
										<c:when test="${((sessionScope.user.name eq user.name) and (kpi.status eq 0)) ||
											((sessionScope.user.name eq manager.name) and (sessionScope.user.name eq user.name) and (kpi.status eq 1)) }">
											<tr>
												<td style="width:14%;"><p>姓名</p></td>
												<td style="width:10%;"><input id="name" name="name"  type="text" value="${kpi.name }" readonly></td>
												<td style="width:8%;"><p>职位</p></td> 
												<td style="width:20%;"><input id="position" name="position"  type="text" value="${kpi.position}" readonly></td>
												
												<td style="width:12%;"><p>部门</p></td>
												<td style="width:36%;"  colspan="3">
													<div style="float: left;">
														<div style="float: left;font-size:15px;height:20px;">
															<select name="title"><custom:dictSelect type="流程所属公司" selectedValue="${kpi.title}"/></select>					
														</div>	
														<div style="float: left;width:80px;font-size:15px;height:20px;">
															<input id="dept" name="dept" type="text" value="${kpi.dept}" style="padding:0px;text-align:left;" readonly>
														</div>	
														<div style="clear: both"></div>
													</div>		
												</td>
											</tr>		
											<tr>
												<td><p>状态</p></td>
												<td style="width:9%;">
												<input id="entryStatus" name="entryStatus" value="${kpi.entryStatus}" type="hidden" >
												<c:choose>
													<c:when test="${kpi.entryStatus eq 1}">
														<div>实习</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 2}">
														<div>试用</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 3}">
														<div>在职</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 4}">
														<div>离职</div>	
													</c:when>
													
												</c:choose>
												</td>
												
												<td style="width:12%;"><p>入职时间</p></td> 
												<td style="width:12%;"><input  type="text" id="entryDate" readonly name="entryDate" value="<fmt:formatDate value="${kpi.entryDate}" pattern="yyyy-MM-dd" />" ></td>			
	
												<td style="width:12%;"><p>考核年月</td>
												<td style="width:12%;"><input type="text" name="evaluationDate" id="evaluationDate"  value="${kpi.evaluationDate }"  size="18" readonly></td> 
										
												<td style="width:12%;"><p>自评分</p></td>
												<td><input  type="text" id="userScore" name="userScore" value="${kpi.userScore}" placeholder="0-100整数"></td>	
											</tr>
											<tr>
											<td rowspan="2"><p>自我评价</p></td>
											</tr>
				
											<tr>
												<td colspan="10">
													<div colspan="10">
														
														<textarea id="userEvaluation" name="userEvaluation"   rows="14" cols="120"  style="width:100%;height:100%;resize: none;text-align:left;">${kpi.userEvaluation}</textarea>
													</div>
												</td>
											</tr>
										
										</c:when>
										
										
										<c:otherwise>
										<tr>
												<td style="width:10%;"><p>姓名</p></td>
												<td style="width:10%;"><input id="name" name="name"  type="text" value="${kpi.name }" readonly></td>
												<td style="width:8%;"><p>职位</p></td> 
												<td colspan="2" style="width:20%;"><input id="position" name="position"  type="text" value="${kpi.position}" readonly></td>
												
												<td style="width:8%;"><p>部门</p></td>
												<td style="width:44%;"  colspan="2">
													<div style="float: left;">
														<div style="float: left;font-size:15px;height:20px;">
															<input id="title" name="title"  type="hidden" value="${kpi.title }">
															<custom:getDictKey type="流程所属公司" value="${kpi.title}"/>						
														</div>	
														<div style="float: left;width:80px;font-size:15px;height:20px;">
															<input id="dept" name="dept" type="text" value="${kpi.dept}" style="padding:0px;text-align:left;" readonly>
														</div>	
														<div style="clear: both"></div>
													</div>		
												</td>
											</tr>		
											<tr>
												<td><p>状态</p></td>
												<td style="width:9%;">
												<input id="entryStatus" name="entryStatus" value="${kpi.entryStatus}" type="hidden" >
												<c:choose>
													<c:when test="${kpi.entryStatus eq 1}">
														<div>实习</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 2}">
														<div>试用</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 3}">
														<div>在职</div>	
													</c:when>
													<c:when test="${kpi.entryStatus eq 4}">
														<div>离职</div>	
													</c:when>
													
												</c:choose>
												</td>
												
												<td style="width:12%;"><p>入职时间</p></td> 
												<td style="width:12%;"><input type="text" id="entryDate" readonly name="entryDate" value="<fmt:formatDate value="${kpi.entryDate}" pattern="yyyy-MM-dd" />" ></td>			
												<td style="width:12%;"><p>考核年月</td>
												<td style="width:12%;"><input type="text" name="evaluationDate" id="evaluationDate"  value="${kpi.evaluationDate }"  size="18" readonly></td> 				
												<td style="width:12%;"><p>自评分</p></td>
												<td><input  type="text" id="userScore" name="userScore" value="${kpi.userScore}" placeholder="0-100整数" readonly></td>	
											</tr>
											<tr>
											<td rowspan="2"><p>自我评价</p></td>
											</tr>
				
											<tr>
												<td colspan="10">
													<div colspan="10">
														
														<textarea id="userEvaluation" name="userEvaluation"   readonly rows="14" cols="120"  style="width:100%;height:100%;resize: none;text-align:left;">${kpi.userEvaluation}</textarea>
													</div>
												</td>
											</tr>
										
										</c:otherwise>
									</c:choose>
								

							
									<c:choose>
										<c:when test="${(sessionScope.user.name eq manager.name) and (kpi.status eq 1 or kpi.status eq 0)}">
											<tr id="manager_1">
												<td rowspan="2"><p>部门经理考评</p></td>
												<td><p>评分</p></td>
												<td><input id="managerScore" name="managerScore"  type="text" value="${kpi.managerScore}"></td>
												<td><p>奖惩</p></td>
												<td colspan="5"><input  type="text" id="managerPraisedPunished" name="managerPraisedPunished" value="${kpi.managerPraisedPunished}"></td>	
											</tr>

											<tr id="manager_2">
												<td colspan="10">
													<div colspan="10">
														
														<textarea id="managerEvaluation" name="managerEvaluation"  rows="14" cols="120" style="width:100%;height:100%;resize: none;text-align:left;">${kpi.managerEvaluation}</textarea>
													</div>
												</td>
											</tr>
										</c:when>
										
										<c:otherwise>
											<tr id="manager_1">
												<td rowspan="2"><p>部门经理考评</p></td>
												<td><p>评分</p></td>
												<td><input id="managerScore" name="managerScore"  type="text" value="${kpi.managerScore}" readonly></td>
												<td><p>奖惩</p></td>
												<td colspan="7"><input  type="text" id="managerPraisedPunished" name="managerPraisedPunished" value="${kpi.managerPraisedPunished}" readonly></td>	
											</tr>

											<tr id="manager_2">
												<td colspan="10">
													<div colspan="10">
													
														<textarea id="managerEvaluation" name="managerEvaluation"  readonly rows="14" cols="120" style="width:100%;height:100%;resize: none;text-align:left;" readonly>${kpi.managerEvaluation}</textarea>
													</div>
												</td>
											</tr>
										</c:otherwise>
									</c:choose>
								

									<c:choose>
										<c:when test="${sessionScope.user.name eq ceo.name}">
												<tr id="ceo_1">
													<td rowspan="2"><p>公司考评</p></td>
													<td><p>评分</p></td>
													<td><input id="ceoScore" name="ceoScore"  type="text" value="${kpi.ceoScore}" ></td>
													<td><p>奖惩</p></td>
													<td colspan="7"><input  type="text" id="ceoPraisedPunished" name="ceoPraisedPunished"  value="${kpi.ceoPraisedPunished}"  ></td>	
												</tr>

												<tr id="ceo_2">
													<td colspan="10">
														<div colspan="10">
															<textarea id="ceoEvaluation" name="ceoEvaluation"  rows="14" cols="120" style="width:100%;height:100%;resize: none;" >${kpi.ceoEvaluation}</textarea>
														</div>
													</td>
												</tr>
										</c:when>
										<c:otherwise>
											<tr id="ceo_1">
												<td rowspan="2"><p>公司考评</p></td>
												<td><p>评价</p></td>
												<td><input id="ceoScore" name="ceoScore"  type="text" value="${kpi.ceoScore}" readonly></td>
												<td><p>奖惩</p></td>
												<td colspan="7"><input  type="text" id="ceoPraisedPunished" name="ceoPraisedPunished"  value="${kpi.ceoPraisedPunished}" readonly ></td>	
											</tr>

											<tr id="ceo_2">
												<td colspan="10">
													<div colspan="10">
														<textarea id="ceoEvaluation" name="ceoEvaluation"  readonly rows="14" cols="120" style="width:100%;height:100%;resize: none;" >${kpi.ceoEvaluation}</textarea>
													</div>
												</td>
											</tr>
										</c:otherwise>
									</c:choose>	
								</tbody>
							</table>
							<div style="width:100%; text-align:center;">
								<button id="save_btn" type="button" class="btn btn-primary" onclick="save()" >保存</button>
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
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/kpi/js/cedit.js"></script>

</body>
</html>