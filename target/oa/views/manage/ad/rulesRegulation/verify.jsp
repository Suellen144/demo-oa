<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">

<style type="text/css">
div#rMenu { position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px; }
div#rMenu ul { margin: 0px; padding: 0.5em 1em; }
div#rMenu ul li{ margin: 1px 0; padding: 0 5px; cursor: pointer; list-style: none outside none; background-color: #DFDFDF; }
</style>
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
	<section class="content rlspace">
		<div id="buttom" style="padding-bottom:8px;"></div>
		<div class="row">
			<div id="" class="col-md-2">
		 		<div class="row">
					<div class="box box-primary">
						<div class="box-body" style="overflow:auto;">
							<div class="col-xs-12">
								<ul id="publicTree" class="ztree"></ul>
							</div>
						</div> 
					</div>
				</div> 
				<div class="row">
					<div class="box box-primary">
						<div class="box-body" style="overflow:auto;">
							<div class="col-xs-12">
								<ul id="unpublicTree" class="ztree"></ul>
							</div>
							<div id="rMenu">
							<ul>
								<li id="m_add_title" onclick="addTitle('新增标题');">新增标题</li>
								<li id="m_edit_title" onclick="editTitle('编辑标题');">编辑标题</li>
								<li id="m_del_title" onclick="delTitle();">删除标题</li>
								<li id="m_edit_content" onclick="editContent();">编辑内容</li>
							</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- <div class="col-md-2" style="padding-left:0px;">
				<div class="box box-primary">
					<div class="box-body" style="overflow:auto;">
						<div class="col-xs-6">
							<ul id="unpublicTree" class="ztree"></ul>
						</div>
						<div id="rMenu">
							<ul>
								<li id="m_add_title" onclick="addTitle('新增标题');">新增标题</li>
								<li id="m_edit_title" onclick="editTitle('编辑标题');">编辑标题</li>
								<li id="m_del_title" onclick="delTitle();">删除标题</li>
								<li id="m_edit_content" onclick="editContent();">编辑内容</li>
							</ul>
						</div>
					</div>
				</div>
			</div> -->
			
			<div class="col-md-10">
				 <div class="box box-primary" style="margin-bottom:0px;" >
					<div id="content" class="box-body" style="height: 400px;"></div>
				</div> 
				<div class="box box-primary" style="margin-top:0px;">
					<div id="unpubliccontent" class="box-body" style="height: 600px;"></div>
				</div>
			</div>
		</div>
	</section>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="titleModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="outlineModalTitle"></h4>
         </div>
         <div class="modal-body">
         	<form id="form" class="form-horizontal" role="form">
				<div class="form-group">
					<label for="title" class="control-label col-md-2">标题</label>
					<div class="col-md-8">
						<input type="text" id="title" name="title" class="form-control" placeholder="标题名称">
					</div>
				</div>
			</form>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-primary" id="saveBtn" onclick="save()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
   </div>
</div><!-- /.modal -->

<!-- 模态框（Modal） -->
<div class="modal fade" id="contentModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog" style="width:80%;">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="contentModalTitle">编辑内容</h4>
         </div>
         <div class="modal-body">
         	<input type="hidden" id="rulesRegulationId" name="rulesRegulationId">
         	<textarea id="contentCK" name="contentCK" rows="7" cols="70" ></textarea>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-primary" id="saveBtn2" onclick="saveContent()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
   </div>
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.exhide.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/nicescroll/jquery.nicescroll.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/rulesRegulation/js/verify.js"></script>
</body>
</html>