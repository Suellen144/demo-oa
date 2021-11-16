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
    // /* 职位 */
    $("#deptDialog").initDeptDialog({
        "callBack": getDept
    });
    // /* 合同 */
    $("#barginDialog").initBarginDialog({
        "callBack": getBargin
    });

    if($("#barginManageId").val() != null && $("#barginManageId").val() != ""){
        $("#viewBarginBtn").show();
    };
    // /* 用户 */
    // $("#userDialog").initUserDialog({
    //     "callBack": getData
    // });

    $("#userByDeptDialog").initUserByDeptDialog({
        "callBack":getData
    });
    initBrowserInfo();
    var formdata = getFormData();
    if(!isNull(formdata["beginDate"]) || !isNull(formdata["endDate"]) || !isNull(formdata["zBeginDate"]) || !isNull(formdata["zEndDate"]) ||
    		!isNull(formdata["cBeginDate"]) || !isNull(formdata["cEndDate"]) ||!isNull(formdata["projectName"]) || 
    		!isNull(formdata["payCompany"]) || !isNull(formdata["deptName"]) || !isNull(formdata["userName"]) || 
    		!isNull(formdata["generalReimbursType"]) || !isNull(formdata["investId"]) || !isNull(formdata["status"])) {
    	drawTable();
    }
});

function initDatetimepicker() {
	$("#beginDate, #endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	$("#zBeginDate, #zEndDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	$("#cBeginDate, #cEndDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function getSearchData() {
	var params = {};
	var status = "";
	params.beginDate = $.trim($("#beginDate").val());
	params.endDate = $.trim($("#endDate").val());
	/*params.zBeginDate = $.trim($("#zBeginDate").val());
	params.zEndDate = $.trim($("#zEndDate").val());
	params.cBeginDate = $.trim($("#cBeginDate").val());
	params.cEndDate = $.trim($("#cEndDate").val());*/
	params.status = $.trim($("#status").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());

	if(!isNull(params.beginDate)) {
		params.beginDate += " 0:0:0";
	}
	if(!isNull(params.endDate)) {
		params.endDate += " 23:59:59";
	}
	/*if(!isNull(params.zBeginDate)) {
		params.zBeginDate += " 0:0:0";
	}
	if(!isNull(params.zEndDate)) {
		params.zEndDate += " 23:59:59";
	}
	if(!isNull(params.cBeginDate)) {
		params.cBeginDate += " 0:0:0";
	}
	if(!isNull(params.cEndDate)) {
		params.cEndDate += " 23:59:59";
	}*/
	return params;
}

// /*添加回车响应事件*/
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey == 13){
	    openBootstrapShade(true)
		drawTable();
		return false;
	}
});

// /*清空*/
function clearForm() {
	$("#searchForm").clear();
	$("#beginDate").prop("readonly", true);
	$("#endDate").prop("readonly", true);
}
//市场经理与助手专用 清空
function clearForm2(){
    $("#beginDate").val("");
    $("#endDate").val("");
    $("#projectName").val("");
    $("#projectId").val("");
    $("#payCompany").get(0).selectedIndex = 0;
    $("#userId").val("");
    $("#userName").val("");
    $("#generalReimbursType").get(0).selectedIndex = 0;
    $("#status").get(0).selectedIndex = 0;
    $("#beginDate").prop("readonly", true);
    $("#endDate").prop("readonly", true);
}

function openProject(obj) {
    if(isNull($(obj).val())) { // 项目内容为空，则计算其他项目内容
        var project = null;
        var tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");

        if( tr.length > 0 && !isNull($(tr).find("textarea[name='projectName']").val()) ) {
            $(obj).siblings("input[name='projectId']").val($(tr).find("input[name='projectId']").val());
            $(obj).val($(tr).find("textarea[name='projectName']").val());
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

// /*得到部门*/
function getDept(data) {
    if(!isNull(data)) {
        $("#deptId").val(data.id);
        $("#deptName").val(data.name);
        $("#userByDeptDialog").initUserByDeptDialog({
            "callBack":getData
        });
    }
}

function openDept() {
    $("#deptDialog").openDeptDialog();
}

// /*合同*/
function openBargin() {
    $("#barginDialog").openBarginDialog();
}

// /*查看合同详情*/
function viewBargin() {
    var barginProcessInstanceId = $("#barginProcessInstanceId").val();

    var url = "";
    if(barginProcessInstanceId != null && barginProcessInstanceId != ""){
        var param = {
            "processInstanceId": barginProcessInstanceId,
            "page": "manage/sale/barginManage/viewDetail"
        }
        url = web_ctx + "/activiti/process?" + urlEncode(param);
    }

    $("#barginDetailFrame").attr("src", url);
    $("#barginDetailModal").modal("show");
}
// /*得到合同详细信息*/
function getBargin(data) {
    if(!isNull(data) && !$.isEmptyObject(data)) {
        $("#barginId").val(data.id);
        $("#barginProcessInstanceId").val(data.processInstanceId);
        $("#barginCode").val(data.barginCode);
        $("#barginName").val(data.barginName);
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
    var re = /(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    browserInfo.browser = m[1].replace(/version/, "'safari");
    browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
    browserInfo.version = m[2];
}

var currTd = null;
function openDialog(obj) {
    currTd = obj;
    $("#userByDeptDialog").openUserByDeptDialog();
}

function getDeptName() {
    var deptName = $("#deptName").val();
    return deptName;
}

function getDeptName() {
    var name = $("#deptName").val();
    return name;
}

function getData(data) {
    if(!isNull(data) && currTd != null && !$.isEmptyObject(data)) {
        $(currTd).find("input[name='userName']").val(data.name);
        $(currTd).find("input[name='userId']").val(data.id);
    }
}

// /*获取表单数据 */
function getFormData() {
    var json = $("#searchForm").serializeJson();
    var formData = $.extend(true,{},json);
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
    if(!isNull(formdata["zBeginDate"])) {
    	formdata["zBeginDate"] += " 00:00:00";
	}
	if(!isNull(formdata["zEndDate"])) {
		formdata["zEndDate"] += " 23:59:59";
	}
	if(!isNull(formdata["cBeginDate"])) {
		formdata["cBeginDate"] += " 00:00:00";
	}
	if(!isNull(formdata["cEndDate"])) {
		formdata["cEndDate"] += " 23:59:59";
	}
    openBootstrapShade(true)
    submitForm(formdata);
}

function clearProject() {
    $("#projectName").val("");
    $("#projectId").val("");
	//$("#searchForm")[0].reset();
}

///*提交表单*/
function submitForm(formData) {
    $.ajax({
        type:"POST",
        url:web_ctx+"/manage/finance/statisticspay/searchByStatistics",
        contentType: "application/json;charset=UTF-8",
        data: JSON.stringify(formData),
        dataType: "json",
        success:function (data) {
            openBootstrapShade(false);
            if(data.code == 1) {
                $("#reimburse").show();
                $("#reimburseTable_header_content").html("");
                $("#reimburseTable_content_content").html("");
                $("#reimburse_sumMoney").html("");
                $("#function_Button").hide();
                if(data.result["statisticsSelectCondition"].beginDate != null){
                    var beginDate = new Date(data.result["statisticsSelectCondition"].beginDate).format("yyyy-MM-dd");
                }else {
                    var beginDate = "";
                }
                if(data.result["statisticsSelectCondition"].endDate != null){
                    var endDate = new Date(data.result["statisticsSelectCondition"].endDate).format("yyyy-MM-dd");
                }else {
                    var endDate = "";
                }
                if (data.result["statisticsSelectCondition"].companyName != null){
                    var companyName = data.result["statisticsSelectCondition"].companyName;
                }else {
                    var companyName = "";
                }
                if (data.result["statisticsSelectCondition"].deptName != null){
                    var deptName = data.result["statisticsSelectCondition"].deptName;
                }else {
                    var deptName="";
                }
                if(data.result["statisticsSelectCondition"].userName != null){
                    var userName = data.result["statisticsSelectCondition"].userName;
                }else {
                    var userName = "";
                }
                if(beginDate != "" || endDate != "" || companyName != "" || deptName != "" || userName != ""){
                    $("#title").text(beginDate + "至" + endDate + companyName + deptName + userName + "付款统计");
                }
                else {
                    $("#title").text("付款统计");
                }
                var project = 0;
                var sumMoney = 0.00;
                if (data.result["way"] == "project") {
                    $.each(data.result["pay_combination"], function (n, v) {
                        var finPayMainId = "0";
                        var reimburseMainId = "0";
                        var travelMainId = "0";
                        var commonPayMainId = "0";
                        var reimburseOrTravelMainId= "0";
                        if (v.finPayMainId != null) {
                            finPayMainId = v.finPayMainId;
                        }
                        if (v.reimburseMainId != null) {
                            reimburseMainId = v.reimburseMainId;
                        }
                        if (v.travelMainId != null) {
                            travelMainId = v.travelMainId;
                        }
                        if (v.commonPayMainId != null) {
                            commonPayMainId = v.commonPayMainId;
                        }
                        if (v.reimburseOrTravelMainId != null) {
                        	reimburseOrTravelMainId = v.reimburseOrTravelMainId;
                        }
                        var content = "<tr data-toggle='modal' data-target='#singleDetail'" +
                            "onclick='singleDetail(\"" + finPayMainId + "\",\"" + reimburseMainId + "\"," +
                            "\"" + travelMainId + "\"," + "\"" + commonPayMainId + "\"," +
                            "\"" + v.typeName + "\",\""+ v.projectName +"\",\""+ reimburseOrTravelMainId +"\")'>" +
                            "<td style='width: 20%'>" + v.projectName + "</td>" +
                            "<td style='width: 20%;'>" + v.typeName + "</td>" +
                            "<td style='width: 20%;'>" + formatCurrency(v.money) + "</td>" +
                            "<td style='width: 20%;'></td></tr>"
                        if (n == 0) {
                            if (n == data.result["pay_combination"].length - 1) {
                                sumMoney = v.money;
                                var sumContent = "<tr style='font-weight: bold;background-color:#EDEDED;'><td >总计：</td><td></td><td>" + formatCurrency(sumMoney) + "</td><td></td>"
                                $("#reimburseTable_content_content").append(content);
                                $("#reimburseTable_content_content").append(sumContent);
                            } else {
                                $("#reimburseTable_content_content").append(content);
                                project = v.projectId;
                                sumMoney += v.money;
                            }

                        } else if (v.projectId == project) {
                            if (n == data.result["pay_combination"].length - 1) {
                                sumMoney += v.money;
                                var sumContent = "<tr style='font-weight: bold;background-color:#EDEDED;'><td>总计：</td><td></td><td>" + formatCurrency(sumMoney) + "</td><td></td></tr>"
                                $("#reimburseTable_content_content").append(content);
                                $("#reimburseTable_content_content").append(sumContent);

                            } else {
                                $("#reimburseTable_content_content").append(content);
                                sumMoney += v.money;
                            }
                        } else {
                            if (n == data.result["pay_combination"].length - 1) {
                                var sumContent = "<tr style='font-weight: bold;background-color:#EDEDED;'><td>总计：</td><td></td></td><td>" + formatCurrency(sumMoney) + "</td><td></td></tr>"
                                var sumContentLast = "<tr style='font-weight: bold;background-color:#EDEDED;'><td>总计：</td><td></td><td>" + formatCurrency(v.money) + "</td><td></td></tr>"
                                $("#reimburseTable_content_content").append(sumContent);
                                $("#reimburseTable_content_content").append(content);
                                $("#reimburseTable_content_content").append(sumContentLast);

                            } else {
                                var sumContent = "<tr style='font-weight: bold;background-color:#EDEDED;'><td>总计：</td><td></td><td>" + formatCurrency(sumMoney) + "</td><td></td></tr>"
                                $("#reimburseTable_content_content").append(sumContent);
                                $("#reimburseTable_content_content").append(content);
                                project = v.projectId;
                                sumMoney = v.money;
                            }
                        }
                    })
                } else if (data.result["way"] == "type"){
                    var project = "";
                    $.each(data.result["pay_combination"], function (n, v){
                        var finPayMainId = "0";
                        var reimburseMainId = "0";
                        var travelMainId = "0";
                        var commonPayMainId = "0";
                        var reimburseOrTravelMainId = "0";
                        if (v.finPayMainId != null) {
                            finPayMainId = v.finPayMainId;
                        }
                        if (v.reimburseMainId != null) {
                            reimburseMainId = v.reimburseMainId;
                        }
                        if (v.travelMainId != null) {
                            travelMainId = v.travelMainId;
                        }
                        if (v.commonPayMainId != null) {
                            commonPayMainId = v.commonPayMainId;
                        }
                        if (v.reimburseOrTravelMainId != null) {
                        	reimburseOrTravelMainId = v.reimburseOrTravelMainId;
                        }
                      var content="<tr name='node'>" +
                          "<td style='width: 20%;'>"+project+"</td>" +
                          "<td style='width: 20%;'>" +
                          " <input class='selectedTheType' type='checkbox' value='selectedTheType'/>"+v.typeName+"</td>" +
                          "<td style='width: 20%;' name='money'>"+formatCurrency(v.money)+"</td>" +
                          "<td style='width: 20%;' data-toggle='modal' data-target='#singleDetail' " +
                          "onclick='singleDetail(\""+finPayMainId+"\",\""+reimburseMainId+"\",\""+travelMainId+"\"," +
                          "\""+commonPayMainId+"\",\""+ v.typeName +"\",\"\",\""+ reimburseOrTravelMainId +"\")'><button class='btn btn-primary'>详情</button></td>" +
                          "</tr>"
                        $("#reimburseTable_content_content").append(content);
                    })
                    $("#function_Button").html("");
                    $("#function_Button").show();
                    $("#function_Button").append(
                        "<div class='row' style='height: 40px'>" +
                        "<div class='col-xs-6'>" +
                        "<button style='margin-left: 200px' class='btn btn-primary' class='btn btn-primary' onclick='removeTheType()'>不显示已勾选的类别</button>" +
                        "</div>" +
                        "<div class='col-xs-6'>" +
                        "<button style='margin-left: 200px' class='btn btn-primary' class='btn btn-primary' onclick='onlyDisplayTheType()'>只显示已勾选的类别</button>" +
                        "</div>" +
                        "</div>");
                    sumTheMoneyByType();
                }
            } else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        error: function(data) {
            openBootstrapShade(false);
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        },
    });
}
//按照类型显示时计算总数
function sumTheMoneyByType() {
    var total = 0;
    $("tr[name='node']").each(function(index, tr){
        temp = $(tr).find("td[name='money']").text();
        total = digitTool.add(total, rmoney(temp));
    });
    $("#reimburse_sumMoney").html("");
    $("#reimburse_sumMoney").append(
        "<div class='row' style='height: 40px'>" +
        "<div class='col-xs-5' " +
        "   style='font-size: 17px;font-weight:bold;background-color:#EDEDED;height: 29px;'>" +
        "       总计：</div>" +
        "<div class='col-xs-7' " +
        "   style='font-size: 17px;font-weight:bold;background-color:#EDEDED;height: 29px;'>" +
        "<spn style='margin-left: 10%;'>"+formatCurrency(total)+"元</spn></div>" +
        "</div>"
       );

}
//根据勾选的，清除掉已勾选的类型，不在页面进行显示
function removeTheType() {
    $("input:checkbox:checked.selectedTheType").parent().parent().remove();
    sumTheMoneyByType();
}
//根据勾选的，清除掉未勾选的类型，只是显示勾选的类型
function onlyDisplayTheType() {
    $("input:checkbox:not(:checked).selectedTheType").parent().parent().remove();
    sumTheMoneyByType();
}

//用于导出详情的参数
var detailParam = {};
//查找单条的详细记录
function singleDetail(finPayMainId, reimburseMainId, travelMainId, commonPayMainId, typeName, projectName,reimburseOrTravelMainId) {
        $.ajax({
            type:"POST",
            url:web_ctx+"/manage/finance/statisticspay/singleDetailByStatistics",
            data:{
                "finPayMainId":finPayMainId,
                "reimburseMainId":reimburseMainId,
                "travelMainId":travelMainId,
                "commonPayMainId":commonPayMainId,
                "typeName":typeName,
                "projectName":projectName,
                "reimburseOrTravelMainId":reimburseOrTravelMainId,
            },
            dataType:"json",
            success:function (data) {
                if(data.code == 1){
                    $("#modalTitle").html("");
                    $("#singleDetail_content_rows").html("");
                    var project="";
                    var type="";
                    if (data.result["singleDetailProjectName"] != null) {
                        project = data.result["singleDetailProjectName"];
                    }
                    if (data.result["singleDetailTypeName"] != null) {
                        type = data.result["singleDetailTypeName"];
                    }
                    $("#modalTitle").html(project+":"+type+"详细信息");
                    $.each(data.result["contentOfForm"],function (n,v) {
                        var date = "";
                        /*if(v.date != null){
                            date=new Date(v.date).format("yyyy-MM-dd");
                        }*/
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
                        var content ="<div class='row' onclick='toProcess(\""+ v.processInstanceId + "\", \""+ v.commonPayId + "\", \""+ v.commonCollectionId + "\")'><div class='col-xs-2'>"+v.userName+"</div><input name='processInstanceId' value='"+v.processInstanceId+"' hidden><div class='col-xs-2'>"+orderNo+"</div>" +
                            "<div class='col-xs-2'>"+date+"</div><div class='col-xs-2'>"+v.projectName+"</div><div class='col-xs-2'>"+v.reason+"</div>" +
                            "<div class='col-xs-2'>"+money+"</div></div>"
                        $("#singleDetail_content_rows").append(content);
                    })
                    
                	//导出详情参数
					detailParam={
							"finPayMainId":finPayMainId,
				            "reimburseMainId":reimburseMainId,
				            "travelMainId":travelMainId,
				            "commonPayMainId":commonPayMainId,
				            "reimburseOrTravelMainId":reimburseOrTravelMainId,
				            "title":type,
				            "beginDate":$.trim($("#beginDate").val()),
			                "endDate":$.trim($("#endDate").val())
					};
                }else{
                    bootstrapAlert("提示", data.result, 400, null);
                }
            },
            error:function (data) {
                bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
            }

        })
}
//导出详情
function exportDetails(){
	var srcURI = web_ctx+"/manage/finance/statisticspay/exportDetails";
	var exportForm = $("<form>");   
	exportForm.attr('style','display:none');   
	exportForm.attr('target','');
	exportForm.attr('method','post');
	exportForm.attr('action', srcURI);
	exportForm.append("<input type='hidden' name='finPayMainId' value=\""+detailParam['finPayMainId']+"\">");
	exportForm.append("<input type='hidden' name='reimburseMainId' value=\""+detailParam['reimburseMainId']+"\">");
	exportForm.append("<input type='hidden' name='travelMainId' value=\""+detailParam['travelMainId']+"\">");
	exportForm.append("<input type='hidden' name='commonPayMainId' value=\""+detailParam['commonPayMainId']+"\">");
	exportForm.append("<input type='hidden' name='reimburseOrTravelMainId' value=\""+detailParam['reimburseOrTravelMainId']+"\">");
	exportForm.append("<input type='hidden' name='title' value=\""+detailParam['title']+"\">");
	exportForm.append("<input type='hidden' name='beginDate' value=\""+detailParam['beginDate']+"\">");
	exportForm.append("<input type='hidden' name='endDate' value=\""+detailParam['endDate']+"\">");
	$('body').append(exportForm);  
    exportForm.submit(); 
}


//导出excel 表
function exportExcel (){
    var params = getFormData();
    params = urlEncode(params);
    params = params.substring(1);
    var url = web_ctx +  "/manage/finance/statisticspay/exportExcel?" + params;
    $("#excelDownload").attr("src", encodeURI(url));
    // bootstrapAlert("数据导出中","请稍等一下");
}
//导出excel 表 --全部搜索字段
function exportExcel1 (){
    var params = getFormData();
    if(!isNull(params["zBeginDate"]) && !isNull(params["zEndDate"])) {
    	if(!isNull(params["cBeginDate"]) && !isNull(params["cEndDate"])){
    		params = urlEncode(params);
    		params = params.substring(1);
    		var url = web_ctx +  "/manage/finance/statisticspay/exportExcelOne?" + params;
    		$("#excelDownload").attr("src", encodeURI(url));
    		// bootstrapAlert("数据导出中","请稍等一下");
    	}else{
    		 layer.msg('导出详情出纳审批开始时间和结束时间为必填', { offset: '150px' })
    	        return false
    	}
    }else {
        layer.msg('导出详情总经理审批开始时间和结束时间为必填', { offset: '150px' })
        return false
        //alert("导出详情总经理审批开始时间和结束时间必须不为空")
    }

}
//时间格式化
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

function toProcess(processInstanceId, commonPayId, commonCollectionId){
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId
        }
	}else {
        var param = {
            "processInstanceId": processInstanceId
        }
	}
    if(processInstanceId === "undefined" && commonCollectionId === "undefined"){ 
    	window.location.href = web_ctx + "/manage/finance/commonPay/toAddOrEdit?id="+commonPayId;
    }else if(processInstanceId === "undefined" && commonPayId === "undefined"){
    	window.location.href = web_ctx + "/manage/finance/commonReceived/toAddOrEdit?id="+commonCollectionId;
    } else{
    	window.location.href = web_ctx + "/activiti/process2?" + urlEncode(param);
    }
}
