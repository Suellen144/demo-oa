<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>

</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">模块加密管理</li>
		</ol>
	</header>
	
	
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<form id="form1" class="form-horizontal tbspace" action="getEncryptionKey" method="post">
					<div class="form-group">
						<div class="col-sm-4">
							<input type="file" id="encryptionKeyFile" name="encryptionKeyFile" accept="text/plain" style="display:none;">
							<input type="hidden" id="encryptionKeyPath" name="encryptionKeyPath" value="">
							<button type="button" class="btn btn-primary" onclick="changeKey()">更改密钥</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</section>	
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript">
$(function() {
	initFileUpload();
});

function changeKey() {
	$("#encryptionKeyFile").trigger("click");
}

function initFileUpload() {
	$('#encryptionKeyFile').fileupload({
		url: 'generateKey',
        dataType: 'json',
        maxFileSize: 200, // 200字节
        acceptFileTypes: /(txt)$/i,
        messages: {
        	maxFileSize: '文件大小最大为200字节！',
        	acceptFileTypes: '请导入txt文件类型的密钥！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		openBootstrapShade(true);
        		data.submit();
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		openBootstrapShade(false);
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
        	openBootstrapShade(false);
        	if( data.result.code != 1 ) {
        		bootstrapAlert("提示", data.result.result, 400, null);
        	} else {
        		bootstrapAlert("提示", "请不要覆盖同名密钥文件！", 400, null);
				$("#encryptionKeyPath").val(data.result.result);
       			$("#form1").submit();
        	}
        },
        error: function(e) {
        	openBootstrapShade(false);
			bootstrapAlert("提示", "更改密钥失败，请联系管理员！", 400, null);
        }
    });
}

</script>
</body>
</html>