<%@ page contentType="text/html; charset=UTF-8" %>
<!-- Javascript -->
<script type="text/javascript" src="<%=base%>/static/jquery/jquery-1.11.1/jquery.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/bootstrap/js/bootstrap.min.js"></script>
<%-- <script type="text/javascript" src="<%=base%>/static/AdminLTE/js/app.min.js"></script> --%>
<!-- 实用工具脚本 -->
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/saveSvgAsPng.js"></script>

<!-- <script type="text/javascript" src="<%=base%>/static/js/require-min.js"></script> -->

<script type="text/javascript">
web_ctx = "<%=base%>"; // 全局变量“应用名称”，所有脚本可用

<%-- require.config({
	paths: {  
        "jquery": "<%=base%>/static/jquery/jquery-1.11.1/jquery.min",  
        "bootstrap": "<%=base%>/static/bootstrap/js/bootstrap.min",
    	"datatables": "<%=base%>/static/plugins/datatables/jquery.dataTables",
        "datatable": "<%=base%>/static/plugins/datatables/dataTables.bootstrap.min",
        "treetable": "<%=base%>/static/treeTable/jquery.treetable"
    },
    "shim": { 
       bootstrap: {
            deps: ['jquery'],
            exports: 'bootstrap'
       },
       datatable: {
    	   deps: ['datatables'],
           exports: 'datatable'
       },
       treetable: {
    	   deps: ['jquery'],
    	   exports: 'treetable'
       }
    } 
}); --%>

var _footer_prevDate = new Date();
jQuery(document).ready(function () {
    //ajax处理session过期问题
    $.ajaxSetup({
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        complete: function(XMLHttpRequest, textStatus) {
            var sessionstatus = XMLHttpRequest.getResponseHeader("sessionstatus"); //通过XMLHttpRequest取得响应头，sessionstatus，
            if(sessionstatus == "timeout") {
            	var currDate = new Date();
            	if( ((currDate - _footer_prevDate) / 1000) > 1 ) {
                    //如果超时就处理 ，指定要跳转的页面
                    bootstrapAlert("提示", "<div class='text-center'><h4>登录超时,请重新登录！</h4></div>", 400, function() {
                    	location.replace(location.href);
                    });
            	}
            	_footer_prevDate = currDate;
            }
        }
    });
});

// 返回上一页并刷新
function backPageAndRefresh() {
	try {
		var browserInfo = window.parent.getBrowserInfo();
    	if( browserInfo.browser == "firefox" ) {
    		location.href = document.referrer;
    	} 
    	else if(browserInfo.browser == "ie"){
    		history.go(-1);
    	}
    	else {
/*     		window.history.back(-1);
    		window.location.reload();	 */
    		history.go(-1);
    	}
	} catch(e) {
		window.history.back(-1);
		window.location.reload();
	}
}

// 刷新当前页
function refreshPage() {
	try{
		var browserInfo = window.parent.getBrowserInfo();
		if( browserInfo.browser == "firefox" ) {
			window.location.reload(true);
    	} 
		else if(browserInfo.browser == "ie"){
    		window.location.reload();
    	}
    	else {
    		window.location.reload(true);	
    	}
	}
	catch(e){
		window.location.reload(true);	
	}
}

/*判断页面访问来自移动端 OR PC端*/
var browser={
    versions:function(){
        var u = navigator.userAgent, app = navigator.appVersion;
        return {//移动终端浏览器版本信息
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
            iPhone: u.indexOf('iPhone') > -1 , //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
        };
    }(),
    language:(navigator.browserLanguage || navigator.language).toLowerCase()
}

//金钱格式化
function fmoney(s, n){
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + '').replace(/[^\d\.-]/g, '')).toFixed(n) + '';
    var l = s.split('.')[0].split('').reverse(), r = s.split('.')[1];
    var t = '';
    for (var i = 0; i < l.length; i++) {
        t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? ',' : '');
    }
    return t.split('').reverse().join('') + '.' + r;

}
//反转金钱格式化
function rmoney(s)
{
    return parseFloat(s.replace(/[^\d\.-]/g, ""));
}
</script>
