<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
body {
	background: none !important;
}
#table1 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}


#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}

.td_left {
	text-align: left !important;
	white-space:pre-line;
}
.hidden{
	display: none;
}
</style>
</head>
<body>
<div class="wrapper">
	<!-- Main content -->
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class=" box-primary tbspace">
					<form id="formPtyh">
						<div class="modal-header">
		                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                       <h4 class="modal-title" id="myModalLabel" style="text-align:center;">${ogn.name }基本信息</h4>
		                   	</div>
                           <table id="table1" style="margin:auto;width:80%;text-align:center;">
                               <thead>
                                   <tr>
                                       <th colspan="4" style="text-align: center;" ><span id="ognInfoName"></span></th>
                                   </tr>
                               </thead>
                               <tbody>
                                   <tr>
                                       <td>
                                           <p>公司名称&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsmc2" name="gsmc2" type="text" value="${ogn.name }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                   		<td>
                                           <p>社会信用代码&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="shxydm2" name="shxydm2" type="text" value="${ogn.shxydm }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                   	   <td>
                                           <p>联系电话&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="lxdh2" name="lxdh2" type="text" value="${ogn.lxdh }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>公司地址&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsdz2" name="gsdz2" type="text" value="${ogn.gsdz }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>公司账号&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gszh2" name="gszh2" type="text" value="${ogn.gszh }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                   		<td>
                                           <p>账户名称&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zhmc2" name="zhmc2"  value="${ogn.zhmc }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>开户银行&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khyh2" name="khyh2"  value="${ogn.khyh }" readonly/>
                                       </td>
                                   </tr>
                                   <tr>
                                   		<td>
                                           <p>开户行地址&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khhdz2" name="khhdz2"  value="${ogn.khhdz }" readonly/>
                                       </td>
                                   </tr>
                               </tbody>
                           </table>
                       </form>
				</div>
			</div>
		</div>
</div>
<!-- 模态框（Modal） -->
<%@ include file="../common/footer.jsp"%>
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>

</body>
</html>