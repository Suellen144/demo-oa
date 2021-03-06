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

        /* IE10???????????? */
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
            <li class="active">??????</li>
            <li class="active">????????????</li>
            <li class="active">??????</li>
            <li class="active">????????????</li>
            <li class="active">????????????</li>
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
	                        <c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '????????????' or map.task.name eq '????????????') }">
	                        	<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
	                        </c:when>
	                        <c:otherwise>
	                        	<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
	                        </c:otherwise>
	                    </c:choose>

                        <div style="text-align: center;font-weight: bolder;font-size: large;">
                            <thead>
	                            <tr>
	                                <th colspan="34">???????????????</th>
	                                <span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(???????????????${map.business.orderNo })</span>
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
                            <%-- ????????????????????? --%>
                            <c:choose>
	                            <c:when test="${ ((map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
									((map.task.name eq '??????' or map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler) or (sessionScope.user.id == 2 or sessionScope.user.id  == 3 )}">
		                            <tbody>
			                            <select id="conveyance_hidden" style="display:none;">
			                                <custom:dictSelect type="????????????????????????"/>
			                            </select>
			                            <select id="conveyance1_hidden" style="display: none">
			                                <custom:dictSelect type="???????????????????????????"/>
			                            </select>

			                            <!-- ??????????????? -->
			                            <tr>
			                                <td class="td_weight"><span>????????????</span></td>
			                                <td><input type="text" id="name" name="name" value="${map.business.name }"></td>
			                                <td class="td_weight"><span>????????????</span></td>
			                                <td style="line-height:20px;text-align:left;">
			                                    <select name="title">
			                                    	<custom:dictSelect type="??????????????????"  selectedValue="${map.business.title }"/>
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
			                                <td class="td_weight"><span>????????????</span></td>
			                                <td>
			                                    <input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>"
			                                           style="color:gray;" readonly>
			                                </td>
		                                    <%--<shiro:hasPermission name="fin:reimburse:seeall">--%>
		                                    <%--<td class="td_weight"><span>????????????</span></td>--%>
		                                    <%--<td style="width:100px;">--%>
		                                    <%--<select  type="text" style="width: 100%;" name="investId" value="${map.business.investId }"></select>--%>
		                                    <%--</td>--%>
		                                    <%--</shiro:hasPermission>--%>
	                            		</tr>
			                            <tr>
			                                <!-- ??????????????? -->
			                                <td class="td_weight"><span>?????????</span></td>
			                                <td style="width:5%;"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
			                                <td class="td_weight"><span>????????????</span></td>
			                                <td><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
			                                <td class="td_weight"><span>???????????????</span></td>
			                                <td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
			                            </tr>

			                            <!-- ??????????????? -->
			                            <tr>
			                            	<td colspan="22">
			                                    <div style="text-align:left;" class="tittle">
			                                        <a href="#intercityCost" data-toggle="collapse">???????????????</a>
			                                        <div id="myTabContent" class="tab-content">
			                                            <div class="panel-collapse collapse in" id="intercityCost">
			                                                <table style="width:100%;">
			                                                    <thead>
				                                                    <tr>
				                                                        <td class="td_weight" style="width: 10%; border-left-style:hidden;">??????</td>
				                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
				                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
				                                                        <td class="td_weight" style="width: 5.5%;">????????????</td>
				                                                        <td class="td_weight" style="width: 13%;">??????</td>
				                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
				                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
				                                                        <td class="td_weight" style="width: 18%;">??????</td>
				                                                        <td class="td_weight" style="width: 26.2%; border-right:none;">??????</td>
				                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
				                                                            <td class="td_weight" style="width: 4%; border-right-style:hidden;">??????</td>
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
				                                                                        <custom:dictSelect type="????????????????????????" selectedValue="${travelreimburseAttach.conveyance }"/>
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
				                                                                <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                    <!-- ????????? -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#stayCost" data-toggle="collapse" data-parent="#intercityCost">?????????</a>
		                                        <div class="panel-collapse collapse in" id="stayCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%; border-left-style:hidden;">??????</td>
			                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
			                                                    <td class="td_weight" style="width: 12%;">??????</td>
			                                                    <td class="td_weight" style="width: 5%;">???*???</td>
			                                                    <td class="td_weight" style="width: 5%;">??????</td>
			                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
			                                                    <td class="td_weight" style="width: 15%;">??????</td>
			                                                    <td class="td_weight" style="width: 21%;  border-right:none; ">??????</td>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;border-right: hidden">????????????
			                                                        </td>
			                                                    </c:if>
			                                                    <!--   <td class="td_weight" style="width: 11%;">??????</td> -->
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 3.3%; border-right-style:hidden;">??????</td>
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
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                       <%--  <select style="width: 100%;" name="attachInvestId" value="${travelreimburseAttach.attachInvestId}"></select> --%>
			                                                                       <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            </c:if>
			
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly ></td>
		                                                        <td><input type="text" name="costTotal" readonly></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                            <td colspan="2"><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- ??????????????? -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#cityCost" data-toggle="collapse">???????????????</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">??????</td>
			                                                    <td class="td_weight" style="width: 6%;">??????</td>
			                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">????????????</td>
			                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 22%;">??????</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler}">
			                                                        <td class="td_weight" style="width: 5.6%;border-right: hidden">???????????? </td>
			                                                    </c:if>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%; border-right-style:hidden;">??????</td>
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
			                                                                        <custom:dictSelect type="???????????????????????????"
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
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                        <%-- <select style="width: 100%;" name="attachInvestId"
			                                                                                value="${travelreimburseAttach.attachInvestId}"></select> --%>
			                                                                                <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            </c:if>
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                                <td></td>
			                                                            </c:if>
			                                                        </tr>
			                                                    </c:if>
			                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" name="costTotal" readonly ></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                            <td colspan="2"><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
		                                    <!-- ????????????-->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#receiveCost" data-toggle="collapse">????????????</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight"
		                                                        style="width: 8%; border-left-style:hidden;">??????
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">??????</td>
		                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 22%;">??????</td>
		                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
		                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%; border-left-style:hidden;">????????????
		                                                        </td>
		                                                    </c:if>
		                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                        <td class="td_weight"
		                                                            style="width: 4%;border-right-style:hidden;">??????
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
		                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
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
		                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                                <td></td>
		                                                            </c:if>
		                                                        </tr>
		                                                    </c:if>
		                                                </c:forEach>
		                                                    <%-- <tr name="subTotal">
		                                                        <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" name="costTotal" readonly ></td>
		                                                        <td><input type="text" name="actReimburseTotal" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <td><input type="text" readonly></td>
		                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                            <td><input type="text" readonly></td>
		                                                        </c:if>
		                                                    </tr> --%>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                    <hr>
                                    <!-- ?????? -->
                                    <div style="text-align:left;" class="tittle">
                                        <a href="#subsidy" data-toggle="collapse">??????</a>
                                        <div class="panel-collapse collapse in" id="subsidy">
                                            <table style="width:100%;">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="width: 7.7%; border-left-style:hidden;">???????????? </td>
                                                    <td class="td_weight" style="width: 7.1%;">????????????</td>
                                                    <td class="td_weight" style="width: 7%;">????????????</td>
                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">????????????</td>
                                                    <td class="td_weight" style="width: 14.7%;">??????</td>
                                                    <td class="td_weight" style="width: 22%;">??????</td>
                                                    <td class="td_weight" style="width: 26.4%;  border-right:none;"> ??????</td>
                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
                                                        <td class="td_weight"
                                                            style="width: 4%;border-right-style:hidden;">??????
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
                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
										<!-- ?????????-->
										<div style="text-align:left;" class="tittle">
											<a href="#business" data-toggle="collapse">????????????</a>
											<div class="panel-collapse collapse in" id="business">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight"
															style="width: 8%; border-left-style:hidden;">??????
														</td>
														<td class="td_weight" style="width: 6%;">??????</td>
														<td class="td_weight" style="width: 15.4%;">??????</td>
														<td class="td_weight" style="width: 7%;">??????</td>
														<td class="td_weight" style="width: 7%;">??????</td>
														<td class="td_weight" style="width: 22%;">??????</td>
														<td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
														<c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
															<td class="td_weight"
																style="width: 5.6%; border-left-style:hidden;">????????????
															</td>
														</c:if>
														<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
															<td class="td_weight"
																style="width: 4%;border-right-style:hidden;">??????
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
																<c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																</c:if>
																<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
										<!-- ?????????-->
										<div style="text-align:left;" class="tittle">
											<a href="#relationship" data-toggle="collapse">????????????</a>
											<div class="panel-collapse collapse in" id="relationship">
												<table style="width:100%;">
													<thead>
													<tr>
														<td class="td_weight"
															style="width: 8%; border-left-style:hidden;">??????
														</td>
														<td class="td_weight" style="width: 6%;">??????</td>
														<td class="td_weight" style="width: 15.4%;">??????</td>
														<td class="td_weight" style="width: 7%;">??????</td>
														<td class="td_weight" style="width: 7%;">??????</td>
														<td class="td_weight" style="width: 22%;">??????</td>
														<td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
														<c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
															<td class="td_weight"
																style="width: 5.6%; border-left-style:hidden;">????????????
															</td>
														</c:if>
														<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
															<td class="td_weight"
																style="width: 4%;border-right-style:hidden;">??????
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
																<c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td style="width:100px;">
																			<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false"
																					data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
																		</td>
																	</shiro:hasPermission>
																</c:if>
																<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
                                                <span>???????????????</span></td>
                                            <td style="width:92%;border-right-style:hidden;">
                                                <div style="display:flex">
                                                    <div style="display:flex">
                                                        <span>??</span>
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
                                                <span>????????????</span></td>
                                            <td colspan="20" style="text-align:left; border:none;">
                                                <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
                                                    <input type="button" style="border:none" value="?????????????????????"
                                                           onclick="openTravel()">
                                                </c:if>
                                                <span id="selectTravel" name="selectTravel"></span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="end" style="margin-top:0;">
                                        <td class="td_right td_weight"
                                            style="width:8%; border-left-style:hidden; border-bottom:0px;">
                                            <span>?????????</span>
                                        </td>
                                        <td colspan="20" style="border-bottom:0px; border-right-style:hidden;">
                                            <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
											</a>
                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                        <td style="border-bottom:0px;">
		                                        	<input type="file" id="file" name="file" style="display:none">
		                                            <input type="button" value="????????????" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
		                                        </td>
                                        	</c:if>
	                                        <c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
	                                            <td style="border-bottom:0px; border-right-style:hidden;">
	                                                <c:if test="${ not empty(map.business.attachments)}">
	                                                    <a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">??????</a>
	                                                </c:if>
	                                                <c:if test="${empty(map.business.attachments)}">
														<input type="file" id="file" name="file" style="display:none;">
														<input type="button" value="????????????" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
													</c:if>
	                                            </td>
	                                        </c:if>
                                        </td>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                            </c:when>
                            
                            <%-- ???????????????????????????????????? --%>
                            <%-- <c:if test="${(map.task.name ne '????????????' and map.task.name ne '????????????') or map.business.userId ne sessionScope.user.id }"> --%>
                            <c:otherwise>
                            	<tbody>
                            		<shiro:hasPermission name="fin:reimburse:modify">
                            			<select id="conveyance_hidden" style="display:none;">
		                                <custom:dictSelect type="????????????????????????"/>
		                            </select>
		                            <select id="conveyance1_hidden" style="display: none">
		                                <custom:dictSelect type="???????????????????????????"/>
		                            </select>

		                            <!-- ??????????????? -->
		                            <tr>
		                                <td class="td_weight"><span>????????????</span></td>
		                                <td><input type="text" id="name" name="name" value="${map.business.name }"></td>
		                                <td class="td_weight"><span>????????????</span></td>
		                                <td style="line-height:20px;text-align:left;">
		                                    <select name="title">
		                                    	<custom:dictSelect type="??????????????????"  selectedValue="${map.business.title }"/>
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
		                                <td class="td_weight"><span>????????????</span></td>
		                                <td>
		                                    <input type="text" id="applyTime" name="applyTime"
		                                           value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>"
		                                           style="color:gray;" readonly>
		                                </td>
                            		</tr>
		                            <tr>
		                                <!-- ??????????????? -->
		                                <td class="td_weight"><span>?????????</span></td>
		                                <td style="width:5%;"><input type="text" id="payee" name="payee" value="${map.business.payee }"></td>
		                                <td class="td_weight"><span>????????????</span></td>
		                                <td><input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }"></td>
		                                <td class="td_weight"><span>???????????????</span></td>
		                                <td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }"></td>
		                            </tr>

		                            <!-- ??????????????? -->
		                            <tr>
		                            	<td colspan="22">
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#intercityCost" data-toggle="collapse">???????????????</a>
		                                        <div id="myTabContent" class="tab-content">
		                                            <div class="panel-collapse collapse in" id="intercityCost">
		                                                <table style="width:100%;">
		                                                    <thead>
			                                                    <tr>
			                                                        <td class="td_weight" style="width: 10%; border-left-style:hidden;">??????</td>
			                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
			                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
			                                                        <td class="td_weight" style="width: 5.5%;">????????????</td>
			                                                        <td class="td_weight" style="width: 13%;">??????</td>
			                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
			                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
			                                                        <td class="td_weight" style="width: 18%;">??????</td>
			                                                        <td class="td_weight" style="width: 26.2%; border-right:none;">??????</td>
			                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                            <td class="td_weight" style="width: 4%; border-right-style:hidden;">??????</td>
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
			                                                                        <custom:dictSelect type="????????????????????????" selectedValue="${travelreimburseAttach.conveyance }"/>
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
			                                                                <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                    <!-- ????????? -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#stayCost" data-toggle="collapse" data-parent="#intercityCost">?????????</a>
		                                        <div class="panel-collapse collapse in" id="stayCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight"
			                                                        style="width: 8%; border-left-style:hidden;">??????
			                                                    </td>
			                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
			                                                    <td class="td_weight" style="width: 12%;">??????</td>
			                                                    <td class="td_weight" style="width: 5%;">???*???</td>
			                                                    <td class="td_weight" style="width: 5%;">??????</td>
			                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
			                                                    <td class="td_weight" style="width: 15%;">??????</td>
			                                                    <td class="td_weight" style="width: 21%;  border-right:none; ">??????</td>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">????????????
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <%-- <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;border-right: hidden">????????????
			                                                        </td>
			                                                    </c:if> --%>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight"
			                                                            style="width: 3.3%; border-right-style:hidden;">??????
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
			                                                           <%--  <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}"> --%>
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
			
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                    <!-- ??????????????? -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#cityCost" data-toggle="collapse">???????????????</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 6.9%;border-left-style:hidden;"></td>
			                                                    <td class="td_weight" style="width: 6%;">??????</td>
			                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">????????????</td>
			                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 22%;">??????</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
			                                                    <%-- <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                        <td class="td_weight" style="width: 5.6%;border-right: hidden">????????????</td>
			                                                    </c:if> --%>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">????????????
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%; border-right-style:hidden;">??????</td>
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
			                                                                        <custom:dictSelect type="???????????????????????????"  selectedValue="${travelreimburseAttach.conveyance }"/>
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
			                                                            <%-- <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler}"> --%>
			                                                                <shiro:hasPermission name="fin:reimburse:seeall">
			                                                                    <td style="width:100px;">
			                                                                        <%-- <select style="width: 100%;" name="attachInvestId" value="${travelreimburseAttach.attachInvestId}">
			                                                                        </select> --%>
			                                                                        <select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
			                                                                    </td>
			                                                                </shiro:hasPermission>
			                                                            <%-- </c:if> --%>
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                    <!-- ????????????-->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#receiveCost" data-toggle="collapse">????????????</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 8%; border-left-style:hidden;">?????? </td>
			                                                    <td class="td_weight" style="width: 6%;">??????</td>
			                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 7%;">??????</td>
			                                                    <td class="td_weight" style="width: 22%;">??????</td>
			                                                    <td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
			                                                    <shiro:hasPermission name="fin:reimburse:seeall">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%;border-right: hidden;">????????????
			                                                        </td>
			                                                    </shiro:hasPermission>
			                                                    <%-- <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
			                                                        <td class="td_weight"
			                                                            style="width: 5.6%; border-left-style:hidden;">????????????
			                                                        </td>
			                                                    </c:if> --%>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%;border-right-style:hidden;">??????</td>
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
				                                                        <%-- <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}"> --%>
				                                                        	<shiro:hasPermission name="fin:reimburse:seeall">
				                                                            	<td style="width:100px;">
				                                                                	<%-- <select style="width: 100%;" name="attachInvestId"
				                                                                    	value="${travelreimburseAttach.attachInvestId}"></select> --%>
				                                                                    	<select style="width:100%;" name="attachInvestId" class="selectpicker show-tick form-control " multiple data-live-search="false" 
			                                                                       data-selected-text-format="count > 2" data-v="${travelreimburseAttach.attachInvestIdStr eq '' or travelreimburseAttach.attachInvestIdStr == null?travelreimburseAttach.attachInvestId:travelreimburseAttach.attachInvestIdStr}"></select>
				                                                                </td>
				                                                            </shiro:hasPermission>
				                                                        <%-- </c:if> --%>
				                                                        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                    <!-- ?????? -->
		                                    <div style="text-align:left;" class="tittle">
		                                        <a href="#subsidy" data-toggle="collapse">??????</a>
		                                        <div class="panel-collapse collapse in" id="subsidy">
		                                            <table style="width:100%;">
		                                                <thead>
			                                                <tr>
			                                                    <td class="td_weight" style="width: 7.7%; border-left-style:hidden;">????????????</td>
			                                                    <td class="td_weight" style="width: 7.1%;">????????????</td>
			                                                    <td class="td_weight" style="width: 7%;">????????????</td>
			                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">????????????</td>
			                                                    <td class="td_weight" style="width: 14.7%;">??????</td>
			                                                    <td class="td_weight" style="width: 22%;">??????</td>
			                                                    <td class="td_weight" style="width: 26.4%;  border-right:none; ">??????</td>
			                                                    <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
			                                                        <td class="td_weight" style="width: 4%;border-right-style:hidden;">??????</td>
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
			                                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
											<!-- ?????????-->
											<div style="text-align:left;" class="tittle">
												<a href="#business" data-toggle="collapse">????????????</a>
												<div class="panel-collapse collapse in" id="business">
													<table style="width:100%;">
														<thead>
														<tr>
															<td class="td_weight" style="width: 8%; border-left-style:hidden;">?????? </td>
															<td class="td_weight" style="width: 6%;">??????</td>
															<td class="td_weight" style="width: 15.4%;">??????</td>
															<td class="td_weight" style="width: 7%;">??????</td>
															<td class="td_weight" style="width: 7%;">??????</td>
															<td class="td_weight" style="width: 22%;">??????</td>
															<td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
															<shiro:hasPermission name="fin:reimburse:seeall">
																<td class="td_weight"
																	style="width: 5.6%;border-right: hidden;">????????????
																</td>
															</shiro:hasPermission>
															<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
																<td class="td_weight" style="width: 4%;border-right-style:hidden;">??????</td>
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
																	<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
											<!-- ?????????-->
											<div style="text-align:left;" class="tittle">
												<a href="#relationship" data-toggle="collapse">????????????</a>
												<div class="panel-collapse collapse in" id="relationship">
													<table style="width:100%;">
														<thead>
														<tr>
															<td class="td_weight" style="width: 8%; border-left-style:hidden;">?????? </td>
															<td class="td_weight" style="width: 6%;">??????</td>
															<td class="td_weight" style="width: 15.4%;">??????</td>
															<td class="td_weight" style="width: 7%;">??????</td>
															<td class="td_weight" style="width: 7%;">??????</td>
															<td class="td_weight" style="width: 22%;">??????</td>
															<td class="td_weight" style="width: 26%;  border-right:none; ">??????</td>
															<shiro:hasPermission name="fin:reimburse:seeall">
																<td class="td_weight"
																	style="width: 5.6%;border-right: hidden;">????????????
																</td>
															</shiro:hasPermission>
															<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
																<td class="td_weight" style="width: 4%;border-right-style:hidden;">??????</td>
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
																	<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
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
		                                                <span>???????????????</span>
		                                            </td>
		                                            <td style="width:92%;border-right-style:hidden;">
		                                                <div style="display:flex">
		                                                    <div style="display:flex">
		                                                        <span>??</span>
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
		                                                <span>????????????</span>
		                                            </td>
		                                            <td colspan="20" style="text-align:left; border:none;">
		                                                <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
		                                                    <input type="button" style="border:none" value="?????????????????????" onclick="openTravel()">
		                                                </c:if>
		                                                <span id="selectTravel" name="selectTravel"></span>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                    <table class="end" style="margin-top:0;">
		                                        <td class="td_right td_weight" style="width:8%; border-left-style:hidden; border-bottom:0px;">
		                                            <span>?????????</span>
		                                        </td>
		                                        <td colspan="20" style="border-bottom:0px; border-right-style:hidden;">
		                                            <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
		                                               <input type="text" id="showName" name="showName" value="${map.business.attachName }" readonly>
		                                            </a>
		                                            <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
				                                        <td style="border-bottom:0px;">
				                                        	<input type="file" id="file" name="file" style="display:none">
				                                            <input type="button" value="????????????" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
				                                        </td>
		                                        	</c:if>
			                                        <c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11' or map.business.status eq '1')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
			                                            <td style="border-bottom:0px; border-right-style:hidden;">
			                                                <c:if test="${ not empty(map.business.attachments)}">
			                                                    <a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">??????</a>
			                                                </c:if>
			                                                <c:if test="${empty(map.business.attachments)}">
																<input type="file" id="file" name="file" style="display:none;">
																<input type="button" value="????????????" onclick="$('#file').click()" style="border:none;float:right;" href="javascript:;">
															</c:if>
			                                            </td>
			                                        </c:if>
		                                        </td>
		                                    </table>
		                                </td>
		                            </tr>
                            		</shiro:hasPermission>
                            		<shiro:lacksPermission name="fin:reimburse:modify">
                            			<!-- ??????????????? -->
				                            <tr>
				                                <td class="td_weight"><span>????????????</span></td>
				                                <td><input type="text" id="name" name="name" value="${map.business.name }" readonly></td>
				                                <td class="td_weight"><span>????????????</span></td>
				                                <td colspan="2" style="line-height:20px;text-align:left;">
				                                    <custom:getDictKey type="??????????????????" value="${map.business.title }"/>
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
				                                <td class="td_weight"><span>????????????</span></td>
				                                <td>
				                                	<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value='${map.business.applyTime }' pattern='yyyy-MM-dd'/>" readonly>
				                                </td>
				                                    <%--<shiro:hasPermission name="fin:reimburse:seeall">--%>
				                                    <%--<td class="td_weight"><span>????????????34</span></td>--%>
				                                    <%--<td colspan="2" style="text-align:left;">--%>
				                                    <%--<select  type="text" style="width: 100%;" name="investId" value="${map.business.investId }"></select>--%>
				                                    <%--</td> --%>
				                                    <%--</shiro:hasPermission>--%>
				                            </tr>
				                            <!-- ??????????????? -->
				                            <tr>
				                                <td class="td_weight"><span>?????????</span></td>
				                                <td style="width:10%">
				                                	<input type="text" id="payee" name="payee" style="text-align:center;" value="${map.business.payee }" readonly>
				                                </td>
				                                <td class="td_weight"><span>????????????</span></td>
				                                <td>
				                                	<input type="text" id="bankAccount" name="bankAccount" value="${map.business.bankAccount }" readonly>
				                                </td>
				                                <td class="td_weight"><span>???????????????</span></td>
				                                <td colspan="3">
				                                	<input type="text" id="bankAddress" name="bankAddress" value="${map.business.bankAddress }" readonly>
				                                </td>
				                            </tr>
		
				                            <!-- ??????????????? -->
				                            <tr>
				                                <td colspan="22">
				                                    <div style="text-align:left;" class="tittle">
				                                    	<a href="#intercityCost" data-toggle="collapse">???????????????</a>
				                                        <div id="myTabContent" class="tab-content">
				                                            <div class="panel-collapse collapse in" id="intercityCost">
				                                                <table style="width:100%;">
				                                                    <thead>
					                                                    <tr>
					                                                        <td class="td_weight"
					                                                            style="width: 10%; border-left-style:hidden;">??????
					                                                        </td>
					                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
					                                                        <td class="td_weight" style="width: 5.5%;">?????????</td>
					                                                        <td class="td_weight" style="width: 5.5%;">????????????</td>
					                                                        <td class="td_weight" style="width: 13%;">??????</td>
					                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
					                                                        <td class="td_weight" style="width: 5.5%;">??????</td>
					                                                        <td class="td_weight" style="width: 18%;">??????</td>
					                                                        <td class="td_weight"
					                                                            style="width: 26.2%; border-right-style:hidden;">??????
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
					                                                                           value="<custom:getDictKey type="????????????????????????" value="${travelreimburseAttach.conveyance }"/>"
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
				                                                            <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
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
				                                    <!-- ????????? -->
				                                    <div style="text-align:left;" class="tittle">
				                                    	<a href="#stayCost" data-toggle="collapse">?????????</a>
				                                        <div class="panel-collapse collapse in" id="stayCost">
				                                            <table style="width:100%;">
				                                                <thead>
				                                                <tr>
				                                                    <td class="td_weight"
				                                                        style="width: 8%; border-left-style:hidden;">??????
				                                                    </td>
				                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
				                                                    <td class="td_weight" style="width: 12%;">??????</td>
				                                                    <td class="td_weight" style="width: 5%;">???*???</td>
				                                                    <td class="td_weight" style="width: 5%;">??????</td>
				                                                    <td class="td_weight" style="width: 4.8%;">??????</td>
				                                                    <td class="td_weight" style="width: 15%;">??????</td>
				                                                    <td class="td_weight"
				                                                        style="width: 21%;">??????
				                                                    </td>
				                                                    <shiro:hasPermission name="fin:reimburse:seeall">
				                                                        <td class="td_weight"
				                                                            style="width: 5.6%;border-right: hidden;">????????????
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
				                                                    <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
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
		                                    <!-- ??????????????? -->
		                                    <div style="text-align:left;" class="tittle"><a href="#cityCost"
		                                                                                    data-toggle="collapse">???????????????</a>
		                                        <div class="panel-collapse collapse in" id="cityCost">
		                                            <table style="width:100%">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">
		                                                        ??????
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">??????</td>
		                                                    <td class="td_weight trafficT" style="width: 3%;display: none;white-space: nowrap">????????????</td>
		                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 22%;">??????</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26%;">??????
		                                                    </td>
		                                                    <shiro:hasPermission name="fin:reimburse:seeall">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%;border-right: hidden">????????????
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
		                                                                           value="<custom:getDictKey type="???????????????????????????" value="${travelreimburseAttach.conveyance }"/>"
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
		                                                    <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
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

		                                    <!-- 	????????????-->
		                                    <div style="text-align:left;" class="tittle"><a href="#receiveCost"
		                                                                                    data-toggle="collapse">????????????</a>
		                                        <div class="panel-collapse collapse in" id="receiveCost">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight" style="width: 8%;border-left-style:hidden;">
		                                                        ??????
		                                                    </td>
		                                                    <td class="td_weight" style="width: 6%;">??????</td>
		                                                    <td class="td_weight" style="width: 15.4%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 7%;">??????</td>
		                                                    <td class="td_weight" style="width: 22%;">??????</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26%;">??????
		                                                    </td>
		                                                    <shiro:hasPermission name="fin:reimburse:seeall">
		                                                        <td class="td_weight"
		                                                            style="width: 5.6%;border-right: hidden">????????????
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
		                                                        <td colspan="2" class="td_right td_weight"><span>?????????</span></td>
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
		                                    <!-- ?????? -->
		                                    <div style="text-align:left;" class="tittle"><a href="#subsidy"
		                                                                                    data-toggle="collapse">??????</a>
		                                        <div class="panel-collapse collapse in" id="subsidy">
		                                            <table style="width:100%;">
		                                                <thead>
		                                                <tr>
		                                                    <td class="td_weight"
		                                                        style="width: 7.7%; border-left-style:hidden;">????????????
		                                                    </td>
		                                                    <td class="td_weight" style="width: 7.1%;">????????????</td>
		                                                    <td class="td_weight" style="width: 7%;">????????????</td>
		                                                    <td class="td_weight trafficSubsidy" style="width: 7%;">????????????</td>
		                                                    <td class="td_weight" style="width: 14.7%;">??????</td>
		                                                    <td class="td_weight" style="width: 22%;">??????</td>
		                                                    <td class="td_weight"
		                                                        style="width: 26.4%; border-right-style:hidden;">??????
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
																	<td colspan="2" class="td_right td_weight"><span>?????????</span></td>
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
													<!-- 	?????????-->
													<div style="text-align:left;" class="tittle"><a href="#business"
																									data-toggle="collapse">????????????</a>
														<div class="panel-collapse collapse in" id="business">
															<table style="width:100%;">
																<thead>
																<tr>
																	<td class="td_weight" style="width: 8%;border-left-style:hidden;">
																		??????
																	</td>
																	<td class="td_weight" style="width: 6%;">??????</td>
																	<td class="td_weight" style="width: 15.4%;">??????</td>
																	<td class="td_weight" style="width: 7%;">??????</td>
																	<td class="td_weight" style="width: 7%;">??????</td>
																	<td class="td_weight" style="width: 22%;">??????</td>
																	<td class="td_weight"
																		style="width: 26%;">??????
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td class="td_weight"
																			style="width: 5.6%;border-right: hidden">????????????
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
													<!-- 	?????????-->
													<div style="text-align:left;" class="tittle">
														<a href="#relationship" data-toggle="collapse">????????????</a>
														<div class="panel-collapse collapse in" id="relationship">
															<table style="width:100%;">
																<thead>
																<tr>
																	<td class="td_weight" style="width: 8%;border-left-style:hidden;">
																		??????
																	</td>
																	<td class="td_weight" style="width: 6%;">??????</td>
																	<td class="td_weight" style="width: 15.4%;">??????</td>
																	<td class="td_weight" style="width: 7%;">??????</td>
																	<td class="td_weight" style="width: 7%;">??????</td>
																	<td class="td_weight" style="width: 22%;">??????</td>
																	<td class="td_weight"
																		style="width: 26%;">??????
																	</td>
																	<shiro:hasPermission name="fin:reimburse:seeall">
																		<td class="td_weight"
																			style="width: 5.6%;border-right: hidden">????????????
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
		                        <td class="td_right td_weight" style="width:8.3%;border-top-style:hidden;"><span>???????????????</span>
		                        </td>
		                        <td style="width:92%;border-right-style:hidden;border-top-style:hidden;">
		                            <div style="display:flex">
		                                <div style="display:flex">
		                                    <span>??</span>
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
		                            <span>????????????</span></td>
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
		                        <span>?????????</span></td>
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
		                                   value="${map.business.attachments }">??????</a>
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
                <c:if test="${map.isHandler and map.task.name ne '????????????' }">
                    <tr>
                        <td colspan="34">
                            <textarea id="comment" name="comment" rows="2" cols="70" placeholder="???????????????"
                                      style="float:left;width:70%;height:100%;"></textarea>
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td colspan="34" style="text-align:center;border:none;padding-top:10px">
                        <%-- <button type="button" class="btn btn-primary" onclick="viewProcess(${map.business.processInstanceId})">???????????????</button> --%>
                        <c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '????????????' }">
                            <button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">??????
                            </button>
                            <button type="button" class="btn btn-primary" onclick="approve(5)">????????????</button>
                            <!-- <button type="button" id="resetBtn" class="btn btn-default" onclick="location.replace(location.href)">??????</button> -->
                        </c:if>
                        <c:if test="${map.isHandler and map.task.name ne '????????????' and map.task.name ne '????????????' }">
                            <button type="button" class="btn btn-primary" onclick="save()">????????????</button>
                        </c:if>
                        <c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') or (map.initiator.dept.id  eq '3' and map.task.name ne '????????????') 
                        	or (map.initiator.dept.id eq '20' and map.task.name ne '????????????') or (map.initiator.dept.id  eq '35' and map.task.name ne '????????????') or (map.initiator.dept.id eq '36' and map.task.name ne '????????????') or (map.initiator.dept.id eq '37' and map.task.name ne '????????????') or (map.initiator.dept.id eq '38' and map.task.name ne '????????????') or (map.initiator.dept.id eq '39' and map.task.name ne '????????????'))
                        	and map.isHandler and map.task.name ne '????????????' }">
                            <button type="button" class="btn btn-primary" onclick="approve(2)">??????</button>
                            <button type="button" class="btn btn-warning" onclick="approve(3)">?????????</button>
                        </c:if>
                        <%-- <c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '????????????'  and sessionScope.user.id ne '225'  and map.isHandler  and map.business.assistantStatus eq '1'}"> --%>
                        <c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35' or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39') and map.task.name eq '????????????'  and sessionScope.user.id ne '225'  and map.isHandler}">
                            <button type="button" class="btn btn-primary" onclick="approve(2)">??????</button>
                            <button type="button" class="btn btn-warning" onclick="approve(3)">?????????</button>
                        </c:if><!--
                         ???????????? ((map.business.assistantStatus eq '1' and map.initiator.id ne '61' and  map.initiator.id ne '87') or (map.initiator.id eq '61' or  map.initiator.id eq '87'))
                        -->

                        <c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '????????????' }">
                            <!-- <button type="saveBtn" class="btn btn-primary" onclick="save()">????????????</button> -->
                            <button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">???????????????
                            </button>
                            <button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">????????????
                            </button>
                        </c:if>
                        <c:if test="${(sessionScope.user.id == 2 or  sessionScope.user.id == 3) and map.task.name ne '????????????'  and !map.isHandler }" >
							<button type="button" class="btn btn-primary" onclick="save()">??????</button>
						</c:if>
                        <c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
                            <button type="button" class="btn btn-primary"
                                    onclick="print(${map.business.processInstanceId })">??????
                            </button>
                        </c:if>
                        <c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and (sessionScope.user.id eq '8' or sessionScope.user.id eq '477' )}">
                            <button type="button" class="btn btn-primary"
                                    onclick="exportpdf(${map.business.processInstanceId })">??????PDF
                            </button>
                        </c:if>
                        <c:if test="${(map.initiator.dept.id  eq '3' or map.initiator.dept.id  eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39')&& map.task.name eq '????????????'  && map.business.assistantStatus ne '1'}">
                            <shiro:hasPermission name="fin:reimburse:assistantAffirm">
                                <button type="button" class="btn btn-warning" onclick="assistantConfirm()">????????????</button>
                                <button type="button" class="btn btn-danger" onclick="disagree()">?????????</button>
                            </shiro:hasPermission>
                        </c:if><%-- ????????????  and map.initiator.id ne '61' and  map.initiator.id ne '87' --%>
                        <%-- <c:forEach items="${sessionScope.user.positionList }" var="position">
                         <c:if test="${ position.name eq '??????'  && (map.business.isSend eq '0' || map.business.isSend eq null) && map.business.status eq '6'  }">
                         <button type="button" class="btn btn-default" onclick="sendMail()">????????????</button>
                         </c:if>
                         </c:forEach> --%>
                        <button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">??????
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
                        <th colspan="20">??? ??? ??? ???</th>
                    </tr>
                    <tr>
                        <td class="td_weight" style="width:10%;">??????</td>
                        <td class="td_weight" style="width:9%">?????????</td>
                        <td class="td_weight" style="width:15%">????????????</td>
                        <td class="td_weight" style="width:10%">????????????</td>
                        <td class="td_weight" style="width:56%">????????????</td>
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


<!-- ????????????????????????Modal??? -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
    	<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">????????????????????????</h4>
         	</div>
	        <div class="modal-body">
				<p>
					??????????????????  ??????????????????
				</p>
	        	<p>
					    <span style="font-size:19px">1</span><span style="font-size:19px;font-family:??????">????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">0</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????</span><span style="font-family: ??????; font-size: 19px;">????????????????????????????????????????????????????????????????????????????????????</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695004905.png" _src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"/>
					</p>
					<p>
					    <span style="font-size:19px">2</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><img src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png" _src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"/>
					</p>
					<p>
					    <span style="font-size:19px">3</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695286246.png" _src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"/>
					</p>
					<p>
					    <span style="font-size:19px;font-family:??????"><span style="font-size:19px;font-family: &#39;Calibri&#39;,sans-serif">4</span><span style="font-size:19px;font-family:??????">???</span>???????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:??????">?????????????????????????????????</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family: ??????">??????</span><span style="font-size: 19px;font-family: Arial, sans-serif;color: rgb(51, 51, 51)">???</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family:??????">??????</span><span style="font-size:19px">+</span><span style="font-size:19px;font-family: ??????">???????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:??????">????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">8</span><span style="font-size:19px;font-family:??????">??????????????????????????????</span><span style="font-size:19px">11</span><span style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span style="font-size:19px">(</span><span style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span style="font-size:19px">)</span><span style="font-size:19px;font-family: ??????">???</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695342507.png" _src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"/>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" _src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" style="width: 900px; height: 744px;"/><img src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" _src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" style="width: 750px; height: 708px;"/>
					</p>
					<p>
					    <span style="font-size:19px">5</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
					</p>
					<p>
					    <img src="http://www.reyzar.com/images/upload/20181008/1507695123456.png" _src="http://www.reyzar.com/images/upload/20181008/1507695123456.png" style="width: 940px;"/><img src="http://www.reyzar.com/images/upload/20181008/1507695654321.png" _src="http://www.reyzar.com/images/upload/20181008/1507695654321.png" style="width: 1000px;"/>
					</p>
					<p>
					    <span style="font-size:19px">6</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
					</p>
					<p></p>
					<p>
					    <br/>
			</p>
			</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- ????????????????????????Modal??? -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="travelModalLabel">????????????</h4>
            </div>
            <div class="modal-body" style="overflow: auto;">
                <iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto"
                        style="height:100%;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
            </div>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- ?????????????????????Modal??? -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:80%; max-height: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    ?????????
                </h4>
            </div>
            <div class="modal-body">
                <div id="imgcontainer"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <!-- <button type="button" class="btn btn-primary">??????</button> -->
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->


    <%@ include file="../../common/footer.jsp" %>
    <!-- ???????????? -->
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
        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????')and map.isHandler}">
	        <shiro:hasPermission name="fin:reimburse:seeall">
	        	seeAll = true;
	        </shiro:hasPermission>
        </c:if>

        var variables = ${map.jsonMap.variables};
        var editInvest = false;
        var submitPhase = ""; // ???????????????????????????????????????????????????????????????????????????????????????
        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
        	submitPhase = "resubmit";
        </c:if>
        <c:if test="${((map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler ) or (sessionScope.user.id == 2 or sessionScope.user.id  == 3 )}">
        	submitPhase = "othersubmit";
        </c:if>
        <c:if test="${((map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler) }">
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