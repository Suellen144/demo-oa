
var type2html = {
	"salaryRecord":getHtmlForSalaryRecord,
	"stationRecord":getHtmlForStationRecord,
	"signRecord":getHtmlForSignRecord,
	"oldworkRecord":getHtmlForOldworkRecord,
	"educationRecord":getHtmlForEducationRecord,
	"honorRecord":getHtmlForHonorRecord
};
var rMenu;
$(function () {
    initSex();
    initnumber();
    rMenu = $("#rMenu");
    initDatetimepicker();
    initDecryption();
    initTd();
	initFileUpload();
})

function initnumber(){
	var id=$("#number").text();
	var number="";
	if(id<10){
		number="000"+id;
	}else if(id>=10 && id<99){
		number="00"+id;
	}else if(id>=100 && id<999){
		number="0"+id;
	}else{
		number=id;
	}
	$("#number").text(number);
}
function hiddenall() {
    bootstrapConfirm("提示","执行此操作后无法再次更改表格，确定吗？",300,function () {
    	$("td").prop("contentEditable",false);
    	$("#BuSelect")[0].style.display = 'none';
        $("#button3")[0].style.display = 'none';
        $("select").prop("disabled","disabled");
        getSameData();
        $("#recordImg").attr("onclick","");
        checkTable();
    });
}

function checkTable(){
	
	$("tr[name='salary").each(function(){
		if($(this).find("span[name='total']").text()==""){
			$(this).hide();
		}
	})
	
	if($("#tbSal tr:visible").length==1){
		$("thead[name='tableSale']").hide();
		$("tbody[name='tableSale']").hide();
	}
	$("tr[name='station").each(function(){
		if($(this).find("select[name='postAppointmentDept'] option:selected").text()==""||
				$(this).find("select[name='postAppointmentCompany'] option:selected").text()==""||
				$(this).find("select[name='station'] option:selected").text()==""||
				$(this).find("select[name='appoint'] option:selected").text()==""
		){
			$(this).hide();
		}
	})
	
	if($("#tbStation tr:visible").length==1){
		$("thead[name='tableStation']").hide();
		$("tbody[name='tableStation']").hide();
	}
	
	
	$("tr[name='sign").each(function(){
		if($(this).find("select[name='barginType'] option:selected").text()==""||$(this).find("input[name='beginDate']")==""||$(this).find("input[name='endDate']")==""){
			$(this).hide();
		}
	})
	
	if($("#tbSign tr:visible").length==1){
		$("thead[name='tableSing']").hide();
		$("tbody[name='tableSing']").hide();
	}
	
	$("tr[name='oldwork").each(function(){
		if($(this).find("input[name='beginDate']")==""||$(this).find("input[name='endDate']")==""||$(this).find("td[name='company']").text()==""||$(this).find("td[name='station']").text()==""){
			$(this).hide();
		}
	})
	
	if($("#tbOld tr:visible").length==1){
		$("thead[name='tableOld']").hide();
		$("tbody[name='tableOld']").hide();
	}
	
	
	$("tr[name='education").each(function(){
		if($(this).find("select[name='educationEducation'] option:selected").text()==""||$(this).find("td[name='school']").text()==""
				||$(this).find("td[name='major']").text()==""){
			$(this).hide();
		}
	})
	
	if($("#tbEducation tr:visible").length==1){
		$("thead[name='tableEducation']").hide();
		$("tbody[name='tableEducation']").hide();
	}
	
	
	$("tr[name='honor").each(function(){
		if($(this).find("td[name='issuingUnit']").text()==""||$(this).find("input[name='scanName']").val()==""){
			$(this).hide();
		}
	})
	
	if($("#tbHonor tr:visible").length==1){
		$("thead[name='tableHonor']").hide();
		$("tbody[name='tableHonor']").hide();
	}
	
}



function initSex() {
	if($("#sex").val()=='0') {
		$("#sexName").text("男");
	}
	if($("#sex").val()=='1'){
		$("#sexName").text("女");
	}
}

//身份证校验

function idCardCheck() {
    //获取输入身份证号码
    var ic = $("#idcard").text();
    if(IdCardValidate(ic)){
        var ic = String(ic);
        //获取出生日期
        var birth = ic.substring(6, 10) + "-" + ic.substring(10, 12) + "-" + ic.substring(12, 14);
        if ($("#birthday").text()==""){
            $("#birthday").text(birth);
        }
        //获取性别
        var gender = ic.slice(14, 17) % 2 ? "1" : "2"; // 1代表男性，2代表女性
        $("#sex").empty();
        if(gender==1){
            $("#sex").val(0);
            $("#sexName").text("男");

        }else {
            $("#sex").val(1);
            $("#sexName").text("女");
        }
    }
}

var Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 ];    // 加权因子
var ValideCode = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ];            // 身份证验证位值.10代表X
function IdCardValidate(idCard) {
    idCard = trim(idCard.replace(/ /g, ""));               //去掉字符串头尾空格
    if (idCard.length == 15) {
        return isValidityBrithBy15IdCard(idCard);       //进行15位身份证的验证
    } else if (idCard.length == 18) {
        var a_idCard = idCard.split("");                // 得到身份证数组
        if(isValidityBrithBy18IdCard(idCard)&&isTrueValidateCodeBy18IdCard(a_idCard)){   //进行18位身份证的基本验证和第18位的验证
            return true;
        }else {
            return false;
        }
    } else {
        return false;
    }
}
/**
 * 判断身份证号码为18位时最后的验证位是否正确
 * @param a_idCard 身份证号码数组
 * @return
 */
function isTrueValidateCodeBy18IdCard(a_idCard) {
    var sum = 0;                             // 声明加权求和变量
    if (a_idCard[17].toLowerCase() == 'x') {
        a_idCard[17] = 10;                    // 将最后位为x的验证码替换为10方便后续操作
    }
    for ( var i = 0; i < 17; i++) {
        sum += Wi[i] * a_idCard[i];            // 加权求和
    }
    valCodePosition = sum % 11;                // 得到验证码所位置
    if (a_idCard[17] == ValideCode[valCodePosition]) {
        return true;
    } else {
        return false;
    }
}
/**
 * 验证18位数身份证号码中的生日是否是有效生日
 * @param idCard 18位书身份证字符串
 * @return
 */
function isValidityBrithBy18IdCard(idCard18){
    var year =  idCard18.substring(6,10);
    var month = idCard18.substring(10,12);
    var day = idCard18.substring(12,14);
    var temp_date = new Date(year,parseFloat(month)-1,parseFloat(day));
    // 这里用getFullYear()获取年份，避免千年虫问题
    if(temp_date.getFullYear()!=parseFloat(year)
        ||temp_date.getMonth()!=parseFloat(month)-1
        ||temp_date.getDate()!=parseFloat(day)){
        return false;
    }else{
        return true;
    }
}
/**
 * 验证15位数身份证号码中的生日是否是有效生日
 * @param idCard15 15位书身份证字符串
 * @return
 */
function isValidityBrithBy15IdCard(idCard15){
    var year =  idCard15.substring(6,8);
    var month = idCard15.substring(8,10);
    var day = idCard15.substring(10,12);
    var temp_date = new Date(year,parseFloat(month)-1,parseFloat(day));
    // 对于老身份证中的你年龄则不需考虑千年虫问题而使用getYear()方法
    if(temp_date.getYear()!=parseFloat(year)
        ||temp_date.getMonth()!=parseFloat(month)-1
        ||temp_date.getDate()!=parseFloat(day)){
        return false;
    }else{
        return true;
    }
}

//右键操作
$("tbody").find("tr[name='honor'],tr[name='education'],tr[name='oldwork'],tr[name='sign'],tr[name='station'],tr[name='salary']").each(function(index,tr){
	$(tr).mousedown(function(e){
	    if(3 == e.which){
	    	rightClick();
	   }
	})
})



//动态添加节点处理函数
function addnode(type, obj) {
     var fun = type2html[type];
     var html = fun.call();
     $(obj).after(html);
     hideRMenu(obj);
}

function delnode(obj){
	 var tr = $(obj).remove();
	 hideRMenu(obj);
}




function rightClick() {
		$.contextMenu({
	    	selector: '.level0',
	           callback: function(key, options) {
		            switch(key) {
		                case 'addnode': addnode($(this).find("input[name='flag']").val(),$(this)); break ;
		            }
	        },
	        items: {
	        	"addnode":{ name: "新增", icon: "add" },
	        }
	    });
		
		$.contextMenu({
	    	selector: '.level1',
	           callback: function(key, options) {
		            switch(key) {
		                case 'addnode': addnode($(this).find("input[name='flag']").val(),$(this)); break ;
		                case 'delnode': delnode($(this)); break ;
		            }
	        },
	        items: {
	        	"addnode":{ name: "新增", icon: "add" },
	        	"delnode":{ name: "删除", icon: "delete" },
	        }
	    });
}

/*隐藏右键菜单*/
function hideRMenu(obj) {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$(obj).unbind("mousedown", onBodyMouseDown);
}


function onBodyMouseDown(event) {
	if ( !(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0) ) {
		rMenu.css({"visibility" : "hidden"});
	}
}


//薪酬调整记录
function getHtmlForSalaryRecord(){
  var html = [];
  html.push('<tr name="salary" class="level1">');
  html.push('<input type="hidden" name="payAdjustmentId" value=""> <input type="hidden"  name="flag" value="salaryRecord">');
  html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="changeDate" class="changeDate" readonly></td>');
  html.push('	<td style="width: 6%;" name="basePay" contentEditable="true"></td>');
  html.push('	<td style="width: 6%;" name="meritPay" contentEditable="true"></td>');
  html.push('	<td style="width: 6%;" name="agePay" contentEditable="true"></td>');
  html.push('	<td style="width: 6%;" name="lunchSubsidy" contentEditable="true"></td>');
  html.push('	<td style="width: 5%;"  name="computerSubsidy" contentEditable="true"></td>');
  html.push('	<td style="width: 5%;"  name="accumulationFund" contentEditable="true"></td>');
  html.push('	<td style="width: 5%;" name="total" contentEditable="true"></td>');
  html.push('	<td style="width: 18%;" contentEditable="true"></td>');
  html.push('</tr>');

  return html.join("");
}

//岗位调整记录
function getHtmlForStationRecord(){
  var html = [];
  html.push('<tr name="station" class="level1">');
  html.push('<input type="hidden" name="postAppointmentId" value=""><input type="hidden"  name="flag" value="stationRecord">');
  html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="postDate" class="postDate" readonly></td>');
  html.push('	<td style="width: 12%;"><select name="postAppointmentCompany" style="width:100%;test-align-last:center"> <option value=""></option>'+$("#company_hidden").html()+'</select></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="postAppointmentDept"> <option value=""></option>'+$("#dept_hidden").html()+'</select></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="postAppointmentProjectTeam"> <option value=""></option>'+$("#projectTeam_hidden").html()+'</select></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="station"> <option value=""></option>'+$("#station_hidden").html()+'</select></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="appoint"> <option value=""></option>'+$("#appoint_hidden").html()+'</select></td>');
  html.push('	<td style="width: 18%;" contentEditable="true"></td>');
  html.push('</tr>');

  return html.join("");
}

//劳动合同签约记录
function getHtmlForSignRecord(){
  var html = [];
  html.push('<tr name="sign" class="level1">');
  html.push('<input type="hidden" name="arbeitsvertragId" value=""> <input type="hidden"  name="flag" value="signRecord">');
  html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="signDate" class="signDate" readonly></td>');
  html.push('	<td style="width: 12%;"><select name="arbeitsvertragCompany" style="width:100%;test-align-last:center"> <option value=""></option>'+$("#company_hidden").html()+'</select></td>');
  html.push('	<td style="width: 12%;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
  html.push('	<td style="width: 10%;"><input type="text" name="endDate" class="endDate" readonly></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="barginType"> <option value=""></option>'+$("#barginType_hidden").html()+'</select></td>');
  html.push('	<td style="width: 18%;" contentEditable="true"></td>');
  html.push('</tr>');

  return html.join("");
}

//以往工作记录
function getHtmlForOldworkRecord(){
  var html = [];
  html.push('<tr name="oldwork" class="level1">');
  html.push('<input type="hidden" name="jobRecordId" value=""><input type="hidden"  name="flag" value="oldworkRecord">');
  html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
  html.push('	<td style="width: 6.8%;"><input type="text" name="endDate" class="endDate" readonly></td>');
  html.push('	<td style="width: 27.2%;" contentEditable="true"></td>');
  html.push('	<td style="width: 5%;" contentEditable="true"></td>');
  html.push('	<td style="width: 18%;"  contentEditable="true"></td>');
  html.push('</tr>');

  return html.join("");
}

//教育背景
function getHtmlForEducationRecord(){
  var html = [];
  html.push('<tr name="education" class="level1">');
  html.push('<input type="hidden" name="educationId" value=""><input type="hidden"  name="flag" value="educationRecord">');
  html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="beginDate" class="beginDate" readonly></td>');
  html.push('	<td style="width: 6.8%;"><input type="text" name="endDate" class="endDate" readonly></td>');
  html.push('	<td style="width: 12.2%;" contentEditable="true"></td>');
  html.push('	<td style="width: 20%;" contentEditable="true"></td>');
  html.push('	<td style="width: 9%;" contentEditable="true"></td>');
  html.push('	<td style="width: 3%;"><select style="width:100%;" name="educationEducation"> <option value=""></option>'+$("#education_hidden").html()+'</select></td>');
  html.push('</tr>');

  return html.join("");
}

//荣誉/证书
function getHtmlForHonorRecord(){
  var html = [];
  html.push('<tr name="honor" class="clHonor level1">');
  html.push('<input type="hidden" name="certificateId" value=""><input type="hidden"  name="flag" value="honorRecord">');
  html.push('	<td style="width: 8%;"><input type="text"  class="validity" name="date" readonly></td>');
  html.push('	<td style="width: 12%;" contentEditable="true"></td>');
  html.push('	<td style="width: 12%;" contentEditable="true"></td>');
  html.push('	<td style="width: 9%;"><input type="text"  class="validity" name="validity" readonly></td>');
  html.push('	<td style="width: 25%;"> <input type="text"  name="scanName" style="width:auto"  value="" readonly onclick="selectScan(this)" placeholder="选择扫描件"> <input type="file"  name="scanFile" style="display:none;"></td>');
  html.push('</tr>');

  return html.join("");
}

function initDatetimepicker() {
    $("input.datetimepicker").datetimepicker({
        minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true
    });

    $(".changeDate,.postDate,.signDate,.beginDate,.endDate,.date,.validity").datetimepicker({
        minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true
	})

	$(".become_date,.leaveTime,.birthday").datetimepicker({
		language: "zh-CN",
		format: 'yyyy-mm-dd',
        showMeridian: true,
        autoclose: true,
        todayBtn: true,
        bootcssVer:3,
        minView: 2
    });




	$(".leaveTime").datetimepicker({
		language:"zh-CN",
		format: 'yyyy-mm-dd',
        showMeridian: true ,
        bootcssVer:3,
        autoclose: true,
        minView: 2
    }).on('changeDate',function(e){
        var leaveTime = e.date;
       /* $(".entryTime").datetimepicker('setEndDate',leaveTime);*/
    });

	$(".work_begin_date").datetimepicker({
		language:"zh-CN",
		format: 'yyyy-mm-dd',
        showMeridian: true,
        bootcssVer:3,
        autoclose: true,
        minView: 2
    }).on('changeDate',function(e){
        var work_begin_date = e.date;
        $(".work_end_date").datetimepicker('setStartDate',work_begin_date);
    });

	$(".work_end_date").datetimepicker({
		language:"zh-CN",
		format: 'yyyy-mm-dd',
        showMeridian: true ,
        bootcssVer:3,
        autoclose: true,
        minView: 2
    }).on('changeDate',function(e){
        var work_end_date = e.date;
        $(".work_start_date").datetimepicker('setEndDate',work_end_date);
    });
}




var key="";
function initTd(){
	var tr=$('#tbSal tr:last');
	$("tr[name='salary']").each(function (index,tr){
		$(tr).find("td[name='total']").attr('contentEditable', true);
	})
	if($(tr).find("td[name='total']").text()!=""){
	if(key==""||key==null){
		$("tr[name='salary']").each(function(index,tr){
			$(tr).find("td[name='basePay'],td[name='meritPay'],td[name='agePay'],td[name='lunchSubsidy'],td[name='computerSubsidy'],td[name='accumulationFund']").attr('contentEditable', true);
		})
	}else{
		$("tr[name='salary']").each(function(){
			$(tr).find("td[name='basePay'],td[name='meritPay'],td[name='agePay'],td[name='lunchSubsidy'],td[name='computerSubsidy'],td[name='accumulationFund']").removeAttr('contentEditable');
		})
	}
	}
}



/************* 加解密操作 Begin **************/
//如果有解密权限，则解密当前已加密的数据
function initDecryption() {
			if( hasDecryptPermission ) {
				var now = new Date().pattern("yyyyMMdd");
				$.ajax({
					url: web_ctx+'/manage/getEncryptionKey?baseKey='+now,
					type: 'GET',
					success: function(data) {
						if(data.code == 1) {
							var tempKey = data.result;
							var encryptionKey = aesUtils.decryptECB(tempKey, now);
							key=encryptionKey;
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

function encryptPageText(encryptionKey) {
	
	$("tr[name='salary']").each(function (index,tr){
		var total=$(tr).find("td[name='total']").text();
		var basePay=$(tr).find("td[name='basePay']").text();
		var meritPay=$(tr).find("td[name='meritPay']").text();
			total=aesUtils.decryptECB(total, encryptionKey);
			basePay = aesUtils.decryptECB(basePay, encryptionKey);
			meritPay=aesUtils.decryptECB(meritPay, encryptionKey);
			if( !isNull(total) ) {
				$(tr).find("td[name='total']").text(total);
			}
			if( !isNull(basePay) ) {
				$(tr).find("td[name='basePay']").text(basePay);
			}
			if( !isNull(meritPay) ) {
				$(tr).find("td[name='meritPay']").text(meritPay);
			}
	})
}
function disabledEncryptPageText() {
	$("#salary").prop("readonly", true);
}

/************* 加解密操作 End **************/


function findLastData(){
	var leng = $("#tbStation tr").length; 
	var indexTr;
	var resultTime=$("#tbStation tr").eq(leng-1).find("input[name='postDate']").val();
	for(var i=leng-1; i>=0; i--)  
    {  
        var tr = $("#tbStation tr").eq(i)
        var result=$(tr).find("select[name='appoint'] option:selected").text()
        var dateFlag=$(tr).find("input[name='postDate']").val()
        if(result!="兼任"&&resultTime<=dateFlag){
        	indexTr=tr;
        	resultTime=dateFlag;
        }
    }  
	return indexTr;
}
function findSignLastData(){
	var leng = $("#tbSign tr").length;
	var indexTr;
	var resultTime=$("#tbSign tr").eq(leng-1).find("input[name='beginDate']").val();
	for(var i=leng-1; i>=0; i--)
	{
		var tr = $("#tbSign tr").eq(i)
		var dateFlag=$(tr).find("input[name='beginDate']").val()
		if(resultTime<=dateFlag){
			indexTr=tr;
			resultTime=dateFlag;
		}
	}
	return indexTr;
}


function findEduLastData(){
	var leng = $("#tbEducation tr").length;
	var indexTr;
	var result=$("#tbEducation tr").eq(leng-1).find("select[name='educationEducation']").val();
	for(var i=leng-1; i>=0; i--)
	{
		var tr = $("#tbEducation tr").eq(i)
		var Flag=$(tr).find("select[name='educationEducation']").val()
		if(result>=Flag){
			indexTr=tr;
			result=Flag;
		}
	}
	return indexTr;
}


function getSameData(){
	var tr=findLastData();
	if($(tr).find("input[name='postDate']").val()!=""){
	if($(tr).find("select[name='postAppointmentDept'] option:selected").text()!=""){
		$("#table1").find("td[name='dept']").text($(tr).find("select[name='postAppointmentDept'] option:selected").text());
		/*$("#deptId").val($(tr).find("select[name='postAppointmentDept'] option:selected").val());
		$("#deptName").text($(tr).find("select[name='postAppointmentDept'] option:selected").text());*/
	}
	if($(tr).find("select[name='postAppointmentCompany'] option:selected").text()!=""){
		$("#table1").find("td[name='company']").text($(tr).find("select[name='postAppointmentCompany'] option:selected").text());
	}
	if($(tr).find("select[name='postAppointmentProjectTeam'] option:selected").text()!=""){
		$("#table1").find("td[name='projectTeam']").text($(tr).find("select[name='postAppointmentProjectTeam'] option:selected").text());
	}
	if($(tr).find("select[name='station'] option:selected").text()!=""){
		$("#table1").find("td[name='position']").text($(tr).find("select[name='station'] option:selected").text());
		/*$("#positionId").val($(tr).find("select[name='station'] option:selected").val());
		$("#positionName").text($(tr).find("select[name='station'] option:selected").text());*/
		}
	}
	var tr1=findEduLastData();
	
	if($(tr1).find("td[name='educationMajor']").text()!=""){
		$("#table1").find("td[name='major']").text($(tr1).find("td[name='educationMajor']").text());
	}
	if($(tr1).find("td[name='educationSchool']").text()!=""){
		$("#table1").find("td[name='school']").text($(tr1).find("td[name='educationSchool']").text());
	}
	
	if($(tr1).find("select[name='educationEducation'] option:selected").text()!=""){
		$("#table1").find("td[name='education']").text($(tr1).find("select[name='educationEducation'] option:selected").text());
	}
	var tr2=findSignLastData();
	if($(tr2).find("input[name='beginDate']").val()!=""){
		$("#table1").find("td[name='entryTime']").text($(tr2).find("input[name='beginDate']").val());
	}
}

function select(){
    var ie=navigator.appName=="Microsoft Internet Explorer" ? true : false;
    if(ie){
    document.getElementById("file").click();
    }else{
    var a=document.createEvent("MouseEvents");
    a.initEvent("click", true, true);
    document.getElementById("file").dispatchEvent(a);
    }
}

//档案图片上传
var fileData = null;
var urlParam = "";
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "recordImg/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};

	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        acceptFileTypes: /(gif|jpe?g|png)$/i,
        fileTypes: /(gif|jpe?g|png)$/i,
        maxFileSize: 50000000, // 50 MB
       /* add: function (e, data) {
        	fileData = data;
        	$("#imgName").text(data.files[0].name);
        },*/
        done: function (e, data) {
        	var result = data.result;
        	if(result.execResult.code != 0) {
    			params["deleteFile"] = result.path;
    			urlParam = urlEncode(params);
    			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
    			$("#file").fileupload("option", "formData", urlParam);
    			$("#imgName").text(result.originName);
        		$("#photo").val(result.path);
        		$("#photPath").val(result.path);
        		$("#recordImg").attr("src", web_ctx+result.path);
        		//savedata();
        	} else {
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}

//证书扫描件上传
var urlParam1 = "";
function initRecordUpload() {
	var date = new Date();
	var params = {
		"path" : "certificate/" + date.getFullYear() + (date.getMonth() + 1)
				+ date.getDate()
	};

	urlParam1 = urlEncode(params);
	
		$(indexTr).find("input[name='scanFile']").fileupload(
				{
					url : web_ctx + '/fileUpload?' + urlParam1,
					dataType : 'json',
					formData : params,
					maxFileSize : 50 * 1024 * 1024, // 50 MB
					messages : {
						maxFileSize : '附件大小最大为50M！'
					},
					done : function(e, data) {
						var result = data.result;
						if (result.execResult.code != 0) {
							// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
							/*params["deleteFile"] = result.path;
							urlParam1 = urlEncode(params);*/
							$(indexTr).find("input[name='scanfile']").fileupload("option", "url",
									(web_ctx + '/fileUpload?' + urlParam1));
							$(indexTr).find("input[name='scanfile']").fileupload("option", "formData", urlParam1);
							$(indexTr).find("input[name='scanName']").val(result.originName);
						} else {
							openBootstrapShade(false);
							bootstrapAlert("提示", "保存文件失败，错误信息："
									+ result.execResult.result, 400, null);
						}
					}
				});
}

var indexTr="";
function selectScan(obj){
    var ie=navigator.appName=="Microsoft Internet Explorer" ? true : false;
    var tr=$(obj).parent().parent();
    indexTr=tr;
    if(ie){
    	$(tr).find("input[name='scanFile']").click();
       // document.getElementById("scanFile").click();
    }else{
        var a=document.createEvent("MouseEvents");
        a.initEvent("click", true, true);
        
        $(tr).find("input[name='scanFile']").trigger('click');
        initRecordUpload();
       // document.getElementById("scanFile").dispatchEvent(a);
    }
}

