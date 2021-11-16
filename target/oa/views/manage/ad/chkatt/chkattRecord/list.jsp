<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}
body, #myTabContent, #leave{
	height: 80%;
}
table {
	border: 1px solid #ddd;
}
table tr,td {
	 border: 1px solid #ddd;
	 text-align: center;
}

</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">考勤管理</li>
		<li class="active">考勤记录</li>
	</ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
   <li class="active"><a href="#commute" data-toggle="tab">上班统计</a></li>
   <li><a href="#leave" data-toggle="tab">请假考勤</a></li>
</ul>
<div id="myTabContent" class="tab-content">
	<div class="tab-pane fade in active" id="commute">
		<div class="input-group" style="width: 99%;margin-left: 13px">
			<span  title="导出Excel" style="width: 2%" class="input-group-addon btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel2()" ></span>
			<span  title="导入考勤数据" style="width: 2%;float: right;" class="input-group-addon btn btn-primary  fa fa-x fa-cloud-upload" onclick="importBtn()" ></span>
		</div>
		<table style="width: 100%;">
			<tr>
				<td colspan="32" style="text-align: center;font-weight: bold;font-size: 16px" id="fristTd">睿哲科技股份有限公司XXXX年X月考勤统计</td>
			</tr>
			<tr>
				<td colspan="7" style="font-weight: bold;" id="secondTd">考勤统计时段：XXXX至XXXX</td>
				<td colspan="14"></td>
				<td colspan="11" style="font-weight: bold;" id="thirdTd">满勤天数：</td>
			</tr>
			<tr style="font-weight: bold;">
				<td rowspan="2" style="width: 4%">
					序号
				</td>
				<td rowspan="2" style="width: 4%">
					部门
				</td>
				<td rowspan="2" style="width: 4%">
					姓名
				</td>
				<td rowspan="2" style="width: 6%">
					入职时间
				</td>
				<td  colspan="2" style="width: 5%">
					迟到/早退
				</td>
				<td rowspan="2" style="width: 3%">
					未打卡次数
				</td>
				<td rowspan="2" style="width: 2%">
					旷工天数
				</td>
				<td rowspan="2" style="width: 2%">
					国家假日
				</td>
				<td rowspan="2" style="width: 3.8%">
					实际出勤天数
				</td>
				<td rowspan="2" style="width: 2%">
					记薪天数
				</td>
				<td colspan="4">
					加班、补休（小时）
				</td>
				<td rowspan="2" style="width: 2.9%">
					本月已休年假
				</td>
				<td rowspan="2" style="width: 2%" id="lastYear">
					
				</td>
				<td rowspan="2" style="width: 2%" id="thisYear">
					
				</td>
				<td rowspan="2" style="width: 3%" id="shouldYearLeave">
					
				</td>
				<td rowspan="2" style="width: 3%" id="alreadyYearLeave">
					
				</td>
				<td rowspan="2" style="width: 3%" id="residueYearLeave">
					
				</td>
				<td rowspan="2" style="width: 2%">
					事假天数
				</td><td rowspan="2" style="width: 2%">
					病假天数
				</td>
				<td rowspan="2" style="width: 2%">
					婚假天数
				</td><td rowspan="2" style="width: 2%">
					产假天数
				</td><td rowspan="2" style="width: 2%">
					陪产假天数
				</td>
				<td rowspan="2" style="width: 2%">
					丧假天数
				</td><td rowspan="2" style="width: 2%">
					出差天数
				</td>
<!-- 				<td rowspan="2" style="width: 2%"> -->
<!-- 					派驻天数 -->
<!-- 				</td> -->
				<td rowspan="2" style="width:2%"> 
					试用天数
				</td>
				<td rowspan="2" style="width: 2%">
					转正天数
				</td><td rowspan="2" style="width: 2%">
					实习天数
				</td>
				</td><td rowspan="2" style="width: 3%">
					备注
				</td>
			</tr>
			<tr  style="font-weight: bold;">
				<td >次数</td>
				<td>分钟</td>
				<td style="width: 2%">本月加班</td>
				<td style="width: 2%">本月补休</td>
				<td style="width: 3.8%">上月剩余加班</td>
				<td style="width: 3.8%">累计剩余加班</td>
			</tr>
			<tbody id="outWork">
				
			</tbody>
		
		</table>
   	</div>
   	<div class="tab-pane fade" id="leave">
   		<iframe id="leave_iframe" name="leave_iframe" width="100%" height="100%" frameborder="no" scrolling="yes" src="<%=base%>/views/manage/ad/chkatt/chkattRecord/leaveCharts.jsp"></iframe>
   	</div>
   	<!-- 导入模态框 -->
	<div class="modal fade" id="importModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
           <div class="modal-dialog" style="width: 85%;">
               <div class="modal-content" style="height: 85%;">
                   <div class="modal-header">
                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                       <h4 class="modal-title" id="myModalLabel" style="text-align:center;">导入考勤记录</h4>
                   </div>
                  <div class="modal-body">
                   	 <form id="form2" method="post" enctype="multipart/form-data" >
						 <table style="width: 100%;">
						 	<tr>
						        <td>
						       	<span>请选择文件：</span><input id="file" type="file" name="file">
						        </td>
						    </tr>
						 </table>
					</form> 
     			  </div>
                   <div class="modal-footer">
                   		<button id="btnOK" type="button" class="btn btn-default" onclick="importExcel()">导入</button>
                       <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                   </div>
               </div>
           </div>
     </div>
<iframe id="excelDownload" style="display:none;"></iframe>
</div>
<script type="text/javascript">
	var session="<%=session.getAttribute("attendance")%>"; 
	var ctx="<%=base%>";
</script>
<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/chkattRecord/js/list.js"></script>
</body>
</html>