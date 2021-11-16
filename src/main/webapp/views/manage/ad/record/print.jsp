<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css"/>
    <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css"/>
    <link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
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
		tr{
			min-height: 30px;
			line-height:30px;
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
            padding: 3px 1em;
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
    </style>
    <div class="wrapper">
        <!-- Main content -->
        <section class="content rlspace">
            <section class="col-md-12 connectedSortable ui-sortable">
                <div class="box box-primary box-solid">
                    <div class="box-header with-border">
                        <!-- <h3 class="box-title">档案</h3> -->
                    </div>
                    <div class="box-body">
                        <form id="form">
                            <input type="hidden" id="id" name="id" value="${record.id}">
                            <input type="hidden" id="userId" name="userId" value="${record.userId}">
                            <input type="hidden" id="photo" name="photo" value="${record.photo}">


                            <table id="table1" style="width: 98%">
                                <select id="dept_hidden" style="display: none">
                                    <custom:dictSelect type="部门"/>
                                </select>
                                <select id="projectTeam_hidden" style="display: none">
                                    <custom:dictSelect type="项目组"/>
                                </select>
                                <select id="station_hidden" style="display: none">
                                    <custom:dictSelect type="岗位"/>
                                </select>
                                <select id="appoint_hidden" style="display: none">
                                    <custom:dictSelect type="任免"/>
                                </select>
                                <select id="barginType_hidden" style="display: none">
                                    <custom:dictSelect type="合同性质"/>
                                </select>
                                <select id="company_hidden" style="display: none">
                                    <custom:dictSelect type="存续公司"/>
                                </select>
                                <select id="education_hidden" style="display: none">
                                    <custom:dictSelect type="学历"/>
                                </select>
                                <thead>
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                    <td colspan="1">${record.name}</td>
                                    <td><p>岗位</p>
                                    <td colspan="1">${record.position }</td>
                                    </td>
                                    <!-- 档案照片 -->
                                    <td rowspan="5" colspan="1" style="text-align: center;">
                                        <img id="recordImg" src="<%=base%>${record.photo }" width="80"
                                             height="120"/>
                                        <input id="file" type="file" name="file" style="display:none;"/>
                                        <span id="imgName"></span>
                                    </td>
                                </tr>
                                <tr rowspan="1">
                                    <td><p>公司</p></td>
                                    <td colspan="1">${record.company }</td>
                                    <td><p>部门</p></td>
                                    <td colspan="1">${record.dept }</td>
                                    <td><p>项目组</p></td>
                                    <td colspan="1">${record.projectTeam }</td>
                                </tr>
                                <tr>
                                    <td><p>电话</p></td>
                                    <td>${record.phone}</td>
                                    <td><p>工作邮箱</p></td>
                                    <td colspan="1">${record.email}</td>
                                    <td><p>个人邮箱 </p></td>
                                    <td>${record.qq}</td>
                                </tr>
                                <tr>
                                    <td><p>学历</p></td>
                                    <td>${record.education}</td>
                                    <td><p>毕业院校</p></td>
                                    <td>${record.school}</td>
                                    <td><p>专业</p></td>
                                    <td>${record.major}</td>
                                </tr>
                                <tr>
                                    <td><p>职称</p></td>
                                    <td colspan="1">${record.majorName}</td>
                                    <td><p>政治面貌</p></td>
                                    <td colspan="1"><custom:getDictKey type="政治面貌" value="${record.politicsStatus}"/>
                                    </td>
                                    <td style="width: 10%"><p>性别</p></td>
                                    <td colspan="1"><span id="sexName"></span>
                                    <input id="sex" value="${record.sex}" hidden>
                                    </td>
                                </tr>
                                <tr>
                                    <td><p>出生日期</p></td>
                                    <td colspan="1"><fmt:formatDate value="${record.birthday}"
                                                                    pattern="yyyy-MM-dd"/></td>
                                    <td><p>身份证号码</p></td>
                                    <td colspan="1">${record.idcard}</td>
                                    <td><p>身份证地址</p></td>
                                    <td colspan="2">${record.idcardAddress}</td>
                                </tr>
                                <tr>
                                    <td><p>籍贯</p></td>
                                    <td colspan="1">${record.householdAddress }</td>
                                    <td><p>户口性质</p></td>
                                    <td><custom:getDictKey type="档案户口性质" value="${record.householdState}"/></td>
                                    <td><p>通信地址</p></td>
                                    <td colspan="6">${record.home}</td>
                                </tr>
                                <tr>
                                    <td><p>民族</p></td>
                                    <td>${record.nation}</td>
                                    <td><p>工资卡号</p></td>
                                    <td>${record.bankCard }</td>
                                    <td><p>开户银行</p></td>
                                    <td colspan="6">${record.bank}</td>
                                </tr>
                                <tr>
                                    <td><p>在职状态</p></td>
                                    <td><custom:getDictKey type="员工在职状态" value="${record.entrystatus}"/>
                                    </td>
                                    <td><p>入职日期</p></td>
                                    <td><fmt:formatDate value="${record.entryTime}" pattern="yyyy-MM-dd"/></td>
                                    <td><p>离职日期</p></td>
                                    <td colspan="2"><fmt:formatDate value="${record.leaveTime}" pattern="yyyy-MM-dd"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td><p>紧急联络人</p></td>
                                    <td>${record.emergencyPerson}</td>
                                    <td><p>紧急联络人电话</p></td>
                                    <td>${record.emergencyPhone}</td>
                                    <td><p>联络人关系</p></td>
                                    <td colspan="6">${record.emergencyRelation}</td>
                                </tr>
                                <c:if test="${not empty record.payAdjustments }">
                                <thead>
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                        薪酬调整记录
                                    </th>
                                </tr>
                                </thead>
                                    <tbody>
                                    <td colspan="22">
                                        <div class="panel-collapse collapse in" id="salaryRecord">
                                            <div>
                                                <table style="width:100%;" id="tbSal">
                                                    <thead>
                                                    <tr class="pay">
                                                        <td class="td_weight" style="border-left-style:hidden;">调薪日期
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

                                                    <c:forEach items="${record.payAdjustments }" var="payAdjustment">
                                                        <tr name="salary">
                                                            <input type="hidden" name="payAdjustmentId"
                                                                   value="${payAdjustment.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td style="width: 6.8%; border-left-style:hidden;">
                                                                <fmt:formatDate value="${payAdjustment.changeDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="basePay"
                                                                style="width: 6%;">${payAdjustment.basePay}</td>
                                                            <td name="meritPay"
                                                                style="width: 6%;">${payAdjustment.meritPay}</td>
                                                            <td name="agePay"
                                                                style="width: 6%;">${payAdjustment.agePay}</td>
                                                            <td name="lunchSubsidy"
                                                                style="width: 6%;">${payAdjustment.lunchSubsidy }</td>
                                                            <td name="computerSubsidy"
                                                                style="width: 5%;">${payAdjustment.computerSubsidy }</td>
                                                            <td name="accumulationFund"
                                                                style="width: 5%;">${payAdjustment.accumulationFund }</td>
                                                            <td style="width: 5%;height:auto;">
                                                                <div style="display:flex">
                                                                    <span name="total">${payAdjustment.total }</span>
                                                                </div>
                                                            </td>
                                                            <td style="width: 18%;">${payAdjustment.payReason }</td>
                                                        </tr>
                                                    </c:forEach>

                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                    </tbody>
                                </c:if>
                                <c:if test="${not empty record.postAppointments }">
                                <tr>
                                    <th colspan="10" class="station"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        岗位任免记录
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="stationRecord">
                                        <div>
                                            <table style="width:100%;" id="tbStation">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight" style="border-left-style:hidden;">调岗日期</td>
                                                    <td class="td_weight">公司</td>
                                                    <td class="td_weight">部门</td>
                                                    <td class="td_weight">项目组</td>
                                                    <td class="td_weight">岗位</td>
                                                    <td class="td_weight">任免</td>
                                                    <td class="td_weight">调岗原因</td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${record.postAppointments }"
                                                               var="postAppointment">
                                                        <tr name="station">
                                                            <input type="hidden" name="postAppointmentId"
                                                                   value="${postAppointment.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="postDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <fmt:formatDate value="${postAppointment.postDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="company" style="width: 12%;">
                                                                <custom:getDictKey type="存续公司"
                                                                                   value="${postAppointment.company }"/>
                                                            </td>
                                                            <td name="dept" style="width: 6%; ">
                                                                <custom:getDictKey type="部门"
                                                                                   value="${postAppointment.dept }"/>
                                                            </td>
                                                            <td name="projectTeam" style="width: 6%;">
                                                                <custom:getDictKey type="项目组"
                                                                                   value="${postAppointment.projectTeam }"/>
                                                            </td>
                                                            <td name="station" style="width: 10%;">
                                                                <custom:getDictKey type="岗位"
                                                                                   value="${postAppointment.station }"/>
                                                            </td>
                                                            <td name="appoint" style="width: 5%;height:auto;">
                                                                <custom:getDictKey type="任免"
                                                                                   value="${postAppointment.appoint }"/>
                                                            </td>
                                                            <td name="postReason"
                                                                style="width: 18%;">${postAppointment.postReason }</td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </c:if>
                                <c:if test="${not empty record.arbeitsvertrags }">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        劳动合同签约记录
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
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
                                                    <c:forEach items="${record.arbeitsvertrags }" var="arbeitsvertrag">
                                                        <tr name="sign">
                                                            <input type="hidden" name="arbeitsvertragId"
                                                                   value="${arbeitsvertrag.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="signDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <fmt:formatDate value="${arbeitsvertrag.signDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="company" style="width: 12%;">
                                                                <custom:getDictKey type="存续公司"
                                                                                   value="${arbeitsvertrag.company }"/>
                                                            </td>
                                                            <td name="beginDate" style="width: 12%;">
                                                                <fmt:formatDate value="${arbeitsvertrag.beginDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="endDate" style="width: 10%;">
                                                                <fmt:formatDate value="${arbeitsvertrag.endDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="barginType" style="width: 5%;height:auto;">
                                                                <custom:getDictKey type="合同性质"
                                                                                   value="${arbeitsvertrag.barginType}"/>
                                                            </td>
                                                            <td name="signReason"
                                                                style="width: 18%;">${arbeitsvertrag.signReason }</td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </c:if>
                                <c:if test="${not empty record.jobRecords }">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        以往工作记录
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="oldworkRecord">
                                        <div>
                                            <table style="width:100%;">
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
                                                    <c:forEach items="${record.jobRecords }" var="jobRecord">
                                                        <tr name="oldwork">
                                                            <input type="hidden" name="jobRecordId"
                                                                   value="${jobRecord.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <fmt:formatDate value="${jobRecord.beginDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <fmt:formatDate value="${jobRecord.endDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="company"
                                                                style="width: 27.2%;">${jobRecord.company }</td>
                                                            <td name="station"
                                                                style="width: 5%;height:auto;">${jobRecord.station }</td>
                                                            <td name="duty" style="width: 18%;">${jobRecord.duty }</td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </c:if>

                                <c:if test="${not empty record.educations }">
                                <tr>
                                    <th colspan="10" class="education"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        教育背景
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
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
                                                    <c:forEach items="${record.educations}" var="education">
                                                        <tr name="education">
                                                            <input type="hidden" name="educationId"
                                                                   value="${education.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <td name="beginDate"
                                                                style="width: 6.8%; border-left-style:hidden;">
                                                                <fmt:formatDate value="${education.beginDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="endDate" style="width: 6.8%;">
                                                                <fmt:formatDate value="${education.endDate}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="school"
                                                                style="width: 12.2%;">${education.school }</td>
                                                            <td name="department"
                                                                style="width: 20%;height:auto;">${education.department }</td>
                                                            <td name="major"
                                                                style="width: 9%;height:auto;">${education.major }</td>
                                                            <td name="education" style="width: 9%;height:auto;">
                                                                <custom:getDictKey type="学历"
                                                                                   value="${education.education}"/>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </c:if>
                                <c:if test="${not empty record.certificates }">
                                <tr>
                                    <th colspan="10"
                                        style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                            <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                        证书/荣誉
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <td colspan="22">
                                    <div class="panel-collapse collapse in" id="honorRecord">
                                        <div>
                                            <table style="width:100%;">
                                                <thead>
                                                <tr>
                                                    <td class="td_weight honor">日期</td>
                                                    <td class="td_weight honor">颁发单位</td>
                                                    <td class="td_weight honor">证书/荣誉名称</td>
                                                    <td class="td_weight honor">有效期</td>
                                                    <!--  <td class="td_weight">证书扫描件</td> -->
                                                </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${record.certificates }" var="certificate">
                                                        <tr name="honor">
                                                            <input type="hidden" name="certificateId"
                                                                   value="${certificate.id }">
                                                            <input type="hidden" id="recordId" name="recordId"
                                                                   value="${record.id}">
                                                            <input type="hidden" id="hiddenPath" name="hiddenPath"
                                                                   value="${certificate.scannings}">
                                                            <input type="hidden" id="hiddenName" name="hiddenName"
                                                                   value="${certificate.scanningName}">
                                                            <td name="date" style="width: 13.6%;">
                                                                <fmt:formatDate value="${certificate.date}"
                                                                                pattern="yyyy-MM-dd"/>
                                                            </td>
                                                            <td name="issuingUnit"
                                                                style="width: 12.2%;">${certificate.issuingUnit }</td>
                                                            <td name="honor"
                                                                style="width: 20%;height:auto;">${certificate.honor }</td>
                                                            <td name="validity" style="width: 9%;height:auto;">
                                                                <fmt:formatDate value="${certificate.validity}"
                                                                                pattern="yyyy-MM-dd"/></td>
                                                                <%--  <td style="width: 9%;height:auto;" >
                                                                     <input type="button" value="点击上传扫描件" onclick="$('#scanFile').click(this)" style="border:none;" href="javascript:;">
                                                                     <input type="file" id="scanFile" name="scanFile" style="display:none;">
                                                                     <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${certificate.scanningName}" target='_blank'>
                                                                             <input type="text" id="scanName" name="scanName" value="${certificate.scanningName}" style="text-align: left;" readonly>
                                                                     </a>
                                                                 </td> --%>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                                </tbody>
                                </c:if>
                                </tbody>
                            </table>
                        </form>
                    </div>

                </div>
            </section>
        </section>
    </div>


</shiro:hasPermission>

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
<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript"
        src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript"
        src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script>
    $(function () {
        initSex();
        initnumber();
    })

    function initSex() {
        if($("#sex").val()=='0'){
            $("#sexName").text("男");
        }
        if($("#sex").val()=='1'){
            $("#sexName").text("女");
        }
    }

function initnumber(){
	var id=$("#number").text();
	var number="";
	if(id<10){
		number="000"+id;
	}else if(id>=10 && id<99){
		number="00"+id;
	}else if(id>=100 && id<999){
		number="0"+id;
	}else{
		number=id;
	}
	$("#number").text(number);
}
</script>
</body>
</html>