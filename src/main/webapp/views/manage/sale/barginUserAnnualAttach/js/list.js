$(function () {
    initInputMask();
    // initCountAnnualCommission();
})

function save() {
    var formData = getFormJson();
    var checkMsg = checkForm(formData);
    if (!isNull(checkMsg)){
        bootstrapAlert("提示",checkMsg.join("<br/>"), 400, null);
        return;
    }else {
        openBootstrapShade(true);
        saveInfo(formData);
    }
}

function getFormJson() {
    var json = $("#form1").serializeJson();
    var formData = $.extend(true, {}, json);
    formData["barginAttachs"] = [];
    var id = $("#annual_id").val();
    formData["id"]=id;
    $("tbody").find("tr[name='node']").each(function(index, tr) {
        var id = $(this).find("input[name='attachId']").val();
        var barginId = $(this).find("input[name='barginId']").val();
        var barginName = $(this).find("input[name='barginName']").val();
        var barginAnnualPay = $(this).find("input[name='barginAnnualPay']").val();
        var barginAnnualIncome = $(this).find("input[name='barginAnnualIncome']").val();
        var barginAnnualCommissionPercent = $(this).find("input[name='barginAnnualCommissionPercent']").val();
        var barginAnnualCommission = $(this).find("input[name='barginAnnualCommission']").val();
        var commissionId = $(this).find("input[name='commissionId']").val();
        var barginAnnual = $("#annual").val();
        // 其中一个有值就算有效表单数据
        if(!isNull(id) || !isNull(barginId) || !isNull(barginName)
            || !isNull(barginAnnualPay) || !isNull(barginAnnualIncome)
            || !isNull(barginAnnualIncome) || !isNull(barginAnnualCommission)){
            var data = {};
            data["id"] = id;
            data["barginId"] = barginId;
            data["barginName"] = barginName;
            data["commissionId"] = commissionId;
            data["barginAnnualPay"] = barginAnnualPay;
            data["barginAnnualIncome"] = barginAnnualIncome;
            data["barginAnnualCommissionPercent"] = barginAnnualCommissionPercent;
            data["barginAnnualCommission"] = barginAnnualCommission;
            data["barginAnnual"] = barginAnnual;
            formData["barginAttachs"].push(data);
        }
    });
    return formData;
}

function saveInfo(formData) {
    $.ajax({
        url:"/manage/sale/barginUserAnnualAttach/saveInfo",
        type:"post",
        contentType:"application/json;charset=UTF-8",
        data:JSON.stringify(formData),
        dataType:"json",
        success:function (data) {
            if (data.code==1){
                openBootstrapShade(false);
                backPageAndRefresh();
            }else {
                bootstrapAlert("提示", data.result, 400, null);
            }

        },
        error:function (data) {
            openBootstrapShade(false);
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    })
}

var onclickTr;
function writePersion(tr){
    onclickTr="";
    onclickTr=tr;
    var attachId=$(tr).prev().val();
    var barginAnnualCommissionModel=$(tr).parent().prev().find("input[name='barginAnnualCommission']").val();
    $.ajax({
        url:"/manage/sale/commissionAttach/getUserList",
        data:{
            "id":attachId,
        },
        type:"post",
        dataType:"json",
        success:function (data) {
            $("#user_content").html("");
            $("#commissionId").val("");
           if (data.code==1){
                $.each(data.result,function (n,v) {
                    var userCommission ;
                    var commissionAttachId;
                    var userCommissionPercent;
                    if(v.userCommission == null){
                        userCommission="";
                    }else {
                        userCommission=v.userCommission;
                    }
                    if(v.id == null){
                        commissionAttachId="";
                    }else {
                        commissionAttachId=v.id;
                    }
                    if (v.userCommissionPercent == null){
                        userCommissionPercent="";
                    }else {
                        userCommissionPercent=v.userCommissionPercent;
                    }
                    var commissionId = $("#commissionId").val();
                    if(commissionId == '' || commissionId == null){
                        if (v.commissionId != null) {
                            $("#commissionId").val(v.commissionId);
                        }
                    }
                    var content =
                        "<tr name='writeUser'>" +
                        "<td style='width: 25%'><input style='width: 100%' name='deptName' value='"+v.deptName+"' type='text' readonly>" +
                        "                       <input name='deptId' value='"+v.deptId+"' type='hidden'>" +
                        "</td>" +
                        "<td style='width: 25%'><input style='width: 100%' name='userName' value='"+v.userName+"' type='text' readonly>" +
                        "                       <input name='userId' value='"+v.userId+"' type='hidden'></td>" +
                        "<td style='width: 25%'><input style='width: 100%' name='userCommissionPercent' value='"+userCommissionPercent+"' type='text'>" +
                        "                       <input name='barginAnnualCommissionModel' value='"+barginAnnualCommissionModel+"' type='hidden'></td>" +
                        "<td style='width: 25%'><input style='width: 100%' name='userCommission' value='"+userCommission+"' type='text'>" +
                        "                       <input name='commissionAttachId' value='"+commissionAttachId+"' type='hidden'>" +
                        "</td>" +
                        "</tr>"
                    $("#user_content").append(content);
                });

               $("#user_content").find("tr[name='writeUser']").find("input").each(function (index,input) {
                   var name = $(input).attr("name");
                   if(name == "userCommissionPercent"){
                       $(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
                   }
               });
               countPersonCommission();
           }
        },
        error:function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    })
}

function savePersonCommission() {
    openBootstrapShade(true);
    var formData=getPersonForme();
    $.ajax({
        url:"/manage/sale/commissionAttach/saveUserList",
        type:"post",
        contentType:"application/json;charset=UTF-8",
        data:JSON.stringify(formData),
        dataType:"json",
        success:function (data) {
            if(data.code==1){
                bootstrapAlert("提示","保存数据成功");
                openBootstrapShade(false);
                $(onclickTr).prev().val(data.result.id);
            }
        },
        error:function (data) {
            openBootstrapShade(false);
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    })
    
}

function getPersonForme() {
    var json = $("#form2").serializeJson();
    var formData2= $.extend(true, {}, json);
    formData2["commissionAttachList"] = [];
    var id = $("#commissionId").val();
    formData2["id"]=id;
    $("#user_content").find("tr[name='writeUser']").each(function (index,tr) {
       var id = $(this).find("input[name='commissionAttachId']").val();
       var deptId = $(this).find("input[name='deptId']").val();
       var deptName = $(this).find("input[name='deptName']").val();
       var userId = $(this).find("input[name='userId']").val();
       var userName = $(this).find("input[name='userName']").val();
       var userCommissionPercent= $(this).find("input[name='userCommissionPercent']").val();
       var userCommission = $(this).find("input[name='userCommission']").val();
       var data = {};
       data["id"] = id ;
       data["deptId"] = deptId;
       data["deptName"] = deptName;
       data["userId"] = userId;
       data["userName"] = userName;
       data["userCommissionPercent"] = userCommissionPercent;
       data["userCommission"] = userCommission;
       formData2["commissionAttachList"].push(data);
    });
    return formData2;
}

//初始化输入框约束
function initInputMask() {
    $("#annual").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
    $("tbody").find("tr[name='node']").find("input").each(function(index,input){
       var name = $(input).attr("name");
       if(name == "barginAnnualPay"
           || name == "barginAnnualIncome"
           || name == "barginAnnualCommissionPercent"){
           $(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
       }
    });
}

//页面元素检查
function checkForm(formData) {
    var checkMsg = [];
    var annual=$("#annual").val();
    if (annual == "" || annual == null){
        checkMsg.push("合同年度不能为空！");
        return checkMsg;
    }
}

//计算每行的年度提成
function initCountAnnualCommission(thisInput) {
    $(thisInput).parent().parent().each(function (index,input) {
        var barginAnnualPay = $(this).find("input[name='barginAnnualPay']").val();
        var barginAnnualIncome = $(this).find("input[name='barginAnnualIncome']").val();
        var barginAnnualCommissionPercent = $(this).find("input[name='barginAnnualCommissionPercent']").val();
        if ((barginAnnualPay!=null||barginAnnualPay!="")
                &&(barginAnnualIncome!=null||barginAnnualIncome!="")
                &&(barginAnnualCommissionPercent != null || barginAnnualCommissionPercent!="")){
            var barginAnnualCommission =(barginAnnualIncome-barginAnnualPay)*(barginAnnualCommissionPercent*0.01);
            $(this).find("input[name='barginAnnualCommission']").val(barginAnnualCommission);
        }
    })
}

//计算个人年度提成
function countPersonCommission() {
    $("#user_content").find("tr[name='writeUser']").each(function (index,tr){
        $(this).find("input[name='userCommissionPercent']").attr("onkeyup","countPersonCommissionWay('"+index+"')");
    });
}

function countPersonCommissionWay(oldIndex) {
    $("#user_content").find("tr[name='writeUser']").each(function (index,tr){
        if(index==oldIndex){
            var userCommission;
            var barginAnnualCommissionModel;
            var userCommissionPercentModel;
            if ($(this).find("input[name='userCommissionPercent']").next().val()==null ||
                $(this).find("input[name='userCommissionPercent']").next().val()==""){
                barginAnnualCommissionModel=0;
            }else{
                barginAnnualCommissionModel
                    =$(this).find("input[name='userCommissionPercent']").next().val();
            }
            if($(this).find("input[name='userCommissionPercent']").val()==null ||
               $(this).find("input[name='userCommissionPercent']").val()==""){
                userCommissionPercentModel=0;
            }else {
                userCommissionPercentModel
                    =$(this).find("input[name='userCommissionPercent']").val();
            }
            userCommission=(barginAnnualCommissionModel)*(userCommissionPercentModel)*0.01;
            $(this).find("input[name='userCommission']").val(userCommission)
            return false;
        }
    })



}