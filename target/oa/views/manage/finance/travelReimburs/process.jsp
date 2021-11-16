<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp" %>
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css">
    <style>
        #table1, #table2, .tab {
            table-collapse: collapse;
            border: none;
            margin: 5px 20px;
            width: 97%;
        }

        #table1 td:not(.select2), #table2 td, .tab td {
            border: solid #999 1px;
            /* padding: 5px; */
            text-align: center;
        }

        #table1 td input[type="text"], #table2 input[type="text"], .tab td input[type="text"] {
            width: 100%;
            height: 100%;
            border: none;
            outline: medium;
        }

        #table1 td input[name="startPoint"], input[name="destination"], input[name="place"], input[name="dayRoom"] {
            width: 100%;
            height: 100%;
            border: none;
            outline: medium;
            text-align: center;
        }

        #table1 td input[name="actReimburse"], input[name="cost"] {
            width: 100%;
            height: 100%;
            border: none;
            outline: medium;
            padding-right: 5px;
        }

        #table1 td input[name="name"], input[name="date"], input[name="beginDate"], input[name="endDate"], input[name="applyTime"], input[name="conveyanceText"], input[name="payee"], input[name="bankAddress"] {
            text-align: center;
        }

        #table1 td span:not(.select2 span), #table2 td span, .tab td span {
            padding: 0px 6px;
            text-align: center;
        }

        #table1 th, #table2 th, .tab th {
            border: solid #999 1px;
            text-align: center;
            font-size: 1.5em;
        }

        textarea {
            resize: none;
            border: none;
            outline: medium;
            width: 100%;
        }

        textarea[name="projectName"], textarea[name="reason"], textarea[name="detail"] {
            height: 100%;
            padding-top: 10px;
            text-align: left;
            min-height: 70px !important;
        }

        select {
            appearance: none;
            -moz-appearance: none;
            -webkit-appearance: none;
            border: none;
            text-align-last: center;
        }

        hr {
            margin-top: 0px;
            margin-bottom: 0px;
            border-top-color: #999999;
            display: none;
        }

        /* IE10以上生效 */
        select::-ms-expand {
            display: none;
        }

        .datetimepick {
            text-align: center;
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

        .end {
            width: 100%;
        }

        .label_title {
            display: block;
            border-bottom: 1px solid white;
            padding: 0.5em;
        }

        /* .select2-selection__clear{
            display:none;
        } */

        .label_item {
            display: block;
            border-bottom: 1px solid white;
            text-align: left;
        }
        ul.dropdown-menu{max-height: 200px!important;}
		button.dropdown-toggle{width:130px!important;}
    </style>
</head>
<body style="min-width:1110px; overflow:auto;font-size:small;">
<div class="wrapper">
    <header>
        <ol class="breadcrumb">
            <li class="active">主页</li>
            <li class="active">财务管理</li>
            <li class="active">报销</li>
            <li class="active">出差报销</li>
            <li class="active">报销处理</li>
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
                        <input type="hidden" id="id" value="${map.business.id }">
                        <input type="hidden" id="deptId" name="deptId" value="${map.business.deptId }">
                        <input type="hidden" id="userId" name="userId" value="${map.business.userId }">
                        <input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
                        <input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
                        <input type="hidden" id="travelId" name="travelId" value="${map.business.travelId }">
                        <input type="hidden" id="travelProcessInstanceIds" value="">
                        <input type="hidden" id="total" name="total" value="${map.business.total }" readonly>
                        <input type="hidden" id="totalcn" readonly>
                        <input type="hidden" id="isSend" name="isSend" value="${map.business.isSend }">
                        <input type="hidden" id="initMoney" name="initMoney" value="${map.business.initMoney }">
                        <input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
                        <input type="hidden" id="encrypted" name="encrypted" value="${map.business.encrypted }">
                        <input type="hidden" id="processInstanceId" name="" value="${map.business.processInstanceId}">
                        <input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
                        <input type="hidden" id="operStatus" value="">
                        <input type="hidden" id="assistantStatus" name="assistantStatus" value="${map.business.assistantStatus}">
                      	<input type="hidden" id="createDateStr" name="createDateStr" value="${map.business.createDateStr}">
                      	<input type="hidden" id="isOk" name="isOk" value="${map.business.isOk}">
                        <c:choose>
	                        <c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
	                        	<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
	                        </c:when>
	                        <c:otherwise>
	                        	<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
	                        </c:otherwise>
	                    </c:choose>

                        <div style="text-align: center;font-weight: bolder;font-size: large;">
                            <thead>
	                            <tr>
	                                <th colspan="34">差旅报销单</th>
	                                <span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(报销单号：${map.business.orderNo })</span>
	                            </tr>
	                            <i class="icon-question-sign" style="cursor:pointer" onclick="showhelp()"> </i>
	                            <shiro:hasPermission name="fin:travelreimburse:encrypt">
	                                <c:if test="${map.business.encrypted ne 'y' }">
	                                    <i class="icon-eye-close" style="cursor:pointer" onclick="lock()"> </i>
	                                </c:if>
	                            </shiro:hasPermission>
                            </thead>
                        </div>
                        <table id="table1">
                            <%-- 可以提交的部分 --%>
                            <c:choose>
	                            <c:when test="${ ((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
									((map.task.name eq '经办' or map.task.name eq '提交申请' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) or (sessionScope.user.id == 2 or sessionScope.user.id  == 3 )}">
		                            <tbody>
			                            <select id="conveyance_hidden" style="display:none;">
			                                <custom:dictSelect type="出差报销交通工具"/>
			                            </select>
			                            <select id="conveyance1_hidden" style="display: none">
			                                <custom:dictSelect type="市内交通费交通工具"/>
			                            </select>

			                            <!-- 报销人相关 -->
			                            <tr>
			                                <td class="td_weight"><span>出差人员</span></td>
			                                <td><input type="text" id="name" name="name" value="${map.business.name }"></td>
			                                <td class="td_weight"><span>报销单位</span></td>
			                                <td style="line-height:20px;text-align:left;">
			                                    <select name="title">
			                                    	<custom:dictSelect type="流程所属公司"  selectedValue="${map.business.title }"/>
			                                    </select>
	                                    		<c:choose>
	                                        		<c:when test="${empty(map.business.dept.alias)}">
			                                            <input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;"
			                                                   id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
			                                        </c:when>
			                                        <c:otherwise>
			                                            <input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;"
			                                                   id="deptName" name="deptName" onclick="openDept()" value="" readonly>
			                                        </c:otherwise>
	                                    		</c:choose>
	                                		</td>
			                                <td class="td_weight"><span>提交日期</span></td>
			                                <td>
			                                    <input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>"
			                                           style="color:gray;" readonly>
			                                </td>
		                                    <%--<shiro:hasPermission name="fin:reimburse:seeall">--%>
		                                    <%--<td class="td_weight"><span>费用归属</span></td>--%>
		                                    <%--<td style="width:100px;">--%>
		                                    <%--<select  type="text" style="width: 100%;" name="investId" value="${map.business.investId }"></select>--%>
		                                    <%--</td>--%>
		                                    <%--</shiro:hasPermission>--%>
	                            		</tr>
			                            <tr>
			                                <!-- 领款人相关 -->
			                                <td class="td_weight"><span>领款人</span></td>
			                                <td style="width:5%;"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
			                                <td class="td_weight"><span>银行卡号</span></td>
			                                <td><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
			                                <td class="td_weight"><span>开户行名称</span></td>
			                                <td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
			                            </tr>

			                            <!-- 城际交通费 -->
			                            <tr>
			                            	<td colspan="22">
			                                    <div style="text-align:left;" class="tittle">
			                                        <a href="#intercityCost" data-toggle="collapse">城际交通费</a>
			                                        <div id="myTabContent" class="tab-content">
			                                            <div class="panel-collapse collapse in" id="intercityCost">
			                                                <table style="width:100%;">
			                                                    <thead>
				                                                    <tr>
				                                                        <td class="td_weight" style="width: 10%; border-left-style:hidden;">日期</td>
				                                                        <td class="td_weight" style="width: 5.5%;">出发地</td>
				                                                        <td class="td_weight" style="width: 5.5%;">目的地</td>
				                                                        <td class="td_weight" style="width: 5.5%;">交通工具</td>
				                                                        <td class="td_weight" style="width: 13%;">项目</td>
				                                                        <td class="td_weight" style="width: 5.5%;">费用</td>
				                                                        <td class="td_weight" style="width: 5.5%;">实报</td>
				                                                        <td class="td_weight" style="width: 18%;">事由</td>
				                                                        <td class="td_weight" style="width: 26.2%; border-right:none;">明细</td>
				                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
				                                                            <td class="td_weight" style="width: 4%; border-right-style:hidden;">操作</td>
				                                                        </c:if>
				                                                    </tr>
                                                    			</thead>
	                                                    	    <tbody>
		                                                    		<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
		                                                        	    <c:if test="${travelreimburseAttach.type eq '0' }">
		                                                                	<tr name="node" id="node">
		                                                                		<input type="hidden" name="id" value="${travelreimburseAttach.id }">
				                                                                <td style="border-left-style:hidden;">
				                                                                    <input type="text" name="date" class="datetimepick"
				                                                                           value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
				                                                                </td>
				                                                                <td>
				                                                                    <input type="text" name="startPoint" value="${travelreimburseAttach.startPoint }">
				                                                                </td>
				                                                                <td>
				                                                                    <input type="text" name="destination" value="${travelreimburseAttach.destination }">
				                                                                </td>
				                                                                <td>
				                                                                    <select name="conveyance" style="width:100%; test-align-last:center">
				                                                                        <custom:dictSelect type="出差报销交通工具" selectedValue="${travelreimburseAttach.conveyance }"/>
				                                                                    </select>
				                                                                </td>
                                                                                <td>
                                                                                    <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
                                                                                    <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
                                                                                </td>
				                                                                <td>
				                                                                    <input type="text" name="cost" style="text-align:right"
				                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
				                                                                </td>
				                                                                <td>
				                                                                    <input type="text" name="actReimburse" style="text-align:right"
				                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
				                                                                </td>
				                                                                <td>
				                                                                    <textarea type="text" name="reason"
				                                                                              autocomplete="off">${travelreimburseAttach.reason }</textarea>
				                                                                </td>
				                                                                <td style="">
				                                                                	<textarea name="detail">${travelreimburseAttach.detail }</textarea>
				                                                                </td>
				                                                                <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
				                                                                    <td></td>
				                                                                </c:if>
				                                                            </tr>
				                                                        </c:if>
				                                                    </c:forEach>
			                                                    </tbody>
			                                                </table>
			                                            </div>
			                                        </div>
			                                    </div>
	                                    	<hr>
		                                    <!-- 住宿费 -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#stayCost" data-toggle="collapse" data-parent="#intercityCost">住宿费</a>
		                                        <div class="panel-collapse collapse in" id="stayCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%; border-left-style:hidden;">日期</td>
			                                                    <td class="td_weight" style="width: 4.8%;">地点</td>
			                                                    <td class="td_weight" style="width: 12%;">项目</td>
			                                                    <td class="td_weight" style="width: 5%;">天*房</td>
			                                                    <td class="td_weight" style="width: 5%;">费用</td>
			                                                    <td class="td_weight" style="width: 4.8%;">实报</td>
			                                                    <td class="td_weight" style="width: 15%;">事由</td>
			                                                    <td class="td_weight" style="width: 21%;  border-right:none; ">明细</td>
			                                                    <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;border-right: hidden">费用归属
			                                                        </td>
			                                                    </c:if>
			                                                    <!--   <td class="td_weight" style="width: 11%;">备注</td> -->
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 3.3%; border-right-style:hidden;">操作</td>
			                                                    </c:if>
			                                                </tr>
			                                            </thead>
		                                                <tbody>
			                                                <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
			                                                    <c:if test="${travelreimburseAttach.type eq '1' }">
			                                                        <tr name="node" id="node">
			                                                            <input type="hidden" name="id" value="${travelreimburseAttach.id }">
			                                                            <td style="border-left-style:hidden;">
			                                                                <input type="text" name="date" class="datetimepick"
			                                                                       value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
			                                                                       readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="place" value="${travelreimburseAttach.place }">
			                                                            </td>
			                                                            <td>
			                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
			                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="dayRoom"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="cost" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="actReimburse" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="reason" autocomplete="off">${travelreimburseAttach.reason }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                            </td>
			                                                            <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                       <%--  <select style="width: 100%;" name="attachInvestId" value="${travelreimburseAttach.attachInvestId}"></select> --%>
			                                                                       <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            </c:if>
			
			                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly ></td>
		                                                        <td><input type="text" name="costTotal" readonly></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                            <td colspan="2"><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 市内交通费 -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#cityCost" data-toggle="collapse">市内交通费</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">日期</td>
			                                                    <td class="td_weight" style="width: 6%;">地点</td>
			                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">交通工具</td>
			                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
			                                                    <td class="td_weight" style="width: 7%;">费用</td>
			                                                    <td class="td_weight" style="width: 7%;">实报</td>
			                                                    <td class="td_weight" style="width: 22%;">事由</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
			                                                    <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler}">
			                                                        <td class="td_weight" style="width: 5.6%;border-right: hidden">费用归属 </td>
			                                                    </c:if>
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%; border-right-style:hidden;">操作</td>
			                                                    </c:if>
			                                                </tr>
		                                                </thead>
		                                                <tbody>
			                                                <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
			                                                    <c:if test="${travelreimburseAttach.type eq '2' }">
			                                                        <tr name="node" id="node">
			                                                            <input type="hidden" name="id" value="${travelreimburseAttach.id }">
			                                                            <td style="border-left-style:hidden;">
			                                                                <input type="text" name="date" class="datetimepick"
			                                                                       value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
			                                                                       readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="place" value="${travelreimburseAttach.place }">
			                                                            </td>
			                                                            <c:if test="${not empty travelreimburseAttach.conveyance}">
			                                                                <td>
			                                                                    <select name="conveyance" style="width:100%;test-align-last:center">
			                                                                        <custom:dictSelect type="市内交通费交通工具"
			                                                                                           selectedValue="${travelreimburseAttach.conveyance }"/>
			                                                                    </select>
			                                                                </td>
			                                                            </c:if>
			                                                            <td>
			                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
			                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="cost" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="actReimburse" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="reason">${travelreimburseAttach.reason }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                            </td>
			                                                            <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                        <%-- <select style="width: 100%;" name="attachInvestId"
			                                                                                value="${travelreimburseAttach.attachInvestId}"></select> --%>
			                                                                                <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            </c:if>
			                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" name="costTotal" readonly ></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                            <td colspan="2"><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 接待餐费-->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#receiveCost" data-toggle="collapse">接待费用</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight"
		                                                        style="width: 8%; border-left-style:hidden;">日期
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">地点</td>
		                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
		                                                    <td class="td_weight" style="width: 7%;">费用</td>
		                                                    <td class="td_weight" style="width: 7%;">实报</td>
		                                                    <td class="td_weight" style="width: 22%;">事由</td>
		                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
		                                                    <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%; border-left-style:hidden;">费用归属
		                                                        </td>
		                                                    </c:if>
		                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                        <td class="td_weight"
		                                                            style="width: 4%;border-right-style:hidden;">操作
		                                                        </td>
		                                                    </c:if>
		                                                </tr>
		                                                </thead>
		                                                <tbody>
		                                                <c:forEach items="${map.business.travelreimburseAttachList }"
		                                                           var="travelreimburseAttach">
		                                                    <c:if test="${travelreimburseAttach.type eq '3' }">
		                                                        <tr name="node" id="receive">
		                                                            <input type="hidden" name="id"
		                                                                   value="${travelreimburseAttach.id }">
		                                                            <td style="border-left-style:hidden;">
		                                                                <input type="text" name="date" class="datetimepick"
		                                                                       value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
		                                                                       readonly>
		                                                            </td>
		                                                            <td>
		                                                                <input type="text" name="place"
		                                                                       value="${travelreimburseAttach.place }">
		                                                            </td>
		                                                            <td>
		                                                                <input type="hidden" name="projectId"
		                                                                       value="${travelreimburseAttach.projectId }">
		                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
		                                                            </td>
		                                                            <td>
		                                                                <input type="text" name="cost" style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
		                                                            </td>
		                                                            <td>
		                                                                <input type="text" name="actReimburse"
		                                                                       style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
		                                                            </td>
		                                                            <td>
		                                                                <textarea name="reason"
		                                                                          onfocus="reasonChange(this, 'receiveCost')">${travelreimburseAttach.reason }</textarea>
		                                                            </td>
		                                                            <td>
		                                                                <textarea
		                                                                        name="detail">${travelreimburseAttach.detail }</textarea>
		                                                            </td>
		                                                            <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
		                                                                <shiro:hasPermission name="fin:reimburse:seeall">
		                                                                    <td style="width:100px;">
		                                                                      <%--   <select style="width: 100%;"
		                                                                                name="attachInvestId"
		                                                                                value="${travelreimburseAttach.attachInvestId}"></select> --%>
		                                                                                <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
		                                                                    </td>
		                                                                </shiro:hasPermission>
		                                                            </c:if>
		                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                                <td></td>
		                                                            </c:if>
		                                                        </tr>
		                                                    </c:if>
		                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" name="costTotal" readonly ></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                            <td><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
                                    <!-- 补贴 -->
                                    <div style="text-align:left;" class="tittle">
                                        <a href="#subsidy" data-toggle="collapse">补贴</a>
                                        <div class="panel-collapse collapse in" id="subsidy">
                                            <table style="width:100%;">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="width: 7.7%; border-left-style:hidden;">出发日期 </td>
                                                    <td class="td_weight" style="width: 7.1%;">离开日期</td>
                                                    <td class="td_weight" style="width: 7%;">餐费补贴</td>
                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">交通补贴</td>
                                                    <td class="td_weight" style="width: 14.7%;">项目</td>
                                                    <td class="td_weight" style="width: 22%;">事由</td>
                                                    <td class="td_weight" style="width: 26.4%;  border-right:none;"> 明细</td>
                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
                                                        <td class="td_weight"
                                                            style="width: 4%;border-right-style:hidden;">操作
                                                        </td>
                                                    </c:if>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach items="${map.business.travelreimburseAttachList }"
                                                           var="travelreimburseAttach">
                                                    <c:if test="${travelreimburseAttach.type eq '4' }">
                                                        <tr name="node" id="node">
                                                            <input type="hidden" name="id"
                                                                   value="${travelreimburseAttach.id }">
                                                            <input type="hidden" name="date"
                                                                   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />">
                                                            <input type="hidden" name="actReimburse"
                                                                   value="<fmt:formatNumber value="0" pattern="#.##" />">
                                                            <td style="border-left-style:hidden;">
                                                                <input type="text" name="beginDate" class="datetimepick"
                                                                       value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />"
                                                                       readonly>
                                                            </td>
                                                            <td>
                                                                <input type="text" name="endDate" class="datetimepick"
                                                                       value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />"
                                                                       readonly>
                                                            </td>
                                                            <td>
                                                                <input type="text" name="foodSubsidy"
                                                                       style="text-align:right"
                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
                                                            </td>

                                                            <c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
                                                                <td><input type="text" name="trafficSubsidy" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />"></td>
                                                            </c:if>
															<c:if test="${empty travelreimburseAttach.trafficSubsidy}">
                                                                <td><input type="text" name="trafficSubsidy" style="text-align:right" value="0"></td>
                                                            </c:if>
                                                            <td>
                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
                                                            </td>
                                                            <td>
                                                                <textarea
                                                                        name="reason">${travelreimburseAttach.reason }</textarea>
                                                            </td>
                                                            <td>
                                                                <textarea
                                                                        name="detail">${travelreimburseAttach.detail }</textarea>
                                                            </td>
                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
                                                                <td></td>
                                                            </c:if>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
										<hr>
										<!-- 业务费-->
										<div style="text-align:left;" class="tittle">
											<a href="#business" data-toggle="collapse">业务费用</a>
											<div class="panel-collapse collapse in" id="business">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight"
															style="width: 8%; border-left-style:hidden;">日期
														</td>
														<td class="td_weight" style="width: 6%;">地点</td>
														<td class="td_weight" style="width: 15.4%;">项目</td>
														<td class="td_weight" style="width: 7%;">费用</td>
														<td class="td_weight" style="width: 7%;">实报</td>
														<td class="td_weight" style="width: 22%;">事由</td>
														<td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
														<c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
															<td class="td_weight"
																style="width: 5.6%; border-left-style:hidden;">费用归属
															</td>
														</c:if>
														<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
															<td class="td_weight"
																style="width: 4%;border-right-style:hidden;">操作
															</td>
														</c:if>
													</tr>
													</thead>
													<tbody>
													<c:forEach items="${map.business.travelreimburseAttachList }"
															   var="travelreimburseAttach">
														<c:if test="${travelreimburseAttach.type eq '5' }">
															<tr name="node" id="receive">
																<input type="hidden" name="id"
																	   value="${travelreimburseAttach.id }">
																<td style="border-left-style:hidden;">
																	<input type="text" name="date" class="datetimepick"
																		   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																		   readonly>
																</td>
																<td>
																	<input type="text" name="place"
																		   value="${travelreimburseAttach.place }">
																</td>
																<td>
																	<input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</td>
																<td>
																	<input type="text" name="cost" style="text-align:right"
																		   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																</td>
																<td>
																	<input type="text" name="actReimburse"
																		   style="text-align:right"
																		   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" onchange="validationRed('business')">
																</td>
																<td>
																<textarea name="reason"
																		  onfocus="reasonChange(this, 'business')">${travelreimburseAttach.reason }</textarea>
																</td>
																<td>
																<textarea
																		name="detail">${travelreimburseAttach.detail }</textarea>
																</td>
																<c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																</c:if>
																<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																	<td></td>
																</c:if>
															</tr>
														</c:if>
													</c:forEach>
													</tbody>
												</table>
											</div>
										</div>
										<hr>
										<!-- 攻关费-->
										<div style="text-align:left;" class="tittle">
											<a href="#relationship" data-toggle="collapse">攻关费用</a>
											<div class="panel-collapse collapse in" id="relationship">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight"
															style="width: 8%; border-left-style:hidden;">日期
														</td>
														<td class="td_weight" style="width: 6%;">地点</td>
														<td class="td_weight" style="width: 15.4%;">项目</td>
														<td class="td_weight" style="width: 7%;">费用</td>
														<td class="td_weight" style="width: 7%;">实报</td>
														<td class="td_weight" style="width: 22%;">事由</td>
														<td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
														<c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
															<td class="td_weight"
																style="width: 5.6%; border-left-style:hidden;">费用归属
															</td>
														</c:if>
														<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
															<td class="td_weight"
																style="width: 4%;border-right-style:hidden;">操作
															</td>
														</c:if>
													</tr>
													</thead>
													<tbody>
													<c:forEach items="${map.business.travelreimburseAttachList }"
															   var="travelreimburseAttach">
														<c:if test="${travelreimburseAttach.type eq '6' }">
															<tr name="node" id="receive">
																<input type="hidden" name="id"
																	   value="${travelreimburseAttach.id }">
																<td style="border-left-style:hidden;">
																	<input type="text" name="date" class="datetimepick"
																		   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																</td>
																<td>
																	<input type="text" name="place"
																		   value="${travelreimburseAttach.place }">
																</td>
																<td>
																	<input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</td>
																<td>
																	<input type="text" name="cost" style="text-align:right"
																		   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																</td>
																<td>
																	<input type="text" name="actReimburse"
																		   style="text-align:right"
																		   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" onchange="validationRed('relationship')">
																</td>
																<td>
																<textarea name="reason"
																		  onfocus="reasonChange(this, 'relationship')">${travelreimburseAttach.reason }</textarea>
																</td>
																<td>
																<textarea
																		name="detail">${travelreimburseAttach.detail }</textarea>
																</td>
																<c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																</c:if>
																<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																	<td></td>
																</c:if>
															</tr>
														</c:if>
													</c:forEach>
													</tbody>
												</table>
											</div>
										</div>
									  <hr>
                                    <table class="end" style="border-top-style:hidden">
                                        <tr>
                                            <td class="td_right td_weight" style="width:8%;border-left-style:hidden;">
                                                <span>实报金额：</span></td>
                                            <td style="width:92%;border-right-style:hidden;">
                                                <div style="display:flex">
                                                    <div style="display:flex">
                                                        <span>¥</span>
                                                        <span id="Total">${map.business.total }</span>
                                                    </div>
                                                    <div>(<span id="Totalcn"></span>)</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <table id="reimbursetotal" class="end" style="margin-top:0;">
                                            <thead name="reimbursetotal">
                                            </thead>
                                        </table>
                                    </div>
                                    <table class="end" style="margin-top:0;">
                                        <tr>
                                            <td class="td_weight"
                                                style="width:8%;border-top-style:none;border-left-style:none;border-bottom-style:none;">
                                                <span>出差管理</span></td>
                                            <td colspan="20" style="text-align:left; border:none;">
                                                <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
                                                    <input type="button" style="border:none" value="请选择出差申请"
                                                           onclick="openTravel()">
                                                </c:if>
                                                <span id="selectTravel" name="selectTravel"></span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="end" style="margin-top:0;">
                                        <td class="td_right td_weight"
                                            style="width:8%; border-left-style:hidden; border-bottom:0px;">
                                            <span>附件：</span>
                                        </td>
                                        <td colspan="20" style="border-bottom:0px; border-right-style:hidden;">
                                            <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
											</a>
                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                        <td style="border-bottom:0px;">
		                                        	<input type="file" id="file" name="file" style="display:none">
		                                            <input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
		                                        </td>
                                        	</c:if>
	                                        <c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
	                                            <td style="border-bottom:0px; border-right-style:hidden;">
	                                                <c:if test="${ not empty(map.business.attachments)}">
	                                                    <a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
	                                                </c:if>
	                                                <c:if test="${empty(map.business.attachments)}">
														<input type="file" id="file" name="file" style="display:none;">
														<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
													</c:if>
	                                            </td>
	                                        </c:if>
                                        </td>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                            </c:when>
                            
                            <%-- 审批或者其他人查看的部分 --%>
                            <%-- <c:if test="${(map.task.name ne '提交申请' and map.task.name ne '部门经理') or map.business.userId ne sessionScope.user.id }"> --%>
                            <c:otherwise>
                            	<tbody>
                            		<shiro:hasPermission name="fin:reimburse:modify">
                            			<select id="conveyance_hidden" style="display:none;">
		                                <custom:dictSelect type="出差报销交通工具"/>
		                            </select>
		                            <select id="conveyance1_hidden" style="display: none">
		                                <custom:dictSelect type="市内交通费交通工具"/>
		                            </select>

		                            <!-- 报销人相关 -->
		                            <tr>
		                                <td class="td_weight"><span>出差人员</span></td>
		                                <td><input type="text" id="name" name="name" value="${map.business.name }"></td>
		                                <td class="td_weight"><span>报销单位</span></td>
		                                <td style="line-height:20px;text-align:left;">
		                                    <select name="title">
		                                    	<custom:dictSelect type="流程所属公司"  selectedValue="${map.business.title }"/>
		                                    </select>
                                    		<c:choose>
                                        		<c:when test="${empty(map.business.dept.alias)}">
		                                            <input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;"
		                                                   id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
		                                        </c:when>
		                                        <c:otherwise>
		                                            <input type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;"
		                                                   id="deptName" name="deptName" onclick="openDept()" value="" readonly>
		                                        </c:otherwise>
                                    		</c:choose>
                                		</td>
		                                <td class="td_weight"><span>提交日期</span></td>
		                                <td>
		                                    <input type="text" id="applyTime" name="applyTime"
		                                           value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>"
		                                           style="color:gray;" readonly>
		                                </td>
                            		</tr>
		                            <tr>
		                                <!-- 领款人相关 -->
		                                <td class="td_weight"><span>领款人</span></td>
		                                <td style="width:5%;"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
		                                <td class="td_weight"><span>银行卡号</span></td>
		                                <td><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
		                                <td class="td_weight"><span>开户行名称</span></td>
		                                <td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
		                            </tr>

		                            <!-- 城际交通费 -->
		                            <tr>
		                            	<td colspan="22">
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#intercityCost" data-toggle="collapse">城际交通费</a>
		                                        <div id="myTabContent" class="tab-content">
		                                            <div class="panel-collapse collapse in" id="intercityCost">
		                                                <table style="width:100%;">
		                                                    <thead>
			                                                    <tr>
			                                                        <td class="td_weight" style="width: 10%; border-left-style:hidden;">日期</td>
			                                                        <td class="td_weight" style="width: 5.5%;">出发地</td>
			                                                        <td class="td_weight" style="width: 5.5%;">目的地</td>
			                                                        <td class="td_weight" style="width: 5.5%;">交通工具</td>
			                                                        <td class="td_weight" style="width: 13%;">项目</td>
			                                                        <td class="td_weight" style="width: 5.5%;">费用</td>
			                                                        <td class="td_weight" style="width: 5.5%;">实报</td>
			                                                        <td class="td_weight" style="width: 18%;">事由</td>
			                                                        <td class="td_weight" style="width: 26.2%; border-right:none;">明细</td>
			                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                            <td class="td_weight" style="width: 4%; border-right-style:hidden;">操作</td>
			                                                        </c:if>
			                                                    </tr>
                                                    		</thead>
                                                    	    <tbody>
	                                                    		<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
	                                                        	    <c:if test="${travelreimburseAttach.type eq '0' }">
	                                                                	<tr name="node" id="node">
	                                                                		<input type="hidden" name="id" value="${travelreimburseAttach.id }">
			                                                                <td style="border-left-style:hidden;">
			                                                                    <input type="text" name="date" class="datetimepick"
			                                                                           value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
			                                                                           readonly>
			                                                                </td>
			                                                                <td>
			                                                                    <input type="text" name="startPoint" value="${travelreimburseAttach.startPoint }">
			                                                                </td>
			                                                                <td>
			                                                                    <input type="text" name="destination" value="${travelreimburseAttach.destination }">
			                                                                </td>
			                                                                <td>
			                                                                    <select name="conveyance" style="width:100%; test-align-last:center">
			                                                                        <custom:dictSelect type="出差报销交通工具" selectedValue="${travelreimburseAttach.conveyance }"/>
			                                                                    </select>
			                                                                </td>
                                                                            <td>
                                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </td>
			                                                                <td>
			                                                                    <input type="text" name="cost" style="text-align:right"
			                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
			                                                                </td>
			                                                                <td>
			                                                                    <input type="text" name="actReimburse" style="text-align:right"
			                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
			                                                                </td>
			                                                                <td>
			                                                                    <textarea type="text" name="reason" autocomplete="off">
			                                                                    	${travelreimburseAttach.reason }
			                                                                    </textarea>
			                                                                </td>
			                                                                <td style="">
			                                                                	<textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                                </td>
			                                                                <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                    <td></td>
			                                                                </c:if>
			                                                            </tr>
			                                                        </c:if>
			                                                    </c:forEach>
		                                                    </tbody>
		                                                </table>
		                                            </div>
		                                        </div>
		                                    </div>
                                    		<hr>
		                                    <!-- 住宿费 -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#stayCost" data-toggle="collapse" data-parent="#intercityCost">住宿费</a>
		                                        <div class="panel-collapse collapse in" id="stayCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight"
			                                                        style="width: 8%; border-left-style:hidden;">日期
			                                                    </td>
			                                                    <td class="td_weight" style="width: 4.8%;">地点</td>
			                                                    <td class="td_weight" style="width: 12%;">项目</td>
			                                                    <td class="td_weight" style="width: 5%;">天*房</td>
			                                                    <td class="td_weight" style="width: 5%;">费用</td>
			                                                    <td class="td_weight" style="width: 4.8%;">实报</td>
			                                                    <td class="td_weight" style="width: 15%;">事由</td>
			                                                    <td class="td_weight" style="width: 21%;  border-right:none; ">明细</td>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">费用归属
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <%-- <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;border-right: hidden">费用归属
			                                                        </td>
			                                                    </c:if> --%>
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight"
			                                                            style="width: 3.3%; border-right-style:hidden;">操作
			                                                        </td>
			                                                    </c:if>
			                                                </tr>
		                                                </thead>
		                                                <tbody>
			                                                <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
			                                                    <c:if test="${travelreimburseAttach.type eq '1' }">
			                                                        <tr name="node" id="node">
			                                                            <input type="hidden" name="id"
			                                                                   value="${travelreimburseAttach.id }">
			                                                            <td style="border-left-style:hidden;">
			                                                                <input type="text" name="date" class="datetimepick"
			                                                                       value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
			                                                                       readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="place" value="${travelreimburseAttach.place }">
			                                                            </td>
			                                                            <td>
			                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
			                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="dayRoom"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="cost" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="actReimburse" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="reason" autocomplete="off">
			                                                                	${travelreimburseAttach.reason }
			                                                                </textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                            </td>
			                                                           <%--  <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}"> --%>
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                        <%-- <select style="width: 100%;" name="attachInvestId"
			                                                                                value="${travelreimburseAttach.attachInvestId}">
			                                                                        </select> --%>
			                                                                        <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            <%-- </c:if> --%>
			
			                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 市内交通费 -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#cityCost" data-toggle="collapse">市内交通费</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 6.9%;border-left-style:hidden;"></td>
			                                                    <td class="td_weight" style="width: 6%;">地点</td>
			                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">交通工具</td>
			                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
			                                                    <td class="td_weight" style="width: 7%;">费用</td>
			                                                    <td class="td_weight" style="width: 7%;">实报</td>
			                                                    <td class="td_weight" style="width: 22%;">事由</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
			                                                    <%-- <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                        <td class="td_weight" style="width: 5.6%;border-right: hidden">费用归属</td>
			                                                    </c:if> --%>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">费用归属
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%; border-right-style:hidden;">操作</td>
			                                                    </c:if>
		                                                	</tr>
		                                                </thead>
		                                                <tbody>
			                                                <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
			                                                    <c:if test="${travelreimburseAttach.type eq '2' }">
			                                                        <tr name="node" id="node">
			                                                            <input type="hidden" name="id" value="${travelreimburseAttach.id }">
			                                                            <td style="border-left-style:hidden;">
			                                                                <input type="text" name="date" class="datetimepick"
			                                                                       value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
			                                                                       readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="place" value="${travelreimburseAttach.place }">
			                                                            </td>
			                                                            <c:if test="${not empty travelreimburseAttach.conveyance}">
			                                                                <td>
			                                                                    <select name="conveyance" style="width:100%;test-align-last:center">
			                                                                        <custom:dictSelect type="市内交通费交通工具"  selectedValue="${travelreimburseAttach.conveyance }"/>
			                                                                    </select>
			                                                                </td>
			                                                            </c:if>
			                                                            <td>
			                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
			                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="cost" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="actReimburse" style="text-align:right"
			                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="reason">${travelreimburseAttach.reason }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                            </td>
			                                                            <%-- <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler}"> --%>
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                        <%-- <select style="width: 100%;" name="attachInvestId" value="${travelreimburseAttach.attachInvestId}">
			                                                                        </select> --%>
			                                                                        <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            <%-- </c:if> --%>
			                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 接待餐费-->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#receiveCost" data-toggle="collapse">接待费用</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%; border-left-style:hidden;">日期 </td>
			                                                    <td class="td_weight" style="width: 6%;">地点</td>
			                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
			                                                    <td class="td_weight" style="width: 7%;">费用</td>
			                                                    <td class="td_weight" style="width: 7%;">实报</td>
			                                                    <td class="td_weight" style="width: 22%;">事由</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">费用归属
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <%-- <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;">费用归属
			                                                        </td>
			                                                    </c:if> --%>
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%;border-right-style:hidden;">操作</td>
			                                                    </c:if>
			                                                </tr>
			                                            </thead>
			                                            <tbody>
				                                        	<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
				                                            	<c:if test="${travelreimburseAttach.type eq '3' }">
				                                                	<tr name="node" id="receive">
				                                                    	<input type="hidden" name="id" value="${travelreimburseAttach.id }">
				                                                        <td style="border-left-style:hidden;">
				                                                        	<input type="text" name="date" class="datetimepick"
				                                                            	value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
				                                                                readonly>
				                                                        </td>
				                                                        <td>
				                                                        	<input type="text" name="place" value="${travelreimburseAttach.place }">
				                                                        </td>
				                                                        <td>
				                                                        	<input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
				                                                            <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
				                                                        </td>
				                                                        <td>
				                                                        	<input type="text" name="cost" style="text-align:right"
				                                                            	value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
				                                                        </td>
				                                                        <td>
				                                                        	<input type="text" name="actReimburse" style="text-align:right"
				                                                                value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
				                                                        </td>
				                                                        <td>
				                                                        	<textarea name="reason" onfocus="reasonChange(this, 'receiveCost')">
				                                                        		${travelreimburseAttach.reason }
				                                                        	</textarea>
				                                                        </td>
				                                                        <td>
				                                                        	<textarea name="detail">${travelreimburseAttach.detail }</textarea>
				                                                        </td>
				                                                        <%-- <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}"> --%>
				                                                        	<shiro:hasPermission name="fin:reimburse:seeall">
				                                                            	<td style="width:100px;">
				                                                                	<%-- <select style="width: 100%;" name="attachInvestId"
				                                                                    	value="${travelreimburseAttach.attachInvestId}"></select> --%>
				                                                                    	<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
				                                                                </td>
				                                                            </shiro:hasPermission>
				                                                        <%-- </c:if> --%>
				                                                        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
				                                                        	<td></td>
				                                                        </c:if>
				                                                    </tr>
				                                                  </c:if>
				                                              </c:forEach>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 补贴 -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#subsidy" data-toggle="collapse">补贴</a>
		                                        <div class="panel-collapse collapse in" id="subsidy">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 7.7%; border-left-style:hidden;">出发日期</td>
			                                                    <td class="td_weight" style="width: 7.1%;">离开日期</td>
			                                                    <td class="td_weight" style="width: 7%;">餐费补贴</td>
			                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">交通补贴</td>
			                                                    <td class="td_weight" style="width: 14.7%;">项目</td>
			                                                    <td class="td_weight" style="width: 22%;">事由</td>
			                                                    <td class="td_weight" style="width: 26.4%;  border-right:none; ">明细</td>
			                                                    <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%;border-right-style:hidden;">操作</td>
			                                                    </c:if>
			                                                </tr>
		                                                </thead>
		                                                <tbody>
			                                                <c:forEach items="${map.business.travelreimburseAttachList }"
			                                                           var="travelreimburseAttach">
			                                                    <c:if test="${travelreimburseAttach.type eq '4' }">
			                                                        <tr name="node" id="node">
			                                                            <input type="hidden" name="id" value="${travelreimburseAttach.id }">
			                                                            <input type="hidden" name="date"
			                                                                   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />">
			                                                            <input type="hidden" name="actReimburse" value="<fmt:formatNumber value="0" pattern="#.##" />">
			                                                            <td style="border-left-style:hidden;">
			                                                                <input type="text" name="beginDate" class="datetimepick"
			                                                                       value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />"
			                                                                       readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="endDate" class="datetimepick"
			                                                                	value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />"
			                                                                    readonly>
			                                                            </td>
			                                                            <td>
			                                                                <input type="text" name="foodSubsidy" style="text-align:right"
			                                                                	value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />" readonly>
			                                                            </td>
			
			                                                            <c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
			                                                                <td>
			                                                                	<input type="text" name="trafficSubsidy" style="text-align:right" 
			                                                                		value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />" readonly>
			                                                               </td>
			                                                            </c:if>
																		<c:if test="${empty travelreimburseAttach.trafficSubsidy}">
			                                                                <td><input type="text" name="trafficSubsidy" style="text-align:right" value="0"></td>
			                                                            </c:if>
			                                                            <td>
			                                                                <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
			                                                                <textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="reason">${travelreimburseAttach.reason }</textarea>
			                                                            </td>
			                                                            <td>
			                                                                <textarea name="detail">${travelreimburseAttach.detail }</textarea>
			                                                            </td>
			                                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
											<hr>
											<!-- 业务费-->
											<div style="text-align:left;" class="tittle">
												<a href="#business" data-toggle="collapse">业务费用</a>
												<div class="panel-collapse collapse in" id="business">
													<table style="width:100%;">
														<thead>
														<tr>
															<td class="td_weight" style="width: 8%; border-left-style:hidden;">日期 </td>
															<td class="td_weight" style="width: 6%;">地点</td>
															<td class="td_weight" style="width: 15.4%;">项目</td>
															<td class="td_weight" style="width: 7%;">费用</td>
															<td class="td_weight" style="width: 7%;">实报</td>
															<td class="td_weight" style="width: 22%;">事由</td>
															<td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
															<shiro:hasPermission name="fin:reimburse:seeall">
																<td class="td_weight"
																	style="width: 5.6%;border-right: hidden;">费用归属
																</td>
															</shiro:hasPermission>
															<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																<td class="td_weight" style="width: 4%;border-right-style:hidden;">操作</td>
															</c:if>
														</tr>
														</thead>
														<tbody>
														<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
															<c:if test="${travelreimburseAttach.type eq '5' }">
																<tr name="node" id="receive">
																	<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																	<td style="border-left-style:hidden;">
																		<input type="text" name="date" class="datetimepick"
																			   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																			   readonly>
																	</td>
																	<td>
																		<input type="text" name="place" value="${travelreimburseAttach.place }">
																	</td>
																	<td>
																		<input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
																		<textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																	</td>
																	<td>
																		<input type="text" name="cost" style="text-align:right"
																			   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
																	</td>
																	<td>
																		<input type="text" name="actReimburse" style="text-align:right"
																			   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
																	</td>
																	<td>
				                                                        	<textarea name="reason" onfocus="reasonChange(this, 'business')">
																					${travelreimburseAttach.reason }
																			</textarea>
																	</td>
																	<td>
																		<textarea name="detail">${travelreimburseAttach.detail }</textarea>
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																	<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																		<td></td>
																	</c:if>
																</tr>
															</c:if>
														</c:forEach>
														</tbody>
													</table>
												</div>
											</div>
											<hr>
											<!-- 攻关费-->
											<div style="text-align:left;" class="tittle">
												<a href="#relationship" data-toggle="collapse">攻关费用</a>
												<div class="panel-collapse collapse in" id="relationship">
													<table style="width:100%;">
														<thead>
														<tr>
															<td class="td_weight" style="width: 8%; border-left-style:hidden;">日期 </td>
															<td class="td_weight" style="width: 6%;">地点</td>
															<td class="td_weight" style="width: 15.4%;">项目</td>
															<td class="td_weight" style="width: 7%;">费用</td>
															<td class="td_weight" style="width: 7%;">实报</td>
															<td class="td_weight" style="width: 22%;">事由</td>
															<td class="td_weight" style="width: 26%;  border-right:none; ">明细</td>
															<shiro:hasPermission name="fin:reimburse:seeall">
																<td class="td_weight"
																	style="width: 5.6%;border-right: hidden;">费用归属
																</td>
															</shiro:hasPermission>
															<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																<td class="td_weight" style="width: 4%;border-right-style:hidden;">操作</td>
															</c:if>
														</tr>
														</thead>
														<tbody>
														<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
															<c:if test="${travelreimburseAttach.type eq '6' }">
																<tr name="node" id="receive">
																	<input type="hidden" name="id" value="${travelreimburseAttach.id }">
																	<td style="border-left-style:hidden;">
																		<input type="text" name="date" class="datetimepick"
																			   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																			   readonly>
																	</td>
																	<td>
																		<input type="text" name="place" value="${travelreimburseAttach.place }">
																	</td>
																	<td>
																		<input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
																		<textarea name="projectName" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																	</td>
																	<td>
																		<input type="text" name="cost" style="text-align:right"
																			   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />" readonly >
																	</td>
																	<td>
																		<input type="text" name="actReimburse" style="text-align:right"
																			   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" readonly >
																	</td>
																	<td>
				                                                        	<textarea name="reason" onfocus="reasonChange(this, 'relationship')">
																					${travelreimburseAttach.reason }
																			</textarea>
																	</td>
																	<td>
																		<textarea name="detail">${travelreimburseAttach.detail }</textarea>
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																	<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																		<td></td>
																	</c:if>
																</tr>
															</c:if>
														</c:forEach>
														</tbody>
													</table>
												</div>
											</div>
		                                    <hr>
		                                    <table class="end" style="border-top-style:hidden">
		                                        <tr>
		                                            <td class="td_right td_weight" style="width:8%;border-left-style:hidden;">
		                                                <span>实报金额：</span>
		                                            </td>
		                                            <td style="width:92%;border-right-style:hidden;">
		                                                <div style="display:flex">
		                                                    <div style="display:flex">
		                                                        <span>¥</span>
		                                                        <span id="Total">${map.business.total }</span>
		                                                    </div>
		                                                    <div>(<span id="Totalcn"></span>)</div>
		                                                </div>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                    <div>
		                                        <table id="reimbursetotal" class="end" style="margin-top:0;">
		                                            <thead name="reimbursetotal"></thead>
		                                        </table>
		                                    </div>
		                                    <table class="end" style="margin-top:0;">
		                                        <tr>
		                                            <td class="td_weight" style="width:8%;border-top-style:none;border-left-style:none;border-bottom-style:none;">
		                                                <span>出差管理</span>
		                                            </td>
		                                            <td colspan="20" style="text-align:left; border:none;">
		                                                <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
		                                                    <input type="button" style="border:none" value="请选择出差申请" onclick="openTravel()">
		                                                </c:if>
		                                                <span id="selectTravel" name="selectTravel"></span>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                    <table class="end" style="margin-top:0;">
		                                        <td class="td_right td_weight" style="width:8%; border-left-style:hidden; border-bottom:0px;">
		                                            <span>附件：</span>
		                                        </td>
		                                        <td colspan="20" style="border-bottom:0px; border-right-style:hidden;">
		                                            <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
		                                               <input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
		                                            </a>
		                                            <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
				                                        <td style="border-bottom:0px;">
				                                        	<input type="file" id="file" name="file" style="display:none">
				                                            <input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
				                                        </td>
		                                        	</c:if>
			                                        <c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11' or map.business.status eq '1')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
			                                            <td style="border-bottom:0px; border-right-style:hidden;">
			                                                <c:if test="${ not empty(map.business.attachments)}">
			                                                    <a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
			                                                </c:if>
			                                                <c:if test="${empty(map.business.attachments)}">
																<input type="file" id="file" name="file" style="display:none;">
																<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
															</c:if>
			                                            </td>
			                                        </c:if>
		                                        </td>
		                                    </table>
		                                </td>
		                            </tr>
                            		</shiro:hasPermission>
                            		<shiro:lacksPermission name="fin:reimburse:modify">
                            			<!-- 报销人相关 -->
				                            <tr>
				                                <td class="td_weight"><span>出差人员</span></td>
				                                <td><input type="text" id="name" name="name" value="${map.business.name }" readonly></td>
				                                <td class="td_weight"><span>报销单位</span></td>
				                                <td colspan="2" style="line-height:20px;text-align:left;">
				                                    <custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
				                                    <c:choose>
				                                        <c:when test="${empty(map.business.dept.alias)}">
				                                            <input type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;"
				                                                   id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
				                                        </c:when>
				                                        <c:otherwise>
				                                            <input type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;"
				                                                   id="deptName" name="deptName" onclick="openDept()" value="" readonly>
				                                        </c:otherwise>
				                                    </c:choose>
				                                </td>
				                                <td class="td_weight"><span>提交日期</span></td>
				                                <td>
				                                	<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>" readonly>
				                                </td>
				                                    <%--<shiro:hasPermission name="fin:reimburse:seeall">--%>
				                                    <%--<td class="td_weight"><span>费用归属34</span></td>--%>
				                                    <%--<td colspan="2" style="text-align:left;">--%>
				                                    <%--<select  type="text" style="width: 100%;" name="investId" value="${map.business.investId }"></select>--%>
				                                    <%--</td> --%>
				                                    <%--</shiro:hasPermission>--%>
				                            </tr>
				                            <!-- 领款人相关 -->
				                            <tr>
				                                <td class="td_weight"><span>领款人</span></td>
				                                <td style="width:10%">
				                                	<input type="text" id="payee" name="payee" style="text-align:center;" value="${map.business.payee }" readonly>
				                                </td>
				                                <td class="td_weight"><span>银行卡号</span></td>
				                                <td>
				                                	<input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }" readonly>
				                                </td>
				                                <td class="td_weight"><span>开户行名称</span></td>
				                                <td colspan="3">
				                                	<input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }" readonly>
				                                </td>
				                            </tr>
		
				                            <!-- 城际交通费 -->
				                            <tr>
				                                <td colspan="22">
				                                    <div style="text-align:left;" class="tittle">
				                                    	<a href="#intercityCost" data-toggle="collapse">城际交通费</a>
				                                        <div id="myTabContent" class="tab-content">
				                                            <div class="panel-collapse collapse in" id="intercityCost">
				                                                <table style="width:100%;">
				                                                    <thead>
					                                                    <tr>
					                                                        <td class="td_weight"
					                                                            style="width: 10%; border-left-style:hidden;">日期
					                                                        </td>
					                                                        <td class="td_weight" style="width: 5.5%;">出发地</td>
					                                                        <td class="td_weight" style="width: 5.5%;">目的地</td>
					                                                        <td class="td_weight" style="width: 5.5%;">交通工具</td>
					                                                        <td class="td_weight" style="width: 13%;">项目</td>
					                                                        <td class="td_weight" style="width: 5.5%;">费用</td>
					                                                        <td class="td_weight" style="width: 5.5%;">实报</td>
					                                                        <td class="td_weight" style="width: 18%;">事由</td>
					                                                        <td class="td_weight"
					                                                            style="width: 26.2%; border-right-style:hidden;">明细
					                                                        </td>
					                                                    </tr>
				                                                    </thead>
				                                                    <tbody>
					                                                    <c:forEach items="${map.business.travelreimburseAttachList }"
					                                                               var="travelreimburseAttach">
					                                                        <c:if test="${travelreimburseAttach.type eq '0' }">
					                                                            <tr name="node" id="node">
					                                                                <input type="hidden" name="id" value="${travelreimburseAttach.id }">
					                                                                <td style="border-left-style:hidden;">
					                                                                	<input type="text" name="date" 
					                                                                		value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
					                                                                </td>
					                                                                <td>
					                                                                	<input type="text" name="startPoint" value="${travelreimburseAttach.startPoint }" readonly>
					                                                                </td>
					                                                                <td>
					                                                                	<input type="text" name="destination" value="${travelreimburseAttach.destination }" readonly>
					                                                                </td>
					                                                                <td>
					                                                                    <input type="text" name="conveyanceText"
					                                                                           value="<custom:getDictKey type="出差报销交通工具" value="${travelreimburseAttach.conveyance }"/>"
					                                                                           readonly>
					                                                                    <input type="hidden" name="conveyance" value="${travelreimburseAttach.conveyance }">
					                                                                </td>
					                                                                <td>
					                                                                    <input type="hidden" name="projectId" value="${travelreimburseAttach.projectId }">
					                                                                    <textarea name="projectName" readonly>${travelreimburseAttach.project.name }</textarea>
					                                                                </td>
					                                                                <td>
					                                                                	<input type="text" name="cost" style="text-align:right"
					                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
					                                                                           readonly></td>
					                                                                <td>
					                                                                	<input type="text" name="actReimburse" style="text-align:right"
					                                                                           value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
					                                                                           readonly></td>
					                                                                <td><textarea name="reason" readonly>${travelreimburseAttach.reason }</textarea></td>
					                                                                <td><textarea name="detail" readonly>${travelreimburseAttach.detail }</textarea></td>
					                                                            </tr>
					                                                        </c:if>
					                                                    </c:forEach>
				                                                    <!-- 	<tr name="subTotal">
				                                                            <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
				                                                            <td><input type="text" readonly></td>
				                                                            <td><input type="text" readonly ></td>
				                                                            <td><input type="text" readonly></td>
				                                                            <td><input type="text" name="costTotal" readonly></td>
				                                                            <td><input type="text" name="actReimburseTotal" readonly></td>
				                                                            <td><input type="text" readonly></td>
				                                                            <td><input type="text" readonly></td>
				                                                        </tr> -->
				                                                    </tbody>
				                                                </table>
				                                            </div>
				                                        </div>
				                                    </div>
				                                    <hr>
				                                    <!-- 住宿费 -->
				                                    <div style="text-align:left;" class="tittle">
				                                    	<a href="#stayCost" data-toggle="collapse">住宿费</a>
				                                        <div class="panel-collapse collapse in" id="stayCost">
				                                            <table style="width:100%;">
				                                                <thead>
				                                                <tr>
				                                                    <td class="td_weight"
				                                                        style="width: 8%; border-left-style:hidden;">日期
				                                                    </td>
				                                                    <td class="td_weight" style="width: 4.8%;">地点</td>
				                                                    <td class="td_weight" style="width: 12%;">项目</td>
				                                                    <td class="td_weight" style="width: 5%;">天*房</td>
				                                                    <td class="td_weight" style="width: 5%;">费用</td>
				                                                    <td class="td_weight" style="width: 4.8%;">实报</td>
				                                                    <td class="td_weight" style="width: 15%;">事由</td>
				                                                    <td class="td_weight"
				                                                        style="width: 21%;">明细
				                                                    </td>
				                                                    <shiro:hasPermission name="fin:reimburse:seeall">
				                                                        <td class="td_weight"
				                                                            style="width: 5.6%;border-right: hidden;">费用归属
				                                                        </td>
				                                                    </shiro:hasPermission>
				                                                </tr>
				                                                </thead>
				                                                <tbody>
				                                                <c:forEach items="${map.business.travelreimburseAttachList }"
				                                                           var="travelreimburseAttach">
				                                                    <c:if test="${travelreimburseAttach.type eq '1' }">
				                                                        <tr name="node" id="node">
				                                                            <input type="hidden" name="id"
				                                                                   value="${travelreimburseAttach.id }">
				                                                            <td style="border-left-style:hidden;"><input type="text"
				                                                                                                         name="date"
				                                                                                                         value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
				                                                                                                         readonly></td>
				                                                            <td><input type="text" name="place"
				                                                                       value="${travelreimburseAttach.place }" readonly>
				                                                            </td>
				                                                            <td>
				                                                                <input type="hidden" name="projectId"
				                                                                       value="${travelreimburseAttach.projectId }">
				                                                                <textarea type="text" name="projectName"
				                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
				                                                            </td>
				                                                            <td><input type="text" name="dayRoom"
				                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />"
				                                                                       readonly></td>
				                                                            <td><input type="text" name="cost" style="text-align:right"
				                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
				                                                                       readonly></td>
				                                                            <td><input type="text" name="actReimburse"
				                                                                       style="text-align:right"
				                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
				                                                                       readonly></td>
				                                                            <td><textarea name="reason"
				                                                                          readonly>${travelreimburseAttach.reason }</textarea>
				                                                            </td>
				                                                            <td><textarea name="detail"
				                                                                          readonly>${travelreimburseAttach.detail }</textarea>
				                                                            </td>
				                                                            <shiro:hasPermission name="fin:reimburse:seeall">
				                                                                <td style="width:100px;">
				                                                                    <%-- <select style="width: 100%;" name="attachInvestId"
				                                                                            value="${travelreimburseAttach.attachInvestId}"></select> --%>
				                                                                            <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
				                                                                </td>
				                                                            </shiro:hasPermission>
				                                                        </tr>
				                                                    </c:if>
				                                                </c:forEach>
				                                                <!-- <tr name="subTotal">
				                                                    <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
				                                                    <td><input type="text" readonly></td>
				                                                    <td><input type="text" readonly ></td>
				                                                    <td><input type="text" name="costTotal" readonly></td>
				                                                    <td><input type="text" name="actReimburseTotal" readonly></td>
				                                                    <td><input type="text" readonly></td>
				                                                    <td><input type="text" readonly></td>
				                                                    <td><input type="text" readonly></td>
				                                                </tr> -->
				                                                </tbody>
				                                            </table>
				                                        </div>
				                                    </div>
				                                    <hr>
		                                    <!-- 市内交通费 -->
		                                    <div style="text-align:left;" class="tittle"><a href="#cityCost"
		                                                                                    data-toggle="collapse">市内交通费</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">
		                                                        日期
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">地点</td>
		                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">交通工具</td>
		                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
		                                                    <td class="td_weight" style="width: 7%;">费用</td>
		                                                    <td class="td_weight" style="width: 7%;">实报</td>
		                                                    <td class="td_weight" style="width: 22%;">事由</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26%;">明细
		                                                    </td>
		                                                    <shiro:hasPermission name="fin:reimburse:seeall">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%;border-right: hidden">费用归属
		                                                        </td>
		                                                    </shiro:hasPermission>
		                                                </tr>
		                                                </thead>
		                                                <tbody>
		                                                <c:forEach items="${map.business.travelreimburseAttachList }"
		                                                           var="travelreimburseAttach">
		                                                    <c:if test="${travelreimburseAttach.type eq '2' }">
		                                                        <tr name="node" id="node">
		                                                            <input type="hidden" name="id"
		                                                                   value="${travelreimburseAttach.id }">
		                                                            <td style="border-left-style:hidden;"><input type="text"
		                                                                                                         name="date"
		                                                                                                         value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
		                                                                                                         readonly></td>
		                                                            <td><input type="text" name="place"
		                                                                       value="${travelreimburseAttach.place }" readonly>
		                                                            </td>
		                                                            <c:if test="${not empty travelreimburseAttach.conveyance}">
		                                                                <td>
		                                                                    <input type="text" name="conveyanceText"
		                                                                           value="<custom:getDictKey type="市内交通费交通工具" value="${travelreimburseAttach.conveyance }"/>"
		                                                                           readonly>
		                                                                    <input type="hidden" name="conveyance"
		                                                                           value="${travelreimburseAttach.conveyance }">
		                                                                </td>
		                                                            </c:if>
		                                                            <td>
		                                                                <input type="hidden" name="projectId"
		                                                                       value="${travelreimburseAttach.projectId }">
		                                                                <textarea name="projectName"
		                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
		                                                            </td>
		                                                            <td><input type="text" name="cost" style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
		                                                                       readonly></td>
		                                                            <td><input type="text" name="actReimburse"
		                                                                       style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
		                                                                       readonly></td>
		                                                            <td><textarea name="reason"
		                                                                          readonly>${travelreimburseAttach.reason }</textarea>
		                                                            </td>
		                                                            <td><textarea name="detail"
		                                                                          readonly>${travelreimburseAttach.detail }</textarea>
		                                                            </td>
		                                                            <shiro:hasPermission name="fin:reimburse:seeall">
		                                                                <td style="width:100px;">
		                                                                    <%-- <select style="width: 100%;" name="attachInvestId"
		                                                                            value="${travelreimburseAttach.attachInvestId}"></select> --%>
		                                                                            <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
		                                                                </td>
		                                                            </shiro:hasPermission>
		                                                        </tr>
		                                                    </c:if>
		                                                </c:forEach>
		                                                <!-- <tr name="subTotal">
		                                                    <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
		                                                    <td><input type="text" readonly></td>
		                                                    <td><input type="text" name="costTotal" readonly ></td>
		                                                    <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                    <td><input type="text" readonly></td>
		                                                    <td><input type="text" readonly></td>
		                                                </tr> -->
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>

		                                    <!-- 	接待餐费-->
		                                    <div style="text-align:left;" class="tittle"><a href="#receiveCost"
		                                                                                    data-toggle="collapse">接待餐费</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">
		                                                        日期
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">地点</td>
		                                                    <td class="td_weight" style="width: 15.4%;">项目</td>
		                                                    <td class="td_weight" style="width: 7%;">费用</td>
		                                                    <td class="td_weight" style="width: 7%;">实报</td>
		                                                    <td class="td_weight" style="width: 22%;">事由</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26%;">明细
		                                                    </td>
		                                                    <shiro:hasPermission name="fin:reimburse:seeall">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%;border-right: hidden">费用归属
		                                                        </td>
		                                                    </shiro:hasPermission>
		                                                </tr>
		                                                </thead>
		                                                <tbody>
		                                                <c:forEach items="${map.business.travelreimburseAttachList }"
		                                                           var="travelreimburseAttach">
		                                                    <c:if test="${travelreimburseAttach.type eq '3' }">
		                                                        <tr name="node" id="receive">
		                                                            <input type="hidden" name="id"
		                                                                   value="${travelreimburseAttach.id }">
		                                                            <td style="border-left-style:hidden;"><input type="text"
		                                                                                                         name="date"
		                                                                                                         value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
		                                                                                                         readonly></td>
		                                                            <td><input type="text" name="place"
		                                                                       value="${travelreimburseAttach.place }" readonly>
		                                                            </td>
		                                                            <td>
		                                                                <input type="hidden" name="projectId"
		                                                                       value="${travelreimburseAttach.projectId }">
		                                                                <textarea name="projectName"
		                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
		                                                            </td>
		                                                            <td><input type="text" name="cost" style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
		                                                                       readonly></td>
		                                                            <td><input type="text" name="actReimburse"
		                                                                       style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
		                                                                       readonly></td>
		                                                            <td><textarea name="reason"
		                                                                          readonly>${travelreimburseAttach.reason }</textarea>
		                                                            </td>
		                                                            <td><textarea name="detail"
		                                                                          readonly>${travelreimburseAttach.detail }</textarea>
		                                                            </td>
		                                                            <shiro:hasPermission name="fin:reimburse:seeall">
		                                                                <td style="width:100px;">
		                                                                    <%-- <select style="width: 100%;" name="attachInvestId"
		                                                                            value="${travelreimburseAttach.attachInvestId}"></select> --%>
		                                                                            <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
		                                                                </td>
		                                                            </shiro:hasPermission>
		                                                        </tr>
		                                                    </c:if>
		                                                </c:forEach>
		                                                <!-- 	<tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" name="costTotal" readonly ></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                    </tr> -->
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- 补贴 -->
		                                    <div style="text-align:left;" class="tittle"><a href="#subsidy"
		                                                                                    data-toggle="collapse">补贴</a>
		                                        <div class="panel-collapse collapse in" id="subsidy">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight"
		                                                        style="width: 7.7%; border-left-style:hidden;">出发日期
		                                                    </td>
		                                                    <td class="td_weight" style="width: 7.1%;">离开日期</td>
		                                                    <td class="td_weight" style="width: 7%;">餐费补贴</td>
		                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">交通补贴</td>
		                                                    <td class="td_weight" style="width: 14.7%;">项目</td>
		                                                    <td class="td_weight" style="width: 22%;">事由</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26.4%; border-right-style:hidden;">明细
		                                                    </td>
		                                                </tr>
		                                                </thead>
		                                                <tbody>
		                                                <c:forEach items="${map.business.travelreimburseAttachList }"
		                                                           var="travelreimburseAttach">
		                                                    <c:if test="${travelreimburseAttach.type eq '4' }">
		                                                        <tr name="node" id="node">
		                                                            <input type="hidden" name="id"
		                                                                   value="${travelreimburseAttach.id }">
		                                                            <input type="hidden" name="actReimburse"
		                                                                   value="<fmt:formatNumber value="" pattern="#.##" />">
		                                                            <input type="hidden" name="date"
		                                                                   value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
		                                                                   readonly>
		                                                            <td style="border-left-style:hidden;"><input type="text"
		                                                                                                         name="beginDate"
		                                                                                                         value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />"
		                                                                                                         readonly></td>
		                                                            <td><input type="text" name="endDate"
		                                                                       value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />"
		                                                                       readonly></td>
		                                                            <td><input type="text" name="foodSubsidy"
		                                                                       style="text-align:right"
		                                                                       value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />"
		                                                                       readonly></td>
		                                                            <c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
		                                                                <td><input type="text" name="trafficSubsidy" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />" readonly></td>
		                                                            </c:if>
		                                                            <c:if test="${empty travelreimburseAttach.trafficSubsidy}">
		                                                                <td><input type="text" name="trafficSubsidy" style="text-align:right" value="0" readonly></td>
		                                                            </c:if>
		                                                            <td>
		                                                                <input type="hidden" name="projectId"
		                                                                       value="${travelreimburseAttach.projectId }">
		                                                                <textarea name="projectName"
		                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
		                                                            </td>
		                                                            <td><textarea name="reason"
		                                                                          readonly>${travelreimburseAttach.reason }</textarea>
		                                                            </td>
		                                                            <td><textarea name="detail"
		                                                                          readonly>${travelreimburseAttach.detail }</textarea>
		                                                            </td>
		                                                        </tr>
		                                                    	</c:if>
															</c:forEach>
																<!-- <tr name="subTotal">
																	<td colspan="2" class="td_right td_weight"><span>小计：</span></td>
																	<td><input type="text" name="foodSubsidyTotal" readonly></td>
																	<td><input type="text" name="trafficSubsidyTotal" readonly ></td>
																	<td><input type="text" readonly></td>
																	<td><input type="text" readonly></td>
																	<td><input type="text" readonly></td>
																</tr> -->
																</tbody>
															</table>
														</div>
													</div>
													<hr>
													<!-- 	业务费-->
													<div style="text-align:left;" class="tittle"><a href="#business"
																									data-toggle="collapse">业务费用</a>
														<div class="panel-collapse collapse in" id="business">
															<table style="width:100%;">
																<thead>
																<tr>
																	<td class="td_weight" style="width: 8%;border-left-style:hidden;">
																		日期
																	</td>
																	<td class="td_weight" style="width: 6%;">地点</td>
																	<td class="td_weight" style="width: 15.4%;">项目</td>
																	<td class="td_weight" style="width: 7%;">费用</td>
																	<td class="td_weight" style="width: 7%;">实报</td>
																	<td class="td_weight" style="width: 22%;">事由</td>
																	<td class="td_weight"
																		style="width: 26%;">明细
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td class="td_weight"
																			style="width: 5.6%;border-right: hidden">费用归属
																		</td>
																	</shiro:hasPermission>
																</tr>
																</thead>
																<tbody>
																<c:forEach items="${map.business.travelreimburseAttachList }"
																		   var="travelreimburseAttach">
																	<c:if test="${travelreimburseAttach.type eq '5' }">
																		<tr name="node" id="receive">
																			<input type="hidden" name="id"
																				   value="${travelreimburseAttach.id }">
																			<td style="border-left-style:hidden;"><input type="text"
																														 name="date"
																														 value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																														 readonly></td>
																			<td><input type="text" name="place"
																					   value="${travelreimburseAttach.place }" readonly>
																			</td>
																			<td>
																				<input type="hidden" name="projectId"
																					   value="${travelreimburseAttach.projectId }">
																				<textarea name="projectName"
																						  readonly>${travelreimburseAttach.project.name }</textarea>
																			</td>
																			<td><input type="text" name="cost" style="text-align:right"
																					   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
																					   readonly></td>
																			<td><input type="text" name="actReimburse"
																					   style="text-align:right"
																					   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
																					   readonly></td>
																			<td><textarea name="reason"
																						  readonly>${travelreimburseAttach.reason }</textarea>
																			</td>
																			<td><textarea name="detail"
																						  readonly>${travelreimburseAttach.detail }</textarea>
																			</td>
																			<shiro:hasPermission name="fin:reimburse:seeall">
																				<td style="width:100px;">
																					<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																							data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																				</td>
																			</shiro:hasPermission>
																		</tr>
																	</c:if>
																</c:forEach>
																</tbody>
															</table>
														</div>
													</div>
													<hr>
													<!-- 	攻关费-->
													<div style="text-align:left;" class="tittle">
														<a href="#relationship" data-toggle="collapse">攻关费用</a>
														<div class="panel-collapse collapse in" id="relationship">
															<table style="width:100%;">
																<thead>
																<tr>
																	<td class="td_weight" style="width: 8%;border-left-style:hidden;">
																		日期
																	</td>
																	<td class="td_weight" style="width: 6%;">地点</td>
																	<td class="td_weight" style="width: 15.4%;">项目</td>
																	<td class="td_weight" style="width: 7%;">费用</td>
																	<td class="td_weight" style="width: 7%;">实报</td>
																	<td class="td_weight" style="width: 22%;">事由</td>
																	<td class="td_weight"
																		style="width: 26%;">明细
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td class="td_weight"
																			style="width: 5.6%;border-right: hidden">费用归属
																		</td>
																	</shiro:hasPermission>
																</tr>
																</thead>
																<tbody>
																<c:forEach items="${map.business.travelreimburseAttachList }"
																		   var="travelreimburseAttach">
																	<c:if test="${travelreimburseAttach.type eq '6' }">
																		<tr name="node" id="receive">
																			<input type="hidden" name="id"
																				   value="${travelreimburseAttach.id }">
																			<td style="border-left-style:hidden;"><input type="text"
																														 name="date"
																														 value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
																														 readonly></td>
																			<td><input type="text" name="place"
																					   value="${travelreimburseAttach.place }" readonly>
																			</td>
																			<td>
																				<input type="hidden" name="projectId"
																					   value="${travelreimburseAttach.projectId }">
																				<textarea name="projectName"
																						  readonly>${travelreimburseAttach.project.name }</textarea>
																			</td>
																			<td><input type="text" name="cost" style="text-align:right"
																					   value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />"
																					   readonly></td>
																			<td><input type="text" name="actReimburse"
																					   style="text-align:right"
																					   value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />"
																					   readonly></td>
																			<td><textarea name="reason"
																						  readonly>${travelreimburseAttach.reason }</textarea>
																			</td>
																			<td><textarea name="detail"
																						  readonly>${travelreimburseAttach.detail }</textarea>
																			</td>
																			<shiro:hasPermission name="fin:reimburse:seeall">
																				<td style="width:100px;">
																					<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																							data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																				</td>
																			</shiro:hasPermission>
																		</tr>
																	</c:if>
																</c:forEach>
																</tbody>
															</table>
														</div>
													</div>
		                </div>
		                <hr>
		                <table class="end">
		                    <tr style="border-left-style:hidden;">
		                        <td class="td_right td_weight" style="width:8.3%;border-top-style:hidden;"><span>实报金额：</span>
		                        </td>
		                        <td style="width:92%;border-right-style:hidden;border-top-style:hidden;">
		                            <div style="display:flex">
		                                <div style="display:flex">
		                                    <span>¥</span>
		                                    <span id="Total">${map.business.total }</span>
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
		                <table id="reimbursetotal" class="end" style="margin-top:0;">
		                    <thead name="reimbursetotal">
		                    </thead>
		                </table>
		
		                <table class="end" style="margin-top:0px;">
		                    <tr style="border-left-style:hidden;">
		                        <td class="td_weight" style="width:7.4%;border-bottom-style:hidden;border-top-style:hidden;">
		                            <span>出差管理</span></td>
		                        <td style="text-align:left; width:80%;border-right-style:hidden;border-bottom-style:hidden;border-top-style:hidden;">
		                            <c:if test="${not empty map.business.travelId}">
		                                <span id="selectTravel" name="selectTravel"></span>
		                            </c:if>
		                        </td>
		                    </tr>
		                </table>
		
		                <table class="end" style="margin-top:0px;">
		                    <td class="td_right td_weight"
		                        style="width:8.4%; border-bottom:0px; border-left-style:hidden;border-bottom-style:hidden;">
		                        <span>附件：</span></td>
		                    <td colspan="20" style="border-bottom:0px;border-right-style:hidden;border-bottom-style:hidden;">
		                        <a href="javascript:void(0);" onclick="downloadAttach(this)"
		                           value="${map.business.attachments }" target='_blank'><input type="text" id="showName"
		                                                                                       name="showName"
		                                                                                       value="${map.business.attachName }"
		                                                                                       readonly></a>
		                    </td>
		                    <c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
		                        <td style="border-bottom:0px;border-bottom-style:hidden;">
		                            <c:if test="${not empty(map.business.attachments)}">
		                                <a href="javascript:void(0);" onclick="deleteAttach(this)"
		                                   value="${map.business.attachments }">删除</a>
		                            </c:if>
		                        </td>
		                    </c:if>
		                </table>
		                </td>
		                </tr>
                            		</shiro:lacksPermission>
                				</tbody>
                    <%-- </c:if> --%>
                </c:otherwise>
                </c:choose>
                <tfoot>
                <c:if test="${map.isHandler and map.task.name ne '提交申请' }">
                    <tr>
                        <td colspan="34">
                            <textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注"
                                      style="float:left;width:70%;height:100%;"></textarea>
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td colspan="34" style="text-align:center;border:none;padding-top:10px">
                        <%-- <button type="button" class="btn btn-primary" onclick="viewProcess(${map.business.processInstanceId})">查看流程图</button> --%>
                        <c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '部门经理' }">
                            <button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交
                            </button>
                            <button type="button" class="btn btn-primary" onclick="approve(5)">取消申请</button>
                            <!-- <button type="button" id="resetBtn" class="btn btn-default" onclick="location.replace(location.href)">重置</button> -->
                        </c:if>
                        <c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '部门经理' }">
                            <button type="button" class="btn btn-primary" onclick="save()">保存修改</button>
                        </c:if>
                        <c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') or (map.initiator.dept.id  eq '3' and map.task.name ne '部门经理') 
                        	or (map.initiator.dept.id eq '20' and map.task.name ne '部门经理') or (map.initiator.dept.id  eq '35' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '36' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '37' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '38' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '39' and map.task.name ne '部门经理'))
                        	and map.isHandler and map.task.name ne '提交申请' }">
                            <button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
                            <button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
                        </c:if>
                        <%-- <c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '部门经理'  and sessionScope.user.id ne '225'  and map.isHandler  and map.business.assistantStatus eq '1'}"> --%>
                        <c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '部门经理'  and sessionScope.user.id ne '225'  and map.isHandler}">
                            <button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
                            <button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
                        </c:if><!--
                         排除时用 ((map.business.assistantStatus eq '1' and map.initiator.id ne '61' and  map.initiator.id ne '87') or (map.initiator.id eq '61' or  map.initiator.id eq '87'))
                        -->

                        <c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
                            <!-- <button type="saveBtn" class="btn btn-primary" onclick="save()">保存修改</button> -->
                            <button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">保存并提交
                            </button>
                            <button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请
                            </button>
                        </c:if>
                        <c:if test="${(sessionScope.user.id == 2 or  sessionScope.user.id == 3) and map.task.name ne '提交申请'  and !map.isHandler }" >
							<button type="button" class="btn btn-primary" onclick="save()">保存</button>
						</c:if>
                        <c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
                            <button type="button" class="btn btn-primary"
                                    onclick="print(${map.business.processInstanceId })">打印
                            </button>
                        </c:if>
                        <c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and (sessionScope.user.id eq '8' or sessionScope.user.id eq '477' )}">
                            <button type="button" class="btn btn-primary"
                                    onclick="exportpdf(${map.business.processInstanceId })">导出PDF
                            </button>
                        </c:if>
                        <c:if test="${(map.initiator.dept.id  eq '3' or map.initiator.dept.id  eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39')&& map.task.name eq '部门经理'  && map.business.assistantStatus ne '1'}">
                            <shiro:hasPermission name="fin:reimburse:assistantAffirm">
                                <button type="button" class="btn btn-warning" onclick="assistantConfirm()">助手确认</button>
                                <button type="button" class="btn btn-danger" onclick="disagree()">不同意</button>
                            </shiro:hasPermission>
                        </c:if><%-- 排除时用  and map.initiator.id ne '61' and  map.initiator.id ne '87' --%>
                        <%-- <c:forEach items="${sessionScope.user.positionList }" var="position">
                         <c:if test="${ position.name eq '财务'  && (map.business.isSend eq '0' || map.business.isSend eq null) && map.business.status eq '6'  }">
                         <button type="button" class="btn btn-default" onclick="sendMail()">发送邮件</button>
                         </c:if>
                         </c:forEach> --%>
                        <button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回
                        </button>
                    </td>
                </tr>
                </tfoot>
                </table>
                </form>
            </div>
        </div>
</div>
</section>

<section class="content rlspace">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary tbspace">
                <table id="table2" style="width:97%;">
                    <thead>
                    <tr>
                        <th colspan="20">处 理 流 程</th>
                    </tr>
                    <tr>
                        <td class="td_weight" style="width:10%;">环节</td>
                        <td class="td_weight" style="width:9%">操作人</td>
                        <td class="td_weight" style="width:15%">操作时间</td>
                        <td class="td_weight" style="width:10%">操作结果</td>
                        <td class="td_weight" style="width:56%">操作备注</td>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</section>
</div>

<div id="deptDialog"></div>
<div id="projectDialog"></div>
<div id="travelDialog"></div>


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

<!-- 出差详细模态框（Modal） -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="travelModalLabel">出差详细</h4>
            </div>
            <div class="modal-body" style="overflow: auto;">
                <iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto"
                        style="height:100%;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- 流程图模态框（Modal） -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:80%; max-height: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    流程图
                </h4>
            </div>
            <div class="modal-body">
                <div id="imgcontainer"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <!-- <button type="button" class="btn btn-primary">选择</button> -->
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->


    <%@ include file="../../common/footer.jsp" %>
    <!-- 全局变量 -->
    <script type="text/javascript">
        base = "<%=base%>";
    </script>
    <script type="text/javascript"
            src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>

    <script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

    <shiro:hasPermission name="fin:travelreimburse:decrypt">
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
    </shiro:hasPermission>

    <script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
    <script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

    <script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/process.js"></script>
    	<script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-select.js"></script>
    <script>
        var hasDecryptPermission = false;
        <shiro:hasPermission name="fin:travelreimburse:decrypt">
        	hasDecryptPermission = true;
        </shiro:hasPermission>
    
        var seeAll;
        <c:if test="${(map.task.name eq '部门经理' or map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理')and map.isHandler}">
	        <shiro:hasPermission name="fin:reimburse:seeall">
	        	seeAll = true;
	        </shiro:hasPermission>
        </c:if>

        var variables = ${map.jsonMap.variables};
        var editInvest = false;
        var submitPhase = ""; // 提交阶段，用于判断是重新提交申请、财务修改还是没有表单操作
        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
        	submitPhase = "resubmit";
        </c:if>
        <c:if test="${((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler ) or (sessionScope.user.id == 2 or sessionScope.user.id  == 3 )}">
        	submitPhase = "othersubmit";
        </c:if>
        <c:if test="${((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
        	editInvest = true;
        </c:if>

        var ishavatrafficSubsidy = new Array() ;
        <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
        if(${travelreimburseAttach.type eq "4"}){
            if(${not empty(travelreimburseAttach.trafficSubsidy)}){
                ishavatrafficSubsidy.push(${travelreimburseAttach.trafficSubsidy});
            }
        }
        </c:forEach>

        var ishavatrafficTool = new Array();
        <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
	        if(${travelreimburseAttach.type eq "2"}){
	            if(${not empty(travelreimburseAttach.conveyance)}){
	                ishavatrafficTool.push(${travelreimburseAttach.conveyance});
	            }
	        }
        </c:forEach>
    </script>
</body>
</html>