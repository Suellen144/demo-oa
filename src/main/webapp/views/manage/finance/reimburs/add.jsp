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


#table1 td input[name="money"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
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


.td_right {
	text-align: right;
}
.td_weight {
	font-weight: bold;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}

.label_title {
	display: block;
	border-bottom: 1px solid white;
	padding: 0.5em;
}
.label_item {
	display: block;
	border-bottom: 1px solid white;
	text-align: left;
	
}
</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<div class="wrapper">
<!-- 	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">个人办公</li>
			<li class="active">报销</li>
			<li class="active">通用报销</li>
			<li class="active">报销申请</li>	
		</ol>
	</header> -->

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-16">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<select id="type_hidden" style="display:none;">
							<custom:dictSelect type="通用报销类型"/>
						</select>
					
						<input type="hidden" id="projectId" name="projectId" value="">
						<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
						<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
						<input type="hidden" id="cost" name="cost" value="0">
						<input type="hidden" id="orderNo" value="">
						<input type="hidden" id="attachments" name="attachments" value="">
						<input type="hidden" id="attachName" name="attachName" value="">
						<input type="hidden" id="issubmit" name="issubmit" value="">
							<div  style="text-align: center;font-weight: bolder;font-size: large;">
							<thead>
								<tr><th colspan="20">通用报销单</th></tr>
								<i class="icon-question-sign" style="cursor:pointer"  onclick="showhelp()"> </i>
							</thead>
							</div>
						<table id="table1">
							<tbody>
								<tr>
									<td class="td_weight"><span>报销人</span></td>
									<td><input type="text" id="name" name="name" value="${sessionScope.user.name }"></td>
									<td class="td_weight"><span>报销单位</span></td>
									<td colspan="3" style="font-size:14px;text-align:left;white-space:nowrap;">
										<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;text-align:left;"><custom:dictSelect type="流程所属公司" /></select>
										</c:if>
										<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
										</c:if>
										<c:choose>
										<c:when test="${empty(sessionScope.user.dept.alias)}"> 
										<input  type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${sessionScope.user.dept.name }" readonly>
										</c:when>
										<c:otherwise>  
										<input  type="text" style="height:20px;width:auto;font-size:14px;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
										</c:otherwise>
										</c:choose>
									</td>
									<td  class="td_weight"><span>提交日期</span></td>
									<td colspan="3"><input type="text" id="applyTime" name="applyTime" style="color:gray;" readonly ></td>
								</tr>
								<tr>
									<td  class="td_weight"><span>领款人</span></td>
									<td><input type="text"  id="payee" name="payee" value="${payee}"></td>
									<td class="td_weight"><span>银行卡号</span></td>
									<td colspan="3"><input type="text" id="bankAccount" name="bankAccount" value="${number}"></td>
									<td class="td_weight"><span>开户行名称</span></td>
									<td colspan="3"><input type="text" id="bankAddress" name="bankAddress" value="${address}"></td>
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
								<tr name="node">
									<td style="width:9%;">
										<input type="text" name="date" class="date" value="" readonly>
									</td>
									<td style="width:8%;"><input type="text" name="place" class="input" ></td>
									<td style="width:15%;">
										<textarea  name="projectName"  id="projectName" onclick="openProject(this)" readonly></textarea>
										<input type="hidden" name="projectId" value="">
									</td>
									<td style="width:18%;"><textarea name="reason" autocomplete="off" class="input"  ></textarea></td>
									<td style="width:8%;"><input type="text" name="money" style="text-align:right;" value="" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)"></td>
									<td style="width:8%;"><input type="text" name="actReimburse" value="" style="text-align:right;" onkeyup="actReimburseCount()" onfocus="this.select()"></td>
									<td style="width:6%;">
										<select name="type" onchange="validationRed()">
											<custom:dictSelect type="通用报销类型"/>
										</select>
									
									<td style="width:24%;"><textarea name="detail"></textarea></td>
									<td style="width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
								</tr>
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
									<td colspan="7" style="border-right-style:hidden;">
										<input type="text" id="showName" name="showName" value="" readonly>
										<td colspan="2">
										<input type="file" id="file" name="file" style="display: none;">
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;" href="javascript:;"> 
										</td>
									</td>
								</tr>
							</tbody>
							<tfoot>
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/reimburs/js/add.js"></script>
<script>
var investList = JSON.parse('${investListForJson}');
</script>
</body>
</html>