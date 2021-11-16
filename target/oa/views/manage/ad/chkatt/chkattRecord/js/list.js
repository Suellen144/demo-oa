$(function() {
	initIFrame();
	queryAttendanceData();//初始化考勤记录之前查询考勤表是否有数据
//	if(session!='null'){
//		if(session!='false'){
//			initTable();
//		}
//		else{
//			bootstrapAlert("提示", "请先导入考勤数据！", 400, null);
//		}
//	}else{
//		bootstrapAlert("提示", "请先导入考勤数据！", 400, null);
//	}
});

function queryAttendanceData(){
	$.ajax({
	    url: web_ctx+"/manage/ad/attendance/queryAttendanceData",
	    type: "get",
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	    	if(result.length>0){
	    		initTable();//初始化考勤记录表
	    	}else{
	    		bootstrapAlert("提示", "请先在【考勤管理】中导入考勤数据！", 400, null);
	    	}
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	})
}

//============================================导入考勤Excel============================================
function importBtn(){
	$("#btnOK").attr({"disabled":false});
	$("#importModal").modal("show");
}

function importExcel(){
	var index1=$('input[name = "file"]').val().lastIndexOf(".");
	var index2=$('input[name = "file"]').val().length;
	var suffix=$('input[name = "file"]').val().substring(index1+1,index2);//后缀名
	if ($('input[name = "file"]').val() == '') {
		bootstrapAlert("提示", "请选择导入文件！", 400, null);
		return false;
	}
	if($('input[name = "file"]').val() != ''){
		if(suffix.trim()!="xls" && suffix.trim()!="xlsx"){
			bootstrapAlert("提示", "导入文件的扩展名必须为：.xls或.xlsx的文件!", 400, null);
			return false;
		}
	}
	
	var formData = new FormData();
    formData.append("file",$("#file")[0].files[0]);
	$.ajax({
        type: "POST",
        url:ctx+"/manage/ad/attendance/save2",
        data:formData,
        async: true,
        processData : false,//不要去处理发送的数据
        contentType:false,//不要去设置Content-Type请求头
        beforeSend:function(){
        	$("#btnOK").attr({"disabled":true});
	    },
        success: function(data) {
        	var result = $.parseJSON(data.replace("<PRE>","").replace("</PRE>",""));
        	bootstrapAlert("提示", result.msg, 400, null);
            $("#importModal").modal("hide");
            $("#outWork").html("");//清空原来表格中的数据
            initTable();//初始化考勤记录表
            $('#file').val("");//清空选择的文件
        },
        error: function(request) {
        	bootstrapAlert("提示", "导入失败!", 400, null);
        	$('#file').val("");
        }
        
    });
}
//========================================================================================

function initIFrame() {
	var leaveHeight = $("#leave").height();
	$("#leave_iframe").height(leaveHeight);
}

function initTable(){
	$.ajax({
		"type":"POST",
		"url":web_ctx+"/manage/ad/attendance/getList",
		"dataType": "json", 
		"success": function(data) {   
				buildTale(data);
	        },
	     "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
		
		
	});
}

function buildTale(data){
	var map=data.result;
	var result=map['attendanceRecordDTOs'];
	var str="";
	for(var i=0;i<result.length;i++){
		var v=result[i];
		var mapResult=result[i].leaveType;
		var numberLate;
		var layTime;
		/*if(v.deptName=='市场部'){
			numberLate="";
			layTime="";
		}else{*/
			 numberLate=(v.numberLate== 0 ? str : v.numberLate);
			 layTime= (v.layTime== 0 ? str : v.layTime);
		/*}*/
			 
		var calcMoney="";
		var tryOn="";
		/*if((new Date(v.entryTime).format("yyyy-MM"))==( new Date(map['year']+"-"+map['calcMonth']).format("yyyy-MM"))){
			calcMoney=v.schuqin;
		}else{
			calcMoney=(map['saleDays']-mapResult['casualLeave']-map['legal']);
		}*/
		calcMoney=map['legal']+v.schuqin;
		if(mapResult['tryOn']!="0"){
			if(mapResult['tryOn']>v.schuqin){
				tryOn=v.schuqin;
			}else{
				tryOn=mapResult['tryOn']
			}
		}
		if(v.eememberPay==undefined){
			v.eememberPay=0;
		}
		var content = "<tr>" +
    	"<td>"+(i+1)+"</td>" +
        "<td>"+v.deptName+"</td>" +
        "<td>"+v.userNmae+"</td>" +
        "<td>"+new Date(v.entryTime).format("yyyy-MM-dd")+"</td>" +
        "<td>"+numberLate+"</td>" +
        "<td>"+layTime+"</td>" +
        "<td>"+(v.nuPunchCard== 0 ? str : v.nuPunchCard)+"</td>" +
        "<td>"+(v.absent== 0 ? str : v.absent)+"</td>" +
        "<td>"+map['legal']+"</td>" +
        "<td>"+v.schuqin+"</td>" +
        "<td>"+Math.round(v.eememberPay*100)/100+"</td>" +
        "<td>"+(v.thisOverTime== 0 ? str : v.thisOverTime)+"</td>" +
        "<td "+(v.isRest?'style="color: red;"':'')+">"+(v.thisRestTime== 0 ? str : v.thisRestTime)+"</td>" +
        "<td>"+(v.lastRemainTime== 0 ? str : v.lastRemainTime)+"</td>" +
        "<td>"+(v.sumRemainOverTime== 0 ? str : v.sumRemainOverTime)+"</td>" +
        "<td>"+(mapResult['yearLeave']== 0 ? str : mapResult['yearLeave'])+"</td>" +
        "<td>"+(mapResult['lastYearLeave']== 0 ? str : mapResult['lastYearLeave'])+"</td>" +
        "<td>"+(mapResult['thisYearLeave']== 0 ? str : mapResult['thisYearLeave'])+"</td>" +
        "<td>"+(mapResult['shouldYearLeave']== 0 ? str : mapResult['shouldYearLeave'])+"</td>" +
        "<td>"+(mapResult['alreadyYearLeave']== 0 ? str : mapResult['alreadyYearLeave'])+"</td>" +
        "<td>"+(mapResult['residueYearLeave']== 0 ? str : mapResult['residueYearLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['casualLeave']== 0 ? str : mapResult['casualLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['sickLeave']== 0 ? str : mapResult['sickLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['marriageLeave']== 0 ? str : mapResult['marriageLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['maternityLeave']== 0 ? str : mapResult['maternityLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['paternityLeave']== 0 ? str : mapResult['paternityLeave'])+"</td>" +
        "<td "+(v.isLeave?'style="color: red;"':'')+">"+(mapResult['funeralLeave']== 0 ? str : mapResult['funeralLeave'])+"</td>" +
        "<td "+(v.isTrave?'style="color: red;"':'')+">"+(mapResult['traveDays']== 0 ? str : mapResult['traveDays'])+"</td>" +
//        "<td></td>" +
        "<td>"+tryOn+"</td>" +
        "<td>"+(mapResult['positive']== 0 ? str : mapResult['positive'])+"</td>" +
        "<td>"+(mapResult['practice']== 0 ? str : mapResult['practice'])+"</td>" +
        "<td style='color: red;'>"+(v.remarks== '打卡异常' ? str : v.remarks)+"</td>" +
        "</tr>";
		 $("#outWork").append(content);
		 $("#fristTd").html("睿哲科技股份有限公司"+map['year']+"年"+map['calcMonth']+"月考勤统计");
		 $("#secondTd").html("考勤统计时段："+map['beginDate']+"至"+map['endDate']);
		 $("#lastYear").html((map['year']-1)+"累休年假");
		 $("#thirdTd").html("满勤天数："+(map['saleDays']-map['legal']));
		 $("#thisYear").html((map['year'])+"累休年假");
		 $("#shouldYearLeave").html("本年应休年假天数");
		 $("#alreadyYearLeave").html("本年已休年假天数");
		 $("#residueYearLeave").html("本年剩余年假天数");
	}
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

//function exportExcel(){
//	var url = web_ctx +  "/manage/ad/attendance/exportExcel";
//		$("#excelDownload").attr("src", url);
//	
//}
function exportExcel2(){
	var srcURI = web_ctx +  "/manage/ad/attendance/exportExcel2";
	var exportForm = $("<form>");   
	exportForm.attr('style','display:none');   
	exportForm.attr('target','');
	exportForm.attr('method','post');
	exportForm.attr('action', srcURI);
	$('body').append(exportForm);  
    exportForm.submit(); 
}

