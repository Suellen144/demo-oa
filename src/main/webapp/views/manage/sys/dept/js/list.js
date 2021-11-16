var deptJson = [];
var id = null;
var parentId = null
var name = null;
var level = null;
var list = [];
$(function() {
	deptJson = getdept();
	var tableHtml = buildTable(deptJson);
	$("#treetable tbody").html(tableHtml);
	$("#treetable").treetable({ expandable: true });
	$("#treetable").treetable("expandAll");
	
});


(function ($) {
    $.fn.extend({
        initTable:function (o) {
            //接受配置参数并设定默认值
            var it = this,
                tbody = $(it).children("tbody"),
                tr = $(it).children("tbody").children("tr");
            //添加事件前先移除对象所有的事件
            it.undelegate();
           if(canEdit){
        	   //表格行的移动效果
               if(o.rowMove){
               	var timer = null;  
                   var targetEl,replaceEl,mouseDown=false,mousemove=false,mouseup=false;
                   tbody.delegate("tr", "mousedown", function(e){
                   	 if(e.target.tagName.toLowerCase() === "td"){
                         	 $(this).dblclick(function() {
                         		 if ($(this).attr("name") == "睿哲科技股份有限公司") {
                         			 $("#companyname").val("睿哲科技股份有限公司");
                         			 $("#address").val("广州市天河区中山大道西89号B栋西梯701");
                         			 $("#phone").val("020-3829 9023");
                         			 $("#nubmer").val("440100593721312");
                         			 $("#companyModal").modal("show");
                             		 clearTimeout(timer);    
   							}
                         		 else if ($(this).attr("name") == "新疆睿哲网络科技有限公司") {
                         			 $("#companyname").val("新疆睿哲网络科技有限公司");
                         			 $("#address").val("新疆克拉玛依市云计算产业园 区A-00012号");
                         			 $("#phone").val("138 0977 1400");
                         			 $("#nubmer").val("");
                         			 $("#companyModal").modal("show");
                             		 clearTimeout(timer);    
   							}
                         		 else if ($(this).attr("name") == "四川睿哲网络科技有限公司") {
                         			 $("#companyname").val("四川睿哲网络科技有限公司");
                         			 $("#address").val("成都高新区益州大道北段388号8幢5层501号");
                         			 $("#phone").val("189 2510 6336");
                         			 $("#nubmer").val("");
                         			 $("#companyModal").modal("show");
                             		 clearTimeout(timer);    
   							}
                         		 else if ($(this).attr("name") == "福建润哲网络科技有限公司") {
                         			 $("#companyname").val("福建润哲网络科技有限公司");
                         			 $("#address").val("三明市泰宁县状元街142号");
                         			 $("#phone").val("134 1615 6551");
                         			 $("#nubmer").val("");
                         			 $("#companyModal").modal("show");
                             		 clearTimeout(timer);    
   							}
                         		else if ($(this).attr("name") == "沈阳睿哲科技有限公司") {
                        			 $("#companyname").val("沈阳市和平区长白西路51号时代广场B座2015");
                        			 $("#address").val("三明市泰宁县状元街142号");
                        			 $("#phone").val("138 0401 4880");
                        			 $("#nubmer").val("");
                        			 $("#companyModal").modal("show");
                            		 clearTimeout(timer);    
   							}
                         		else if ($(this).attr("name") == "武汉润哲网络科技有限公司") {
                       			 $("#companyname").val("武汉润哲网络科技有限公司");
                       			 $("#address").val("武汉市洪山区珞瑜路95号融科珞瑜中心T1栋2单元1808室");
                       			 $("#phone").val("027-8788 0550,177 6248 8997");
                       			 $("#nubmer").val("");
                       			 $("#companyModal").modal("show");
                           		 clearTimeout(timer);    
   							}
                         		else if ($(this).attr("name") == "北京睿哲广联科技有限公司") {
                      			 $("#companyname").val("北京睿哲广联科技有限公司");
                      			 $("#address").val("北京市东城区东兴隆街58号北京汇510室");
                      			 $("#phone").val("137 9897 1631");
                      			 $("#nubmer").val("");
                      			 $("#companyModal").modal("show");
                          		 clearTimeout(timer);    
   							}
                  			});	
                         }
                   	
                   	if(e.which == 3){
               	    	id = $(this).attr("data-tt-id");
               			id = id.replace("position_", "");
               			parentId = $(this).attr("data-tt-parent-id");
               			name = $(this).attr("data");
               			level = $(this).attr("nodelevel");
               			$(".selected").not(this).removeClass("selected");
               			$(this).toggleClass("selected");
               			initRightMenu();
               	    }else if(e.which == 1){	
   	                    //只对td对象触发
   	                    if(e.target.tagName.toLowerCase() === "td"){
   	                    	clearTimeout(timer);  
   	                    	timer = setTimeout(function() { 
   	                     	}, 500); 
   	                        //按下鼠标时选取行
   	                    	targetEl = this,mouseDown = true;
   	                        parentId =  $(targetEl).prev('tr.dept').attr("data-tt-id");
   	                        $(this).css({"border":"2px solid #3c8dbc" });
   	                        $(this).css("cursor","move");
   	                        return false;
   	                    }
               	    }
                   }).delegate("tr", "mousemove", function(e){
                   	mousemove=true;
                         //移动鼠标
                         if (mouseDown) {
                             //释放鼠标键时进行插入
                       	  $(tr).css({"border":"3px solid #0F0" });
                       	  replaceEl = $(targetEl).find('tr').next('tr');
                             if (targetEl != this) {
                                 if ($(this).index()>$(targetEl).index()){
                                     $($(this)).after(targetEl);
                                 } else {
                                     $($(this)).before(targetEl);
                                 }
                             }
                         }
                         return false;
                   }).delegate("tr", "mouseup", function (e) {
                   	mouseup = true;
                       $(tr).css("cursor","default");
                       $(this).css({"border":"1px solid #1E71A0"});
                       targetEl = null;
                   })
                   //鼠标离开表格时,释放所有事件
                   it.delegate("tbody", "mouseleave", function (e) {
                       $(tr).css("cursor","default");
                       targetEl = null;
                       mouseDown = false;
                   })
               }
           }
           else {
        	   tbody.delegate("tr", "mousedown", function(e){
                 	 if(e.target.tagName.toLowerCase() === "td"){
                       	 $(this).dblclick(function() {
                       		 if ($(this).attr("name") == "睿哲科技股份有限公司") {
                       			 $("#companyname").val("睿哲科技股份有限公司");
                       			 $("#address").val("广州市天河区中山大道西89号B栋西梯701");
                       			 $("#phone").val("020-3829 9023");
                       			 $("#nubmer").val("440100593721312");
                       			 $("#companyModal").modal("show");
                           		 clearTimeout(timer);    
 							}
                       		 else if ($(this).attr("name") == "新疆睿哲网络科技有限公司") {
                       			 $("#companyname").val("新疆睿哲网络科技有限公司");
                       			 $("#address").val("新疆克拉玛依市云计算产业园 区A-00012号");
                       			 $("#phone").val("138 0977 1400");
                       			 $("#nubmer").val("");
                       			 $("#companyModal").modal("show");
                           		 clearTimeout(timer);    
 							}
                       		 else if ($(this).attr("name") == "四川睿哲网络科技有限公司") {
                       			 $("#companyname").val("四川睿哲网络科技有限公司");
                       			 $("#address").val("成都高新区益州大道北段388号8幢5层501号");
                       			 $("#phone").val("189 2510 6336");
                       			 $("#nubmer").val("");
                       			 $("#companyModal").modal("show");
                           		 clearTimeout(timer);    
 							}
                       		 else if ($(this).attr("name") == "福建润哲网络科技有限公司") {
                       			 $("#companyname").val("福建润哲网络科技有限公司");
                       			 $("#address").val("三明市泰宁县状元街142号");
                       			 $("#phone").val("134 1615 6551");
                       			 $("#nubmer").val("");
                       			 $("#companyModal").modal("show");
                           		 clearTimeout(timer);    
 							}
                       		else if ($(this).attr("name") == "沈阳睿哲科技有限公司") {
                      			 $("#companyname").val("沈阳市和平区长白西路51号时代广场B座2015");
                      			 $("#address").val("三明市泰宁县状元街142号");
                      			 $("#phone").val("138 0401 4880");
                      			 $("#nubmer").val("");
                      			 $("#companyModal").modal("show");
                          		 clearTimeout(timer);    
 							}
                       		else if ($(this).attr("name") == "武汉润哲网络科技有限公司") {
                     			 $("#companyname").val("武汉润哲网络科技有限公司");
                     			 $("#address").val("武汉市洪山区珞瑜路95号融科珞瑜中心T1栋2单元1808室");
                     			 $("#phone").val("027-8788 0550,177 6248 8997");
                     			 $("#nubmer").val("");
                     			 $("#companyModal").modal("show");
                         		 clearTimeout(timer);    
 							}
                       		else if ($(this).attr("name") == "北京睿哲广联科技有限公司") {
                    			 $("#companyname").val("北京睿哲广联科技有限公司");
                    			 $("#address").val("北京市东城区东兴隆街58号北京汇510室");
                    			 $("#phone").val("137 9897 1631");
                    			 $("#nubmer").val("");
                    			 $("#companyModal").modal("show");
                        		 clearTimeout(timer);    
 							}
                			});	
                       }
                 });
           }
        }
    
    
    
    })
    
    
    
})(jQuery)

$("#treetable").initTable({
    rowMove:true,
})

function setSort(){
	 var deptList = [];
     $("tbody").find("tr.dept").each(function(){
   	  	deptList.push($(this).attr("data-tt-id"));
     });
     
      var positionList = [];
     $("tbody").find("tr.position").each(function(){
    	 deptList.push("position_"+$(this).attr("data-tt-id"));
     });
     
     $.ajax({
    	type: "POST",  
 		url: "setSort?timetamp="+new Date().getTime(),
 		dataType: "json",
 		data:{"deptList":deptList},
 		traditional: true, 
 		success: function(data) {
 			if(data.code == 1){
 				refreshPage();
 			}
 		},
 		error: function() {
 			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
 		}
 	});
}



function getdept() {
	var deptJson = [];
	$.ajax({
		url: "getDeptList?timetamp="+new Date().getTime(),
		async: false,
		dataType: "json",
		success: function(data) {
			deptJson = data;
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	
	return deptJson;
}


function initRightMenu() {
    $.contextMenu({
    	selector: 'tr.dept',
           callback: function(key, options) {
            switch(key) {
                case 'deldept': del(id); break ;
                case 'truedel': truedel(id); break ;
                case 'editdept': editdept(id);break;
                case 'adddept': adddept(parentId);break;
                case 'addchildren': addchildren(id);break;
                case 'addposition': addposition();break;
            }
        },
        items: {
        	"editdept":{ name: "编辑部门", icon: "edit" },
            "adddept": { name: "新增同级部门", icon: "add" },
        	"addchildren": { name: "新增下级部门", icon: "add" },
            "deldept": { name: "撤销部门", icon: "delete" },
            "truedel": { name: "删除部门", icon: "delete" },
        	"addposition": { name: "新增职位", icon: "add" }
        }
    });

    $.contextMenu({
    	selector: 'tr.position',
    		callback: function(key, options) {
            switch(key) {
                case 'edit': editposition(); break ;
                case 'del': delposition(); break ;
            }
        },
        items: {
            "edit": { name: "编辑职位", icon: "edit" },
            "del": { name: "删除职位", icon: "delete" }
        }
    });
}
function getPostiionUser(id){
	var positionlist = [];
	$.ajax({
		url:"getPoistionUser?timetamp="+new Date().getTime(),
		async: false,
		dataType: "json",
		contentType:"application/json;charset:UTF-8",
		data:{"id":id},
		success:function(data){
			positionlist = data;
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	})
	return positionlist;
}


function getPosition(){
	var positionJson = [];
	var position = []
	$.ajax({
		url: "getDeptWithPositionInList?timetamp="+new Date().getTime(),
		async: false,
		dataType: "json",
		success: function(data) {
				positionJson = data;
		},
		error: function() {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
	$(positionJson).each(function(index, obj){
		if (obj.nodetype == "position") {
			position.push(obj);
		}
	});
	return position;
}


function bulidposition(){
	var positionJson = getPosition();
	$(positionJson).each(function(index, obj){
		buildTr(obj);
	});
}

function buildTable(deptJson) {
	var html = [];
	var dept = [];
	var position = [];
	$(deptJson).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = buildTable(obj.children);
			html.push(buildTr(obj));
			html.push(childHtml);
		}
	});
	return html.join("");
}

function buildTr(dept) {
	var html = [];
	deptParent = null;
	var positon = null;
	getParentDept(dept.parentId, deptJson);
	var positionJson = getPosition();
	if (dept.name == "组织架构") {
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "总经理"){
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "总经办"){
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "总监"){
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "副总经理"){
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "沈阳办事处"){
		html.push('<tr style="display:none;">');
	}
	else if(dept.name == "郑州办事处"){
		html.push('<tr class="dept column" data-tt-id="'+dept.id+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.parentId+'">');
		html.push('<td  nowrap style="padding-left:26px;">'+dept.name+'</td>');
		html.push('<td  nowrap></td></tr>');
	}
	else{
		html.push('<tr class="dept column" data-tt-id="'+dept.id+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.parentId+'">');
		html.push('<td  nowrap>'+dept.name+'</td>');
		html.push('<td  nowrap></td></tr>');
	}
	$(positionJson).each(function(index, obj){
		var name = [];
		if (obj.parentId == "dept_"+dept.id  && obj.parentId != "dept_2" &&  obj.parentId != "dept_10" && obj.name != "沈阳办事处管理") {
			if(obj.name == "总经理" && obj.parentId == "dept_31"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>杨国良</td>');
			}
			else if(obj.name == "总经理" && obj.parentId == "dept_15"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>谭文波</td>');
			}
			else if(obj.name == "总经理" && obj.parentId == "dept_16"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>周娟瑶</td>');
			}
			else if(obj.name == "总经理" && obj.parentId == "dept_21"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap ><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>张志明</td>');
			}
			else if(obj.name == "总经理" && obj.parentId == "dept_25"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap></td>');
			}
			else if(obj.name == "沈阳总经理" && obj.parentId == "dept_26"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>总经理</td>');
				html.push('<td  nowrap>刘士杰</td>');
			}
			else if(obj.name == "总经理" && obj.parentId == "dept_27"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap ><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>陈琦</td>');
			}
			else if(obj.name == "董事"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>杨达开，杨国良，王伟明，严健渝，茅荣</td>');
			}
			else if(obj.name == "总监助理"){
			}
				else if(obj.name == "会计复核"){
					}
				else if(obj.name == "会计经办"){
					}
				else if(obj.name == "财务"){
					}
			else if(obj.name == "监事"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>关志华，李伟波,刘建文</td>');
			}
			else if(obj.name == "监事会主席"){
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>关志华</td>');
			}
			else if(obj.name == "副总经理" && obj.parentId == "dept_31") {
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>王伟明</td>');
			}
			else if(obj.name == "市场总监" ) {
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>陈琦</td>');
			}
			else if(obj.name == "技术总监" ) {
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>李伟波</td>');
			}
			else if(obj.name == "财务总监" ) {
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap style="padding-left: 18px;"><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>黄瑞瑜</td>');
			}
			else{
				html.push('<tr  class="position" data="'+obj.name+'" nodelevel = "'+obj.nodelevel+'"sort="'+obj.sort+'"data-tt-id="'+obj.id+'" data-tt-parent-id="'+dept.id+'">');
				html.push('<td  nowrap><i class ="icon-user"style="padding-right:3px;"></i>'+obj.name+'</td>');
				html.push('<td  nowrap>'+getPostiionUser(obj.id.replace("position_", ""))+'</td>');
			}
		}
	});
	html.push('</tr>');
	return html.join('');
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


/*部门右键操作Start*/
function editdept(id){
	window.location.href = "toAddOrEdit?id="+id+"&isEdit=true";
}

function adddept(id){
	window.location.href = "toAddOrEdit?id="+id;
}


function addchildren(id){
	window.location.href = "toAddOrEdit?id="+id;
}


var idForDel = null;
function del(id) {
	idForDel = id;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax({
			url: "delete/"+idForDel,
			dataType: "json",
			success: function(data) {
				if(data.code == 1) {
					bootstrapAlert("提示", data.result, 400, null);
					location.replace(location.href);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}

//真实删除
function truedel(id) {
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax({
			url: "truedel/"+id,
			dataType: "json",
			success: function(data) {
				if(data.code == 1) {
					bootstrapAlert("提示", data.result, 400, null);
					location.replace(location.href);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}
/*部门右键操作End*/


/*职位右键操作Start*/
function editposition(){
	$("#positionName").text("编辑职位");
	$("#id").val(id);
	$("#deptId").val(parentId);
	$("#name").val(name);
	if(!isNull(level)) {
		if(level == "undefined"){
			$("#level").find("option:last").prop("selected", true);
		}
		else{
			$("#level").find("option[value="+level+"]").prop("selected", true);
		}
	}
	else {
		$("#level").find("option:last").prop("selected", true);
	}
	$("#saveBtn").attr("onclick", "update()");
	$("#positionModal").modal("show");
	
}


var digits = /^\d{3}$/;
function checkForm() {
	var formData = $("#form").serializeJson();
	var text = [];
	if(isNull(formData.name)) {
		text.push("中文名不能为空！");
	}
	
	return text;
}


function delposition() {
	bootstrapConfirm("提示", "是否删除该职位？", 300, function() {
		$.ajax({
			url: web_ctx+"/manage/ad/position/delete",
			dataType: "json",
			data: {"id":id},
			success: function(data) {
				if(data.code == 1) {
					location.replace(location.href);
				} else {
					bootstrapAlert("提示", data.result, 400, null);
				}
			},
			error: function(data) {
				bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			}
		});
	}, null);
}



function addposition(){
	$("#positionName").text("新增职位");
	$("#deptId").val(id);
	$("#id").val("");
	$("#name").val("");
	$("#level").find("option:last").prop("selected", true);
	$("#saveBtn").attr("onclick", "save()");
	$("#positionModal").modal("show");
}



function save() {
	var msg = checkForm();
	if(msg.length) {
		bootstrapAlert("提示", msg.join("<br/>"), 400, null);
		return ;
	}
	$.ajax({
		url:web_ctx+"/manage/ad/position/save",
		type: "POST",
		dataType: "json",
		data:$("#form").serializeJson(),
		success:function(data){
			if(data.code==1){
				$("#positionModal").modal("hide");
				location.replace(location.href);
			} else {
				bootstrapAlert("提示", "保存失败！", 400, null);
			}
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}


function update() {
	var msg = checkForm();
	if(msg.length) {
		bootstrapAlert("提示", msg.join("<br/>"), 400, null);
		return ;
	}
	if($("#form")){
		$.ajax({
			url:web_ctx+"/manage/ad/position/save",
			type: "POST",
			dataType: "json",
			data:$("#form").serializeJson(),
			success:function(data){
				if(data.code==1){
					$("#positionModal").modal("hide");
					location.replace(location.href);
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


/*职位右键操作End*/




