<%@ page contentType="text/html; charset=UTF-8" %>
<footer>
	<ul>
		<li>
			<a href="mIndex">
				<i class="iconfont icon-home"></i>
				<i class="iconfont icon-homefill"></i>
				<span>首页</span></a>
		</li>
		<li>
			<a href="javascript:void(0)">
				<i class="iconfont icon-barrage"></i>
				<i class="iconfont icon-barrage_fill"></i>
				<span>分类</span>
			</a>
		</li>
		<li>
			<a href="<%=base%>/manage/personal">
				<i class="iconfont icon-people"></i>
				<i class="iconfont icon-peoplefill"></i>
				<span>我的</span>
			</a>
		</li>
	</ul>
</footer>
<script src="<%=base%>/static/js/jQuery-2.2.0.min.js"></script>
<script>
	var base = '<%=base%>';
	$(function(){
		$('footer ul li a').click(function(){
			$(this).parent().addClass('active').siblings().removeClass('active')
		})

	})
	function isNull(str){    	
		if (str == '' || str == undefined || str == 'undefined'|| str == null || str == 'null' || str=='NULL')
			return true;
		return false;  		
	}
</script>