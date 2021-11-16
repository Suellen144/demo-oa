<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
<style>
#table1 {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}
#table1 td:not(.select2) {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table1 td input[name="name"],input[name="applyTime"],input[name="place"],input[name="date"]{
	text-align:center;
}


#table1 td span:not(.select2 span) {
	padding: 0px 6px;
	text-align: center;
}
#table1 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	resize: none;
	border: none;
	outline: medium;
	width:100%;
}

textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
	padding-top:10px;
	text-align:left;
}

select{
   appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}

.select2-container--default .select2-selection--single{
	border:none;
	padding-left:0;
}

.select2-selection__clear{
	display:none;
}

.select2-container .select2-selection--single .select2-selection__rendered{
	padding-left:0;
}

.select2-container--default .select2-selection--single .select2-selection__arrow b{
	border:none;	
}


.td_right {
	text-align: right;
}
.td_weight {
	font-weight: bold;
}
</style>
</head>
<body style="min-width:1110px; overflow:auto;font-size:small">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">报销</li>
			<li class="active">通用报销</li>
			<li class="active">报销申请</li>	
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row" width="100%">
			<!-- left column -->
			<div class="col-md-16">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<select id="type_hidden" style="display:none;">
							<custom:dictSelect type="通用报销类型"/>
						</select>
					
						<!-- <input type="hidden" id="projectId" name="projectId" value=""> -->
						<input type="hidden" id="id" name="id" value="${reimburse.id }">
						<input type="hidden" id="userId" name="userId" value="${reimburse.userId }">
						<input type="hidden" id="deptId" name="deptId" value="${reimburse.deptId}">
						<input type="hidden" id="cost" name="cost" value="<fmt:formatNumber value='${reimburse.cost }' pattern='#.##' />">
						<input type="hidden" id="attachments" name="attachments" value="${reimburse.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${reimburse.attachName }">
						<input type="hidden" id="orderNo" name="orderNo" value="${reimburse.orderNo}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="unbound" name="unbound" value="${unbound}">
						
						<div style="text-align: center;font-weight: bolder;font-size: large;">
							<thead>
								<tr>
								<th colspan="20">通 用 报 销 单</th>
								<span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(报销单号：${reimburse.orderNo })</span>
								</tr>
							</thead>
						</div>
						<table id="table1">
							<tbody>
								<tr>
									<td class="td_weight"><span>报销人</span></td>
									<td><input type="text" id="name" name="name" value="${reimburse.name }" readonly></td>
									<td class="td_weight"><span>报销单位</span></td>
									<td colspan="2"  style="line-height:inherit;text-align:left;">
										<custom:getDictKey type="流程所属公司" value="${reimburse.title }"/>
										<c:choose>
										<c:when test="${empty(sessionScope.user.dept.alias)}"> 
										<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${reimburse.dept.name }" readonly>
										</c:when>
										<c:otherwise>  
										<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${reimburse.dept.alias }" readonly>
										</c:otherwise>
										</c:choose>
									</td>
									<td colspan="2" class="td_weight"><span>申请日期</span></td>
									<td colspan="3"><input type="text" id="applyTime" name="applyTime" style="color:gray;" value="<fmt:formatDate value="${reimburse.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly></td>
							
								</tr>
								
								<tr>
									<td class="td_weight"><span>领款人</span></td>
									<td style="width:85px;padding-left:35px;">
											<input type="text" id="payee" name="payee" value ="${reimburse.payee }" readonly>
									</td>
									<td class="td_weight"><span>银行卡号</span></td>
									<td colspan="2">
										<input type="text" id="bankAccount" name="bankAccount" value ="${reimburse.bankAccount }" readonly>
									</td> 
									<td colspan="2" class="td_weight"><span>开户行名称</span></td>
										<td colspan="3">
										<input type="text" id="bankAddress" name="bankAddress"  value ="${reimburse.bankAddress }" readonly>
									
						                </td> 
								</tr>
								<tr>
									<td class="td_weight"><span>日期</span></td>
									<td class="td_weight"><span>地点</span></td>
									<td class="td_weight"><span>项目</span></td>
									<td class="td_weight"><span>事由</span></td>
									<td class="td_weight"><span>金额</span></td>
									<td class="td_weight"><span>实报</span></td>
									<td class="td_weight"><span>类别</span></td>
									<td class="td_weight" colspan="2" ><span>明细</span></td>
								</tr>
								<c:forEach items="${reimburseAttachs}" var="business" varStatus="varStatus">
								<tr name="node">
									<input type="hidden" name="attachId" value="${business.id }">
									<td style="width:10%;">
										<input type="text" name="date" class="date" value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td style="width:8%;"><input type="text" name="place" class="input" value="${business.place }" readonly></td>
									<td style="width:15%;">
										<textarea name="projectName"  onclick="openProject(this)" readonly>${business.project.name }</textarea>
										<input type="hidden" name="projectId" value="${business.project.id }">
									</td>
									<td style="width:16%;"><textarea name="reason" class="input" readonly>${business.reason }</textarea></td>
									<td style="width:8%;"><input type="text" name="money" style="text-align:right;" value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)" readonly></td>
									<td style="width:8%;"><input type="text" name="actReimburse" style="text-align:right;" readonly value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" onkeyup="actReimburseCount()" onfocus="this.select()"></td>
									<td style="width:4%;">
												<custom:getDictKey type="通用报销类型" value="${business.type }" /></td>
									<td colspan="2" ><textarea name="detail" readonly>${business.detail }</textarea></td>
								</tr>
								</c:forEach>
								<tr>
											<td class="td_right td_weight"><span>实报金额：</span></td>
													<td colspan="18">
													<div style="display:flex">
													<div style="display:flex">
													<span>¥</span>
													<span id="actReimburseTotal"></span>
													</div>
													<div>
														(
														<span id="costcn"></span>
														) 
													</div>
													</div>
											</td>
								</tr>
								<tr>
									<td colspan="1" class="td_weight">附件</td>
									<td colspan="6">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${reimburse.attachments }" target='_blank'><input type="text" id="showName" name="showName" value="${reimburse.attachName }" readonly></a>
										<td style="border-left-style:hidden;"><input type="file" id="file" name="file" style="border:none;display:none;">
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;" href="javascript:;"> 
										</td>
									</td>
									<td colspan = "10">
										<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${reimburse.attachments }">删除</a>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="34" style="text-align:center;">
										<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
										
										<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">取消</button>
									</td>
								</tr>
							</tfoot>
						</table>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="deptDialog"></div>
<div id="projectDialog"></div>

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

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/reimburs/js/projectUnboundReimburs.js"></script>
</body>
</html>