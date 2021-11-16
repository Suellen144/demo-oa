<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/header.jsp"%>
</head>
<style>
	#myTab>li.active a {background-color: #3c8dbc;color: white;font-weight: bold;}
	#search-box {position: relative;width: 400px;margin: 0 auto;display: inline;}
	#wrapper {width: 50%;margin: 30px auto;}
	#message {font-size: 16px;text-align: center;}
	#search-form{width: 100%;}
	#message table {border: 1px solid; border-color: #000;border-collapse: collapse;width: 100%;border-top: 0;}
	#message table tr{border-bottom: 1px solid #000;width: 100%;line-height: 30px;}
	#message table tr th{width: 20%; border-right: 1px solid #333;text-align: center;}
	#message table tr td{width: 80%;}
	#btn{width: 100%;text-align: center;}
	#btn button{transition: all 0.2s ease-out 0s;margin: 20px;width: 100px;line-height: 30px;background: #fff;border: 1px solid #333;font-size: 16px;border-radius: 3px;cursor: pointer;}
	#btn button:hover{background: #ccc;}
	.autocomplete-container {position: relative;width: 100%;height: 30px;margin: 0 auto;}
	.autocomplete-input {padding-left: 15px;outline: none;border-radius: 3px;font-family: inherit;float: left;font-size: 1em;margin: 0;width: 80%;line-height: 30px;border:1px solid #333;=padding-left: 15px;}
	.autocomplete-button {font-family: inherit;border: none;border: 1px solid #333;background-color: #efefef;color: #000;width: 20%;line-height: 32px;text-align: center;float: left;cursor: pointer;border-radius: 0px 3px 0px 0px;transition: all 0.2s ease-out 0s;}
	.autocomplete-button:HOVER {background-color: #ccc;}
	.proposal-box {position: absolute;height: auto;border-left: 1px solid rgba(0, 0, 0, 0.11);border-right: 1px solid rgba(0, 0, 0, 0.11);left: 0px;width: 80%;}
	.proposal-list {list-style: none;box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.44);-webkit-margin-before: 0em;-webkit-margin-after: 0em;-webkit-margin-start: 0px;-webkit-margin-end: 0px;-webkit-padding-start: 0px;max-height: 215px;overflow: auto;}
	.proposal-list li {text-align: left;padding-left: 10px;font-family: inherit;border-bottom: 1px solid rgba(0, 0, 0, 0.16);line-height: 30px;background-color: #f9f9f9;cursor: pointer;}
	.proposal-list li.proposal.selected {background-color: #EFEFEF;color: #333;}
</style>
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
			<li><a href="<%=base%>/manage/institution/toList" >机构设置</a></li>
            <li class="active"><a href="<%=base%>/manage/addressbook/toList" >通讯录</a></li>
        </ul>
	<div class="wrapper">
		<div id="wrapper">
			<div id="search-form">
				<!-- <div class="autocomplete-container">
				<input type="text" autocomplete="off" name="query" spellcheck="false" placeholder="姓名/电话/邮箱" class="autocomplete-input" style="border-radius: 3px 0px 0px;">
				<div class="autocomplete-button" onclick="submit()">搜索</div>
				</div> -->
			</div>
			<div id="message">
			<table data-i='0'>
				<tr><th>公司</th><td id="gsName"></td></tr>
				<tr><th>部门</th><td id="deptName"></td></tr>
				<tr><th>项目组</th><td id="xmz"></td></tr>
				<tr><th>姓名</th><td id="name"></td></tr>
				<tr><th>岗位</th><td id="position"></td></tr>
				<tr><th>电话</th><td id="phone"></td></tr>
				<tr><th>邮箱</th><td id="email"></td></tr>
			</table>
			</div>
			<div id="btn">
				<button class="lastPage" data-i='-1'>上一页</button>
				<button class="nextPage" data-i='1'>下一页</button>
			</div>
		</div>
	</div>			

<%@ include file="../common/footer.jsp"%>
<script>
    base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/addressbook/js/addressBookList.js"></script>
</body>
<script>
	$(function(){
		mobilePage()
	})
</script>
</html>