var dataTable = null;
var projectObj = null;
var map={};

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
    
    $("#selectCompany option").each(function () {
        var txt = $(this).text(); //获取单个text
        var val = $(this).val(); //获取单个value
        map[val]=txt;
      });
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
function viewBargin(processInstanceId) {
    var barginProcessInstanceId = processInstanceId;

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

//遍历合同list
/*function getBargin(barginList) {
	alert("进入此方法")
    var html = [];
    if(barginList != null && barginList.length > 0) {
        var barginId = [];
        var barginProcessInstanceId = [];
        $(barginList).each(function(index, bargin) {
            barginId.push(bargin.id);
            barginProcessInstanceId.push(bargin.processInstanceId);
            var num = index+1;
            html.push('<input type="button"  name="barginId"  style="margin-left:6px"  value="查看合同详情（'+num+'）" onclick="viewBargin('+bargin.processInstanceId+')" style="border:none;">');
        });
        $("#selectbargin").html(html.join(""));
        $("#barginId").val(barginId.join(", "));
        $("#barginProcessInstanceId").val(barginProcessInstanceId.join(","));
    }else {
        $("#barginId").text("");
        $("#barginProcessInstanceId").val("");
    }
}*/

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
    var formdata=getFormData();
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
        url:web_ctx+"/manage/finance/statisticsBargin/searchByStatistics",
        contentType:"application/json;charset=UTF-8",
        data:JSON.stringify(formdata),
        dataType:"json",
        success:function (data) {
            openBootstrapShade(false);
            if(data.code == 1){
                $("#reimburse").show();
                $("#reimburseTable_header_content").html("");
                $("#reimburseTable_content_content").html("");
              /*  
                if (beginDate != "" || endDate != ""){
                    $("#title").text(beginDate + "至" +endDate + "合同统计");
                }else{
                    $("#title").text("合同统计");
                }*/
                
                $.each(data.result["mapContent"],function (n,v) {
                    var processInstanceId="";
                    var projectManageName="";
                    var barginName="";
                    if(v.processInstanceId != null){
                        processInstanceId = v.processInstanceId;
                    }

                    var beginDate="";
                    if(v.startTime!= null) {
                        beginDate = new Date(v.startTime).format("yyyy-MM-dd");
                    }

                    var endDate="";
                    if(v.endTime != null){
                       endDate = new Date(v.endTime).format("yyyy-MM-dd");
                    }

                    var company="";
                    if(v.company != null){
                    	company=v.company;
                     }

                    var totalMoney="";
                    if(v.totalMoney != null){
                        totalMoney=v.totalMoney;
                    }

                    var projectManageName="";
                    if(v.projectManage != null){
                        projectManageName=v.projectManage.name;
                    }

                    var barginConfirm="";
                    if(v.barginConfirm == '1'){
                        barginConfirm='是';
                    }else if (v.barginConfirm == '0' || v.barginConfirm == "" || v.barginConfirm == null) {
                        barginConfirm='否';
                    }

                    var title=map[v.title];
                    if(v.title=="0"){
                    	title=map['11'];
                    }
                    var content = "<tr onclick='viewBargin(\""+processInstanceId+"\")'>" +
                        "<td style='width: 10%;'>"+v.barginCode+"</td>" +
                        "<td style='width: 8%;'>"+totalMoney+"</td>" +
                        "<td style='width: 10%;'>"+projectManageName+"</td>" +
                        "<td style='width: 10%;'>"+title+"</td>" +
                        "<td style='width: 10%;'>"+company+"</td>" +
                        "<td style='width: 8%;'>"+beginDate+"</td>" +
                        "<td style='width: 8%;'>"+endDate+"</td>" +
                        "<td style='width: 6%;'>"+barginConfirm+"</td>" +
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
    params = urlEncode(params);
    params = params.substring(1);
    var url = web_ctx +  "/manage/finance/statisticsReceived/exportExcel?" + params;
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

