<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">绩效考核</li>
	</ol>
</header>

<style>
table {table-collapse: collapse;border: none;margin: 0px 0px;text-align: center;width: 100%;}
#table thead th {border: none;}
#table td input[type="text"] {width: 100%;height: 100%;border: none;outline: medium;}
td {border: solid #999 1px;padding: 0px;font-size: 1em;text-align: center;} 
td input[type="text"] {width: 100%;height: 100%;border: none;outline: medium;text-align: center;padding: 5px 1em;margin: 0px;}
td input[type="radio"] {margin-left: 0.5em;vertical-align: middle;}
td label {font-weight: normal;}
td p {padding: 5px 1em;margin: 0px;}
th {border: solid #999 1px;text-align: center;font-size: 1.5em;} 
select{appearance:none;-moz-appearance:none;-webkit-appearance:none;border: none;}
/* IE10以上生效 */
select::-ms-expand {display: none;}
textarea{border-left:0px;border-top:0px;border-right:0px;border-bottom:1px;}
#ul_user li {list-style-type: none;}
#ul_user li:hover {cursor: pointer;font-weight: bold;font-size: 1.2em;}
.connectedSortable {padding-right: 0px;}
.butn{width:36px;height:34px;padding:0}
</style>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
			<section class="col-md-10 connectedSortable ui-sortable" style="width:100%;height:100%;">
				<button type="button" class="btn btn-primary butn fa fa-x fa-cloud-download" onclick="exportExcel()"></button>
				<button type="button" class="btn btn-primary butn fa fa-x fa-print" onclick="printing()"></button>	
				<div class="box box-primary box-solid">
					<div class="box-body">
						<form id="form1">
							<table>
								<thead>
									<tr><input type="text" name="title" value="${reward.title}"style="width:100%;height:100%;font-weight：bolder;font-size:24px;border:none;text-align:center;"></tr>
									<input type="hidden" id="rewardId" name="id" value="${reward.id}">
									<input type="hidden" name="status" id="status" value="${reward.status}">
									<tr style="background-color:#d2d6de;height:35px;">
										<td class="td_weight"><span>序号</span></td>
										<td class="td_weight"><span>部门</span></td>
										<td class="td_weight"><span>姓名</span></td>
										<td class="td_weight"><span>岗位</span></td>
										<td class="td_weight"><span>入职时间</span></td>
										<td class="td_weight"><span>基本月薪</span></td>
										<td class="td_weight"><span>考核分数</span></td>
										<td class="td_weight"><span>奖励系数</span></td>
										<td class="td_weight"><span>奖励金额</span></td>
										<td class="td_weight"><span>其他奖项</span></td>
										<td class="td_weight"><span>奖金总额</span></td>										
										<td class="td_weight"><span>备注</span></td>
									</tr>
								</thead>
									
								<c:forEach items="${list}" var="reward" varStatus="itemIndex">
									<tbody data-index = "${itemIndex.index}">											
									<c:choose>
									  <c:when test="${reward[0].record.deptId ==2}"> 
									   <tr><td colspan='12'><input  type="text" value = "总经理" readonly></td></tr>	
									  </c:when>
									  <c:when test="${reward[0].record.deptId ==3 or reward[0].record.deptId ==35 or reward[0].record.deptId ==36
									  or reward[0].record.deptId ==37 or reward[0].record.deptId ==38 or reward[0].record.deptId ==39}"> 
									   <tr><td colspan='12'><input  type="text" value = "营销中心" readonly></td></tr>	
									  </c:when>
									  <c:when test="${reward[0].record.deptId ==4}"> 
									   <tr><td colspan='12'><input  type="text" value = "行政中心" readonly></td></tr>	
									  </c:when>
									  <c:when test="${reward[0].record.deptId ==5 or reward[0].record.deptId ==40 or reward[0].record.deptId ==41
									  or reward[0].record.deptId ==42 or reward[0].record.deptId ==43 or reward[0].record.deptId ==44}"> 
									   <tr><td colspan='12'><input  type="text" value = "技术中心" readonly></td></tr>	
									  </c:when>
									  <c:when test="${reward[0].record.deptId ==6}"> 
									   <tr><td colspan='12'><input  type="text" value = "项目中心" readonly></td></tr>	
									  </c:when>
									   <c:otherwise> 
									     <tr><td colspan='12'><input  type="text" value = "${reward[0].record.dept}" readonly></td></tr>	
									   </c:otherwise>
									</c:choose>
									<c:forEach items="${reward}" var="a" varStatus="itemIndex2">								
										<tr name = "node" data-i = "${itemIndex.index}" >
											<input type="hidden" name="Attachid" value="${a.id}">			
											<td style="width:4%;"><input  type="text" name = number value = "" readonly></td>
											<td style="width:7%;"><input  type="text" value = "${a.record.dept}" readonly></td>
											<input name="AttachuserId"  type="hidden" value = "${a.record.userId}" readonly>
											<input name="AttachdeptId" type="hidden" value = "${a.record.deptId}" readonly>
											<td style="width:7%;"><input  type="text" name="name" value = "${a.record.name}" readonly></td>
											<td style="width:8%;"><input  type="text" value = "${a.record.position}" readonly></td>
											<td style="width:8%;"><input  type="text" name="entrytime" value="<fmt:formatDate value="${a.record.entryTime}" pattern="yyyy-MM-dd" />" readonly></td>
											<td style="width:8%;"><input  type="text" name="salary" value = "${a.wages}" readonly></td>
											<td style="width:6%;"><input  type="text" name="score"  value="<fmt:formatNumber value='${a.score}' pattern='#.#' />" readonly></td>
											<td style="width:6%;"><input  name="coefficient" type="text"  value = "${a.coefficient}"></td>
											<td style="width:6%;"><input style="text-align: right;" name = "money" type="text" value = "${a.businessreward}" readonly></td>
											<td style="width:6%;"><input style="text-align: right;" name="otherreward" type="text" value = "${a.otherreward}"></td>
											<td style="width:6%;"><input style="text-align: right;background:#fff" name="totalbonus" disabled="disabled" type="text"  value = "${a.totalreward}"></td>
											<td style="width:20%;"><input  name="remark"  type="text" value = "${a.remark}"></td>
										</tr>
										<c:set var="size" value = "${itemIndex2.index + 1}" />
									</c:forEach>
									<tr class='subtotal'>
										<td colspan='2'><input  type="text" value = "小计" readonly></td>
										<td><input  type="text" value = "${size }人" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value='--' readonly></td>
										<td><input  type="text" value = "0" readonly></td>
										<td><input  type="text" value = "0" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td></td>
										</tr>									
									</tbody>
								</c:forEach>
						
								<tbody data-index = 'null' class='summaryT'>
									<tr>
										<td colspan='2'><input  type="text" value = "汇总" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value='' readonly></td>
										<td><input  type="text" value = "0" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value = "" readonly></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td><input  type="text" value = "0" readonly style="text-align: right;"></td>
										<td></td>										
									</tr>									
								</tbody>
								
								
								
							</table>
							<c:if test="${empty(reward.status)}">
								<div style="width:100%; text-align:center;margin-top:5px;">
									<button id="save_btn" type="button" class="btn btn-primary" onclick="save()" >保存</button>
									<button id="save_btn" type="button" class="btn btn-primary" onclick="submitinfo()" >提交</button>
									<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
								</div>
							</c:if>
						</form>
					</div>
				</div>
			</section>
	</section>
</div>
<iframe id="excelDownload" style="display:none;"></iframe>
<script type="text/javascript">
	base = "<%=base%>";
	var hasDecryptPermission = false;
	<shiro:hasPermission name="fin:travelreimburse:decrypt">
		hasDecryptPermission = true;
	</shiro:hasPermission>
</script>
<%@ include file="../../common/footer.jsp"%>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/reward/js/edit.js"></script>

<script>
$(function(){
		$(".box-body #form1").find("input[name='coefficient']").bind("input",function(event){
			var subtotal = 0;
			var totalbonus = 0;
			var tr = $(this).parent().parent();
 	    var index = tr.attr('data-i')
			var val = rmoney(tr.find("input[name='salary']").val());
	        var percent = tr.find("input[name='coefficient']").val();
			var otherM = rmoney(tr.find("input[name='otherreward']").val());
		try {
			var count = val*percent;
 	        if(isNaN(count) || isNull(count)){
				count = 0;
			}
 	  
			tr.find("input[name='money']").val(fmoney(count,2));
			tr.find("input[name='coefficient']").val(parseInt(percent.length>0 ? percent : 0))
			tr.find("input[name='totalbonus']").val(fmoney(parseInt(percent.length>0 ? count + otherM : 0),2));   
		} catch(e) {}
 	      
		tr.parent().find('tr[data-i = '+index+']').each(function(i){
			subtotal += rmoney($(this).find("input[name='money']").val())
			totalbonus += rmoney($(this).find("input[name='totalbonus']").val())
			
		})
 	    
		tr.parent().find('.subtotal td').eq(7).find('input').val(fmoney(subtotal,2));      
		tr.parent().find('.subtotal td').eq(9).find('input').val(fmoney(totalbonus,2)); 
		Amount()
 	});
		
		
		$(".box-body #form1").find("input[name='otherreward']").bind("input",function(event){
			var subtotal = 0;
			var totalbonus = 0;
			var tr = $(this).parent().parent();
 	    var index = tr.attr('data-i')			
 	    var percent = parseInt($(this).val());
 	    var count = rmoney(tr.find("input[name='money']").val());
 	   
 	    tr.find("input[name='otherreward']").val(fmoney(parseInt(percent>0 ? percent : 0),2));
 	    tr.find("input[name='totalbonus']").val(fmoney(parseInt(count + (percent >= 0 ? percent : 0)),2));
 	    
		tr.parent().find('tr[data-i = '+index+']').each(function(i){
			subtotal += rmoney($(this).find("input[name='otherreward']").val())
			totalbonus += rmoney($(this).find("input[name='totalbonus']").val())
		})

		tr.parent().find('.subtotal td').eq(8).find('input').val(fmoney(parseInt(subtotal),2));      	 	   	
 	    tr.parent().find('.subtotal td').eq(9).find('input').val(fmoney(totalbonus,2));
 	    
 	   Amount()
 	});

		var peo = 0;
		$(".box-body #form1").find('tbody').each(function(i){
			var mark = 0,markpeo = 0;;
			var index = $(this).attr('data-index');
			if(index == i){
				$(this).find('tr').each(function(j){ 					
					if(i == $(this).attr('data-i')){
						peo++;	
						var ma = $(this).find("input[name = 'score']").val()
						if(ma.length > 0){
							mark += parseFloat(ma);
							markpeo++;
						}
					}					
				})
				$(this).find('.subtotal').find('td').eq(5).find('input').val(mark == 0 ? '' : (mark/markpeo).toFixed(1))
			}
			$(".summaryT").find('td').eq(1).find('input').val(peo +'人')
		})	

}) 

function Amount(){
		var money0 = 0,money1 = 0,money2 = 0,money3 = 0;
		$(".box-body #form1").find('tbody').each(function(i){			
			var index = $(this).attr('data-index');
			if(index == i){
				var peo = 0,money = 0;
				$(this).find('tr').each(function(j){ 					
					if(i == $(this).attr('data-i')){
						peo++;
						money += parseInt(rmoney($(this).find("input[name='salary']").val()));
						money0 += parseInt(rmoney($(this).find("input[name='salary']").val()));
						money1 += parseInt(rmoney($(this).find("input[name='money']").val()));
						money2 += parseInt(rmoney($(this).find("input[name='otherreward']").val()));
						money3 += parseInt(rmoney($(this).find("input[name='totalbonus']").val()));
					}					
				})
				$(this).find(".subtotal").find('td').eq(4).find('input').val(fmoney(money/peo));
				
			}
			$(".summaryT").find('td').eq(4).find('input').val(fmoney(money0))
			$(".summaryT").find('td').eq(7).find('input').val(fmoney(money1))
			$(".summaryT").find('td').eq(8).find('input').val(fmoney(money2))
			$(".summaryT").find('td').eq(9).find('input').val(fmoney(money3))
			
		})
	}
	
	function printing(){
		window.print()
	}
	
</script>
</body>
</html>