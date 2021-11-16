var dataTable = null;
var projectObj = null;

$(function() {
    initDatetimepicker();
    // /*initSelect();*/
    $("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
    // /* 项目模态框 */
    $("#projectDialog").initProjectDialog2({
        "callBack": getProject
    });
    // /* 合同 */
    $("#barginDialog").initBarginDialog({
        "callBack": getBargin,
        "isCheck": true
    });

    if($("#barginManageId").val() != null && $("#barginManageId").val() != ""){
        $("#viewBarginBtn").show();
    };
    initBrowserInfo();
});

function initDatetimepicker() {
    $("#beginDate, #endDate").datetimepicker({
        minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
        bootcssVer:3,
    });
}

function getSearchData() {
    var params = {};
    var status = "";
    params.beginDate = $.trim($("#beginDate").val());
    params.endDate = $.trim($("#endDate").val());
    params.status = $.trim($("#status").val());
    params.fuzzyContent = $.trim($("#fuzzyContent").val());

    if(!isNull(params.beginDate)) {
        params.beginDate += " 0:0:0";
    }
    if(!isNull(params.endDate)) {
        params.endDate += " 23:59:59";
    }
    return params;
}

// /*添加回车响应事件*/
$(document).keydown(function(event){
    var curkey = event.which;
    if(curkey==13){
        drawTable();
        return false;
    }
});

//清空项目
function clearProject() {
    $("#projectName").val("");
    $("#projectId").val("");
}

// /*清空*/
function clearForm() {
    $("#searchForm").clear();
    $("#beginDate").prop("readonly", true);
    $("#endDate").prop("readonly", true);
    $("#payCompany").selectpicker('refresh');
    $("#barginType").selectpicker('refresh');
    $("#selectbargin").html("");
}

function openProject(obj) {
    if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
        var project = null;
        var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");

        if( tr.length > 0 && !isNull($(tr).find("textarea[name='projectName']").val()) ) {
            $(obj).siblings("input[name='projectId']").val( $(tr).find("input[name='projectId']").val() );
            $(obj).val( $(tr).find("textarea[name='projectName']").val() );
            return ;
        }
    }
    $("#projectDialog").openProjectDialog();
    projectObj = obj;
}
// /*得到项目*/
function getProject(data) {
    if(!isNull(data) && !isNull(projectObj)) {
        $(projectObj).next("input[name='projectId']").val(data.id);
        $(projectObj).val(data.name);
    }
}

// /*合同*/
function openBargin() {
    $("#barginDialog").openBarginDialog();
}

// /*查看合同详情*/
function viewBargin(projectId) {
	 var formdata = getFormData();
	 if(!isNull(formdata["beginDate"])) {
		 formdata["beginDate"] += " 00:00:00";
	 }
	 if(!isNull(formdata["endDate"])) {
		 formdata["endDate"] += " 23:59:59";
	 }
	 // 因为 bootstrap Select()单选为数字，多选为数组 判断是否为数组
	 if(!(formdata["payCompany"] instanceof Array)){
		 if(!isNull(formdata["payCompany"])) {
			 var payCompany = new Array();
	         payCompany[0] = formdata["payCompany"];
	         formdata["payCompany"] = payCompany;
	     }
	 }
	 if(!(formdata["barginType"] instanceof Array)){
		 if (!isNull(formdata["barginType"])) {
			 var barginType = new Array();
	         barginType[0] = formdata["barginType"];
	         formdata["barginType"] = barginType;
	     }
	 }
	 formdata["projectId"] = projectId;
	 $.ajax({
		 type:"POST",
	     url:web_ctx+"/manage/finance/statisticsBargin/searchOtherByProjectId",
	     contentType:"application/json;charset=UTF-8",
	     data:JSON.stringify(formdata),
	     dataType:"json",
	     success:function (data) {
	    	 openBootstrapShade(false);
	         if(data.code == 1){
	        	 buildProjectContent(data,projectId)
	         }else {
	             bootstrapAlert("提示", data.result, 400, null);
	         }
	     },
	     error: function(data) {
	    	 openBootstrapShade(false);
	         bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	     },
	 })
}

//内容的搭建
function buildProjectContent(data,projectId){
	 $("#tab3Body").html("");
	 $("#tab2Body").html("");
	//新建展示内容，构建表格
    $("#myModalLabel").html(data.result["barginProfitDTO"].projectName);
    $("#sellTotal").html(data.result["barginProfitDTO"].sellTotal);
    $("#BuyerTotal").html(data.result["barginProfitDTO"].buyerTotal);
    $("#fee").html(data.result["barginProfitDTO"].fee);
    $("#fee").attr("data-id",projectId);
    $("#margin").html(data.result["barginProfitDTO"].margin);
    if(data.result["barginS"].length>0){
    	var barginS = data.result["barginS"]
    	
    	for(var i = 0; i<barginS.length; i++){
    		var v=barginS[i];
    		var company = "";
        	var startTime = "";
        	if(!isNull(v.company)){
        		company = v.company;
        	}
        	if(!isNull(v.startTime)){
        		startTime = new Date(v.startTime).format("yyyy-MM-dd");
        	}
        	var accountReceived = "";
        	if(v.accountReceived > 0){
        		accountReceived = v.accountReceived;
        	}else{
        		accountReceived = 0;
        	}
    		var content = "<tr>" +
        	"<td>"+v.barginCode+"</td>" +
            "<td>"+company+"</td>" +
            "<td>"+startTime+"</td>" +
            "<td>"+v.totalMoney+"</td>" +
            "<td>"+v.receivedMoney+"</td>" +
            "<td>"+v.unreceivedMoney+"</td>" +
            "<td>"+v.invoiceMoney+"</td>" +
            "<td>"+v.advancesReceived+"</td>" +
            "<td>"+accountReceived+"</td>" +
            "</tr>";
    		 $("#tab2Body").append(content);
    	}
    }
    
    if(data.result["barginB"].length>0){
    	var barginB = data.result["barginB"]
    	for(var i = 0; i<barginB.length; i++){
    		var v = barginB[i];
    		var company = "";
        	var startTime = "";
        	if(!isNull(v.company)){
        		company = v.company;
        	}
        	if(!isNull(v.startTime)){
        		startTime = new Date(v.startTime).format("yyyy-MM-dd");
        	}
        	var payUnreceivedInvoice = "";
        	if(v.payUnreceivedInvoice > 0){
        		payUnreceivedInvoice = v.payUnreceivedInvoice;
        	}else{
        		payUnreceivedInvoice = 0;
        	}
    		var content = "<tr>" +
        	"<td>"+v.barginCode+"</td>" +
            "<td>"+company+"</td>" +
            "<td>"+startTime+"</td>" +
            "<td>"+v.totalMoney+"</td>" +
            "<td>"+v.payMoney+"</td>" +
            "<td>"+v.unpayMoney+"</td>" +
            "<td>"+v.payReceivedInvoice+"</td>" +
            "<td>"+v.unInvoice+"</td>" +
            "<td>"+payUnreceivedInvoice+"</td>" +
            "</tr>";
    		 $("#tab3Body").append(content);
    	}
    }
    $("#barginDetailModal").modal("show");
}

//用于导出详情的参数
var detailParam = {};
/* 查看项目支出详情 */
function payDetail(obj){
	var projectId = $("#projectId").val();
	var projectManageId = $(obj).attr("data-id");
	var id = null;
	if(projectId == ""){
		id = projectManageId;
	}else{
		id = projectId;
	}
	$.ajax({
        type:"POST",
        url:web_ctx+"/manage/finance/statisticsBargin/searchInfoByProjectId",
        data:{
            "projectId":id
        },
        dataType:"json",
        success:function (data) {
            if(data.code == 1){
            	$("#modalTitle").html("项目支出详情");
                $("#singleDetail_content_rows").html("");
                $.each(data.result["contentOfForm"],function (n,v) {
                    var date = "";
                    if(v.payDate != null){
                    	date = new Date(v.payDate).format("yyyy-MM-dd");
                    }else{
                    	date = new Date(v.date).format("yyyy-MM-dd");
                    }
                    var orderNo = "";
                    if (v.orderNo != null){
                        orderNo = v.orderNo;
                    }
                    var money = 0.00;
                    if (v.money != null){
                        money = formatCurrency(v.money);
                    }
                    if (v.payMoney != null){
                        money = formatCurrency(v.payMoney);
                    }   
                    var content = '<tr><td style="width:10%;padding-left:15px;">'+v.userName+'</td>'+
        				'<td style="width:12%;padding-left:15px;">'+orderNo+'</td>'+
        				'<td style="width:12%;padding-left:15px;">'+date+'</td>'+
        				'<td style="width:14%;padding-left:15px;">'+v.projectName+'</td>'+
        				'<td style="width:40%;padding-left:15px;">'+v.reason+'</td>'+
        				'<td style="width:12%;padding-left:15px;">'+money+'</td></tr>'
                    $("#singleDetail_content_rows").append(content);
                })
              //导出详情参数
				detailParam={
						"projectId":projectId
				};
            }else{
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        error:function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    })
	$("#singleDetail").modal("show");
}

//导出详情
function exportDetails(){
	var srcURI = web_ctx+"/manage/finance/statisticsBargin/exportDetails";
	var exportForm = $("<form>");   
	exportForm.attr('style','display:none');   
	exportForm.attr('target','');
	exportForm.attr('method','post');
	exportForm.attr('action', srcURI);
	exportForm.append("<input type='hidden' name='projectId' value=\""+detailParam['projectId']+"\">");
	$('body').append(exportForm);  
    exportForm.submit(); 
}

// /*得到合同详细信息*/
function getBargin(data) {
    if(!isNull(data) && !$.isEmptyObject(data)) {
        $("#barginId").val(data.id);
        $("#barginProcessInstanceId").val(data.processInstanceId);
        $("#barginCode").val(data.barginCode);
        $("#barginName").val(data.barginName);
        $("#selectbargin").html(data.barginName);
        $("#totalPay").val(data.totalMoney);
        if(data.projectManage != null && data.projectManage != ""){
            $("#projectManageName").val(data.projectManage.name);
            $("#projectManageId").val(data.projectManage.id);
        }
        if(data.processInstanceId != null && data.processInstanceId != "" && data.processInstanceId != "undefined"){
            $("#tip").remove();
            $("#viewBarginBtn").show();
        }else{
            $("#tip").remove();
            document.getElementById("viewBarginBtn").style.display = "none";
            $("#viewBarginBtn").before('<font id="tip" style="border:none;color: rgb(54, 127, 169)">选取成功！</font>');
        }
    }
}

// /*获取浏览器信息*/
function getBrowserInfo() {
	return $.extend(true, {}, browserInfo);
}

function initBrowserInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
    browserInfo.version = m[2];
}

var currTd = null;
function openDialog(obj) {
    currTd = obj;
    $("#userDialog").openUserDialog();
    var browserInfo = getBrowserInfo();
    window.frames["userFrame"].drawTable();
    /* if (browserInfo.browser == "ie") {*/
    /*   }*/
    /*  else {
          userFrame.contentWindow.drawTable();
      }*/
}

// /*获取表单数据 */
function getFormData() {
    var json = $("#searchForm").serializeJson();
    var formData =$.extend(true,{},json);
    return formData;
}

// /*搜索*/
function drawTable() {
    var formdata = getFormData();
    if(!isNull(formdata["beginDate"])) {
        formdata["beginDate"] += " 00:00:00";
    }
    if(!isNull(formdata["endDate"])) {
        formdata["endDate"] += " 23:59:59";
    }
    // 因为 bootstrap Select()单选为数字，多选为数组 判断是否为数组
    if(!(formdata["payCompany"] instanceof Array)){
        if(!isNull(formdata["payCompany"])) {
            var payCompany = new Array();
            payCompany[0] = formdata["payCompany"];
            formdata["payCompany"] = payCompany;
        }
    }
    if(!(formdata["barginType"] instanceof Array)){
        if (!isNull(formdata["barginType"])) {
            var barginType = new Array();
            barginType[0] = formdata["barginType"];
            formdata["barginType"] = barginType;
        }
    }
    openBootstrapShade(true)
    //提交代码
    submitForm(formdata);
}

//提交搜索内容
function submitForm(formdata) {
    $.ajax({
        type:"POST",
        url:web_ctx+"/manage/finance/statisticsBargin/searchOtherByStatistics",
        contentType:"application/json;charset=UTF-8",
        data:JSON.stringify(formdata),
        dataType:"json",
        success:function (data) {
            openBootstrapShade(false);
            if(data.code == 1){
                $("#reimburse").show();
                $("#reimburseTable_header_content").html("");
                $("#reimburseTable_content_content").html("");
               /* if(data.result["mapContent"].beginDate != null) {
                    var beginDate = new Data(data.result["mapContent"].beginDate).format("yyyy-MM-dd");
                }else {
                    var beginDate="";
                }
                if(data.result["mapContent"].endDate != null){
                    var endDate = new Data(data.result["mapContent"].endDate).format("yyyy-MM-dd");
                }else {
                    var endDate="";
                }

                if (beginDate != "" || endDate != ""){
                    $("#title").text(beginDate + "至" +endDate + "合同统计");
                }else{
                    $("#title").text("合同统计");
                }*/
                $.each(data.result["mapContent"],function (n,v) {
	                var processInstanceId = "";
	                var projectManageName = "";
	                var barginName = "";
	                if(v.processInstanceId != null){
	                    processInstanceId = v.processInstanceId;
	                }
	                if (v.projectManage != null) {
	                    if (v.projectManage.name != null) {
	                        projectManageName = v.projectManage.name;
	                    }
	                }
	                if(v.barginName != null){
	                    barginName = v.barginName;
	                }
	                var content = "<tr onclick='viewBargin(\""+v.projectManageId+"\")'>" +
	                	"<td style='width: 9%;border-right: 1px solid #ddd;' class = 'projectManageId' data-id="+v.projectManageId+">"+projectManageName+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.totalMoneyS)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.receivedMoney)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.unreceivedMoney)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.invoiceMoney)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.advancesReceived)+"</td>" +
	                    "<td style='width: 7%;border-right: 1px solid #ddd;'>"+fmoney(v.accountReceived)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.totalMoneyB)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.payMoney)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.unpayMoney)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.payReceivedInvoice)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.unReceivedInvoice)+"</td>" +
	                    "<td style='width: 7%;'>"+fmoney(v.payUnreceivedInvoice)+"</td>" +
	                    "</tr>"
	                $("#reimburseTable_content_content").append(content);
                })
            }else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        error: function(data) {
            openBootstrapShade(false);
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        },
    })
}

//导出excel 表
function exportExcel (){
    var params = getFormData();
    var str=params["payCompany"];
    params = urlEncode(params);
    params = params.substring(1);
    
    var url = web_ctx +  "/manage/finance/statisticsBargin/exportExcel?" + params+"&strRayCompany="+str;
    $("#excelDownload").attr("src", encodeURI(url));
    // bootstrapAlert("数据导出中","请稍等一下");
}

//时间格式
Date.prototype.format = function(fmt) {
    var o = {
        "M+" : this.getMonth()+1,                 //月份
        "d+" : this.getDate(),                    //日
        "h+" : this.getHours(),                   //小时
        "m+" : this.getMinutes(),                 //分
        "s+" : this.getSeconds(),                 //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S"  : this.getMilliseconds()             //毫秒
    };
    if(/(y+)/.test(fmt)) {
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }
    for(var k in o) {
        if(new RegExp("("+ k +")").test(fmt)){
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        }
    }
    return fmt;
}

//金钱格式化
function formatCurrency(num) {
    num = num.toString().replace(/\$|\,/g,'');
    if(isNaN(num))
        num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
            num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + num + '.' + cents);
}
//反转金钱格式化
function rmoney(s)
{
    return parseFloat(s.replace(/[^\d\.-]/g, ""));
}

