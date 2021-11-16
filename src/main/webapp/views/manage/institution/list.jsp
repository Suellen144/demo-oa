<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/bootstrap-switch.css">
<link rel="stylesheet" href="<%=base%>/static/jquery/picker/flatpickr.min.css">
<link rel="stylesheet" href="<%=base%>/static/jtoggler/jtoggler.styles.css">
<style>
	/* body {-webkit-touch-callout:none;-webkit-user-select: none;-moz-user-select: none;-webkit-user-select:none; -o-user-select:none; user-select:none; }
 */
	select {appearance: none;-moz-appearance: none;border: none;}
	#myTab>li.active a {background-color: #3c8dbc;color: white;font-weight: bold;}
      
	td,th {border: 1px solid;}
      
	#treetable_qxdy th {background-color: #3c8dbc;color: #fff;border: 1px solid #1E71A0 ;} 
      
	td {border-color: #ddd;line-height: 30px;padding-left:5px;}
	.box-section .box-body{overflow:auto;} 
	.box-section .box-body #treetable tbody td{cursor:pointer;}
	#treetable{position: relative;top:0px;margin:0px;}
	#treetable tbody tr td span{float: left;display: block;height:19px;}
	#treetable tbody tr td p{float: left;margin:0px;}
    .power{position:relative;}        	
      
	.sortable{position: absolute;-webkit-tap-highlight-color: rgba(0,0,0,0);-webkit-transform: translateZ(0);-moz-transform: translateZ(0);-ms-transform: translateZ(0);-o-transform: translateZ(0);transform: translateZ(0);} 
     
	.box-header{color:#000 !important;}
	#organization{color:#fff !important;background:#3c8dbc;}
	
	.box-body{height:463px}
	label{margin:0;line-height:30px;}
	.powerlab{padding-left:10px;position: relative;padding-right:20px;}
	.inchecked {position: absolute;top:8px;right:15px;}
	.Checkbox {position: absolute;visibility: hidden;}
	.Checkbox+b {position:absolute;width: 15px;height: 15px;border: 1px solid #DEDEDE;border-radius: 50%;background-color:#eee;} 
	.Checkbox:checked+b:after {content: "";position: absolute;left: 4px;top:4px;width: 5px;height: 5px;background: #3cdd4b;border-radius: 50%;border-top-color: transparent;border-right-color: transparent; transform: rotate(-45deg);-ms-transform: rotate(-60deg);-moz-transform: rotate(-60deg);-webkit-transform: rotate(-60deg);}
	.power{text-align:left;}
	
	input#position{border: 0px;outline: none;}
    .btn-primary{margin:0px 10px;}
    
    .dropdown-menu{width:100%;background:#3c8dbc;border-color:#3c8dbc;max-height:220px;overflow: auto;}
    .dropdown-menu li{line-height:30px;color:#fff;text-align: center;cursor: pointer;}
    .dropdown-menu li:hover{color:#333;background:rgba(255,255,255,0.1)}    
    
    #content{width: 100%;height: 100%;resize:none;border:0;background: #fff;font-size: 16px;max-height: 200px;overflow: auto}

	.liAlert{z-index:-100; background: rgba(0,0,0,0.6);position: absolute;width: 100%;height: 100%;top: 0px;left: 0px;display: flex;vertical-align: middle;}
	.liMove{line-height:26px;background:#fff;width:50%;margin:auto;padding:5px 0px;border-radius: 10px; -moz-box-shadow:0px 0px 10px #eee; -webkit-box-shadow:0px 0px 10px #eee; box-shadow:0px 0px 10px #eee;}
	.liMove li{list-style: none;text-align: center;font-size:17px;}
	.modal-body #form4 thead th{border-color: #3c8dbc;}
    .modal-body #form4 tbody {width:100%;border-left:1px solid #CCCCCC;}
    .modal-body #form4 tbody tr {width:50% ;height:30px;float: left;line-height: 25px;border-bottom:1px solid #CCCCCC;border-right:1px solid #CCCCCC;}
    .modal-body #form4 tbody tr th{display: flex;justify-content: center;align-items: center;width:30%;float: left;border:0;border-right:1px solid #CCCCCC;}
    .modal-body #form4 tbody tr th p{display: block;font-weight: 400;margin:0px;text-align: center;line-height:30px;}
    .modal-body #form4 tbody tr td{display: flex !important;justify-content: center;align-items: center;width:70%;display: block;float: left;border:0;}
    .modal-body #form4 tbody tr td select{width:100%;text-align-last: center;text-align: center;width:100%;line-height:25px;}
    .modal-body #form4 tbody tr td input{width:100%;border: none;text-align:center;line-height: 25px;}
    .modal-body #form4 tbody tr:last-child{width:100% !important;min-height: 100px;height:100px;}
    .modal-body #form4 tbody tr:last-child th{width:14.9%; border-right: 0;vertical-align: middle;height:100px;height:100px;}
    .modal-body #form4 tbody tr:last-child td{width:85%; border-left:1px solid #CCCCCC;height:100px;}
    .modal-body #form4 tbody tr textarea{background: none; width:100%;border:0;min-height: 30px !important;}
    .modal-body #form4 tbody tr #jyfw{min-height: 100px;}
</style>
</head>
<script type="text/javascript">
var jgszEdit='<shiro:hasPermission name="jgsz:edit">true</shiro:hasPermission>';
</script>
 
 <body>
 		<header>
            <ol class="breadcrumb">
                <li class="active"></li>
                <li class="active"></li>
            </ol>
        </header> 
 		<ul id="myTab" class="nav nav-tabs rlspace">
<%--             <li><a href="<%=base%>/manage/sys/dept/toList">组织架构</a></li> --%>
            <li><a href="<%=base%>/manage/organization/toList" >组织关系</a></li>
			<li class="active"><a href="<%=base%>/manage/institution/toList" >机构设置</a></li>
            <%--<li><a href="<%=base%>/manage/addressbook/toList" >通讯录</a></li>--%>
        </ul>
 
    <div class="wrapper" style="margin:0;padding:10px 13px;">
		<section class="content rlspace" style="padding:0px !important;">
			<div class="row">
				<section class="col-md-3 box-section" style="position: relative;">
					<div class="box box-primary box-solid">
						<div class="box-header with-border" style="padding:4px 0px;">
							<div class="dropdown">
							  <button class="btn btn-default dropdown-toggle" style="width:100%;border:0;" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
							    <p id="Ptitle" style="display: inline-block;width: 90%;margin:0;"></p>
							    <span class="caret"></span>
							  </button>
							  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1"></ul>
							</div>
							<!-- <select id="organization" onchange="onchangeOrganization(this)" style="width: 98%;" >
								
							</select> -->
						</div>
						<div class="box-body" style="height: 670px; overflow: auto;">
							
							<table id="treetable" style="width:100%;" class="sortable">
		                        <tbody></tbody>
		                    </table>
		                    <div class="liAlert" ontouchstart='alertClick(this)'>
		                    	<ul class="liMove">
		                    		<!-- <li>新增同级部门</li>
		                    		<li>新增下级部门</li>
		                    		<li>新增岗位</li>
		                    		<li>编辑</li>
		                    		<li>上移</li>
		                    		<li>下移</li>
		                    		<li>撤销</li>
		                    		<li>恢复</li>
		                    		<li>删除</li> -->
		                    	</ul>
		                    </div>
						</div>
					</div>
				</section>
					<div class="col-xs-9 power">
						<div class="box box-primary box-solid post">
							<div class="box-header" align="center"  style="text-align: center;font-weight: bolder;font-size: 1em;margin: auto;position: relative;">
							<div style="float: right;position: absolute;margin: auto;right: -6px;top: -5px;">
								 <!-- <input type="checkbox" name="my-checkbox" checked style="float:right;"> -->
								 <input type="checkbox" class="jtoggler">
							</div>
								 <h3 class="box-title replace_title">部门描述</h3>
							</div>
							<input type="hidden" id="jobsId" name="jobsId"/>
							<div class="box-body" style="height: 140px;">
								<input type="hidden" id="responsibilityId"/>
								<input type="hidden" id="deptId"/>
								<input type="hidden" id="titleOrContent"/>
								<textarea id="content" name="content"></textarea>
							</div>
						</div>
						<div id="qxdy1" class="box box-primary box-solid define" style="height: 500px; overflow: auto;">
							<div class="box-header" align="center">
								 <h3 class="box-title">权限定义</h3>
							</div>
									<div class="box box-primary box-solid define" id="qxdy">
											<table id="treetable_qxdy" style="width:100%;">
												<thead>
													<tr>
														<th style="width:30%;">菜单名</th>
														<th>权限标识</th>
														<th>数据权限</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
									</div>
						</div>
					</div>
					
			    </div>

			  <div align="center">
				 <!--  <button id="showAll" onclick="showAll(this)" class="btn btn-primary" data-flag = '0'>显示全部</button> -->
				  <!-- <button id="edit"  class="btn btn-primary">编辑</button> -->
				  <!-- <button id="saveJobsInfo" class="btn btn-primary" onclick="saveJobsInfo()">保存</button> -->
				   <button id="saveResponsibility" class="btn btn-primary" onclick="saveResponsibility()">保存</button>
			  </div>
		  
	</section>
</div>

<!-- 新增、编辑 -->
<div class="modal fade" id="institutionInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
      <div class="modal-dialog">
          <div class="modal-content" style="height: 80%;">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <span id="addName"></span>
              </div>
              <div class="modal-body"  style="text-align:center;">
                  <form id="form">
                  <input type="hidden" id="dept_id"/>
                  <input type="hidden" id="dept_parent_id"/>
                  <input type="hidden" id="dept_status"/>
                   <input type="hidden" id="id"/>
                   <input type="hidden" id="operation"/>
	                  <table style="margin:auto" frame=void>
	                  <tr id="belongsDept_tr">
	                  		<td style="border: 0px solid;"><span>所属部门</span>：</td>
	                  		<td style="border: 0px solid;"><span id="belongsDept"></span></td>
	                  	</tr>
	                  	<tr>
	                  		<td style="border: 0px solid;"><span id="deptOrPositionName"></span>：</td>
	                  		<td style="border: 0px solid;"><input id="deptName" name="deptName" /></td>
	                  	</tr>
	                  	<tr id="eDeptName_tr">
	                  		<td style="border: 0px solid;"><span>英文名称</span>：</td>
	                  		<td style="border: 0px solid;"><input id="eDeptName" name="eDeptName" /></td>
	                  	</tr>
	                  	<!-- <tr id="generateKpi_tr">
	                  		<td style="border: 0px solid;"><span>是否生成绩效考核：</span></td>
	                  		<td style="border: 0px solid;"><input type="radio" name="generateKpi" value="1" checked="checked">是
							<input type="radio" name="generateKpi" value="0">否</td>
	                  	</tr> -->
	                  </table>
                  </form>
              </div>
              <div class="modal-footer">
               <button id="save" type="button" class="btn btn-default"  onclick="dept_save()">保存</button>
                  <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
              </div>
          </div>
      </div>
</div>
 <!--部门模态框 -->
        <div class="modal fade" id="deptModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" style="padding-top: 100px">
            <div class="modal-dialog" style="width:80%">
                <div class="modal-content" style="height: 85%;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="myModalLabel4" style="text-align:center;">部门基本信息</h4>
                    </div>
                    <div class="modal-body">
                        <form id="form4">
                            <table style="margin:auto;width:80%;text-align:center;">
                                <thead>
                                <tr>
                                    <th colspan="4" style="text-align: center;" ><span id="ognInfoName2"></span></th>
                                </tr>
                                </thead>

                                <tbody>
                                <tr>
                                    <th><p>部门名称</p></th>
                                    <input type="hidden" id="deptId1" name="id" />
                                    <input type="hidden" id="parentId" name="parentId" />
                                    <input type="hidden" id="sign" name="sign" />
                                    <td><input id="name" name="name" type="text" ></td>
                                </tr>
                                <tr>
                                    <th><p>部门负责人</p></th>
                                    <td><input id="deptPerson" name="deptPerson" type="text" ></td>
                                </tr>
                                <tr>
                                    <th><p>联系电话</p></th>
                                    <td><input id="deptPhone" name="deptPhone" type="text" ></td>
                                </tr>
                                <tr>
                                    <th><p>办公地址</p></th>
                                    <td><input id="deptAddress" name="deptAddress" type="text" ></td>
                                </tr>
                                <tr>
                                    <th><p>成立日期</p></th>
                                    <td><input id="createDate" name="createDate" size="18" class="createDate" value="" style="width:100%;border:0; text-align: center;" autocomplete='off' readonly></td>
                                </tr>
                                <tr>
                                    <th><p>撤销日期</p></th>
                                    <td><input id="deptRevokeDate" name="deptRevokeDate" size="18" class="deptRevokeDate" value="" style="width:100%;border:0; text-align: center;" autocomplete='off' readonly></td>
                                </tr>
                                <tr>
                                    <th><p>部门职责&nbsp;</p></th>
                                    <td style="overflow: hidden;">
                                        <textarea class="form-control"  id="content1" name="content" rows="5" ></textarea>
                                    </td>
                                </tr>
                                </tbody>

                            </table>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button id="saveDeptData" type="button" class="btn btn-default" onclick="saveDeptData()">保存</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
                    </div>
                </div>
            </div>
        </div>
<!-- 权限继承 窗口 -->
<div class="modal fade" id="permissionsInheritance" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
      <div class="modal-dialog">
          <div class="modal-content" style="height: 80%;">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <span>权限继承</span>
              </div>
              <div class="modal-body"  style="text-align:center;">
                   <input type="hidden" id="permissions_id"/>
	                  <table style="margin:auto;" frame=void>
	                  <tr id="belongsDept_tr">
	                  		<td style="border: 0px solid;"><span>父角色</span>：</td>
	                  		<td style="border: 0px solid;"><select id="permissions_select" style="text-align:center;text-align-last:center;padding-left:6px; margin:-0.6rem 0;"></select></td>
	                  	</tr>
	                  	<tr>
	                  		<td style="border: 0px solid;"><span>继承角色</span>：</td>
	                  		<td style="border: 0px solid;"><span id="p_permissions"></span></td>
	                  	</tr>
	                  </table>
              </div>
              <div class="modal-footer">
               <button id="save" type="button" class="btn btn-default"  onclick="permissions_save()">保存</button>
                  <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
              </div>
          </div>
      </div>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="authorityModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">数据授权</h4>
         </div>
         <div class="modal-body">
         	<div class="box box-primary box-solid">
				<div class="box-header with-border" style="padding: 0px;">
	    			<h3 class="box-title" style="font-size:0.9em; padding: 0.3em 1em 0.1em; line-height: 1.9;">数据权限</h3>
	    			<input type="hidden" id="menuId" value="">
		    	</div>
				<div class="box-body" style="min-height: 600px;">
					<div id="dept_div" class="col-md-6">
						<ul id="deptTree" class="ztree"></ul>
					</div>
				</div>
		 	</div>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-primary"data-dismiss="modal" onclick="setDataPermission()">确认</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->
</div> 
<%@ include file="../common/footer.jsp"%>
<script>
		
    Date.prototype.pattern=function(fmt) {         
        var o = {         
        "M+" : this.getMonth()+1, //月份         
        "d+" : this.getDate(), //日         
        "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时         
        "H+" : this.getHours(), //小时         
        "m+" : this.getMinutes(), //分         
        "s+" : this.getSeconds(), //秒         
        "q+" : Math.floor((this.getMonth()+3)/3), //季度         
        "S" : this.getMilliseconds() //毫秒         
        };         
        var week = {         
        "0" : "/u65e5",         
        "1" : "/u4e00",         
        "2" : "/u4e8c",         
        "3" : "/u4e09",         
        "4" : "/u56db",         
        "5" : "/u4e94",         
        "6" : "/u516d"        
        };         
        if(/(y+)/.test(fmt)){         
            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));         
        }         
        if(/(E+)/.test(fmt)){         
            fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);         
        }         
        for(var k in o){         
            if(new RegExp("("+ k +")").test(fmt)){         
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));         
            }         
        }         
        return fmt;         
    } 
    base = "<%=base%>";
</script>
     <script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
	 <script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap-switch.js"></script>
     <script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
     <script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

	 <script type="text/javascript" src="<%=base%>/static/jtoggler/jtoggler.js"></script>
     <script type="text/javascript" src="<%=base%>/views/manage/institution/js/list.js"></script>
     <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
     <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>
     <script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui.min.js"></script>
     <script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
     <script type="text/javascript" src="<%=base%>/static/jquery/picker/flatpickr.js"></script>
	 <script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	 <script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
</body>
</html>