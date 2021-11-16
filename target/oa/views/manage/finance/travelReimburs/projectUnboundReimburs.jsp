<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<%
	request.setAttribute("currTime", new java.util.Date());
%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
<style>
#table1, .tab {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	width: 97%;
}
#table1 td:not(.select2), .tab td {
	border: solid #999 1px;
	text-align: center;
}
#table1 td input[type="text"], .tab td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table1 td input[name="name"],input[name="applyTime"]{
	text-align:center;
}

#table1 td input[name="startPoint"],input[name="destination"],input[name="place"],input[name="dayRoom"]{
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align:center;
}

#table1 td input[name="actReimburse"],input[name="cost"]{
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding-right:5px;
}

select{
   appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center;
}

hr{
	margin-top:0px;
	margin-bottom:0px;
 	border-top-color:#999999;
 	display:none;
} 

textarea{
	resize: none;
	border: none;
	outline: medium;
	width:100%;
}

textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
	padding-top:10px;
	text-align:left;
}


.end{
	width:100%;
	border-top-style:hidden;
}

.datetimepick{
	text-align:center;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}



.select2-selection__clear{
	display:none;
}

.select2-container--default .select2-selection--single{
	border:none;
	padding-left:0;
}

.select2-container .select2-selection--single .select2-selection__rendered{
	padding-left:0;
}

.select2-container--default .select2-selection--single .select2-selection__arrow b{
	border:none;	
}

#table1 td span:not(.select2 span), .tab td span {
	padding: 0px 6px;
	text-align: center;
}
@media (max-width: 768px) {
	#table1 td span:not(.select2 span) {
		padding: 0px 5px;
		text-align: center;
	}
}
#table1 th, .tab th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

.td_one {
	width: 5%;
}
.td_two {
	width: 10%;
}
.td_three {
	width: 20%;
}
.td_right {
	text-align: right;
}
.td_weight {
	font-weight: bold;
}

.label_title {
	display: block;
	border-bottom: 1px solid white;
	padding: 0.5em;
}
.label_item {
	display: block;
	border-bottom: 1px solid white;
	text-align: left;
}
</style>
</head>
<body style="min-width:1100px; overflow:auto;font-size:small;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">报销</li>
			<li class="active">出差报销</li>
			<li class="active">报销申请</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-16">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<div style="text-align: center;font-weight: bolder;font-size: large;">
							<thead>
								<tr>
								<th colspan="34">差旅报销单</th>
								<span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(报销单号：${travelreimburse.orderNo })</span>
								</tr>
							</thead>
						</div>
						<table id="table1">
							<tbody>
								<input type="hidden" id="id" name="id" value="${travelreimburse.id }">
								<input type="hidden" id="deptId" name="deptId" value="${travelreimburse.deptId}">
								<input type="hidden" id="attachments" name="attachments" value="${travelreimburse.attachments }">
								<input type="hidden" id="attachName" name="attachName" value="${travelreimburse.attachName }">	
								<input type="hidden" id="travelId" name="travelId" value="${travelreimburse.travel.id }">
								<input type="hidden" id="travelProcessInstanceId" value="${travelreimburse.travel.processInstanceId }">
								<input type="hidden" id="issubmit" name="issubmit" value="">
								<input type="hidden" id="orderNo" name="orderNo" value="${travelreimburse.orderNo}">
								<input type="hidden" id="total" name="total" readonly>
								<input type="hidden" id="totalcn" readonly>
								<select id="conveyance_hidden" style="display:none;">
										<custom:dictSelect type="出差报销交通工具"/>
									</select>
								<!-- 报销人相关 -->
								<tr>
									<td class="td_weight"><span>出差人员</span></td>
									<td>
										<input type="text" id="name" name="name" value="${travelreimburse.name }" readonly>
									</td>
									
									<td class="td_weight"><span>报销单位</span></td>
									<td colspan="2"  style="line-height:inherit;text-align:left;">
										<custom:getDictKey type="流程所属公司" value="${travelreimburse.title }"/>
										<c:choose>
										<c:when test="${empty(sessionScope.user.dept.alias)}"> 
										<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${travelreimburse.dept.name }" readonly>
										</c:when>
										<c:otherwise>  
										<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${travelreimburse.alias }" readonly>
										</c:otherwise>
										</c:choose>
									</td>
									<td class="td_weight"><span>提交日期</span></td>
									<td colspan="4">
										<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value='${travelreimburse.applyTime}' pattern='yyyy-MM-dd'/>" readonly >
									</td>
								</tr>
								</tr>
									<tr>
										<td class="td_weight"><span>领款人</span></td>
										<td style="width:108px;padding-left:35px;">
											<input type="text" id="payee" name="payee" value ="${travelreimburse.payee }" readonly>
											
										</td>
										<td class="td_weight"><span>银行卡号</span></td>
										<td><input type="text" id="bankAccount" name="bankAccount" value="${travelreimburse.bankAccount }" readonly></td>
										<td class="td_weight"><span>开户行名称</span></td>
										<td colspan="6"><input type="text" id="bankAddress" name="bankAddress" value="${travelreimburse.bankAddress }" readonly></td>
									</tr>
									<tr>
										<td colspan="22">
												<div style="text-align:left;">
													<a href="#intercityCost" data-toggle="collapse">城际交通费</a>
													<div id="myTabContent" class="tab-content">
														<!-- 城际交通费 -->
														<div class="panel-collapse collapse in" id="intercityCost"  class="tittle">
															<table style="width: 100%;">
																<thead>
																	<tr>
																		<td class="td_weight" style="border-left-style:hidden;">日期</td>
																		<td class="td_weight">出发地</td>
																		<td class="td_weight">目的地</td>
																		<td class="td_weight">交通工具</td>
																		<td class="td_weight">项目</td>
																		<td class="td_weight">费用</td>
																		<td class="td_weight">实报</td>
																		<td class="td_weight">事由</td>
																		<td class="td_weight" colspan="2">明细</td>
																	</tr>
																</thead>
																<tbody>
																	<c:forEach items="${travelreimburseAttachs}"
																		var="travelreimburseAttach">
																		<c:if test="${travelreimburseAttach.type eq '0' }">
																			<tr name="node">
																				<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																				<td style="width: 6%; border-left-style:hidden; "><input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																					readonly></td>
																				<td style="width: 5.5%;"><input type="text" name="startPoint" value="${travelreimburseAttach.startPoint }" readonly>
																				</td>
																				<td style="width: 5.5%;"><input type="text" name="destination"  value="${travelreimburseAttach.destination }" readonly></td>
																				<td style="width: 5.5%;"><custom:getDictKey type="出差报销交通工具" value="${travelreimburseAttach.conveyance }" /></td>
																				<td style="width: 13%;"><input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
																					<textarea  name="projectName"  onclick="openProject(this, 'intercityCost')" readonly>${travelreimburseAttach.project.name }</textarea></td>
																				<td style="width: 5.5%;"><input type="text" readonly
																					name="cost" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																				</td>
																				<td style="width: 5.5%;"><input type="text" readonly
																					name="actReimburse" style="text-align:right"
																					value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																				</td>
																				<td style="width: 18%;"><textarea 
																					name="reason" readonly onfocus="reasonChange(this, 'intercityCost')">${travelreimburseAttach.reason }</textarea>
																				</td>
																				<td style="width:26.2%" colspan="2"><textarea name="detail"  readonly>${travelreimburseAttach.detail }</textarea></td>
																				
																			</tr>
																		</c:if>
																	</c:forEach>
																</tbody>
															</table>
														</div>
														<hr style="display:none">
														<!-- 住宿费 -->
														<div style="text-align:left;" class="tittle" >
															<a href="#stayCost" data-toggle="collapse"
																data-parent="#intercityCost">住宿费</a>
															<div class="panel-collapse collapse in" id="stayCost">
																<table style="width: 100%">
																	<thead>
																		<tr>
																			<td class="td_weight" style="border-left-style:hidden;">日期</td>
																			<td class="td_weight">地点</td>
																			<td class="td_weight">项目</td>
																			<td class="td_weight">天*房</td>
																			<td class="td_weight">费用</td>
																			<td class="td_weight">实报</td>
																			<td class="td_weight">事由</td>
																			<td class="td_weight" colspan="2">明细</td>
																		</tr>
																	</thead>
																	<tbody>
																		<c:forEach items="${travelreimburseAttachs}"
																			var="travelreimburseAttach">
																			<c:if test="${travelreimburseAttach.type eq '1' }">
																				<tr name="node">
																					<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																					<td style="width: 5%; border-left-style:hidden; "><input type="text"
																						name="date" class="datetimepick" 
																						value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																						readonly></td>
																					<td style="width: 5%;"><input type="text"
																						name="place" readonly
																						value="${travelreimburseAttach.place }"></td>
																					<td style="width: 12%;"><input type="hidden"
																						name="projectId"
																						value="${travelreimburseAttach.projectId }">
																						<textarea name="projectName"
																						onclick="openProject(this, 'stayCost')"
																						readonly>${travelreimburseAttach.project.name }</textarea></td>
																					<td style="width: 5%;"><input type="text"
																						name="dayRoom"  readonly
																						value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
																					</td>
																					<td style="width: 5%;"><input type="text"
																						name="cost"  style="text-align:right" readonly
																						value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																					</td>
																					<td style="width: 5%;"><input type="text" readonly
																						name="actReimburse" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																					</td>
																					<td style="width: 15%;"><textarea readonly
																						name="reason">${travelreimburseAttach.reason }</textarea>
																					</td>
																					<td style="width: 21.4%;" colspan="2"><textarea readonly
																						name="detail">${travelreimburseAttach.detail }</textarea>
																					</td>
																				</tr>
																			</c:if>
																		</c:forEach>
																	</tbody>
																</table>
															</div>
														</div>
														<hr>
														<!-- 市内交通费 -->
														<div style="text-align:left;" class="tittle" >
															<a href="#cityCost" data-toggle="collapse">市内交通费</a>
															<div class="panel-collapse collapse in" id="cityCost">
																<table style="width: 100%;">
																	<thead>
																		<tr>
																			<td class="td_weight" style="border-left-style:hidden;">日期</td>
																			<td class="td_weight">地点</td>
																			<td class="td_weight">项目</td>
																			<td class="td_weight">费用</td>
																			<td class="td_weight">实报</td>
																			<td class="td_weight">事由</td>
																			<td class="td_weight" colspan="2">明细</td>
																		</tr>
																	</thead>
																	<tbody>
																		
																		<c:forEach items="${travelreimburseAttachs}"
																			var="travelreimburseAttach">
																			<c:if test="${travelreimburseAttach.type eq '2' }">
																				<tr name="node">
																					<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																					<td style="width: 6%; border-left-style:hidden;"><input type="text"
																						name="date" class="datetimepick"
																						value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																						readonly></td>
																					<td style="width: 6.2%;"><input type="text"
																						name="place" readonly
																						value="${travelreimburseAttach.place }"></td>
																					<td style="width: 14%;"><input type="hidden"
																						name="projectId"
																						value="${travelreimburseAttach.projectId }">
																						<textarea type="text" name="projectName"
																						onclick="openProject(this, 'cityCost')"
																						readonly>${travelreimburseAttach.project.name }</textarea></td>
																					<td style="width: 7%;"><input type="text" readonly
																						name="cost" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																					</td>
																					<td style="width: 7%;"><input type="text" readonly
																						name="actReimburse" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																					</td>
																					<td style="width: 20.6%;"><textarea type="text" readonly
																						name="reason">${travelreimburseAttach.reason }</textarea>
																					</td>
																					<td style="width: 24.8%;" colspan="2"><textarea type="text" readonly
																						name="detail">${travelreimburseAttach.detail }</textarea>
																					</td>
																				</tr>
																			</c:if>
																		</c:forEach>
																	</tbody>
																</table>
														</div>
														</div>
														<hr>
														<!-- 接待餐费-->
														<div style="text-align:left;" class="tittle" >
															<a href="#receiveCost" data-toggle="collapse">接待费用</a>
															<div class="panel-collapse collapse in" id="receiveCost">
																<table style="width: 100%;">
																	<thead>
																		<tr>
																			<td class="td_weight" style="border-left-style:hidden;">日期</td>
																			<td class="td_weight">地点</td>
																			<td class="td_weight">项目</td>
																			<td class="td_weight">费用</td>
																			<td class="td_weight">实报</td>
																			<td class="td_weight">事由</td>
																			<td class="td_weight"  colspan="2">明细</td>
																		</tr>
																	</thead>
																	<tbody>
																		<c:forEach items="${travelreimburseAttachs}"
																			var="travelreimburseAttach">
																			<c:if test="${travelreimburseAttach.type eq '3' }">
																				<tr name="node">
																					<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																					<td style="width: 6%; border-left-style:hidden;"><input type="text"
																						name="date" class="datetimepick"
																						value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																						readonly></td>
																					<td style="width: 6.2%;"><input type="text"
																						name="place" readonly
																						value="${travelreimburseAttach.place }"></td>
																					<td style="width: 14%;"><input type="hidden"
																						name="projectId"
																						value="${travelreimburseAttach.projectId }">
																						<textarea name="projectName"
																						onclick="openProject(this, 'receiveCost')"
																						readonly>${travelreimburseAttach.project.name }</textarea></td>
																					<td style="width: 7%;"><input type="text"
																						name="cost" style="text-align:right" readonly
																						value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																					</td>
																					<td style="width: 7%;"><input type="text" readonly
																						name="actReimburse" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																					</td>
																					<td style="width: 20.6%;"><textarea readonly
																						name="reason">${travelreimburseAttach.reason }</textarea>
																					</td>
																					<td style="width: 24.8%;"  colspan="2"><textarea  readonly
																						name="detail">${travelreimburseAttach.detail }</textarea>
																					</td>
																				</tr>
																			</c:if>
																		</c:forEach>
																	</tbody>
																</table>
															</div>
														</div>
														<hr>
														<!-- 补贴 -->
														<div style="text-align:left;" class="tittle" >
															<a href="#subsidy" data-toggle="collapse">补贴</a>
															<div class="panel-collapse collapse in" id="subsidy">
																<table  style="width: 100%;">
																	<thead>
																		<tr>
																			<td class="td_weight" style="border-left-style:hidden;">出发日期</td>
																			<td class="td_weight">离开日期</td>
																			<td class="td_weight">餐费补贴</td>
																			<td class="td_weight">交通补贴</td>
																			<td class="td_weight">项目</td>
																			<td class="td_weight">事由</td>
																			<td class="td_weight" colspan="2">明细</td>
																		</tr>
																	</thead>
																	<tbody>
																		<c:forEach items="${travelreimburseAttachs}"
																			var="travelreimburseAttach">
																			<c:if test="${travelreimburseAttach.type eq '4' }">
																				<tr name="node">
																					<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																					<td style="width: 6%; border-left-style:hidden;"><input type="text" 
																						name="beginDate" class="datetimepick" readonly
																						value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />">
																					</td>
																					<td style="width: 6%;"><input type="text" 
																						name="endDate"  class="datetimepick" readonly
																						value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />">
																					</td>
																					<td style="width: 7%;"><input type="text" readonly
																						name="foodSubsidy" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
																					</td>
																					<td style="width: 7%;"><input type="text" readonly
																						name="trafficSubsidy" style="text-align:right"
																						value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />">
																					</td>
																					<td style="width: 15%;"><input type="hidden"
																						name="projectId"
																						value="${travelreimburseAttach.projectId }">
																						<textarea  name="projectName"
																						onclick="openProject(this, 'subsidy')"
																						readonly>${travelreimburseAttach.project.name }</textarea></td>
																					<td style="width: 20%;"><textarea readonly
																						name="reason">${travelreimburseAttach.reason }</textarea>
																					</td>
																					<td style="width: 25%;" colspan="2"><textarea readonly
																						name="detail">${travelreimburseAttach.detail }</textarea>
																					</td>
																				</tr>
																			</c:if>
																		</c:forEach>
																	</tbody>
																</table>
															</div>
														</div>
														<hr>
													<table class="end">
														<tr>
															<td class="td_right td_weight" style="width:8%; border-left-style:hidden;"><span>实报金额：</span></td>
															<td style="width:92%; border-right-style:hidden; " >
															<div style="display:flex">
															<div style="display:flex">
															<span>¥</span>
															<span id="Total"></span>
															</div>
															<div>
																(
																<span id="Totalcn"></span>
																) 
															</div>
															</div>
														</td>
														</tr>
													</table>
													<table class="end">
														<td class="td_weight" style="width:8%; border-left-style:hidden;border-bottom-style:hidden;"><span>出差管理</span></td>
														<td colspan="20" style="text-align: left; border-bottom-style:hidden; border-right-style:hidden;"><input
															type="button" value="请选择出差申请" onclick="openTravel()" style="border:none;">
															<input type="button" id="viewTravelBtn" value="查看出差详细"
															onclick="viewTravel()" style="display: none">
														</td> 
													</table> 
										</td>
									</tr>
								</tbody>
							<tfoot>
								  <tr>
										<td style="width:8.1%" class="td_right td_weight"><span>附件：</span></td>
										<td colspan="6" style="border-right-style:hidden;"><a href="javascript:void(0);"
											onclick="downloadAttach(this)"
											value="${travelreimburse.attachments }" target='_blank'><input
											type="text" id="showName" name="showName"
											value="${travelreimburse.attachName }" readonly></a>
										<td>
											<input type="file" id="file" name="file" style="display:none;">
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
										</td>
										</td>
										<td colspan="3"><a href="javascript:void(0);"
											onclick="deleteAttach(this)"
										    value="${travelreimburse.attachments }">删除</a></td>
								 </tr>  
								
								<tr>
									<td colspan="34" style="text-align:center;padding:10px;border:none;">
										<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
										<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">取消</button>
									</td>
								</tr>
							</tfoot>
						</table>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="deptDialog"></div>
<div id="projectDialog"></div>
<div id="travelDialog"></div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
    	<div class="modal-content" style="height:100%;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel">出差详细</h4>
         	</div>
	        <div class="modal-body" style="height:75%;">
	        	<iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
			</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->


<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/projectUnboundReimburs.js"></script>
</body>
</html>