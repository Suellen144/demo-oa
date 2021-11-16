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

#table2 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table4 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table3 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table4 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table3 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table4 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}


#table4 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table3 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table2 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table3 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table4 td {
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
#table9 {
	width: 96%;
	margin: 0 auto;
	margin-top:20px;
	background-color: white;
}
#table9 td {
	font-weight: bold;
	font-size: 1em;
	
	width: 13%;
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
<!-- 				<input class="example1" type="button" value="导出图片"> -->
<!-- 				<a id="tuPian" href="">刷新</a> -->
					<form id="form1">
					 <table id="table1" style="margin:auto;width:80%;text-align:center;">
							 <div class="modal-header">
		                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                       <h4 class="modal-title" id="myModalLabel" style="text-align:center;">${ogn.name }基本信息</h4>
		                   	</div>
                               <thead>
                                   <tr>
                                       <th colspan="4" style="text-align: center;"><span id="ognInfoName"></span></th>
                                   </tr>
                               </thead>
                               <tbody>
                                   <tr>
                                       <td>
                                           <p>公司名称&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsmc" name="gsmc"  value="${ogn.name }" readonly>
                                       </td>
                                       <td>
                                           <p>社会信用代码&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="shxydm" name="shxydm" value="${ogn.shxydm }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>成立日期&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="clrq" name="clrq" value="${ogn.clrq }" readonly>
                                       </td>
                                       <td>
                                           <p>注册资本（万元）&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zczb" name="zczb" value="${ogn.zczb }" readonly >
                                       </td>
                                   </tr>
                                    <tr>		
                                       <td>
                                           <p>法人代表&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="frdb" name="frdb" value="${ogn.frdb }" readonly />
                                       </td>
                                       
                                       <td>
                                           <p>董事长/执行董事&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="dszzxds" name="dszzxds" value="${ogn.dszzxds }" readonly/>
                                       </td>
                                   </tr>
                                    <tr>
                                       <td>
                                           <p>总经理&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zjl" name="zjl" value="${ogn.zjl }" readonly/>
                                       </td>
                                       
                                       <td>
                                           <p>财务总监&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="cwzj" name="cwzj" value="${ogn.cwzj }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>监事会主席/监事&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="jshzxjs" name="jshzxjs" value="${ogn.jshzxjs }" readonly>
                                       </td>
                                       
                                       <td>
                                           <p>公司网站&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gswz" name="gswz" value="${ogn.gswz }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>联系电话&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="lxdh" name="lxdh" value="${ogn.lxdh }" readonly>
                                       </td>
                                       
                                       <td>
                                           <p>公司地址&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gsdz" name="gsdz" value="${ogn.gsdz }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>公司账号&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="gszh" name="gszh" value="${ogn.gszh }" readonly>
                                       </td>
                                       
                                       <td>
                                           <p>账户名称&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zhmc" name="zhmc" value="${ogn.zhmc }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>开户银行&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khyh" name="khyh" value="${ogn.khyh }" readonly>
                                       </td>
                                       
                                       <td>
                                           <p>开户行地址&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="khhdz" name="khhdz" value="${ogn.khhdz }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>上级单位&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="sjdw" name="sjdw" value="${ogn.sjdw }" readonly>
                                       </td>
                                       
                                       <td>
                                           <p>上级持股比例（%）&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="sjcgbl" name="sjcgbl" value="${ogn.sjcgbl }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>注销日期&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="zxrq" name="zxrq" value="${ogn.zxrq }" readonly >
                                       </td>
                                       
                                       <td>
                                           <p>售出日期&nbsp;</p>
                                       </td>
                                       <td>
                                           <input style="width:100%;border: none;text-align:center;" id="scrq" name="scrq" value="${ogn.scrq }" readonly>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <p>经营范围&nbsp;</p>
                                       </td>
                                       <td colspan="3">
                                           <textarea class="form-control" style="width:100%;border: none;" id="jyfw" name="jyfw"  rows="5" readonly>${ogn.jyfw }</textarea>
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
	$(document).ready( function(){
        $(".example1").on("click", function(event) {
                event.preventDefault();
                html2canvas($("#form1"), {
                allowTaint: true,
                taintTest: false,
                onrendered: function(canvas) {
                    canvas.id = "mycanvas";
                    //document.body.appendChild(canvas);
                    //生成base64图片数据
                    var dataUrl = canvas.toDataURL();

                    var newImg = document.createElement("img");
                    newImg.src =  dataUrl;
                    $("#form1").html("");
                    document.body.appendChild(newImg);
                }
            });
        }); 

});
	
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/static/html2canvas/html2canvas.min.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<%-- <script type="text/javascript" src="<%=base%>/views/manage/organization/js/pdf.js"></script> --%>
</body>
</html>