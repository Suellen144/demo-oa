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
      <link rel="stylesheet"
          href="<%=base%>/static/bootstrap/css/bootstrap-select.min.css">
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
                        <input type="hidden" id="id" name="id" value="">
                        <input type="hidden" id="userId" name="userId" value="">
                        <input type="hidden" id="photo" name="photo" value="">
                        <input id="companyId" name="companyId"  type="hidden" value = "${companyId}">
                        <table id="table1" style="width: 98%">
                            <select id="dept_hidden" style="display: none">
                                <custom:dictSelect type="部门"/>
                            </select>
                            <select id="projectTeam_hidden" style="display: none">
                                <custom:dictSelect type="项目组"/>
                            </select>
                            <select id="station_hidden" style="display: none" >
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
                                    员工档案
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td><p>员工编号</p></td>
                                <td colspan="1"><input id="number" name="number" type="text" readonly></td>
                                <td><p>姓名</p></td>
                                <td colspan="1"><input id="name" name="name" type="text"
                                                       value="" onchange="setUserName(this)"></td>
                                <td><p>岗位</p>
                                <td colspan="1"><input id="position" name="position"  type="text" value="" readonly></td>
                                </td>
                                <!-- 档案照片 -->
                                <td rowspan="5" colspan="1" style="text-align: center;width:200px;">
                                    <img id="recordImg"  src="" width="80"
                                         height="120" onclick="select()"/>
                                    <input id="file" type="file" name="file" style="display:none;"/>
                                    <span id="imgName" style="overflow-x: scroll;width: auto;"></span>
                                </td>
                            </tr>
                            <tr rowspan="1">
                                <td><p>公司</p></td>
                                <td colspan="1"><input id="company" name="company"  type="text" value="" readonly></td>
                                <td><p>部门</p></td>
                                <td colspan="1">
                                    <input id="dept" name="dept"  type="text" value=""  readonly>
                                </td>
                                <td><p>项目组</p></td>
                                <td colspan="1"><input id="projectTeam" name="projectTeam"  type="text" value="" readonly></td>
                            </tr>
                            <tr>
                                <td><p>电话</p></td>
                                <td><input id="phone" name="phone" type="text" value="" ></td>
                                <td><p>工作邮箱</p></td>
                                <td colspan="1"><input id="email" name="email" type="text" value=""></td>
                                <td><p>个人邮箱 </p></td>
                                <td><input id="qq" name="qq" type="text" value=""></td>
                            </tr>
                            <tr>
                                <td><p>学历</p></td>
                                <td><input id="education" name="education"  type="text"
                                           value="" readonly>
                                </td>
                                <td><p>毕业院校</p></td>
                                <td><input id="school" name="school"  type="text" value="" readonly></td>
                                <td><p>专业</p></td>
                                <td><input id="major" name="major"  type="text" value="" readonly></td>
                            </tr>
                            <tr>
                                <td><p>职称</p></td>
                                <td colspan="1"><input id="majorName" name="majorName"  type="text"
                                                       value=""></td>
                                <td><p>政治面貌</p></td>
                                <td colspan="1"><select name="politicsStatus"
                                                        style="font-size:small; height:100%;border: none;width: 100%;text-align: center;"
                                                        >
                                                        <option value=""></option>
                                                        <custom:dictSelect type="政治面貌"
                                                                                    selectedValue="${record.politicsStatus}"/></select>
                                </td>
                                <td style="width: 10%"><p>性别</p></td>
                                <td colspan="1">
                                    <input name="sexName" id="sexName" type="text" value="" readonly>
                                    <input name="sex" id="sex" type="text" value="" hidden>
                                </td>
                            </tr>
                            <tr>
                                <td><p>出生日期</p></td>
                                <td colspan="1"><input type="text" id="birthday" name="birthday" readonly
                                                       class="birthday"
                                                       value=""/>
                                </td>
                                <td><p>身份证号码</p></td>
                                <td colspan="1"><input id="idcard" name="idcard" type="text"
                                                       value="" onkeyup="idCardCheck()"></td>
                                <td><p>身份证地址</p></td>
                                <td colspan="2"><input id="idcardAddress" name="idcardAddress" type="text"
                                                       value=""></td>
                            </tr>
                            <tr>
                                <td><p>籍贯</p></td>
                                <td colspan="1"><input id="householdAddress" name="householdAddress"  type="text"
                                                       value=""></td>
                                <td><p>户口性质</p></td>
                                <td><select name="householdState"
                                            style="font-size:small; height: 100%; border: none;width: 100%"
                                            >
                                            <option value=""></option>
                                            <custom:dictSelect type="档案户口性质"
                                                                        selectedValue="${record.householdState}"/></select>
                                </td>
                                <td><p>通信地址</p></td>
                                <td colspan="6"><input id="home" name="home" type="text" value=""></td>
                            </tr>
                            <tr>
                                <td><p>民族</p></td>
                                <td><input id="nation" name="nation"  type="text" value=""></td>
                                <td><p>工资卡号</p></td>
                                <td><input id="bankCard" name="bankCard"  type="text" value=""></td>
                                <td><p>开户银行</p></td>
                                <td colspan="6"><input id="bank" name="bank"  type="text" value=""></td>
                            </tr>
                            <tr>
                                <td><p>在职状态</p></td>
                                <td><select name="entrystatus"
                                            style="font-size:small;  height:100%;border: none; width: 100%">
                                            <option value=""></option>
                                    <custom:dictSelect type="员工在职状态"
                                                                        selectedValue=""/></select>
                                </td>
                                <td><p>入职日期</p></td>
                                <td><input type="text" id="entryTime" name="entryTime" readonly
                                           class="entryTime"
                                           value=""/>
                                </td>
                                <td><p>离职日期</p></td>
                                <td colspan="2"><input id="leaveTime" name="leaveTime" class="leaveTime" type="text"
                                                       readonly
                                                       value="">
                                </td>
                            </tr>
                            <tr>
                                <td><p>紧急联络人</p></td>
                                <td><input id="emergencyPerson" name="emergencyPerson"  type="text"
                                           value=""></td>
                                <td><p>紧急联络人电话</p></td>
                                <td><input id="emergencyPhone" name="emergencyPhone" type="text"
                                           value=""></td>
                                <td><p>联络人关系</p></td>
                                <td colspan="6"><input id="emergencyRelation" name="emergencyRelation"  type="text"
                                                       value=""></td>
                            </tr>
                 	  <shiro:hasAnyPermission name="fin:reimburse:encrypt,fin:reimburse:decrypt,fin:travelreimburse:encrypt,fin:travelreimburse:decrypt">
                            <thead>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size:1em;min-height: 30px;line-height: 30px">
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
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                         </shiro:hasAnyPermission> 
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                                    <select name="postAppointmentDept" id="postAppointmentDept"
                                                            style="width:100%;" onchange="onPostAppointmentProjectTeam()">
                                                             <option value=""></option>
                                                    </select>
                                                </td>
                                                <td style="width: 6%;">
                                                    <select name="postAppointmentProjectTeam" id="postAppointmentProjectTeam"
                                                            style="width:100%;">
                                                    </select>
                                                </td>
                                                <td style="width: 10%;">
                                                    <select name="station"
                                                            style="width:100%;" >
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
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size:1em;">
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
                                               </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                               </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>
                            <tr>
                                <th colspan="10" style="text-align:center; border: solid #999 1px; font-size: 1em;">
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
                                            <tr name="education" class="level1">
                                             <input type="hidden" name="educationId" value="">
                                               <input type="hidden"  name="flag" value="educationRecord">
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
                                               </tr>
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
                                            </tr>
                                            </thead>
                                            <tbody>
                                             <tr name="honor"  class="level1">
                                              <input type="hidden" name="certificateId" value="">
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
                                                <td style="width: 8%;">
	                                                <select  name="isValidity" style="width:98%;" onchange="selectOnchang(this)">
	                                                	<option value=""></option>
														<option value="0">长期</option>
														<option value="1">否</option>
													</select>
                                                </td>
                                                <td style="width: 20%;" >
                                               		<!-- <input type="button" value="点击上传扫描件" onclick="selectScan(this)" style="border:none;" href="javascript:;"> --> 
                                                    <input type="text"  name="scanName"  value="" readonly  placeholder="选择扫描件" onclick="selectScan(this)">
                                                    <input type="file"  name="scanFile" style="display:none;">
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            </tbody>

                            </tbody>
                        </table>
                    </form>
                    <div style="width:100%; text-align:center;padding: 10px">
                    <form id="form1" class="form-horizontal tbspace" method="post">
                    <input type="hidden" name="photPath" id="photPath" value="">
						<div class="form-group">
							<label for="account" class="col-sm-1 control-label">帐号</label>
							<div class="col-sm-4">
								<input type="text" name="account" style="display: none">
								<input class="form-control" id="account" name="account" placeholder="帐号" value="" readonly autocomplete="off">
							</div>
							<label for="password" class="col-sm-1 control-label">密码</label>
							<div class="col-sm-4">
								<input type="text" style="display: none">
								<input class="form-control" type="password" id="password" name="password" placeholder="密码" value="" readonly autocomplete="off">
								<div style="color:red;">（初始密码为八位随机数,通过邮件发送至该用户邮箱，请及时修改新密码！）</div>
							</div>
						</div>
						<div class="form-group" style="display: none">
							<label for="name" class="col-sm-1 control-label">姓名</label>
							<div class="col-sm-4">
								<input class="form-control" id="userName" name="name" placeholder="姓名" value="" disabled="disabled">
							</div>
							<label for="userId" class="col-sm-1 control-label">负责人</label>
							<div class="col-sm-4">
								<input id="principalName" name="principalName" value=""
									   style="border-style:none;width: 50px" readonly>
								<input type="hidden" name="principalId" id="principalId" value="">
								<!-- <input type="hidden" name="positionId" id="positionId" value="">
								<input type="hidden" name="deptId" id="deptId" value=""> -->
								<button type="button" class="btn btn-default" onclick="openDialog(this)">选择</button>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">所属单位</label>
							<div class="col-sm-4">
								<label id="deptName" class="control-label"></label>
								<input type="hidden" name="deptId" id="deptId" value="">
								<button type="button" class="btn btn-default" onclick="openDept()">选择</button>
							</div> 
							<label for="userId" class="col-sm-1 control-label">所处职位</label>
							<div class="col-sm-4">
								<label id="positionName" class="control-label"></label>
								<input type="hidden" name="positionId" id="positionId" value="">
								<button type="button" class="btn btn-default" onclick="openPosition()">选择</button>
							</div>
							
						</div>
						<div class="form-group"> 
							<h3 class="col-sm-2" style="margin-left:30%;"><font style="font-size:16px;font-weight:bold;">选择角色</font></h3>
						</div>
						<%-- <c:forEach items="${user.positionList }" var="position">
						<c:if test="${position.name eq '前台文员' }">
						<div class="form-group col-sm-7" id="roles" style="margin-left:15px;">
							<c:forEach items="${roleList}" var="role">
								<c:if test="${role.name eq '普通员工'}">
								<label class="col-sm-3 control-label" style="text-align:left;">
									<input type="checkbox" style="vertical-align:middle; margin-top:0;" name="roleidList[]" value="${role.id}"> ${role.name}
								</label>
								</c:if>
							</c:forEach>
						</div>
						</c:if>
						</c:forEach> --%>
						<c:set var="flag" value="true" /> 
						<c:forEach items="${user.positionList }" var="position">
						<c:if test="${(position.name eq '前台文员'  or position.name eq '行政主管'  or position.name eq '人事经理' or position.name eq '总经理') and flag}">
						<div id="deptAndRoles"></div>
						<c:set var="flag" value="false" /> 
						</c:if>
						</c:forEach>
						<c:if test="${user.name eq '超级管理员' }">
                            <div id="deptAndRoles"></div>
						</c:if>
					</form>
                   </div>
                </div>
				 <div style="width:100%; text-align:center;padding: 10px">
                            <button id="edit_btn" type="button" class="btn btn-primary" onclick="upload()">保存</button>
                            <button id="backNoSaveBtn" type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
                            <button id="reload_btn" type="button" class="btn btn-primary" onclick="window.location.reload(true);return false;" >重置</button>
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
     <script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-select.js"></script>
    <script type="text/javascript"
            src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui-1.12.1/jquery-ui.min.js"></script>
    <script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
    <script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
   
    <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
    <script type="text/javascript" src="<%=base%>/static/jquery/ChinesePY.js"></script>
    <script type="text/javascript" src="<%=base%>/views/manage/ad/record/js/add.js"></script>

</body>
</html>