
$(function() {
	initTaskComment();
	findPayInfo();
});

var barginManageId = $("#id").val();
function findPayInfo(){
	var status = "5";
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/finance/pay/findPayInfo",//查找与合同关联的已审批完的付款信息
        "dataType": "json",
        "data": {"barginManageId": barginManageId, "status": status},
        "success": function(data) {
        	if(data.code == 1) {
				if(data.result != null && data.result != "" && data.result.length >0 ){
					var html = [];
					
					//插入表头
					html.push('<table id="table3" style="width:90%;text-align: center;>');
					html.push('<thead>');
					html.push('<tr style="text-align: center;font-weight: bold;"><th colspan="20" >付  款  详  情</th></tr>');
					html.push('<tr style="text-align: center;font-weight: bold;" >');
					html.push('<td class="td_weight" style="width:15%;" id="pay">付款类型</td>');
					html.push('<td class="td_weight" style="width:20%">收款单位</td>');
					html.push('<td class="td_weight" style="width:10%">发票金额</td>');
					html.push('<td class="td_weight" style="width:10%">实际付款金额</td>');
					html.push('</tr>');
					
							
					//计算已收发票金额
					var actualPayTotalMoney = 0;
					for (var i in data.result) {
						var payType = '';
						if(data.result[i].payType == '1'){
							 payType = '货款';
						}else if(data.result[i].payType == '0'){
							payType = '预付款';
						}
						
						var actualPayMoney = data.result[i].actualPayMoney.toFixed(2);
						var invoiceMoney = data.result[i].invoiceMoney.toFixed(2);
						
						actualPayTotalMoney = digitTool.add(actualPayTotalMoney,actualPayMoney).toFixed(2);
						html.push('<tr><td>'+payType+'</td><td style="text-align: center;">'+ data.result[i].collectCompany +'</td><td>'+invoiceMoney +'</td><td style="text-align: right;">'+ actualPayMoney +'</td></tr>');
					}
					html.push('</thead>');
					html.push('<tbody></tbody>');
					html.push('</table>');
					html.push('<br><br>');
					
					$("#pay").append(html.join(""));
					
					var trAttr = $("tbody").find("#totalMoney").parent().attr("colspan","3");
					var tr = $("tbody").find("#totalMoney").parent();
					$(tr).after('<td  class="td_weight"><span>已付金额</span></td><td colspan="3"><input type="text"  readonly name="payMoney" style="text-align: right;"  id ="payMoney" value="'+actualPayTotalMoney +'"></td>');
        	}
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
	
}

var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

	for (var i = commentList.length -1; i >= 0; i--) {
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		html.push(commentList[i].node);
		html.push("</td>");
		html.push("<td>");
		html.push(commentList[i].approver);
		html.push("</td>");
		html.push("<td>");
		var approveDate = commentList[i].approveDate + "";
		if( !dateRep.test(approveDate) ) {
			html.push(new Date(commentList[i].approveDate).pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
		}
		html.push("</td>");
		html.push("<td>");
		html.push(commentList[i].approveResult);
		html.push("</td>");
		html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(commentList[i].comment) ? "" : commentList[i].comment);
		html.push("</td>");
		
		$("#table2").find("tbody").append(html.join(""));
	}
}
//下载附件
function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}

