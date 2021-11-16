<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <%@ include file="../../common/header.jsp"%>
            <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
            <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
            <link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">

            <style>
                #myTab>li.active a {
                    background-color: #3c8dbc;
                    color: white;
                    font-weight: bold;
                }
                
                td,
                th {
                    border: 1px solid;
                }
                
                th {
                    background-color: #3c8dbc;
                    color: #fff;
                    border: 1px solid #1E71A0 ;
                }
                
                td {
                    border-color: #ddd;
                    line-height: 1.5em;
                }
                .tab-pane #treetable thead tr th{line-height:30px;}
            </style>
    </head>

    <body>
        <header>
            <ol class="breadcrumb">
                <li class="active">主页</li>
                <li class="active">组织机构</li>
            </ol>
        </header>
        <ul id="myTab" class="nav nav-tabs rlspace">
            <li class="active"><a href="#list" data-toggle="tab">组织架构</a></li>
<!--             <li><a href="#position" data-toggle="tab">职位</a></li> -->
            <!-- <li><a href="#organization" data-toggle="tab">组织关系</a></li> -->
            <li><a href="<%=base%>/manage/organization/toList" >组织关系</a></li>
            <li><a href="<%=base%>/manage/institution/toList" >机构设置</a></li>
            <li><a href="<%=base%>/manage/addressbook/toList" >通讯录</a></li>
            <shiro:hasPermission name="sys:dept:sort ">
            <button id="sort" name="sort" style="float: right;" onclick="setSort()" class="btn btn-primary">排序</button>
            </shiro:hasPermission>
        </ul>
        
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="list">
                <div class="col-xs-12">
                    <table id="treetable" style="width:100%;" class="sortable">
                        <thead>
                            <tr>
                                <th style="width:20%;">单位名</th>
                                <th style="width:50%;">人员</th>
                                <!-- 				<th>排序序号</th> -->
                                <!-- 	<th>经理</th>
							<th>副经理</th>  -->
                                <!-- 	<th>操作</th> -->
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

            <div class="tab-pane fade" id="position">
                <iframe id="position_iframe" name="position_iframe" width="100%" height="1000" frameborder="no" scrolling="yes" src="<%=base%>/manage/ad/position/toList"></iframe>
            </div>
            
             <div class="tab-pane fade" id="organization">
                <iframe id="organization_iframe" name="position_iframe" width="100%" height="1000" frameborder="no" scrolling="yes" src="<%=base%>/manage/organization/toList"></iframe>
            
            	<script>
            		document.getElementById('organization_iframe').contentWindow.location.reload(true);
            	</script>
            </div>
        </div>


        <!-- 职位模态框（Modal） -->
        <div class="modal fade" id="positionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
                        <h4 class="modal-title" id="myModalLabel" style="text-align:center;">职位表单</h4>
                    </div>
                    <div class="modal-body">
                        <form id="form">
                            <input type="hidden" id="id" name="id">
                            <input type="hidden" id="deptId" name="deptId">
                            <table style="margin:auto;width:70%;text-align:center;">
                                <thead>
                                    <tr>
                                        <th colspan="6" style="text-align: center;"><span id="positionName"></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>中文名&nbsp;</p>
                                        </td>
                                        <td>
                                            <input id="name" name="name" type="text" value="" class="form-control">
                                        </td>
                                    </tr>
                                    <!-- 	<tr>
							<td><p>英文名&nbsp;</p></td>
							<td>
								<input id="enname" name="enname" type="text" value=""  class="form-control">
							</td>
						</tr> -->
                                    <tr>
                                        <td>
                                            <p>职位等级&nbsp;</p>
                                        </td>

                                        <td>
                                            <select id="level" name="level" class="form-control" style="border:none;"><custom:dictSelect type="职位等级"/></select>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary" id="saveBtn" onclick="update()">保存</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.modal -->
		<!-- 开票信息模态框 -->
		    <div class="modal fade" id="companyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
                        <h4 class="modal-title" id="myModalLabel" style="text-align:center;">公司信息</h4>
                    </div>
                    <div class="modal-body">
                        <form id="form">
                            <table style="margin:auto;width:80%;text-align:center;">
                                <thead>
                                    <tr>
                                        <th colspan="6" style="text-align: center;"><span id="companyName"></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>名称&nbsp;</p>
                                        </td>
                                        <td>
                                            <input style="width:100%;border: none;text-align:center;" id="companyname" type="text"  readonly value="">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <p>地址&nbsp;</p>
                                        </td>

                                        <td>
                                            <input style="width:100%;border: none;text-align:center;" id="address" type="text"  readonly value="">
                                        </td>
                                    </tr>
                                     <tr>		
                                        <td>
                                            <p>电话&nbsp;</p>
                                        </td>

                                        <td>
                                            <input style="width:100%;border: none;text-align:center;" id="phone" type="text"  readonly value="">
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                            <p>纳税人识别号&nbsp;</p>
                                        </td>

                                        <td>
                                            <input style="width:100%;border: none;text-align:center;" id="nubmer" type="text"  readonly value="">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </div>
            </div>
        </div>
         <!-- /.modal -->
        <%@ include file="../../common/footer.jsp"%>
          	<script>
                var canEdit = '<shiro:hasPermission name="sys:dept:edit">true</shiro:hasPermission>';
                var canAdd = '<shiro:hasPermission name="sys:dept:add">true</shiro:hasPermission>';
                var canDel = '<shiro:hasPermission name="sys:dept:del">true</shiro:hasPermission>';
            </script>
            <script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
            <script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
            <script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
            <script type="text/javascript" src="<%=base%>/views/manage/sys/dept/js/list.js"></script>
            <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
            <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>
            <script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui.min.js"></script>
    </body>

    </html>