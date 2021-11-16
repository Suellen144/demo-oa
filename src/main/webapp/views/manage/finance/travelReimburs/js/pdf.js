$(function() {
	initNode();
	initDatetimepicker();
	initMap();
	initPage();
    initInvest();
	edit();
    if(ishavatrafficSubsidy.length>0){
        $(".trafficSubsidy").show();
    }
    else {
        $(".trafficSubsidy").hide();
	}
    
    if (ishavatrafficTool.length > 0) {
        $(".trafficT").show();
    }

	$("tr[name='node']").find("td[name='operation']").each(function(index,td){
		$(td).attr("contenteditable","false");
		}); 
	
/*	$("tbody").find("td").each(function(index,td){
		$(td).attr("contenteditable","true");
		}); */
	initDecryption();

});


// 初始化费用归属
function initInvest() {
    $.ajax( {
        "type": "GET",
        "url": web_ctx + "/manage/finance/reimburs/getInvestList",
        "dataType": "json",
        "success": function(data) {
            if(!isNull(data)) {
                investList = data;
                $("tbody").find("select[name='attachInvestId']").each(function(index, select) {
                    var investValue = $(select).attr("value");
                    var html = [];
                    html.push('<option value="-1"></option>');
                    $(investList).each(function(index, invest) {
                        html.push('<option value="'+invest.id+'" '+(investValue==invest.id?"selected":"")+'>'+invest.value+'</option>');
                    });
                    $(select).append(html.join(""));
                });
            }
        }
    } );
}

/*用于报销项目去重*/
function unique(array){
	  var n = []; //一个新的临时数组
	  //遍历当前数组
	  for(var i = 0; i < array.length; i++){
	    //如果当前数组的第i已经保存进了临时数组，那么跳过，
	    //否则把当前项push到临时数组里面
	    if (n.indexOf(array[i]) == -1) n.push(array[i]);
	  }
	  return n;
}

/*更新差旅报销统计*/
function updatereimbursetotal (){
	var cost = []; //项目费用数据
	var receive = [];
	var projectName = [];
	var temp = [];
	var key; 	 //项目索引Key
	var costmap = new Map(cost);
	var receivemap = new Map(receive);
	var sum = [];
	
	sum.push("<tr>")
	sum.push("<td style='width:20%;border-top-style:hidden;' contenteditable=true>项目</td>")
	sum.push("<td style='width:40%;border-top-style:hidden;' contenteditable=true>差旅统计</td>")
	sum.push("<td style='width:40%;border-top-style:hidden;' contenteditable=true>招待统计</td>")
	sum.push("</tr>")
	
	$("tr[name='node']").each(function(index, tr) {
		 project = $(tr).find("td[name='projectName']").text();
		 temp.push(project);
	});
	projectName = unique(temp);
	
	$("tr[id='node']").each(function(index, tr) {
		 project = $(tr).find("td[name='projectName']").text();
		 actReimburse = $(tr).find("td[name='actReimburse']").text(); 
		 food = $(tr).find("td[name='foodSubsidy']").text();
		 traffic = $(tr).find("td[name='trafficSubsidy']").text();
		 money = digitTool.add(food,traffic);
		 if(money!=""){
			 actReimburse = money.toFixed(2);
		 }
		 cost.push(actReimburse);
		 key = project;
		 if(costmap.get(key) == undefined){
			 costmap.set(key,cost[index]);
		 }
		 else {
			 total = digitTool.add(costmap.get(key),cost[index]);
			 costmap.set(key,total.toFixed(2));
		 }
	});
	
	$("tr[id='receive']").each(function(index, tr) {
		 project = $(tr).find("td[name='projectName']").text();
		 actReimburse = $(tr).find("td[name='actReimburse']").text(); 
		 receive.push(actReimburse);
		 key = project;
		 if(receivemap.get(key) == undefined){
			 receivemap.set(key,receive[index]);
		 }
		 else {
			 total = digitTool.add(receivemap.get(key),receive[index]);
			 receivemap.set(key,total.toFixed(2));
		 }
	});
	
	$(projectName).each(function(index,value){
		sum.push("<tr style='border-top-style:hidden;'>")
		sum.push("<td>"+value+"</td>");
		if(costmap.get(value) == undefined){
			sum.push("<td>"+'0.00'+"</td>");
		}
		else {
			sum.push("<td>"+costmap.get(value)+"</td>");
		}
		if(receivemap.get(value) == undefined){
			sum.push("<td>"+'0.00'+"</td>");
		}
		else{
			sum.push("<td>"+receivemap.get(value)+"</td>");
		}
		sum.push("</tr>")
	});
	$("#reimbursetotal").find("thead[name='reimbursetotal']").append(sum);
	
	
}

function edit(){
	$("tr[name='node']").find("td[name='cost'],td[name='actReimburse']," +
	"td[name='foodSubsidy'],td[name='trafficSubsidy']").bind("keyup", function() {
	updateTotal(); // 更新总计数据
	});
}

function updateTotal() {
    var total = 0.0;
    $("tr[name='node']").find("td[name='foodSubsidy'],td[name='trafficSubsidy']").each(function(index, input) {
      var value = $(input).text();
      if(!isNull(value)) {
        total = digitTool.add(total, parseFloat(value));
      }
    });
    
    $("tr[name='node']").each(function(index, tr) {
      var actReimburse = $(tr).find("td[name='actReimburse']").text();
      var value = "";
      if( !isNull(actReimburse) ) {
        value = actReimburse;
      } else {
        value = $(tr).find("td[name='cost']").text();
      }
      
      if(isNull(value)) {
        value = "0";
      }
      total = digitTool.add(total, parseFloat(value));
    });
    
    if(total != 0) {
      $("#total").text(total.toFixed(2));
      $("#totalcn").text(digitUppercase(total)); // 将总计数字转换为中文大写
    } else {
      $("#total").text("");
      $("#totalcn").text("");
    }
 }


var type2html = { // 新增节点时，根据类型获取生成HTML的函数
		"intercityCost": getHtmlForIntercityCost,
		"stayCost": getHtmlForStayCost,
		"cityCost": getHtmlForCityCost,
		"receiveCost": getHtmlForReceiveCost,
		"subsidy": getHtmlForSubsidy,
		"business": getHtmlForBusiness,
		"relationship": getHtmlForRelationship
	};

function initDatetimepicker() {
	$("input.datetimepick").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		toDay: true,
		bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}


function hiddenvalues(){
	var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy","business","relationship"];
	$(elements).each(function(index, ele){
		$("#"+ele).find("td[name='operation']").each(function(index,td){
			td.style.display = "none";
		});
	});
	$("div.tab_title").each(function(index, tab) {
		// 如果没有报销项，则隐藏该tab
		if( $(tab).next("table").find("tr[name='node']").length <= 0 ) {
			$(tab).parents("tr").hide();
		}
	});

	
}

function showvalues(){
	var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy","business","relationship"];
	$(elements).each(function(index, ele){
		$("#"+ele).find("td[name='operation']").each(function(index,td){
			td.style.display = "";
		});
	});
	$("div.tab_title").each(function(index, tab) {
		var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy","business","relationship"];
		if( $(tab).next("table").find("tr[name='node']").length <= 0 ) {
			$(elements).each(function(index, ele) {
				var fun = type2html[ele];
				var html = fun.call();
				$("#"+ele).find("tbody").append(html);
			});
			$(tab).parents("tr").show();
		}
		
		$("tr[name='node']").find("td").each(function(index,td){
			$(td).attr("contenteditable","true");
			}); 
		$("tr[name='node']").find("td[name='operation']").each(function(index,td){
			$(td).attr("contenteditable","false");
			}); 
		
		$("tr[name='node']").find("td[name='date']").each(function(index,td){
			$(td).attr("contenteditable","false");
			}); 
		
		 initDatetimepicker();
	});

	

}

function hiddenall(){
	
	bootstrapConfirm("提示", "执行此操作后无法再次更改表格，确定吗？", 300, function() {
	var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy","business","relationship"];
	$(elements).each(function(index, ele){
		$("#"+ele).find("td[name='operation']").each(function(index,td){
			td.style.display = "none";
		});
	});
	$("div.tab_title").each(function(index, tab) {
		// 如果没有报销项，则隐藏该tab
		if( $(tab).next("table").find("tr[name='node']").length <= 0 || $(tab).next("table").find("tr[name='node']")[0].innerText.trim() == '') {
			$(tab).parents("tr").hide();
		}
	});
	
	$("#button1")[0].style.display = 'none';
	$("#button2")[0].style.display = 'none';
	$("#button3")[0].style.display = 'none';
	updatereimbursetotal();
	});
}



function initNode() {
	var elements = ["intercityCost", "stayCost", "cityCost", "receiveCost", "subsidy","business","relationship"];
	$(elements).each(function(index, ele) {
		var nodes = $("#"+ele).find("tr[name='node']");
		if(!isNull(nodes) && nodes.length > 0) {
			$(nodes).each(function(index, node) {
				var td = $(node).find("td:last");
				if(index < nodes.length - 1) { // 不是最后的表格行
					$(td).append('<a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'add\', \''+ele+'\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'del\', \''+ele+'\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a>');
				} else {
					$(td).append('<a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'add\', \''+ele+'\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);"  style="font-size:x-large;" onclick="node(\'del\', \''+ele+'\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a>');
				}
			});
		} else {
			var fun = type2html[ele];
			var html = fun.call();
			$("#"+ele).find("tbody").append(html);
		}
	});
	
	$("tr[name='node']").find("td").each(function(index,td){
		$(td).attr("contenteditable","true");
		}); 
	
}

function initInputKeyUp() {
	$("td[name='actReimburse']," +
			"td[name='foodSubsidy'],td[name='trafficSubsidy']").bind("keyup", function() {
		updateTotal(); // 更新总计数据
	});

}


//城际交通费用节点
function getHtmlForIntercityCost() {
	var html = [];
	html.push('<tr name="node" id="node">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push('	<td></td>');
	html.push('	<td></td>');
	html.push('	<td><select style="width:100%" name="conveyance">'+$("#conveyance_hidden").html()+'</select></td>');
	html.push('	<td name="projectName"></td>');
	html.push('	<td name="actReimburse"></td>');
	html.push('	<td style="text-align:left;"></td>');
	html.push('	<td style="text-align:left;"></td>');
	html.push('	<td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'intercityCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'intercityCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}

//住宿费用节点
function getHtmlForStayCost() {
	var html = [];
	html.push('<tr name="node" id="node">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td></td>');
	html.push(' <td name="projectName"></td>');
	html.push(' <td></td>');
	html.push(' <td name="actReimburse"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'stayCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'stayCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}

//市内交通费用节点
function getHtmlForCityCost() {
	var html = [];
	html.push('<tr name="node" id="node">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td></td>');
	if (ishavatrafficTool.length > 0){
		html.push('	<td><select style="width:100%" name="conveyance">'+$("#conveyance1_hidden").html()+'</select></td>');
    }
	html.push(' <td name="projectName"></td>');
	html.push(' <td name="actReimburse"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'cityCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'cityCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 接待餐费节点
function getHtmlForReceiveCost() {
	var html = [];
	html.push('<tr name="node" id="receive">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td></td>');
	html.push(' <td name="projectName"></td>');
	html.push(' <td name="actReimburse"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'receiveCost\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'receiveCost\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}
// 补贴节点
function getHtmlForSubsidy() {
	var html = [];
	html.push('<tr name="node" id="node">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="beginDate" class="datetimepick" readonly></td>');
	html.push(' <td><input type="text" name="endDate" class="datetimepick" readonly></td>');
	html.push(' <td name="foodSubsidy"></td>');
	//html.push(' <td name="trafficSubsidy"></td>');
    if(ishavatrafficSubsidy.length>0){
        html.push(' <td name="trafficSubsidy"></td>');
    }
	html.push(' <td name="projectName"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'subsidy\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'subsidy\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');
	
	return html.join("");
}

// 业务费用节点
function getHtmlForBusiness() {
	var html = [];
	html.push('<tr name="node" id="receive">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td></td>');
	html.push(' <td name="projectName"></td>');
	html.push(' <td name="actReimburse"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'business\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'business\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');

	return html.join("");
}

// 攻关费用节点
function getHtmlForRelationship() {
	var html = [];
	html.push('<tr name="node" id="receive">');
	html.push('<input type="hidden" name="id">');
	html.push(' <td><input type="text" name="date" class="datetimepick" readonly></td>');
	html.push(' <td></td>');
	html.push(' <td name="projectName"></td>');
	html.push(' <td name="actReimburse"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td style="text-align:left;"></td>');
	html.push(' <td name="operation"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'add\', \'relationship\', this)"><img alt="添加" src="'+base+'/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node(\'del\', \'relationship\', this)"><img alt="删除" src="'+base+'/static/images/del.png" ></a></td>');
	html.push('</tr>');

	return html.join("");
}

// 初始化node行的输入框
function setNode(tr) {
	$(tr).find("td[name='cost'],td[name='actReimburse']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$(tr).find("td[name='foodSubsidy'],td[name='trafficSubsidy']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
	$(tr).find("td[name='dayRoom']").inputmask("Regex", { regex: "\\d+\\.?\\d{0,1}" });
	
	$(tr).find(".datetimepick").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		toDay: true,
		bootcssVer:3,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	$(tr).find("td[name='cost'],input[td='actReimburse']," +
			"td[name='foodSubsidy'],td[name='trafficSubsidy']").bind("keyup", function() {
		updateTotal(); // 更新总计数据
	});
	
	$("tr[name='node']").find("td").each(function(index,td){
		$(td).attr("contenteditable","true");
		}); 
	
	$("tr[name='node']").find("td[name='operation']").each(function(index,td){
		$(td).attr("contenteditable","false");
		}); 
	
	initInputKeyUp();
	
}


//动态添加节点处理函数
function node(oper, type, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr:first").remove();
		updateTotal();
	} else {
		var fun = type2html[type];
		var html = fun.call();
		$(obj).parents("tr:first").after(html);
		
		setNode($(obj).parents("tr:last"));
	}
}










