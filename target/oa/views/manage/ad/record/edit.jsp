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
     <link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
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
	input{
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

    select{
        appearance:none;
        -moz-appearance:none;
        -webkit-appearance:none;
        border: none;
        text-align: center;
   		text-align-last: center;
    }
	
    span{
        display:inline-block;
        text-align:center;
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

	.displayShow{
		display: none;
	}
	input[name='scanName1']:HOVER {
	cursor: pointer;
}
div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
	div#rMenu ul li{
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
                        <input type="hidden" id="userId" name="userId" value="${record.userId}">
                        <input type="hidden" id="photo" name="photo" value="${record.photo}">
                        <input id="companyId" name="companyId"  type="hidden" value = "${companyId}">

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
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
                                        <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
                                    员工档案
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td><p>员工编号</p></td>
                                <td colspan="1"><input id="number" name="number" type="text"></td>
                                <td><p>姓名</p></td>
                                <td colspan="1"><input id="name" name="name" type="text"
                                                       value="${record.name}" onchange="setUserName(this)"></td>
                                <td><p>岗位</p>
                                <td colspan="1"><input id="position" name="position"  type="text" value="${record.position }"></td>
                                </td>
                                    <%--<td style="width: 10%"><p>性别</p></td>--%>
                                    <%--<td colspan="3">--%>
                                    <%--<select name="sex"  style="width:100%; height:100%;border: none; padding: 0 0 0 10px;" disabled><custom:dictSelect type="个人档案性别" selectedValue="${record.sex}" /></select>--%>
                                    <%--</td>--%>
                                <!-- 档案照片 -->
                                <td rowspan="5" colspan="1" style="text-align: center;">
                                    <img id="recordImg"  src="<%=base%>${record.photo }" width="80"
                                         height="120"/>
                                    <input id="file" type="file" name="file" style="display:none;"/>
                                    <span id="imgName"></span>
                                </td>
                            </tr>
                            <tr rowspan="1">
                                <td><p>公司</p></td>
                                <td colspan="1"><input id="company" name="company"  type="text" value="${record.company }"></td>
                                <td><p>部门</p></td>
                                <td colspan="1">
                                    <input id="dept" name="dept"  type="text" value="${record.dept }">
                                </td>
                                <td><p>项目组</p></td>
                                <td colspan="1"><input id="projectTeam" name="projectTeam"  type="text" value="${record.projectTeam }"></td>
                                    <%--<div id='dept-div' style='width: 50%' class='dept-box'>--%>
                                    <%--<div id='dept-box-body' class='dept-box-body' ></div>--%>
                                    <%--</div>--%>
                                    <%--<div id='position-div' style='width: 50%' class='position-box' >--%>
                                    <%--<div id='position-box-body' class='position-box-body' ></div>--%>
                                    <%--</div>--%>
                            </tr>
                                <%--<tr>--%>
                                <%--<td><p>岗位</p>--%>
                                <%--<shiro:hasPermission name="ad:record:editHistory">--%>
                                <%--<div style="float: right;color: #3c8dbc" onclick="addPositionHistory()" ><li class="fa fa-x fa-plus"></li></div>--%>
                                <%--</shiro:hasPermission>--%>
                                <%--</td>--%>
                                <%--<td colspan="5">--%>
                                <%--<textarea id="position" name="position"  onclick="openPosition(this)"  readonly>${record.position}</textarea>--%>
                                <%--</td>--%>
                                <%--<div id='position-div' style='width: 50%' class='position-box' >--%>
                                <%--<div id='position-box-body' class='position-box-body' ></div>--%>
                                <%--</div>--%>
                                <%--</tr>--%>
                            <tr>
                                <td><p>电话</p></td>
                                <td><input id="phone" name="phone" type="text" value="${record.phone}" disable></td>
                                <td><p>工作邮箱</p></td>
                                <td colspan="1"><input id="email" name="email" type="text" value="${record.email}"
                                                       disable></td>
                                <td><p>个人邮箱 </p></td>
                                <td><input id="qq" name="qq" type="text" value="${record.qq}" disable></td>
                                    <%--<td><p>民族</p></td>--%>
                                    <%--<td><input id="nation" name="nation" disabled type="text" value="${record.nation}"></td>--%>
                                    <%--</td> --%>
                                    <%--<td><p>政治面貌</p></td>--%>
                                    <%--<td>--%>
                                    <%--<select name="politicsStatus" style="font-size:small; width:100%; height:100%;border: none; padding: 0 0 0 10px;" disabled><custom:dictSelect type="政治面貌" selectedValue="${record.politicsStatus}" /></select>--%>
                                    <%--</td> --%>
                                    <%-- </tr>
                                    <tr>
                                        <td><p>薪酬</p></td>
                                        <td>
                                        <input id="salary" name="salary" disabled tygpe="text" value="${record.salary}" disabled>
                                        </td> --%>
                                    <%--<td><p>出生日期</p></td>--%>
                                    <%--<td><input type="text" id = "birthday" name = "birthday" readonly disabled class="birthday"  value="<fmt:formatDate value="${record.birthday}" pattern="yyyy-MM-dd" />"/></td> --%>
                            </tr>
                            <tr>
                                <td><p>学历</p></td>
                                <td><input id="education" name="education"  type="text"
                                           value="${record.education}">
                                </td>
                                <td><p>毕业院校</p></td>
                                <td><input id="school" name="school"  type="text" value="${record.school}"></td>
                                <td><p>专业</p></td>
                                <td><input id="major" name="major"  type="text" value="${record.major}"></td>
                                    <%--<td><p>紧急联络人</p></td>--%>
                                    <%--<td><input id="emergencyPerson" name="emergencyPerson" disabled type="text" value="${record.emergencyPerson}"></td>--%>
                                    <%--<td><p>紧急联络人电话</p></td>--%>
                                    <%--<td ><input id="emergencyPhone" name="emergencyPhone" disabled type="text" value="${record.emergencyPhone}"></td>--%>
                                    <%--<td><p>毕业院校</p></td>--%>
                                    <%--<td><input id="school" name="school" disabled type="text" value="${record.school}"></td>--%>
                            </tr>
                            <tr>
                                <td><p>职称</p></td>
                                <td colspan="1"><input id="majorName" name="majorName"  type="text"
                                                       value="${record.majorName}"></td>
                                <td><p>政治面貌</p></td>
                                <td colspan="1"><select name="politicsStatus"
                                                        style="font-size:small; height:100%;border: none;width: 100%;text-align: center;"
                                                        >
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
                                                </select>
                                </td>
                                <td style="width: 10%"><p>性别</p></td>
                                <td colspan="1">
                                    <input name="sexName" id="sexName" type="text" value="" >
                                    <input name="sex" id="sex" type="text" value="${record.sex}" hidden>
                                    <%--<select--%>
                                                        <%--id="sex"--%>
                                                        <%--name="sex"--%>
                                                        <%--style="width:100%; height:100%;border: none; padding: 0 0 0 10px;"--%>
                                                        <%--disabled></select>--%>
                                    <%--<custom:dictSelect type="个人档案性别"
                                                                                    selectedValue="${record.sex}"/>--%>
                                </td>
                                    <%--<td><p>移动电话</p></td>--%>
                                    <%--<td><input id="phone" name="phone"  type="text" value="${record.phone}" disable></td>--%>
                                    <%--<td><p>个人邮箱 </p></td>--%>
                                    <%--<td><input id="qq" name="qq"  type="text" value="${record.qq}" disable></td>--%>
                                    <%--<td style="width: 10%"><p>办公邮箱</p></td>--%>
                                    <%--<td colspan="3"><input id="email" name="email"  type="text" value="${record.email}" disable></td>--%>
                            </tr>
                            <tr>
                                <td><p>出生日期</p></td>
                                <td colspan="1"><input type="text" id="birthday" name="birthday" readonly
                                                       class="birthday"
                                                       value="<fmt:formatDate value="${record.birthday}" pattern="yyyy-MM-dd" />"/>
                                </td>
                                <td><p>身份证号码</p></td>
                                <td colspan="1"><input id="idcard" name="idcard" type="text"
                                                       value="${record.idcard}" onkeyup="idCardCheck()"></td>
                                <td><p>身份证地址</p></td>
                                <td colspan="2"><input id="idcardAddress" name="idcardAddress" type="text"
                                                       value="${record.idcardAddress}"></td>
                                    <%--<td><p>学历</p></td>--%>
                                    <%--<td><input id="education" name="education" disabled type="text" value="${record.education}"></td>--%>
                                    <%--<td><p>专业</p></td>--%>
                                    <%--<td><input id="major" name="major" disabled type="text" value="${record.major}"></td>--%>
                                    <%--<td><p>专业技术职称</p></td>--%>
                                    <%--<td colspan="2"><input id="majorName" name="majorName" disabled type="text" value="${record.majorName}"></td>--%>
                            </tr>
                            <tr>
                                <td><p>籍贯</p></td>
                                <td colspan="1"><input id="householdAddress" name="householdAddress"  type="text"
                                                       value="${record.householdAddress }"></td>
                                <td><p>户口性质</p></td>
                                <td><select name="householdState"
                                            style="font-size:small; height: 100%; border: none;width: 100%"
                                            >
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
                                <td colspan="6"><input id="home" name="home" type="text" value="${record.home}"></td>
                            </tr>
                            <tr>
                                <td><p>民族</p></td>
                                <td><input id="nation" name="nation"  type="text" value="${record.nation}"></td>
                                <td><p>工资卡号</p></td>
                                <td><input id="bankCard" name="bankCard"  type="text" value="${record.bankCard }"></td>
                                <td><p>开户银行</p></td>
                                <td colspan="6"><input id="bank" name="bank"  type="text" value="${record.bank }"></td>
                                    <%--<td><p>户口所在地</p></td>--%>
                                    <%--<td><input id="householdAddress" name="householdAddress" disabled type="text" value="${record.householdAddress}"></td>--%>
                                    <%--<td><p>身份证号码</p></td>--%>
                                    <%--<td><input id="idcard" name="idcard" disabled type="text" value="${record.idcard}"></td>--%>
                                    <%--<td><p>身份证地址</p></td>--%>
                                    <%--<td colspan="2"><input id="idcardAddress" name="idcardAddress" disabled type="text" value="${record.idcardAddress}"></td>--%>
                            </tr>
                            <tr>
                                <td><p>在职状态</p></td>
                                <td><select name="entrystatus"
                                            style="font-size:small;  height:100%;border: none; width: 100%">
                                    <custom:dictSelect type="员工在职状态"
                                                                        selectedValue="${record.entrystatus}"/></select>
                                </td>
                                <td><p>入职日期</p></td>
                                <td><input type="text" id="entryTime" name="entryTime" readonly
                                           class="entryTime"
                                           value="<fmt:formatDate value="${record.entryTime}" pattern="yyyy-MM-dd" />"/>
                                </td>
                                <td><p>离职日期</p></td>
                                <td colspan="2"><input id="leaveTime" name="leaveTime" class="leaveTime" type="text"
                                                       readonly
                                                       value="<fmt:formatDate value="${record.leaveTime}" pattern="yyyy-MM-dd" />">
                                </td>
                                    <%--<td><p>户口性质</p></td>--%>
                                    <%--<td>--%>
                                    <%--<select name="householdState" style="font-size:small;width:100%; height: 100%; border: none; padding: 0 0 0 10px;" disabled><custom:dictSelect type="档案户口性质" selectedValue="${record.householdState}" /></select>--%>
                                    <%--</td>--%>
                                    <%--<td><p>现住址</p></td>--%>
                                    <%--<td colspan="6"><input id="home" name="home"  type="text" value="${record.home}"></td>--%>
                            </tr>
                            <tr>
                                <td><p>紧急联络人</p></td>
                                <td><input id="emergencyPerson" name="emergencyPerson"  type="text"
                                           value="${record.emergencyPerson}"></td>
                                <td><p>紧急联络人电话</p></td>
                                <td><input id="emergencyPhone" name="emergencyPhone" type="text"
                                           value="${record.emergencyPhone}"></td>
                                <td><p>联络人关系</p></td>
                                <td colspan="6"><input id="emergencyRelation" name="emergencyRelation"  type="text"
                                                       value="${record.emergencyRelation}"></td>
                                    <%--<td><p>入职日期</p></td>--%>
                                    <%--<td><input type="text" id = "entryTime" name = "entryTime" readonly disabled class="entryTime"  value="<fmt:formatDate value="${record.entryTime}" pattern="yyyy-MM-dd" />"/></td>--%>
                                    <%--<td><p>在职状态</p></td>--%>
                                    <%--<td>--%>
                                    <%--<select name="entrystatus" style="font-size:small; width:100%; height:100%;border: none;  padding: 0 0 0 10px;" disabled><custom:dictSelect type="员工在职状态" selectedValue="${record.entrystatus}" /></select>--%>
                                    <%--</td> --%>
                                    <%--<td><p>离职日期</p></td>--%>
                                    <%--<td colspan="2"><input id="leaveTime" name="leaveTime" class="leaveTime" type = "text"  readonly value="<fmt:formatDate value="${record.leaveTime}" pattern="yyyy-MM-dd" />"></td>--%>
                            </tr>
                                <%--<tr>--%>
                                <%--<td><p>合同期限</p></td>--%>
                                <%--<td colspan = "6">--%>
                                <%--<input readonly disabled id="workBeginDate" name="workBeginDate" class="work_begin_date" style = "height:100%; text-align: center;border: none; " value="<fmt:formatDate value="${record.workBeginDate}" pattern="yyyy-MM-dd" />"/>--%>
                                <%--<span>至</span>--%>
                                <%--<input readonly disabled id="workEndDate" name="workEndDate" class="work_end_date"  style = "height:100%; text-align: center; border: none;"  value="<fmt:formatDate value="${record.workEndDate}" pattern="yyyy-MM-dd" />"/>--%>
                                <%--<input id="unlimited" name="unlimited"  type="hidden" value="${record.unlimited}">--%>
                                <%--<input type="checkbox" id="forever" name="forever" style="vertical-align:middle; margin-top:0;"><span>无固定期限</span>--%>
                                <%--</td>--%>
                                <%--</tr>--%>
                                <%--<tr>--%>
                                <%--<td><p>备注</p></td>--%>
                                <%--<td colspan = "6" rowspan = "2">--%>
                                <%--<textarea id="remark" name="remark"  disabled style="resize:none;width: 100%;  padding: 0;">${record.remark}</textarea>--%>
                                <%--</td>--%>
                                <%--</tr>--%>
                         <shiro:hasAnyPermission name="fin:reimburse:encrypt,fin:reimburse:decrypt,fin:travelreimburse:encrypt,fin:travelreimburse:decrypt">
                            <thead>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size:1em;min-height: 30px;line-height: 30px">
                                        <%-- <select name="householdState" style="font-size:large" disabled><custom:dictSelect type="流程所属公司"/> selectedValue="${record.householdState}" /></select> --%>
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
                                            <tr>
                                                <td class="td_weight" style="border-left-style:hidden;">调薪日期</td>
                                                <td class="td_weight">基本工资</td>
                                                <td class="td_weight">绩效工资</td>
                                                <td class="td_weight">工龄工资</td>
                                                <td class="td_weight">午餐补贴</td>
                                                <td class="td_weight">电脑补贴</td>
                                                <td class="td_weight">公积金</td>
                                                <td class="td_weight">合计</td>
                                                <td class="td_weight">调薪原因</td>
                                               <!--  <td class="td_weight" style="border-right-style:hidden;" name="tdSalarys">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody>
                                             <c:if test="${not empty record.payAdjustments }">
                                            <c:forEach items="${record.payAdjustments }" var="payAdjustment">
                                            <tr name="salary" class="level1">
                                             	<input type="hidden"  name="flag" value="salaryRecord">
                                           	   <input type="hidden" name="payAdjustmentId" value="${payAdjustment.id }">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="changeDate" class="changeDate" readonly value="<fmt:formatDate value="${payAdjustment.changeDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text"  name="basePay" value="${payAdjustment.basePay }" >
                                                </td>
                                                <td style="width: 6%; ">
                                                    <input type="text"  name="meritPay" value="${payAdjustment.meritPay }">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text" name="agePay" value="${payAdjustment.agePay }">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text" name="lunchSubsidy" value="${payAdjustment.lunchSubsidy }">
                                                </td>
                                                <td style="width: 5%;">
                                                    <input type="text" name="computerSubsidy" value="${payAdjustment.computerSubsidy }">
                                                </td>
                                                <td style="width: 5%;">
                                                    <input type="text" name="accumulationFund" value="${payAdjustment.accumulationFund }">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <div style="display:flex">
                                                        <span  name="total">${payAdjustment.total }</span>
                                                    </div>
                                                </td>
                                                <td style="width: 18%;"><textarea name="payReason"
                                                                                  autocomplete="off">${payAdjustment.payReason }</textarea></td>
                                               <%--  <td style="width: 4%;" name="tdSalary">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);" style="font-size:x-large" onclick="node('add', 'salaryRecord', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
                                                    <a href="javascript:void(0);" style="font-size:x-large" onclick="node('del', 'salaryRecord', this)"><img alt="删除" src="<%=base%>/static/images/del.png" ></a>
                                                    </span>
                                                </td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                            <c:if test="${empty record.payAdjustments }">
                                             <tr name="salary" class="level1">
                                              <input type="hidden"  name="flag" value="salaryRecord">
                                             <input type="hidden" name="payAdjustmentId" value="">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="changeDate" class="changeDate" readonly value="">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text"  name="basePay" value="">
                                                </td>
                                                <td style="width: 6%; ">
                                                    <input type="text"  name="meritPay" value="">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text" name="agePay" value="">
                                                </td>
                                                <td style="width: 6%;">
                                                    <input type="text" name="lunchSubsidy" value="">
                                                </td>
                                                <td style="width: 5%;">
                                                    <input type="text" name="computerSubsidy" value="">
                                                </td>
                                                <td style="width: 5%;">
                                                    <input type="text" name="accumulationFund" value="">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <div style="display:flex">
                                                        <span  name="total"></span>
                                                    </div>
                                                </td>
                                                <td style="width: 18%;"><textarea name="payReason"
                                                                                  autocomplete="off"></textarea></td>
                                                <%-- <td style="width: 4%;" >
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);" style="font-size:x-large" onclick="node('add', 'salaryRecord', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a>
                                                    <a href="javascript:void(0);" style="font-size:x-large" onclick="node('del', 'salaryRecord', this)"><img alt="删除" src="<%=base%>/static/images/del.png" ></a>
                                                    </span>
                                                </td> --%>
                                            </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                           </shiro:hasAnyPermission>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                                <!-- <td class="td_weight" style="border-right-style:hidden;">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty record.postAppointments }">
                                            <c:forEach items="${record.postAppointments }" var="postAppointment">
                                            <tr name="station"  class="level1">
                                             <input type="hidden"  name="flag" value="stationRecord">
                                            <input type="hidden" name="postAppointmentId" value="${postAppointment.id }">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="postDate" class="postDate" value="<fmt:formatDate value="${postAppointment.postDate}" pattern="yyyy-MM-dd" />" readonly>
                                                </td>
                                                <td style="width: 12%;">
                                                   <%--  <input type="text" name="postAppointmentCompany" value="${postAppointment.company }"> --%>
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
                                                <td style="width: 18%;"><textarea name="postReason"
                                                                                  autocomplete="off">${postAppointment.postReason }</textarea></td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'stationRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a>
                                                    <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'stationRecord', this)"><img
                                                        alt="删除" src="<%=base%>/static/images/del.png"></a>
                                                    </span></td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                             <c:if test="${empty record.postAppointments }">
                                             <tr name="station" class="level1">
                                             <input type="hidden"  name="flag" value="stationRecord">
                                              <input type="hidden" name="postAppointmentId" value="">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="postDate" class="postDate" value="" readonly>
                                                </td>
                                                <td style="width: 12%;">
                                                   <!--  <input type="text" name="postAppointmentCompany" value=""> -->
                                                   <select name="postAppointmentCompany"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 6%; ">
                                                    <select name="postAppointmentDept"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="部门"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 6%;">
                                                    <select name="postAppointmentProjectTeam"
                                                            style="width:100%;">
                                                        <option value=""></option>
                                                        <custom:dictSelect type="项目组"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 10%;">
                                                    <select name="station"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="岗位"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <select name="appoint"
                                                            style="width:100%;">
                                                         <option value=""></option>
                                                        <custom:dictSelect type="任免"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 18%;"><textarea name="postReason"
                                                                                  autocomplete="off"></textarea></td>
                                                <%-- <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'stationRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a>
                                                    <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'stationRecord', this)"><img
                                                        alt="删除" src="<%=base%>/static/images/del.png"></a>
                                                    </span></td> --%>
                                            </tr>
                                             </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size:1em;">
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
                                               <!--  <td class="td_weight" style="border-right-style:hidden;">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody> 
                                            <c:if test="${not empty record.arbeitsvertrags }">
                                            <c:forEach items="${record.arbeitsvertrags }" var="arbeitsvertrag">
                                            <tr name="sign" class="level1">
                                            <input type="hidden"  name="flag" value="signRecord">
                                            	<input type="hidden" name="arbeitsvertragId" value="${arbeitsvertrag.id }">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="signDate" class="signDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.signDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 12%;">
                                                   <!--  <input type="text" name="arbeitsvertragCompany" value=""> -->
                                                   <select name="arbeitsvertragCompany"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue="${arbeitsvertrag.company }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 12%;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.beginDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 10%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${arbeitsvertrag.endDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <select name="barginType"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="合同性质"
                                                                           selectedValue="${arbeitsvertrag.barginType }"/>
                                                    </select>
                                                </td>
                                                <td style="width: 18%;"><textarea name="signReason"
                                                                                  autocomplete="off">${arbeitsvertrag.signReason }</textarea></td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'signRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'signRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                             <c:if test="${empty record.arbeitsvertrags }">
                                             	<tr name="sign"  class="level1">
                                             	 <input type="hidden"  name="flag" value="signRecord">
                                             	 <input type="hidden" name="arbeitsvertragId" value="">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="signDate" class="signDate" readonly value="">
                                                </td>
                                                <td style="width: 12%;">
                                                    <!-- <input type="text" name="arbeitsvertragCompany" value=""> -->
                                                     <select name="arbeitsvertragCompany"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="存续公司"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 12%;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                </td>
                                                <td style="width: 10%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <select name="barginType"
                                                            style="width:100%;">
                                                             <option value=""></option>
                                                        <custom:dictSelect type="合同性质"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <td style="width: 18%;"><textarea name="signReason"
                                                                                  autocomplete="off"></textarea></td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'signRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'signRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                             </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                               <!--  <td class="td_weight" style="border-right-style:hidden;">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty record.jobRecords }">
                                            <c:forEach items="${record.jobRecords }" var="jobRecord">
                                            <tr name="oldwork"  class="level1">
                                            <input type="hidden"  name="flag" value="oldworkRecord">
                                            	<input type="hidden" name="jobRecordId" value="${jobRecord.id }">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${jobRecord.beginDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 6.8%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${jobRecord.endDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 27.2%;">
                                                    <input type="text" name="jobRecordCompany" value="${jobRecord.company }">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <input type="text" name="station" value="${jobRecord.station }">
                                                </td>
                                                <td style="width: 18%;"><textarea name="duty"
                                                                                  autocomplete="off">${jobRecord.duty }</textarea></td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'oldworkRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'oldworkRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                            <c:if test="${empty record.jobRecords }">
                                            <tr name="oldwork" class="level1">
                                             	<input type="hidden" name="jobRecordId" value="">
                                            	<input type="hidden"  name="flag" value="oldworkRecord">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                </td>
                                                <td style="width: 6.8%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="">
                                                </td>
                                                <td style="width: 27.2%;">
                                                    <input type="text" name="jobRecordCompany" value="">
                                                </td>
                                                <td style="width: 5%;height:auto;">
                                                    <input type="text" name="station" value="">
                                                </td>
                                                <td style="width: 18%;"><textarea name="duty"
                                                                                  autocomplete="off"></textarea></td>
                                                <%-- <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'oldworkRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'oldworkRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                            
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                               <!--  <td class="td_weight" style="border-right-style:hidden;">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty record.educations }">
                                            <c:forEach items="${record.educations}" var="education">
                                            <tr name="education" class="level1">
                                            <input type="hidden" name="educationId" value="${education.id }">
                                            <input type="hidden" id="recordId" name="recordId" value="${record.id}">
                                             <input type="hidden"  name="flag" value="educationRecord">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="<fmt:formatDate value="${education.beginDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 6.8%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="<fmt:formatDate value="${education.endDate}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td style="width: 12.2%;">
                                                    <input type="text" name="educationSchool" value="${education.school }">
                                                </td>
                                                <td style="width: 20%;height:auto;">
                                                    <input type="text" name="department" value="${education.department }">
                                                </td>
                                                <td style="width: 9%;height:auto;">
                                                    <input type="text" name="educationMajor" value="${education.major }">
                                                </td>
                                                <td style="width: 9%;height:auto;">
                                                    <select name="educationEducation"
                                                            style="width:100%;">
                                                        <custom:dictSelect type="学历"
                                                                           selectedValue="${education.education}"/>
                                                    </select>
                                                </td>
                                                <%-- <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'educationRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'educationRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                            <c:if test="${empty record.educations }">
                                            <tr name="education" class="level1">
                                             <input type="hidden" name="educationId" value="">
                                               <input type="hidden"  name="flag" value="educationRecord">
                                            <input type="hidden" id="recordId" name="recordId" value="${record.id}">
                                                <td style="width: 6.8%; border-left-style:hidden;">
                                                    <input type="text" name="beginDate" class="beginDate" readonly value="">
                                                </td>
                                                <td style="width: 6.8%;">
                                                    <input type="text" name="endDate" class="endDate" readonly value="">
                                                </td>
                                                <td style="width: 12.2%;">
                                                    <input type="text" name="educationSchool" style="text-align:right" value="">
                                                </td>
                                                <td style="width: 20%;height:auto;">
                                                    <input type="text" name="department" value="">
                                                </td>
                                                <td style="width: 9%;height:auto;">
                                                    <input type="text" name="educationMajor" value="">
                                                </td>
                                                <td style="width: 9%;height:auto;">
                                                    <select name="educationEducation"
                                                            style="width:100%;">
                                                         <option value=""></option>
                                                        <custom:dictSelect type="学历"
                                                                           selectedValue=""/>
                                                    </select>
                                                </td>
                                                <%-- <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                    <a href="javascript:void(0);"
                                                                          style="font-size:x-large"
                                                                          onclick="node('add', 'educationRecord', this)"><img
                                                        alt="添加" src="<%=base%>/static/images/add.png"
                                                        style="margin-right: 6px"></a> <a href="javascript:void(0);"
                                                                                          style="font-size:x-large"
                                                                                          onclick="node('del', 'educationRecord', this)"><img
                                                            alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                           	 </tr>
                                             </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                                <td class="td_weight" style="width: 8%;">日期</td>
                                                <td class="td_weight" style="width: 13%;">颁发单位</td>
                                                <td class="td_weight" style="width:13%;">证书/荣誉名称</td>
                                                <td class="td_weight" style="width: 9%;">有效期</td>
                                                <td class="td_weight" style="width: 8%;">有效期（是否长期）</td>
                                                <td class="td_weight" style="width: 23%;">证书扫描件</td>
                                               <!--  <td class="td_weight" style="border-right-style:hidden;">操作</td> -->
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty record.certificates }">
                                            <c:forEach items="${record.certificates }" var="certificate">
                                            <tr name="honor" class="clHonor level1">
                                            	<input type="hidden" name="certificateId" value="${certificate.id }">
                                            	<input type="hidden" id="recordId" name="recordId" value="${record.id}">
                                            	<input type="hidden"  name="hiddenPath" value="${certificate.scannings}">
                        						<input type="hidden"  name="hiddenName" value="${certificate.scanningName}">
                        							<input type="hidden"  name="flag" value="honorRecord">
                                                <td >
                                                    <input type="text" class="date" name="date" value="<fmt:formatDate value="${certificate.date}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td >
                                                    <input type="text" name="issuingUnit" value="${certificate.issuingUnit }">
                                                </td>
                                                <td >
                                                    <input type="text" name="honor" value="${certificate.honor }">
                                                </td>
                                                <td >
                                                    <input type="text" class="validity" name="validity" value="<fmt:formatDate value="${certificate.validity}" pattern="yyyy-MM-dd" />">
                                                </td>
                                                <td>
	                                                <select  name="isValidity" style="width:98%;" onchange="selectOnchang(this)">
	                                                	<c:if test="${certificate.isValidity eq '0'}">
	                                                	 	<option value=""></option>
	                                                	 	<option value="${certificate.isValidity}" selected="selected">长期</option>
	                                                	 	<option value="1">否</option>
		                                                </c:if>
		                                                <c:if test="${certificate.isValidity eq '1'}">
		                                                	<option value=""></option>
		                                                	<option value="0">长期</option>
		                                                	<option value="${certificate.isValidity}" selected="selected">否</option>
		                                                </c:if>
		                                                <c:if test="${empty certificate.isValidity}">
			                                                <option value=""></option>
															<option value="0">长期</option>
															<option value="1">否</option>
														</c:if>
													</select>
                                                </td>
                                                <td  >
                                                    <input type="file"  name="scanFile" style="display:none;">
                                                    <a href="javascript:void(0);" onclick="downloadAttach(this)" style="width:auto; display: inline-block;" value="${certificate.scannings}" target='_blank'>
															<input type="text"   name="scanName1" value="${certificate.scanningName}" style="width:auto" readonly>
													</a>
													 <input type="button" name="BuSelect" value="点击上传扫描件" onclick="selectScan(this)" style="border:none;display:none;" href="javascript:;"> 
                                                </td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                        <a href="javascript:void(0);" onclick="node('add', 'honorRecord', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'honorRecord', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a></span></td> --%>
                                            </tr>
                                            </c:forEach>
                                            </c:if>
                                            <c:if test="${empty record.certificates }">
                                             <tr name="honor"  class="level1">
                                              <input type="hidden" name="certificateId" value="">
                                            	<input type="hidden" id="recordId" name="recordId" value="${record.id}">
                                            	<input type="hidden"  name="hiddenPath" value="">
                        						<input type="hidden"  name="hiddenName" value="">
                        						<input type="hidden"  name="flag" value="honorRecord">
                                                <td style="width: 8%;">
                                                    <input type="text" class="date" name="date" value="" readonly>
                                                </td>
                                                <td style="width: 10%;">
                                                    <input type="text" name="issuingUnit" value="">
                                                </td>
                                                <td style="width: 10%;">
                                                    <input type="text" name="honor" value="">
                                                </td>
                                                <td style="width: 9%;">
                                                    <input type="text" class="validity" name="validity" value="" readonly>
                                                </td>
                                                 <td style="width: 9%;">
                                                    <select  name="isValidity" style="width:98%;" onchange="selectOnchang(this)">
	                                                	<option value=""></option>
														<option value="0">长期</option>
														<option value="1">否</option>
													</select>
                                                </td>
                                                <td style="width: 20%;" >
                                               		<!-- <input type="button" value="点击上传扫描件" onclick="selectScan(this)" style="border:none;" href="javascript:;"> --> 
                                                    <input type="text"  name="scanName"  value="" readonly  placeholder="选择扫描件">
                                                    <input type="file"  name="scanFile" style="display:none;">
                                                </td>
                                               <%--  <td style="width: 4%;">
                                                    <span style="margin-left: 20%" hidden>
                                                        <a href="javascript:void(0);" onclick="node('add', 'honorRecord', this)" style="font-size:x-large;"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" onclick="node('del', 'honorRecord', this)" style="font-size:x-large;"><img alt="删除" src="<%=base%>/static/images/del.png"></a></span></td>
                                            --%> 
                                            </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>

                            </tbody>
                        </table>
                    </form>
                 
                   <c:if test="${not empty sysUser }">
                   <div style="width:100%; text-align:center;padding: 10px" id="userDiv">
                    <form id="form1" class="form-horizontal tbspace" method="post">
                    <input type="hidden" name="photPath" id="photPath" value="${sysUser.photo}">
                    <input type="hidden" id="userid" name="userid" value="${sysUser.id}">
						<div class="form-group">
							<label for="account" class="col-sm-1 control-label">帐号</label>
							<div class="col-sm-4">
								<input type="text" name="account" style="display: none">
								<input class="form-control" id="account" name="account" placeholder="帐号" value="${sysUser.account}" autocomplete="off">
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">姓名</label>
							<div class="col-sm-4">
								<input class="form-control" id="userName" name="name" placeholder="姓名" value="${sysUser.name}"  readonly>
							</div>
							<label for="userId" class="col-sm-1 control-label">负责人</label>
							<div class="col-sm-4">
								<input id="principalName" name="principalName" value="${sysUser.principalName}"
									   style="border-style:none;width: 50px" readonly>
								<input type="hidden" name="principalId" id="principalId" value="${sysUser.principalId}">
								<button type="button" class="btn btn-default" onclick="openDialog(this)" name="depeSelect">选择</button>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">所属单位</label>
							<div class="col-sm-4">
								<label id="deptName" class="control-label">${sysUser.dept.name }</label>
								<input type="hidden" name="deptId" id="deptId" value="${sysUser.deptId}">
								<button type="button" id="deptselect" class="btn btn-default" onclick="openDept()">选择</button>
							</div> 
							<label for="userId" class="col-sm-1 control-label">所处职位</label>
							<div class="col-sm-4">
								<label id="positionName" class="control-label"></label>
								<input type="hidden" name="positionId" id="positionId" value="">
								<button type="button"  id="stionselect" class="btn btn-default" onclick="openPosition()">选择</button>
							</div>
							
						</div>
						<div class="form-group"> 
							<h3 class="col-sm-2" style="margin-left:30%;"><font style="font-size:16px;font-weight:bold;">选择角色</font></h3>
						</div>
                        <div id="deptAndRoles"></div>
					</form>
                   </div>
                   </c:if>
                </div>
                 <div style="width:100%; text-align:center;padding: 10px">
                            <button id="print_btn" type="button" class="btn btn-primary" onclick="print(${record.id})">打印</button>
                            <button id="export_btn" type="button" class="btn btn-primary" onclick="pdf(${record.id})">导出</button>
                            <button id="edit_btn" type="button" class="btn btn-primary" onclick="edit()">编辑</button>
                            <c:if test="${not empty sysUser }">
                             	<button id="del_btn" type="button" class="btn btn-primary" onclick="del()">删除</button>
                             	<button id="re_btn" type="button" class="btn btn-primary" onclick="resetPassword(${sysUser.id})">重置密码</button>
                            </c:if>
                            <button id="backNoSaveBtn" type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
                            <!-- <button id="reload_btn" type="button" class="btn btn-primary" onclick="window.location.reload(true);return false;" >重置</button> -->
                            <button id="save_btn" type="button" class="btn btn-warning dropdown-toggle"
                                    onclick="upload()" >保存
                            </button>
                            <button type="button" id="backBtn" class="btn btn-default" onclick="goBack()">返回</button>
                  </div>
               </div>
            </div>
        </section>
    </section>
</div>
<div id="deptDialog"></div>
<div id="positionDialog"></div>
<div id="userByDeptDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="deptModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="border-bottom-color:#3c8dbc">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel" style="font-weight: bolder;">组织架构</h4>
            </div>
            <div class="modal-body">
                <div class="box-body" style="min-height: 200px;">
                    <div id="dept_div" class="col-md-6">
                        <ul id="deptTree" class="ztree"></ul>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="setDept()">确认</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->


    </shiro:hasPermission>

    <script>
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
		var user =${userJson};
		
		var loginUser=${loginUser};
		var position=loginUser.positionList;
		var showFlag=true;
		for(var i=0;i<position.length;i++){
			if(position[i].name=="前台文员"){
				showFlag=false;
				break;
			}
		}
		var showuserFlag=true;
		for(var i=0;i<position.length;i++){
			if(position[i].name=="会计" || position[i].name=="财务" || position[i].name=="会计经办"){
				showuserFlag=false;
				break;
			}
		}
		
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
    <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
    <script type="text/javascript" src="<%=base%>/views/manage/ad/record/js/edit.js"></script>
   
</body>
</html>