<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
body {
	background: none !important;
}

#table {
	width: 96%;
	margin: 0 auto;
	table-collapse: collapse;
	border: none;
	padding: 0;
}
#table th {
	text-align: center;
	/* font-weight: bold; */
	font-size: 1.5em;
}
#table td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}

#table td.td_left {
	text-align: left;
	white-space:pre-line;
}

.tab {
	table-collapse: collapse;
	border: none;
	width: 100%;
}

select{
   appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center;
}

select::-ms-expand { 
	display: none; 
}
.tab td {
	font-family: 宋体;
	font-size: 12px;
	border: solid #999 1px;
	padding: 2px;
	word-break: break-all;
	word-wrap: break-word;
	text-align: center;
}

.tab_title {
	text-align: left;
	/* font-weight: bold; */
	border-bottom: solid #999 1px;
	padding-top: 0.5em;
}
.tab_title span {
	display: inline-block;
	padding: 0.5em 2em !important;
	border: solid #999 1px;
	border-bottom: none;
}

.td_right {
	text-align: right;
}
.td_weight {
	/* font-weight: bold; */
}

.label_title {
	display: block;
	border-bottom: 1px solid white;
	padding: 0.5em;
}
.label_item {
	display: block;
	border-bottom: 1px solid white;
	text-align: left;
}

#table2 {
	width: 96%;
	margin: 0 auto;
	margin-top: 1.3em;
}
#table2 td {
	/* font-weight: bold; */
	font-size: 1em;
	width: 13%;
	white-space:pre-line;
}

#table td input[type="text"]{
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	text-align:center;
}

/******** 打印机样式 ********/
@media print {
	/* portrait： 纵向打印       landscape: 横向 打印  */
	@page {
		size: A5 landscape;
		/* margin: 2cm 0cm 1.4cm 3cm; */
	}
	
	* {
		text-shadow: none !important;
		box-shadow: none !important;
	}
	
	body {
	  	background-color: #FFF;
	  	background-image: none;
	  	width: 100%;
     	margin: 0;
		padding: 0;
	}
	
	#table {
		width: 100%;
		table-collapse: collapse !important;
		border: none;
		padding: 0;
		margin: 0;
	}
	#table tr {
		/* page-break-after: always; */
		/* page-break-after: avoid; */
	}
	#table th {
		text-align: center;
		/* font-weight: bold; */
		font-size: 12pt;
	}
	#table td {
		font-family: 宋体;
		font-size: 8pt !important;
		border: solid #999 0.5pt;
		padding: 1pt;
		word-break: break-all;
		word-wrap: break-word;
		text-align: center;
	}
	#table td span {
		font-weight: 100;
		padding: 0pt 1pt;
	}

	#table td.td_left {
		text-align: left;
	}
	
	#table th {
		text-align: center;
		/* font-weight: bold; */
		font-size: 12pt;
	}
	
	.tab_title {
		text-align: left;
		/* font-weight: bold; */
		border-bottom: solid #999 0.5pt;
		/* padding-top: 0.5em; */
	}
	.tab_title span {
		display: inline-block;
		padding: 3pt 8pt !important;
		border: solid #999 0.5pt;
		border-bottom: none;
	}
	.tab span{
	font-weight: 100;
	}
	
	#table2 {
		width: 100%;
		margin-top: 0.5em;
		font-weight: 100;
	}
	#table2 td {
		/* font-weight: bold; */
		font-size: 8pt;
		width: 15%;
		font-weight: 100;
	}
	#total {
	font-weight: 100;
	}
	#totalcn {
	font-weight: 100;
	}
}
</style>
</head>
<body>
<div class="tbspace">
	<input type="hidden" id="status" value="${map.business.status }">
	<input type="hidden" id="title_val" value="${map.business.title }">
	<input type="hidden" id="encrypted" value="${map.business.encrypted }">
	<select id="title_hidden" style="display:none;"><custom:dictSelect type="流程所属公司" /></select>
	<select id="conveyance_hidden" style="display:none;"><custom:dictSelect type="出差报销交通工具"/></select>
	<select id="conveyance1_hidden" style="display: none"><custom:dictSelect type="市内交通费交通工具"/></select>
	<table id="table">
		<thead>
			<tr>
				<th id="" colspan="20" style="padding-bottom:0.5em;font-weight:300;">差旅报销单</th>
			</tr>
		</thead>
		<tbody>
			<button type="button" id="button1" onclick="hiddenvalues()">隐藏</button>
			<button type="button" id="button2" onclick="showvalues()">显示</button>
			<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>
			
			<!-- 报销人相关 -->
			<tr>
				<td class="td_weight"><span>出差人员</span></td>
				<td contenteditable=true>${map.business.name }</td>
				<td class="td_weight"><span>报销单位</span></td>
				<c:choose>
				<c:when test="${empty(map.business.dept.alias)}"> 
				<td id="title" contenteditable=true>${map.business.dept.name }</td>
				</c:when>
				<c:otherwise> 
				<td id="title" contenteditable=true></td>
				</c:otherwise>
				</c:choose>
				<td class="td_weight"><span>提交日期</span></td>
				<td  contenteditable=true><fmt:formatDate value='${map.business.applyTime }' pattern='yyyy年MM月dd日'/></td>
				<td class="td_weight"><span>领款人</span></td>
				<td  contenteditable=true>${map.business.payee }</td> 
			</tr>
			
			<!-- 城际交通费 -->
			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">
					<div class="tab_title"><span contenteditable=true>城际交通费</span></div> 
					<table class="tab" id="intercityCost">
						<tbody>
							<tr>
								<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
								<td class="td_weight" contenteditable="true" style="width: 6%;">出发地</td>
								<td class="td_weight" contenteditable="true" style="width: 6%;">目的地</td>
								<td class="td_weight" contenteditable="true" style="width: 8%;">交通工具</td>
								<td class="td_weight" contenteditable="true" style="width: 12%;">项目</td>
								<td class="td_weight" contenteditable="true" style="width: 6%;">实报</td>
								<td class="td_weight" contenteditable="true" style="width: 19%;">事由</td>
								<td class="td_weight">明细</td>
								<td class="td_weight" name="operation">操作</td>
							</tr>
							<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
								<c:if test="${travelreimburseAttach.type eq '0' }">
									<tr name="node" id="node">
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td>${travelreimburseAttach.startPoint }</td>
										<td>${travelreimburseAttach.destination }</td>
										<td>
										<select name="conveyance" style="width:100%">
										<custom:dictSelect type="出差报销交通工具" selectedValue="${travelreimburseAttach.conveyance }" />
										</select>
										</td>
										<td name="projectName">${travelreimburseAttach.project.name }</td>
										<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
										<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
										<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
										<td name="operation"></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
		   			</table>
		   		</td>
		   	</tr>
			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">	
					<div class="tab_title"><span contenteditable=true>住宿费</span></div>
					<table class="tab" id="stayCost">
						<tbody>
							<tr>
								<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
								<td class="td_weight" contenteditable="true" style="width: 5%;">地点</td>
								<td class="td_weight" contenteditable="true" style="width: 12%;">项目</td>
								<td class="td_weight" contenteditable="true" style="width: 5%;">天*房</td>
								<td class="td_weight" contenteditable="true" style="width: 5%;">实报</td>
								<td class="td_weight" contenteditable="true" style="width: 15%;">事由</td>
								<td class="td_weight">明细</td>
								<td class="td_weight" name="operation">操作</td>
							</tr>
							<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
								<c:if test="${travelreimburseAttach.type eq '1' }">
									<tr name="node" id="node">
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td>${travelreimburseAttach.place }</td>
										<td name="projectName">${travelreimburseAttach.project.name }</td>
										<td><fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" /></td>
										<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
										<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
										<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
										<td name="operation"></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
		   			</table>
		   		</td>
		   	</tr>
		   	<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">		
		   			<div class="tab_title"><span contenteditable=true>市内交通费</span></div>
					<table class="tab"  id="cityCost">
						<tbody>
							<tr>
								<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
								<td class="td_weight" contenteditable="true" style="width: 5%;">地点</td>
								<td class="td_weight trafficT" contenteditable="true" style="width: 3%;white-space: nowrap;display: none;">交通工具</td>
								<td class="td_weight" contenteditable="true" style="width: 15%;">项目</td>
								<td class="td_weight" contenteditable="true" style="width: 5%;">实报</td>
								<td class="td_weight" contenteditable="true" style="width: 26%;">事由</td>
								<td class="td_weight" contenteditable="true">明细</td>
								<td class="td_weight" name="operation">操作</td>
							</tr>
							<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
								<c:if test="${travelreimburseAttach.type eq '2' }">
									<tr name="node" id="node">
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td>${travelreimburseAttach.place }</td>
										<c:if test="${not empty travelreimburseAttach.conveyance}">
											<td>
												<select name="conveyance" style="width:100%">
													<custom:dictSelect type="市内交通费交通工具" selectedValue="${travelreimburseAttach.conveyance }"/>
												</select>
											</td>
										</c:if>
										<td name="projectName">${travelreimburseAttach.project.name }</td>
										<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
										<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
										<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
										<td name="operation"></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
		   			</table>
				</td>
			</tr>
			
			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">		
		   			<div class="tab_title"><span contenteditable=true>接待餐费</span></div>
					<table class="tab" id="receiveCost">
						<tbody>
							<tr>
								<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
								<td class="td_weight" contenteditable="true" style="width: 7%;">地点</td>
								<td class="td_weight" contenteditable="true" style="width: 15%;">项目</td>
								<td class="td_weight" contenteditable="true" style="width: 7%;">实报</td>
								<td class="td_weight" contenteditable="true" style="width: 20%;">事由</td>
								<td class="td_weight" contenteditable="true">明细</td>
								<td class="td_weight" name="operation">操作</td>
							</tr>
							<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
								<c:if test="${travelreimburseAttach.type eq '3' }">
									<tr name="node" id="receive">
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td>${travelreimburseAttach.place }</td>
										<td name="projectName">${travelreimburseAttach.project.name }</td>
										<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
										<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
										<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
										<td name="operation"></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
		   			</table>
				</td>
			</tr>	
			
			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">		
		   			<div class="tab_title"><span contenteditable=true>补贴</span></div>
					<table class="tab" id="subsidy">
						<tbody>
							<tr>
								<td class="td_weight" contenteditable="true" style="width: 9%;">出发日期</td>
								<td class="td_weight" contenteditable="true" style="width: 9%;">离开日期</td>
								<td class="td_weight" contenteditable="true" style="width: 8%;">餐费补贴</td>
								<td class="td_weight trafficSubsidy" style="width: 7%">交通补贴</td>
								<td class="td_weight" contenteditable="true" style="width: 15%;">项目</td>
								<td class="td_weight" contenteditable="true" style="width: 22%;">事由</td>
								<td class="td_weight" contenteditable="true">明细</td>
								<td class="td_weight" name="operation">操作</td>
							</tr>
							<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
								<c:if test="${travelreimburseAttach.type eq '4' }">
									<tr name="node"  id="node">
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td name="foodSubsidy"><fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="0.00" /></td>
										<c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
											<td name="trafficSubsidy" ><fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="0.00" /></td>
										</c:if>
										<td name="projectName">${travelreimburseAttach.project.name }</td>
										<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
										<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
										<td name="operation"></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
		   			</table>
				</td>
			</tr>

			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">
					<div class="tab_title"><span contenteditable=true>业务费用</span></div>
					<table class="tab" id="business">
						<tbody>
						<tr>
							<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
							<td class="td_weight" contenteditable="true" style="width: 7%;">地点</td>
							<td class="td_weight" contenteditable="true" style="width: 15%;">项目</td>
							<td class="td_weight" contenteditable="true" style="width: 7%;">实报</td>
							<td class="td_weight" contenteditable="true" style="width: 20%;">事由</td>
							<td class="td_weight" contenteditable="true">明细</td>
							<td class="td_weight" name="operation">操作</td>
						</tr>
						<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
							<c:if test="${travelreimburseAttach.type eq '5' }">
								<tr name="node" id="receive">
									<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td>${travelreimburseAttach.place }</td>
									<td name="projectName">${travelreimburseAttach.project.name }</td>
									<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
									<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
									<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
									<td name="operation"></td>
								</tr>
							</c:if>
						</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>

			<tr>
				<td colspan="20" style="border-top:none; border-bottom:none;">
					<div class="tab_title"><span contenteditable=true>攻关费用</span></div>
					<table class="tab" id="relationship">
						<tbody>
						<tr>
							<td class="td_weight" contenteditable="true" style="width: 9%;">日期</td>
							<td class="td_weight" contenteditable="true" style="width: 7%;">地点</td>
							<td class="td_weight" contenteditable="true" style="width: 15%;">项目</td>
							<td class="td_weight" contenteditable="true" style="width: 7%;">实报</td>
							<td class="td_weight" contenteditable="true" style="width: 20%;">事由</td>
							<td class="td_weight" contenteditable="true">明细</td>
							<td class="td_weight" name="operation">操作</td>
						</tr>
						<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
							<c:if test="${travelreimburseAttach.type eq '6' }">
								<tr name="node" id="receive">
									<td>
										<input type="text" name="date" class="datetimepick" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td>${travelreimburseAttach.place }</td>
									<td name="projectName">${travelreimburseAttach.project.name }</td>
									<td name="actReimburse"><fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="0.00" /></td>
									<td name="reason" class="td_left">${travelreimburseAttach.reason }</td>
									<td name="detail" class="td_left">${travelreimburseAttach.detail }</td>
									<td name="operation"></td>
								</tr>
							</c:if>
						</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>

			<tr>
				<td colspan="20" style="border-top:none;">		
					<table class="tab" style="margin-top: 1em;">
						<tr>
							<td class="td_right td_weight" style="width:8%;"><span>实报金额：</span></td>
							<td style="width:92%;" >
							<div style="display:flex">
							<div style="display:flex">
							<span>¥</span>
							<span id="total"></span>
							</div>
							<div>
							(
							<span id="totalcn"></span>
							) 
							</div>
							</div>
							</td>
						</tr>
					</table>
					<table id="reimbursetotal" class="tab" style="margin-top:0;">
						<thead name="reimbursetotal">
						</thead>
					</table> 
				</td>
			</tr>
		</tbody>
	</table>
	
	<table id="table2">
		<tbody>
			<tr>
				<td id="fuhe">审核：</td>
				<td id="ceo"  style="text-align:center;">审批：</td>
				<td  style="text-align:center;">领款人：</td>
			</tr>
		</tbody>
	</table>
</div>
	

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
// 	var variables = JSON.parse('${map.jsonMap.variables}');
	var hasDecryptPermission = false;
	<shiro:hasPermission name="fin:travelreimburse:decrypt">
		hasDecryptPermission = true;
	</shiro:hasPermission>
	var variables = ${map.jsonMap.variables};


	var ishavatrafficSubsidy = new Array() ;
	<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
	if(${travelreimburseAttach.type eq "4"}){
	    if(${not empty(travelreimburseAttach.trafficSubsidy)}){
	        ishavatrafficSubsidy.push(${travelreimburseAttach.trafficSubsidy});
	    }
	}
	</c:forEach>

	var ishavatrafficTool = new Array();
	<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
	if(${travelreimburseAttach.type eq "2"}){
	    if(${not empty(travelreimburseAttach.conveyance)}){
	        ishavatrafficTool.push(${travelreimburseAttach.conveyance});
	    }
	}
	</c:forEach>

	/* $(function() {
		initMap();
		initPage();

	    if (ishavatrafficTool.length > 0) {
	        $(".trafficT").show();
	    }
		$("tr[name='node']").find("td[name='operation']").each(function(index,td){
			$(td).attr("contenteditable","false");
			}); 
		initDecryption(); 
	}); */
	var titleMap =new Array();

	function initPage() {
		var title = titleMap[$("#title_val").val()].split("");
		$("#title").prepend(title);
	 	$("tr[name='node']").find("td").each(function(index,td){
			$(td).attr("contenteditable","true");
			}); 
		
		var total = ${map.business.total};
		$("#total").text(total.toFixed(2));
		toUppercase(total);
		var status = $("#status").val();
	}

	function toUppercase(value) {
		if(!isNull(value)) {
			$("#totalcn").text(digitUppercase(value));
		} else {
			$("#totalcn").text("零元整");
		}
	}

	function initMap() {
		$("#title_hidden").find("option").each(function(index, option) {
			titleMap[$(option).attr("value")] = $(option).text();
		});
	}

	//如果有解密权限，则解密当前已加密的数据
	function initDecryption() {
		if( 'y' == $("#encrypted").val() ) {
			if( hasDecryptPermission ) {
				var now = new Date().pattern("yyyyMMdd");
				$.ajax({
					url: web_ctx+'/manage/getEncryptionKey?baseKey='+now,
					type: 'GET',
					success: function(data) {
						if(data.code == 1) {
							var tempKey = data.result;
							var encryptionKey = aesUtils.decryptECB(tempKey, now);
							encryptPageText(encryptionKey);
						} else {
							if(data.code == -1) {
								bootstrapAlert('提示', data.result, 400, null);
							}
							disabledEncryptPageText();
						}
					}
				});
			} else {
				disabledEncryptPageText();
			}
		}
	}
	function encryptPageText(encryptionKey) {
		$("td[name='reason'],td[name='detail']").each(function(index, td) {
			var val = $(td).text();
			try {
				val = aesUtils.decryptECB(val, encryptionKey);
				if( !isNull(val) ) {
					$(td).text(val);
				}
			} catch(e) {}
		});
	}
	function disabledEncryptPageText() {
		/* $("tr[name='node']").each(function(index, tr) {
			$(tr).find("td[name='reason']").prop("contenteditable", false);
			$(tr).find("td[name='detail']").prop("contenteditable", false);
		}); */
	}
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<shiro:hasPermission name="fin:travelreimburse:decrypt">
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>

<script>

</script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/pdf.js"></script>
</body>
</html>