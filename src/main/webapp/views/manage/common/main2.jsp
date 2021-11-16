<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/AdminLTE/css/skins/_all-skins.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMain.css">
<style>
	.skin-blue .main-header .navbar .dropdown-menu li a{
		color: #0c0c0c;
	}
</style>
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body class="hold-transition skin-blue sidebar-collapse">
	<div class="wrapper">

		<header class="main-header">
			
			<!-- Header Navbar: style can be found in header.less -->
			<nav class="navbar navbar-static-top">
				<!-- Sidebar toggle button-->
				<c:if test="${sessionScope.user.id ne 36 and sessionScope.user.id ne 50}">
					<a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button"> <span class="sr-only">Toggle navigation</span>
					</a>
				</c:if>
					<!-- Logo -->
			<a href="main2" class="logo" style="background-color:#3c8dbc"> <!-- logo for regular state and mobile devices -->
				<img alt="" src="<%=base%>/static/images/main/logo.png">
			</a>
				<div style="display:none; float:left; line-height:2.1em; font-size:1.5em; font-weight:bold; color:orange; padding-left:3em;">(测试版)</div>
				<div class="navbar-custom-menu">
					<ul class="nav navbar-nav">
						<li class="dropdown messages-menu">
							<a href="javascript:forward(history.go(-1));">
								<i class="fa fa  fa-reply" style="font-size:18px;"></i> 
								<span class="label label-success"></span>
							</a>
						</li> 
						<li class="dropdown messages-menu">
							<a href="main2">
								<i class="fa fa fa-home" style="font-size:18px;"></i> 
								<span class="label label-success"></span>
							</a>
						</li> 
						<!-- 系统设置 -->
						<shiro:hasPermission name="sys:menu:set">
						<li class="dropdown messages-menu">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">
								<i class="fa fa fa-gears" style="font-size:18px;"></i> 
								<span class="label label-success"></span>
							</a>
							<ul class="dropdown-menu" id="dropDownSetting">
								<li>
									<a href="javascript:forward('<%=base%>/manage/sys/menu/toList');">
									<i class="icon-pencil icon-white"></i> 
									<span>系统菜单</span>
									</a>
								</li>
								<li>
									<a href="javascript:forward('<%=base%>/manage/sys/role/toList');">
									<i class="icon-github-sign icon-white"></i> 
									<span>角色管理</span>
									</a>
								</li>
								<li>
									<a href="javascript:forward('<%=base%>/manage/sys/encrypt/toPage');">
									<i class="icon-lock icon-white"></i> 
									<span>模块加密</span>
									</a>
								</li>
								<li>
									<a href="javascript:forward('<%=base%>/manage/sys/dict/toList');">
									<i class="icon-book icon-white"></i> 
									<span>数据字典</span>
									</a>
								</li>
							</ul>
						</li> 
						</shiro:hasPermission>
						<!-- 用户信息 -->
						<li class="dropdown user user-menu" onclick="refreshInfo(this)">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown"> <c:if
									test="${not empty sessionScope.user.photo }">
									<img id="mainHeadImg" src="<%=base%>${sessionScope.user.photo}"
										class="user-image" alt=" ">
								</c:if> <c:if test="${empty sessionScope.user.photo }">
									<img id="mainHeadImg"
										src="<%=base%>/static/AdminLTE/img/avatar04.png"
										class="user-image" alt=" ">
								</c:if> <span class="hidden-xs"> ${sessionScope.user.name } </span>
						</a>
							<ul class="dropdown-menu" id="dropDownMenu">
								<!-- User image -->
								<li class="user-header"><c:if
										test="${not empty sessionScope.user.photo }">
										<img id="secondHeadImg" src="<%=base%>${sessionScope.user.photo}"
											class="user-image" alt=" ">
									</c:if> <c:if test="${empty sessionScope.user.photo }">
										<img id="secondHeadImg" src="<%=base%>/static/AdminLTE/img/avatar04.png"
											class="user-image" alt=" ">
									</c:if> <br />
									<p>
										${sessionScope.user.name } <small><fmt:formatDate
												value="<%=new java.util.Date() %>" pattern="yyyy-MM-dd" /></small>
									</p></li>
								<!-- Menu Footer-->
								<li class="user-footer">
									<div class="pull-left">
									<%--	<a href="javascript:;" onclick="toUserDetail()"
											class="btn btn-info btn-flat">个人信息</a>--%>
										<button type="button" class="btn btn-info" onclick="toUserDetail()">
											个人信息
										</button>

									</div>
									<%-- 具有某模块解密权限的都可看到此按钮 --%>
									<shiro:hasAnyPermission name="fin:reimburse:encrypt,fin:reimburse:decrypt,fin:travelreimburse:encrypt,fin:travelreimburse:decrypt">
										<div class="" style="float:left; margin-left:13%;">
											<%--<a href="javascript:;" onclick="popWindow()" class="btn btn-info btn-flat">解锁</a>--%>
												<button type="button" class="btn btn-info" onclick="popWindow()">
													解锁
												</button>
											<form action="importEncryptionKey" style="display:none;">
												<input type="file" id="encryptionKeyFile" name="encryptionKeyFile" accept="text/plain">
											</form>
										</div>
									</shiro:hasAnyPermission>
									<div class="pull-right">
									<%--	<a href="javascript:void(0);" onclick="logout()" class="btn btn-info btn-flat">注销</a>--%>
										<button type="button" class="btn btn-info" onclick="logout()">
											注销
										</button>
									</div>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</nav>
		</header>
		<aside class="main-sidebar">
			<div class="userMsgBox">
				<div class="userMsgConn" style="margin-bottom:7px;">
					用户名：${sessionScope.user.name}
				</div>
				<div class="userMsgConn">所属部门：
					<c:if test="${sessionScope.user.dept.name ne '总经理'}">
						${sessionScope.user.dept.name}
					</c:if>
				</div>
			</div>
			<section class="sidebar">
				<!-- 菜单 -->
				<ul class="sidebar-menu"></ul>
			</section>
		</aside>

		<!-- 内容块 -->
		<section id="content">
	        <div class="content-wrapper">
	            <iframe id="contentFrame" name="contentFrame" width="100%" frameborder="no" scrolling="auto" src="<%=base%>/manage/sys/user/toPersonHome2"></iframe>
	        </div>
	    </section>

	</div>
	<!-- ./wrapper -->

<%@ include file="footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script src="<%=base%>/common/js/dateUtils.js"></script>
<script src="<%=base%>/common/js/webSocket.js"></script>
<script src="<%=base%>/views/manage/common/js/main2.js"></script>

<!-- 弹窗start -->
<!-- 标题+内容弹窗start -->
<div class="box box-primary box-solid popup" style="display:none;">
	<div class="box-header with-border">
		<h3 class="box-title">提示</h3>
		<div class="box-tools pull-right">
			<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
		</div>			
	</div>
	<div class="box-body">
		<h4 class="text-light-blue">OA试用通知</h4>
		<div class="popupBox">				
			<p>各位同事：<br>
公司的OA系统已经开始研发和逐步上线，请各同事积极参与试用，在界面、功能等方面提出更合理的需求建议，谢谢！
登录方法为点击公司官网www.reyzar.com 首页底部的“登录OA”图标。...</p>
		</div>	
		<a>查看详情</a>		
	</div>
</div>
<!-- 标题+内容弹窗end -->
<!-- 列表start -->
<div id="messageListPanel" class="box box-primary box-solid popup" style="display:none;" onmouseover="destroyTimeout()" onmouseout="startTimeout()">
	<div class="box-header with-border">
		<h3 class="box-title">提示</h3>
		<div class="box-tools pull-right">
			<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
		</div>			
	</div>
	<div class="box-body">
		<div class="popupList">				
			<ul class="list-unstyled">
				<!-- <li><a>OA试用通知</a></li> -->
			</ul>
		</div>			
	</div>
</div>
<!-- 列表end -->
<!-- 弹窗end -->

<!-- 模态框（Modal） -->
<div class="modal fade" id="msgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">提示消息</h4>
         </div>
         <div class="modal-body"></div>
         <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div>
</div><!-- /.modal -->
</body>
</html>
