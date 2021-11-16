	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>
	<head>
	<%@ include file="../../common/header.jsp"%>
	</head>
	<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
	<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
	<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
	<style>

 td {
		border: solid #999 1px;
		padding: 5px 0px;
		font-size: 0.8em;
	} 

td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding: 0px 1em;
}


td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding: 0px 1em;
}

td input[type="radio"] {
	margin-left: 0.5em;
	vertical-align: middle;
}

td label {
	font-weight: normal;
}

td p {
	padding: 5px 1em;
	margin: 0px;
}


.connectedSortable {
	padding-right: 0px;
} 

div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
div#rMenu ul li{
	margin: 1px 0;
	padding: 0 5px;
	cursor: pointer;
	list-style: none outside none;
	background-color: #DFDFDF;
}
</style>
<body>
	<header>
	 	<ol class="breadcrumb">
	       <li class="active">主页</li>
	       <li class="active">数据字典</li>
	    </ol>
	</header>
	
	<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<section class="col-md-3 connectedSortable ui-sortable">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
						<h3 class="box-title">字典管理</h3>
					</div>
					<div class="box-body">
						<div id="Divcloum1" class="col-xs-6">
							<ul id="dictTree" class="ztree"></ul>
						</div>
						<div id="rMenu">
							<ul>
								<li id="m_add" onclick="addTreeNode();">新增类型</li>
						 		<li id="d_add" onclick="adddata();">新增数据</li>
								<li id="m_edit" onclick="editTreeNode();">编辑类型</li>
								<li id="m_del" onclick="delTreeNode();">删除类型</li>
							</ul>
						</div>
					</div>
				</div>
			</section>
	<!-- Main content -->	
		<div class="row">
			<div class="col-xs-8 ">
				<div class="box box-primary box-solid">
					<div class="box-header">
						 <h3 class="box-title">字典数据</h3>
					</div>
					<div class="box-body">
							<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>数据名</th>
									<th>数据值</th>
									<th>备注</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		</div>
	</section>
</div>

<!-- 字典类型新增模态框 -->
<div class="modal fade" id="typeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">字典类型</h4>
         </div>
         <div class="modal-body">
         	<form id="form1">
				<input type="hidden" id="id" name="id"> 
				<input type="hidden" id="parentId" name="parentId">
				<table>
					<thead>
						<tr><th colspan="6"><span id="typeName"></span></th></tr>
					</thead>
					<tbody>
						<tr>
							<td><p>类型名称&nbsp;</p></td>
							<td>
								<input id="name" name="name" type="text" value="">
							</td>
						</tr>
						<tr>
							<td><p>类型备忘&nbsp;</p></td>
							<td>
								<input id="remark" name="remark" type="text" value="">
							</td>
						</tr>
					</tbody>
				</table>
			</form>
         </div>
         <div class="modal-footer">
            <button type="submit" class="btn btn-primary" id="saveBtn" onclick="save()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->
</div>

<!-- 字典数据新增模态框 -->
 <div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">字典数据</h4>
         </div>
         <div class="modal-body">
         	<form id="form2">
				<input type="hidden" id="typeid" name="typeid">
				<table>
					<thead>
						<tr><th colspan="6"><span id="dataName"></span></th></tr>
					</thead>
					<tbody>
						<tr>
							<td><p>数据名&nbsp;</p></td>
							<td>
								<input id="name" name="name" type="text" value="">
							</td>
						</tr>
							<tr>
							<td><p>数据值&nbsp;</p></td>
							<td>
								<input id="value" name="value" type="text" value="">
							</td>
						</tr>
						<tr>
							<td><p>数据备忘&nbsp;</p></td>
							<td>
								<input id="remark" name="remark" type="text" value="">
							</td>
						</tr>
					</tbody>
				</table>
			</form>
         </div>
         <div class="modal-footer">
            <button type="submit" class="btn btn-primary" id="saveBtn" onclick="savedata()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div>
</div>
</div> 



<!-- 字典数据编辑模态框 -->
  <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">字典数据</h4>
         </div>
         <div class="modal-body">
         	<form id="form3">
				<input type="hidden" id="editid" name="id" value = "" >
				<input type="hidden" id="edittypeid" name="typeid" value = "" >
				<table>
					<thead>
						<tr><th colspan="6"><span>编辑数据</span></th></tr>
					</thead>
					<tbody>
						<tr>
							<td><p>数据名&nbsp;</p></td>
							<td>
								<input id="editname" name="name" type="text" value="">
							</td>
						</tr>
							<tr>
							<td><p>数据值&nbsp;</p></td>
							<td>
								<input id="editvalue" name="value" type="text" value="">
							</td>
						</tr>
						<tr>
							<td><p>数据备忘&nbsp;</p></td>
							<td>
								<input id="editremark" name="remark" type="text" value="">
							</td>
						</tr>
					</tbody>
				</table>
			</form>
         </div>
         <div class="modal-footer">
            <button type="submit" class="btn btn-primary" id="saveBtn" onclick="updatedata()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div>
</div>
</div> 
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/dict/js/list.js"></script>
<script>
</body>
</html>