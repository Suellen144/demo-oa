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
	/* padding: 5px; */
	text-align: center;
}
#table1 td input[type="text"], .tab td input[type="text"]{
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}


#table1 td input[name="startPoint"],input[name="destination"],input[name="place"],input[name="dayRoom"]
	,input[name="payee"],input[name="bankAddress"]{
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

#table1 td input[name="name"],input[name="applyTime"]{
	text-align:center;
}


 .select2-selection__clear{
	/* display:none; */
} 

hr{
	margin-top:0px;
	margin-bottom:0px;
 	border-top-color:#999999;
 	display:block;
} 

.end{
	width:100%;
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

thread{
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

textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
	padding-top:10px;
	text-align:left;
}


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
.datetimepick{
	text-align:center;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align: justify;
  text-align-last:center;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
	text-align: justify;
    text-align-last:center;
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
<body style="min-width:1100px; overflow:auto;height:500px;font-size:small;">
<div class="wrapper">
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
								<tr><th colspan="34">差旅报销单</th></tr>
								<i class="icon-question-sign" style="cursor:pointer"  onclick="showhelp()"> </i>
							</thead>
						</div>
						<table id="table1">
							<tbody>
								<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
								<input type="hidden" id="attachments" name="attachments" value="">
								<input type="hidden" id="attachName" name="attachName" value="">
								<input type="hidden" id="travelId" name="travelId" value="">
								<input type="hidden" id="travelProcessInstanceId" value="">
								<input type="hidden" id="orderNo" value="">
								<input type="hidden" id="issubmit" name="issubmit" value="">
								<input type="hidden" id="total" name="total" readonly>
								<input type="hidden" id="totalcn" readonly>
								<select id="conveyance_hidden" style="display:none;">
									<custom:dictSelect type="出差报销交通工具"/>
								</select>
								<select id="conveyance1_hidden" style="display: none">
									<custom:dictSelect type="市内交通费交通工具"/>
								</select>
								
								<!-- 报销人相关 -->
								<tr>
									<td class="td_weight" style="width:10px;"><span>出差人员</span></td>
									<td style="width:1%"> 
										<input type="text" id="name" name="name" value="${sessionScope.user.name }">
									</td>
									
									<td class="td_weight" style="width:10%"><span>报销单位</span></td>
									<td style="width:20%;line-height:20px;text-align:left;">
										<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;text-align:left;"><custom:dictSelect type="流程所属公司" /></select>
										</c:if>
										<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
										</c:if>
										<c:choose>
										<c:when test="${empty(sessionScope.user.dept.alias)}"> 
										<input  type="text" style="height:20px;font-size:14px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${sessionScope.user.dept.name }" readonly>
										</c:when>
										<c:otherwise>  
										<input  type="text" style="height:20px;font-size:14px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
										</c:otherwise>
										</c:choose>
									</td>
									
									<td class="td_weight" style="width:10%;"><span>提交日期</span></td>
									<td style="width:10%;">
										<input type="text" id="applyTime" name="applyTime" " value="<fmt:formatDate value='${currTime}' pattern='yyyy-MM-dd'/>" readonly >
									</td>
								</tr>
								
											<!-- 领款人相关 -->
									<tr>
									<td class="td_weight"><span>领款人</span></td>
									<td style="width:5%;" ><input type="text" id="payee" name="payee" value="${payee}"></td>
									<td class="td_weight"><span>银行卡号</span></td>
									<td><input type="text" id="bankAccount" name="bankAccount" value="${number}"></td>
									<td class="td_weight"><span>开户行名称</span></td>
									<td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${address}"></td>
								</tr>
								
								<!-- 城际交通费 -->
								<tr>
									<td colspan="22">
										   <div style="text-align:left;"><a href="#intercityCost" data-toggle="collapse">城际交通费 </a>
										  
											<div class="panel-collapse collapse in" id="intercityCost">
												<div>
												<table style="width:100%;">
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
															<td class="td_weight">明细</td>
															<td class="td_weight" style="border-right-style:hidden;">操作</td>
														</tr>
													</thead>
													<tbody>
														<tr name="node">
															<td style="width: 6.8%; border-left-style:hidden;">
																<input type="text" name="date" class="datetimepick" readonly>
															</td>
															<td style="width: 6.1%;">
																<input type="text" name="startPoint">
															</td>
															<td style="width: 6%; ">
																<input type="text" name="destination">
															</td>
															<td style="width: 6%;">
																<select name="conveyance" style="width:100%;">
																	<custom:dictSelect type="出差报销交通工具"/>
																</select>
															</td>
															<td style="width: 12%;">
																<input type="hidden" name="projectId">
																<textarea name="projectName" id="projectName" onclick="openProject(this, 'intercityCost')" readonly></textarea>
															</td>
															<td style="width: 5%;">
																<input type="text" name="cost" style="text-align:right">
															</td>
															<td style="width: 5%;">
																<input type="text" name="actReimburse" style="text-align:right">
															</td>
															<td style="width: 18%;height:auto;">
																<textarea name="reason"  autocomplete="off" onfocus="reasonChange(this, 'intercityCost')"></textarea>
															</td>
															<td style="width: 24.5%;"><textarea name="detail"  autocomplete="off"></textarea></td>
															<td style="width: 4%;" ><a href="javascript:void(0);" style="font-size:x-large" onclick="node('add', 'intercityCost', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large" onclick="node('del', 'intercityCost', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
														</tr>
													</tbody>
												</table>
												</div>
										  	 	</div>
										   </div>
										   <hr style="display:none;">
											  <!-- 住宿费 -->
										   <div style="text-align:left;">
										   <a href="#stayCost" data-toggle="collapse" data-parent="#intercityCost">住宿费</a>
										   	<div class="panel-collapse collapse" id="stayCost">
										   		<table style="width:100%;">
													<thead>
														<tr>
															<td class="td_weight" style="border-left-style:hidden;">日期</td>
															<td class="td_weight">地点</td>
															<td class="td_weight">项目</td>
															<td class="td_weight">天*房</td>
															<td class="td_weight">费用</td>
															<td class="td_weight">实报</td>
															<td class="td_weight">事由</td>
															<td class="td_weight">明细</td>
															<td class="td_weight" style="border-right-style:hidden;">操作</td>
														</tr>
													</thead>
													<tbody>
														<tr name="node">
															<td style="width: 5.6%; border-left-style:hidden; ">
																<input type="text" name="date" class="datetimepick" readonly>
															</td>
															<td style="width: 5.2%;">
																<input type="text" name="place">
															</td>
															<td style="width: 11%;">
																<input type="hidden" name="projectId">
																<textarea type="text" id="stayPorject" name="projectName" onclick="openProject(this, 'stayCost')" readonly></textarea>
															</td>
															<td style="width: 5%;">
																<input type="text" name="dayRoom">
															</td>
															<td style="width: 5%;">
																<input type="text" name="cost" style="text-align:right">
															</td>
															<td style="width: 5%;">
																<input type="text" name="actReimburse" style="text-align:right">
															</td>
															<td style="width: 18%;">
																<textarea  id="stayreason" style="height: 20px;" type="text" name="reason" onfocus="reasonChange(this, 'stayCost')"></textarea>
															</td>
															<td style="width: 20.7%;">
																<textarea id="staydetail" name="detail"></textarea>
															</td>
															<td style="width: 3.4%;"><a href="javascript:void(0);" onclick="node('add', 'stayCost', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'stayCost', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
														</tr>
													</tbody>
												</table>
										   	</div>
										   </div>
										    <hr>
										   
										    <!-- 市内交通费 -->
										   <div style="text-align:left;">
										   <a href="#cityCost" data-toggle="collapse">市内交通费</a>
										   	<div class="panel-collapse collapse" id="cityCost">
										   		<table style="width:100%;">
													<thead>
														<tr>
															<td class="td_weight" style="border-left-style:hidden;">日期</td>
															<td class="td_weight">地点</td>
															<td class="td_weight trafficT" style="width: 3%;white-space: nowrap;">交通工具</td>
															<td class="td_weight">项目</td>
															<td class="td_weight">费用</td>
															<td class="td_weight">实报</td>
															<td class="td_weight">事由</td>
															<td class="td_weight">明细</td>
															<td class="td_weight" style="border-right-style:hidden;white-space: nowrap;">操作</td>
														</tr>
													</thead>
													<tbody>
														<tr name="node">
															<td style="width:7%; border-left-style:hidden;">
																<input type="text" name="date" class="datetimepick" readonly>
															</td>
															<td style="width: 6.3%;">
																<input type="text" name="place">
															</td>
															<td style="width: 3%;white-space: nowrap">
																<select name="conveyance" style="width:100%;">
																	<custom:dictSelect type="市内交通费交通工具"/>
																</select>
															</td>
															<td style="width: 15%;">
																<input type="hidden" name="projectId">
																<textarea type="text" id="cityproject" name="projectName" onclick="openProject(this, 'cityCost')" readonly></textarea>
															</td>
															<td style="width: 7%;">
																<input type="text" name="cost" style="text-align:right">
															</td>
															<td style="width: 7%;">
																<input type="text" name="actReimburse" style="text-align:right">
															</td>
															<td style="width: 25%;">
																<textarea id=cityreason name="reason" onfocus="reasonChange(this, 'cityCost')"></textarea>
															</td>
															<td style="width: 25.4%;">
																<textarea id=citydetail name="detail"></textarea>
															</td>
															<td style="width: 4%;"><a href="javascript:void(0);" onclick="node('add', 'cityCost', this)"  style="font-size:x-large"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'cityCost', this)"  style="font-size:x-large"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
														</tr>
													</tbody>
												</table>
										   	</div>
										   </div>
										   <%--  <hr>
										    <!-- 接待餐费-->
										   <div style="text-align:left;">
										   <a href="#receiveCost" data-toggle="collapse">接待费用</a>
										   	<div class="panel-collapse collapse" id="receiveCost">
										   		<table style="width:100%;">
													<thead>
														<tr>
															<td class="td_weight" style="border-left-style:hidden;">日期</td>
															<td class="td_weight">地点</td>
															<td class="td_weight">项目</td>
															<td class="td_weight">费用</td>
															<td class="td_weight">实报</td>
															<td class="td_weight">事由</td>
															<td class="td_weight">明细</td>
															<td class="td_weight" style="border-right-style:hidden;">操作</td>
														</tr>
													</thead>
													<tbody>
														<tr name="node">
															<td style="width: 7%;border-left-style:hidden;">
																<input type="text" name="date" class="datetimepick" readonly>
															</td>
															<td style="width: 6.3%;">
																<input type="text" name="place">
															</td>
															<td style="width: 15%;">
																<input type="hidden" name="projectId">
																<textarea type="text" id="receiveproject" name="projectName" onclick="openProject(this, 'receiveCost')" readonly></textarea>
															</td>
															<td style="width: 7%;">
																<input type="text" name="cost" style="text-align:right">
															</td>
															<td style="width: 7%;">
																<input type="text" name="actReimburse" style="text-align:right">
															</td>
															<td style="width: 25%;">
																<textarea type="text" id="receivereason" name="reason" onfocus="reasonChange(this, 'receiveCost')"></textarea>
															</td>
															<td style="width: 25.4%;">
																<textarea type="text" id="receivedetail" name="detail"></textarea>
															</td>
															<td style="width: 4%;"><a href="javascript:void(0);" onclick="node('add', 'receiveCost', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'receiveCost', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
														</tr>
													</tbody>
												</table>
										   	</div>
										   </div>--%>
										     <hr>
										   <!-- 补贴 -->
										   <div style="text-align:left;">
										   <a href="#subsidy" data-toggle="collapse">补贴</a>
										   	<div class="panel-collapse collapse" id="subsidy">
										   		<table style="width:100%;">
													<thead>
														<tr>
															<td class="td_weight" style="border-left-style:hidden;">出发日期</td>
															<td class="td_weight">离开日期</td>
															<td class="td_weight">餐费补贴 </td>
															<td class="td_weight">交通补贴</td>
															<td class="td_weight">项目</td>
															<td class="td_weight">事由</td>
															<td class="td_weight">明细</td>
															<td class="td_weight" style="border-right-style:hidden;">操作</td>
														</tr>
													</thead>
													<tbody>
														<tr name="node">
															<input type="hidden" name = "date">
															<input type="hidden" name = "actReimburse" value="">
															<td style="width: 6.6%; border-left-style:hidden;">
																<input type="text" name="beginDate" class="datetimepick" readonly>
															</td>
															<td style="width: 6.8%;">
																<input type="text" name="endDate" class="datetimepick" readonly>
															</td>
															<td style="width: 7%;">
																<input type="text" name="foodSubsidy" style="text-align:right">
															</td>
															<td style="width: 6.6%;">
																<input type="text" name="trafficSubsidy" style="text-align:right">
															</td>
															<td style="width: 15%;">
																<input type="hidden" name="projectId">
																<textarea name="projectName" id="subsidyproject" onclick="openProject(this, 'subsidy')" readonly></textarea>
															</td>
															<td style="width: 19%;">
																<textarea  id="subsidyreason" name="reason" onfocus="reasonChange(this, 'subsidy')"></textarea>
															</td>
															<td style="width: 23%;">
																<textarea id="subsidydetail" name="detail"></textarea>
															</td>
															<td style="width: 3.7%;">
															<a href="javascript:void(0);" onclick="node('add', 'subsidy', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
															<a href="javascript:void(0);" onclick="node('del', 'subsidy', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
															</td>
														</tr>
													</tbody>
												</table>
										   	</div>
										</div>
										<hr>
										<!-- 业务费-->
										<div style="text-align:left;">
											<a href="#business" data-toggle="collapse">业务费用</a>
											<div class="panel-collapse collapse" id="business">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight" style="border-left-style:hidden;">日期</td>
														<td class="td_weight">地点</td>
														<td class="td_weight">项目</td>
														<td class="td_weight">费用</td>
														<td class="td_weight">实报</td>
														<td class="td_weight">事由</td>
														<td class="td_weight">明细</td>
														<td class="td_weight" style="border-right-style:hidden;">操作</td>
													</tr>
													</thead>
													<tbody>
													<tr name="node">
														<td style="width: 7%;border-left-style:hidden;">
															<input type="text" name="date" class="datetimepick" readonly>
														</td>
														<td style="width: 6.3%;">
															<input type="text" name="place">
														</td>
														<td style="width: 15%;">
															<input type="hidden" name="projectId">
															<textarea type="text" id="businessproject" name="projectName" onclick="openProject(this, 'business')" readonly></textarea>
														</td>
														<td style="width: 7%;">
															<input type="text" name="cost" style="text-align:right">
														</td>
														<td style="width: 7%;">
															<input type="text" name="actReimburse" style="text-align:right" onchange="validationRed('business')">
														</td>
														<td style="width: 25%;">
															<textarea type="text" id="businessreason" name="reason" onfocus="reasonChange(this, 'business')"></textarea>
														</td>
														<td style="width: 25.4%;">
															<textarea type="text" id="businessdetail" name="detail"></textarea>
														</td>
														<td style="width: 4%;">
															<a href="javascript:void(0);" onclick="node('add', 'business', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
															<a href="javascript:void(0);" onclick="node('del', 'business', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
														</td>
													</tr>
													</tbody>
												</table>
											</div>
										</div>
										<hr>
										<!-- 攻关费-->
										<div style="text-align:left;">
											<a href="#relationship" data-toggle="collapse">攻关费用</a>
											<div class="panel-collapse collapse" id="relationship">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight" style="border-left-style:hidden;">日期</td>
														<td class="td_weight">地点</td>
														<td class="td_weight">项目</td>
														<td class="td_weight">费用</td>
														<td class="td_weight">实报</td>
														<td class="td_weight">事由</td>
														<td class="td_weight">明细</td>
														<td class="td_weight" style="border-right-style:hidden;">操作</td>
													</tr>
													</thead>
													<tbody>
													<tr name="node">
														<td style="width: 7%;border-left-style:hidden;">
															<input type="text" name="date" class="datetimepick" readonly>
														</td>
														<td style="width: 6.3%;">
															<input type="text" name="place">
														</td>
														<td style="width: 15%;">
															<input type="hidden" name="projectId">
															<textarea type="text" id="relationshipproject" name="projectName" onclick="openProject(this, 'relationship')" readonly></textarea>
														</td>
														<td style="width: 7%;">
															<input type="text" name="cost" style="text-align:right">
														</td>
														<td style="width: 7%;">
															<input type="text" name="actReimburse" style="text-align:right" onchange="validationRed('relationship')">
														</td>
														<td style="width: 25%;">
															<textarea type="text" id="relationshipreason" name="reason" onfocus="reasonChange(this, 'relationship')"></textarea>
														</td>
														<td style="width: 25.4%;">
															<textarea type="text" id="relationshipdetail" name="detail"></textarea>
														</td>
														<td style="width: 4%;"><a href="javascript:void(0);" onclick="node('add', 'relationship', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'relationship', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
													</tr>
													</tbody>
												</table>
											</div>
										</div>
										  <hr>
										 <table class="end"  style="border-top-style:hidden;">
											<tr>
												<td class="td_right td_weight" style="width:7.5%;  border-left-style:hidden;"><span>实报金额：</span></td>
													<td style="width:92%;border-right-style:hidden;">
													<div style="display:flex">
													<div style="display:flex">
													<span>¥</span>
													<span id="Total" name="Total"></span>
													</div>
													<div>
														&nbsp;&nbsp;
														<span id="Totalcn"></span>
													</div>
													</div>
												</td>
											</tr>
										</table>
										<table class="end" style="border-top:none;">
										<td class="td_weight" style="border-bottom:0px; border-top:0px; width:7.5%; border-left-style:hidden;" ><span>出差管理</span></td>
										<td colspan="20" style="text-align:left; border:0px; border-right-style:hidden;">
										<input  type="button" value="请选择出差申请" onclick="openTravel()" style="border:none;">
										<span id="selectTravel" name="selectTravel"></span>
										</td>
										</table>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
											<td  class="td_right td_weight" style="padding:5px;border-right:none; width:7.6%;padding-right:60px;"><span>附件：</span></td>
												<td colspan="3" style="border-right:none;border-left:none;">
													<input type="text" id="showName" name="showName" value="" readonly>
													<td colspan="7" style="border-left:none;">
													<input type="file" id="file" name="file" style="display:none;">
													<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
													</td>
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

<!-- 帮助文本模态框（Modal） -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
    	<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">差旅报销填写规范</h4>
         	</div>
	        <div class="modal-body">
				<p>
					双箭头符号⇌  单箭头符号→
				</p>
	        	<p>
					    <span style="font-size:19px">1</span><span style="font-size:19px;font-family:宋体">、由行政部代订机票，出差人员填写差旅报销单时，须将城际交通往返路线写清楚，金额填</span><span style="font-size:19px">0</span><span style="font-size:19px;font-family:宋体">，明细注明：行政部代订机票，</span><span style="font-family: 宋体; font-size: 19px;">如员工个人购买机票，附件请附上报价单，明细写上机票几折。</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695004905.png" _src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"/>
					</p>
					<p>
					    <span style="font-size:19px">2</span><span style="font-size:19px;font-family:宋体">、同一天内如果不是直达目的地，需要中转的，中转费用不需要单独加行填写，与当天的交通费用合并填写，明细栏上注明在某某地点某某交通工具中转即可，发票金额与实报金额不一致的请写上发票金额为多少元。</span><img src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png" _src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"/>
					</p>
					<p>
					    <span style="font-size:19px">3</span><span style="font-size:19px;font-family:宋体">、住宿费：日期填写入住酒店当天（发票一般是离开酒店时开具的），如与其他同事一起住宿请在明细栏写明，住宿由于特殊原因超标，请写明原因。</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695286246.png" _src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"/>
					</p>
					<p>
					    <span style="font-size:19px;font-family:宋体"><span style="font-size:19px;font-family: &#39;Calibri&#39;,sans-serif">4</span><span style="font-size:19px;font-family:宋体">、</span>市内交通费用的填报：同一天在同一个城市产生的公交地铁打的可写在一起</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:宋体">在明细写清楚路线金额（</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family: 宋体">地方</span><span style="font-size: 19px;font-family: Arial, sans-serif;color: rgb(51, 51, 51)">→</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family:宋体">地方</span><span style="font-size:19px">+</span><span style="font-size:19px;font-family: 宋体">交通工具，如打的拜访客户的请写明拜访某公司某客户）</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:宋体">如与其他同事一起打车请在明细栏写明，不同时间、不同城市的分开填写，大家选择滴滴出行的，报销时请提供纸质的滴滴发票与行程单，行程单的金额必须与发票金额一致，行程单上须显示具体的起点与终点地址；周六日因公的交通费用请在报销明细上注明是周六日，属于早班机</span><span style="font-size:19px">8</span><span style="font-size:19px;font-family:宋体">点前打的费用与晚班机</span><span style="font-size:19px">11</span><span style="font-size:19px;font-family: 宋体">点后打的费用请在明细注明</span><span style="font-size:19px">(</span><span style="font-size:19px;font-family: 宋体">早班机几点或者晚班机几点</span><span style="font-size:19px">)</span><span style="font-size:19px;font-family: 宋体">。</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695342507.png" _src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"/>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" _src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" style="width: 900px; height: 744px;"/><img src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" _src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" style="width: 750px; height: 708px;"/>
					</p>
					<p>
					    <span style="font-size:19px">5</span><span style="font-size:19px;font-family:宋体">、补贴：餐补和交补按出差天数填写如发生招待用餐或者同行人员参与招待用餐则当天餐补不能享受，如果连续出差几个地方跟进不同项目的，按照交通费在到达地的项目报销，补贴在出发地的项目报销的原则填报。</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20181008/1507695123456.png" _src="http://www.reyzar.com/images/upload/20181008/1507695123456.png" style="width: 940px;"/><img src="http://www.reyzar.com/images/upload/20181008/1507695654321.png" _src="http://www.reyzar.com/images/upload/20181008/1507695654321.png" style="width: 1000px;"/>
					</p>
					<p>
					    <span style="font-size:19px">6</span><span style="font-size:19px;font-family:宋体">、出差期间产生的与渠道相关的费用（例如餐费、交通、住宿），要归属到渠道商名下的，请单独填写通用报销单，不要与个人产生的费用合在一起在差旅报销单上填写。</span>
					</p>
					<p></p>
					<p>
					    <br/>
			</p>
			</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->


<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/add.js"></script>
</body>
</html>