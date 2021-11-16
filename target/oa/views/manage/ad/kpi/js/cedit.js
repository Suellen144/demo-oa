$(document).ready(function(){
	
	var formData = getFormJson();
	
	//经理改自己的绩效
	if (formData.currName == formData.managerName && formData.currName == formData.userName && formData.status== 1) {
		initUserCkeditor();

		$("tr[id^='manager_']").remove();
		$("tr[id ^= 'ceo_']").remove();
		msinitParams();
		
	//绩效本人修改	
	}else if(formData.currName == formData.userName && formData.status==0){
		$("tr[id^='manager_']").remove();
		$("tr[id ^= 'ceo_']").remove();
		initUserCkeditor();
		CKEDITOR.instances.userEvaluation.setData(formData.eu);
		uinitParams();
	
	//总经理审核
	}else if (formData.currName == formData.ceoName && formData.status== 1) {

		initCeoCkeditor();
		if($("#isManager").val()==1){
			var trSelect= $("tr[id^='manager']");
			$("#form").find(trSelect).each(function(index,tr){
				$(tr).remove();
			})	
			cminitParams();
		}else {
			cinitParams();
		}
		
	//总经理在经理为审核前打开绩效
	}else if (formData.currName == formData.ceoName && (formData.status== 0 || formData.status== 2 )){
		$("#form").find("input").attr('readonly', true);
		$("#form").find("textarea").attr('readonly', true);
		$("#form").find("select").attr('readonly', true);
		$("#save_btn").remove();
		
	//经理审核
	}else if($("#currName").val() == $("#managerName").val() &&  ($("#status").val()==0 ||  $("#status").val()==1)){
		$("tr[id ^= 'ceo_']").remove();
		initManagerCkeditor();
		minitParams();
		
	}else{
		removeManagerEvaluation();
		$(document.getElementById("save_btn")).hide();
	}
	
});
function removeManagerEvaluation(){
	if($("#isManager").val()==1){
		var trSelect= $("tr[id^='manager']");
		$("#form").find(trSelect).each(function(index,tr){
			$(tr).remove();
		})	
	}
}
function initUserCkeditor() {
	CKEDITOR.replace("userEvaluation", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
	
}

function initManagerCkeditor() {
	
	CKEDITOR.replace("managerEvaluation", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
	
}

function initCeoCkeditor() {

	CKEDITOR.replace("ceoEvaluation", {
		toolbar: [
		   ['Styles', 'Format'],     
           ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList']    
		]
	});
	
}

/*经理评价评分为空则默认用户数据，总经理评价评分为空则默认经理数据*/
function uinitParams(){
	
	var userEvaluation = CKEDITOR.instances.userEvaluation.getData();
	var userScore = $("#userScore").val();
	
	$("#managerScore").val(userScore); 
	$("#managerEvaluation").html(userEvaluation);

	$("#ceoScore").val(userScore);
	$("#ceoEvaluation").val(userEvaluation);

}

function minitParams(){
	var managerScore = $("#managerScore").val();
	var userScore = $("#userScore").val();
	if(isNull(managerScore) ){
		$("#managerScore").val(userScore);
		$("#ceoScore").val(userScore);
	}else{
		$("#ceoScore").val(managerScore);
	}
		
	var managerEvaluation = CKEDITOR.instances.managerEvaluation.getData();
	var userEvaluation = $("#userEvaluation").val();
	if( isNull(managerEvaluation)){
		 CKEDITOR.instances.managerEvaluation.setData(userEvaluation);
		 $("#ceoEvaluation").val(userEvaluation);
	}else{
		$("#ceoEvaluation").val(managerEvaluation);
	}
	var managerPraisedPunished = $("#managerPraisedPunished").val();
	$("#ceoPraisedPunished").val(managerPraisedPunished);
}

function msinitParams(){

	var userEvaluation = CKEDITOR.instances.userEvaluation.getData();
	var userScore = $("#userScore").val();
	$("#ceoScore").val(userScore);
	$("#ceoEvaluation").val(userEvaluation);

}

function cinitParams(){

	var ceoEvaluation =  CKEDITOR.instances.ceoEvaluation.getData();
	var managerScore = $("#managerScore").val();
	if(isNull($("#ceoScore").val()) ){
		$("#ceoScore").val(managerScore);
	}
	var managerEvaluation = $("#managerEvaluation").val();
	if(isNull(ceoEvaluation)){
		CKEDITOR.instances.ceoEvaluation.setData(managerEvaluation);
	}
	
	var managerPraisedPunished = $("#managerPraisedPunished").val();
	if(isNull($("#ceoPraisedPunished").val())){
		$("#ceoPraisedPunished").val(managerPraisedPunished);
	}
}

function cminitParams(){
	
	var ceoEvaluation =  CKEDITOR.instances.ceoEvaluation.getData();
	var userScore = $("#userScore").val();
	if(isNull($("#ceoScore").val()) ){
		$("#ceoScore").val(userScore);
	}
	
	var userEvaluation = $("#userEvaluation").val();
	if(isNull(ceoEvaluation)){
		CKEDITOR.instances.ceoEvaluation.setData(userEvaluation);
	}
}

function save() {
	
	
	var formData = "";

	//经理改自己绩效
	if($("#currName").val() == $("#managerName").val() && $("#currName").val() == $("#userName").val() && $("#status").val()==1){
		msinitParams();
		formData = getFormJson();
		formData.userEvaluation=CKEDITOR.instances.userEvaluation.getData();
		
		if(!checkForm(formData)) {
			return ;
		}
		saveReal(formData);

		
		//经理审核第一次，第二次保存
	}else if($("#currName").val() == $("#managerName").val() &&  ($("#status").val()==0 ||  $("#status").val()==1)){
		minitParams();
		formData = getFormJson();
		formData.managerEvaluation=CKEDITOR.instances.managerEvaluation.getData();
		if(!checkForm(formData)) {
			return ;
		}
		saveReal(formData);
	

		//总经理审核
	}else if ($("#currName").val() == $("#ceoName").val() && $("#status").val()==1 ) {
		
		cinitParams();
		formData = getFormJson();
		formData.ceoEvaluation=CKEDITOR.instances.ceoEvaluation.getData();
		if(!checkForm(formData)) {
			return ;
		}
		saveReal(formData);

	//用户自己修改
	}else {
		
		uinitParams();
		formData = getFormJson();
		formData.userEvaluation=CKEDITOR.instances.userEvaluation.getData();
		if(!checkForm(formData)) {
			return ;
		}
		saveReal(formData);

	}
	
		
}

function saveReal(formData){

		$.ajax({
			url:"save",
			type: "POST",
			data:formData,
			dataType: "json",
			success:function(data){
			
				bootstrapAlert("提示",data.result, 400, function() {						
					window.location.href = "toList";
				});
			},
			error:function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
}


function saveBefore(formData,flag){
	//经理审核在保存之前异步校验用户是否已经修改
	
	$.ajax({
		url:web_ctx+"/manage/ad/kpi/isEdit?flag="+flag,
		type: "GET",
		data:formData,
		dataType: "json",
		success:function(data){	

			if(data.code != 1){	
				bootstrapAlert("提示",data.result, 400, function() {
					
					window.location.href = "evaluation?id="+formData.id;
					});
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});		
}

function getFormJson() {	
	var json = $("#form").serializeJson();
	return json;
}

function checkForm(formData) {
	var text = [];
	$(formData).each(function(index,formData){
		 
		//改自己绩效
		if ((formData.currName == formData.userName) && ($("#status").val()== 0) || (formData.currName == formData.managerName && formData.currName == formData.userName && $("#status").val()== 1) ) {
			
				var userEvaluation = CKEDITOR.instances.userEvaluation.getData();
				if(isNull(userEvaluation)){
					text.push("必须填写自我评价！<br/>");
				}
				if(isNull(formData.userScore)){     
						text.push("必须填写自评分！<br/>");         
				              
				}else {
		             if(/^([0-9]{1,2}|100)$/.test(formData.userScore)) {
		                      
				        var value=parseInt(formData.userScore);
				        if(value<0 || value>100){
				        	text.push("请输入0-100的整数！<br/>");
						}
		             }else {
		            	 text.push("请输入0-100的整数！<br/>");
					}   
				}
		
		//经理改别人的
		}else if (formData.currName == formData.managerName) {
			var managerEvaluation = CKEDITOR.instances.managerEvaluation.getData();
			if(isNull(managerEvaluation)){
				text.push("必须填写经理评价！<br/>");
			}
			if(isNull(formData.managerScore)){     
					text.push("必须填经理写评分！<br/>");         
			              
			}else {
	             if(/^([0-9]{1,2}|100)$/.test(formData.managerScore)) {
	                      
			        var value=parseInt(formData.managerScore);
			        if(value<0 || value>100){
			        	text.push("请输入0-100的整数！<br/>");
					}
	             }else {
	            	 text.push("请输入0-100的整数！<br/>");
				}   
			}
		}else if(formData.currName == formData.ceoName){
			var ceoEvaluation = CKEDITOR.instances.ceoEvaluation.getData();
			if(isNull(ceoEvaluation)){
				text.push("必须填写总经理评价！<br/>");
			}
			if(isNull(formData.ceoScore)){     
					text.push("必须填写总经理评分！<br/>");         
			              
			}else {
	             if(/^([0-9]{1,2}|100)$/.test(formData.ceoScore)) {
	                      
			        var value=parseInt(formData.ceoScore);
			        if(value<0 || value>100){
			        	text.push("请输入0-100的整数！<br/>");
					}
	             }else {
	            	 text.push("请输入0-100的整数！<br/>");
				}   
			}
		}
	});
	
	if(text.length > 0) {
		bootstrapAlert("提示", text.join(""), 400, null);
		return false;
	} else {
		return true;
	}
}

function goBack() {
	window.history.back(-1);
}
