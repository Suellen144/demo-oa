<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<header>
    <nav class="navbar navbar-default" role="navigation" style="background-color: white">
        <div class="container-fluid">
            <div>
                <!--向左对齐-->
                <ul class="nav navbar-nav navbar-left">
                    <li <c:if test="${tab.tabNameEn == 'tech'}">
                            class="active" </c:if>><a href="${pageContext.request.contextPath }/tab/tech">技术</a>
                    </li>
                    <li <c:if test="${tab.tabNameEn == 'play'}">class="active"
                        </c:if>><a href="${pageContext.request.contextPath }/tab/play">好玩</a></li>
                    <li <c:if test="${tab.tabNameEn == 'creative'}">class="active"
                        </c:if>><a href="${pageContext.request.contextPath }/tab/creative">创意</a></li>
                    <li <c:if test="${tab.tabNameEn == 'jobs'}">class="active"
                         </c:if>><a href="${pageContext.request.contextPath }/tab/jobs">工作</a></li>
                    <li <c:if test="${tab.tabNameEn == 'deals'}">class="active"
                        </c:if>><a href="${pageContext.request.contextPath }/tab/deals">交易</a></li>

                </ul>
            </div>
        </div>
    </nav>


</header>
<script>
    function signout_confirm()
    {
        var r=confirm("确定退出?")
        if (r==true)
        {
            window.location.href="/signout";
        }
        else
        {

        }
    }
</script>