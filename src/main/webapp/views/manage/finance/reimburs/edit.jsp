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

#table1 td input[name="name"],input[name="applyTime"],input[name="place"],input[name="date"]
	,input[name="payee"],input[name="bankAddress"]{
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
					
						<input type="hidden" id="id" name="id" value="${reimburse.id }">
						<input type="hidden" id="userId" name="userId" value="${reimburse.userId }">
						<input type="hidden" id="deptId" name="deptId" value="${reimburse.deptId}">
						<input type="hidden" id="cost" name="cost" value="<fmt:formatNumber value='${reimburse.cost }' pattern='#.##' />">
						<input type="hidden" id="attachments" name="attachments" value="${reimburse.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${reimburse.attachName }">
						<input type="hidden" id="orderNo" name="orderNo" value="${reimburse.orderNo}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<div style="text-align: center;font-weight: bolder;font-size: large;">
							<thead>
								<tr>
								<th colspan="20">通用报销单</th>
								<i class="icon-question-sign" style="cursor:pointer"  onclick="showhelp()"> </i>
								<span style="font-size:smaller;font-weight:normal;position:absolute;right:2.5em;line-height:2em;">(报销单号：${reimburse.orderNo })</span>
								</tr>
							</thead>
						</div>
						<table id="table1">
							<tbody>
								<tr>
									<td class="td_weight"><span>报销人</span></td>
									<td><input type="text" id="name" name="name" value="${reimburse.name }"></td>
									<td class="td_weight"><span>报销单位</span></td>
									<td colspan="2"  style="line-height:20px;text-align:left;">
										<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;text-align:left;"><custom:dictSelect type="流程所属公司" selectedValue="${reimburse.title }"/></select>
										</c:if>
										<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
										</c:if>
										<c:choose>
										<c:when test="${empty(reimburse.dept.alias)}">
										<input  type="text" style="height:20px;font-size:14px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${reimburse.dept.name }" readonly>
										</c:when>
										<c:otherwise>  
										<input  type="text" style="height:20px;font-size:14px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
										</c:otherwise>
										</c:choose>
									</td>
									<td colspan="2" class="td_weight"><span>申请日期</span></td>
									<td colspan="3"><input type="text" id="applyTime" name="applyTime" style="color:gray;" value="<fmt:formatDate value="${reimburse.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly></td>
								</tr>
								
								<tr>
									<td class="td_weight"><span>领款人</span></td>
									<td><input type="text" id="payee" name="payee" value ="${reimburse.payee }"></td>
									<td class="td_weight"><span>银行卡号</span></td>
									<td colspan="2"><input type="text" id="bankAccount" name="bankAccount" value ="${reimburse.bankAccount }"></td> 
									<td colspan="2" class="td_weight"><span>开户行名称</span></td>
									<td colspan="3"><input type="text" id="bankAddress" name="bankAddress"  value ="${reimburse.bankAddress }"></td> 
								</tr>
								<tr>
									<td class="td_weight"><span>日期</span></td>
									<td class="td_weight"><span>地点</span></td>
									<td class="td_weight"><span>项目</span></td>
									<td class="td_weight"><span>事由</span></td>
									<td class="td_weight"><span>金额</span></td>
									<td class="td_weight"><span>实报</span></td>
									<td class="td_weight"><span>类别</span></td>
									<td class="td_weight"><span>明细</span></td>
									<td class="td_weight"><span>操作</span></td>
								</tr>
								<c:forEach items="${reimburseAttachs}" var="business" varStatus="varStatus">
								<tr name="node">
									<td style="width:10%;">
										<input type="text" name="date" class="date" value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td style="width:8%;"><input type="text" name="place" class="input" value="${business.place }"></td>
									<td style="width:15%;">
										<c:choose>
											<c:when test="${reimburse.status eq '7' or empty reimburse.status  and business.project.status eq '-1' }">
												<textarea name="projectName" onclick="openProject(this)"  readonly></textarea>
												<input type="hidden" name="projectId" value="">
											</c:when>
											<c:otherwise>
												<textarea name="projectName" onclick="openProject(this)"  readonly>${business.project.name }</textarea>
												<input type="hidden" name="projectId" value="${business.project.id }">
											</c:otherwise>
										</c:choose>
									
										
									</td>
									<td style="width:16%;"><textarea name="reason" autocomplete="off" class="input">${business.reason }</textarea></td>
									<td style="width:8%;"><input type="text" name="money" style="text-align:right;" value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)"></td>
									<td style="width:8%;"><input type="text" name="actReimburse" style="text-align:right;" value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" onkeyup="actReimburseCount()" onfocus="this.select()"></td>
									<td style="width:4%;">
									<select name="type" value="${business.type }" onchange="validationRed()">
													<custom:dictSelect type="通用报销类型" selectedValue="${business.type }" />
									</select>
									<td style="width:2%;"><textarea name="detail">${business.detail }</textarea></td>
									<td style="width:6%;">
													<c:if test="${varStatus.last }">
														<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></span></a>
														<a href="javascript:void(0);" style="font-size:x-large;"onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
													</c:if>
													<c:if test="${!varStatus.last }">
														<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
													</c:if>
									</td>
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
									<td colspan="34" style="text-align:center;border:none;" >
										<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
										<button type="button" class="btn btn-primary" onclick="del()" >删除</button>
										<button type="button" class="btn btn-primary" onclick="submitinfo()" >提交审核</button>
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
<!-- 帮助文本模态框（Modal） -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
    	<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">通用报销填写规范</h4>
         	</div>
	        <div class="modal-body">
					<p>
						双箭头符号⇌  单箭头符号→
					</p>
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 12px;">1</span><span style="font-size: 12px;">、</span><span
							style="font-size: 19px;">外勤的费用同一天在同一个城市产生的公交地铁打的可写在一起</span><span
							style="font-size: 19px">,</span><span style="font-size: 19px;">在明细写清楚路线金额（</span><span
							style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
							style="font-size: 19px; color: rgb(51, 51, 51);">→</span><span
							style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
							style="font-size: 19px">+</span><span style="font-size: 19px;">交通工具</span><span
							style="font-size: 19px">+</span><span style="font-size: 19px;">某公司某客户）</span><span
							style="font-size: 19px">, </span><span style="font-size: 19px;">大家选择滴滴出行的，报销时请提供纸质的滴滴发票与行程单，行程单的金额必须与发票金额一致，行程单上须显示具体的起点与终点地址，不同时间、不同城市的分开填写路线金额。城际交通是同一天的写在一起，地点用双箭头标示，不是同一天的分开填写，地点之间用单箭头标示。</span></span>
					</p>
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 19px;"><img
								src="http://www.reyzar.com/images/upload/20171011/1507707545581.png"
								_src="http://www.reyzar.com/images/upload/20171011/1507707545581.png" /></span></span>
					</p>
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 19px;"><br /></span></span>
					</p>
					<p>
						<br />
					</p>
				</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/reimburs/js/edit.js"></script>
</body>
</html>