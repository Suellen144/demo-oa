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


input{
	text-align: center;
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
   <li class="active"><a href="#business" data-toggle="tab">商务工作</a></li>
   <li><a href="#market" data-toggle="tab">拜访工作</a></li>
   <div style="text-align: right;">
			<tr>
				<td colspan="34" style="text-align: center; padding: 5px;">
					<button type="button" class="btn btn-primary" id="save" onclick="save()">保存</button>
					<button type="button" class="btn btn-primary" id="submitinfo"
						onclick="submitinfo()">提交</button>
					<button type="button" class="btn btn-default"
						onclick="javascript:window.history.back(-1)">返回</button>
				</td>
			</tr>
	</div>
</ul>


<div id="myTabContent" class="tab-content" style="min-height:600px;">
		<div class="tab-pane fade in active" id="business" style="min-height: 600px">
		<iframe id="business_iframe" name="business_iframe"  frameborder="no" style="width:100%;min-height:1080px" scrolling="no" src="<%=base%>/manage/ad/workBiness/toAdd"></iframe>
   	</div>
   	<div class="tab-pane fade" id="market" style="min-height: 600px">
   		<iframe id="market_iframe" name="market_iframe"  style="width:100%;min-height:1080px"  frameborder="no" scrolling="yes" src="<%=base%>/manage/ad/workMarket/toAdd"></iframe>
   	</div>
</div>




<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/workmanage/js/add.js"></script>
</body>
</html>