<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>睿哲办公系统</title>
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/css/m_oa/cssreset.css"/>
    <link rel="stylesheet" href="<%=base%>/static/css/m_oa/iconfont.css"/>
    <link rel="stylesheet" href="<%=base%>/static/js/dropload/dropload.css">
   	<link rel="stylesheet" type="text/css" href="<%=base%>/static/css/m_oa/m_footer.css"/>
    <script type="text/javascript" src="<%=base%>/static/js/rem.js" ></script>
    
    
	<style>
		body{max-width: 750px;background: #f5f5f5;}
		header{position: relative;background: url(<%=base%>/static/images/m_oa/index_bg01.png) center no-repeat;background-size: 100% 100%;height: 0.88rem;padding: 0 0.3rem;}
		header h1{color: #fefefe;font-size: 0.38rem;text-align: center;line-height: 0.88rem;}
		header a{position: absolute;left: 0.3rem;top: 0;line-height: 0.88rem;}
		header a span{font-size: 0.4rem !important;color: #fff;}
		#main{padding: 0.3rem;}
		#main ul{background: #fff;border-radius: 5px;}
		#main ul li{border-top: 1px solid #f5f5f5;}
		#main ul li:first-child{border: 0;}
		#main ul li a{padding: 0 0.5rem;font-size: 0.26rem;line-height: 0.8rem;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;color: #333;display: block;width: 100%;}	
	</style>
</head>
<body>
	<header>		
		<h1>通知</h1>
		<a href="javascript:return_prepage();"><span class="iconfont icon-left-line"></span></a>
	</header>
	<div id="main">	
		<ul>
			
		</ul>
	</div>
	
</body>
</html>

<script src="<%=base%>/static/js/jQuery-2.2.0.min.js"></script>
<script src="<%=base%>/static/js/dropload/dropload.min.js"></script>
<script>
	var base = '<%=base%>';
	function return_prepage(){
		if(window.document.referrer==""||window.document.referrer==window.location.href){
			window.location.href="{dede:type}[field:typelink /]{/dede:type}";
		}else{
			window.location.href=window.document.referrer;
		}

	}
	$(function(){
		// 页数
	    var page = 0;
	    // 每页展示10个
	    var size = 10;
		
		$('#main').dropload({
	        scrollArea : window,
	        loadDownFn : function(me){
	            page++;
	            // 拼接HTML
	            var result = '';
	            $.ajax({
	                type: 'POST',
	                url: base + "/manage/office/noitce/getNoticeList",
	                dataType: 'json',
	                contentType: "application/json",
	                data: JSON.stringify({
	        			"pageData": [{"name":"sEcho","value":page},{"name":"iDisplayStart","value":page},{"name":"iDisplayLength", "value":size}],
	        			"search": {"userName":"", "beginDate":"", "endDate":"", "isRead":"", "fuzzyContent":""},
	        			"orderColumns": {}
	        		}),
	                success: function(data){
	                	console.log(data)
	                    var arrLen = data.aaData.length;
	                    if(arrLen > 0){
	                    	$.each(data.aaData,function(i,val){
	                    		result +=   '<li><a href="javascript:void(0)">'+val.title+'</a></li>';
	                    	}) 
	                       
	                    // 如果没有数据
	                    }else{
	                        // 锁定
	                        me.lock();
	                        // 无数据
	                        me.noData();
	                    }
	                    // 为了测试，延迟1秒加载
	                    setTimeout(function(){
	                        // 插入数据到页面，放到最后面
	                        $('#main ul').append(result);
	                        // 每次数据插入，必须重置
	                        me.resetload();
	                    },1000);
	                },
	                error: function(xhr, type){
	                    alert('Ajax error!');
	                    // 即使加载出错，也得重置
	                    me.resetload();
	                }
	            });
	        }
	    });				
	})
	
</script>