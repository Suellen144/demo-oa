<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
</head>
<body>
<header>
    <%--<ol class="breadcrumb">--%>
        <%--<li class="active">主页</li>--%>
        <%--<li class="active">财务管理</li>--%>
        <%--<li class="active">财务统计</li>--%>
    <%--</ol>--%>
</header>
<style>
    #myTab>li.active a{
        background-color: #3c8dbc;
        color: white;
        font-weight: bold;
    }
</style>
    <div class="wrapper">
    <!-- Main content -->
        <section class="content rlspace">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-primary">
                        <div class="box-header">
                            <form id="searchForm" class="form-inline" role="form">
                                <div class="col-xs-12">
                                    <div  class="col-xs-4">
                                        <span><label class="control-label">时间：</label></span>
                                        <input id="beginDate" name="beginDate" placeholder="开始时间" style="background-color: inherit;width: 30%;" readonly>
                                        <span>到</span>
                                        <input id="endDate" name="endDate" placeholder="结束时间" style="background-color: inherit;width: 30%;" readonly>
                                    </div>
                                    <div class="col-xs-4">
                                        <span><input id="whetherSelectProject" name="whetherSelectProject" type="checkbox" value="1"></span>
                                        <span><label class="control-label">项目：</label></span>
                                        <span style="width:15%;">
                                            <input type="text" name="projectName"  id="projectName" onclick="openProject(this)" readonly/>
                                            <input type="text" name="projectId" id="projectId" value="" style="display:none;">
                                        </span>
                                    </div>
                                    <div class="col-xs-4">
                                        <span><label class="control-label">合同：</label></span>
                                        <span>
                                            <input type="button" value="请选择合同" onclick="openBargin()" style="border:none;">
                                            <input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;display:none;">
                                            <input type="text" id="barginProcessInstanceId" value="" style="display:none;">
                                            <input type="text" id="barginId" name="barginId" value="" style="display:none;">
                                        </span>
                                    </div>
                                </div>
                                <br><br>
                                <div class="col-xs-12">
                                    <div class="col-xs-4">
                                        <span><label class="control-label">公司：</label></span>
                                        <span>
                                            <select name="payCompany"  id="payCompany">
                                                <option value="">全选</option>
                                                <custom:dictSelect type="流程所属公司" selectedValue="${commonPay.payCompany}"/>
                                            </select>
                                        </span>
                                    </div>
                                    <div class="col-xs-4">
                                        <span><label class="control-label">部门：</label></span>
                                        <span>
                                            <input type="text" id="deptName" name="deptName" onclick="openDept()" readonly/>
                                            <input type="text" name="deptId" id="deptId" value="" style="display:none;">
                                        </span>
                                    </div>
                                    <div class="col-xs-4">
                                        <span><label class="control-label">个人：</label></span>
                                        <span onclick="openDialog(this)">
                                            <input name="userId" type="text" id ="userId" style="display:none;">
                                            <input type="text" name="userName" id="userName" class="input" value = "" readonly/>
                                        </span>
                                    </div>
                                </div>
                                <br><br>
                                <div class="col-xs-12">
                                    <div class="col-xs-4">
                                        <span><label class="control-label">收入性质：</label></span>
                                        <span><select name="costProperty">
                                            <option value="">全选</option>
                                            <custom:dictSelect type="费用性质" />
                                        </select>
                                        </span>
                                    </div>
                                    <div class="col-xs-4">
                                        <span><label class="control-label">费用归属：</label></span>
                                        <span>
                                        <select name="investId">
                                            <option value="">全选</option>
                                            <c:forEach items="${invest}" var="invest">
                                                <option value="${invest.id}">${invest.value}</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    </div>
                                </div>
                            </form>
                            <br><br>
                            <div style="text-align:center;">
                                <button type="button" class="btn btn-default" onclick="clearProject()" style="margin-left:10px;">清空项目</button>
                                <button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
                                <button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
                                <button type="button"
                                        class="btn btn-primary  fa fa-x fa-cloud-download"
                                        onclick="exportExcel()" style="margin-left:10px;"></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="stattisticsContent" class="box box-primary">
                <div id="reimburse" hidden>
                    <h3 id = title style="text-align: center;"></h3>
                    <div id="reimburse_header">
                        <table id="reimburseTable_header" class="table table-hover">
                            <tr>
                                <td style="width: 20%">项目</td>
                                <td style="width: 20%;">类型</td>
                                <td style="width: 20%;">金额</td>
                                <td style="width: 20%;">操作</td>
                            </tr>
                        </table>
                    </div>
                    <div id="reimburse_content">
                        <table id="reimburseTable_content_content" class="table table-hover">
                        </table>
                    </div>
                    <div id="reimburse_sumMoney">
                    </div>
                    <div id="function_Button" hidden>
                    </div>
                </div>
            </div>
        </section>
    </div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="barginDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:80%; height: 80%;">
        <div class="modal-content" style="height:100%;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">合同详情</h4>
            </div>
            <div class="modal-body" style="height:75%;">
                <iframe id="barginDetailFrame" name="barginDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div><!-- /.modal-content -->
</div>
<div id="projectDialog"></div>
<div id="deptDialog"></div>
<div id="barginDialog"></div>
<!-- <div id="userDialog"></div> -->
<div id="userByDeptDialog"></div>
<%--单条记录详细信息--%>
<div class="modal fade bs-example-modal-lg" id="singleDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 id="modalTitle" class="modal-title"></h4>
            </div>
            <div class="modal-body" id="singleDetail_content">
                <div class="row">
                    <div class="col-xs-2">用户</div>
                    <div class="col-xs-2">单号</div>
                    <div class="col-xs-2">时间</div>
                    <div class="col-xs-2">项目</div>
                    <div class="col-xs-2">原因</div>
                    <div class="col-xs-2">金钱</div>
                </div>
                <div id="singleDetail_content_rows"></div>
            </div>
            <div class="modal-footer">
            	<button type="button" class="btn btn-default" id="exportDetails" onclick="exportDetails()">导出</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/statisticsReceived/js/list.js"></script>
<script>
    var userId = ${sessionScope.user.id};
</script>
</body>
</html>