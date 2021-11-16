$(function() {
	initTaskComment();
	initInput();
});



/**
 * 获取流程节点
 */
function getNodeInfo() {
	var nodeInfo = "";
	if($("#operStatus").val() == "重新申请" || $("#operStatus").val() == "取消申请") {
		nodeInfo = "提交申请";
	} else {
		nodeInfo = $("#taskName").val();
	}
	
	return nodeInfo;
}

function endProcess(status) {
	var processInstanceId = $("#processInstanceId").val();
	var variables = getVariables();
	var result = endProcessOfParallel(processInstanceId, variables);
	if(result != null) {
		if(result.code == 1) {
			setStatus(status);
		} else {
			bootstrapAlert("提示", result.result, 400, null);
		}
	} else {
		bootstrapAlert("提示", "结束流程失败，请联系管理员！", 400, null);
	}
}

//取消流程
function cancelProcess() {
	bootstrapConfirm("提示", "确定要取消申请吗？", 300, function() {
		endProcess("3");
	}, null);
}

function setStatus(status) {
	var id = $("#id").val();
	$.ajax( {   
        "type": "POST",    
        "url": web_ctx + "/manage/ad/travel/setStatus",    
        "dataType": "json",
        "data": {"id": id, "status": status},
        "success": function(data) { 
        	if(data.code == 1) {
        		var text = "操作成功！";
        		if($("#operStatus").val() == "重新申请") {
					text = "重新申请成功 ！";
				} else if($("#operStatus").val() == "取消申请") {
					text = "取消申请成功 ！";
				}
        		
        		window.parent.initTodo();
				bootstrapAlert("提示", text, 400, function() {
					backPageAndRefresh();
				});
        	} else {
        		bootstrapAlert("提示", data.result, 400, null);
        	}
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
	} );
}

//查看流程图
function viewProcess(processInstanceId) {
	var url = web_ctx+"/activiti/getImgByProcessInstancdId?processInstanceId="+processInstanceId;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("client_type", "DESKTOP_WEB");
    xhr.onload = function() {
        if (this.status == 200) {
            var blob = this.response;
            var img = document.createElement("img");
            $(img).width("100%");
            img.onload = function(e) {
                window.URL.revokeObjectURL(img.src); 
            };
            img.src = window.URL.createObjectURL(blob);
            $("#imgcontainer").html(img);
            $("#imgModal").modal("show");
        } else if(this.status == 500) {
        	bootstrapAlert("提示", this.statusText, 400, null);
        }
    }
    xhr.send();
}

/*****
 *	普通操作相关函数 
 * ****/

//新增或删除一个“行程”表格行
function node(oper, obj) {
	if(oper == "del") {
		var tr = $(obj).parents("tr").remove();
	} else {
		var html = getNodeHtml();
		$(obj).parents("tr").after(html);
		$(obj).attr("onclick", "node('del', this)");
		$(obj).text("删除");
		initDatetimepicker();
	}
}

function getNodeHtml() {
	var html = [];
	html.push('<tr name="node">');
	html.push('<td style="padding: 0px;">');
	html.push('<input type="text" name="beginDate" class="beginDate" style="width:43%;text-align:center;" readonly> 至 ');
	html.push('<input type="text" name="endDate" class="endDate" style="width:43%;text-align:center;" readonly>');
	html.push('</td>');
	html.push('<td colspan="2" class="nest_td">');
	html.push('<table>');
	html.push('<tr>');
	html.push('<td class="nest_td_left"><input type="text" name="place"></td>');
	html.push('<td><input type="text" name="task"></td>');
	html.push('</tr>');
	html.push('</table>');
	html.push('</td>');
	html.push('<td>');
	html.push('<select name="vehicle">');
	html.push('<option value="汽车">汽车</option>');
	html.push('<option value="火车">火车</option>');
	html.push('<option value="动车">动车</option>');
	html.push('<option value="高铁">高铁</option>');
	html.push('<option value="自驾车">自驾车</option>');
	html.push('</select>');
	html.push('</td>');
	html.push('<td><a href="javascript:void(0);" onclick="node(\'add\', this)">新增</a></td>');
	html.push('</tr>');
	
	return html.join("");
}

/*****
 *	页面初始化相关函数 
 * ****/
var dateRep = /^((\d{4})\-(\d{2})\-(\d{2})).*$/;
function initTaskComment() {
	var commentList = variables.commentList;
	if(isNull(commentList)) {
		commentList = [];
	}

	$(commentList).each(function(index, comment) {
		var html = [];
		html.push("<tr>");
		html.push("<td>");
		html.push(comment.node);
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approver);
		html.push("</td>");
		html.push("<td>");
		var approveDate = comment.approveDate + "";
		if( !dateRep.test(approveDate) ) {
			html.push(new Date(comment.approveDate).pattern("yyyy-MM-dd HH:mm"));
		} else {
			html.push(new Date(Date.parse(approveDate.replace(/-/g,"/"))).pattern("yyyy-MM-dd HH:mm"));
		}
		html.push("</td>");
		html.push("<td>");
		html.push(comment.approveResult);
		html.push("</td>");
		html.push('<td style="text-align:left;word-break:break-all;word-wrap:break-word;">');
		html.push(isNull(comment.comment) ? "" : comment.comment);
		html.push("</td>");
		
		$("#table2").find("tbody").append(html.join(""));
	});
}

function initInput() {
	if( !isNull(formElement) ) {
		$("#form1").find("input,select").each(function(index, ele) {
			var name = $(ele).attr("name");
			if( !isNull(formElement[name]) ) {
				$(ele).removeAttr("readonly");
			}
			if( !isNull(disableElement[name]) ) {
				$(ele).attr("readonly");
				$(ele).css("color", "gray");
			}
			
			if(name == "budget") {
				$(ele).inputmask("Regex", { regex: "\\d+\\.?\\d{0,2}" });
			}
		});
		initDatetimepicker();
	}
}

function initDatetimepicker() {
	$(".beginDate, .endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
        todayBtn: true
    });
}

function downloadAttach(obj) {
	var attachUrl = $(obj).attr("value");
	if(!isNull(attachUrl)) {
		var url = web_ctx + attachUrl;
		window.open(url,'_blank');
	}
}