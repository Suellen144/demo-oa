<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
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

#table2 td input[type="text"] {
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

#table2 td span {
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

#table2 th {
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
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">收款管理</li>
			<li class="active">申请收款</li>
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
						<input type="hidden" id="attachments" name="attachments" value="${collection.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${collection.attachName}">
						<input type="hidden" id="barginProcessInstanceId" value="">
						<input type="hidden" id="isSubmit" name="isSubmit" value="">
						<table id="table1">
							<thead>
								<tr><th colspan="20">收款申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:15%;"><span>发起人</span></td>
									<td style="width:10%;"><input type="text" value="${sessionScope.user.name }" readonly></td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
											<div style="float: left;height:20px;font-size: 15px;">
												<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
												<div style="float: left;">
													<select name="title"><custom:dictSelect
															type="流程所属公司" /></select>
												</div>
												</c:if>
												<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
												<div style="float: left;">
												<input name="title" value="10" type="hidden">
												<custom:getDictKey type="流程所属公司" value="10"/>
												</div>
												</c:if>
												<div style="float: left;height:20px;font-size: 15px;">
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${sessionScope.user.dept.name }" readonly>
													</c:if>
												</div>
												<div style="clear: both"></div>
											</div>
									</td>
									<td><span>提交时间</span></td>
									<td><input type="text" name="applyTime" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" readonly></td>
									<td><span>总金额</span></td>
									<td>
										<input type="text" id="totalPay"  name="totalPay" value="" onkeyup="initInputBlur()">
									</td>
								</tr>
								<tr>
									<input type="hidden" name="barginId"  id="barginId" value="">
									<td><span>合同编号</span></td>
									<td>
										<input type="text" id="barginCode" value="" readonly>
									</td>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="" readonly>
									</td>
									<td ><span>项目名称</span></td>
									<td colspan="3" onclick="openProject(this)">
										<input  type="text" id="projectManageName" name="projectManageName" value="" readonly>
										<input type="hidden" id="projectId" name="projectId" value="" readonly>
									</td>
								</tr>
								<tr>
									<td><span>申请金额</span></td>
									<td>
										<input type="text"  name="applyPay" id="applyPay" value="" onkeyup="initInputBlur()">
									</td>	
									<td><span>申请比例</span></td>
									<td>
										<input  type="text"  name="applyProportion" id ="applyProportion" value="" readonly>
										</td>
									<td><span>付款单位</span></td>
									<td>
										<input type="text"  name="payCompany" value="" >
									</td>
									<td><span>是否开具发票</span></td>
									<td>
										<select name="isInvoiced" id="isInvoiced" style="width:100%;" onchange = "initinvoiced(this)">
										<custom:dictSelect type="发票开具"/>
										</select>
									</td>
								</tr>
								<tr>
									<td><span>收款类型</span></td>
									<td colspan="1" style="text-align:left;">
										<select name="collectionType" style="height:100%;width:100%;text-align-last:center;">
											<custom:dictSelect type="费用性质"/>
										</select>
									</td>
									<td><span>关联合同</span></td>
									<td colspan="10" style="text-align:left;">
									<input type="button" value="请选择合同" onclick="openBargin()" style="border:none;">
									<input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;display:none;">
									</td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${finCollection.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${finCollection.attachName }" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file" name="file" style="display: none;">
										<c:if test="${not empty finCollection.attachments }">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${finCollection.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="20" style="text-align:left;">
										<textarea name ="reason"></textarea>
									</td>
								</tr>
								</tbody>
						</table>
						<div>
						<table id="table2" style="display:none;">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:10%;"><span>购货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="payname" value=" "></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="paynumber" name="paynumber" ></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="payaddress" value="" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="payphone" name="payphone" value="" ></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="bankAddress" value="" ></td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="5"><input type="text" name="bankNumber" id="bankNumber" value=""></td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td style="width:12%;"><span>规格型号</span></td>
									<td style="width:12%;"><span>单位</span></td>
									<td style="width:5%;"><span>数量</span></td>
									<td style="width:8%;"><span>单价</span></td>
									<td style="width:9%;"><span>金额</span></td>
									<td style="width:5%;"><span>税率(%)</span></td>
									<td style="width:8%;"><span>税额</span></td>
									<td style="width:8%;"><span>价税小计</span></td>
									<td style="width:5%;"><span>操作</span></td>
								</tr>
								<tr name="add">
									<td>
										<input type="text" name="name" value="" >
									</td>
									<td>
										<input type="text"  name="model" value="" >
									</td>
									<td>
										<input type="text" name="unit" value=""  >
									</td>
									<td>
										<input type="text" name="number" value="" onkeyup="coutmoney()" >
									</td>
									<td>
										<input type="text"  name="price" value=""  readonly>
									</td>
									<td>
										<input type="text"  name="money" value="0" readonly >
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;width: 100%;">
											<option selected="selected">0</option>
											<option>6</option>
											<option>13</option>
											<option>16</option>
											<option>17</option>
										</select>
										<!-- <input type="text" name="excise" value="" onkeyup="initexcise()"> -->
									</td>
									<td>
										<input type="text" name="exciseMoney" value="0"  readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="0"  onkeyup="coutmoney()">
									</td>
									<td style="text-align:center;width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td><input type="text" name="total" value="" readonly></td>
								<td></td>
								<td><input type="text" name="totalexcisemoney"  value="" readonly></td>
								<td></td>
								<td></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9"><input type="text" name="totalexcise" value="0" readonly></td>
								</tr>
								<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="collectionCompany" value="睿哲科技股份有限公司"></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="collectionNumber" name="collectionNumber" value="91440106593721312R"></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="collectionAddress" value="广州市天河区中山大道西89号B栋西梯701" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="collectionContact" name="collectionContact" value="020-3829 9023"></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="collectionBank"value="工商银行广州华景新城支行" ></td>
									<td style="width:15%;"><span>账号</span></td>
									<!-- <td>
										<input type="hidden" name="collection">
									</td> -->
								<td colspan="5"><input type="text" id="collectionAccount" name="collectionAccount" value="3602028609200082654"></td>
								</tr>
								<tr>
									<td colspan="10"><textarea name="remark" placeholder="备注"></textarea></td>
								</tr>
							</tbody>
						</table>
						</div>
						<div style="width: 80%; text-align: center;margin:auto;padding-top:5px;">
							<button type="button" class="btn btn-primary" onclick="submitinfo()" >提交</button>
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
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
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/add.js"></script>
</body>
</html>