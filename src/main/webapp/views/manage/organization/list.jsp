<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
    <!DOCTYPE html>
    <html>

    <head>
        <%@ include file="../common/header.jsp"%>
            <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
            <link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
            <link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
            <link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
            <link rel="stylesheet" href="<%=base%>/static/css/jquery.orgchart.css">
            <link rel="stylesheet" href="<%=base%>/static/bootstrap/css/bootstrap-switch.css">
            <link rel="stylesheet" href="<%=base%>/static/jtoggler/jtoggler.styles.css">
            <style>
                /*竖向文字  思路 给竖向的加上class hNode */
                .orgchart .hNode .title .symbol{
                    display:none;
                    float: left;
                    margin-left:0;
                    margin-top:0;
                    width:100%;
                    text-align: center;
                    height:20px;
                }
                .orgchart .hNode{
                    width:50px;
                    padding:0;
                    margin:0 10px;
                }

                .orgchart .hNode .title{
                    font-size: 15px;
                    padding:0 15px;
                    /*font-weight: 700;*/
                    height: 230px;
                    line-height: 18px;
                    /*writing-mode:vertical-lr;*/
                    overflow: hidden;
                    text-overflow: inherit;
                    white-space: normal;
                    color: #fff;
                    width: 100%;
                    word-break: break-word;/*强制换行*/
                    word-break: break-all;
                    padding-top: 10px;
                }
            	.modal-body #form thead th{border-color: #3c8dbc;}
            	.modal-body #form tbody {width:100%;border-left:1px solid #CCCCCC;}
            	.modal-body #form tbody tr {width:50% ;height:30px;float: left;line-height: 25px;border-bottom:1px solid #CCCCCC;border-right:1px solid #CCCCCC;}
            	.modal-body #form tbody tr th{display: flex;justify-content: center;align-items: center;width:30%;float: left;border:0;border-right:1px solid #CCCCCC;}
            	.modal-body #form tbody tr th p{display: block;font-weight: 400;margin:0px;text-align: center;line-height:30px;}
            	.modal-body #form tbody tr td{display: flex !important;justify-content: center;align-items: center;width:70%;display: block;float: left;border:0;}
            	.modal-body #form tbody tr td select{width:100%;text-align-last: center;text-align: center;width:100%;line-height:25px;}
            	.modal-body #form tbody tr td input{width:100%;border: none;text-align:center;line-height: 25px;}
            	.modal-body #form tbody tr:last-child{width:100% !important;min-height: 100px;height:100px;}
				.modal-body #form tbody tr:last-child th{width:14.9%; border-right: 0;vertical-align: middle;height:100px;height:100px;}
				.modal-body #form tbody tr:last-child td{width:85%; border-left:1px solid #CCCCCC;height:100px;}
				.modal-body #form tbody tr textarea{background: none; width:100%;border:0;min-height: 30px !important;}
				.modal-body #form tbody tr #jyfw{min-height: 100px;}
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
               .modal-body #formPtyh thead th{border-color: #3c8dbc;}
               .modal-body #formPtyh tbody {width:100%;border-left:1px solid #CCCCCC;}
               .modal-body #formPtyh tbody tr {width:50% ;height:30px;float: left;line-height: 25px;border-bottom:1px solid #CCCCCC;border-right:1px solid #CCCCCC;}
               .modal-body #formPtyh tbody tr th{display: flex;justify-content: center;align-items: center;width:30%;float: left;border:0;border-right:1px solid #CCCCCC;}
               .modal-body #formPtyh tbody tr th p{display: block;font-weight: 400;margin:0px;text-align: center;line-height:30px;}
               .modal-body #formPtyh tbody tr td{display: flex !important;justify-content: center;align-items: center;width:70%;display: block;float: left;border:0;}
               .modal-body #formPtyh tbody tr td select{width:100%;text-align-last: center;text-align: center;line-height:25px;}
               .modal-body #formPtyh tbody tr td input{width:100%;border: none;text-align:center;line-height: 25px;}
               .modal-body #formPtyh tbody tr:last-child{width:100% !important;min-height: 100px;height:100px;}
               .modal-body #formPtyh tbody tr:last-child th{width:14.9%; border-right: 0;vertical-align: middle;height:100px;}
               .modal-body #formPtyh tbody tr:last-child td{width:85%; border-left:1px solid #CCCCCC;height:100px;}
               .modal-body #formPtyh tbody tr textarea{background: none; width:100%;border:0;min-height: 30px !important;}
               .modal-body #formPtyh tbody tr #jyfw{min-height: 100px;}
                 #table2 td,th{border: 1px solid;}
               .liAlert, .InfoModal{position: absolute;width: 150px;display:none;}
               .InfoModal{z-index:-100;display:block;}
               .liMove{line-height:26px;background:#fff;width:100%;margin:auto;padding:5px 0px;border-radius: 3px;border:1px solid #eee;-moz-box-shadow:0px 0px 10px #333; -webkit-box-shadow:0px 0px 10px #333; box-shadow:0px 0px 10px #333;}
               .liMove li{list-style: none;text-align: center;font-size:16px;}
                #ognInfoModal,#deptModal{padding-left: 0px !important;}
                #myTabContent{width:100%;overflow: hidden; margin: .6em 0 1.8em 0}
                #myTab>li.active a {background-color: #3c8dbc;color: white;font-weight: bold;}
            </style>
            <style type="text/css">
                .orgchart { background: white;
                            width: 100%;
                            height: 100%;
                }
                #chart-container{
                    position: relative;
                    display: inline-block;
                    top: -22px;
                    left: 10px;
                    height: 100%;
                    width: calc(100% - 24px);
                    border: 2px dashed #aaa;
                    border-radius: 5px;
                    overflow: auto;
                    text-align: center;
                }
            </style>
    </head>
<script type="text/javascript">
var zzgxedit='<shiro:hasPermission name="zzgx:edit">true</shiro:hasPermission>';
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
            <li class="active"><a href="<%=base%>/manage/organization/toList" >组织关系</a></li>
			<li><a href="<%=base%>/manage/institution/toList" >机构设置</a></li>
           <%-- <li><a href="<%=base%>/manage/addressbook/toList" >通讯录</a></li>--%>
        </ul>
        <%--<div id="myTabContent" class="tab-content" style="margin:0;padding:10px 13px;">
            <div class="tab-pane fade in active" id="list">
                <!-- 移动端弹窗 -->
                <div class="liAlert"><ul class="liMove"></ul></div>
            </div>
        </div>--%>
        <div style="width: 99%">
            <div style="float: right;padding-top: 5px;">
            <!-- <input id="my-checkbox" type="checkbox" checked name="my-checkbox"> -->
            <input type="checkbox" class="jtoggler">
            </div>
        </div>
        <div id="div" style="float: right;" >
        </div>
        <div id="chart-container"></div>
         <!-- /.modal -->
         <!-- 公司基本信息模态框 -->
	<div class="modal fade" id="ognInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" style="padding-top: 100px">
           <div class="modal-dialog" style="width:80%;">
               <div class="modal-content" style="height: 85%;">
                   <div class="modal-header">
                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                       <h4 class="modal-title" id="myModalLabel" style="text-align:center;">公司基本信息</h4>
                   </div>
                   <div class="modal-body">
                       <form id="form">
                           <table style="margin:auto;width:80%;text-align:center;">
                               <thead>
                                   <tr>
                                       <th colspan="4" style="text-align: center;" ><span id="ognInfoName"></span></th>
                                   </tr>
                               </thead>
                               
                               <tbody>
                               		<tr>
                               			<th><p>公司名称</p></th>
                               			<input type="hidden" id="id" name="id" />
                               			<td><input id="gsmc" name="gsmc" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>社会信用代码</p></th>
                               			<td><input id="shxydm" name="shxydm" type="text"  ></td>
                               		</tr>
                               		<tr>
                               			<th><p>成立日期</p></th>
                                       	<td><input id="clrq" name="clrq" type="text" readonly></td>
                               		</tr>
                               		<tr>
                               			<th><p>注册资本(万元)</p></th>
                               			<td><input id="zczb" name="zczb" type="text"></td>
                               		</tr>
                               		<tr>  
                               			<th><p>法人代表</p></th>
                               			<td><input id="frdb" name="frdb" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>董事长/执行董事</p></th>
                               			<td><input id="dszzxds" name="dszzxds" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>总经理</p></th>
                               			<td><input id="zjl" name="zjl" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>财务总监</p></th>
                               			<td><input id="cwzj" name="cwzj" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>监事会主席/监事</p></th>
                               			<td><input id="jshzxjs" name="jshzxjs" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>公司网站</p></th>
                               			<td><input id="gswz" name="gswz" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>联系电话</p></th>
                               			<td><input id="lxdh" name="lxdh" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>公司地址</p></th>
                               			<td>
	                               			<input id="gsdz" name="gsdz" type="text" title="">
	                               			<textarea style="display:none;" class="gsdz form-control" name="textjyfw" rows="1"></textarea>
                               			</td>
                               			
                               		</tr>
                               		<tr>
                               			<th><p>公司账号</p></th>
                               			<td><input id="gszh" name="gszh" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>账户名称</p></th>
                               			<td><input id="zhmc" name="zhmc" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>开户银行</p></th>
                               			<td><input id="khyh" name="khyh" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>开户行地址</p></th>
                               			<td>
                               				<input id="khhdz" name="khhdz" type="text" title="">
                               				<textarea style="display:none;" class="khhdz form-control" name="textjyfw" rows="1"></textarea>
                               			</td>
                               			
                               		</tr>
                               		<tr style="display: none">
                               			<th><p>上级单位</p></th>
                               			<td><select id="sjdw" name="sjdw" onchange="getSelect(this)"></select></td>
                               		</tr>
                               		<tr style="display: none">
                               			<th><p>上级持股比例(%)</p></th>
                               			<td><input id="sjcgbl" name="sjcgbl" type="text"></td>
                               		</tr>
                               		<tr>
                               			<th><p>注销日期</p></th>
                               			<td><input id="zxrq" name="zxrq" type="text" readonly></td>
                               		</tr>
                               		<tr>
                               			<th><p>售出日期</p></th>
                               			<td><input id="scrq" name="scrq" type="text" readonly></td>
                               		</tr>
                               		<tr>
                               			<th><p>经营范围&nbsp;</p></th>
                               			<td style="overflow: hidden;">
                               				<textarea class="form-control"  id="jyfw" name="jyfw" rows="5"></textarea>
                               			</td>
                               		</tr>
                               </tbody>

                           </table>
                       </form>
                   </div>
                   <div class="modal-footer">
                   <shiro:hasPermission name="zzgx:edit">
	                   <button id="save" type="button" class="btn btn-default" onclick="saveBaseInfo()">保存</button>
	                   <button id="change" type="button" class="btn btn-default"  onclick="change()">变更</button>
	               </shiro:hasPermission>
	                   <!-- <button id="export" type="button" class="btn btn-default"  onclick="exportInfo()">导出</button> -->
	                     <button id="export" type="button" class="btn btn-default"  onclick="exportInfo1()">导出</button>
                       <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
                   </div>
               </div>
           </div>
     </div>
     
     <!-- 普通用户 -->
     <div class="modal fade" id="ognInfoModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" style="padding-top: 100px">
           <div class="modal-dialog" style="width: 80%">
               <div class="modal-content" style="height: 50%;">
                   <div class="modal-header">
                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                       <h4 class="modal-title" id="myModalLabel2" style="text-align:center;">公司基本信息</h4>
                   </div>
                   <div class="modal-body">
                       <form id="formPtyh">
                       <input type="hidden" id="changeId2" name="changeId2"/> 
                           <table  style="margin:auto;width:80%;text-align:center;">
                               <thead>
                                   <tr>
                                       <th colspan="4" style="text-align: center;" ><span id="ognInfoName"></span></th>
                                   </tr>
                               </thead>
                               <tbody>
                                   <tr>
                                       <th>
                                           <p>公司名称&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsmc2" name="gsmc2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                   		<th>
                                           <p>社会信用代码&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="shxydm2" name="shxydm2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                   	   <th>
                                           <p>联系电话&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="lxdh2" name="lxdh2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                       <th>
                                           <p>公司地址&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsdz2" name="gsdz2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                       <th>
                                           <p>公司账号&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gszh2" name="gszh2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                   		<th>
                                           <p>账户名称&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zhmc2" name="zhmc2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                       <th>
                                           <p>开户银行&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khyh2" name="khyh2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                   		<th>
                                           <p>开户行地址&nbsp;</p>
                                       </th>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khhdz2" name="khhdz2" type="text">
                                       </td>
                                   </tr>
                                   <tr>
                                       <th><p>经营范围&nbsp;</p></th>
                                       <td style="overflow: hidden;">
                                           <textarea class="form-control"  id="jyfw2" name="jyfw2" rows="5" style="width:100%;margin-top:0px;"></textarea>
                                       </td>
                                   </tr>
                               </tbody>
                           </table>
                       </form>
                   </div>
                   <div class="modal-footer">
	                   <button id="export2" type="button" class="btn btn-default"  onclick="exportInfo2()">导出</button>
                       <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
                   </div>
               </div>
           </div>
     </div>
         
    <!-- 公司变更信息模态框 -->
	<div class="modal fade" id="ognChangeInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" style="padding-top: 100px">
           <div class="modal-dialog" style="width: 80%;">
               <div class="modal-content" style="height: 80%;">
                   <div class="modal-header">
                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="onModalLabel()">&times;</button>
                       <h4 class="modal-title" id="myModalLabel" style="text-align:center;">公司变更信息</h4>
                   </div>
                   <div class="modal-body">
                   	 <form id="form2">
                   	 <input type="hidden" id="changeId" name="changeId"/>
                   	 <input type="hidden" id="changeInfoList" name="changeInfoList"/>
                   	 <select id="changeQ_hidden" style="display: none;"></select>
                   	 <select id="changeH_hidden" style="display: none;"></select>
                   	 <div class="table2Div" style="overflow-y:auto;height:430px;position:relative;">
                   	 	<!-- 移动端弹窗 -->
                		<div class="InfoModal"><ul class="liMove"></ul></div>
                        <table id="table2" style="margin:auto;width:80%;text-align:center;position: relative;top:0px;">
                           	<thead>
                            	<tr>
                                	<th colspan="4" style="text-align: center;"><span id="ognChangeInfoName"></span></th>
                           		</tr>
                            </thead>
                            <tbody id="tbodyInfo">
                            	<tr>
                            		<td><p>公司名称&nbsp;</p></td>
                                	<td colspan="3">
                                          <input style="width:100%;border: none;text-align:center;" id="changeGSMC" name="changeGSMC" type="text">
                                	</td>
                                  </tr>
                                  <tr>
                                      <td>
                                          <p>社会信用代码&nbsp;</p>
                                      </td>
                                      <td colspan="3">
                                          <input style="width:100%;border: none;text-align:center;" id="changeSHXYDM" name="changeSHXYDM" type="text">
                                      </td>
                                  </tr>
                                  <tr>
                                  	   <td>
                                           <p>成立日期&nbsp;</p>
                                       </td>
                                       <td colspan="3">
                                           <input style="width:100%;border: none;text-align:center;" id="changeCLRQ" name="changeCLRQ" type="text">
                                       </td>
                                  </tr>
                                  <tr style="padding-top: -10px;">
	                                 <td style="width:25%"><p>变更日期</p></td>
                         	   		 <td style="width:25%"><p>变更项目</p></td>
                         	   		 <td style="width:25%"><p>变更前</p></td>
                         	   		 <td style="width:25%"><p>变更后</p></td>
	                              </tr>
                                  
                               </tbody>
                               <tbody id="tbodyInfoTr">
                               <%--
                               		<tr name="node" class="node">
                                  	<td style="display: none;">
				   	               		<input class="ocrId" name="uuid"  type="hidden">
				   	                </td>
				   	                <td>
				   	                	<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" name="changeBGRQ"  type="text"/>
				   	                </td>
					   	   			<td>
					   	   			    <select style="width: 98%;" class="changeXM" name="changeXM" onchange="getChange(this)">
					   	   			</select>
					   	   			</td>
					   	   			<td>					   	   			
					   	   				<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ"  type="text">
					   	   			</td>
					   	   			<td>
					   	   				<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH"  type="text">
					   	   		 	 </td>
	                              </tr>--%>
                               </tbody>
                           </table>
                          </div>
                     </form>
     			  </div>

                   <div class="modal-footer">
	                   <button id="saveChangeInfo" type="button" class="btn btn-default" data-dismiss="modal" onclick="saveChangeInfo()">保存</button>
                       <button type="button" class="btn btn-default" data-dismiss="modal" onclick="onModalLabel()">返回</button>
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
                                    <input type="hidden" id="deptId" name="id" />
                                    <input type="hidden" id="parentId" name="parentId" />
                                    <input type="hidden" id="sign" name="sign" />
                                    <td><input id="name" name="name" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>部门负责人</p></th>
                                    <td><input id="deptPerson" name="deptPerson" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>联系电话</p></th>
                                    <td><input id="deptPhone" name="deptPhone" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>办公地址</p></th>
                                    <td><input id="deptAddress" name="deptAddress" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>成立日期</p></th>
                                    <td><input id="createDate" name="createDate" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>撤销日期</p></th>
                                    <td><input id="deptRevokeDate" name="deptRevokeDate" type="text" readonly></td>
                                </tr>
                                <tr>
                                    <th><p>部门职责&nbsp;</p></th>
                                    <td style="overflow: hidden;">
                                        <textarea class="form-control"  id="content" name="content" rows="5" readonly></textarea>
                                    </td>
                                </tr>
                                </tbody>

                            </table>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <shiro:hasPermission name="zzgx:edit">
                            <button id="saveDeptData" type="button" class="btn btn-default" onclick="saveDeptData()">保存</button>
                            <button id="editDeptData" type="button" class="btn btn-default" onclick="editDeptData()">编辑</button>
                        </shiro:hasPermission>
                          <%--  <button id="changeDateData" type="button" class="btn btn-default"  onclick="changeDateData()">变更</button>--%>
                        <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
                    </div>
                </div>
            </div>
        </div>

        <!--部门或者子公司 -->
        <div class="modal fade" id="deptModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" style="padding-top: 100px">
            <div class="modal-dialog">
                <div class="modal-content" style="height: 80%;width: 30%;margin-left: 500px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="myModalLabel3" style="text-align:center;">新增选择</h4>
                    </div>
                    <div class="modal-body"  style="text-align:center;">
                       <button id="saveInfo2" type="button" class="btn btn-default"  onclick="showDeptOrCompany(1)">新增下级部门</button>
                       <button  id="saveInfo3" type="button" class="btn btn-default"  onclick="showDeptOrCompany(2)">新增子公司</button>
                    </div>
                </div>
            </div>
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
     <script type="text/javascript" src="<%=base%>/views/manage/organization/js/list.js"></script>  
     <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
	 <script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script> 
   <%--   <script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui.min.js"></script> --%>
     <script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="<%=base%>/static/js/jquery.orgchart.js"></script>
	<script>
		$(function(){
			$("#CompanyType").selectCompant();
			mobilePage()
		})
	</script>
</body>
</html>