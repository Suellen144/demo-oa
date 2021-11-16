/******************************
 * 		全局变量		  	 	  *
 ******************************/
var fileData = null; // 选择文件后的文件数据变量
var urlParam = ""; // 文件上传URL参数
var projectObj = null; // 选择项目后的对象
var maxDate = null; // 餐费补贴的最大日期
var minDate = null;
var type2html = { // 新增节点时，根据类型获取生成HTML的函数
	"intercityCost": getHtmlForIntercityCost,
	"stayCost": getHtmlForStayCost,
	"cityCost": getHtmlForCityCost,
	"receiveCost": getHtmlForReceiveCost,
	"subsidy": getHtmlForSubsidy,
	"business": getHtmlForBusiness,
	"relationship": getHtmlForRelationship
};
var type2value = { // 每个大类节点对应的类型代码
	"intercityCost": "0",
	"stayCost": "1",
	"cityCost": "2",
	"receiveCost": "3",
	"subsidy": "4",
	"business": "5",
	"relationship": "6"
};
var validElements = { // 不同大类节点所需验证的表单元素
	"0": {
		"date": 0,
		"startPoint": 0,
		"destination": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"1": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"2": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0,
		"reason": 0,
		"costWithAct": 0
	},
	"3": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0
		"reason": 0,
		"costWithAct": 0
	},
	"4": {
		"beginDate": 0,
		"endDate": 0,
		"foodSubsidy": 0,
		"trafficSubsidy": 0,
		"reason": 0,
		"projectId": 0
	},
	"5": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0
		"reason": 0,
		"costWithAct": 0
	},
	"6": {
		"date": 0,
		"place": 0,
		"projectId": 0,
		//"cost": 0,
//		"actReimburse": 0
		"reason": 0,
		"costWithAct": 0
	}
};
var validElementsZh = { // 验证的表单元素对应的中文名
	"date": "日期",
	"place": "地点",
	"startPoint": "出发地",
	"destination": "目的地",
	"projectId": "项目",
	"cost": "费用",
	"actReimburse": "实报",
	"beginDate": "出发日期",
	"endDate": "离开日期",
	"foodSubsidy": "餐费补贴",
	"trafficSubsidy": "交通补贴",
	"reason": "事由",
	"costWithAct": "费用与实报"
};


$(function() {
	initDatetimepicker();
	initDialog();
//	initSelect();
	initBrowserInfo();
	initInputMask();
	initInputKeyUp();
	initFileUpload();
	initcollapse();
/*	initBrowserInfo();*/
	inittextarea();
	/* $("#travelDialog").initTravelDialog({
			"callBack": getTravel,
			"isCheck": true
		});
	*/
});

// 转换数字为中文大写
function converDigit(value) {
	var res = digitUppercase(value);
	$("#bigcost").val(res);
}


function getTravelname() {
    var name = $("#name").val();
    return name;
}


function getTravelID() {
	var temp = $("#travelId").val()
	if (temp != "" && temp != null) {
		return temp;
	}
}

function showhelp() {
	$("#helpModal").modal("show");
}





/******************************
 * 		表单相关函数		  	  *
 ******************************/

// 先验证表单（checkForm），验证通过后调用fileUpload函数
function save() {
	var formData = getFormData();
	var issubmit = $("#issubmit").val("0");
	var checkMsg = checkForm(formData);
	if(!isNull(checkMsg) && !$.isEmptyObject(checkMsg)) {
		bootstrapAlert("提示", buildCheckMsg(checkMsg), 400, null);
		return ;
	} else {
		if(fileData != null) { // 已选择文件，则先上传文件
			fileData.submit();
		} else {
			saveForm(formData);
		}
	}
}

function submitinfo() {
	var formData = getFormData();
	var checkMsg = checkForm(formData);
	var issubmit = $("#issubmit").val("1");
	if(!isNull(checkMsg) && !$.isEmptyObject(checkMsg)) {
		/*bootstrapAlert("提示", buildCheckMsg(checkMsg), 400, null);*/
		return ;
	} else {
		if(fileData != null) { // 已选择文件，则先上传文件
			fileData.submit();
		} else {
			submitForm(formData);
		}
	}
}

// 提交表单
function submitForm(formData) {
	$.ajax({
		url: "submitinfo",
		type: "post",
		contentType: "application/json",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				submitBankInfo();
				/*window.parent.submit();*/
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}



//保存表单
function saveForm(formData) {
	$.ajax({
		url: "save",
		type: "post",
		contentType: "application/json",
		data: JSON.stringify(formData),
		dataType: "json",
		success: function(data) {
			openBootstrapShade(false);
			if(data.code == 1) {
				submitBankInfo();
				window.parent.savereimburse();
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data, textstatus) {
			openBootstrapShade(false);
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

// 获取表单数据
function getFormData() {
	var json = $("#form1").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["travelreimburseAttachList"] = [];
	
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("intercityCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("stayCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("cityCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("receiveCost"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("subsidy"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("business"));
	formData["travelreimburseAttachList"] = formData["travelreimburseAttachList"].concat(getBranchFormData("relationship"));
	return formData;
}
function getBranchFormData(id) {
	var json = [];
	$("#"+id).find("tr[name='node']").each(function(index, tr) {
		var tempJson = {};
		$(tr).find("input,select,textarea").each(function(index, ele) {
			var name = $(ele).attr("name");
			var value = $(ele).val();
			if(!isNull(name) && !isNull(value)) {
				tempJson[name] = value;
			}
		});
		if(!$.isEmptyObject(tempJson)) {
			if((type2value[id] == "0"||type2value[id] == "2" )&& Object.getOwnPropertyNames(tempJson).length == 1) {
				return ;
			} else {
				tempJson["type"] = type2value[id];
                if(tempJson["type"] == "4"){
                    if(tempJson["trafficSubsidy"] != undefined){
                        tempJson["actReimburse"] = digitTool.add(tempJson["foodSubsidy"],tempJson["trafficSubsidy"])
                    }else{
                        tempJson["actReimburse"] =tempJson["foodSubsidy"]
                    }
                }		
				json.push(tempJson);
			}
			
		}
		if(id == "business" || id == "relationship"){
			validationRed(id);
		}
	});
	return json;
}

function validationRed(id){
	var str="";
	var strTo=0;
	var map = {};
	//var id=$("#id").val();
	$("#"+id).find("tr[name='node']").each(function(index, tr) {
		var projectId=$(tr).find("input[name='projectId']").val();
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		if(id == "relationship"){
		//如果包含，则取出 map中的value进行叠加
		if(str.indexOf(projectId) != -1){
			actReimburse=numAdd(actReimburse,map[projectId]);
			map[projectId]=actReimburse;
		}else{
			str=str+","+projectId;
			map[projectId]=actReimburse;
		}
		$.ajax({
			url: web_ctx+"/manage/finance/reimburs/getProjectById?id="+projectId,
			type: "POST",
			dataType: "json",
			success: function(data) {
				if(data !=null){
					if(data.researchCostLinesBalance<actReimburse){
						$(tr).find("input[name='actReimburse']").css("color","red");
						$(tr).find("input[name='actReimburse']")[0].title="超出攻关费"+accSub(actReimburse,data.researchCostLinesBalance)+"元";
					}else{
						$(tr).find("input[name='actReimburse']").css("color","");
						$(tr).find("input[name='actReimburse']")[0].title="";
					}
				}else{
					$(tr).find("input[name='actReimburse']").css("color","");
					$(tr).find("input[name='actReimburse']")[0].title="";
				}
			},error: function(data) {
				openBootstrapShade(false);
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		}else if(id == "business"){
			strTo=numAdd(strTo,actReimburse);
			$.ajax({
				url: web_ctx+"/manage/finance/reimburs/getGroupBusinessSum?state=2",
				type: "POST",
				dataType: "json",
				success: function(data) {
					if(data !=null){
						if(numAdd(data[0],strTo)>data[1]){
							$(tr).find("input[name='actReimburse']").css("color","red");
							$(tr).find("input[name='actReimburse']")[0].title="超出业务费"+accSub(numAdd(data[0],strTo),data[1])+"元";
						}else{
							$(tr).find("input[name='actReimburse']").css("color","");
							$(tr).find("input[name='actReimburse']")[0].title="";
						}
					}
				},error: function(data) {
					openBootstrapShade(false);
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
				}
			});
		}else{
			$(tr).find("input[name='actReimburse']").css("color","");
			$(tr).find("input[name='actReimburse']")[0].title="";
		}
	});
}

function accSub(arg1,arg2){
	var r1,r2,m,n;
	try{
	r1=arg1.toString().split(".")[1].length
	}catch(e){
	r1=0
	}try{
	r2=arg2.toString().split(".")[1].length
	}catch(e){
		r2=0
		}
	m=Math.pow(10,Math.max(r1,r2));
	n=(r1>=r2)?r1:r2;
	return ((arg1*m-arg2*m)/m).toFixed(n);
	}
function numAdd(num1, num2) {
   var baseNum, baseNum1, baseNum2; 
   try { 
      baseNum1 = num1.toString().split(".")[1].length; 
   } catch (e) {  
     baseNum1 = 0;
   } 
   try {
       baseNum2 = num2.toString().split(".")[1].length; 
   } catch (e) {
     baseNum2 = 0; 
   } 
   baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
   var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;//精度
   return ((num1 * baseNum + num2 * baseNum) / baseNum).toFixed(precision);; 
};

// 检查表单约束
function checkForm(formData) {
	var checkMsg = {};
	var validFields = $.extend(true, [], validElements);
	var dateComp = null;
	
	// 判断必须验证的字段是否有空值，如果有则 validFields 对应的属性会自增，0值表示该字段验证通过
	$(formData["travelreimburseAttachList"]).each(function(index, ele) {
		var fields = validFields[ele["type"]];
		if(!isNull(fields)) {
			for(var key in fields) {
				var value = ele[key];
				if(isNull(value) && key != "costWithAct") {
					fields[key]++;
				}
			}
		}
		
		if(ele["type"] == "4") {
			if(!isNull(ele["beginDate"]) 
					&& !isNull(ele["endDate"])
					&& ele["endDate"] < ele["beginDate"]) {
				dateComp = "离开日期不能小于出发日期！";
			}
		} else {
			if( isNull(ele["cost"]) && isNull(ele["actReimburse"]) ) {
				fields["costWithAct"]++;
			}
		}
	});
	
	for(var key1 in validFields) {
		var fieldObj = validFields[key1];
		var msg = {};
		for(var key2 in fieldObj) {
			if(fieldObj[key2] > 0 && isNull(msg[key2])) {
				if(key2 != "costWithAct") {
					msg[key2] = validElementsZh[key2] + "不能为空！";
				} else {
					msg[key2] = validElementsZh[key2] + "不能同时为空！";
				}
			}
		}
		if(!$.isEmptyObject(msg)) {
			checkMsg[key1] = [];
			for(var key3 in msg) {
				checkMsg[key1].push(msg[key3]);
			}
		}
	}
	
	var plainMsgObj = {"5": []};
	if(formData["travelreimburseAttachList"].length <= 0) {
		plainMsgObj["5"].push("至少有一条报销项！");
	}
	if(isNull(formData["name"])) {
		plainMsgObj["5"].push("出差人员不能为空！");
	}
/*	if(isNull(formData["travelId"])) {
		plainMsgObj["5"].push("出差申请不能为空！");
	}*/
	if(plainMsgObj["5"].length > 0) {
		checkMsg["5"] = plainMsgObj["5"];
	}
	if(!isNull(dateComp)) {
		if(isNull(checkMsg["4"]) || $.isEmptyObject(checkMsg["4"])) {
			checkMsg["4"] = [];
		}
		checkMsg["4"].push(dateComp);
	}
	
	return checkMsg;
}

function buildCheckMsg(checkMsg) {
	var html = [];
	for(var key in checkMsg) {
		if(key == "7") {
			html.push('<span class="label label-primary label_title">其他</span>')
		}else if(key == "0") {
			html.push('<span class="label label-primary label_title">城际交通费</span>');
		} else if(key == "1") {
			html.push('<span class="label label-primary label_title">住宿费</span>');
		} else if(key == "2") {
			html.push('<span class="label label-primary label_title">市内交通费</span>');
		} else if(key == "3") {
			html.push('<span class="label label-primary label_title">接待餐费</span>');
		} else if(key == "4") {
			html.push('<span class="label label-primary label_title">补贴</span>');
		}else if(key == "5") {
			html.push('<span class="label label-primary label_title">业务费</span>');
		}else if(key == "6") {
			html.push('<span class="label label-primary label_title">攻关费</span>');
		}
		
		var msg = checkMsg[key];
		for(var key2 in msg) {
			html.push('<span class="label label-default label_item">');
			html.push(msg[key2]);
			html.push('</span>');
		}
	}
	
	return html.join("");
}

//提交收款人、银行的相关信息作为历史数据
function submitBankInfo() {
	var json = {
		"payee": $("#payee").val(),
		"bank": $("#bank").val(),
		"bankAccount": $("#bankAccount").val(),
		"bankAddress": $("#bankAddress").val()
	};
	
	$.ajax({
		url: web_ctx+"/manage/finance/travelReimburs/saveBankInfo",
		type: "post",
		data: json
	});
}

// 文件上传
function initFileUpload() {
	var date = new Date();
	var params = {
		"path": "travelreimburse/" + date.getFullYear() + (date.getMonth()+1) + date.getDate()
	};
	
	urlParam = urlEncode(params);
	$('#file').fileupload({
		url: web_ctx+'/fileUpload?'+urlParam,
        dataType: 'json',
        formData: params,
        maxFileSize: 50 * 1024 * 1024, // 50 MB
        messages: {
        	maxFileSize: '附件大小最大为50M！'
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
        done: function (e, data) {
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
        		if($("#issubmit").val()=="0"){
        			saveForm(formData);
        		}
        		else{
        			submitForm(formData);
        		}
        	
        	} else {
        		openBootstrapShade(false);
        		bootstrapAlert("提示", "保存文件失败，错误信息：" + result.execResult.result, 400, null);
        	}
        }
    });
}





/******************************
 * 		普通操作相关函数		  *
 ******************************/
function openDept() {
	$("#deptDialog").openDeptDialog();
}
function getDept(dept) {
	if(dept != null) {
		$("#deptName").val(dept.name);
		$("#deptId").val(dept.id);
	}
}

function openProject(obj, tab) {
	if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
		var project = null;
		var tr = null;
		if( tab != "intercityCost"
			&& $(obj).parents("tr[name='node']").prev().length <= 0
			&& isNull($($(obj).parents("tr[name='node']").prev()).find("textarea[name='projectName']").val())
			&& !isNull($("#intercityCost").find("tr[name='node']:first").find("textarea[name='projectName']").val()) ) {
			tr = $("#intercityCost").find("tr[name='node']:first");
		} else {
			tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		}
		if( tr.length > 0 && !isNull($(tr).find("textarea[name='projectName']").val()) ) {
			$(obj).siblings("input[name='projectId']").val( $(tr).find("input[name='projectId']").val() );
			$(obj).val( $(tr).find("textarea[name='projectName']").val() );
			return ;
		}
	}
	$("#projectDialog").openProjectDialog();
	projectObj = obj;
	if(tab == "business" || tab == "relationship"){
		validationRed(tab);
	}
}
function getProject(data) {
	if(!isNull(data) && !isNull(projectObj)) {
		$(projectObj).siblings("input[name='projectId']").val(data.id);
		$(projectObj).val(data.name);
	}
}

function initBrowserInfo() {
	var ua = navigator.userAgent.toLowerCase();
	var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
	var m = ua.match(re);
	browserInfo.browser = m[1].replace(/version/, "'safari");
	browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
	browserInfo.version = m[2];
}


function getBrowserInfo() {
	return $.extend(true, {}, browserInfo);
}

function openTravel() {
	
    $("#travelDialog").openTravelDialog();
    var browserInfo = getBrowserInfo();
    if (browserInfo.browser == "ie") {
        window.frames["travelFrame"].drawTable();
    }
    else {
        travelFrame.contentWindow.drawTable();
    }
}
function getTravel(travelList) {

	var html = [];
	if(travelList != null && travelList.length > 0) {
		var travelId = [];
		var travelProcessInstanceId = [];
		$(travelList).each(function(index, travel) {
			travelId.push(travel.id);
			travelProcessInstanceId.push(travel.processInstanceId);
			var num = index+1;
			html.push('<input type="button"  name="detail"  style="margin-left:6px"  value="查看出差明细（'+num+'）" onclick="viewTravel('+travel.processInstanceId+')" style="border:none;">');
		});
		$("#selectTravel").html(html.join(""));
		$("#travelId").val(travelId.join(", "));
		$("#travelProcessInstanceId").val(travelProcessInstanceId.join(","));
		
	} else {
		$("#travelId").text("");
		$("#travelProcessInstanceId").val("");
	}
}

// 动态添加节点处理函数
function node(oper, type, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr:first").remove();
		initSubTotal();
	} else {
		var fun = type2html[type];
		var html = fun.call();
		$(obj).parents("tr:first").after(html);
		setNode($(obj).parents("tr:last"));
	}
}


// 城际交通费用节点
function getHtmlForIntercityCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push('	<td style="width: 6.8%;border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push('	<td style="width: 6.1%;"><input type="text" name="startPoint"></td>');
	html.push('	<td style="width: 6%;"><input type="text" name="destination"></td>');
	html.push('	<td style="width: 6%;"><select style="width:100%;" name="conveyance">'+$("#conveyance_hidden").html()+'</select></td>');
	html.push('	<td style="width: 12%;"><input type="hidden" name="projectId"><textarea type="text" name="projectName" onclick="openProject(this, \'intercityCost\')" readonly></textarea></td>');
	html.push('	<td style="width: 5%;"><input type="text" style="text-align:right;"   name="cost"></td>');
	html.push('	<td style="width: 5%;"><input type="text"  style="text-align:right;"  name="actReimburse"></td>');
	html.push('	<td style="width: 18%;"><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'intercityCost\')"></textarea></td>');
	html.push('	<td style="width: 24.5%;"><textarea  name="detail"></textarea></td>');
	html.push('	<td style="width: 4%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'intercityCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'intercityCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
	
}
// 住宿费用节点
function getHtmlForStayCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 5.2%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 5.6%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 11%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'stayCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 5%;"><input type="text" name="dayRoom"></td>');
	html.push(' <td style="width: 5%;"><input type="text" style="text-align:right;"   name="cost"></td>');
	html.push(' <td style="width: 5%;"><input type="text" style="text-align:right;"   name="actReimburse"></td>');
	html.push(' <td style="width: 18%;"><textarea name="reason" autocomplete="off" onfocus="reasonChange(this, \'stayCost\')"></textarea></td>');
	html.push(' <td style="width: 20.7%;"><textarea name="detail"></textarea></td>');
	html.push(' <td style="width: 3.4%; border-right-style:hidden;"><a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'add\', \'stayCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'del\', \'stayCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	return html.join("");
	
}
// 市内交通费用节点
function getHtmlForCityCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 7%;border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6.3%;"><input type="text" name="place"></td>');
    html.push('	<td style="width: 3%;"><select style="width:100%;" name="conveyance">'+$("#conveyance1_hidden").html()+'</select></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea type="text" name="projectName" onclick="openProject(this, \'cityCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 25%;"><textarea name="reason"  autocomplete="off" onfocus="reasonChange(this, \'cityCost\')"></textarea></td>');
	html.push(' <td style="width: 25.4%;"><textarea name="detail"></textarea></td>');
	html.push(' <td style="width: 4%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'cityCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a>  <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'cityCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 接待餐费节点
function getHtmlForReceiveCost() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 7%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6.3%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'receiveCost\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;" ></td>');
	html.push(' <td style="width: 25%;"><textarea name="reason"  autocomplete="off" onfocus="reasonChange(this, \'receiveCost\')"></textarea></td>');
	html.push(' <td style="width: 25.4%;"><textarea type="text" name="detail"></textarea></td>');
	html.push(' <td style="width: 4%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'receiveCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'receiveCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 补贴节点
function getHtmlForSubsidy() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<input type="hidden" name= "date">');
    html.push('<input type="hidden" name= "actReimburse" value="">');
	html.push(' <td style="width: 6.6%;border-left-style:hidden;"><input type="text" name="beginDate" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6.8%;"><input type="text" name="endDate" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="foodSubsidy" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 6.6%;"><input type="text" name="trafficSubsidy" style="text-align:right;" ></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea  name="projectName" onclick="openProject(this, \'subsidy\')" readonly></textarea></td>');
	html.push(' <td style="width: 19%;"><textarea  name="reason" autocomplete="off" onfocus="reasonChange(this, \'subsidy\')"></textarea></td>');
	html.push(' <td style="width: 23%;"><textarea type="text" name="detail"></textarea></td>');
	html.push(' <td style="width: 3.7%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'subsidy\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'subsidy\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 业务费节点
function getHtmlForBusiness() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 7%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6.3%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'business\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;" onchange="validationRed(\'business\')"></td>');
	html.push(' <td style="width: 25%;"><textarea name="reason"  autocomplete="off" onfocus="reasonChange(this, \'business\')"></textarea></td>');
	html.push(' <td style="width: 25.4%;"><textarea type="text" name="detail"></textarea></td>');
	html.push(' <td style="width: 4%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'business\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'business\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');

	return html.join("");
}
// 攻关费用节点
function getHtmlForRelationship() {
	var html = [];
	html.push('<tr name="node">');
	html.push(' <td style="width: 7%; border-left-style:hidden;"><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td style="width: 6.3%;"><input type="text" name="place"></td>');
	html.push(' <td style="width: 15%;"><input type="hidden" name="projectId"><textarea name="projectName" onclick="openProject(this, \'relationship\')" readonly></textarea></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="cost" style="text-align:right;"  ></td>');
	html.push(' <td style="width: 7%;"><input type="text" name="actReimburse" style="text-align:right;" onchange="validationRed(\'relationship\')"></td>');
	html.push(' <td style="width: 25%;"><textarea name="reason"  autocomplete="off" onfocus="reasonChange(this, \'relationship\')"></textarea></td>');
	html.push(' <td style="width: 25.4%;"><textarea type="text" name="detail"></textarea></td>');
	html.push(' <td style="width: 4%;border-right-style:hidden;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'relationship\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'relationship\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');

	return html.join("");
}

// 初始化某node行的输入框
function setNode(tr) {
	$(tr).find("input[name='cost'],input[name='actReimburse']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$(tr).find("input[name='foodSubsidy'],input[name='trafficSubsidy']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
    $(tr).find("input[name='foodSubsidy']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$(tr).find("input[name='dayRoom']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
	
	$(tr).find(".datetimepick").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		bootcssVer:3,
		toDay: true,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	 $(tr).find("input[name='cost'],input[name='actReimburse']," +
			"input[name='foodSubsidy'],input[name='trafficSubsidy']").bind("keyup", function() {
    /*$(tr).find("input[name='cost'],input[name='actReimburse']," +
        "input[name='foodSubsidy']").bind("keyup", function() {*/
		updateSubTotal(this); // 更新小计数据
		updateTotal(); // 更新总计数据
	});
	
	$(tr).find("input[name='cost']").blur(function() {
		costBlur(this);
	});
    $(tr).find("input[name='beginDate']").change(function() {
        initdate(this);
    });
	inittextarea();
	
	
}


function initdate(obj) {
	var temp  = $(obj).val();
    var tr = $(obj).parent("td").parent("tr");
    var date = $(tr).find("input[name='date']");
	if(!isNull(temp)){
      	date.val(temp);
	}
}

// 更新小计
function updateSubTotal(obj) {
	var tbody = $(obj).parents("tbody:first");
	var name = $(obj).attr("name");

	var total = 0;
	$(tbody).find("tr[name='node']").find("input[name='"+name+"']").each(function(index, input) {
		var value = $(input).val();
		if(!isNull(value)) {
			total = digitTool.add(total, parseFloat(value));
		}
	});
	
	$(tbody).find("tr[name='subTotal']").find("input[name='"+name+"Total']").val(total != 0 ? total : "");
}




// 更新总计
function updateTotal() {
	var total = 0.0;
	 $("tr[name='node']").find("input[name='foodSubsidy'],input[name='trafficSubsidy']").each(function(index, input) {
        /*$("tr[name='node']").find("input[name='foodSubsidy']").each(function(index, input) {*/
		var value = $(input).val();
		if(!isNull(value)) {
			total = digitTool.add(total, parseFloat(value));
		}
	});

	$("tr[name='node']").each(function(index, tr) {
		var actReimburse = $(tr).find("input[name='actReimburse']").val();
		var value = "";
		if( !isNull(actReimburse) ) {
			value = actReimburse;
		} else {
			value = $(tr).find("input[name='cost']").val();
		}
		
		if(isNull(value)) {
			value = "0";
		}
		total = digitTool.add(total, parseFloat(value));
	});

	if(total != 0) {
		$("#total").val(total);
		$("#totalcn").val(digitUppercase(total)); // 将总计数字转换为中文大写
		$("#Total").text(total);
		$("#Totalcn").text(digitUppercase(total));
	} else {
		$("#total").val("");
		$("#Total").val("");
		$("#totalcn").text("");
		$("#Totalcn").text("");
	}
}

// 费用失去焦点时刷新实报
function costBlur(obj) {
	var td = $(obj).parent("td");
	var actReimbruseObj = $(td).next("td").find("input[name='actReimburse']");
	if( isNull($(actReimbruseObj).val()) ) {
		var value = $(obj).val();
		$(actReimbruseObj).val(value);
	}
	$(actReimbruseObj).trigger("keyup");
}

// 查看出差详细
function viewTravel(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/ad/chkatt/travel/view"
	}
	
	var url = web_ctx + "/activiti/process?" + urlEncode(param);
	$("#travelDetailFrame").attr("src", url);
	$("#travelDetailModal").modal("show");
}

// 事由聚焦时
function reasonChange(obj, tab) {
	if( isNull($(obj).val()) ) { // 项目内容为空，则计算其他项目内容
		var tr = null;
		if( tab != "intercityCost"
			&& $(obj).parents("tr[name='node']").prev().length <= 0
			&& isNull($($(obj).parents("tr[name='node']").prev()).find("textarea[name='reason']").val())
			&& !isNull($("#intercityCost").find("tr[name='node']:first").find("textarea[name='reason']").val()) ) {
			tr = $("#intercityCost").find("tr[name='node']:first");
		} else {
			tr = $(obj).parents("tr[name='node']").prev("tr[name='node']");
		}

	/*	if( tr.length > 0 && !isNull($(tr).find("textarea[name='reason']").val()) ) {
			$(obj).val( $(tr).find("textarea[name='reason']").val() );
		}*/
	}
}










/******************************
 * 		各类初始化相关函数		  *
 ******************************/

//初始化时间输入框
function initDatetimepicker() {
	$("input.datetimepick").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		toDay: true,
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
}

// 初始化弹出选择框
function initDialog() {
	$("#deptDialog").initDeptDialog({
		"callBack": getDept,
		"isCheck": false
	});
	
	$("#projectDialog").initProjectDialog({
		"callBack": getProject
	});	
	
	$("#travelDialog").initTravelDialog({
		"callBack": getTravel,
		"isCheck": true
	});	
}

//初始化文本域
function inittextarea(){
	autosize(document.querySelectorAll('textarea'));
}


/*初始化Bootstrap的折叠插件和Textarea高度*/
function initcollapse(){
	$('#intercityCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[0].style.display ="none";
		
	});
	
	$('#intercityCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[0].style.display ="block";
	});
	
	$('#stayCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[1].style.display ="none";
		$("#stayreason")[0].style.height = "35px";
		$("#staydetail")[0].style.height = "35px";
		$("#stayPorject")[0].style.height = "35px";
		
	
	});
	
	$('#stayCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[1].style.display ="block";
	
	});
	
	$('#cityCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[2].style.display ="none";
		$("#cityreason")[0].style.height = "35px";
		$("#citydetail")[0].style.height = "35px";
		$("#cityproject")[0].style.height = "35px";
		
	});
	
	$('#cityCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[2].style.display ="block";
	});
	
	/*$('#receiveCost').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="none";
		$("#receivereason")[0].style.height = "35px";
		$("#receivedetail")[0].style.height = "35px";
		$("#receiveproject")[0].style.height = "35px";
	});
	
	$('#receiveCost').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="block";
	});*/
	
	$('#subsidy').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="none";
		$("#subsidyreason")[0].style.height = "35px";
		$("#subsidydetail")[0].style.height = "35px";
		$("#subsidyproject")[0].style.height = "35px";
		
	});
	
	$('#subsidy').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[3].style.display ="block";
	});

	$('#business').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[4].style.display ="none";
		$("#businessreason")[0].style.height = "35px";
		$("#businessdetail")[0].style.height = "35px";
		$("#businessproject")[0].style.height = "35px";
	});

	$('#business').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[4].style.display ="block";
	});

	$('#relationship').on('show.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[5].style.display ="none";
		$("#relationshipreason")[0].style.height = "35px";
		$("#relationshipdetail")[0].style.height = "35px";
		$("#relationshipproject")[0].style.height = "35px";
	});

	$('#business').on('hidden.bs.collapse', function () {
		var l=document.getElementsByTagName("hr");
		l[5].style.display ="block";
	});
}


// 初始化select2控件（收款人、银行卡号、开户行地址）
function initSelect() {
	var isDigit = /^\d+(\d\s)?.*\d+$/;
	$(".select2").select2({ tags: true, allowClear: true, placeholder: "请选择一项或输入值后回车" });
	$(".select2").on("select2:select", function(evt) {
		var name = $(this).prev("input[type='hidden']").attr("name");
		if(name == "bankAccount") {
			var selValue = $(this).val();
			if(!isNull(selValue) && isDigit.test(selValue)) {
				$(this).prev("input[type='hidden']").val(selValue);
			} else {
				$(this).prev("input[type='hidden']").val("");
				$(this).select2('val', '');
			}
		} else {
			$(this).prev("input[type='hidden']").val($(this).val());
		}
	});
	
	$(".select2").on("change", function(evt) {
		var selValue = $(this).val();
		if(isNull(selValue)) {
			$(this).prev("input[type='hidden']").val("");
		}
	});
	
	$("#payee").next(".select2").trigger('select2:select');
	$("#bankAccount").next(".select2").trigger('select2:select');
	$("#bankAddress").next(".select2").trigger('select2:select');
	$(".select2-selection__rendered").css("text-align", "left");
}

// 初始化输入框约束
function initInputMask() {
	$("input[name='cost'],input[name='actReimburse']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("input[name='foodSubsidy'],input[name='trafficSubsidy']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$("input[name='dayRoom']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
	$("input[name='bankAccount']").inputmask("Regex", { regex: "\\d+\\?\\d{0,0}" });
}

// 初始化输入框按键弹起事件
function initInputKeyUp() {
	 $("input[name='cost'],input[name='actReimburse']," +
	 		"input[name='foodSubsidy'],input[name='trafficSubsidy']").bind("keyup", function() {
       /* $("input[name='cost'],input[name='actReimburse']," +
            "input[name='foodSubsidy']").bind("keyup", function() {*/
		updateSubTotal(this); // 更新小计数据
		updateTotal(); // 更新总计数据
	});
	
	$("input[name='cost']").blur(function() {
		costBlur(this);
	});
    $("input[name='beginDate']").change(function(){
        initdate(this);
    });

}
//初始化小计
function initSubTotal() {
	$("input[name='cost'],input[name='actReimburse']," +
	"input[name='foodSubsidy'],input[name='trafficSubsidy']").trigger("keyup");
}

// 自动计算补贴
function calSubsidy(obj) {
	var tr = $(obj).parents("tr");
	var foodSubsidy = $(tr).find("input['foodSubsidy']").val();
	var trafficSubsidy = $(tr).find("input['trafficSubsidy']").val();
	
	// 都有值，则不用计算
	if( !isNull(foodSubsidy)) {
		return ;
	}
}







/*提供给Iframe父页面调用的方法*/
function check(formData){
	var checkMsg = [];
	if(formData["travelreimburseAttachList"].length <= 0) {
		checkMsg.push("至少有一条报销项！");
	}
	return checkMsg;
}

function checkTravel(formData){
	var checkMsg = [];
	if(isNull(formData["travelId"])) {
		checkMsg.push("必须含有出差！");
	}
	return checkMsg;
}

function checktravel(){
	var formData = getFormData();
	checkMsg = checkTravel(formData);
	return checkMsg;
}



function checknull(){
	var formData = getFormData();
	checkMsg = check(formData);
	return checkMsg;

}


function checkall(){
	var formData = getFormData();
	checkMsg = checkFrameForm(formData);
	return buildCheckMsg(checkMsg);
}


function checkFrameForm(formData) {
	var checkMsg = {};
	var validFields = $.extend(true, [], validElements);
	var dateComp = null;
	
	// 判断必须验证的字段是否有空值，如果有则 validFields 对应的属性会自增，0值表示该字段验证通过
	$(formData["travelreimburseAttachList"]).each(function(index, ele) {
		var fields = validFields[ele["type"]];
		if(!isNull(fields)) {
			for(var key in fields) {
				var value = ele[key];
				if(isNull(value) && key != "costWithAct") {
					fields[key]++;
				}
			}
		}
		
		if(ele["type"] == "4") {
			if(!isNull(ele["beginDate"]) 
					&& !isNull(ele["endDate"])
					&& ele["endDate"] < ele["beginDate"]) {
				dateComp = "离开日期不能小于出发日期！";
			}
		} else {
			if( isNull(ele["cost"]) && isNull(ele["actReimburse"]) ) {
				fields["costWithAct"]++;
			}
		}
	});
	
	for(var key1 in validFields) {
		var fieldObj = validFields[key1];
		var msg = {};
		for(var key2 in fieldObj) {
			if(fieldObj[key2] > 0 && isNull(msg[key2])) {
				if(key2 != "costWithAct") {
					msg[key2] = validElementsZh[key2] + "不能为空！";
				} else {
					msg[key2] = validElementsZh[key2] + "不能同时为空！";
				}
			}
		}
		if(!$.isEmptyObject(msg)) {
			checkMsg[key1] = [];
			for(var key3 in msg) {
				checkMsg[key1].push(msg[key3]);
			}
		}
	}
	
	var plainMsgObj = {"5": []};
	if(isNull(formData["name"])) {
		plainMsgObj["5"].push("出差人员不能为空！");
	}

	if(plainMsgObj["5"].length > 0) {
		checkMsg["5"] = plainMsgObj["5"];
	}
	if(!isNull(dateComp)) {
		if(isNull(checkMsg["4"]) || $.isEmptyObject(checkMsg["4"])) {
			checkMsg["4"] = [];
		}
		checkMsg["4"].push(dateComp);
	}
	
	return checkMsg;
}




