<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <%@ include file="../../common/header.jsp" %>

    <style>
        body {
            background: none !important;
        }

        select {
            appearance: none;
            -moz-appearance: none;
            -webkit-appearance: none;
            border: none;
            text-align-last: center;
        }

        /* IE10以上生效 */
        select::-ms-expand {
            display: none;
        }

        #table {
            width: 96%;
            margin: 0 auto;
            table-collapse: collapse;
            border: none;
            padding: 0;
        }

        #table th {
            text-align: center;
            font-weight: bold;
            font-size: 1.5em;
        }

        #table td {
            border: solid #999 1px;
            /* padding: 5px; */
            text-align: center;
        }

        #table td.td_left {
            text-align: left;
            white-space: pre-line;
        }

        .tab {
            table-collapse: collapse;
            border: none;
            width: 100%;
        }

        .tab td {
            font-family: 宋体;
            font-size: 12px;
            border: solid #999 1px;
            padding: 2px;
            word-break: break-all;
            word-wrap: break-word;
            text-align: center;
        }

        .tab_title {
            text-align: left;
            /* font-weight: bold; */
            border-bottom: solid #999 1px;
            /* 	padding-top: 0.5em; */
            font-size: 14px;
        }

        .tab_title span {
            display: inline-block;
            padding: 0.5em 2em !important;
            border: solid #999 1px;
            border-bottom: none;
        }

        .td_right {
            text-align: right;
        }

        .td_weight {
            /* font-weight: bold; */
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

        #table2 {
            width: 96%;
            margin: 0 auto;
            margin-top: 1.3em;
        }

        #table2 td {
            /* font-weight: bold; */
            font-size: 1em;
            width: 13%;
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
                font-size: 14px;
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
                /* font-weight: bold; */
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
            	font-weight: 100;
                padding: 0pt 1pt;
            }

            #table td.td_left {
                text-align: left;
            }

            #table th {
                text-align: center;
               /*  font-weight: bold; */
                font-size: 12pt;
            }

            .tab_title {
                text-align: left;
                /* font-weight: bold; */
                border-bottom: solid #999 0.5pt;
                /* padding-top: 0.5em; */
                font-size: 14px;
                font-weight: 100; 
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
                /* font-weight: bold; */
                font-size: 8pt;
                width: 15%;
                font-weight: 100; 
            }
            .td_weight {
            font-size: 12px;
        	}
            .td_weight span {
            font-size: 12px;
        	}
        	#totalcn {
        	 font-weight: 100; 
        	}
        }
    </style>
</head>
<body>
<div class="tbspace">
    <input type="hidden" id="status" value="${map.business.status }">
    <input type="hidden" id="title_val" value="${map.business.title }">
    <input type="hidden" id="encrypted" value="${map.business.encrypted }">
    <select id="title_hidden" style="display:none;"><custom:dictSelect type="流程所属公司"/></select>
    <select id="conveyance_hidden" style="display:none;"><custom:dictSelect type="出差报销交通工具"/></select>
    <select id="conveyance1_hidden" style="display: none">
        <custom:dictSelect type="市内交通费交通工具"/>
    </select>
    <table id="table">
        <thead>
        <tr>
            <th id="" colspan="20" style="padding-bottom:0.5em;font-weight:300;">差旅报销单<span
                    style="font-size:0.7em;float:right;right:2.5em;line-height:16pt;">(报销单号：${map.business.orderNo })</span>
            </th>
        </tr>
        </thead>
        <tbody>

        <!-- 报销人相关 -->
        <tr>
            <td class="td_weight"><span>出差人员</span></td>
            <td>${map.business.name }</td>
            <td class="td_weight"><span>报销单位</span></td>
            <c:choose>
                <c:when test="${empty(map.business.dept.alias)}">
                    <td id="title">${map.business.dept.name }</td>
                </c:when>
                <c:otherwise>
                    <td id="title"></td>
                </c:otherwise>
            </c:choose>
            <td class="td_weight"><span>提交日期</span></td>
            <td><fmt:formatDate value='${map.business.applyTime }' pattern='yyyy年MM月dd日'/></td>
            <td class="td_weight"><span>领款人</span></td>
            <td>${map.business.payee }</td>
        </tr>

        <!-- 城际交通费 -->
        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="intercityCost">城际交通费</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%;border-left-style:hidden;">日期</td>
                        <td class="td_weight" style="width: 6%;">出发地</td>
                        <td class="td_weight" style="width: 6%;">目的地</td>
                        <td class="td_weight" style="width: 8%;">交通工具</td>
                        <td class="td_weight" style="width: 12%;">项目</td>
                        <!-- <td class="td_weight" style="width: 6%;">费用</td> -->
                        <td class="td_weight" style="width: 6%;">实报</td>
                        <td class="td_weight" style="width: 19%;">事由</td>
                        <td class="td_weight" style="border-right-style:hidden;">明细</td>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '0' }">
                            <tr name="node" id="node">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                                <td>${travelreimburseAttach.startPoint }</td>
                                <td>${travelreimburseAttach.destination }</td>
                                <td><custom:getDictKey type="出差报销交通工具"
                                                       value="${travelreimburseAttach.conveyance }"/></td>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                    <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                                <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                          pattern="0.00"/></td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!-- <tr name="subTotal">
                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td name="costTotal"></td>
                        <td name="actReimburseTotal"></td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    </tbody>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="stayCost">住宿费</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%;border-left-style:hidden;">日期</td>
                        <td class="td_weight" style="width: 5%;">地点</td>
                        <td class="td_weight" style="width: 12%;">项目</td>
                        <td class="td_weight" style="width: 5%;">天*房</td>
                        <!-- <td class="td_weight" style="width: 5%;">费用</td> -->
                        <td class="td_weight" style="width: 5%;">实报</td>
                        <td class="td_weight" style="width: 15%;">事由</td>
                        <td class="td_weight" style="">明细</td>
                        <shiro:hasPermission name="fin:reimburse:seeall">
                            <td class="td_weight"
                                style="width: 5.6%;border-right: hidden">费用归属
                            </td>
                        </shiro:hasPermission>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '1' }">
                            <tr name="node" id="node">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                                <td>${travelreimburseAttach.place }</td>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                <td><fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##"/></td>
                                    <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                                <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                          pattern="0.00"/></td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                                <shiro:hasPermission name="fin:reimburse:seeall">
                                    <td style="width:100px;">
                                        <select style="width: 100%;" name="attachInvestId"
                                                value="${travelreimburseAttach.attachInvestId}"></select>
                                    </td>
                                </shiro:hasPermission>
                                    <%-- <td class="td_left">${travelreimburseAttach.remark }</td> --%>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!-- <tr name="subTotal">
                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
                        <td></td>
                        <td></td>
                        <td name="costTotal"></td>
                        <td name="actReimburseTotal"></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    </tbody>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="cityCost">市内交通费</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%; border-left-style:hidden;">日期</td>
                        <td class="td_weight" style="width: 5%;">地点</td>
                        <td class="td_weight trafficT" contenteditable="true" style="width: 3%;display: none;white-space: nowrap">交通工具</td>
                        <td class="td_weight" style="width: 15%;">项目</td>
                        <!-- <td class="td_weight" style="width: 5%;">费用</td> -->
                        <td class="td_weight" style="width: 5%;">实报</td>
                        <td class="td_weight" style="width: 26%;">事由</td>
                        <td class="td_weight" style="border-right-style:hidden;">明细</td>
                        <shiro:hasPermission name="fin:reimburse:seeall">
                            <td class="td_weight"
                                style="width: 5.6%; border-right: hidden">费用归属
                            </td>
                        </shiro:hasPermission>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '2' }">
                            <tr name="node" id="node">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                                <td>${travelreimburseAttach.place }</td>
                                <c:if test="${not empty travelreimburseAttach.conveyance}">
                                    <td>
                                        <custom:getDictKey type="市内交通费交通工具" value="${travelreimburseAttach.conveyance }"/>
                                    </td>
                                </c:if>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                    <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                                <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                          pattern="0.00"/></td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                                <shiro:hasPermission name="fin:reimburse:seeall">
                                    <td style="width:100px;">
                                        <select style="width: 100%;" name="attachInvestId"
                                                value="${travelreimburseAttach.attachInvestId}"></select>
                                    </td>
                                </shiro:hasPermission>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!-- <tr name="subTotal">
                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
                        <td></td>
                        <td name="costTotal"></td>
                        <td name="actReimburseTotal"></td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    </tbody>
                </table>
            </td>
        </tr>

        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="receiveCost">接待餐费</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%;border-left-style:hidden;">日期</td>
                        <td class="td_weight" style="width: 7%;">地点</td>
                        <td class="td_weight" style="width: 15%;">项目</td>
                        <!-- <td class="td_weight" style="width: 7%;">费用</td> -->
                        <td class="td_weight" style="width: 7%;">实报</td>
                        <td class="td_weight" style="width: 20%;">事由</td>
                        <td class="td_weight" style="border-right-style:hidden;">明细</td>
                        <shiro:hasPermission name="fin:reimburse:seeall">
                            <td class="td_weight"
                                style="width: 5.6%; border-right: hidden">费用归属
                            </td>
                        </shiro:hasPermission>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '3' }">
                            <tr name="node" id="receive">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                                <td>${travelreimburseAttach.place }</td>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                    <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                                <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                          pattern="0.00"/></td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                                <shiro:hasPermission name="fin:reimburse:seeall">
                                    <td style="width:100px;">
                                        <select style="width: 100%;" name="attachInvestId"
                                                value="${travelreimburseAttach.attachInvestId}"></select>
                                    </td>
                                </shiro:hasPermission>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!--<tr name="subTotal">
                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
                        <td></td>
                        <td name="costTotal"></td>
                        <td name="actReimburseTotal"></td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    </tbody>
                </table>
            </td>
        </tr>

        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="subsidy">补贴</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%;border-left-style:hidden;">出发日期</td>
                        <td class="td_weight" style="width: 9%;">离开日期</td>
                        <td class="td_weight" style="width: 8%;">餐费补贴</td>
                        <td class="td_weight trafficSubsidy" style="width: 7%;display: none">交通补贴</td>
                        <td class="td_weight" style="width: 15%;">项目</td>
                        <td class="td_weight" style="width: 22%;">事由</td>
                        <td class="td_weight" style="border-right-style:hidden;">明细</td>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '4' }">
                            <tr name="node" id="node">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${travelreimburseAttach.endDate }"
                                                    pattern="yyyy-MM-dd"/></td>
                                <td name="foodSubsidy"><fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }"
                                                                         pattern="0.00"/></td>
                                <c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
                                    <td name="trafficSubsidy"><fmt:formatNumber
                                            value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##"/></td>
                                </c:if>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!-- <tr name="subTotal">
                        <td colspan="2" class="td_right td_weight"><span>小计：</span></td>
                        <td name="foodSubsidyTotal"></td>
                        <td name="trafficSubsidyTotal"></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    </tbody>
                </table>
            </td>
        </tr>

        <tr>
        <td colspan="20" style="border-top:none; border-bottom:none;">
            <div class="tab_title" id="business">业务费用</div>
            <table class="tab">
                <tbody>
                <tr style="border-top-style:hidden;">
                    <td class="td_weight" style="width: 9%;border-left-style:hidden;">日期</td>
                    <td class="td_weight" style="width: 7%;">地点</td>
                    <td class="td_weight" style="width: 15%;">项目</td>
                    <!-- <td class="td_weight" style="width: 7%;">费用</td> -->
                    <td class="td_weight" style="width: 7%;">实报</td>
                    <td class="td_weight" style="width: 20%;">事由</td>
                    <td class="td_weight" style="border-right-style:hidden;">明细</td>
                    <shiro:hasPermission name="fin:reimburse:seeall">
                        <td class="td_weight"
                            style="width: 5.6%; border-right: hidden">费用归属
                        </td>
                    </shiro:hasPermission>
                </tr>
                <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                    <c:if test="${travelreimburseAttach.type eq '5' }">
                        <tr name="node" id="receive">
                            <td style="border-left-style:hidden;"><fmt:formatDate
                                    value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                            <td>${travelreimburseAttach.place }</td>
                            <td name="projectName">${travelreimburseAttach.project.name }</td>
                                <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                            <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                      pattern="0.00"/></td>
                            <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                            <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                            <shiro:hasPermission name="fin:reimburse:seeall">
                                <td style="width:100px;">
                                    <select style="width: 100%;" name="attachInvestId"
                                            value="${travelreimburseAttach.attachInvestId}"></select>
                                </td>
                            </shiro:hasPermission>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </td>
        </tr>

        <tr>
            <td colspan="20" style="border-top:none; border-bottom:none;">
                <div class="tab_title" id="relationship">攻关费用</div>
                <table class="tab">
                    <tbody>
                    <tr style="border-top-style:hidden;">
                        <td class="td_weight" style="width: 9%;border-left-style:hidden;">日期</td>
                        <td class="td_weight" style="width: 7%;">地点</td>
                        <td class="td_weight" style="width: 15%;">项目</td>
                        <!-- <td class="td_weight" style="width: 7%;">费用</td> -->
                        <td class="td_weight" style="width: 7%;">实报</td>
                        <td class="td_weight" style="width: 20%;">事由</td>
                        <td class="td_weight" style="border-right-style:hidden;">明细</td>
                        <shiro:hasPermission name="fin:reimburse:seeall">
                            <td class="td_weight"
                                style="width: 5.6%; border-right: hidden">费用归属
                            </td>
                        </shiro:hasPermission>
                    </tr>
                    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
                        <c:if test="${travelreimburseAttach.type eq '6' }">
                            <tr name="node" id="receive">
                                <td style="border-left-style:hidden;"><fmt:formatDate
                                        value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd"/></td>
                                <td>${travelreimburseAttach.place }</td>
                                <td name="projectName">${travelreimburseAttach.project.name }</td>
                                    <%-- <td name="cost"><fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="0.00" /></td> --%>
                                <td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }"
                                                                          pattern="0.00"/></td>
                                <td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
                                <td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
                                <shiro:hasPermission name="fin:reimburse:seeall">
                                    <td style="width:100px;">
                                        <select style="width: 100%;" name="attachInvestId"
                                                value="${travelreimburseAttach.attachInvestId}"></select>
                                    </td>
                                </shiro:hasPermission>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </td>
        </tr>

        <tr>
            <td colspan="20" style="border-top:none;">
                <table class="tab" style="margin-top: 1em;">
                    <tr>
                        <td class="td_right td_weight" style="width:10%;border-left-style:hidden;"><span>实报金额：</span>
                        </td>
                        <td style="width:92%;border-right-style:hidden;">
                            <div style="display:flex">
                                <div style="display:flex">
                                    <span>¥</span>
                                    <span id="total"></span>
                                </div>
                                <div>
                                    (
                                    <span id="totalcn"></span>
                                    )
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <table id="reimbursetotal" class="tab" style="margin-top:0;">
                    <thead name="reimbursetotal" style="border-bottom-style:hidden;">
                    </thead>
                </table>
            </td>
        </tr>
        </tbody>
    </table>

    <table id="table2">
        <tbody>
        <tr>
            <td id="fuhe">审核：</td>
            <td id="ceo" style="text-align:center;">审批：</td>
            <td style="text-align:center;">领款人：</td>
        </tr>
        </tbody>
    </table>
</div>


<%@ include file="../../common/footer.jsp" %>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>

<script>
    var hasDecryptPermission = false;
    <shiro:hasPermission name="fin:travelreimburse:decrypt">
    hasDecryptPermission = true;
    </shiro:hasPermission>

    var variables = ${map.jsonMap.variables};
    var titleMap = {};

    $(function () {
        initMap();
        initPage();
        updatereimbursetotal();
        initDecryption();
        initInvest();

        if (ishavatrafficSubsidy.length > 0) {
            $(".trafficSubsidy").show();
        }
        if (ishavatrafficTool.length > 0) {
            $(".trafficT").show();
        }
    });

    // 初始化费用归属
    function initInvest() {
        $.ajax({
            "type": "GET",
            "url": web_ctx + "/manage/finance/reimburs/getInvestList",
            "dataType": "json",
            "success": function (data) {
                if (!isNull(data)) {
                    investList = data;
                    $("tbody").find("select[name='attachInvestId']").each(function (index, select) {
                        var investValue = $(select).attr("value");
                        var html = [];
                        html.push('<option value="-1"></option>');
                        $(investList).each(function (index, invest) {
                            html.push('<option value="' + invest.id + '" ' + (investValue == invest.id ? "selected" : "") + '>' + invest.value + '</option>');
                        });
                        $(select).append(html.join(""));
                    });
                }
            }
        });
    }

    /*用于报销项目去重*/
    function unique(array) {
        var n = []; //一个新的临时数组
        //遍历当前数组
        for (var i = 0; i < array.length; i++) {
            //如果当前数组的第i已经保存进了临时数组，那么跳过，
            //否则把当前项push到临时数组里面
            if (n.indexOf(array[i]) == -1) n.push(array[i]);
        }
        return n;
    }

    /*更新差旅报销统计*/
 /*   function updatereimbursetotal() {
        var cost = []; //项目费用数据
        var receive = [];
        var projectName = [];
        var temp = [];
        var key; 	 //项目索引Key
        var costmap = new Map(cost);
        var receivemap = new Map(receive);
        var sum = [];

        sum.push("<tr>")
        sum.push("<td style='width:20%;border-top-style:hidden;border-left-style:hidden;'>项目</td>")
        sum.push("<td style='width:40%;border-top-style:hidden;'>差旅统计</td>")
        sum.push("<td style='width:40%;border-top-style:hidden;'>招待统计</td>")
        sum.push("</tr>")

        $("tr[name='node']").each(function (index, tr) {
            project = $(tr).find("td[name='projectName']").text();
            temp.push(project);
        });
        projectName = unique(temp);

        $("tr[id='node']").each(function (index, tr) {
            project = $(tr).find("td[name='projectName']").text();
            actReimburse = $(tr).find("td[name='actReimburse']").text();
            food = $(tr).find("td[name='foodSubsidy']").text();
            traffic = $(tr).find("td[name='trafficSubsidy']").text();
            if (traffic == undefined) {
                money = food;
            } else {
                money = digitTool.add(food, traffic);
            }
            if (money != "") {
                actReimburse = money;
            }
            cost.push(actReimburse);
            key = project;
            if (costmap.get(key) == undefined) {
                costmap.set(key, cost[index]);
            }
            else {
                total = digitTool.add(costmap.get(key), cost[index]);
                costmap.set(key, total.toFixed(2));
            }
        });

        $("tr[id='receive']").each(function (index, tr) {
            project = $(tr).find("td[name='projectName']").text();
            actReimburse = $(tr).find("td[name='actReimburse']").text();
            receive.push(actReimburse);
            key = project;
            if (receivemap.get(key) == undefined) {
                receivemap.set(key, receive[index]);
            }
            else {
                total = digitTool.add(receivemap.get(key), receive[index]);
                receivemap.set(key, total.toFixed(2));
            }
        });

        $(projectName).each(function (index, value) {
            sum.push("<tr style='border-top-style:hidden;'>")
            sum.push("<td style='border-left-style:hidden;'>" + value + "</td>");
            if (costmap.get(value) == undefined) {
                sum.push("<td>" + '0.00' + "</td>");
            }
            else {
                sum.push("<td>" + costmap.get(value) + "</td>");
            }
            if (receivemap.get(value) == undefined) {
                sum.push("<td>" + '0.00' + "</td>");
            }
            else {
                sum.push("<td>" + receivemap.get(value) + "</td>");
            }
            sum.push("</tr>")
        });
        $("#reimbursetotal").find("thead[name='reimbursetotal']").append(sum);

    }*/


    function initMap() {
        $("#title_hidden").find("option").each(function (index, option) {
            titleMap[$(option).attr("value")] = $(option).text();
        });
    }

    function initPage() {
        var title = titleMap[$("#title_val").val()].split("");
        $("#title").prepend(title);


        var total = ${map.business.total};
        $("#total").text(total.toFixed(2));
        toUppercase(total);
        var status = $("#status").val();
        /* 	// 初始化签名
         var node2td = {
         "总经理": (status == "3" || status == "4" ||  status == "11") ? "" : "ceo",
         "复核": (status == "3" || status == "11") ? "" : "fuhe",
         "部门经理": "manager"
         };
         $(variables.commentList).each(function(index, comment) {
         if( !isNull(comment["node"]) && !isNull(node2td[comment["node"]]) ) {
         if(node2td[comment["node"]] == "ceo")
         {
         $("#" + node2td[comment["node"]]).text("审批人"+"："+comment["approver"]);
         }
         else
         {
         $("#" + node2td[comment["node"]]).text(comment["node"]+"："+comment["approver"]);
         }
         }
         }); */

        // 初始化小计
        $("div.tab_title").each(function (index, tab) {
            // 计算非补贴项
            if ($(tab).attr("id") != "subsidy") {
                var costTotal = 0;
                var actReimburseTotal = 0;
                $(tab).next("table").find("tr[name='node']").each(function (index, node) {
                    var cost = $("td[name='cost']", node).text();
                    var actReimburse = $("td[name='actReimburse']", node).text();
                    if (!isNull(cost)) {
                        costTotal = digitTool.add(costTotal, parseFloat(cost)).toFixed(2);
                    }
                    if (!isNull(actReimburse)) {
                        actReimburseTotal = digitTool.add(actReimburseTotal, parseFloat(actReimburse)).toFixed(2);
                    }
                });

                $(tab).next("table").find("td[name='costTotal']").text(costTotal);
                $(tab).next("table").find("td[name='actReimburseTotal']").text(actReimburseTotal);
            } else { // 计算补贴

                var foodSubsidyTotal = 0;
//			var trafficSubsidyTotal = 0;
                $(tab).next("table").find("tr[name='node']").each(function (index, node) {
                    var foodSubsidy = $("td[name='foodSubsidy']", node).text();
//				var trafficSubsidy = $("td[name='trafficSubsidy']", node).text();
                    if (!isNull(foodSubsidy)) {
                        foodSubsidyTotal = digitTool.add(foodSubsidyTotal, parseFloat(foodSubsidy));
                    }
//				if(!isNull(trafficSubsidy)) {
//					trafficSubsidyTotal = digitTool.add(trafficSubsidyTotal, parseFloat(trafficSubsidy));
//				}
                });

                $(tab).next("table").find("td[name='foodSubsidyTotal']").text(foodSubsidyTotal);
//			$(tab).next("table").find("td[name='trafficSubsidyTotal']").text(trafficSubsidyTotal);
            }

            // 如果没有报销项，则隐藏该tab
            if ($(tab).next("table").find("tr[name='node']").length <= 0) {
                $(tab).parents("tr").hide();
            }
        });
    }

    function toUppercase(value) {
        if (!isNull(value)) {
            $("#totalcn").text(digitUppercase(value));
        } else {
            $("#totalcn").text("零元整");
        }
    }

    //如果有解密权限，则解密当前已加密的数据
    function initDecryption() {
        if ('y' == $("#encrypted").val()) {
            if (hasDecryptPermission) {
                var now = new Date().pattern("yyyyMMdd");
                $.ajax({
                    url: web_ctx + '/manage/getEncryptionKey?baseKey=' + now,
                    type: 'GET',
                    success: function (data) {
                        if (data.code == 1) {
                            var tempKey = data.result;
                            var encryptionKey = aesUtils.decryptECB(tempKey, now);
                            encryptPageText(encryptionKey);
                        } else {
                            if (data.code == -1) {
                                bootstrapAlert('提示', data.result, 400, null);
                            }
                        }
                    }
                });
            }
        }
    }
    function encryptPageText(encryptionKey) {
        $("td[name='reason'],td[name='detail']").each(function (index, td) {
            var val = $(td).text();
            try {
                val = aesUtils.decryptECB(val, encryptionKey);
                if (!isNull(val)) {
                    $(td).text(val);
                }
            } catch (e) {
            }
        });
    }

    var ishavatrafficSubsidy = new Array();
    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
    if (${travelreimburseAttach.type eq "4"}) {
        if (${not empty(travelreimburseAttach.trafficSubsidy)}) {
            ishavatrafficSubsidy.push(${travelreimburseAttach.trafficSubsidy});
            $(".trafficSubsidy").show();
        }
    }
    </c:forEach>

    var ishavatrafficTool = new Array();
    <c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
    if(${travelreimburseAttach.type eq "2"}){
        if(${not empty(travelreimburseAttach.conveyance)}){
            ishavatrafficTool.push(${travelreimburseAttach.conveyance});
            $(".trafficT").show();
        }
    }
    </c:forEach>
</script>
</body>
</html>