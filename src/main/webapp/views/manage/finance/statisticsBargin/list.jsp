<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
    <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet"
          href="<%=base%>/static/bootstrap/css/bootstrap-select.min.css">

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
                            	 <select style="display: none;"  id="selectCompany"
                                           >
                                        <custom:dictSelect type="流程所属公司"/>
                                  </select>
                            
                                <div  class="col-xs-6">
                                    <span><label class="control-label">时间：</label></span>
                                    <input id="beginDate" name="beginDate" placeholder="开始时间" style="background-color: inherit;width: 30%;" readonly>
                                    <span>到</span>
                                    <input id="endDate" name="endDate" placeholder="结束时间" style="background-color: inherit;width: 30%;" readonly>
                                </div>
                                <div class="col-xs-6">
                                    <div class="col-xs-2">
                                    <label class="control-label">合同类型：</label>
                                    </div>
                                    <div class="col-xs-8" style="width: 40%">
                                        <select id ="barginType" name="barginType"
                                                class="selectpicker show-tick form-control" multiple data-live-search="false">
                                            <%-- <custom:dictSelect type="合同类型" selectedValue="${saleBarginManage.barginType}"/> --%>
                                            	<option value="S" <c:if test="${saleBarginManage.barginType eq 'S' }"> selected="selected"</c:if>>销售合同</option>
                                                <option value="B" <c:if test="${saleBarginManage.barginType eq 'B' }"> selected="selected"</c:if>>采购合同</option>
                                                <option value="L" <c:if test="${saleBarginManage.barginType eq 'L' }"> selected="selected"</c:if>>劳动合同</option>
                                            	<option value="C" <c:if test="${saleBarginManage.barginType eq 'C' }"> selected="selected"</c:if> >合作协议</option>
                                            	<option value="M" <c:if test="${saleBarginManage.barginType eq 'M' }"> selected="selected"</c:if>>备忘录</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <div style="text-align:center;margin: 5px">
                           <!--  <button type="button" class="btn btn-default" onclick="clearProject()" style="margin-left:10px;">清空项目</button> -->
                            <button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
                            <button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
                           <!--  <button type="button"
                                    class="btn btn-primary  fa fa-x fa-cloud-download"
                                    onclick="exportExcel()" style="margin-left:10px;"></button> -->
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
                           <!--  <td style="width: 10%;">项目名称</td>
                            <td style="width: 10%;">合同名称</td>
                            <td style="width: 8%;">合同总金额</td>
                            <td style="width: 8%;">已收金额</td>
                            <td style="width: 8%;">未收金额</td>
                            <td style="width: 8%;">开票金额</td>
                            <td style="width: 8%;">预收款</td>
                            <td style="width: 8%;">应收款</td>
                            <td style="width: 8%;">付款已收发票</td>
                            <td style="width: 8%;">付款未收发票</td>
                            <td style="width: 8%;">已付金额</td>
                            <td style="width: 8%;">未付金额</td> -->
                            <td style="width: 10%;">合同编号</td>
                            <td style="width: 8%;">合同金额</td>
                            <td style="width: 10%;">所属项目</td>
                            <td style="width: 10%;">所属公司</td>
                            <td style="width: 10%;">签订单位</td>
                            <td style="width: 8%;">开始时间</td>
                            <td style="width: 8%;">结束时间</td>
                            <td style="width: 6%;">纸质合同</td>
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
<div id="userDialog"></div>
<%--单条记录详细信息--%>
<div class="modal fade bs-example-modal-lg" id="singleDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 id="modalTitle" class="modal-title"></h4>
            </div>
            <div class="modal-body" id="singleDetail_content">
                <div class="row">
                    <div class="col-xs-2">用户</div>
                    <div class="col-xs-2">单号</div>
                    <div class="col-xs-3">时间</div>
                    <div class="col-xs-3">原因</div>
                    <div class="col-xs-2">金钱</div>
                </div>
                <div id="singleDetail_content_rows"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="collectionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:80%; height: 80%;">
        <div class="modal-content" style="height:100%;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">收款详细</h4>
            </div>
            <div class="modal-body" style="height:75%;">
                <iframe id="collectionFrame" name="collectionFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div><!-- /.modal-content -->
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/statisticsBargin/js/list.js"></script>

<script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-select.js"></script>
<script>
    var userId = ${sessionScope.user.id};
</script>
</body>
</html>