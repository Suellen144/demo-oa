<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet"
	href="<%=base%>/static/plugins/select2/select2.min.css">
<link rel="stylesheet"
	href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet"
	href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
<link rel="stylesheet"
	href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet"
	href="<%=base%>/static/plugins/select2/select2.min.css">
<link rel="stylesheet"
	href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<body>
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">档案管理</li>
		</ol>
	</header>
	<!-- 当前登陆用户具有编辑权限，可编辑个人档案 -->
	<shiro:hasPermission name="ad:record:edit">
		<style>
tr {
	min-height: 30px;
	line-height: 30px;
	text-align: center;
}

td {
	min-height: 30px;
	line-height: 30px;
	text-align: center;
}

#table1 td {
	border: solid #999 1px;
	height: 100%;
}

.td_weight {
	text-align: center;
}

.datetimepicker {
	text-align: center;
}

td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding: 0px 1em;
	height: 30px;
	line-height: 30px;
}

textarea {
	width: 100%;
	height: 30px;
	resize: none;
	border: none;
	outline: medium;
}

select {
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	border: none;
}

/* IE10以上生效 */
select::-ms-expand {
	display: none;
}

td label {
	font-weight: normal;
}

td p {
	margin: 1px;
	white-space: nowrap;
	height: auto;
}

#imgName {
	float: left;
}

#ul_user li {
	list-style-type: none;
}

select {
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	border: none;
	text-align: justify;
	text-align-last: center;
}

span {
	display: inline-block;
	text-align: center;
}

#ul_user li:hover {
	cursor: pointer;
	font-weight: bold;
	font-size: 1.2em;
}

.dept-box, .position-box {
	z-index: 999999; /*这个数值要足够大，才能够显示在最上层*/
	margin-bottom: 2px;
	display: none;
	position: absolute;
}

.dept-box-body, .position-box-body {
	clear: both;
	margin: 2px;
	font-size: 12px;
}

.displayShow {
	display: none;
}

/******** 打印机样式 ********/
@media print {
	/* portrait： 纵向打印       landscape: 横向 打印  */
	@page {
		size: A5 landscape;
		/* margin: 2cm 0cm 1.4cm 3cm; */
	}
	* {
		text-shadow: none !important;
		box-shadow: none !important;
	}
	body {
		background-color: #FFF;
		background-image: none;
		width: 100%;
		margin: 0;
		padding: 0;
	}
	#table {
		width: 100%;
		table-collapse: collapse !important;
		border: none;
		padding: 0;
		margin: 0;
	}
	#table tr {
		/* page-break-after: always; */
		/* page-break-after: avoid; */
		
	}
	#table th {
		text-align: center;
		font-weight: bold;
		font-size: 12pt;
	}
	#table td {
		font-family: 宋体;
		font-size: 8pt !important;
		border: solid #999 0.5pt;
		padding: 1pt;
		word-break: break-all;
		word-wrap: break-word;
		text-align: center;
	}
	#table td span {
		padding: 0pt 1pt;
	}
	#table td.td_left {
		text-align: left;
	}
	#table th {
		text-align: center;
		font-weight: bold;
		font-size: 12pt;
	}
	.tab_title {
		text-align: left;
		font-weight: bold;
		border-bottom: solid #999 0.5pt;
		/* padding-top: 0.5em; */
	}
	.tab_title span {
		display: inline-block;
		padding: 3pt 8pt !important;
		border: solid #999 0.5pt;
		border-bottom: none;
	}
	#table2 {
		width: 100%;
		margin-top: 0.5em;
	}
	#table2 td {
		font-weight: bold;
		font-size: 8pt;
		width: 15%;
	}
}

div#rMenu {
	position: absolute;
	visibility: hidden;
	top: 0;
	background-color: #555;
	text-align: left;
	padding: 2px;
}

div#rMenu ul li {
	margin: 1px 0;
	padding: 0 5px;
	cursor: pointer;
	list-style: none outside none;
	background-color: #DFDFDF;
}
</style>
		<div class="wrapper">
			<!-- Main content -->
			<section class="content rlspace">
				<section class="col-md-12 connectedSortable ui-sortable">
					<div class="box box-primary box-solid">
						<div class="box-header with-border">
							<!-- <h3 class="box-title">档案</h3> -->
							<div id="rMenu">
								<ul>
									<li id="m_add" onclick="addnode()">新增类型</li>
									<li id="m_del" onclick="delnode()">删除类型</li>
								</ul>
							</div>
						</div>
						<div class="box-body">
							<form id="form">
								<input type="hidden" id="id" name="id" value="${record.id}">
								<input type="hidden" id="userId" name="userId"
									value="${record.userId}"> <input type="hidden"
									id="photo" name="photo" value="${record.photo}">
								<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>

								<table id="table1" style="width: 98%">
									<select id="dept_hidden" style="display: none">
										<custom:dictSelect type="部门" />
									</select>
									<select id="projectTeam_hidden" style="display: none">
										<custom:dictSelect type="项目组" />
									</select>
									<select id="station_hidden" style="display: none">
										<custom:dictSelect type="岗位" />
									</select>
									<select id="appoint_hidden" style="display: none">
										<custom:dictSelect type="任免" />
									</select>
									<select id="barginType_hidden" style="display: none">
										<custom:dictSelect type="合同性质" />
									</select>
									<select id="company_hidden" style="display: none">
										<custom:dictSelect type="存续公司" />
									</select>
									<select id="education_hidden" style="display: none">
										<custom:dictSelect type="学历" />
									</select>
									<thead>
										<tr>
											<th colspan="10"
												style="text-align: center; border: solid #999 1px; font-size: 1em;">
												<%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
												员工档案
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><p>员工编号</p></td>
											<td colspan="1" id="number">${record.id}</td>
											<td><p>姓名</p></td>
											<td colspan="1" contentEditable="true">${record.name}</td>
											<td><p>岗位</p>
											<td colspan="1" name="position">${record.position }</td>
											</td>
											<!-- 档案照片 -->
											<td rowspan="5" colspan="1" style="text-align: center;">
												<img id="recordImg" src="<%=base%>${record.photo }"
												width="80" height="120" onclick="select()"/> <input id="file" type="file"
												name="file" style="display: none;" />
											</td>
										</tr>
										<tr rowspan="1">
											<td><p>公司</p></td>
											<td colspan="1" name="company">${record.company }</td>
											<td><p>部门</p></td>
											<td colspan="1" name="dept">${record.dept }</td>
											<td><p>项目组</p></td>
											<td colspan="1" name="projectTeam">${record.projectTeam }</td>
										</tr>
										<tr>
											<td><p>电话</p></td>
											<td contentEditable="true">${record.phone}</td>
											<td><p>工作邮箱</p></td>
											<td colspan="1" contentEditable="true">${record.email}</td>
											<td><p>个人邮箱</p></td>
											<td contentEditable="true">${record.qq}</td>
										</tr>
										<tr>
											<td><p>学历</p></td>
											<td name="education">${record.education}</td>
											<td><p>毕业院校</p></td>
											<td name="school">${record.school}</td>
											<td><p>专业</p></td>
											<td name="major">${record.major}</td>
										</tr>
										<tr>
											<td><p>职称</p></td>
											<td colspan="1" contentEditable="true">${record.majorName}</td>
											<td><p>政治面貌</p></td>
											<td colspan="1"><select name="politicsStatus"
												style="font-size: small; height: 100%; border: none; width: 100%; text-align: center;">
												 <c:choose>
                                                        	<c:when test="${not empty record.politicsStatus }">
                                                        		<custom:dictSelect type="政治面貌"
                                                                                    selectedValue="${record.politicsStatus}"/>
                                                        	</c:when>
                                                        	<c:otherwise>
                                                        		<option value="0"></option>
                                                        		<custom:dictSelect type="政治面貌"
                                                                                    selectedValue=""/>
                                                        	</c:otherwise>
                                                        </c:choose>
												</select></td>
											<td style="width: 10%"><p>性别</p></td>
											<td colspan="1"><span id="sexName"></span> <input
												id="sex" value="${record.sex}" hidden></td>
										</tr>
										<tr>
											<td><p>出生日期</p></td>
											<td colspan="1" id="birthday"><fmt:formatDate
													value="${record.birthday}" pattern="yyyy-MM-dd" /></td>
											<td><p>身份证号码</p></td>
											<td colspan="1" contentEditable="true" id="idcard">${record.idcard}</td>
											<td><p>身份证地址</p></td>
											<td colspan="2" contentEditable="true">${record.idcardAddress}</td>
										</tr>
										<tr>
											<td><p>籍贯</p></td>
											<td colspan="1" contentEditable="true">${record.householdAddress }</td>
											<td><p>户口性质</p></td>
											<td><select name="householdState"
												style="font-size: small; height: 100%; border: none; width: 100%">
												<c:choose>
                                                            <c:when test="${ not empty record.householdState }">
                                                       					 <custom:dictSelect type="档案户口性质"
                                                                        selectedValue="${record.householdState}"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <option value=""></option>
                                                            <custom:dictSelect type="档案户口性质"
                                                                        selectedValue=""/>
                                                            </c:otherwise>    
                                              </c:choose> 
											</select>
											</td>
											<td><p>通信地址</p></td>
											<td colspan="6" contentEditable="true">${record.home}</td>
										</tr>
										<tr>
											<td><p>民族</p></td>
											<td contentEditable="true">${record.nation}</td>
											<td><p>工资卡号</p></td>
											<td contentEditable="true">${record.bankCard }</td>
											<td><p>开户银行</p></td>
											<td colspan="6" contentEditable="true">${record.bank}</td>
										</tr>
										<tr>
											<td><p>在职状态</p></td>
											<td><select name="entrystatus"
												style="font-size: small; height: 100%; border: none; width: 100%">
													<custom:dictSelect type="员工在职状态"
														selectedValue="${record.entrystatus}" /></td>
											<td><p>入职日期</p></td>
											<td name="entryTime"><fmt:formatDate value="${record.entryTime}"
													pattern="yyyy-MM-dd" /></td>
											<td><p>离职日期</p></td>
											<td colspan="2" contentEditable="true"><input
												id="leaveTime" name="leaveTime" class="leaveTime"
												type="text" readonly
												value="<fmt:formatDate value="${record.leaveTime}" pattern="yyyy-MM-dd" />">
											</td>
										</tr>
										<tr>
											<td><p>紧急联络人</p></td>
											<td contentEditable="true">${record.emergencyPerson}</td>
											<td><p>紧急联络人电话</p></td>
											<td contentEditable="true">${record.emergencyPhone}</td>
											<td><p>联络人关系</p></td>
											<td colspan="6" contentEditable="true">${record.emergencyRelation}</td>
										</tr>
										<c:if test="${sessionScope.user.id eq 2 }">
									<thead name="tableSale">
										<tr>
											<th colspan="10"
												style="text-align: center; border: solid #999 1px; font-size: 1em;">
												薪酬调整记录</th>
										</tr>
									</thead>
									<tbody name="tableSale">
										<td colspan="22">
											<div class="panel-collapse collapse in" id="salaryRecord">
												<div>
													<table style="width: 100%;" id="tbSal">
														<thead>
															<tr class="pay">
																<td class="td_weight" style="border-left-style: hidden;">调薪日期
																</td>
																<td class="td_weight">基本工资</td>
																<td class="td_weight">绩效工资</td>
																<td class="td_weight">工龄工资</td>
																<td class="td_weight">午餐补贴</td>
																<td class="td_weight">电脑补贴</td>
																<td class="td_weight">公积金</td>
																<td class="td_weight">合计</td>
																<td class="td_weight">调薪原因</td>
															</tr>
														</thead>
														<c:choose>
															<c:when test="${not empty record.payAdjustments }">

																<c:forEach items="${record.payAdjustments }"
																	var="payAdjustment">
																	<tr name="salary" class="level1">
																		<input type="hidden" name="flag" value="salaryRecord">
																		<input type="hidden" name="payAdjustmentId"
																			value="${payAdjustment.id }">
																		<input type="hidden" id="recordId" name="recordId"
																			value="${record.id}">
																		<td style="width: 6.8%; border-left-style: hidden;">
																			<input type="text" name="changeDate"
																			class="changeDate" readonly
																			value="<fmt:formatDate value="${payAdjustment.changeDate}" pattern="yyyy-MM-dd" />">
																		</td>
																		<td name="basePay" style="width: 6%;"
																			contentEditable="true">${payAdjustment.basePay}</td>
																		<td name="meritPay" style="width: 6%;"
																			contentEditable="true">${payAdjustment.meritPay}</td>
																		<td name="agePay" style="width: 6%;"
																			contentEditable="true">${payAdjustment.agePay}</td>
																		<td name="lunchSubsidy" style="width: 6%;"
																			contentEditable="true">${payAdjustment.lunchSubsidy }</td>
																		<td name="computerSubsidy" style="width: 5%;"
																			contentEditable="true">${payAdjustment.computerSubsidy }</td>
																		<td name="accumulationFund" style="width: 5%;"
																			contentEditable="true">${payAdjustment.accumulationFund }</td>
																		<td style="width: 5%; height: auto;">
																			<div style="display: flex">
																				<span name="total">${payAdjustment.total }</span>
																			</div>
																		</td>
																		<td style="width: 18%;" contentEditable="true">${payAdjustment.payReason }</td>
																	</tr>
																</c:forEach>
															</c:when>
															<c:otherwise>
																<tr name="salary" class="level1">
																	<td style="width: 6.8%; border-left-style: hidden;">
																		<input type="text" name="changeDate"
																		class="changeDate" readonly
																		value="">
																	</td>
																	<td name="basePay" style="width: 6%;"
																		contentEditable="true"></td>
																	<td name="meritPay" style="width: 6%;"
																		contentEditable="true"></td>
																	<td name="agePay" style="width: 6%;"
																		contentEditable="true"></td>
																	<td name="lunchSubsidy" style="width: 6%;"
																		contentEditable="true"></td>
																	<td name="computerSubsidy" style="width: 5%;"
																		contentEditable="true"></td>
																	<td name="accumulationFund" style="width: 5%;"
																		contentEditable="true"></td>
																	<td style="width: 5%; height: auto;">
																		<div style="display: flex">
																			<span name="total"></span>
																		</div>
																	</td>
																	<td style="width: 18%;" contentEditable="true"></td>
																</tr>
															</c:otherwise>
														</c:choose>
														</tbody>
													</table>
												</div>
											</div>
										</td>
									</tbody>
									</c:if>
 									<thead name="tableStation">
									<tr>
										<th colspan="10" class="station"
											style="text-align: center; border: solid #999 1px; font-size: 1em;">
											<%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
											岗位任免记录
										</th>
									</tr>
									</thead>
									<tbody name="tableStation">
										<td colspan="22">
											<div class="panel-collapse collapse in" id="stationRecord">
												<div>
													<table style="width: 100%;" id="tbStation">
														<thead>
															<tr>
																<td class="td_weight" style="border-left-style: hidden;">调岗日期</td>
																<td class="td_weight">公司</td>
																<td class="td_weight">部门</td>
																<td class="td_weight">项目组</td>
																<td class="td_weight">岗位</td>
																<td class="td_weight">任免</td>
																<td class="td_weight">调岗原因</td>
															</tr>
														</thead>
														<tbody>
														
										<c:choose>
										<c:when test="${not empty record.postAppointments }">
										<c:forEach items="${record.postAppointments }" var="postAppointment">
                                            <tr name="station"  class="level1">
                                             <input type="hidden"  name="flag" value="stationRecord">
                                            <input type="hidden" name="postAppointmentId" value="${postAppointment.id }">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="postDate" class="postDate" value="<fmt:formatDate value="${postAppointment.postDate}" pattern="yyyy-MM-dd" />" readonly>
                                                </td>
                                                <td style="width: 12%;">
                                                	<select name="postAppointmentCompany"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue="${postAppointment.company }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 6%; ">
                                                    <select name="postAppointmentDept"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="部门"
                                                                           selectedValue="${postAppointment.dept }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 6%;">
                                                    <select name="postAppointmentProjectTeam"
                                                            style="width:100%;">
                                                       <c:choose>
                                                            <c:when test="${ not empty postAppointment.projectTeam }">
                                                       					 <custom:dictSelect type="项目组"
                                                                           selectedValue="${postAppointment.projectTeam }"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <option value=""></option>
                                                           <custom:dictSelect type="项目组"
                                                                           selectedValue=""/>
                                                            </c:otherwise>    
                                                            </c:choose>   
                                                    </select>
                                                </td>
                                                <td style="width: 10%;">
                                                    <select name="station"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="岗位"
                                                                           selectedValue="${postAppointment.station }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <select name="appoint"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="任免"
                                                                           selectedValue="${postAppointment.appoint }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 18%;" contentEditable="true">${postAppointment.postReason }</td>
                                            </tr>
                                            </c:forEach>
										</c:when>
										<c:otherwise>
												<tr name="station"  class="level1">
											 <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="postDate" class="postDate" value="" readonly>
                                              </td>
                                              <td style="width: 12%;">
                                                	<select name="postAppointmentCompany"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="存续公司"
                                                                           />
                                                    </select>
                                                </td>   	
											 <td style="width: 6%; ">
                                                    <select name="postAppointmentDept"
                                                            style="width:100%;">
                                                            <option value=""></option>
                                                        <custom:dictSelect type="部门"/>
                                                    </select>
                                                </td>	
											<td style="width: 6%;">
                                                    <select name="postAppointmentProjectTeam"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="项目组"
                                                                           />
                                                    </select>
                                             </td>
                                             <td style="width: 10%;">
                                                    <select name="station"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="岗位"
                                                                           />
                                                    </select>
                                            </td>	
											<td style="width: 5%;height:auto;">
                                                    <select name="appoint"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="任免"
                                                                           />
                                                    </select>
                                                </td>
                                                <td style="width: 18%;" contentEditable="true"></td>
															</tr>
										</c:otherwise>
									</c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                               <thead  name="tableSing">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        劳动合同签约记录
                                    </th>
                                </tr>
                                </thead>
                                <tbody name="tableSing">
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="signRecord">
                                        <div>
                                            <table style="width:100%;" id="tbSign">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="border-left-style:hidden;">签订日期</td>
                                                    <td class="td_weight">公司</td>
                                                    <td class="td_weight">起始日期</td>
                                                    <td class="td_weight">结束日期</td>
                                                    <td class="td_weight">合同性质</td>
                                                    <td class="td_weight">签约说明</td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                	<c:when test="${not empty record.arbeitsvertrags }">
                                                		  <c:forEach items="${record.arbeitsvertrags }" var="arbeitsvertrag">
                                                        <tr name="sign" class="level1">
                                                        <input type="hidden"  name="flag" value="signRecord">
                                                            <input type="hidden" name="arbeitsvertragId"
                                                                   value="${arbeitsvertrag.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="signDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                  <input type="text" name="signDate" class="signDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.signDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="company" style="width: 12%;">
                                                                <select name="arbeitsvertragCompany"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue="${arbeitsvertrag.company }"/>
                                                    </select>
                                                            </td>
                                                            <td name="beginDate" style="width: 12%;">
                                                                 <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.beginDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="endDate" style="width: 10%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.endDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="barginType" style="width: 5%;height:auto;">
                                                               <select name="barginType"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="合同性质"
                                                                           selectedValue="${arbeitsvertrag.barginType }"/>
                                                    </select>
                                                            </td>
                                                            <td name="signReason"
                                                                style="width: 18%;" contentEditable="true">${arbeitsvertrag.signReason }</td>
                                                        </tr>
                                                    </c:forEach>
                                                	</c:when>
                                                	<c:otherwise>
                                                	 <tr name="sign" class="level1">
                                                            
                                                            <td name="signDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                  <input type="text" name="signDate" class="signDate" readonly value="">
                                                            </td>
                                                            <td name="company" style="width: 12%;">
                                                                <select name="arbeitsvertragCompany"
                                                            style="width:100%;">
                                                            <option value=""></option>
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue=""/>
                                                    </select>
                                                            </td>
                                                            <td name="beginDate" style="width: 12%;">
                                                                 <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                            </td>
                                                            <td name="endDate" style="width: 10%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="">
                                                            </td>
                                                            <td name="barginType" style="width: 5%;height:auto;">
                                                               <select name="barginType"
                                                            style="width:100%;">
                                                            <option value=""></option>
                                                        <custom:dictSelect type="合同性质"
                                                                           selectedValue=""/>
                                                    </select>
                                                            </td>
                                                            <td name="signReason"
                                                                style="width: 18%;" contentEditable="true"></td>
                                                        </tr>
                                                	</c:otherwise>
                                                </c:choose>
                                                  

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                              
                                <thead name="tableOld">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        以往工作记录
                                    </th>
                                </tr>
                                </thead>
                                <tbody name="tableOld">
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="oldworkRecord">
                                        <div>
                                            <table style="width:100%;" id="tbOld">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="border-left-style:hidden;">起始日期</td>
                                                    <td class="td_weight">结束日期</td>
                                                    <td class="td_weight">公司</td>
                                                    <td class="td_weight">岗位</td>
                                                    <td class="td_weight">职责</td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                	<c:when test="${not empty record.jobRecords }">
                                                		<c:forEach items="${record.jobRecords }" var="jobRecord">
                                                        <tr name="oldwork"  class="level1">
                                                         <input type="hidden"  name="flag" value="oldworkRecord">
                                                            <input type="hidden" name="jobRecordId"
                                                                   value="${jobRecord.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                 <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${jobRecord.beginDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${jobRecord.endDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="company"
                                                                style="width: 27.2%;" contentEditable="true">${jobRecord.company }</td>
                                                            <td name="station"
                                                                style="width: 5%;height:auto;" contentEditable="true">${jobRecord.station }</td>
                                                            <td name="duty" style="width: 18%;" contentEditable="true">${jobRecord.duty }</td>
                                                        </tr>
                                                    </c:forEach>
                                                	</c:when>
                                                	<c:otherwise>
                                                		 <tr name="oldwork"  class="level1">
                                                         <input type="hidden"  name="flag" value="oldworkRecord">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                 <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="">
                                                            </td>
                                                            <td name="company"
                                                                style="width: 27.2%;" contentEditable="true"></td>
                                                            <td name="station"
                                                                style="width: 5%;height:auto;" contentEditable="true"></td>
                                                            <td name="duty" style="width: 18%;" contentEditable="true"></td>
                                                        </tr>
                                                	</c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                
                                <thead name="tableEducation">
                                <tr>
                                    <th colspan="10" class="education"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                        教育背景
                                    </th>
                                </tr>
                                </thead>
                                <tbody name="tableEducation">
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="educationRecord">
                                        <div>
                                            <table style="width:100%;" id="tbEducation">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="border-left-style:hidden;">起始日期</td>
                                                    <td class="td_weight">结束日期</td>
                                                    <td class="td_weight">学校</td>
                                                    <td class="td_weight">院系</td>
                                                    <td class="td_weight">专业</td>
                                                    <td class="td_weight">学历</td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                	<c:when test="${not empty record.educations }">
                                                		<c:forEach items="${record.educations}" var="education">
                                                        <tr name="education" class="level1">
                                                         <input type="hidden"  name="flag" value="educationRecord">
                                                            <input type="hidden" name="educationId"
                                                                   value="${education.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${education.beginDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${education.endDate}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="school"
                                                                style="width: 12.2%;" contentEditable="true">${education.school }</td>
                                                            <td name="department"
                                                                style="width: 20%;height:auto;" contentEditable="true">${education.department }</td>
                                                            <td name="major"
                                                                style="width: 9%;height:auto;" contentEditable="true">${education.major }</td>
                                                            <td name="education" style="width: 9%;height:auto;">
                                                                <select name="educationEducation"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="学历"
                                                                           selectedValue="${education.education}"/>
                                                    </select>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                	</c:when>
                                                	<c:otherwise>
                                                		<tr name="education" class="level1">
                                                         <input type="hidden"  name="flag" value="educationRecord">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <input type="text" name="endDate" class="endDate" readonly value="">
                                                            </td>
                                                            <td name="school"
                                                                style="width: 12.2%;" contentEditable="true"></td>
                                                            <td name="department"
                                                                style="width: 20%;height:auto;" contentEditable="true"></td>
                                                            <td name="major"
                                                                style="width: 9%;height:auto;" contentEditable="true"></td>
                                                            <td name="education" style="width: 9%;height:auto;">
                                                                <select name="educationEducation"
                                                            style="width:100%;">
                                                            <option value=""></option>
                                                        <custom:dictSelect type="学历"
                                                                           selectedValue="${education.education}"/>
                                                    </select>
                                                            </td>
                                                        </tr>
                                                	</c:otherwise>
                                                </c:choose>
                                                    

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                              
                              <thead name="tableHonor">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        证书/荣誉
                                    </th>
                                </tr>
                                </thead>
                                <tbody name="tableHonor">
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="honorRecord">
                                        <div>
                                            <table style="width:100%;" id="tbHonor">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="width: 8%;">日期</td>
                                                	<td class="td_weight" style="width: 17%;">颁发单位</td>
                                                	<td class="td_weight" style="width:17%;">证书/荣誉名称</td>
                                                	<td class="td_weight" style="width: 9%;">有效期</td>
                                                	<td class="td_weight" style="width: 23%;">证书扫描件</td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                		<c:when test="${not empty record.certificates }">
                                                			<c:forEach items="${record.certificates }" var="certificate">
                                                        <tr name="honor"  class="clHonor level1">
                                                        <input type="hidden"  name="flag" value="honorRecord">
                                                            <input type="hidden" name="certificateId"
                                                                   value="${certificate.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <input type="hidden" id="hiddenPath" name="hiddenPath"
                                                                   value="${certificate.scannings}">
                                                            <input type="hidden" id="hiddenName" name="hiddenName"
                                                                   value="${certificate.scanningName}">
                                                            <td name="date" style="width: 13.6%;">
                                                                 <input type="text" class="date" name="date" value="<fmt:formatDate value="${certificate.date}" pattern="yyyy-MM-dd" />">
                                                            </td>
                                                            <td name="issuingUnit"
                                                                style="width: 12.2%;" contentEditable="true">${certificate.issuingUnit }</td>
                                                            <td name="honor"
                                                                style="width: 20%;height:auto;" contentEditable="true">${certificate.honor }</td>
                                                            <td name="validity" style="width: 9%;height:auto;">
                                                            	 <input type="text" class="validity" name="validity" value="<fmt:formatDate value="${certificate.validity}" pattern="yyyy-MM-dd" />">   
                                                            </td>
                                                             <td  >
                                                   				 <input type="file"  name="scanFile" style="display:none;">
                                                   					 <a href="javascript:void(0);" onclick="downloadAttach(this)" style="width:auto; display: inline-block;" value="${certificate.scannings}" target='_blank'>
																		<input type="text"   name="scanName" value="${certificate.scanningName}" style="width:auto" readonly>
																	 </a>
													 				<input type="button" id="BuSelect" name="BuSelect" value="点击上传扫描件" onclick="selectScan(this)" style="border:none;" href="javascript:;"> 
                                               				 </td>
                                                        </tr>
                                                    </c:forEach>
                                                		</c:when>
                                                		<c:otherwise>
                                                				<tr name="honor"  class="clHonor level1">
                                                        <input type="hidden"  name="flag" value="honorRecord">
                                                            <td name="date" style="width: 13.6%;">
                                                                 <input type="text" class="date" name="date" value="">
                                                            </td>
                                                            <td name="issuingUnit"
                                                                style="width: 12.2%;" contentEditable="true"></td>
                                                            <td name="honor"
                                                                style="width: 20%;height:auto;" contentEditable="true"></td>
                                                            <td name="validity" style="width: 9%;height:auto;">
                                                            	 <input type="text" class="validity" name="validity" value="">   
                                                            </td>
                                                             <td  >
                                                   				 <input type="file"  name="scanFile" style="display:none;">
                                                   					 <a href="javascript:void(0);" onclick="downloadAttach(this)" style="width:auto; display: inline-block;" value="" target='_blank'>
																		<input type="text"   name="scanName" value="" style="width:auto" readonly>
																	 </a>
													 				<input type="button" id="BuSelect" name="BuSelect" value="点击上传扫描件" onclick="selectScan(this)" style="border:none;" href="javascript:;"> 
                                               				 </td>
                                                        </tr>
                                                		</c:otherwise>
                                                </c:choose>
                                                    

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </div>
            </section>
        </section>
    </div>


</shiro:hasPermission>

<script>
    var sexid = ${record.sex};
    var hasDecryptPermission = false;
    <shiro:hasPermission name="fin:travelreimburse:decrypt">
    hasDecryptPermission = true;
    </shiro:hasPermission>
</script>
<%@ include file="../../common/footer.jsp" %>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript">
    base = "<%=base%>";
</script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/common/js/page.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/common/js/autosize.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/jQueryUI/jquery-ui-1.12.1/jquery-ui.min.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/common/js/formUtils.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
																					<script type="text/javascript"
																						src="<%=base%>/views/manage/ad/record/js/pdf.js"></script>
</body>
</html>