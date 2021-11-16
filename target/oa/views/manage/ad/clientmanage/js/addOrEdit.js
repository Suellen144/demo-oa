var currTd = null;
$(function() {
	inittextarea();
	initInputMask();
/*	initMarketInfo();*/
	$("#userDialog").initUserDialog({
		"callBack": getData
	});
	$("#projectDialog").initProjectDialog({
		"callBack": getProjectData
	});
});


function initInputMask() {
	$("input").each(function(index, input) {
		var name = $(input).attr("name");
		if(name == "clientPhone") {
			//$(input).inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
			$(input).inputmask({ "mask": "9{11}" });
		}
	});
}


function showProject(){
	//$("#projectdiv")[0].style.display = "block";
	//$("#show").attr("class","");
	$("#show").toggleClass("fa-remove fa-plus")
	$("#temp").attr("onclick","hideProject()");
}


//隐藏项目
function hideProject() {
	$("#projectdiv")[0].style.display = "none";
}


function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}

function initMarketInfo() {
	var id =  $("#id").val();
	
	$.ajax( {   
        "type": "GET",    
        "url": web_ctx+"/manage/ad/workMarket/findMarketByClientId",    
        "dataType": "json",   
        "data": {"id": id},
        "success": function(data) {
        	if(!isNull(data.result)&&""!=data.result){
        		showMarketInfo(data.result);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}


function save() {
	var formData = $("#form1").serializeJson();
	var chkMsg = checkForm(formData);
	if( !isNull(chkMsg) ) {
		bootstrapAlert("提示", chkMsg.join("<br/>"), 400, null);
		return ;
	}
	else if($("#form1").valid()){
		$.ajax({
			url:web_ctx+"/manage/ad/clientmanage/saveOrUpdate",
			type: "POST",
			dataType: "json",
			contentType: "application/json",
			data: JSON.stringify(formData),
			success:function(data){
				if(data.code==1){
					backPageAndRefresh();
				} else {
					bootstrapAlert("提示", "保存失败！", 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}
}

var email = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/;
var clientPhone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
function checkForm(formData) {
	var text = [];
	if( isNull(formData["clientName"]) ) {
		text.push("请填写客户姓名！");
	}
	if( isNull(formData["company"]) ) {
		text.push("请填写客户单位！");
	}
	if(isNull(formData["clientPosition"])){
		text.push("请填写客户职称");
	}
	if( !isNull(formData["clientPhone"]) &&  !clientPhone.test(formData["clientPhone"]) ) {
		text.push("请填写正确的11位手机号码！");
	}
	if( !isNull(formData["email"]) && !email.test(formData["email"]) ) {
		text.push("请填写正确的邮箱地址！");
	}
	return text;
}

function deleteIt() {
	var id = $("#id").val();
	bootstrapConfirm("提示", "是否确认删除？", 300, function() {
		$.ajax({
			url:web_ctx+"/manage/ad/clientmanage/delete",
			type: "POST",
			dataType: "json",
			data: {"id": id},
			success:function(data){
				if(data.code==1){
					bootstrapAlert("提示", "删除成功！", 400, function() {
						window.location.href = "toList";
						});
				} else {
					bootstrapAlert("提示", "删除失败！", 400, null);
				}
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	})
}



function showMarketInfo(datas){
	var html = [];
	html.push('<tr style="width:80%">');
	html.push('<td style="font-weight: bold;text-align: center;width:8%" >拜访人姓名</td>');
	html.push('<td style="font-weight: bold;text-align: center;width:8%" >拜访时间</td>');
	html.push('<td style="font-weight: bold;text-align: center;width:30%" >拜访内容</td>');
	html.push('</tr>');
	for (var i = 0; i <datas.length; i++) {
		html.push('<tr>');
		html.push('<td style="text-align: center;">'+ datas[i].sysUser.name +'</td>');
		html.push('<td style="text-align: center;">'+ new Date(datas[i].workDate).pattern("yyyy-MM-dd") +'</td>');
		html.push('<td colspan="5" style="text-align:center;height:auto;white-space:pre-line;width:auto;word-break:break-all;">'+ datas[i].content +'</td>');
		html.push('</tr>');
	}
	$("#marketInfo").html(html.join(""));
}




var flag ="";
var obt = "";
function openDialog(num) {
	if(num == "1"){
		flag ="user";
	}else {
		flag ="preuser";
	}
	$("#userDialog").openUserDialog();
}

//负责人选择框
function getData(data) {
	if(data != null && typeof data != "undefined") {
		if (flag == "user") {
			$("#preuserName").val($("#userName").val());
			$("#preClientId").val($("#clientId").val());
			$("#userName").val(data.name);
			$("#clientId").val(data.id);
			
		}
		else {
			$("#preuserName").val(data.name);
			$("#preClientId").val(data.id);
		}
	}
}

//移除负责人
function removePrincipal() {
	$("#clientId").val("");
	$("#userName").val("");
}


function removePrePrincipal() {
	$("#preClientId").val("");
	$("#preuserName").val("");
}



function openProject(){
	$("#projectDialog").openProjectDialog();
}


function getProjectData(data) {
	if(!isNull(data) && !$.isEmptyObject(data)) {
		$("#projectName").val(data.name);
		$("#projectId").val(data.id);
		
		$("#projectName1").html(data.name);
		if(data.principal != "" && data.principal!=null) {
			$("#principal").html(data.principal.name);
		}else{
			$("#principal").html();
		}
		if(data.type == "0") {
			$("#projectType").html("销售类");
		} else if(data.type == "1"){
			$("#projectType").html("研发类");
		}else if(data.type == "2"){
			$("#projectType").html("运营成本类");
		}else if(data.type == "3"){
			$("#projectType").html("业务成本类");
		}else if(data.type == "4"){
			$("#projectType").html("渠道合作项目");
		}else if(data.type == "5"){
			$("#projectType").html("合资项目");
		}
		if(data.location=="0"){
			$("#projectAddress").html("公司");
		}else{
			$("#projectAddress").html("其他");
		}
		$("#projectDescription").html(data.describe);
	}
}

function removeProject(){
	$("#projectName").val("");
	$("#projectId").val("");
}


