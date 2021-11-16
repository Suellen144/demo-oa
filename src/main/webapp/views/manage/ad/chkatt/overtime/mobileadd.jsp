<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../../common/header.jsp"%>
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
    <style>
        #table1 {
            width: 90%;
            table-collapse: collapse;
            border: none;
            margin: auto;
        }
        #table1 td {
            padding: 5px;
        }

        select{
            appearance:none;
            -moz-appearance:none;
            -webkit-appearance:none;
            border: none;
        }

        /* IE10以上生效 */
        select::-ms-expand {
            display: none;
        }


        #table1 td input[type="text"] {
            width: 100%;
            height: 100%;
            border: none;
            outline: medium;
        }
        #table1 td span {
            width: 100%;
            text-align: center;
            display: block;
            font-weight: bold;
            padding: 0px 5px;
        }
        #table1 th {
            border: solid #999 1px;
            border: none;
            text-align: center;
            font-size: 1.5em;
        }
        textarea {
            width: 100%;
            resize: none;
            outline: medium;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <header>
        <ol class="breadcrumb">
            <li class="active">主页</li>
            <li class="active">行政管理</li>
            <li class="active">加班管理</li>
            <li class="active">申请加班</li>
        </ol>
    </header>

    <!-- Main content -->
    <section class="content rlspace">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary tbspace">
                    <form id="form1">
                        <input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
                        <input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">

                        <table id="table1">
                            <thead>
                                <section class="content-header">
                                    <h1>加班申请表</h1>
                                </section>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="mFormName"><span>姓名</span></td>
                                <td class="mFormMsg"><input type="text" value="${sessionScope.user.name }" readonly></td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span>单位</span></td>
                                <td class="mFormMsg" style="line-height:inherit;white-space: nowrap;">
                                    <c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
                                        <select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" /></select>
                                        <c:if test="${sessionScope.user.dept.name  ne '总经理'}">
                                            ${sessionScope.user.dept.name }
                                        </c:if>
                                    </c:if>
                                    <c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
                                        <input name="title" value="10" type="hidden">
                                        <custom:getDictKey type="流程所属公司" value="10"/>
                                        ${sessionScope.user.dept.name }
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span>提交时间</span></td>
                                <td class="mFormMsg"><input type="text" name="applyTime" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" readonly></td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span>起止时间</span></td>
                                <td class="mFormMsg">
                                    自
                                    <input id="startTime" name="startTime" size="18" class="starttime" style="width:100%;" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span></span></td>
                                <td class="mFormMsg">
                                    至
                                    <input id="endTime" name="endTime" size="18" class="endtime" style="width:100%;" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span></span></td>
                                <td class="mFormMsg">
                                    共
                                    <input id="days" name="days" style="width:3em;">
                                    <label id="label_days">天</label>
                                    <input id="hours" name="hours" style="width:3em;">
                                    <label id="label_hours">小时</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="mFormName"><span>加班事由</span></td>
                                <td class="mFormMsg" ><textarea name="reason" rows="7" cols="70"></textarea></td>
                            </tr>
                            </tbody>
                        </table>
                        <div style="width: 80%; text-align: center;margin:auto;margin-top:5px;">
                            <button type="button" class="btn btn-primary" onclick="save()" >提交</button>
                            <button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/overtime/js/add.js"></script>
</body>
</html>