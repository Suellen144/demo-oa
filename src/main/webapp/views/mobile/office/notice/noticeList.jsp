<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    
    <%@ include file="../../common/header.jsp"%>
	<style>
		
		body{max-width: 750px;background: #f5f5f5;}
		header{position: relative;background: #fff;padding: 0 0.3rem;}
		header h1{color: #333;font-size: 0.38rem;text-align: center;line-height: 0.88rem;font-weight: 600;}
		header a{position: absolute;left: 0.3rem;top: 0;line-height: 0.88rem;}
		header a span{font-size: 0.45rem !important;color: #333;font-weight: 600;}
		#main{padding: 0.3rem;}
		
		#main ul li{background: #fff;border-radius: 5px;margin-top: 0.2rem;position: relative;}
		#main ul li:first-child{margin-top: 0;}
		
		#main ul li a p,#main ul li a span{text-overflow: ellipsis;white-space: nowrap;overflow: hidden;display: block;width: 100%;}	
		#main ul li a span{color: #222;font-size: 0.3rem;line-height: 0.3rem;padding-top: 0.3rem;padding-bottom:0.2rem;}
		#main ul li a p{color: #999;font-size: 0.24rem;}
		#main ul li a{height: 1.8rem;position: relative;display: block;padding-left: 1.3rem;padding-right: 0.3rem;}
		#main ul li a.icon_A:before{content: '';display: block;background: #ffa800;width: 0.72rem;height: 0.72rem;border-radius:50%;position: absolute;top: 0;bottom: 0;margin: auto;left: 0.30rem;}
		#main ul li a.icon_A:after{content: '';display: block;background: url(<%=base%>/static/mobile/images/icon/icon_101.png);background-size: 100% 100%;width: 0.42rem;height: 0.42rem;position: absolute;top: 0;bottom: 0;left: 0.45rem;margin: auto;}
		
		#main ul li.acrive_A:before{content: '';display: block;width: 0.1rem;height: 0.1rem;background: #FF3442;border-radius: 50%;position: absolute;top:33%;left:0.88rem;z-index: 100;border: 1px solid #fff;}
		
		#main ul li a.icon_B:before{content: '';display: block;background: #488ff2;width: 0.72rem;height: 0.72rem;border-radius:50%;position: absolute;top: 0;bottom: 0;margin: auto;left: 0.30rem;}
		#main ul li a.icon_B:after{content: '';display: block;background: url(<%=base%>/static/mobile/images/icon/icon_100.png);background-size: 100% 100%;width: 0.42rem;height: 0.42rem;position: absolute;top: 0;bottom: 0;left: 0.44rem;margin: auto;}
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
<script src="<%=base%>/static/mobile/js/dropload/dropload.min.js"></script>
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
	    var ulWith = $('#main ul').width();
	   
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
	                    var arrLen = data.aaData.length;
	                    if(arrLen > 0){
	                    	
	                    	 $.each(data.aaData,function(i,val){
	                    		if(val.type == '2'){
	                    			if(val.isRead){
	                    				result +=   '<li class="acrive_A"><a href="javascript:void(0)" class="icon_A">'+
			                    		'<span>'+val.title+'</span>'+
			                    		/* '<p>'+val.content.replace(/<[^>]*>|\s|(&nbsp;)/g, "")+'</p></a></li>'; */
			                    		'<p>'+getRowStr(val.content.replace(/<[^>]*>|\s|(&nbsp;)/g, ""),ulWith)+'</p></a></li>';
	                    			}else{
	                    				result +=   '<li><a href="javascript:void(0)" class="icon_A">'+
			                    		'<span>'+val.title+'</span>'+
			                    		'<p>'+ getRowStr(val.content.replace(/<[^>]*>|\s|(&nbsp;)/g, ""),ulWith)+'</p></a></li>';
	                    			}
	                    		}else if(val.type == '1'){
	                    			if(val.isRead){
	                    				result +=   '<li class="acrive_A"><a href="javascript:void(0)" class="icon_B">'+
			                    		'<span>'+val.title+'</span>'+
			                    		'<p>'+ getRowStr(val.content.replace(/<[^>]*>|\s|(&nbsp;)/g, ""),ulWith)+'</p></a></li>';
	                    			}else{
	                    				result +=   '<li><a href="javascript:void(0)" class="icon_B">'+
			                    		'<span>'+val.title+'</span>'+
			                    		'<p>'+ getRowStr(val.content.replace(/<[^>]*>|\s|(&nbsp;)/g, ""),ulWith)+'</p></a></li>';
	                    			}
	                    			
	                    		}
	                    		
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
	
	function getRowStr(str,width){
		var strl = str.length;
		var clicent = (document.documentElement.clientWidth) / 7.5;
		var widths = width - clicent * 1.6;		
		var size = Math.ceil(parseFloat(clicent * 0.24))
		return str.substring(0,widths/size) + '</br>' + str.substring(widths/size,strl);				
	}
	
</script>