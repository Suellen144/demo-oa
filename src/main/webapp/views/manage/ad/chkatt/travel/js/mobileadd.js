
var fileData = null;
var index=0;
$(function() {
	initDatetimepicker();
	initInputMask();
	initFileUpload();
	$("#applyTime").val(new Date().pattern("yyyy-MM-dd"));
});


function save() {
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	if(checkMsg.length > 0) {
		bootstrapAlert("提示", checkMsg.join("<br/>"), 400, null);
		return ;
	}
	
	openBootstrapShade(true);
	if(fileData != null) {
		fileData.submit();
	} else {
		submitForm(formData);
	}
	openBootstrapShade(false);
}

function submitForm(formData) {
	$.ajax({
		url: "save",
		type: "post",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
					window.location.href = "toList";
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


/********* 表单相关函数 ***************/

function checkForm(formData) {
	var text = [];
	var days = [];
	if(isNull(formData["budget"])) {
		text.push("费用预算不能为空！");
	}
	if(formData["travelAttachList"].length <= 0) {
		text.push("至少有一条出差项！");
	} else {
		$(formData["travelAttachList"]).each(function(index, attach) {
			var st = attach["beginDate"];
			if(isNull(st)) {
				text.push("开始时间不能为空！");
				return false;
			}
			else{
				var date1=new Date().getTime();  //申请时间
				var date2=new Date(st).getTime();
				var date3=date1-date2 //时间差的毫秒数
				var day=Math.floor(date3/(24*3600*1000));
				if(day > 2){
					text.push("申请时间不能晚于出差开始时间两天！");
					return false;
				}
			}
			var et = attach["endDate"];
			if(isNull(et)) {
				text.push("结束时间不能为空！");
				return false;
			}
			if(st > et) {
				text.push("开始时间不能大于结束时间！");
				return false;
			}
			
			//今天出差，最晚后天提交流程，也就是最晚2天
			if(!isNull(st)){
				var nowTime = new Date().getTime(); 
				 var startTime = new Date(st).getTime();
				var result = nowTime - startTime;
				var day = Math.floor(result/(24*3600*1000));
				
				if(day > 2){
					text.push("请重选出差开始时间，申请时间不能晚于出差开始时间两天！");
					return false;
				}
			}
		});
		
		$(formData["travelAttachList"]).each(function(index, attach) {
			if(isNull(attach["place"])) {
				text.push("出差地点不能为空！");
				return false;
			}
		});
	}
	
	return text;
}


function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["travelAttachList"] = [];

	$("li[name='node']").each(function(index, tr) {
		var beginDate = $(this).find("input[name='beginDate']").val();
		var endDate = $(this).find("input[name='endDate']").val();
		var place = $(this).find("input[name='place']").val();
		var task = $(this).find("input[name='task']").val();
		var vehicle = $(this).find("select[name='vehicle']").val();
		
		if(!isNull(beginDate) || !isNull(endDate)
				|| !isNull(place) || !isNull(task)) {
			var travelAttach = {};
			travelAttach["beginDate"] = beginDate;
			travelAttach["endDate"] = endDate;
			travelAttach["place"] = place;
			travelAttach["task"] = task;
			travelAttach["vehicle"] = vehicle;
			
			formData["travelAttachList"].push(travelAttach);
		}
	});
	
	return formData;
}

/********* 初始化相关函数 **********/

function initDatetimepicker() {
	$(".beginDate, .endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
        bootcssVer:3,
        todayBtn: true
    });
}

function initInputMask() {
	$("#budget").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
}


//改变出差城市的值
function changeText(obj,value) {
      $($(obj).closest('.parentli')).find('.mFormSeconMsg:eq(1)').text(value)
}

function changeText1(obj,value,num) {
  var str=$(obj).prev().text();
  if(num=="1"){
      var ob=$(($(obj).closest('.parentli')).find('.mFormSeconMsg:eq(0)')).find('span:eq(0)');
     ob.text(value);
  }else{
      var ob=$(($(obj).closest('.parentli')).find('.mFormSeconMsg:eq(0)')).find('span:eq(1)');
      ob.text(value);
  }
}

/*添加或删除li*/
function node(oper,obj) {
  if(oper == "del") {
      $(obj).closest('.parentli').remove();
  } else {
      var html = getNodeHtml();
      $(obj).closest('.parentli').after(html);
      $(obj).attr("onclick", "node('del', this)");
      $(obj).html('<img alt="删除" src="'+base+'/static/images/del.png">');
  }
  initDatetimepicker();
}
function getNodeHtml() {
  var html = [];
  html.push('<li class="clearfix parentli" name="node">');
  html.push('<div class="col-xs-12">');
  html.push('<div class="mFormName">出差申请</div> ');
  html.push(' <div class="mFormMsg">');
  html.push(' <div class="mFormShow" href="#intercityCost'+index+'" data-toggle="collapse" data-parent="#accordion">');
  html.push(' <div class="mFormSeconMsg"><span>开始</span>  至  <span>结束</span></div>');
  html.push('<div class="mFormSeconMsg">地点</div>');
  html.push('<div class="mFormArr"><img src="'+base+'/static/images/arr.png" alt=""></div>');
  html.push('<div class="mFormOpe" onclick="node(\'add\',this)"><img src="'+base+'/static/images/add.png" alt="添加"></div>');
  html.push('  </div>');
  html.push(' <div class="mFormToggle panel-collapse collapse" id="intercityCost'+index+'">');
  html.push('<div class="mFormToggleConn">');
  html.push('<div class="mFormXSToggleConn">');
  html.push('<div class="mFormXSName">出差地点</div>');
  html.push(' <div class="mFormXSMsg">');
  html.push(' <input type="text" class="longInput" name="place" onchange="changeText(this,value)"/>');
  html.push(' </div>');
  html.push(' </div>');
  html.push('<div class="mFormXSToggleConn">');
  html.push('<div class="mFormXSName">交通工具</div>');
  html.push('<div class="mFormXSMsg">');
  html.push('<select name="vehicle" class="mSelect">');
  html.push($("#vehicle_hidden").html());
  html.push('</select>');
  html.push('</div>');
  html.push('</div>');
  html.push('</div>');
  html.push('<div class="mFormToggleConn">');
  html.push('<div class="mFormXSName">出差日期</div>');
  html.push('<div class="mFormXSMsg" style="font-size:12px;color: gray;">');
  html.push('<input name="beginDate" type="text" class="beginDate longInput" style="width:20%;text-align: center;"  readonly onchange="changeText1(this,value,1)"> 至 ');
  html.push('<input name="endDate" type="text" class="endDate longInput" style="width:20%;text-align: center;"  readonly onchange="changeText1(this,value,2)">');
  html.push('</div>');
  html.push('</div>');
  html.push('<div class="mFormToggleConn">');
  html.push('<div class="mFormXSName">出差事由</div>');
  html.push('<div class="mFormXSMsg">');
  html.push('<input type="text" class="longInput" />');
  html.push('</div>');
  html.push('</div>');
  html.push('</div>');
  html.push('</div>');;
  html.push('</li>');
  index++;
  return html.join("");
}


//文件上传

/*文件上传*/
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "travel/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
      dataType: 'json',
      formData: params,
      maxFileSize: 3 * 1024 * 1024, // 3 MB
      messages: {
      	maxFileSize: '附件大小最大为3M！'
      },
      add: function (e, data) {
      	var $this = $(this);
      	data.process(function() {
      		return $this.fileupload('process', data);
      	}).done(function(){
      		fileData = data;
          	$("#showName").val(data.files[0].name);
      	}).fail(function() {
      		var errorMsg = [];
      		$(data.files).each(function(index, file) {
      			errorMsg.push(file.error);
      		});
      		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
      	});
      },
      done: function(e, data) {
      	var result = data.result;
      	if(result.execResult.code != 0) {
      		// 如果表单保存不成功，则保留上次上传的文件。再次点提交会删除上次的文件
  			params["deleteFile"] = result.path;
  			urlParam = urlEncode(params);
  			$("#file").fileupload("option", "url", (web_ctx+'/fileUpload?'+urlParam));
  			$("#file").fileupload("option", "formData", urlParam);
      		$("#showName").val(result.originName);
      		$("#attachments").val(result.path);
      		$("#attachName").val(result.originName);
      		
      		var formData = getFormData();
      		submitForm(formData);
      	} else {
      		openBootstrapShade(false);
      		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
      	}
      }
  });
}
