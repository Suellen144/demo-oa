var deptJson = [];
var id = null;
var parentId = null;
var is_dept = null
var name = null;
var list = [];
var sort;
var selectId;
var delID;

var role = null;
var permissMap = null;
var dataPermissionList = null;
var dpModule = null;
var is_delete=0;
$(function() {
	if($("#createDate").val() == null || $("#createDate").val() == ''){
		$("#createDate").val(new Date().pattern("yyyy-MM-dd"));
	}
	//初始化公司下拉选项
	initSelect();
	
	//下拉列表
	Organization();
	
	initDatetimepicker();
	
	initTrEvent();
	 $("#qxdy1").css("display","none");
	 
	 $('.jtoggler').jtoggler();
});

$(document).on('jt:toggled', function(event, target) {
  if($(target).prop('checked')){
		is_delete=1;
	}else{
		is_delete=0;
	}
	var name=$("#Ptitle").text();
	var id="";
	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
		if(obj.innerText == name){
			id=obj.dataset["v"];
		}
	});
	getdeptById(id);
	initSelect();
});     

/*$('input[name="my-checkbox"]').bootstrapSwitch({
   //"onColor" : "success",
    //"offColor" : "danger",
    "handleWidth" :"59px", //开关按钮宽度
    "labelText" :"历史部门",
    "onSwitchChange" : function(event, state) {
    	if(state){
    		is_delete=1;
    	}else{
    		is_delete=0;
    	}
    	var name=$("#Ptitle").text();
    	var id="";
    	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
    		if(obj.innerText == name){
    			id=obj.dataset["v"];
    		}
    	});
    	
    	getdeptById(id);
    	initSelect();
    }
}).bootstrapSwitch('state', false);*/

function ininTerr(val){
	if(isNull(val)){
		deptJson = "";
	}else{
		deptJson = getdept(val);
	}
	var tableHtml = buildTable(deptJson);
	$("#treetable tbody").html(tableHtml);
	$('#treetable').treetable('destroy');
	$("#treetable").treetable({ expandable: true });
	$("#treetable").treetable("expandAll");
	
}
function getdept(val) {
	var deptJson = [];
	$.ajax({
		url: "getInstitutionList?id="+val+"&timetamp="+new Date().getTime(),
		async:false,
		dataType: "json",
		success: function(data) {
			deptJson = data;
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}
	});
	
	return deptJson;
}
function buildTable(deptJson) {
	var html = [];
	$(deptJson).each(function(index, obj) {
		if(obj.children == null || typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = buildTable(obj.children);
			html.push(buildTr(obj));
			html.push(childHtml);
			 $(obj.childrenPosition).each(function(index, obj) {
					html.push(buildTr1(obj));
			});
		}
	});
	contextmenu_id();
	return html.join("");
}

function buildTr(dept) {
	var html = [];
	deptParent = null;
	var positon = null;
	getParentDept(dept.parentId, deptJson);
	//栏目设置
	if(dept.isDeleted == 1){
		html.push('<tr class="dept_isDeleted column" style="background-color:#D0D0D0" is_undo="'+dept.is_undo+'" data_id="'+dept.id+'" data_status="1" data-tt-id="'+dept.index+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.parentId+'" is-dept="'+dept.is_dept+'">');
	}else{
		html.push('<tr class="dept column" is_undo="'+dept.is_undo+'" data_id="'+dept.id+'" data_status="1" data-tt-id="'+dept.index+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.parentId+'" is-dept="'+dept.is_dept+'">');
	}
	if(dept.is_undo=="1"){
		html.push('<td  nowrap onclick="openDetail('+dept.id+',1)" data_id="'+dept.id+'"><p>'+(dept.name==undefined?'':dept.name)+"（撤销）"+'</p></td>');
	}else{
		html.push('<td  nowrap onclick="openDetail('+dept.id+',1)" data_id="'+dept.id+'"><p>'+(dept.name==undefined?'':dept.name)+'</p></td>');
	}
	html.push('</tr>');

	return html.join('');
}

function buildTr1(dept) {
	var html = [];
	deptParent = null;
	var positon = null;
	getParentDept(dept.deptId, deptJson);
	//栏目设置
	if(dept.isDeleted == 1){
		html.push('<tr class="edit_id_isDeleted column" style="background-color:#D0D0D0" is_undo="'+dept.is_undo+'" data_id="'+dept.id+'" data_status="2" data-tt-id="'+dept.index+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.deptId+'" is-dept="'+dept.is_dept+'">');
	}else{
		html.push('<tr class="edit_id column" is_undo="'+dept.is_undo+'" data_id="'+dept.id+'" data_status="2" data-tt-id="'+dept.index+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.deptId+'" is-dept="'+dept.is_dept+'">');
	}
	if(dept.is_undo=="1"){
		html.push('<td  nowrap onclick="openDetail('+dept.id+',2)"><p>'+(dept.name==undefined?'':dept.name)+"（撤销）"+'</p></td>');
	}else{
		html.push('<td  nowrap onclick="openDetail('+dept.id+',2)"><p>'+(dept.name==undefined?'':dept.name)+'</p></td>');
	}
	html.push('</tr>');

	return html.join('');
}

function openDetail(deptId,titleOrContent){
	$("#deptId").val(deptId);
	$.ajax({
		url: web_ctx + "/manage/responsibility/getResponsibilityByDeptId?deptId="+deptId+"&titleOrContent="+titleOrContent,
		type: "post",
		dataType: "json",
		success: function(data) {
			if(data!=null){
				$("#content").val(data.content);
				$("#titleOrContent").val(titleOrContent);
				$("#responsibilityId").val(data.id);
				//传输 id，如果查询不到数据，则代表是部门，如果查询的到，则代表是角色，赋予权限定义
				openDeptIdOrRoleId(deptId,titleOrContent);
			}
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}
	});
}

function openDeptIdOrRoleId(id,titleOrContent){
	$.ajax({
		url: web_ctx + "/manage/sys/dept/getOpenDeptIdOrRoleId?id="+id+"&titleOrContent="+titleOrContent,
		dataType: "json",
		success: function(data) {
			if(data !=null && data.role !=null ){
				 $(".replace_title").text("岗位职责");
				 $("#qxdy1").css("display","block");
				 role = data.role;
				 permissMap = data.permissMap;
				 dataPermissionList = data.dataPermissionList;
				 dpModule = data.dpModule;
				 $("#treetable_qxdy tbody").empty();
				 var menuList = getMenu();
				 var tableHtml = buildTable_qxdy(menuList);
				 $("#treetable_qxdy tbody").html(tableHtml);
				 $("#treetable_qxdy").treetable({ expandable: true});
				 $("#treetable_qxdy").treetable("expandAll");
			}else{
				$("#qxdy1").css("display","none");
				$(".replace_title").text("部门描述");
				//$("#treetable_qxdy tbody").empty();
			}
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}
	});
}

function saveResponsibility(){
	var formData = $.extend(true, {}, '');
	formData["id"]=$("#responsibilityId").val();
	formData["deptId"]=$("#deptId").val();
	formData["content"]=$("#content").val();
	formData["titleOrContent"] = $("#titleOrContent").val();
	$.ajax({
	    url:web_ctx + "/manage/responsibility/saveResponsibility",
	    data:JSON.stringify(formData),
	    type: "post",
	    dataType: "json",
		contentType: "application/json;charset=UTF-8",
	    success:function(data){
	    	doAuthority();
	    	//bootstrapAlert("提示", "保存成功！", 400, null);
	    	if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
	    },
	    error:function(){
	    	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
	    }
	})
}

//添加右键点击
function contextmenu_id(){
	$.contextMenu({
    	selector: 'tr.dept',
           callback: function(key, options) {
    	    var id=$(this).attr("data_id");
            switch(key) {
            	case 'addDept_new': addDept_new($(this).attr("data-tt-parent-id")); break;
            	case 'addNextDept_new': addNextDept_new(id,$(this)[0].innerText);break;
            	case 'addJobs_new': addJobs_new(id,$(this)[0].innerText); break ;
            	case 'editDept_new': editDept_new(id,$(this).attr("data_status")); break ;
				case 'revokeDept_new': revokeDept_new(id,$(this).attr("data_status")); break ;
            	case 'deleteDept_new': deleteDept_new(id,$(this).attr("data_status")); break ;
            }
        },
        items: {
        	"addDept_new":{ name: "新增同级部门", icon: "add" },
        	"addNextDept_new":{ name: "新增下级部门", icon: "add" },
        	"addJobs_new":{ name: "新增岗位", icon: "add" },
        	"editDept_new":{ name: "编辑", icon: "edit" },
			"revokeDept_new":{ name: "撤销", icon: "quit" },
        	"deleteDept_new":{ name: "删除", icon: "delete" }
        }
    });
	$.contextMenu({
    	selector: 'tr.edit_id',
           callback: function(key, options) {
        	    var id=$(this).attr("data_id");
				switch(key) {
					case 'editDept': editDept_new(id,$(this).attr("data_status")); break ;
					case 'revokeDept': revokeDept_new(id,$(this).attr("data_status")); break ;
					case 'permissionsInheritance': permissionsInheritance(id,$(this)[0].innerText); break ;
					case 'deleteDept': deleteDept_new(id,$(this).attr("data_status")); break ;
				}
        },
        items: {
        	"permissionsInheritance":{ name: "权限继承", icon: "edit" },
        	"editDept":{ name: "编辑", icon: "edit" },
        	"revokeDept":{ name: "撤销", icon: "quit" },
			"deleteDept":{ name: "删除", icon: "delete" }
        }
    });
	$.contextMenu({
    	selector: 'tr.edit_id_isDeleted',
           callback: function(key, options) {
        	   var id=$(this).attr("data_id");
            switch(key) {
            case 'dept_restore': restore_new(id,2); break ;
            }
        },
        items: {
        	"dept_restore":{ name: "恢复", icon: "edit" },
        }
    });
	$.contextMenu({
    	selector: 'tr.dept_isDeleted',
           callback: function(key, options) {
        	   var id=$(this).attr("data_id");
            switch(key) {
            	case 'restore': restore_new(id,1); break ;
            }
        },
        items: {
        	"restore":{ name: "恢复", icon: "edit" },
        }
    });
}
function restore_new(id,stauts){
	 bootstrapConfirm("提示", "是否确定恢复？", 300, function () {
			$.ajax({
		        "type": "POST",
		        "url": web_ctx + "/manage/sys/dept/restoreNew",
		        "dataType": "json",
		        "data": {
		            "id": id,
		            "status" :stauts
		        },
		        "success": function (data) {
		            if(data.code == 1){
		            	bootstrapAlert("提示", "恢复成功！", 400, null);
		                //backPageAndRefresh();
		                var name=$("#Ptitle").text();
		            	var id="";
		            	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
		            		if(obj.innerText == name){
		            			id=obj.dataset["v"];
		            		}
		            	});
		            	getdeptById(id);
		            }else{
		            	 bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		            }
		        },
		        "error": function (data) {
		            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
		    });
	 });
}
function addDept_new(id){
	//$("#addName").text("新增同级部门");
	//$("#deptOrPositionName").text("部门名称");	
	//$("#generateKpi_tr")[0].style.display="table-row";
	//$("#belongsDept_tr")[0].style.display="none";
	//$("#eDeptName_tr")[0].style.display="none";
	//$("#deptName").val("");
	$("#dept_status").val(1);
	$("#parentId").val(id);
	$("#operation").val(1);
	$("#deptModal").modal("show");
}
function addNextDept_new(id,name){
	$("#sign").val(0);
	//$("#addName").text("新增下级部门");
	//$("#belongsDept").text(name);
	$("#dept_status").val(1);
	$("#dept_parent_id").val(id);
	$("#parentId").val(id);
	//$("#deptOrPositionName").text("部门名称");	
	//$("#deptName").val("");
	//$("#generateKpi_tr")[0].style.display="table-row";
	//$("#belongsDept_tr")[0].style.display="table-row";
	//$("#eDeptName_tr")[0].style.display="none";
	$("#operation").val(2);
	$("#deptModal").modal("show");
}
function addJobs_new(id,name){
	$("#addName").text("新增岗位");
	$("#belongsDept").text(name);
	$("#dept_status").val(2);
	$("#dept_id").val(id);
	$("#deptOrPositionName").text("岗位名称");	
	$("#deptName").val("");
	//$("#generateKpi_tr")[0].style.display="none";
	$("#belongsDept_tr")[0].style.display="table-row";
	$("#eDeptName_tr")[0].style.display="table-row";
	$("#operation").val(3);
	$("#institutionInfoModal").modal("show");
}
function editDept_new(id,status){
	if(status == 1){
		$.ajax({
			"type": "POST",
			"url": web_ctx + "/manage/sys/dept/getDeptOrRole",
			"dataType": "json",
			"data": {
				"id": id,
				"status": status,
			},
			"success": function (data) {
				if(data!=null && data.id != null){
					$("#name").val(data.name);
					$("#deptPerson").val(data.deptPerson);
					$("#deptPhone").val(data.deptPhone);
					$("#deptAddress").val(data.deptAddress);
					if(data.responsibility == null) {
						$("#content1").val("");
					}else {
						$("#content1").val(data.responsibility.content);
					}
					$("#deptId1").val(data.id);
					$("#parentId").val(data.parentId);
					if(data.createDate != null) {
						$("#createDate").val(new Date(data.createDate).pattern("yyyy-MM-dd"));
					}else {
						$("#createDate").val(data.createDate);
					}
					if(data.deptRevokeDate != null) {
						$("#deptRevokeDate").val(new Date(data.deptRevokeDate).pattern("yyyy-MM-dd"));
					}else {
						$("#deptRevokeDate").val(data.deptRevokeDate);
					}
				}
			},
			"error": function (data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		$("#deptModal").modal("show");
	}else{
		$("#addName").text("编辑");
		$("#deptOrPositionName").text("岗位名称");	
		$("#id").val(id);
		$("#dept_status").val(status);
		$("#operation").val(4);
		$("#belongsDept_tr")[0].style.display="none";
		$.ajax({
			"type": "POST",
			"url": web_ctx + "/manage/sys/dept/getDeptOrRole",
			"dataType": "json",
			"data": {
				"id": id,
				"status": status,
			},
			"success": function (data) {
				if(data!=null && data.id != null){
					//$("#dept_id").val(data.id);
					$("#dept_status").val(status);
					$("#deptName").val(data.name);
					//if(status == 1){
					//	$(":radio[name='generateKpi'][value='" + data.generateKpi + "']").prop("checked", "checked");
					//}else if(status == 2){
					$("#eDeptName").val(data.originName);
					//}
				}
			},
			"error": function (data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
		$("#institutionInfoModal").modal("show");
	}
}

//撤销
function revokeDept_new(id,status){
	 bootstrapConfirm("提示", "是否确定撤销？", 300, function () {
		 $.ajax({
		        "type": "POST",
		        "url": web_ctx + "/manage/sys/dept/revokeDeptOrRole",
		        "dataType": "json",
		        "data": {
		            "id": id,
		            "status": status,
		        },
		        "success": function (data) {
		            if (data.code == 1) {
		                bootstrapAlert("提示", data.result, 400, null);
		                //backPageAndRefresh();
		                var name=$("#Ptitle").text();
		            	var id="";
		            	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
		            		if(obj.innerText == name){
		            			id=obj.dataset["v"];
		            		}
		            	});
		            	getdeptById(id);
		            } else {
		                bootstrapAlert("提示", data.result, 400, null);
		            }
		        },
		        "error": function (data) {
		            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
		    });
	 });
}

//删除
function deleteDept_new(id,status){
	bootstrapConfirm("提示", "是否确定删除？", 300, function () {
		$.ajax({
			"type": "POST",
			"url": web_ctx + "/manage/sys/dept/deleteDeptOrRole",
			"dataType": "json",
			"data": {
				"id": id,
				"status": status,
			},
			"success": function (data) {
				if (data.code == 1) {
					bootstrapAlert("提示", data.result, 400, null);
					//backPageAndRefresh();
					var name=$("#Ptitle").text();
					var id="";
					$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
						if(obj.innerText == name){
							id=obj.dataset["v"];
						}
					});
					getdeptById(id);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			"error": function (data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	});
}

function permissionsInheritance(id,name){
	$("#p_permissions").text(name);
	$("#permissions_id").val(id);
	$.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/sys/dept/getRole",
        "dataType": "json",
        "data": {
            "id": id
        },
        "success": function (data) {
        	//请求成功时
	    	$(data).each(function(index, obj) {
				$("#permissions_select").append("<option value="+obj.id+">"+obj.name+"</option>");
	    	});
	    	if(data !=null){
	    		openDetail(data[0].id,2);
	    	}
        },
        "error": function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	$("#permissionsInheritance").modal("show");
}

function dept_save(){
	var formData=getFormData();
	var status=formData["status"];
	 var checkMsg = checkForm(formData);
	 if (!isNull(checkMsg)) {
	        bootstrapAlert("提示", checkMsg, 400, null);
	        return;
	    } else {
	    	$.ajax({
		        "type": "POST",
		        "url": web_ctx + "/manage/sys/dept/validationName?name="+formData["name"]+"&status="+status+"&id="+$("#id").val(),
		        "dataType": "json",
		        "success": function (data) {
		            if (data.code == 1) {
		            	if(status == 1){
		            		 bootstrapAlert("提示", "部门名称已存在系统！", 400, null);
		            	}else if(status == 2){
		            		bootstrapAlert("提示", "岗位名称已存在系统！", 400, null);
		            	}
		            }else{
		            	save_Toe(formData);
		            }
		        },
		        "error": function (data) {
		        	 bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		        }
		    });
	    }
}
function save_Toe(formData){
	$.ajax({
        "type": "POST",
        "url": web_ctx + "/manage/sys/dept/saveDeptOrRole",
        "contentType": "application/json;charset=utf-8",
        "dataType": "json",
        "data": JSON.stringify(formData),
        "success": function (data) {
            if (data.code == 1) {
                bootstrapAlert("提示", data.result, 400, function() {
                	$("#institutionInfoModal").modal("hide");
                	var name=$("#Ptitle").text();
	            	var id="";
	            	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
	            		if(obj.innerText == name){
	            			id=obj.dataset["v"];
	            		}
	            	});
	            	getdeptById(id);
				});
            } else {
                bootstrapAlert("提示", data.result, 400, null);
            }
        },
        "error": function (data) {
            bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
}
function getFormData(){
	var formData = $.extend(true, {}, '');
	var id=$("#id").val();
	var deptId=$("#dept_id").val();
	var parentId=$("#dept_parent_id").val();
	var status=$("#dept_status").val();
	var deptName=$("#deptName").val();
	var eDeptName=$("#eDeptName").val();
	if(!isNull(id)){
		formData["id"]=id;
	}
	if(!isNull(deptId)){
		formData["deptId"]=deptId;
	}
	if(!isNull(status)){
		formData["status"]=status;
	}
	if(!isNull(name)){
		formData["name"]=deptName;
	}
	if(!isNull(parentId)){
		formData["parentId"]=parentId;
	}
	var operation=$("#operation").val();
	if(!isNull(operation)){
		formData["operation"]=operation;
	}
	if(status == 1){
		//var generateKpi=$("input[name='generateKpi']:checked").val();
		//if(!isNull(generateKpi)){
		formData["generateKpi"]=1;
		//}
	}else{
		formData["eDeptName"]=eDeptName;
	}
	return formData;
}

function checkForm(formData) {
	var checkMsg="";
	var status=formData["status"];
    if (!isNull(status) && status == 2) {
	    if (isNull(formData["eDeptName"])) {
	    	checkMsg="英文名称不能为空！";
	    }
    }
    if (isNull(formData["name"])) {
    	if(status == 1){
    		checkMsg="部门名称不能为空！";
    	}else if(status == 2){
    		checkMsg="岗位名称不能为空！";
    	}
    }
    return checkMsg;
}

$("#permissions_select").bind("change",function(){
    var dataId = $(this).val();
    openDetail(dataId,2);
});

function permissions_save(){
	var permissions_id=$("#permissions_id").val();
	if(permissions_id!=null){
		role.id=permissions_id;
		doAuthority();
	}
}
function isUndo() {
	$("#treetable tbody").find("tr").each(function(index,ele){
		if($(ele).attr("is_undo") == 1){			
			$(ele).css("display","none");
		}
	})
}

var deptParent = null;
function getParentDept(deptid, dept) {
	if(dept.id == deptid) {
		deptParent = dept;
	} else if(dept.children != null && dept.children.length > 0) {
		$(dept.children).each(function(index2, dept2) {
			getParentDept(deptid, dept2);
			if(deptParent != null) {
				return ;
			}
		});
	}
}
/**========================================================树菜单结束======================================================================*/
function initSelect(){
	var urls;
	if(jgszEdit=="true"){
		//urls = "/manage/institution/organizationList";
		urls= "/manage/sys/dept/organizationList?isDeleted="+is_delete;
	}else{
		//urls = "/manage/institution/organizationList2";
		urls= "/manage/sys/dept/organizationList?isDeleted="+is_delete;
	}
	$.ajax({
	    url:web_ctx + urls,
	    type: "get",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){	
	        //请求前
	    },
	    success:function(result){
	    	//$("#organization").append('<option value="">请选择需要操作的公司</option>');
	        //请求成功时
	    	$(".dropdown-menu").html("");
	    	$(result).each(function(index, obj) {
	    		//$("#organization").append('<option value="'+(obj.id)+'">'+(obj.name)+'</option>');
	    		$(".dropdown-menu").append('<li data-v="'+(obj.id)+'" data-s="'+(obj.isAccording)+'">'+(obj.name)+'</li>');
					//根据所选的公司触发公司下的组织机构 树形结构
					if(obj.id == 1){
						$("#Ptitle").html(obj.name);
						getdeptById(obj.id);
					}
	    	});

	    },
	    complete:function(){
			//请求结束时
//	    	refreshPage();
		},
	    error:function(){
	        //请求失败时
//	    	refreshPage();
	    }
	})
}

function getdeptById(val) {
	$.ajax({
		url: web_ctx + "/manage/sys/dept/getDeptAndPosition?id="+val+"&isDelete="+is_delete+"&sign="+$("#sign").val(),
		dataType: "json",
		success: function(data) {
			var tableHtml = buildTable(data);
			$("#treetable tbody").html(tableHtml);
			$('#treetable').treetable('destroy');
			$("#treetable").treetable({ expandable: true });
			$("#treetable").treetable("expandAll");
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}
	});
}
function initRoleSelect(){
	$.ajax({
		url:web_ctx + "/manage/institution/getRoleList",
		type: "get",
		cache:false,//false是不缓存，true为缓存
		async:true,//true为异步，false为同步
		beforeSend:function(){
			//请求前
		},
		success:function(result){
	        //请求成功时
	    	$(result).each(function(index, obj) {
	    		$("#position").append('<option value="'+(obj.id)+'">'+(obj.name)+'</option>');
	    	});
		},
		complete:function(){
			//请求结束时
//	    	refreshPage();
		},
		error:function(){
			//请求失败时
//	    	refreshPage();
		}
	})
}
var boot = 0;
function Organization(){
	$(".dropdown-menu").on("click","li",function(e){
		$("#Ptitle").text($(this).text())
		//切换公司时初始化岗位职责和权限定义
		$("#content").val('');
		$("#titleOrContent").val('');
		$("#deptId").val('');
		$("#responsibilityId").val('');
		$("#treetable_qxdy tbody").empty();
		$("#qxdy1").css("display","none");
		$(".replace_title").text("部门描述");
		 if($(this).attr("data-v") != "1") {
			 if(!isNull($(this).attr("data-s")) && $(this).attr("data-s") == "3") {
				 $("#sign").val(0);
			 }else {
				 $("#sign").val(1);
			 }
		 }else {
			 $("#sign").val(0);
		 }
		getdeptById($(this).attr("data-v"));
	})
}

function getMenu() {
	var menuList = [];
	$.ajax({
		url: web_ctx+"/manage/sys/menu/getMenuList",
		async: false,
		dataType: "json",
		success: function(data) {
			menuList = data;
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return menuList;
}

function buildTable_qxdy(menuList) {
	var html = [];
	
	$(menuList).each(function(index, obj) {
		if(obj.enabled != 0) {
			if(obj.children == null 
					|| typeof obj.children == "undefined") {
				html.push(buildTr_qxdy(obj));
			} else {
				var childHtml = buildTable_qxdy(obj.children);
				html.push(buildTr_qxdy(obj));
				html.push(childHtml);
			}
		}
	});
	
	return html.join("");
}

function buildTr_qxdy(menu) {
	var html = [];
	html.push('<tr data-tt-id="'+menu.id+'" data-tt-parent-id="'+menu.parentId+'">');
	if(juedeMenu(menu.id)) {
		html.push('<td nowrap><label class="checkbox-inline"><input type="checkbox" onclick="checkMenu(this)" style="vertical-align:middle; margin-top:8px;" id="'+menu.id+'" pids="'+menu.parentsId+'" checked>'+menu.name+'</label></td>');
	} else {
		html.push('<td nowrap><label class="checkbox-inline"><input type="checkbox" onclick="checkMenu(this)" style="vertical-align:middle; margin-top:8px;" id="'+menu.id+'" pids="'+menu.parentsId+'">'+menu.name+'</label></td>');
	}
	html.push('<td><div>');
	html.push(buildPermission(menu.permissionList));
	html.push('</div></td>');

	if(dpModule[menu.name]) {
		html.push('<td><a href="javascript:void(0);" onclick="showModel('+menu.id+')" style="font-size:1em;">数据授权</a></td></tr></div>');
	} else {
		html.push('<td></td></tr></div>');
	}
	
	return html.join('');
}

function buildPermission(permissionList) {
	if(permissionList == null || typeof(permissionList) == "undefined" || permissionList.length < 1) {
		return "";
	}
	
	var html = [];
	$.each(permissionList, function(index, obj) {
		if(juedePermission(obj.id)) {
			var element = '<label class="checkbox-inline"><input type="checkbox" onclick="checkParent(this)" style="vertical-align:middle; margin-top:8px;" id="'+obj.id+'" checked> '+permissMap[obj.code]+'</label>';
		} else {
			var element = '<label class="checkbox-inline"><input type="checkbox" onclick="checkParent(this)" style="vertical-align:middle; margin-top:8px;" id="'+obj.id+'"> '+permissMap[obj.code]+'</label>';
		}
		html.push(element);
	});
	
	return html.join("");
}
function checkParent(checkbox) {
	var that = checkbox;
	var inputcheck = $(that).parent().parent().find("input[type='checkbox']:checked").length;
	if($(that).prop("checked") == true){		
		$(that).parent().parent().parent().prev().find(".checkbox-inline input").prop("checked",inputcheck > 0?true:false);
	}else{
		$(that).parent().parent().parent().prev().find(".checkbox-inline input").prop("checked",inputcheck == 0?false:true);		
	}
}


function checkMenu(checkbox) {
	var that = checkbox;
	// 选中，往上的父节点都要选中状态
	if(checkbox.checked) {
		var pidsText = $(checkbox).attr("pids");
		var pids = pidsText.split(",");
		$(pids).each(function(index, pid) {
			$("#treetable_qxdy tbody").children("tr").each(function(index, tr) {
				if($(tr).children("td:first").find("input[type='checkbox']").attr("id") == pid) {
					$(tr).children("td:first").find("input[type='checkbox']").prop("checked", true);
				}
			});
		});
	} else { // 取消选择，往下的子节点都要取消选择
		var id = $(checkbox).attr("id");
		$("#treetable_qxdy tbody").children("tr").each(function(index, tr) {
			var pids = $(tr).children("td:first").find("input[type='checkbox']").attr("pids").split(",");
			$(pids).each(function(index, pid) {
				if(id == pid) {
					$(tr).children("td:first").find("input[type='checkbox']").prop("checked", false);
				}
			});
		});
		$(that).parent().parent().next().find(".checkbox-inline input").each(function(index,ele){
			$(ele).attr("checked",false);
		})
	}
}

function juedeMenu(menuid) {
	var flag = false;
	$(role.menuList).each(function(index, menu) {
		if(menuid == menu.id) {
			flag = true;
			return ;
		}
	});
	
	return flag;
}

function juedePermission(permissionid) {
	var flag = false;
	$(role.permissionList).each(function(index, permission) {
		if(permissionid == permission.id) {
			flag = true;
			return ;
		}
	});
	
	return flag;
}

function doAuthority() {
	var menuidList = [];
	var permissionidList = [];
	var dataPermission = getDataPermission();
	
	$("#treetable_qxdy tbody").children("tr").each(function(index, tr) {
		if($(tr).children("td:first").find("input[type='checkbox']").prop("checked")) {
			menuidList.push($(tr).children("td:first").find("input[type='checkbox']").attr("id"));
		}
	});
	
	$("#treetable_qxdy tbody").children("tr").each(function(index, tr) {
		var checkboxList = $($(tr).children("td")[1]).find("input[type='checkbox']");
		$(checkboxList).each(function(index, checkbox) {
			if($(checkbox).prop("checked")) {
				permissionidList.push($(checkbox).attr("id"));
			}
		});
	});
	
	$.ajax({
		url: web_ctx+"/manage/sys/role/saveAuthority",
		type: "post",
		async: false,
		data: {"menuidList": menuidList, "permissionidList": permissionidList, "roleId": role.id, "dataPermissionList": JSON.stringify(dataPermissionList)},
		dataType: "json",
		success: function(data) {
			if(data.code == 1) {
				bootstrapAlert("提示", "保存并授权成功！", 400, function() {
					window.location.href = "toList";
				});
			} else {
				bootstrapAlert("提示", "授权失败！", 400, null);
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

/*--------- 数据权限 ------------*/

$(document).ready(function(){
	$.fn.zTree.init($("#deptTree"), setting);
});

//获取部门信息
var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: true
		},
		data: {
            simpleData: {
	            enable: true,
	            idKey: "id",
	            pIdKey: "parentId",
	            rootPId: -1
            }
    	},
		async: {
			type: "get",
            enable: true,
			url: web_ctx+"/manage/sys/dept/getDeptListOnJson"
		},
		callback: {
			onAsyncSuccess: expandAll
		}
};

//展开树
function expandAll() {
	var treeObj = $.fn.zTree.getZTreeObj("deptTree"); 
	treeObj.expandAll(true);	
	initCheckedClick();
}

function showModel(menuId) {
	var deptIds = "";
	if(dataPermissionList != null && dataPermissionList.length > 0) {
		$(dataPermissionList).each(function(index, dataPermission) {
			if(menuId == dataPermission.menuId) {
				deptIds = dataPermission.deptIds;
				return ;
			}
		});
	}
	
	initTreeChecked(deptIds);
	$("#menuId").val(menuId);
	$("#authorityModal").modal("show");
}

// 设置部门树选中状态
function initTreeChecked(deptIds) {
	var zTree = $.fn.zTree.getZTreeObj("deptTree");
	zTree.checkAllNodes(false);
	if(deptIds != null && deptIds.length > 0) {
		var ids = deptIds.split(",");
		$(ids).each(function(index, id) {
			var node = zTree.getNodeByParam("id", id);
			if( !isNull(node) ) {
				zTree.checkNode(node, true, false);
				zTree.updateNode(node);
			}
		});
	}
}

// 设置点击节点名设置复选框的选中状态
function initCheckedClick() {
	$("a[treenode_a]").click(function() {
		$(this).prev("span[treenode_check]").trigger("click");
	});
}

//保存所选择的数据权限
function setDataPermission() {
	var deptIds = getDataPermission().join(",");
	var flag = true;
	if(dataPermissionList != null && dataPermissionList.length > 0) {
		$(dataPermissionList).each(function(index, dataPermission) {
			if($("#menuId").val() == dataPermission.menuId) {
				flag = false;
				dataPermission.deptIds = deptIds;
				return ;
			}
		});
	} 
	
	if(flag) {
		var dataPermission = {
				"roleId": role.id,
				"menuId": $("#menuId").val(),
				"deptIds": deptIds
		};
		dataPermissionList.push(dataPermission);
	}
}

//获取数据权限数据
function getDataPermission() {
	var result = [];
	var zTree = $.fn.zTree.getZTreeObj("deptTree");  
 var nodes = zTree.getChangeCheckedNodes(true); 

 $(nodes).each(function(index, node) {
 	result.push(node.id);
 });
 
 // 筛选父部门，如果选中父部门并且子部门也全部选中，则保留该父部门ID作为返回结果
 $(nodes).each(function(index, node) {
 	if(typeof node.children != "undefined" 
 		&& node.children != null
 		&& node.children.length > 0) {

 		// count记录该父部门下有多少子部门是选中状态
 		var count = 0;
 		$(node.children).each(function(index, nodeChild) {
 			if($.inArray(nodeChild.id, result) != -1) {
 				count++;
 			}
 		});
 		// 如果选中的子部门数量(index) 不等于 原来的子部门数量，则移除该父部门
 		if( count < (node.children.length) ) {
 			var offset = $.inArray(node.id, result);
 			if(offset != -1) {
 				result.splice(offset, 1);
 			}
 		}
 	}
 });
 
	return result;
}

function initTrEvent() {
	$("#treetable_qxdy tbody tr").click(function() {
		$(this).css("background-color", "#b4b4b4");
		var obj = this;
		$("#treetable_qxdy tbody tr").each(function(index, tr) {
			if( tr != obj ) {
				$(this).css("background-color", "inherit");
			}
		});
	});
}
function saveDeptData() {
	var formData=$('#form4').serialize();
	var submitData=decodeURIComponent(formData,true);
	var checkMsg = checkForm4(formData);
	if(!isNull(checkMsg)) {
		bootstrapAlert("提示", checkMsg.join("<br />"), 400, null);
		return ;
	}else {
		$.ajax({
			url:web_ctx + "/manage/organization/findDeptByNameAndId",
			data:{"name": $("#name").val() ,"id" : $("#deptId1").val()},
			type: "post",
			dataType:'json',
			success:function(data){
				if (data.code == 1) {
					bootstrapAlert("提示", "部门名称已存在系统！", 400, null);
				}else {
					$.ajax({
						type: "POST",
						url: web_ctx + "/manage/organization/saveOrUpdateDeptData",
						dataType: "json",
						async: true,
						data: submitData,
						success: function (data) {
							//refreshPage();
							$("#deptModal").modal("hide");
		                	var name=$("#Ptitle").text();
			            	var id="";
			            	$($(".dropdown-menu")[0].childNodes).each(function(index, obj) {
			            		if(obj.innerText == name){
			            			id=obj.dataset["v"];
			            		}
			            	});
			            	getdeptById(id);
						}
					})
				}
			}
		})
	}
}
//初始化日期控件
function initDatetimepicker() {
	$("#createDate").flatpickr({
		disable: [
			{
				from: "2016-08-16",
				to: "2016-08-19"
			},
			"2016-08-24",
			new Date().fp_incr(30) // 30 days from now
		]
	});
	$("#deptRevokeDate").flatpickr({
		disable: [
			{
				from: "2016-08-16",
				to: "2016-08-19"
			},
			"2016-08-24",
			new Date().fp_incr(30) // 30 days from now
		]
	});
}
var phone = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})|(16[0-9]{9})$/;
function checkForm4(formData) {
	var checkMsg = []
    if (!isNull($("#deptPhone").val()) && !phone.test($("#deptPhone").val())) {
        checkMsg.push("请填写正确的11位手机号码！");
    }
	if(isNull($("#name").val())){
		checkMsg.push("部门名称不能为空！");
	}
	return checkMsg;
}