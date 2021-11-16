<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
body {
	background: none !important;
}
#table1 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table4 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table3 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table4 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table3 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table4 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}


#table4 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table3 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table2 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table3 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table4 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
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
	border: none;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}
#table9 {
	width: 96%;
	margin: 0 auto;
	margin-top:20px;
	background-color: white;
}
#table9 td {
	font-weight: bold;
	font-size: 1em;
	
	width: 13%;
}
.td_left {
	text-align: left !important;
	white-space:pre-line;
}
.hidden{
	display: none;
}
</style>
</head>
<body>
<div class="wrapper">
	<!-- Main content -->
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class=" box-primary tbspace">
					<form id="form1">
						<input type="hidden" id="barginProcessInstanceId" value="${map.business.barginManage.processInstanceId}">
						<input type="hidden" id="id"  name="id" value="${map.business.id }">
						<input type="hidden" id="barginId" name="barginId" value="${map.business.barginId }">
						<button type="button" id="button1" onclick="hiddenvalues()">隐藏</button>
						<button type="button" id="button2" onclick="showvalues()">显示</button>
						<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>
						<table id="table1">
							<thead>
								<tr><th colspan="20">睿哲科技收款单</th></tr>
							</thead>
							<tbody>
								<tr>
									<td><span>合同编号</span></td>
									<td>
										<input type="text" id="barginCode" value="${map.business.barginManage.barginCode}" readonly>
									</td>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="${map.business.barginManage.barginName}" readonly>
									</td>
									<td ><span>项目名称</span></td>
									<td colspan="3">
										<input  type="text" id="projectManageName" value="${map.business.projectManage.name}" readonly>
									</td>
								</tr>
								<tr>
									<td><span>总金额</span></td>
									<td>
										<input  type="text" id="totalPay" name="totalPay" value="<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00'/>" onkeyup="initInputBlur()" >
									</td>
									<td><span>申请金额</span></td>
									<td>
										<input type="text"  name="applyPay" id="applyPay" onkeyup="initInputBlur()" value="<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />" >
									</td>
									<td ><span>渠道费用</span></td>
									<td colspan="3">
										<input type="text"  name="channelCost" id="channelCost" value="<fmt:formatNumber value='${map.business.channelCost}' pattern='0.00'/>" onkeyup="initInputBlur()">
									</td>
								</tr>
								<tr>
									<td><span>提成基数</span></td>
									<td>
										<input type="text" class="linkage"  name="commissionBase" id="commissionBase" value="${map.business.commissionBase}" onkeyup="initInputBlur()">
									</td>
									<td><span>提成比例</span></td>
									<td>
										<input type="text" class="linkage" name="commissionProportion" id="commissionProportion" value="${map.business.commissionProportion}%" onchange="onchangeCommission()">
									</td>
									<td><span>分配额度</span></td>
									<td colspan="3">
										<input type="text" class="linkage" name="allocations" id="allocations" value="${map.business.allocations}" onkeyup="initInputBlur()">
									</td>
								</tr>
								<tr>
									<td><span>收款类型</span></td>
									<td>
										<select  style="width: 100%" name="collectionType"><custom:dictSelect type="费用性质" selectedValue="${map.business.collectionType }"/></select>
									</td>
									<td><span>付款单位</span></td>
									<td>
										<input type="text"  name="payCompany" value="${map.business.payCompany}" >
									</td>
									<td><span>关联合同</span></td>
									<td colspan="3">
										<input type="button" value="请选择合同" onclick="openBargin()" style="border:none;">
										<!-- <input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;"> -->
									</td>
								</tr>
								<tr>
									<td><span>申请人</span></td>
									<td>
										<input type="text" value="${map.business.applicant.name }" readonly>
										<input type="hidden" id="applyUserId" name="applyUserId" value="${map.business.applicant.id }" readonly>
									</td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
											<div style="float: left;height:20px;font-size: 15px;">
												<div style="float: left;">
												<select name="title"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
												</div>
												<div style="float: left;height:20px;font-size: 15px;">
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${map.business.applicant.dept.name }" readonly>
													</c:if>
												</div>
												<div style="clear: both"></div>
											</div>
									</td>
									<td><span>申请时间</span></td>
									<td colspan="3">
										<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
									</td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="20" style="text-align:left;">
										<textarea name ="reason">${map.business.reason }</textarea>
									</td>
								</tr>
								<tr>
									<td  colspan="3" ><span>收款日期</span></td>
									<td  colspan="3"><span>收款金额</span></td>
									<td  colspan="3" name="operation"><span>操作</span></td>
								</tr>
								<tbody id="node">
								<c:if test="${not empty map.business.collectionAttachList }">
								<c:forEach items="${map.business.collectionAttachList }" var="business" varStatus="varStatus">
								<tr name="node">
									<input type="hidden" name="businessId" value="${business.id}" readonly>
									<td colspan="3" style="height:100%;text-align:center;">
										<input type="text" style="text-align:center;" id="collectionDate"  name="collectionDate" class="collectionDate" 	value="<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />"   readonly>
									</td>
									<td  colspan="3">
										<input type="text" style="text-align:center;" id="collectionBill"   name="collectionBill" onkeyup = "initCompareBillWithBillCollection()" value="${business.collectionBill}">
									</td>
									<td colspan="3" style="text-align:center;" name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)">
									<img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
								</tr>
								</c:forEach>
								</c:if>
								</tbody>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 98%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">提成分配方案</span>
						</div>
							<table id="table2" style="text-align: center;width:98%;">
							<thead>
								<tr  name='node1' class='node1'>
								<td >参与人员</td>
								<td >提成比例</td>
								</tr>
							</thead>
							<tbody id="tableTbody" >
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
							</table>
						<table id="table9">
							<tbody>
								<tr>
									<td id="fuhe">审核：</td>
									<td id="ceo"  style="text-align:center;">审批：</td>
									<td  style="text-align:center;">收款人：</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
		</div>
</div>
<div id="barginDialog"></div>
<div id="projectDialog"></div>
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
</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/pdfNew.js"></script>

</body>
</html>