<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="../../common/header.jsp"%>
    <meta charset="UTF-8">
    <script type="text/javascript" src="<%=base%>/static/ueditor/utf8-jsp/ueditor.config.js"></script>
	<script type="text/javascript" src="<%=base%>/static/ueditor/utf8-jsp/ueditor.all.js"></script>
<style type="text/css">
	html,body {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
            }/*这里是关键*/
     ul li{ list-style-type:none;
     }
</style>
</head>
<body>
<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
<!-- 引入header文件 -->
<%@ include file="postHeader.jsp"%>
<div style="width: 70%;margin:1% 2% 5% 1%;float: left;">
<div class="panel panel-default" id="main" style="">
    <div class="panel-heading" style="background-color: white">
        <div class="panel-heading" style="background-color: white">
           	主题
        </div>
        <h3>${post.title}</h3><br/>
        <div>
            <a href="${pageContext.request.contextPath }/member/${post.user.name}"><span ><strong>${post.user.name}</strong></span></a>&nbsp;&nbsp;
            <small class="text-muted"><fmt:formatDate value="${post.applyTime}" pattern="yyyy-MM-dd hh:mm:ss" /></small>&nbsp;&nbsp;
            <small class="text-muted">${post.replyCount}个回复</small>
            <a style="margin-left:5%" href="javascript:addReply(${post.id})">回复</a>
        </div>
    </div>

    <ul class="list-group" style="width: 100%;">
            <li class="list-group-item">
                ${post.content}
            </li>
    </ul>
</div>

<c:if test="${!empty post.replies}">
<div class="panel panel-default" id="main1" style="">
    <div class="panel-heading" style="background-color: white">
        <span>
                ${post.replyCount} 回复  |  直到 
                <fmt:formatDate value="${post.lastReplyTime }" pattern="yyyy-MM-dd hh:mm:ss" />
    </span>
   	<div style="float: right;"> <a href="javascript:showReply(${post.id })" style="margin-right: 0px">查看回复</a></div>
    </div>
	<div style="height: 100%;width: 100%">
    <ul class="list-group" id="replyUl" style="width: 100%;" >
    </ul>
    </div>
</div>
</c:if>
</div>


<div class="panel panel-default" id="sidebar2" style="width: 20%;margin:1% 2% 1% 0%;float: right">
        <div class="panel-heading" style="background-color: white;text-align: center">
           
        </div>
        <ul class="list-group" style="width: 100%">
            <li class="list-group-item"><a href="${pageContext.request.contextPath }/manage/office/review/new">创作新主题</a></li>
            <li class="list-group-item"><a href="">0条未读提醒</a></li>
            <li class="list-group-item"><a href="">积分:</a></li>
        </ul>
    </div>
<%@ include file="../../common/footer.jsp"%>
<!-- 引入侧边栏文件 -->
<%-- <%@ include file="side.jsp"%> --%>
			</div>
		</div>
	</section>
	
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">添加一条新回复</h4>
            </div>
            <div class="modal-body" style="z-index: 4">
            	 <form action="" method="post" id="replyForm" >
               		 <input type="hidden" name="postId" value="">
               		 <input type="hidden" name="userId" value="${sessionScope.user.id}">
                 	 <script id="container" name="content" type="text/plain" ></script>
            	</form>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="submitReply()">保存</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
 </div>
 <!-- 模态框（Modal） -->
<div class="modal fade" id="myModal1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel1">添加一条新回复</h4>
            </div>
            <div class="modal-body">
            	  <form action="" method="post" id="inReplyForm">
                	<input type="hidden" name="replyId" value="">
                 	<input type="hidden" name="userId" value="${sessionScope.user.id}">
                 	<input type="hidden" name="ruserId" value="">
                 	<script id="container1" name="content" type="text/plain"></script>
            	</form>
            </form>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="submitInReply()">保存</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->   
</div>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript">
	base = "<%=base%>";
	var ue = UE.getEditor('container');
	var ue1 = UE.getEditor('container1');
</script>
<script type="text/javascript" src="<%=base%>/views/manage/office/post/js/detail.js"></script>
</body>
</html>