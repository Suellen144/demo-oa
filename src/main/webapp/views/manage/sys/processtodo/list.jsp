<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>

<style>
td,th{ border:1px solid #ddd; line-height:1.5em; text-align:center; }

.tab_table input { border:none; outline:none; }

.tab_table2 td { border:none; }
.tab_table2 .border_top { border-top: 1px solid #ddd; }
.tab_table2 .border_left { border-left: 1px solid #ddd; }
</style>
</head>
<body>
<header>
 	<ol class="breadcrumb">
       <li class="active">主页</li>
       <li class="active">设置流程待办</li>
    </ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
   <li class="active"><a href="#leave" data-toggle="tab">请假流程</a></li>
   <li><a href="#travel" data-toggle="tab">出差流程</a></li>
   <li><a href="#travelReimburse" data-toggle="tab">差旅报销流程</a></li>
   <li><a href="#reimburse" data-toggle="tab">通用报销流程</a></li>
</ul>
<div id="myTabContent" class="tab-content">
	<div class="tab-pane fade in active" id="leave">
	
		<section class="content rlspace">
			<div class="row" style="background-color:#fff;">
				<div class="col-xs-12">
					<img alt="请假流程图" src="<%=base%>/static/images/leave.png">
					<div class="box box-primary">
						<div class="box-body">
							<table class="tab_table" style="width:50%;">
								<thead>
									<tr>
										<th style="width:40%;">流程所属公司</th>
										<th colspan="2">
											<table class="tab_table2" style="width:100%;">
												<tbody>
													<tr><td colspan="2">流程环节</td></tr>
													<tr><td style="width:50%" class="border_top">HR</td><td class="border_top border_left">总经理</td></tr>
												</tbody>
											</table>
										</th>
									</tr>
								</thead>
								<tbody class="tab_tbody">
									<c:forEach items="${companyList }" var="company">
										<tr>
											<td style="width:40%;" name="firstTd" process="leave" companyId="${company.id }">${company.name }</td>
											<td style="width:30%;" onclick="openDialog(this)" node="hr" nodeId="" handlerId=""></td>
											<td style="width:30%;" onclick="openDialog(this)" node="ceo" nodeId="" handlerId=""></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div style="width:50%; text-align:center;">
								<button class="btn btn-primary" style="margin:6px 0px;" onclick="save('leave')">保存</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		
   	</div>
   	<div class="tab-pane fade" id="travel">
   	
   		<section class="content rlspace">
			<div class="row" style="background-color:#fff;">
				<div class="col-xs-12">
					<img alt="请假流程图" src="<%=base%>/static/images/travel.png">
					<div class="box box-primary">
						<div class="box-body">
							<table class="tab_table" style="width:30%;">
								<thead>
									<tr>
										<th style="width:50%;">流程所属公司</th>
										<th colspan="2">
											<table class="tab_table2" style="width:100%;">
												<tbody>
													<tr><td colspan="2">流程环节</td></tr>
													<tr><td style="width:50%" class="border_top">总经理</td></tr>
												</tbody>
											</table>
										</th>
									</tr>
								</thead>
								<tbody class="tab_tbody">
									<c:forEach items="${companyList }" var="company">
										<tr>
											<td style="width:50%;" name="firstTd" process="travel" companyId="${company.id }">${company.name }</td>
											<td style="width:50%;" onclick="openDialog(this)" node="ceo" nodeId="" handlerId=""></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div style="width:30%; text-align:center;">
								<button class="btn btn-primary" style="margin:6px 0px;" onclick="save('travel')">保存</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		
   	</div>
   	<div class="tab-pane fade" id="travelReimburse">
   	
   		<section class="content rlspace">
			<div class="row" style="background-color:#fff;">
				<div class="col-xs-12">
					<img alt="请假流程图" src="<%=base%>/static/images/reimburse.png">
					<div class="box box-primary">
						<div class="box-body">
							<table class="tab_table" style="width:70%;">
								<thead>
									<tr>
										<th style="width:28%;">流程所属公司</th>
										<th colspan="4">
											<table class="tab_table2" style="width:100%;">
												<tbody>
													<tr><td colspan="4">流程环节</td></tr>
													<tr>
														<td style="width:25%" class="border_top border_left">经办</td>
														<td style="width:25%" class="border_top border_left">复核</td>
														<td style="width:25%" class="border_top border_left">总经理</td>
														<td style="width:25%" class="border_top border_left">出纳</td>
													</tr>
												</tbody>
											</table>
										</th>
									</tr>
								</thead>
								<tbody class="tab_tbody">
									<c:forEach items="${companyList }" var="company">
										<tr>
											<td style="width:28%;" name="firstTd" process="travelReimburse" companyId="${company.id }">${company.name }</td>
											<td style="width:18%;" onclick="openDialog(this)" node="handler" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="checker" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="ceo" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="teller" nodeId="" handlerId=""></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div style="width:70%; text-align:center;">
								<button class="btn btn-primary" style="margin:6px 0px;" onclick="save('travelReimburse')">保存</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		
   	</div>
   	<div class="tab-pane fade" id="reimburse">
   	
   		<section class="content rlspace">
			<div class="row" style="background-color:#fff;">
				<div class="col-xs-12">
					<img alt="请假流程图" src="<%=base%>/static/images/reimburse.png">
					<div class="box box-primary">
						<div class="box-body">
							<table class="tab_table" style="width:70%;">
								<thead>
									<tr>
										<th style="width:28%;">流程所属公司</th>
										<th colspan="4">
											<table class="tab_table2" style="width:100%;">
												<tbody>
													<tr><td colspan="4">流程环节</td></tr>
													<tr>
														<td style="width:25%" class="border_top border_left">经办</td>
														<td style="width:25%" class="border_top border_left">复核</td>
														<td style="width:25%" class="border_top border_left">总经理</td>
														<td style="width:25%" class="border_top border_left">出纳</td>
													</tr>
												</tbody>
											</table>
										</th>
									</tr>
								</thead>
								<tbody class="tab_tbody">
									<c:forEach items="${companyList }" var="company">
										<tr>
											<td style="width:28%;" name="firstTd" process="reimburse" companyId="${company.id }">${company.name }</td>
											<td style="width:18%;" onclick="openDialog(this)" node="handler" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="checker" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="ceo" nodeId="" handlerId=""></td>
											<td style="width:18%;" onclick="openDialog(this)" node="teller" nodeId="" handlerId=""></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div style="width:70%; text-align:center;">
								<button class="btn btn-primary" style="margin:6px 0px;" onclick="save('reimburse')">保存</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		
   	</div>
</div>

<div id="userDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/processtodo/js/list.js"></script>
</body>
</html>