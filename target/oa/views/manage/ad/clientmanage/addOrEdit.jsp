<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
</head>
<style>
table {
	border: 1px solid #fefefe;
	text-align: center;
}

textarea {
	resize: none;
	border: none;
	outline: medium;
	width:100%;
}

#table td input[type="barginCode"],input[name="barginName"],input[name="barginUserName"]{
	text-align:center;
}

/*项目信息*/
.projectBg{ background-color: #f6f6f6!important;}
.projectTable{ text-align: left;}

.input {
	width: 100%;
	height: 100%;
	border: none;
	text-align: center;
	outline: medium;
	resize:none;
	overflow-x: visible;
	overflow-y: visible;
	outline:transparent;
}
th {
	background-color: #ebebeb;
	border: 1px solid #ccc !important;
	text-align: center;
}
table tr>td {
	border: 1px solid #ccc !important;
}
td>input {
	width: 100%;
	border: none;
	outline: medium;
}

textarea{
	height:20px;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align: justify;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
	text-align: justify;
}
.blackColor{
	color: #000000;
			
}

</style>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">项目管理</li>
			<li class="active">
				<c:if test="${not empty project.id }">编辑</c:if>
				<c:if test="${empty project.id }">新增</c:if>
			</li>
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
						<h3 class="box-title" style="color: #367fa9;font-weight: bold;">客户信息</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace">
						<input type="hidden" id="id" name="id" value="${clientManage.id}">
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">客户姓名</label>
							<div class="col-sm-8">
								<input class="form-control" id="clientName" name="clientName" placeholder="客户姓名" value="${clientManage.clientName}">
							</div>
							<label style="color: red;margin-top: 10px;font-size: 16px">*</label>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">客户单位</label>
							<div class="col-sm-8">
								<input class="form-control" id="company" name="company" placeholder="客户单位" value="${clientManage.company}">
							</div>
							<label style="color: red;margin-top: 10px;font-size: 16px">*</label>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">客户部门</label>
							<div class="col-sm-8">
								<input class="form-control" id="dept" name="dept" placeholder="客户部门" value="${clientManage.dept}">
							</div>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">客户职务</label>
							<div class="col-sm-8">
								<input class="form-control" id="clientPosition" name="clientPosition" placeholder="客户职务" value="${clientManage.clientPosition}">
							</div>
							<label style="color: red;margin-top: 10px;font-size: 16px">*</label>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">联系方式</label>
							<div class="col-sm-8">
								<input class="form-control" id="clientPhone" name="clientPhone" placeholder="联系方式" value="${clientManage.clientPhone}">
							</div>
							<label style="color: red;margin-top: 10px;font-size: 16px">*</label>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">客户邮箱</label>
							<div class="col-sm-8">
								<input class="form-control" id="email" name="email" placeholder="邮箱" value="${clientManage.email}">
							</div>
							<label style="color: red;margin-top: 10px;font-size: 16px">*</label>
						</div>
						<div class="form-group">
							<label for="type" class="col-sm-1 control-label">联系地址</label>
							<div class="col-sm-8">
								<input class="form-control" id="address" name="address" placeholder="地址" value="${clientManage.address}">
							</div>
						</div>
						<div class="form-group">
						<label for="describe" class="col-sm-1 control-label">相关备注</label>
						<div class="col-sm-8">
							<textarea class="form-control" id="remark" name="remark" placeholder="备注" value="">${clientManage.remark}</textarea>
						</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">现负责人</label>
							<div class="col-sm-8">
							<c:choose>
								<c:when test="${not empty clientManage.clientId}">
									<input type="hidden" name="clientId" id="clientId" value="${clientManage.clientId}">
									<div class="input-group">
				                   		 <input type="text" id="userName" value="${clientManage.user.name}" class="form-control"  onclick="openDialog(1)" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                   		 <span class="input-group-addon" onclick="removePrincipal()" style="color: #367fa9;cursor:pointer"><i class="fa fa-remove"></i></span>
				                </div>
								</c:when>
								<c:otherwise>
									<input type="hidden" name="clientId" id="clientId" value="${user.id}">
									<div class="input-group">
				                    	<input type="text" id="userName" value="${user.name}" class="form-control"  onclick="openDialog(1)" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                   		<span class="input-group-addon" onclick="removePrincipal()" style="color: #367fa9;cursor:pointer"><i class="fa fa-remove"></i></span>
				              		</div>
								</c:otherwise>
							</c:choose>
								
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">前负责人</label>
							<div class="col-sm-8">
								<input type="hidden" name="preClientId" id="preClientId" value="${clientManage.preClientId}">
								<div class="input-group">
				                    <input type="text" id="preuserName" value="${clientManage.preUser.name}" class="form-control"  onclick="openDialog(2)" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                    <span class="input-group-addon" onclick="removePrePrincipal()" style="color: #367fa9;cursor:pointer"><i class="fa fa-remove"></i></span>
				                </div>
				                
							</div>
						</div>
						<!--关联项目 -->
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">相关项目</label>
							<div class="col-sm-8" id="accordion">
								<input type="hidden" name="projectId" id="projectId" value="${clientManage.projectId}">
								<div class="input-group">
				                    <input type="text" id="projectName" value="${clientManage.projectManage.name}" class="form-control"  onclick="openProject()" style="text-align: left;background-color: #fff;cursor: pointer;" readonly>
				                    <span class="input-group-addon" onclick="showProject()" href="#intercityCost" data-toggle="collapse" data-parent="#accordion" style="color: #367fa9;cursor:pointer">
				                    <i class="fa fa-plus" id="show"></i>
				                    </span>
				                    <span class="input-group-addon" onclick="removeProject()" style="color: #367fa9;cursor:pointer">
				                     <i class="fa fa-remove"></i>
				                    </span>
				             </div>
				              	  <!--项目详情框 -->
								<div class="form-group panel-collapse collapse" style="margin: 0; margin-top: 10px;" id="intercityCost">
									<table class="table table-bordered projectTable">
										<tbody>
										<tr>
											<td class="projectBg">项目名称</td>
											<td id="projectName1">${projectManage.name }</td>
											<td class="projectBg">负责人</td>
											<td id="principal">${projectManage.principal.name}</td>
										</tr>
										<tr>
											<td class="projectBg">项目类型</td>
											<td id="projectType">
												<c:choose>
													<c:when test="${projectManage.type eq '0' } ">销售类</c:when>
													<c:when test="${projectManage.type eq '1' } ">研发类</c:when>
													<c:when test="${projectManage.type eq '2' } ">运营成本类</c:when>
													<c:when test="${projectManage.type eq '3' } ">业务成本类</c:when>
													<c:when test="${projectManage.type eq '4' } ">渠道合作项目</c:when>
													<c:otherwise>合资项目</c:otherwise>
												</c:choose>
											</td>
											<td class="projectBg">项目地址</td>
											<td id="projectAddress">
												<c:choose>
													<c:when test="${projectManage.location  eq '0' } ">公司</c:when>
													<c:otherwise>其他</c:otherwise>
												</c:choose>
											</td>
										</tr>
										<tr>
											<td class="projectBg">项目描述</td>
											<td colspan="3" id="projectDescription">${projectManage.describe }</td>
										</tr>
										</tbody>
									</table>
								</div>
									<!--项目详情框 -->
							</div>
						</div>
						<!--关联项目 -->
						<%--关联拜访--%>
						<div class="form-group" style="margin: 0; margin-top: 10px;">
							<table class="table table-bordered projectTable" id="marketInfo" style="width: 74%;margin-left: 5px">
							</table>
						</div>
				</div>
			</div>
						<%--关联拜访--%>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10"  style="margin-left: 35%">
									<c:if test="${not empty clientManage.id }">
									<c:if test="${clientManage.userId ne user.id }">
									<shiro:hasPermission name="ad:clientmanage:edit">
										<button type="button" class="btn btn-primary" onclick="save()">更新</button>
									</shiro:hasPermission>
									</c:if>
									<c:if test="${clientManage.userId eq user.id }">
										<button type="button" class="btn btn-primary" onclick="save()">更新</button>
									</c:if>
									</c:if>
									<c:if test="${empty clientManage.id }">
											<button type="button" class="btn btn-primary" onclick="save()">提交</button>
									</c:if>
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
						</div>
						</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="userDialog"></div>
<div id="barginUserName"></div> 
<div id="deptDialog"></div>
<div id="projectDialog"></div>


<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/clientmanage/js/addOrEdit.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript"src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
</body>
</html>