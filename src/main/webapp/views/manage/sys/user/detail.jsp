<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link href="<%=base %>/static/plugins/permanent-calendar/permanentCalendar.css" rel="stylesheet" type="text/css" />
<link href="<%=base %>/static/plugins/fileupload/css/jquery.fileupload.css" rel="stylesheet" type="text/css" />
<style>
.name {
	font-size: 1.5em;
	font-weight: bold;
	padding: 10px 0px;
}
.dept {
	background-color: #dcdcdc;
	margin: 0 auto;
	padding: 3px 0px;
}
table {
	table-collapse: collapse;
	border: none;
}
td {
	border: solid #999 1px;
	padding: 0px;
}
td input[type="text"] {
	width: 100%;
	height: 100%;
	outline: medium;
	border:none;
	height:30px;
	line-height:30px;
}
td p {
	padding: 0.5em;
	text-align: center;
}
th {
	border: solid #999 1px;
	text-align: left;
	padding: 3px 5px;
}
textarea {
	resize: none;
	border: none;
	outline: medium;
}

</style>
</head>
<body style="background-color:#ecf0f5;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb" style="background-color:#ededed;border-bottom:1px solid #ccc;">
			<li class="active">主页</li>
			<li class="active">个人信息</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">个人信息</h3>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<form id="form">
							<input type="hidden" id="id" name="id" value = "${record.id}">
							<table>
								<tbody>
									<tr>
										<td><p>姓名</p></td>
										<td><input id="name"  type="text" value="${record.name}"></td>
										<td><p>性别</p></td>
										<td><input id="sex" readonly  type="text" value="<custom:getDictKey type="个人档案性别" value="${record.sex}"/>"></td>
										<!-- 档案照片 -->
										<td rowspan="4" colspan = "3" style="text-align: center;">
											<img id="recordImg" src="<%=base%>${record.photo }" style="max-width:149px; width:100%; height:140px;" />
						    			</td> 
									</tr>
									<tr>
										<td><p>部门</p></td>
										<td>
											<c:choose>
												<c:when test="${fn:indexOf(record.deptName, '总经理') <= -1 }">
													<input id="dept" name="dept" type="text" value="${record.deptName}" readonly>
												</c:when>
												<c:otherwise>
													<input type="text" value="" readonly>
												</c:otherwise>
											</c:choose>
										</td>
										<td><p>职位</p></td>
										<td><input id="position" readonly type="text" value="${record.position}"></td>
									</tr>
									<tr>
										<td><p>民族</p></td>
										<td><input id="nation" readonly type="text" value="${record.nation}"></td>
										<td><p>政治面貌</p></td>
										<td><input id="politicsStatus"  readonly type="text" value="<custom:getDictKey type="政治面貌" value="${record.politicsStatus}"/>"></td>
									</tr>
									<tr>
										<td><p>生日</p></td>
										<td><input type="text" id="birthday" readonly readonly class="birthday"  value="<fmt:formatDate value="${record.birthday}" pattern="yyyy-MM-dd" />"/></td>
										<td><p>婚姻状态</p></td>
										<td><input id="maritalStatus"  readonly type="text" value="<custom:getDictKey type="员工婚姻状态" value="${record.maritalStatus}"/>"></td>
									</tr>
									<tr>
										<td><p>联系电话</p></td>
										<td><input id="phone" name="phone" type="text" value="${record.phone}" ></td>
										<td><p>QQ </p></td>
										<td><input id="qq" name="qq" type="text" value="${record.qq}" ></td>
										<td><p>邮箱地址</p></td>
										<td><input id="email" name="email" type="text" value="${record.email}"></td>
									</tr>
									<tr>
										<td><p>毕业院校</p></td>
										<td><input id="school" readonly type="text" value="${record.school}"></td>
										<td><p>专业</p></td>
										<td><input id="major" readonly type="text" value="${record.major}"></td>
										<td><p>专业技术职称</p></td>
										<td><input id="majorName" readonly type="text" value="${record.majorName}"></td>
									</tr>
									<tr>
										<td><p>身份证地址</p></td>
										<td colspan="5"><input id="idcardAddress" readonly type="text" value="${record.idcardAddress}"></td>
									</tr>
									<tr>
										<td><p>身份证号码</p></td>
										<td colspan="5"><input id="idcard" readonly type="text" value="${record.idcard}"></td>
									</tr>
									<tr>
										<td><p>户口所在地</p></td>
										<td colspan="3"><input id="householdAddress" readonly type="text" value="${record.householdAddress}"></td>
										<td><p>户口性质</p></td>
										<td>
										 	<input id="householdState" readonly type="text" value="<custom:getDictKey type="档案户口性质" value="${record.householdState}"/>">
										</td> 
									</tr>
							
									<tr>
										<td><p>现住址</p></td>
										<td colspan="5"><input id="home" name="home" type="text" value="${record.home}"></td>
									</tr>
								</tbody>
							</table>
							<div style="width:47%; text-align:center; margin-top:0.5em;">
								<button type="button" id="saveBtn" class="btn btn-primary" onclick="save()">提交</button>
								<button type="button" id="backBtn" class="btn btn-default" onclick="javascript:window.history.back();">返回</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">帐号管理</h3>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<input type="hidden" id="photo" name="photo" value="${user.photo}">
						<input type="hidden" id="userId" name="userId" value="${user.id}">
						
						<form id="form1" class="form-horizontal tbspace" method="post">
							<input type="hidden" id="password" name="password" value="${sessionScope.user.password }">
							<input type="hidden" id="account" name="account"value="${sessionScope.user.account }" readonly>
							
							<div class="form-group">
								<label for="qq" class="col-sm-1 control-label">头像</label>
								<div class="col-md-4">
									<span class="btn btn-success fileinput-button">
								        <i class="glyphicon glyphicon-plus"></i>
								        <span>选择图片</span>
								        <input id="file" type="file" name="file">
							    	</span>
							    	<c:if test="${not empty sessionScope.user.photo }">
										<img id="headImg" src="<%=base%>${user.photo }" style="width:50px;">
									</c:if>
									<c:if test="${empty sessionScope.user.photo }">
										<img id="headImg" src="<%=base%>/static/AdminLTE/img/avatar04.png" class="user-image" alt="User Image" style="width:50px;">
									</c:if>
							    	<span id="imgName"></span>
								</div>
								<div class="col-md-2">
									<button type="button" class="btn btn-primary" onclick="uploadHeaderImg()">上传头像</button>
								</div>
							</div>
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">原始密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="origin_pwd" name="origin_pwd" placeholder="原始密码" value="">
									<label id="origin_pwd_error" class="error" style="display:none;">原始密码错误！</label>
								</div>
							</div>
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">新密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="new_pwd" name="new_pwd" placeholder="新密码" value="">
								</div>
							</div>
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">重复密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="re_pwd" name="re_pwd" placeholder="重复新密码" value="">
									<label id="re_pwd_error" class="error" style="display:none;">重复密码与新密码不一致！</label>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<button type="submit" class="btn btn-primary">确认</button>
									<button type="reset" class="btn btn-default">重置</button>
									<button type="button" id="backBtn" class="btn btn-default" onclick="javascript:window.history.back();">返回</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="deptDialog"></div>


<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<!-- File upload widget -->
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sys/user/js/detail.js"></script>
</body>
</html>