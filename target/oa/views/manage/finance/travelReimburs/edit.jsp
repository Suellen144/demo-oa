<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp" %>
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

        #table1 td input[name="name"], input[name="applyTime"], input[name="payee"], input[name="bankAddress"] {
            text-align: center;
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

        textarea {
            resize: none;
            border: none;
            outline: medium;
            width: 100%;
        }

        textarea[name="projectName"], textarea[name="reason"], textarea[name="detail"] {
            padding-top: 10px;
            text-align: left;
        }

        .end {
            width: 100%;
            border-top-style: hidden;
        }

        .datetimepick {
            text-align: center;
        }

        /* IE10???????????? */
        select::-ms-expand {
            display: none;
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
                        <div style="text-align: center;font-weight: bolder;font-size: large;">
                            <thead>
                            <tr>
                                <th colspan="34">???????????????</th>
                                <i class="icon-question-sign" style="cursor:pointer" onclick="showhelp()"> </i>
                                <span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(???????????????${travelreimburse.orderNo })</span>
                            </tr>
                            </thead>
                        </div>
                        <table id="table1">
                            <tbody>
                            <input type="hidden" id="id" name="id" value="${travelreimburse.id }">
                            <input type="hidden" id="deptId" name="deptId" value="${travelreimburse.deptId}">
                            <input type="hidden" id="attachments" name="attachments"
                                   value="${travelreimburse.attachments }">
                            <input type="hidden" id="attachName" name="attachName"
                                   value="${travelreimburse.attachName }">
                            <input type="hidden" id="travelId" name="travelId" value="${travelreimburse.travelId }">
                            <input type="hidden" id="travelProcessInstanceIds" value="${travelProcessInstanceIds}">
                            <input type="hidden" id="issubmit" name="issubmit" value="">
                            <input type="hidden" id="orderNo" name="orderNo" value="${travelreimburse.orderNo}">
                            <input type="hidden" id="total" name="total" readonly>
                            <input type="hidden" id="totalcn" readonly>
                            <select id="conveyance_hidden" style="display:none;">
                                <custom:dictSelect type="????????????????????????"/>
                            </select>
                            <select id="conveyance1_hidden" style="display: none">
                                <custom:dictSelect type="???????????????????????????"/>
                            </select>
                            <!-- ??????????????? -->
                            <tr>
                                <td class="td_weight"><span>????????????</span></td>
                                <td>
                                    <input type="text" id="name" name="name" value="${travelreimburse.name }">
                                </td>

                                <td class="td_weight"><span>????????????</span></td>
                                <td style="line-height:20px;text-align:left;">
                                    <c:if test="${sessionScope.user.dept.name ne '???????????????' and sessionScope.user.dept.name ne '???????????????'}">
                                        <select name="title" style="height:20px;text-align:left;"><custom:dictSelect
                                                type="??????????????????" selectedValue="${travelreimburse.title }"/></select>
                                    </c:if>
                                    <c:if test="${sessionScope.user.dept.name eq '???????????????' or sessionScope.user.dept.name eq '???????????????'}">
                                        <input name="title" value="10" type="hidden">
                                        <custom:getDictKey type="??????????????????" value="10"/>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${empty(travelreimburse.dept.alias)}">
                                            <input type="text"
                                                   style="height:20px;width:auto;text-align:left;font-size:14px;margin-left: -5px;"
                                                   id="deptName" name="deptName" onclick="openDept()"
                                                   value="${travelreimburse.dept.name }" readonly>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text"
                                                   style="height:20px;width:auto;text-align:left;font-size:14px;margin-left: -5px;"
                                                   id="deptName" name="deptName" onclick="openDept()" value="" readonly>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="td_weight"><span>????????????</span></td>
                                <td colspan="4">
                                    <input type="text" id="applyTime" name="applyTime"
                                           value="<fmt:formatDate value='${travelreimburse.applyTime}' pattern='yyyy-MM-dd'/>"
                                           readonly>
                                </td>
                            </tr>
                            </tr>
                            <tr>
                                <td class="td_weight"><span>?????????</span></td>
                                <td style="width:5%;"><input type="text" id="payee" name="payee"
                                                             value="${travelreimburse.payee }"></td>
                                <td class="td_weight"><span>????????????</span></td>
                                <td><input type="text" id="bankAccount" name="bankAccount"
                                           value="${travelreimburse.bankAccount }"></td>
                                <td class="td_weight"><span>???????????????</span></td>
                                <td colspan="6"><input type="text" id="bankAddress" name="bankAddress"
                                                       value="${travelreimburse.bankAddress }"></td>
                            </tr>
                            <tr>
                                <td colspan="22">
                                    <div style="text-align:left;">
                                        <a href="#intercityCost" data-toggle="collapse">???????????????</a>
                                        <div id="myTabContent" class="tab-content">
                                            <!-- ??????????????? -->
                                            <div class="panel-collapse collapse in" id="intercityCost">
                                                <table style="width: 100%;">
                                                    <thead>
                                                    <tr>
                                                        <td class="td_weight" style="border-left-style:hidden;">??????</td>
                                                        <td class="td_weight">?????????</td>
                                                        <td class="td_weight">?????????</td>
                                                        <td class="td_weight">????????????</td>
                                                        <td class="td_weight">??????</td>
                                                        <td class="td_weight">??????</td>
                                                        <td class="td_weight">??????</td>
                                                        <td class="td_weight">??????</td>
                                                        <td class="td_weight">??????</td>
                                                        <td class="td_weight" style="border-right-style:hidden;">??????</td>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach items="${travelreimburseAttachs}"
                                                               var="travelreimburseAttach">
                                                        <c:if test="${travelreimburseAttach.type eq '0' }">
                                                            <tr name="node">
                                                                <td style="width: 6%; border-left-style:hidden; "><input
                                                                        type="text"
                                                                        name="date" class="datetimepick"
                                                                        value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                        readonly></td>
                                                                <td style="width: 5.5%;"><input type="text"
                                                                                                name="startPoint"
                                                                                                value="${travelreimburseAttach.startPoint }">
                                                                </td>
                                                                <td style="width: 5.5%;"><input type="text"
                                                                                                name="destination"
                                                                                                value="${travelreimburseAttach.destination }">
                                                                </td>
                                                                <td style="width: 5.5%;"><select style="width:100%;"
                                                                                                 name="conveyance">
                                                                    <custom:dictSelect type="????????????????????????"
                                                                                       selectedValue="${travelreimburseAttach.conveyance }"/>
                                                                </select></td>
                                                                <td style="width: 13%;">
                                                                    <c:choose>
                                                                        <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                            <input type="hidden" name="projectId"
                                                                                   value="">
                                                                            <textarea name="projectName"
                                                                                      onclick="openProject(this, 'intercityCost')"
                                                                                      readonly></textarea>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <input type="hidden" name="projectId"
                                                                                   value="${travelreimburseAttach.projectId }">
                                                                            <textarea name="projectName"
                                                                                      onclick="openProject(this, 'intercityCost')"
                                                                                      readonly>${travelreimburseAttach.project.name }</textarea>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td style="width: 5.5%;"><input type="text"
                                                                                                name="cost"
                                                                                                style="text-align:right"
                                                                                                value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                </td>
                                                                <td style="width: 5.5%;"><input type="text"
                                                                                                name="actReimburse"
                                                                                                style="text-align:right"
                                                                                                value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
                                                                </td>
                                                                <td style="width: 18%;"><textarea
                                                                        name="reason" autocomplete="off"
                                                                        onfocus="reasonChange(this, 'intercityCost')">${travelreimburseAttach.reason }</textarea>
                                                                </td>
                                                                <td style="width:26.2%"><textarea
                                                                        name="detail">${travelreimburseAttach.detail }</textarea>
                                                                </td>
                                                                <td style="width: 4%;"></td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <hr style="display:none">
                                            <!-- ????????? -->
                                            <div style="text-align:left;">
                                                <a href="#stayCost" data-toggle="collapse"
                                                   data-parent="#intercityCost">?????????</a>
                                                <div class="panel-collapse collapse in" id="stayCost">
                                                    <table style="width: 100%">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">??????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">???*???</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '1' }">
                                                                <tr name="node">
                                                                    <td style="width: 5%; border-left-style:hidden; ">
                                                                        <input type="text"
                                                                               name="date" class="datetimepick"
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                               readonly></td>
                                                                    <td style="width: 5%;"><input type="text"
                                                                                                  name="place"
                                                                                                  value="${travelreimburseAttach.place }">
                                                                    </td>
                                                                    <td style="width: 12%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 5%;"><input type="text"
                                                                                                  name="dayRoom"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 5%;"><input type="text"
                                                                                                  name="cost"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 5%;"><input type="text"
                                                                                                  name="actReimburse"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 15%;"><textarea
                                                                            name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 21.4%;"><textarea
                                                                            name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.4%;"></td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <hr>
                                            <!-- ??????????????? -->
                                            <div style="text-align:left;">
                                                <a href="#cityCost" data-toggle="collapse">???????????????</a>
                                                <div class="panel-collapse collapse in" id="cityCost">
                                                    <table style="width: 100%;">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">??????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight trafficT"
                                                                style="width: 3%;display: none;white-space: nowrap">????????????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '2' }">
                                                                <tr name="node">
                                                                    <td style="width: 6%; border-left-style:hidden;">
                                                                        <input type="text"
                                                                               name="date" class="datetimepick"
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                               readonly></td>
                                                                    <td style="width: 6.2%;"><input type="text"
                                                                                                    name="place"
                                                                                                    value="${travelreimburseAttach.place }">
                                                                    </td>
                                                                    <c:if test="${not empty travelreimburseAttach.conveyance}">
                                                                        <td>
                                                                            <select name="conveyance"
                                                                                    style="width:100%;test-align-last:center"
                                                                                    id="conveyance1">
                                                                                <custom:dictSelect type="???????????????????????????"
                                                                                                   selectedValue="${travelreimburseAttach.conveyance }"/>
                                                                            </select>
                                                                        </td>
                                                                    </c:if>
                                                                    <td style="width: 14%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="cost"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="actReimburse"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 20.6%;"><textarea type="text"
                                                                                                        name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 24.8%;"><textarea type="text"
                                                                                                        name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.9%;"></td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                           <%-- <hr>
                                            <!-- ????????????-->
                                            <div style="text-align:left;">
                                                <a href="#receiveCost" data-toggle="collapse">????????????</a>
                                                <div class="panel-collapse collapse in" id="receiveCost">
                                                    <table style="width: 100%;">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">??????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '3' }">
                                                                <tr name="node">
                                                                    <td style="width: 6%; border-left-style:hidden;">
                                                                        <input type="text"
                                                                               name="date" class="datetimepick"
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                               readonly></td>
                                                                    <td style="width: 6.2%;"><input type="text"
                                                                                                    name="place"
                                                                                                    value="${travelreimburseAttach.place }">
                                                                    </td>
                                                                    <td style="width: 14%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="cost"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="actReimburse"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 20.6%;"><textarea
                                                                            name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 24.8%;"><textarea
                                                                            name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.9%;"></td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>--%>
                                            <hr>
                                            <!-- ?????? -->
                                            <div style="text-align:left;">
                                                <a href="#subsidy" data-toggle="collapse">??????</a>
                                                <div class="panel-collapse collapse in" id="subsidy">
                                                    <table style="width: 100%;">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">
                                                                ????????????
                                                            </td>
                                                            <td class="td_weight">????????????</td>
                                                            <td class="td_weight">????????????</td>
                                                            <td class="td_weight trafficSubsidy"
                                                                style="width: 7%;">????????????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '4' }">
                                                                <tr name="node">
                                                                    <input type="hidden" name="date"
                                                                           value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />">
                                                                    <input type="hidden" name="actReimburse"
                                                                           value="<fmt:formatNumber value="" pattern="#.##" />">
                                                                    <td style="width: 6%; border-left-style:hidden;">
                                                                        <input type="text"
                                                                               name="beginDate" class="datetimepick"
                                                                               readonly
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />">
                                                                    </td>
                                                                    <td style="width: 6%;"><input type="text"
                                                                                                  name="endDate"
                                                                                                  class="datetimepick"
                                                                                                  readonly
                                                                                                  value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />">
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="foodSubsidy"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
                                                                    </td>
                                                                    <c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
                                                                        <td><input type="text" name="trafficSubsidy"
                                                                                   style="text-align:right"
                                                                                   value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />"
                                                                                   ></td>
                                                                    </c:if>
                                                                    <c:if test="${empty travelreimburseAttach.trafficSubsidy}">
                                                                        <td><input type="text" name="trafficSubsidy"
                                                                                   style="text-align:right"
                                                                                   value="0"
                                                                                   ></td>
                                                                    </c:if>
                                                                    <td style="width: 15%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 20%;"><textarea
                                                                            name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 25%;"><textarea
                                                                            name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.9%;"></td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <hr>
                                            <!-- ?????????-->
                                            <div style="text-align:left;">
                                                <a href="#business" data-toggle="collapse">????????????</a>
                                                <div class="panel-collapse collapse in" id="business">
                                                    <table style="width: 100%;">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">??????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '5' }">
                                                                <tr name="node">
                                                                    <td style="width: 6%; border-left-style:hidden;">
                                                                        <input type="text"
                                                                               name="date" class="datetimepick"
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                               readonly></td>
                                                                    <td style="width: 6.2%;"><input type="text"
                                                                                                    name="place"
                                                                                                    value="${travelreimburseAttach.place }">
                                                                    </td>
                                                                    <td style="width: 14%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="cost"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="actReimburse"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" onchange="validationRed('business')">
                                                                    </td>
                                                                    <td style="width: 20.6%;"><textarea
                                                                            name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 24.8%;"><textarea
                                                                            name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.9%;"></td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <hr>
                                            <!-- ????????????-->
                                            <div style="text-align:left;">
                                                <a href="#relationship" data-toggle="collapse">????????????</a>
                                                <div class="panel-collapse collapse in" id="relationship">
                                                    <table style="width: 100%;">
                                                        <thead>
                                                        <tr>
                                                            <td class="td_weight" style="border-left-style:hidden;">??????
                                                            </td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight">??????</td>
                                                            <td class="td_weight" style="border-right-style:hidden;">
                                                                ??????
                                                            </td>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach items="${travelreimburseAttachs}"
                                                                   var="travelreimburseAttach">
                                                            <c:if test="${travelreimburseAttach.type eq '6' }">
                                                                <tr name="node">
                                                                    <td style="width: 6%; border-left-style:hidden;">
                                                                        <input type="text"
                                                                               name="date" class="datetimepick"
                                                                               value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />"
                                                                               readonly></td>
                                                                    <td style="width: 6.2%;"><input type="text"
                                                                                                    name="place"
                                                                                                    value="${travelreimburseAttach.place }">
                                                                    </td>
                                                                    <td style="width: 14%;">
                                                                        <c:choose>
                                                                            <c:when test="${travelreimburse.status eq '7' or empty travelreimburse.status  and travelreimburseAttach.project.status eq '-1' }">
                                                                                <input type="hidden" name="projectId"
                                                                                       value="">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly></textarea>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="projectId"
                                                                                       value="${travelreimburseAttach.projectId }">
                                                                                <textarea name="projectName"
                                                                                          onclick="openProject(this, 'intercityCost')"
                                                                                          readonly>${travelreimburseAttach.project.name }</textarea>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="cost"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
                                                                    </td>
                                                                    <td style="width: 7%;"><input type="text"
                                                                                                  name="actReimburse"
                                                                                                  style="text-align:right"
                                                                                                  value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />" onchange="validationRed('relationship')">
                                                                    </td>
                                                                    <td style="width: 20.6%;"><textarea
                                                                            name="reason">${travelreimburseAttach.reason }</textarea>
                                                                    </td>
                                                                    <td style="width: 24.8%;"><textarea
                                                                            name="detail">${travelreimburseAttach.detail }</textarea>
                                                                    </td>
                                                                    <td style="width: 3.9%;"></td>
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
                                                    <td class="td_right td_weight"
                                                        style="width:8%; border-left-style:hidden;"><span>???????????????</span>
                                                    </td>
                                                    <td style="width:92%; border-right-style:hidden; ">
                                                        <div style="display:flex">
                                                            <div style="display:flex">
                                                                <span>??</span>
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
                                                <td class="td_weight"
                                                    style="width:8%; border-left-style:hidden;border-bottom-style:hidden;">
                                                    <span>????????????</span></td>
                                                <td colspan="20"
                                                    style="text-align: left; border-bottom-style:hidden; border-right-style:hidden;">
                                                    <input
                                                            type="button" value="?????????????????????" onclick="openTravel()"
                                                            style="border:none;">
                                                    <span id="selectTravel" name="selectTravel">
																<c:if test="${not empty travelProcessInstanceIds}">
                                                                    <c:forEach var="travelProcessInstanceId"
                                                                               items="${travelProcessInstanceIds}"
                                                                               varStatus="varStatus">
                                                                        <input type="button" name="detail"
                                                                               style="margin-left:6px"
                                                                               value="?????????????????????${ varStatus.index + 1}???"
                                                                               onclick="viewTravel(${travelProcessInstanceId})"
                                                                               style="border:none;">
                                                                    </c:forEach>
                                                                </c:if>
															</span>


                                                </td>
                                            </table>

                                </td>
                            </tr>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td style="width:8.1%" class="td_right td_weight"><span>?????????</span></td>
                                <td colspan="6" style="border-right-style:hidden;"><a href="javascript:void(0);"
                                                                                      onclick="downloadAttach(this)"
                                                                                      value="${travelreimburse.attachments }"
                                                                                      target='_blank'><input
                                        type="text" id="showName" name="showName"
                                        value="${travelreimburse.attachName }" readonly></a>
                                <td>
                                    <input type="file" id="file" name="file" style="display:none;">
                                    <input type="button" value="????????????" onclick="$('#file').click()"
                                           style="border:none;float:right;" href="javascript:;">
                                </td>
                                </td>
                                <td colspan="3"><a href="javascript:void(0);"
                                                   onclick="deleteAttach(this)"
                                                   value="${travelreimburse.attachments }">??????</a></td>
                            </tr>

                            <tr>
                                <td colspan="34" style="text-align:center;padding:10px;border:none;">
                                    <button type="button" class="btn btn-primary" onclick="save()">??????</button>
                                    <button type="button" class="btn btn-primary" onclick="del()">??????</button>
                                    <button type="button" class="btn btn-primary" onclick="submitinfo()">????????????</button>
                                    <button type="button" class="btn btn-default"
                                            onclick="javascript:window.history.back(-1)">??????
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
</div>

<div id="deptDialog"></div>
<div id="projectDialog"></div>
<div id="travelDialog"></div>

<!-- ????????????Modal??? -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:80%; height: 80%;">
        <div class="modal-content" style="height:100%;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">????????????</h4>
            </div>
            <div class="modal-body" style="height:75%;">
                <iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto"
                        style="height:100%;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
            </div>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal -->


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
                    ?????????????????? ??????????????????
                </p>
                <p>
                    <span style="font-size:19px">1</span><span style="font-size:19px;font-family:??????">????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span
                        style="font-size:19px">0</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????</span><span
                        style="font-family: ??????; font-size: 19px;">????????????????????????????????????????????????????????????????????????????????????</span>
                </p>
                <p>
                    <img src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"
                         _src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"/>
                </p>
                <p>
                    <span style="font-size:19px">2</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><img
                        src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"
                        _src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"/>
                </p>
                <p>
                    <span style="font-size:19px">3</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
                </p>
                <p>
                    <img src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"
                         _src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"/>
                </p>
                <p>
                    <span style="font-size:19px;font-family:??????"><span
                            style="font-size:19px;font-family: &#39;Calibri&#39;,sans-serif">4</span><span
                            style="font-size:19px;font-family:??????">???</span>???????????????????????????????????????????????????????????????????????????????????????????????????</span><span
                        style="font-size:19px">,</span><span
                        style="font-size:19px;font-family:??????">?????????????????????????????????</span><span
                        style="font-size:19px">XX</span><span style="font-size:19px;font-family: ??????">??????</span><span
                        style="font-size: 19px;font-family: Arial, sans-serif;color: rgb(51, 51, 51)">???</span><span
                        style="font-size:19px">XX</span><span style="font-size:19px;font-family:??????">??????</span><span
                        style="font-size:19px">+</span><span style="font-size:19px;font-family: ??????">???????????????????????????????????????????????????????????????????????????????????????</span><span
                        style="font-size:19px">,</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span
                        style="font-size:19px">8</span><span
                        style="font-size:19px;font-family:??????">??????????????????????????????</span><span
                        style="font-size:19px">11</span><span style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span
                        style="font-size:19px">(</span><span
                        style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span
                        style="font-size:19px">)</span><span style="font-size:19px;font-family: ??????">???</span>
                </p>
                <p>
                    <img src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"
                         _src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"/>
                </p>
                <p>
                    <img src="http://www.reyzar.com/images/upload/20171011/1507695378718.png"
                         _src="http://www.reyzar.com/images/upload/20171011/1507695378718.png"
                         style="width: 900px; height: 744px;"/><img
                        src="http://www.reyzar.com/images/upload/20171011/1507695407728.png"
                        _src="http://www.reyzar.com/images/upload/20171011/1507695407728.png"
                        style="width: 750px; height: 708px;"/>
                </p>
                <p>
                    <span style="font-size:19px">5</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
                </p>
                <p>
                    <span style="font-size:19px">6</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
                </p>
                <p>
                    <span style="font-size:19px">7</span><span style="font-size:19px;font-family:??????">????????????????????????????????????</span><span
                        style="font-size:19px">OA</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
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


<%@ include file="../../common/footer.jsp" %>
<!-- ???????????? -->
<script type="text/javascript">
    base = "<%=base%>";

    var ishavatrafficTool = new Array();
    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
    if (${travelreimburseAttach.type eq "2"}) {
        if (${not empty(travelreimburseAttach.conveyance)}) {
            ishavatrafficTool.push(${travelreimburseAttach.conveyance});
        }
    }
    </c:forEach>

    var ishavatrafficSubsidy = new Array();
    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
    if (${travelreimburseAttach.type eq "4"}) {
        if (${not empty(travelreimburseAttach.trafficSubsidy)}) {
            ishavatrafficSubsidy.push(${travelreimburseAttach.trafficSubsidy});
        }
    }
    </c:forEach>


</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript"
        src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/edit.js"></script>
</body>
</html>