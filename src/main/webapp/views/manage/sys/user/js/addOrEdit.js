$(function() {
	initCheckbox();
	initPosition();
	initFormValidate();
	
	$("#deptDialog").initDeptDialog({
		"callBack": getDept,
		"isCheck": false
	});
	
	$("#positionDialog").initPositionDialog({
		"callBack": getPosition,
		"isCheck": true
	});

    $("#userByDeptDialog").initUserByDeptDialog({
        "callBack":getData
    });

	var initpasswd = Math.ceil(Math.random()*100000000);
	$("#password").val(initpasswd);

});

function initCheckbox() {
	if(user.roleList == null 
			|| typeof user.roleList == "undefined"
			|| 1 > user.roleList.length) {
		return ;
	}
	
	$("#roles").find("input[type='checkbox']").each(function(index, checkbox) {
		$.each(user.roleList, function(index, role) {
			if($(checkbox).val() == role.id) {
				$(checkbox).prop("checked", true);
			}
		});
	});
	
}

function getpositionname() {
	var temp = $("#positionId").val()
	if (temp != "" && temp != null) {
		return temp;
	}
}

function initPosition() {
	if(user.positionList == null 
			|| typeof user.positionList == "undefined"
			|| 1 > user.positionList.length) {
		return ;
	}
	
	var positionName = [];
	var positionId = [];
	$.each(user.positionList, function(index, position) {
		positionName.push(position.name);
		positionId.push(position.id);
	});
	
	$("#positionName").text(positionName.join(", "));
	$("#positionId").val(positionId.join(","));
}

function save() {
	$.ajax({
		url: "save",
		type: "post",
		data: $("#form1").serializeJson(),
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				backPageAndRefresh();
			} else {
				bootstrapAlert("提示", data.result, 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

function openDept() {
	$("#deptDialog").openDeptDialog();
}

function getDept(dept) {
	if(dept != null) {
		$("#deptName").text(dept.name);
		$("#deptId").val(dept.id);
	}
}

function openPosition() {
	$("#positionDialog").openPositionDialog();
}

function getPosition(positionList) {
	if(positionList != null && positionList.length > 0) {
		var positionName = [];
		var positionId = [];
		$(positionList).each(function(index, position) {
			positionName.push(position.name);
			positionId.push(position.id);
		});
		$("#positionName").text(positionName.join(", "));
		$("#positionId").val(positionId.join(","));
	} else {
		$("#positionName").text("");
		$("#positionId").val("");
	}
}

function initFormValidate() {
	$("#form1").validate({
		rules: {
			name: {
				required: true
			},
			account: {
				required: true
			},
			password: {
				required: true
			},
			deptId:{
				required: true
			}
			
		},
		messages: {
			name: {
				required: "姓名不能为空！"
			},
			account: {
				required: "帐号不能为空！"
			},
			password: {
				required: "密码不能为空！"
			},
			deptId:	{
				required: "请先选择所属部门！"
			}
			
		},submitHandler:function(form) {
			if(!checkAccount()) {
				save();
			}
		}
	});
}

function checkAccount() {
	var id = $("#id").val();
	if(id != null && id != "") {
		return false;
	}
	
	var account = $("#account").val();
	var flag = true;
	$.ajax({
		url: "checkAccount",
		type: "post",
		async: false,
		data: {"account": account},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				flag = false;
			} else {
				bootstrapAlert("提示", "账号："+account+" 已存在！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return flag;
}

var currTd = null;
function openDialog(obj) {
    currTd = obj;
    $("#userByDeptDialog").openUserByDeptDialog();
}

function getData(data) {
    if(data != null) {
        $("#principalName").val(data.name);
        $("#principalId").val(data.id);
    }
}
function getDeptName() {
    var deptName = $("#deptName").val();
    return deptName;
}