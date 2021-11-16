<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}


.ui-widget-content .ui-state-active {
	background: #3c8dbc;
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
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">财务管理</li>
		<li class="active">报销申请</li>
	</ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
   <li class="active"><a href="#travelreimburs" data-toggle="tab">差旅报销</a></li>
   <li><a href="#reimburs" data-toggle="tab">通用报销</a></li>
   <div style="text-align: right;">
			<tr>
				<td colspan="34" style="text-align: center; padding: 5px;">
					<button type="button" class="btn btn-primary" onclick="save()">保存</button>
					<button type="button" class="btn btn-primary"
						onclick="submitinfo()">提交审核</button>
					<button type="button" class="btn btn-default"
						onclick="javascript:window.history.back(-1)">返回</button>
				</td>
			</tr>
	</div>
</ul>


<div id="myTabContent" class="tab-content" style="height:auto;">
		<div class="tab-pane fade in active" id="travelreimburs" style="height:auto;">
		<iframe id="travelreimburs_iframe" name="travelreimburs_iframe"  frameborder="no" width="100%" height="900px" scrolling="yes" src="<%=base%>/manage/finance/travelReimburs/toAdd"> style="height:500px;"</iframe>
   	</div>
   	<div class="tab-pane fade" id="reimburs">
   		<iframe id="reimburs_iframe" name="reimburs_iframe" width="100%" height="800px" frameborder="no" scrolling="yes" src="<%=base%>/manage/finance/reimburs/toAdd"></iframe>
   	</div>
</div>




<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/management/js/add.js"></script>
</body>
</html>