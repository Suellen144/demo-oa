<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">公共信息</li>
			<li class="active">规章制度管理</li>
		</ol>
	</header>
	
	
	<c:choose>
		<c:when test="${not empty isApprove and isApprove eq 'y' }">
			<section class="content rlspace">
				<div class="row">
					<input type="hidden" id="id" value="${rulesRegulation.id }">
					<div class="col-md-6">
						<div class="box box-primary">
							<div class="box-header with-border">
								<h3 class="box-title">已审核内容</h3>
							</div>
							<div class="box-body" style="overflow-y:auto;">
								${rulesRegulation.publicContent }
							</div>
							<div class="box-footer"	style="text-align:center;">
								<button type="button" class="btn btn-primary" onclick="previewApprove(this)">预览</button>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="box box-primary">
							<div class="box-header with-border">
								<h3 class="box-title">待审核内容</h3>
							</div>
							<div class="box-body" style="overflow-y:auto;">
								${rulesRegulation.privateContent }
							</div>
							<div class="box-footer"	style="text-align:center;">
								<button type="button" class="btn btn-primary" onclick="previewApprove(this)">预览</button>
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="text-align:center; margin-top:1em;">
					<div class="col-md-12">
						<button type="button" class="btn btn-primary" onclick="approve()">审核</button>
						<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
					</div>
				</div>
			</section>	
		</c:when>
		
		<c:otherwise>
			<section class="content rlspace">
				<div class="row">
					<div class="col-md-12">
						<input type="hidden" id="id" value="${rulesRegulation.id }">
						<textarea id="contentCK" name="contentCK" rows="15" cols="70" >${rulesRegulation.privateContent }</textarea>
					</div>
				</div>
				<div class="row" style="text-align:center; margin-top:1em;">
					<div class="col-md-12">
						<button type="button" class="btn btn-primary" onclick="preview()">预览</button>
						<button type="button" class="btn btn-warning" onclick="save(1)">发布</button>
						<button type="button" class="btn btn-primary" onclick="save(0)">提交</button>
						<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
					</div>
				</div>
				
				<div class="row" style="text-align:center; margin-top:1em;">
					<div class="col-md-12">
						<pre style="text-align:left;color:gray;">备注：
1、提交后属于未发布状态，需以后再次发布 -> 审核才有效！
2、发布后需审核通过才有效！</pre>
					</div>
				</div>
			</section>	
		</c:otherwise>
	</c:choose>
</div>

<!-- Modal -->
<div class="modal fade" id="rulesRegulationModal" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
		<div class="modal-content" style="width:100%; height:100%; overflow:scroll;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">规章制度预览</h4>
			</div>
			<div class="modal-body">
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/rulesRegulation/js/edit.js"></script>
<script type="text/javascript">
var isApprove = false;
<c:if test="${not empty isApprove and isApprove eq 'y' }">
isApprove = true;
</c:if>
</script>
</body>
</html>