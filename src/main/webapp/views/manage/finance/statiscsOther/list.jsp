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
</header>
<style>
    #myTab>li.active a{
        background-color: #3c8dbc;
        color: white;
        font-weight: bold;
    }
    #tab1 tr{
    	border: 1px solid #ddd;
    }
    #tab1 tr td{
     	height:40px;
     	font-size:14px;
    	border: 1px solid #ddd;
    }
     #tab2 tr{
    	border: 1px solid #ddd;
    }
    #tab2 tr td{
     	height:40px;
     	font-size:14px;
    	
    }
     #tab3 tr{
    	border: 1px solid #ddd;
    }
    #tab3 tr td{
     	height:40px;
     	font-size:14px;
    	
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
                                <!-- <div  class="col-xs-6">
                                    <span><label class="control-label">时间：</label></span>
                                    <input id="beginDate" name="beginDate" placeholder="开始时间" style="background-color: inherit;width: 30%;" readonly>
                                    <span>到</span>
                                    <input id="endDate" name="endDate" placeholder="结束时间" style="background-color: inherit;width: 30%;" readonly>
                                </div> -->
                                <div class="col-xs-6">
                                    <%--<span><input id="whetherSelectProject" name="whetherSelectProject" type="checkbox" value="1"></span>--%>
                                    <span><label class="control-label">项目：</label></span>
                                    <span style="width:15%;margin-left:11px;">
                                        <input  name="projectName"  id="projectName" onclick="openProject(this)" readonly/>
                                        <input type="hidden" name="projectId" id="projectId" value="">
                                    </span>
                                </div>
                            </div>
                            <div class="col-xs-12" style="margin:7px;margin-left:0;">
                            	<div class="col-xs-6">
	                                <div style="float:left;line-height:34px;">
	                                	<label class="control-label">公司：</label>
	                                </div>
	                                <div class="col-xs-6">
	                                    <select name="payCompany"  id="payCompany"
	                                            class="selectpicker show-tick form-control" multiple data-live-search="false">
	                                        <custom:dictSelect type="流程所属公司" selectedValue="${commonPay.payCompany}"/>
	                                    </select>
	                                </div>
                                </div>
                            </div>
                        </form>
                        <div style="text-align:center;margin: 5px">
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
                    <table id="reimburseTable_header" class="table table-hover" style="margin-bottom:0;">
                    	<tr style="font-weight: bold;">
                    				<td align="center"><h4>项目名</h4></td>
                    				<td colspan="6" align="center"><h4>销售</h4></td>
                    				<td colspan="6" align="center"><h4>采购</h4></td>
                    	</tr>
                        <tr>
                            <td style="width: 9%;border-right: 1px solid #ddd;">项目名称</td>
                            <!-- 销售  -->
                            <td style="width: 7%;">合同总金额</td>
                            <td style="width: 7%;">已收金额</td>
                            <td style="width: 7%;">未收金额</td>
                            <td style="width: 7%;">开票金额</td>
                            <td style="width: 7%;">未开票金额</td>
                            <td style="width: 7%;border-right: 1px solid #ddd;">已开票未收款</td>
                            <!-- 采购 -->
                            <td style="width: 7%;">合同总金额</td>
                            <td style="width: 7%;">已付金额</td>
                            <td style="width: 7%;">未付金额</td>
                            <td style="width: 7%;">已收发票</td>
                            <td style="width: 7%;">未收发票</td>
                            <td style="width: 7%;">已付款未收发票</td>
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
                <h4  id="myModalLabel" style="text-align: center;"></h4>
            </div>
            <div class="modal-body" style="height:75%;">
                	<div style="width: 100%;height: 100%;overflow-y: scroll;" id="projectContent">
                		<table id="tab1" style="width: 100%;height: auto;border: 1px solid #ddd; ">
                				<tr>
                					<td>销售合同总金额</td>
                					<td id="sellTotal"></td>
                					<td>采购成本总金额</td>
                					<td id="BuyerTotal"></td>
                					<td>支出总金额</td>
                					<td id="fee" onclick="payDetail(this);"></td>
                				</tr>
                				<tr>
                					<td>利润</td>
                					<td colspan="5" id="margin"></td>
                				</tr>
                		</table>
                		<br/>
                		<br/>
                		<h4>销售</h4>
                		<table id="tab2" style="width: 100%;height: auto;border: 1px solid #ddd; ">
                			<tr>
                				<td>合同编号</td>
                				<td>签订单位</td>
                				<td>签订时间</td>
                				<td>合同总金额</td>
                				<td>已收金额</td>
                				<td>未收金额</td>
                				<td>开票金额</td>
                				<td>未开票金额</td>
                				<td>已开票未收款</td>
                			</tr>
                			 <tbody id="tab2Body"></tbody>
                		</table>
                		<br/>
                		<br/>
                		<h4>采购</h4>
                		<table id="tab3" style="width: 100%;height: auto;border: 1px solid #ddd; ">
                			<tr>
                				<td>合同编号</td>
                				<td>签订单位</td>
                				<td>签订时间</td>
                				<td>合同总金额</td>
                				<td>已付金额</td>
                				<td>未付金额</td>
                				<td>已收发票</td>
                				<td>未收发票</td>
                				<td>已付款未收发票</td>
                			</tr>
                			 <tbody id="tab3Body"></tbody>
                		</table>
                		
                	</div>
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
    <div class="modal-dialog" role="document" style="width:82%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 id="modalTitle" class="modal-title"></h4>
            </div>
            <div class="modal-body" id="singleDetail_content" style="padding:15px;">
            	<table style="width:100%">
            		<thear>
            			<tr>
            				<th style="width:10%;padding-left:15px;">用户</th>
            				<th style="width:12%;padding-left:15px;">单号</th>
            				<th style="width:12%;padding-left:15px;">时间</th>
            				<th style="width:14%;padding-left:15px;">项目</th>
            				<th style="width:40%;padding-left:15px;">原因</th>
            				<th style="width:12%;padding-left:15px;">金钱</th>
            			</tr>
            		</thear>
            		<tbody id="singleDetail_content_rows"></tbody>
            	</table>
            </div>
            <div class="modal-footer">
            	<button type="button" class="btn btn-default" id="exportDetails" onclick="exportDetails()">导出</button>
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/statiscsOther/js/list.js"></script>

<script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-select.js"></script>
<script>
    var userId = ${sessionScope.user.id};
</script>
</body>
</html>