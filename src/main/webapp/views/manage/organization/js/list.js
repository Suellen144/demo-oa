var deptJson = [];
var id = null;
var parentId = null
var name = null;
var level = null;
var list = [];
var width = $(window).width();
$(window).resize(function() {
	mobileTree();
    
})

//移动端树表单
function mobileTree(){
	width = $(this).width();
	if(width < 578) {				
		$("#treetable tbody").find("tr").each(function(index,ele){
			var spwidth = $(ele).find(".indenter").outerWidth(true)
			var num = spwidth/19;
			if( num == 1){
				$(ele).find("p").eq(0).css("width","80px")
			}else{
				$(ele).find("p").eq(0).css("width",(80- num *6) +"px")
			}	
		});
	    
		$(".divTree").css({"overflow": "hidden","max-height":" 400px"})
	}else{
		$("#treetable tbody").find("tr").each(function(){
			$(this).find("p").eq(0).css("width","70%")
		})
	}
}



//初始化手指坐标点
var startPoint = 0;
var startEle = 0;
var timeOutEvent_1;
//移动端页面
function mobilePage(){
	var startX,startY;
	$(".divTree").css({"overflow": "hidden","max-height":" 480px"})
	if($(window).width() < 578) {
		$("#treetable1 thead").css("line-height","13px")		
		$("#form2").css({'overflow':'hidden','max-height':'430px'})
		$("#form2").on('touchstart',function(e){
			if(e.target.tagName != 'UL' || e.target.tagName != 'LI'){
				$(".InfoModal").css("z-index",-100);
			}
		})
			
		
		$("#table2").get(0).addEventListener('touchstart', function(e){
			//e.preventDefault();	

			try {
		        var touch = e.touches[0]; //获取第一个触点
		        var x = Number(touch.pageX); //页面触点X坐标
		        var y = Number(touch.pageY); //页面触点Y坐标
		    
		        startPoint = e.changedTouches[0].pageY;
		        startEle = $("#table2").get(0).offsetTop;
		        //记录触点初始位置
		        startX = x;
		        startY = y;
		    } catch (e) {
		        //alert('touchSatrtFunc：' + e.message);
		    }
		    if(!timeOutEvent_1){
		    	
		    
				timeOutEvent_1 = setTimeout(function(){				
					timeOutEvent_1=0;
					
					if($(e.target.parentNode.parentNode).is(".node")){
						if(startX > $(window).width()/2){;
							$(".InfoModal").css({"z-index":"10","top": (startY - 120)+"px","left": (startX - parseInt($(".InfoModal").width())) +"px"})
						}else{
							$(".InfoModal").css({"z-index":"10","top": (startY - 120)+"px","left": startX+"px"})
						}
						var id = $(e.target.parentNode.parentNode).find("input[name='uuid']").val()
						$(".InfoModal .liMove").empty();
						$(".InfoModal").css("z-index",10);
		    			$(".InfoModal .liMove").append('<li ontouchstart="added()">新增</li><li ontouchstart="removeTr(\''+id+'\')">删除</li>');
					}
	
					
					//菜单栏:
					//initRightMenu();
	
				},500);//这里设置定时器，定义长按500毫秒触发长按事件，

		    }
		    //e.preventDefault();	
			//e.stopPropagation();
		}, false);
		
		$("#table2").get(0).addEventListener('touchmove', function(e){
			clearTimeout(timeOutEvent_1);//清除定时器   
			timeOutEvent_1 = 0; 
			e.preventDefault();	
			var currPoint = e.changedTouches[0].pageY;
		    var disX = currPoint - startPoint;
		    var top = startEle - 15 + disX;
		    //console.log(currPoint,disX)
		    
		    var boxH = $(".table2Div").height();
		    var boxBodyH = $("#table2").height();
		    
		   // console.log(boxH ,boxBodyH)
		    if(boxH < boxBodyH){

		    	if( top > 0){
			    	$("#table2").css("top", 0 +'px');
			    }else if(boxBodyH == boxH + Math.abs(top)){
			    	$("#table2").css("top",top - 10 + 'px');
			    }else if(boxBodyH > boxH + Math.abs(top)){
			    	$("#table2").css("top",top + 'px');
			    }
		    }
		   	
		}, false);
		
		$("#table2").get(0).addEventListener('touchend', function(e){
			clearTimeout(timeOutEvent_1);  
            if (timeOutEvent_1 != 0) {  
            	$(".InfoModal").css("z-index",-100);
                
                if($(e.target).is(".changeH")){
                	$(e.target).focus();               	
                }else if($(e.target).is(".changeXM")){
                	console.log(235698)
            		$(e.target).trigger("selected");
                }else if($(e.target).is(".changeBGRQ")){
                	var i = $(e.target.parentNode.parentNode).index();
                	
                }
            }  
            return false;  
			
		}, false);
		
		
		
		
		$("#treetable tbody").get(0).addEventListener('touchstart', function(e){
			e.preventDefault();
			if(e.target.tagName == "P" ){
				$(e.target.parentNode.parentNode).css("border","2px solid #3c8dbc");
			}else if(e.target.tagName == "TD"){
				$(e.target.parentNode).css("border","2px solid #3c8dbc");	
			}
			
			try {
		 
		        var touch = e.touches[0]; //获取第一个触点
		        var x = Number(touch.pageX); //页面触点X坐标
		        var y = Number(touch.pageY); //页面触点Y坐标
		        //记录触点初始位置
		        
		        startPoint = e.changedTouches[0].pageY;
		        startEle = $("#treetable").get(0).offsetTop;
		        startX = x;
		        startY = y;		 		 
		    } catch (e) {
		        //alert('touchSatrtFunc：' + e.message);
		    }			
			
			timeOutEvent = setTimeout(function(){
				
				timeOutEvent=0;
				
				if(e.target.tagName == "P"){
					$(e.target.parentNode.parentNode).css("border","0");
					id = $(e.target.parentNode.parentNode).attr("data-tt-id");
					id = id.replace("position_", "");
					parentId = $(e.target.parentNode.parentNode).attr("data-tt-parent-id");
					$(".selected").not(e.target.parentNode.parentNode).removeClass("selected");
					$(e.target.parentNode.parentNode).toggleClass("selected");
					if(startX > $(window).width()/2){
						$(".liAlert").css({"display": "block","top": (startY - parseInt($(".liAlert").height()))+"px","left": (startX - parseInt($(".liAlert").width())) +"px"})
					}else{
						$(".liAlert").css({"display": "block","top": (startY - parseInt($(".liAlert").height()))+"px","left": startX+"px"})
					}
				}else if(e.target.tagName == "TD"){
					$(e.target.parentNode).css("border","0");	
					id = $(e.target.parentNode).attr("data-tt-id");
					id = id.replace("position_", "");
					parentId = $(e.target.parentNode).attr("data-tt-parent-id");
					$(".selected").not(e.target.parentNode).removeClass("selected");
					$(e.target.parentNode).toggleClass("selected");
					if(startX > $(window).width()/2){
						$(".liAlert").css({"display": "block","top": (startY - parseInt($(".liAlert").height()))+"px","left": (startX - parseInt($(".liAlert").width())) +"px"})
					}else{
						$(".liAlert").css({"display": "block","top": (startY - parseInt($(".liAlert").height()))+"px","left": startX+"px"})
					}
				}
				
				if(zzgxedit=="true"){
					$(".liAlert .liMove").empty();
        			$(".liAlert .liMove").append('<li data-v="'+id+'" ontouchstart="editOgn(this)">编辑</li>'+
        					'<li data-v="'+id+'" ontouchstart="addOgn(this)">新增</li>'+
        					'<li data-v="'+id+'" ontouchstart="truedel(this)">删除</li>');
				}else{
		        	$(".liAlert .liMove").empty();
        			$(".liAlert .liMove").append('<li data-v="'+id+'" ontouchstart="queryInfo(this)">查看</li>');
				}
				
				//菜单栏:
				//initRightMenu();
				
				
				
			},500);//这里设置定时器，定义长按500毫秒触发长按事件，时间可以自己改，个人感觉500毫秒非常合适   
		    return false; 
	
		}, false);
		
		$("#treetable tbody").get(0).addEventListener('touchmove', function(e){
			clearTimeout(timeOutEvent);//清除定时器   
		    timeOutEvent = 0; 
		    if(e.target.tagName == "P" ){
				$(e.target.parentNode.parentNode).css("border","0");	
			}else if(e.target.tagName == "TD"){
				$(e.target.parentNode).css("border","0");	
			}
		    
		    var currPoint = e.changedTouches[0].pageY;
		    var disX = currPoint - startPoint;
		    var top = startEle - 110 + disX;
		    
		    var boxH = $(".divTree").height();
		    var boxBodyH = $("#treetable").height();
		    console.log(boxH , boxBodyH)
		    if(boxH < boxBodyH){
		    	if( top > 0){
			    	$("#treetable").css("top", 0 +'px');
			    }else if(boxBodyH == boxH + Math.abs(top)){
			    	console.log(top)
			    	$("#treetable").css("top",top - 10 + 'px');
			    }else if(boxBodyH > boxH + Math.abs(top)){
			    	$("#treetable").css("top",top + 'px');
			    }
		    }
		    
		    
		}, false);
		var touchtime = 0;
		$("#treetable tbody").get(0).addEventListener('touchend', function(e){
			var dataId ;
			
			if(e.target.tagName == "P"){
				dataId = $(e.target.parentNode.parentNode).attr("data-tt-id");
			}else if(e.target.tagName == "TD"){
				dataId = $(e.target.parentNode).attr("data-tt-id");
			}else if(e.target.tagName == "A"){
				if($(e.target.parentNode.parentNode.parentNode).is(".expanded")){
					$(e.target.parentNode.parentNode.parentNode).addClass("collapsed")
					$(e.target.parentNode.parentNode.parentNode).removeClass("expanded")
					var id = $(e.target.parentNode.parentNode.parentNode).attr("data-tt-id")
					var i = 0;
					treeNone(id)	
				}else{
					$(e.target.parentNode.parentNode.parentNode).addClass("expanded")
					$(e.target.parentNode.parentNode.parentNode).removeClass("collapsed")
					var id = $(e.target.parentNode.parentNode.parentNode).attr("data-tt-id")
					var i = 1;
					treeRow(id)
				}
			}else if(e.target.tagName == "SPAN"){
				if($(e.target.parentNode.parentNode).is(".expanded")){
					$(e.target.parentNode.parentNode).addClass("collapsed")
					$(e.target.parentNode.parentNode).removeClass("expanded")
					var id = $(e.target.parentNode.parentNode).attr("data-tt-id")
					var i = 0;
					treeNone(id)
				}else{
					$(e.target.parentNode.parentNode).addClass("expanded")
					$(e.target.parentNode.parentNode).removeClass("collapsed")
					var id = $(e.target.parentNode.parentNode).attr("data-tt-id")
					var i = 1;
					treeRow(id)
				}
			}
			
			if(e.target.tagName == "P" || e.target.tagName == "TD"){
				clearTimeout(timeOutEvent);//清除定时器   
			    if(timeOutEvent!=0){   
			    	$("#modileMenu").css("display","none")
			    	clearTimeout(time)
					//$(e.target.parentNode.parentNode).css("border","2px solid #3c8dbc")
					var time = setTimeout(function(){
						if(e.target.tagName == "P" ){
							$(e.target.parentNode.parentNode).css("border","0");	
						}else if(e.target.tagName == "TD"){
							$(e.target.parentNode).css("border","0");	
						}
						
					},500)
			    	

					$(".modal-dialog").css("width","100%");
					$(".modal-dialog").css("margin","0px");
					$(".modal-header").css("width","100%");
					$("#formPtyh table").css("width","100%");
					$("#form table").css("width","100%");
					
					inforStyle();
					$(".liAlert").css("display", "none");
			        //alert("你这是点击，不是长按");   
					if(0 == touchtime) {
						touchtime = new Date().getTime();
					} else {
						if(new Date().getTime() - touchtime < 300) {
							//弹除基本信息窗口
							queryInfo(dataId)
							$(".liAlert").css("display", "none")
						} else {
							//如果第二次点击在第一次点击0.5秒后，
							//则第二次点击默认为下一次双击判断的第一次点击
							touchtime = new Date().getTime();
						}
					}
					
			    }   
			    return false;
			}else{
				timeOutEvent = 0; 
			}
			
		}, false);
		
		
		
		$("#treetable tbody").find("tr").each(function(index,ele){
			var spwidth = $(ele).find(".indenter").outerWidth(true)
			var num = spwidth/19;
			if( num == 1){
				$(ele).find("p").eq(0).css("width","80px")
			}else{
				$(ele).find("p").eq(0).css("width",(80- num *6) +"px")
			}	
		})	
	}
}


function treeNone(id){

	$("#treetable tbody").find("tr[data-tt-parent-id="+id+"]").each(function(){
		$(this).css("display","none")
		if($("#treetable tbody").find("tr[data-tt-parent-id="+$(this).attr("data-tt-id")+"]").length > 0){
			treeNone($(this).attr("data-tt-id"))
		}
		
	})

}

function treeRow(id){
	$("#treetable tbody").find("tr[data-tt-parent-id="+id+"]").each(function(){
		$(this).css("display","table-row")
		if($("#treetable tbody").find("tr[data-tt-parent-id="+$(this).attr("data-tt-id")+"]").length > 0){
			treeRow($(this).attr("data-tt-id"))
		}
	})
}

//基本信息栏样式
function inforStyle() {
	$(".modal-body #form tbody").find("tr").each(function(index,ele){
		clearTimeout(textTime)
		$(ele).find("td").css("border-right","1px solid #CCCCCC")
		$(ele).find("input").css("line-height","28px");
		$(ele).find("select").css("line-height","28px");
		$(ele).find("#gsdz").css("display","none");
		$(ele).find("#khhdz").css("display","none");
		$(ele).find(".gsdz").css("display","block");
		$(ele).find(".khhdz").css("display","block");
		$(ele).css("float","none");
		var textTime = setTimeout(function(){
			if($(ele).find("th p").get(0).scrollHeight > 30){
				$(ele).find("th").css("height","60px");
				$(ele).find("td").css("height","60px");
			}
			
			if($(ele).find("td textarea").css("display") == "block" && index != 20){
				$(ele).find("td textarea").attr("rows",1);
				$(ele).find("th").css("height","30px");
				$(ele).find("td").css("height","30px");
				var rows = parseInt(($(ele).find("td textarea").get(0).scrollHeight - 12) / 20); //获取行数
				var valRow = $(ele).find("td textarea").attr("rows");
				if(rows > 1){
					$(ele).find("td textarea").attr("rows",rows);
					$(ele).find("th").css("height",rows*22 +"px");
					$(ele).find("td").css("height", rows*22 +"px");
				}else{
					$(ele).find("td textarea").attr("rows",1);
					$(ele).find("th").css("height","30px");
					$(ele).find("td").css("height","30px");
				}

			}
			
			if(index == 20){
				$(ele).find("td").css("border-left", 0);
				$(ele).find("td textarea").attr("rows",0);
				$(ele).find("th").css("border-right", "1px solid #ccc");
				var rows = parseInt(($(ele).find("td textarea").get(0).scrollHeight - 12) / 20);
				if(rows > 5) {
					$(ele).find("td textarea").attr("rows",rows);
					$(ele).find("th").css("height",rows*23 +"px");
					$(ele).find("td").css("height", rows*23 +"px");
				}else{
					$(ele).find("td textarea").attr("rows",5);
					$(ele).find("th").css("height","100px");
					$(ele).find("td").css("height", "100px");
				}	
			}

		},200)
		
		if(index == 20){
			$(ele).find("td").css("width","70%");
			$(ele).find("th").css("width","30%");
		}
	})
}


//移动端变更页面适配
function modileChange () {
	if($(window).width() < 578){
		$("#table2").css("width","100%");
		$("#table2").find("input").each(function(){
			$(this).css("background","none")
		})
	}
}



//适配部分页面
function lookTable(width){
	if(width < 1150 && width > 800){
		$(".modal-dialog").css("width","80%");
		$("#form table").css("width","80%");
		$(".modal-dialog").css("margin","30px auto");
		$(".modal-body #form tbody").find("tr").each(function(index,ele){
			$(ele).css("float","left");
			$(ele).find("td").css("border-right","0")
			if(index != 20){
				$(ele).css("height","60px");
				$(ele).find("th").css("height","60px");
				$(ele).find("td").css("height","60px");
			}	
		})
		$("#treetable tbody").find("tr").each(function(){
			$(this).find("p").eq(0).css("width","70%")
		})
	}else if(width < 800 && width > 415){
		$(".modal-dialog").css("width","80%");
		$("#form table").css("width","80%");
		$(".modal-dialog").css("margin","30px auto");
		$(".modal-body #form tbody").find("tr").each(function(index,ele){
			$(ele).find("td").css("border-right","1px solid #CCCCCC")
			$(ele).css("float","none");
			if(index == 20){
				$(ele).find("td").css("width","70%");
				$(ele).find("th").css("width","30%");
			}
		})
		
		$("#treetable tbody").find("tr").each(function(){
			$(this).find("p").eq(0).css("width","70%")
		})
	}else if(width < 415){
		$(".modal-body #form tbody").find("tr").each(function(index,ele){
//			$(ele).find("td").css("border-right","1px solid #CCCCCC")
			$(ele).css("float","none");
			if(index == 20){
				$(ele).find("td").css("width","70%");
				$(ele).find("th").css("width","30%");
			}
		})
		$(".modal-dialog").css("width","100%");
		$(".modal-dialog").css("margin","0px");
		$("#form table").css("width","100%");	
		
	}else{
		$(".modal-dialog").css("width","80%");
		$("#form table").css("width","80%");
		$(".modal-dialog").css("margin","30px auto");
		$(".modal-body #form tbody").find("tr").each(function(index,ele){
			if(index != 20){
				$(ele).css("height","30px");
				//$(ele).find("th").css("height","30px");
				//$(ele).find("td").css("height","30px");
			}	
		})
		$("#treetable tbody").find("tr").each(function(){
			$(this).find("p").eq(0).css("width","70%")
		})
	}
}

$(function() {

	//初始化Orgchat树形结构
    setTreeInfo(1);

	var width = $(window).width();
//	deptJson = getdept();
//	var tableHtml = buildTable(deptJson);
//	$("#treetable tbody").html(tableHtml);
	$('#treetable').treetable('destroy');
	$("#treetable").treetable({ expandable: true });
	/*$("#treetable").treetable("expandAll");*/
	
	//初始化日期
	initDatetimepicker();
	
	//初始化上级单位下拉框
	initSelect();
	
	//初始化变更表单右键选项
	initMenu();
	
	//权限
	userAuthority(zzgxedit);	
	
	lookTable(width);
	
	$(".Changeblack").click(function(){
		$("#ognInfoModal").modal("show");
		$("#ognInfoModal").css("overflow-y",'auto');
	})
    showSwitch();
});


//初始化弹出框位置
function initializePop(){
	var div = $("#deptModal");
	var div1 = $("#deptModal2");
	var div2 = $("#ognChangeInfoModal");
	var div3 = $("#ognInfoModal2");
	var div4 = $("#ognInfoModal");
	if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
		var scrollTop= window.parent.document.childNodes[1].scrollTop;
		div[0].style.top=scrollTop + "px";
		div1[0].style.top=scrollTop + "px";
		div2[0].style.top=scrollTop + "px";
		div3[0].style.top=scrollTop + "px";
		div4[0].style.top=scrollTop + "px";
	}else{
		div[0].style.top=+ "200px";
		div1[0].style.top=+ "200px";
		div2[0].style.top=+ "200px";
		div3[0].style.top=+ "200px";
		div4[0].style.top=+ "200px";
	}
}
/**========================================================Orgchart树形结构开始======================================================================*/
//加载树形数据：ajax请求获取json格式的数据
function setTreeInfo(sign){
    $.ajax({
        url: "getDeptList?timetamp="+new Date().getTime()+"&sign="+sign,
        async: false,
        dataType: "json",
        success:function (data) {
            setTreeView(data);
            console.log("数据加载成功！");
        },
        error: function(){
            console.log("加载数据异常！");
        }
    });
}

//加载树形结构
function setTreeView(dataJson){
    $('#chart-container').orgchart({
        'data' : dataJson,
        'toggleSiblingsResp': false,
        'direction': 'T2B',
        /*'exportButton':true,*/
        'parentNodeSymbol': null,
        'nodeTemplate': setNodeTemplate,
        'createNode': function($node, data) {
            if(data.level != 1){
                //横排竖排 思路 给竖向的td上加上class tdp
                $node.addClass('hNode');
            }else {
                $node.addClass('zNode');
            }
            if(data.generateKpi == 1 ||data.generateKpi == 0) {
                if(data.isDeleted == 0) {
                    $node.addClass('nodeK');
                }else {
                    $node.addClass('nodeD');
                }
            }else {
                if(data.isDeleted == 0) {
                    $node.addClass('nodeN');
                }else {
                    $node.addClass('nodeD');
                }
            }
        }
    });
}

//设定树形模板。这个是重点，对于每个节点的生成样式与内容都在这里进行控制
function setNodeTemplate(data){
    var str = "";
    if(data.generateKpi == 1 ||data.generateKpi == 0) {
        if(data.isDeleted == 0 || data.isDeleted == null) {
            str += '<div class="title clan-man" name="generateKpi" id="generateKpi">'+data.name+'</div>' ;
        }else {
            str += '<div class="title clan-man" name="deleteNode" id="deleteNode" style="background-color: #aaa;">'+data.name+'</div>' ;
        }
	}else {
        if(data.isDeleted == 0 ||data.isDeleted == null) {
            str += '<div class="title clan-man" name="nodeN" id="nodeN">'+data.name+'</div>' ;
        }else {
            str += '<div class="title clan-man" name="deleteNode2" id="deleteNode2" style="background-color: #aaa;">'+data.name+'</div>' ;
        }

	}
    return str;
}
/**========================================================Orgchart树形结构结束======================================================================*/

function showSwitch() {
	 $('.jtoggler').jtoggler();
	 showDeleteData(1);
}
$(document).on('jt:toggled', function(event, target) {
	  if($(target).prop('checked')){
		     showDeleteData(2)
	      }else{
	          showDeleteData(1)
	      }
	}); 
/*function showSwitch() {
    $('#my-checkbox').bootstrapSwitch({
        //"offColor" : "danger",
        "handleWidth" :"59px", //开关按钮宽度
        "labelText" :"历史部门",
        "onSwitchChange" : function(event, state) {
            if(state){
                showDeleteData(2)
            }else{
                showDeleteData(1)
            }
        },
        "onInit" : function (event, state){
            $(".bootstrap-switch-wrapper").css("top","6px");
        }
    }).bootstrapSwitch('state', null);
}*/

var selectData;
//用户权限
function userAuthority (user){
	if(user){
		$("#CompanyType").html('<select style="background-color:#3c8dbc;color:#fff;cursor: pointer; text-align: center;">'
                                		+'<option value="" selected>存续公司/注销公司/售出公司</option>'
                                		+'<option value="0">存续公司</option>'
                                		+'<option value="1">注销公司</option>'
                                		+'<option value="2">售出公司</option></select>')
	}else{
		$("#CompanyType").html('<select style="width:100%; background-color:#3c8dbc;color:#fff; padding:.3em 1em .1em 1em;cursor: pointer;" disabled="disabled">'
        		+'<option value="0">存续公司</option></select>')
        		
	}
} 

/*function getdept() {
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
			if($(window).width() < 578) {
			    $(".modal-dialog").css("margin","20px auto");
			}
		}
	});
	
	return deptJson;
}*/
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
	if (dept.name == "组织架构") {
		html.push('<tr style="display:none;">');
	}else{
		//栏目设置
		html.push('<tr class="dept column" data-tt-id="'+dept.id+'" name="'+dept.name+'" sort="'+dept.sort+'" data-tt-parent-id="'+dept.parentId+'">');
		html.push('<td  nowrap><p>'+(dept.name==undefined?'':dept.name)+'</p></td>');
		html.push('<td  nowrap><p>'+(dept.clrq==undefined?'':dept.clrq)+'</p></td>');
		html.push('<td  nowrap><p>'+(dept.zczb==undefined?'':dept.zczb)+'</p></td>');
		html.push('<td  nowrap><p>'+(dept.frdb==undefined?'':dept.frdb)+'</p></td>');
		html.push('</tr>');
	}
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


/**========================================================树菜单结束======================================================================*/
//初始化日期控件
function initDatetimepicker() {
	$("#clrq,#zxrq,#scrq,#changeCLRQ,#deptRevokeDate,#createDate").datetimepicker({
		minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        toDay: true,
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
        clearBtn: true
    });

	$(".changeBGRQ").datetimepicker({
		minView: "month",
	    language:"zh-CN",
	    format: "yyyy-mm-dd",
	    toDay: true,
	    pickDate: true,
	    pickTime: false,
	    bootcssVer:3,
	    autoclose: true,
	    clearBtn: true
	});
}

function initSelect(){
	$("#sjdw").html("");
	$("#changeH_hidden").html("");
	$("#changeQ_hidden").html("");
	$.ajax({
	    url:web_ctx + "/manage/organization/selectOgnList",
	    type: "get",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	    	selectData = result;
	    	$("#sjdw").append('<option value=""></option>');
	    	$("#changeH_hidden").append('<option value=""></option>');
	    	$("#changeQ_hidden").append('<option value=""></option>');
	        //请求成功时
	    	$.each(result,function(key,val){
	    	    $("#sjdw").append('<option value="'+(result[key].id)+'">'+(result[key].name)+'</option>');
	    	    $("#changeH_hidden").append('<option value="'+(result[key].id)+'">'+(result[key].name)+'</option>');
	    	    $("#changeQ_hidden").append('<option value="'+(result[key].id)+'">'+(result[key].name)+'</option>');
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

//function initChangeSelect_2(hasSelected){
//	$(".changeXM").html("");
//	$.ajax({
//		url:web_ctx + "/manage/organization/organizationChangeBGXMSelect",
//		type: "get",
//		cache:false,//false是不缓存，true为缓存
//		async:true,//true为异步，false为同步
//		beforeSend:function(){
//			//请求前
//		},
//		success:function(result){
//			$(".changeXM").append('<option value=""></option>');
//			//请求成功时
//			$.each(result,function(key,val){
//				$(".changeXM").append('<option value="'+(result[key].value)+'" '+(result[key].value == hasSelected?' selected':"")+'>'+(result[key].name)+'</option>');
//			});
//		},
//		complete:function(){
//			//请求结束时
//		},
//		error:function(){
//			//请求失败时
//		}
//	})
//}

(function ($) {
    $.fn.extend({
			initTable:function (o) {
            //接受配置参数并设定默认值
            var it = this,
                tbody = $(it).children("tbody"),
                tr = $(it).children("tbody").children("tr");
            //添加事件前先移除对象所有的事件
            it.undelegate();
           if(true){//canEdit
        	   //表格行的移动效果
               if(o.rowMove){
               	var timer = null;  
                   var targetEl,replaceEl,mouseDown=false,mousemove=false,mouseup=false;
                   tbody.delegate("tr", "mousedown", function(e){
	               	/* if(e.target.tagName.toLowerCase() === "td"){
	               		
	                  }*/
                   	if(e.which == 3){//右键
               	    	id = $(this).attr("data-tt-id");
               			id = id.replace("position_", "");
               			parentId = $(this).attr("data-tt-parent-id");
               			$(".selected").not(this).removeClass("selected");
               			$(this).toggleClass("selected");
               			initRightMenu();
               	    }else if(e.which == 1){//左键
   	                    //只对td对象触发
   	                    if(e.target.tagName.toLowerCase() === "td" || e.target.tagName.toLowerCase() === "p"){
   	                    	clearTimeout(timer);  
   	                    	timer = setTimeout(function() {
   	                    		//长按超过两秒则弹出
//   	                    		id = $(this).attr("data-tt-id");
//   	                			id = id.replace("position_", "");
//   	                    		initRightMenu();
   	                     	}, 2000); 
   	                        //按下鼠标时选取行
   	                    	targetEl = this,mouseDown = true;
   	                        parentId =  $(targetEl).prev('tr.dept').attr("data-tt-id");
   	                        $(this).css({"border":"2px solid #3c8dbc" });
   	                        $(this).css("cursor","move");
   	                        
   	                        //获取id
	   	                    id = $(this).attr("data-tt-id");
	 	           			id = id.replace("position_", "");
	 	                 	$(this).dblclick(function (){
	 	                 		initLeftMenu();
	 	                 		//lookTable(width)
	 	                 	});
   	                        return false;
   	                    }
               	    }
                   }).delegate("tr", "mousemove", function(e){
                   	mousemove=true;
                         //移动鼠标
                         if (mouseDown) {
                             //释放鼠标键时进行插入
//                       	  $(tr).css({"border":"3px solid #0F0" });
//                       	  replaceEl = $(targetEl).find('tr').next('tr');
//                             if (targetEl != this) {
//                                 if ($(this).index()>$(targetEl).index()){
//                                     $($(this)).after(targetEl);
//                                 } else {
//                                     $($(this)).before(targetEl);
//                                 }
//                             }
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
                       		 //
                			});	
                       }
                 });
           }
        }
    })
    
	
	//树形菜单
	$.fn.extend({
		selectCompant:function() {
			var width = $(window).width();
			lookTable(width);
			var vals = $(this).find('option:selected').val();
		/*	deptJson = getdept();*/
			var tableHtml = buildTable(deptJson);
			
			if(vals == ""){				
				$("#treetable tbody").html(tableHtml);
				$('#treetable').treetable('destroy');
				$("#treetable").treetable({ expandable: true });
				$("#treetable").treetable("expandAll");	
				
			}else if(vals == "0"){
				$("#treetable tbody").empty()
				var tableHtml = selectTree(deptJson);
				treeTable(tableHtml)
			}

			$("#CompanyType select").change(function(){
				var val = $(this).find('option:selected').val();
				
				switch (val){
				case "":
					$("#treetable tbody").empty()
					var tableHtml = buildTable(deptJson);
					$("#treetable tbody").html(tableHtml);
					$('#treetable').treetable('destroy');
					$("#treetable").treetable({ expandable: true });
					$("#treetable").treetable("expandAll");	
					mobileTree();
					break;
				case "0":
					$("#treetable tbody").empty()
					var tableHtml = selectTree(deptJson);
					treeTable(tableHtml)
					mobileTree();
					break;
				case "1":
					$("#treetable tbody").empty()
					var tableHtml = selectTree1(deptJson);
					treeTable(tableHtml)
					mobileTree();
					break;
				case "2":
					$("#treetable tbody").empty()
					var tableHtml = selectTree2(deptJson);
					treeTable(tableHtml)
					mobileTree();
					break;
				default:
					break;
				}
		
			})
			
		}
	})
	
	
	
	
})(jQuery)


//树
function treeTable(tableHtml){
	$("#treetable tbody").html(tableHtml);
	$('#treetable').treetable('destroy');
	$("#treetable").treetable({ expandable: true });
	$("#treetable").treetable("expandAll")
}

function selectTree(deptJson) {
	var html = [];
	var dept = [];
	var position = [];
	$(deptJson).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = selectTree(obj.children);
			if(obj.scrq == "" && obj.zxrq == ""){
				html.push(buildTr(obj));
			}			
			html.push(childHtml);
		}
	});
	return html.join("");
}
function selectTree1(deptJson) {
	var html = [];
	var dept = [];
	var position = [];
	$(deptJson).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = selectTree1(obj.children);
			if(obj.zxrq != ""){
				html.push(buildTr(obj));
			}			
			html.push(childHtml);
		}
	});
	return html.join("");
}
function selectTree2(deptJson) {
	var html = [];
	var dept = [];
	var position = [];
	$(deptJson).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push(buildTr(obj));
		} else {
			var childHtml = selectTree2(obj.children);
			if(obj.scrq != "" && obj.zxrq == "" ){
				html.push(buildTr(obj));
			}			
			html.push(childHtml);
		}
	});
	return html.join("");
}

//监听更改数据	
var monitor = function(){
	$("#saveChangeInfo").attr({"disabled":"disabled"});
	$("#form2").find(".node").each(function(index,ele){
		$(this).click(function(){
			index = index;
		})		
		
		$(this).find(".changeH").blur(function(){
			var selectIndex = $(this).parents().find(".node").eq(index).find(".changeXM").find('option:selected').val();
			var change = $(this).val();

			swichinput(selectIndex,change);

		})
			
	})

}

//监听selsct数据切换
function selectOptData(){
	$("#form2").find(".node").each(function(index,ele){
		if($("#form2").find(".node").length < 2){
			var selectIndex = $(this).parents().find(".node").eq(0).find(".changeXM").find('option:selected').val();
			if(selectIndex == ""){
				initDatetimepicker()
				$(this).find(".changeXM").attr("disabled",false);
				$(this).find(".changeH").attr("readonly",false)
			}
		}else{
			var selectIndex = $(this).parents().find(".node").eq(index).find(".changeXM").find('option:selected').val();
		}
		
	})
}


//校验
function swichinput(index,change){
	switch (index){
	case "0"://资本
		if(!is_number(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写正整数，且不可超过十个数字！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "1"://法人
		if(!is_name(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写中文,且不可超过五个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "2"://董事长
		if(!is_name(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写中文,且不可超过五个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "3"://总经理
		if(!is_name(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写中文,且不可超过五个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "4"://财务总监
		if(!is_name(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写中文,且不可超过五个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "5"://监事会主席/监事
		if(!is_name(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写中文,且不可超过五个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "6"://联系电话
		if(!is_mobile(change)){
			bootstrapAlert("提示", "电话格式有误，请重新填写！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "7"://公司地址
		if(!is_character(change)){
			bootstrapAlert("提示", "请填写正确的公司地址,不可超过四十个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "8"://公司账号
		if(!is_bank(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写正确的公司账号，却不超过十八个数字！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "9"://账户名称
		if(!is_LongName(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写正确的账户名称！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "10"://开户银行
		if(!is_LongName(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写正确的开户银行！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "11"://开户行地址
		if(!is_character(change)){
			bootstrapAlert("提示", "变更数据不合法,请填写正确的开户行地址！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "12":
		if(!is_character(change)){
			bootstrapAlert("提示", "请选择需要更改的上级单位", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "13"://上级持股比例
		if(!is_Proportion(change)){
			bootstrapAlert("提示", "填入数据有误，请填写包含100在内的整数！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	case "14"://经营范围
		if(!is_LongCharacter(change)){
			bootstrapAlert("提示", "填写内容不能超过一千个字符！", 300, null);
			$(".modal-dialog").css("margin","10px auto");
			return false;
		}else{
			$("#saveChangeInfo").removeAttr("disabled");	
		}
		break;
	default:
		break;
	}
}


//必须在上面函数之后进行初始化
$("#treetable").initTable({
    rowMove:true,
})


//初始化-右键操作
function initRightMenu() {
	if(zzgxedit=="true"){
	    if(divIdS == "generateKpi"){
            $.contextMenu({
                selector: '.nodeK',
                callback: function(key, options) {
                    switch(key) {
                        case 'addOgn': addOgn(id); break ;
                        case 'revoke': revoke(id,1); break ;
						case 'truedel': truedel(id,1); break ;
                    }
                },
                items: {
                    "addOgn":{ name: "新增", icon: "add" },
                    "revoke": { name: "撤销", icon: "quit" },
					"truedel": { name: "删除", icon: "delete" }
                }
            });
        }else if(divIdS == "deleteNode" || divIdS == "deleteNode2"){
	        var sign2 = null;
	        if(divIdS == "deleteNode") {
                sign2 = 1;
            }else if(divIdS == "deleteNode2") {
                sign2 = 2;
            }
            $.contextMenu({
                selector: '.nodeD',
                callback: function(key, options) {
                    switch(key) {
                        case 'recovery': recovery(id ,sign2);break;
                    }
                },
                items: {
                    "recovery":{ name: "恢复", icon: "edit" },
                }
            });
        }else {
            $.contextMenu({
                selector: '.nodeN',
                callback: function(key, options) {
                    switch(key) {
                        case 'editOgn': editOgn(id);break;
                        case 'addOgn': addOgn(id); break ;
                        case 'revoke': revoke(id,2); break ;
						case 'truedel': truedel(id,2); break ;
                    }
                },
                items: {
                    "editOgn":{ name: "编辑", icon: "edit" },
                    "addOgn":{ name: "新增", icon: "add" },
                    "revoke": { name: "撤销", icon: "quit" },
					"truedel": { name: "删除", icon: "delete" }
                }
            });
        }
	}else{
		$.contextMenu({
	    	selector: 'tr.dept',
	           callback: function(key, options) {
	            switch(key) {
	            	case 'queryInfo': queryInfo(id); break;
	            }
	        },
	        items: {
	        	"queryInfo":{ name: "查看", icon: "edit" }
	        }
	    });
	}
}

function initLeftMenu(divId){
		queryInfo(id,divId);
}

//新增
function addOgn(id){
	 initializePop();
	if($.type(id) == 'object'){
		that = id;		
		id = $(that).attr("data-v")	
		$(".liAlert").css("display", "none")
	}
	if(id == 1) {
		$("#sign").val("2")
		$("#deptModal2").modal("show");
	}else {
		if (divIdS == "generateKpi") {
			$("#sign").val("0")
            $("#parentId").val(id)
            $("#name").val("")
            $("#deptPerson").val("")
            $("#deptPhone").val("")
            $("#deptAddress").val("")
            $("#deptRevokeDate").val("")
            $("#createDate").val("")
            $("#content").val("")
            $("#deptId").val("")
            $("#name").attr("readonly",false)
            $("#deptPerson").attr("readonly",false)
            $("#deptPhone").attr("readonly",false)
            $("#deptAddress").attr("readonly",false)
            $("#content").attr("readonly",false)
            $("#saveDeptData").show();
            $("#editDeptData").hide();
            $("#deptModal").modal("show");
		} else {
			$("#sign").val("1")
			$("#deptModal2").modal("show");
		}
	}
}

////匹配国内电话号码(0511-4405222 或 021-87888822)
function istell(str){
//	var result=str.match(/\d{3}-\d{8}|\d{4}-\d{7}/);
	var result=str.match(/(\d{3}-\d{8}|\d{4}-\d{7})|(^1[3|5|8]\d{9}$)/);
	if(result==null) return false;
	return true;
}

//保存
function saveBaseInfo(){
/*=========================数据校验start============================*/
	//输入校验非空值
	if(isNull($("#form").find("input[name='gsmc']").val())){
		bootstrapAlert("提示", "公司名称不能为空！", 300, null);
		return;
	}
	//如果已经输入联系电话，则进行号码校验
	if(!isNull($("#lxdh").val())){
		if(!istell($("#lxdh").val())){
			bootstrapAlert("提示", "请输入正确格式的联系电话！", 300, null);
			return;
		}
	}
	//注销日期校验
	if(!isNull($("#zxrq").val())){
		if(confirm("注销日期非空，是否继续保存？")){
		}else{
			return false;
		}
	}
	//售出日期校验
	if(!isNull($("#scrq").val())){
		if(confirm("售出日期非空，是否继续保存？")){
		}else{
			return false;
		}
	}
	//上级持股比例校验
	if(!isNull($("#sjcgbl").val())){
		if(!isNaN($("#sjcgbl").val())){
			
		}else{
			bootstrapAlert("提示", "上级持股比例请填写数字！", 300, null);
			return false;
		}
	}
	
	//上级持股比例校验
	if(!isNull($("#zczb").val())){
		if(!isNaN($("#zczb").val())){
			if($("#zczb").val().length>10){
				bootstrapAlert("提示", "注册资本请填写数字,并不可超过十个数字！", 300, null);
				return false;
			}
		}
	}
	
	//上级持股比例校验
	if(!isNull($("#jyfw").val())){
		if($("#jyfw").val().length>1000){
			bootstrapAlert("提示", "经营范围数字不可超过一千！", 300, null);
			return false;
		}
	}
/*=========================数据校验end============================*/	
	var data=$('#form').serialize();
	var submitData=decodeURIComponent(data,true);
	$.ajax({
	    url:web_ctx + "/manage/organization/saveOrganization",
	    data:submitData,
	    type: "post",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前
	    },
	    success:function(result){
	        //请求成功时
	    	//bootstrapAlert("提示", "数据变更成功！", 300, null);
	    	if($(window).width() < 578) {
			    $(".modal-dialog").css("margin","20px auto");
			}
            $("#chart-container").remove();
            $("#div").after("<div id = 'chart-container'></div>");
            setTreeInfo(1);
            changeDate();
            $("#ognInfoModal").modal("hide");
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	})
}

//编辑
function editOgn(id){
	 initializePop();
	if($.type(id) == 'object'){
		that = id;		
		id = $(that).attr("data-v")
		$(".liAlert").css("display", "none")
	}
	$.ajax({
		url: web_ctx + "/manage/organization/queryOrganizationById",
		dataType: "json",
		type: 'post',
		data: {id: id},
		success: function (data) {

			var sjdwid = $("#id").val(data.ogn.id);
			$("#gsmc").val(data.ogn.name);
			$("#shxydm").val(data.ogn.shxydm);
			$("#clrq").val(data.ogn.clrq);
			$("#zczb").val(data.ogn.zczb);
			$("#frdb").val(data.ogn.frdb);
			$("#dszzxds").val(data.ogn.dszzxds);
			$("#zjl").val(data.ogn.zjl);
			$("#cwzj").val(data.ogn.cwzj);
			$("#jshzxjs").val(data.ogn.jshzxjs);
			$("#gswz").val(data.ogn.gswz);
			$("#lxdh").val(data.ogn.lxdh);
			if (width < 578) {

				inforStyle();
			}
			$("#gsdz").val(data.ogn.gsdz);

			$("#gszh").val(data.ogn.gszh);
			$("#zhmc").val(data.ogn.zhmc);
			$("#khyh").val(data.ogn.khyh);

			$("#khhdz").val(data.ogn.khhdz);

			if (data.ogn.parentId == "0") {
				$("#sjdw").val("");
			} else {
				$("#sjdw").val(data.ogn.parentId);
			}
			$("#sjcgbl").val(data.ogn.sjcgbl);
			$("#zxrq").val(data.ogn.zxrq);
			$("#scrq").val(data.ogn.scrq);
			$("#jyfw").val(data.ogn.jyfw);
			$("#save").show();
			$("#change").hide();
			$("#export").hide();
			$("#ognInfoModal").modal("show");
			$(".modal-body").find("input").each(function () {
				$(this).attr("readonly", false);
			})
			$(".modal-body").find("select").each(function () {
				$(this).attr("disabled", false);
			})
			$(".modal-body").find("textarea").attr("readonly", false);
		},
		error: function (data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
			if ($(window).width() < 578) {
				$(".modal-dialog").css("margin", "20px auto");
			}
		}
	});
}

//查看
function queryInfo(id,divId){
	 initializePop();
	if($.type(id) == 'object'){
		that = id;		
		id = $(that).attr("data-v")	
		$(".liAlert").css("display", "none")
	}
	if(divId == "generateKpi") {
        $.ajax({
            url: web_ctx + "/manage/organization/findDeptDataById",
            dataType: "json",
            type: 'post',
            data: {id: id},
            success: function (data) {
                $("#name").val(data.sysDept.name);
				$("#deptPerson").val(data.sysDept.deptPerson);
				$("#deptPhone").val(data.sysDept.deptPhone);
				$("#deptAddress").val(data.sysDept.deptAddress);
				if(data.sysDept.createDate != null) {
					$("#createDate").val(new Date(data.sysDept.createDate).pattern("yyyy-MM-dd"));
				}else {
					$("#createDate").val(data.sysDept.createDate);
				}
				if(data.sysDept.deptRevokeDate != null) {
					$("#deptRevokeDate").val(new Date(data.sysDept.deptRevokeDate).pattern("yyyy-MM-dd"));
				}else {
					$("#deptRevokeDate").val(data.sysDept.deptRevokeDate);
				}
				if(data.responsibility == null) {
					$("#content").val("");
				}else {
					$("#content").val(data.responsibility.content);
				}

				$("#deptId").val(data.sysDept.id);
                $("#saveDeptData").hide();
                $("#editDeptData").show();
            }
        })
        $("#deptModal").modal("show");
	}else if(divId == "deleteNode"){
        $.ajax({
            url: web_ctx + "/manage/organization/findDeptDataById",
            dataType: "json",
            type: 'post',
            data: {id: id},
            success: function (data) {
                $("#name").val(data.sysDept.name);
                $("#deptPerson").val(data.sysDept.deptPerson);
                $("#deptPhone").val(data.sysDept.deptPhone);
                $("#deptAddress").val(data.sysDept.deptAddress);
				if(data.sysDept.createDate != null) {
					$("#createDate").val(new Date(data.sysDept.createDate).pattern("yyyy-MM-dd"));
				}else {
					$("#createDate").val(data.sysDept.createDate);
				}
                if(data.sysDept.deptRevokeDate != null) {
                    $("#deptRevokeDate").val(new Date(data.sysDept.deptRevokeDate).pattern("yyyy-MM-dd"));
                }else {
                    $("#deptRevokeDate").val(data.sysDept.deptRevokeDate);
                }
                if(data.responsibility == null) {
                    $("#content").val("");
                }else {
                    $("#content").val(data.responsibility.content);
                }
            }
        })
        $("#saveDeptData").hide();
        $("#editDeptData").hide();
        $("#deptModal").modal("show");
	}
	else {
        if (zzgxedit == "true") {
            //清空原来变更的数据
            $(".changeBGRQ").val("");
            $(".changeXM").val("");
            $(".changeQ").val("");
            $(".changeH").val("");
            $.ajax({
                url: web_ctx + "/manage/organization/queryOrganizationById",
                dataType: "json",
                type: 'post',
                data: {id: id},
                success: function (data) {
                    $("#changeId").val(data.ogn.id);
                    $("#gsmc").val(data.ogn.name);
                    $("#shxydm").val(data.ogn.shxydm);
                    $("#clrq").val(data.ogn.clrq);
                    $("#zczb").val(data.ogn.zczb);
                    $("#frdb").val(data.ogn.frdb);
                    $("#dszzxds").val(data.ogn.dszzxds);
                    $("#zjl").val(data.ogn.zjl);
                    $("#cwzj").val(data.ogn.cwzj);
                    $("#jshzxjs").val(data.ogn.jshzxjs);
                    $("#gswz").val(data.ogn.gswz);
                    $("#lxdh").val(data.ogn.lxdh);
                    $("#gsdz").val(data.ogn.gsdz);
                    $(".gsdz").text(data.ogn.gsdz);
                    $("#gsdz").attr("title", data.ogn.gsdz);
                    $("#gszh").val(data.ogn.gszh);
                    $("#zhmc").val(data.ogn.zhmc);
                    $("#khyh").val(data.ogn.khyh);
                    $("#khhdz").val(data.ogn.khhdz);
                    $(".khhdz").text(data.ogn.khhdz);
                    $("#khhdz").attr("title", data.ogn.khhdz);
                    $("#sjdw").val(data.ogn.parentId);
                    $("#sjcgbl").val(data.ogn.sjcgbl);
                    $("#zxrq").val(data.ogn.zxrq);
                    $("#scrq").val(data.ogn.scrq);
                    $("#jyfw").val(data.ogn.jyfw);
                    $("#save").hide();
                    $("#change").show();
                    $("#export").show();
                    $("#ognInfoModal").modal("show");

                    $(".modal-body").find("input").each(function () {
                        $(this).attr("readonly", true);
                    })
                    $(".modal-body").find("select").each(function () {
                        $(this).attr("disabled", true);
                    })
                    $(".modal-body").find("textarea").attr("readonly", true);

                },
                error: function (data) {
                    bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                    if ($(window).width() < 578) {
                        $(".modal-dialog").css("margin", "20px auto");
                    }
                }
            });
        } else {//普通用户
            $.ajax({
                url: web_ctx + "/manage/organization/queryOrganizationById",
                dataType: "json",
                type: 'post',
                data: {id: id},
                success: function (data) {
                    $("#changeId2").val(data.ogn.id);
                    $("#gsmc2").val(data.ogn.name);
                    $("#shxydm2").val(data.ogn.shxydm);
                    $("#lxdh2").val(data.ogn.lxdh);
                    $("#gsdz2").val(data.ogn.gsdz);
                    $("#gsdz2").attr("title", data.ogn.gsdz);
                    $("#gszh2").val(data.ogn.gszh);
                    $("#zhmc2").val(data.ogn.zhmc);
                    $("#khyh2").val(data.ogn.khyh);
                    $("#khyh2").attr("title", data.ogn.khyh);
                    $("#khhdz2").val(data.ogn.khhdz);
                    $("#jyfw2").val(data.ogn.jyfw);
                    $("#export2").show();
                    $("#ognInfoModal2").modal("show");
                },
                error: function (data) {
                    bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                }
            });
        }
    }
}


//撤销
function revoke(id,sign) {
	if($.type(id) == 'object'){
		that = id;		
		id = $(that).attr("data-v")	
		$(".liAlert").css("display", "none")
	}
	if($(window).width() < 578) {
	    $(".modal-dialog").css("margin","20px auto");
	}
	bootstrapConfirm("提示", "确定撤销吗？", 300, function() {
        $.ajax({
            url:web_ctx + "/manage/organization/findByparentIdAndDelete",
            data:{"id":id,"sign":sign},
            type: "get",
            dataType:'json',
            success:function(data){
                if (data.code == 1) {
                    bootstrapAlert("提示", "请先撤销下级部门或岗位、用户！", 400, null);
                }else {
                    $.ajax({
                        url:web_ctx + "/manage/organization/revokeOrganizationById",
                        data:{"id":id,"sign":sign},
                        type: "get",
                        dataType:'json',
                        success:function(info){
                            $("#chart-container").remove();
                            $("#div").after("<div id = 'chart-container'></div>");
                            setTreeInfo(1);
                            changeDate();
                            showSwitch();
                        },
                        error:function(info){
                            if(info==null&&info==""){
								bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                                refreshPage();
                            }
                        }
                    });
                }
            }
        })
	}, null);
}

//恢复
function recovery(id,sign) {
    bootstrapConfirm("提示", "确定恢复吗？", 300, function() {
        $.ajax({
            url:web_ctx + "/manage/organization/recoveryOrganizationById",
            data:{"id":id,"sign":sign},
            type: "get",
            dataType:'json',
            success:function(info){
                $("#chart-container").remove();
                $("#div").after("<div id = 'chart-container'></div>");
                setTreeInfo(1);
                changeDate();
                showSwitch();
            },
            error:function(info){
                if(info==null&&info==""){
					bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
                    refreshPage();
                }
            }
        });
    }, null);
}

//删除
function truedel(id,sign) {
	if($.type(id) == 'object'){
		that = id;
		id = $(that).attr("data-v")
		$(".liAlert").css("display", "none")
	}
	bootstrapConfirm("提示", "确定删除吗？", 300, function() {
		$.ajax({
			url:web_ctx + "/manage/organization/findByparentIdAndDelete",
			data:{"id":id,"sign":sign},
			type: "get",
			dataType:'json',
			success:function(data){
				if (data.code == 1) {
					bootstrapAlert("提示", "请先删除下级部门或岗位、用户！", 400, null);
				}else {
					$.ajax({
						url:web_ctx + "/manage/organization/delOrganizationById",
						data:{"id":id,"sign":sign},
						type: "get",
						dataType:'json',
						success:function(info){
							$("#chart-container").remove();
							$("#div").after("<div id = 'chart-container'></div>");
							setTreeInfo(1);
							changeDate();
							showSwitch();
						},
						error:function(info){
							if(info==null&&info==""){
								bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
								refreshPage();
							}
						}
					});
				}
			}
		})
	}, null);
}

var change_zczb="";
var change_frdb="";
var change_dszzxds="";
var change_zjl="";
var change_cwzj="";
var change_jshzxjs="";
var change_lxdh="";
var change_gsdz="";
var change_gszh="";
var change_zhmc="";
var change_khyh="";
var change_khhdz="";
var change_sjdw="";
var change_sjcgbl="";
var change_jyfw="";
var change_data="";
var change_code="";
var change_name="";
//变更信息
function change(){
	$(".InfoModal").css("z-index",-100);
	
	var id=$("#changeId").val();

	$.ajax({
		url: web_ctx + "/manage/organization/queryOrganizationById",
		dataType: "json",
		type: 'post',
		data: {id:id},
		success: function(data1) {
			//$(".node").remove();  orgChart插件写的组织结构节点不能删除
			if(data1.length!=0){
				//清空
				change_zczb="";
				change_frdb="";
				change_dszzxds="";
				change_zjl="";
				change_cwzj="";
				change_jshzxjs="";
				change_lxdh="";
				change_gsdz="";
				change_gszh="";
				change_zhmc="";
				change_khyh="";
				change_khhdz="";
				change_sjdw="";
				change_sjcgbl="";
				change_jyfw="";
                change_code="";
                change_name="";
				$("#changeGSMC").val(data1.ogn.name);
				$("#changeSHXYDM").val(data1.ogn.shxydm);
				$("#changeCLRQ").val(data1.ogn.clrq);
				
				//=====================================
				change_zczb=data1.ogn.zczb;
				change_frdb=data1.ogn.frdb;
				change_dszzxds=data1.ogn.dszzxds;
				change_zjl=data1.ogn.zjl;
				change_cwzj=data1.ogn.cwzj;
				change_jshzxjs=data1.ogn.jshzxjs;
				change_lxdh=data1.ogn.lxdh;
				change_gsdz=data1.ogn.gsdz;
				change_gszh=data1.ogn.gszh;
				change_zhmc=data1.ogn.zhmc;
				change_khyh=data1.ogn.khyh;
				change_khhdz=data1.ogn.khhdz;
				change_sjdw=data1.ogn.parentId;
				change_sjcgbl=data1.ogn.sjcgbl;
				change_jyfw=data1.ogn.jyfw;
                change_code=data1.ogn.shxydm;
                change_name=data1.ogn.name;
				//=====================================
				
				$.ajax({
					url: web_ctx + "/manage/organization/queryOrganizationChangeInfoListByOgnId",
					dataType: "json",
					type: 'post',
					data: {ognid:data1.ogn.ognid},
					success: function(data) {
						change_data = data;
						console.log(change_data)
						var dataTR="";
						if(data.length>0){
							$.each(data,function(key,val){
								if(data[key].bgxm=="12"){//如果为：上级单位  则-- 变更前、变更后为下拉选项
									$("#changeQ_hidden").find("option[value='"+data[key].bgq+"']").attr("selected",true);
									$("#changeH_hidden").find("option[value='"+data[key].bgh+"']").attr("selected",true);
									dataTR='<tr class="node" name="node" style="height: 30px;">'
												+'<td style="display: none;">'
													+'<input class="ocrId" name="uuid" value="'+data[key].id+'" type="hidden">'
												+'</td>'
												+'<td>'
													+'<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" name="changeBGRQ" value="'+(data[key].bgrq==null?"":data[key].bgrq)+'" readonly />'
												+'</td>'
												+'<td>'
													+'<select style="width: 98%;" class="changeXM" name="changeXM" onchange="getSelectChange(this)" disabled="disabled" >'
														+'<option value="16" '+(data[key].bgxm=="16"?'selected':"")+'>公司名称</option>'
														+'<option value="15" '+(data[key].bgxm=="15"?'selected':"")+'>社会信用代码</option>'
														+'<option value="0" '+(data[key].bgxm=="0"?'selected':"")+'>注册资本</option>'
														+'<option value="1" '+(data[key].bgxm=="1"?"selected":'')+'>法人代表</option>'
														+'<option value="2" '+(data[key].bgxm=="2"?"selected":'')+'>董事长/执行董事</option>'
														+'<option value="3" '+(data[key].bgxm=="3"?"selected":'')+'>总经理</option>'
														+'<option value="4" '+(data[key].bgxm=="4"?"selected":'')+'>财务总监</option>'
														+'<option value="5" '+(data[key].bgxm=="5"?"selected":'')+'>监事会主席/监事</option>'
														+'<option value="6" '+(data[key].bgxm=="6"?"selected":'')+'>联系电话</option>'
														+'<option value="7" '+(data[key].bgxm=="7"?"selected":'')+'>公司地址</option>'
														+'<option value="8" '+(data[key].bgxm=="8"?"selected":'')+'>公司账号</option>'
														+'<option value="9" '+(data[key].bgxm=="9"?"selected":'')+'>账户名称</option>'
														+'<option value="10" '+(data[key].bgxm=="10"?"selected":'')+'>开户银行</option>'
														+'<option value="11" '+(data[key].bgxm=="11"?"selected":'')+'>开户行地址</option>'
														+'<option value="12" '+(data[key].bgxm=="12"?"selected":'')+'>上级单位</option>'
														+'<option value="13" '+(data[key].bgxm=="13"?"selected":'')+'>上级持股比例</option>'
														+'<option value="14" '+(data[key].bgxm=="14"?"selected":'')+'>经营范围</option>'
													+'</select>'
												 +'</td>'
												 +'<td>'
													+'<select style="width: 98%;" class="changeQ" name="changeQ" disabled="disabled">'
													+$("#changeQ_hidden").html()
													+'</select>'
												+'</td>'
												+'<td>'
													+'<select style="width: 98%;" class="changeH" name="changeH" disabled="disabled">'
													+$("#changeH_hidden").html()
													+'</select>'
												+'</td>'
										  +'</tr>';
									$("#tbodyInfoTr").append(dataTR);	
								}else{

									//遍历的变更信息
									dataTR='<tr class="node" name="node" id="node" style="height: 30px;">'
												+'<td style="display: none;">'
													+'<input class="ocrId" name="uuid" value="'+data[key].id+'" type="hidden">'
												+'</td>'
												+'<td>'
													+'<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" name="changeBGRQ" value="'+(data[key].bgrq==null?"":data[key].bgrq)+'" disabled/>'
												+'</td>'
												+'<td>'
													+'<select style="width: 98%;" class="changeXM" name="changeXM" onchange="getSelectChange(this)" disabled>'
														+'<option value="16" '+(data[key].bgxm=="16"?'selected':"")+'>公司名称</option>'
														+'<option value="15" '+(data[key].bgxm=="15"?'selected':"")+'>社会信用代码</option>'
														+'<option value="0" '+(data[key].bgxm=="0"?'selected':"")+'>注册资本</option>'
														+'<option value="1" '+(data[key].bgxm=="1"?"selected":'')+'>法人代表</option>'
														+'<option value="2" '+(data[key].bgxm=="2"?"selected":'')+'>董事长/执行董事</option>'
														+'<option value="3" '+(data[key].bgxm=="3"?"selected":'')+'>总经理</option>'
														+'<option value="4" '+(data[key].bgxm=="4"?"selected":'')+'>财务总监</option>'
														+'<option value="5" '+(data[key].bgxm=="5"?"selected":'')+'>监事会主席/监事</option>'
														+'<option value="6" '+(data[key].bgxm=="6"?"selected":'')+'>联系电话</option>'
														+'<option value="7" '+(data[key].bgxm=="7"?"selected":'')+'>公司地址</option>'
														+'<option value="8" '+(data[key].bgxm=="8"?"selected":'')+'>公司账号</option>'
														+'<option value="9" '+(data[key].bgxm=="9"?"selected":'')+'>账户名称</option>'
														+'<option value="10" '+(data[key].bgxm=="10"?"selected":'')+'>开户银行</option>'
														+'<option value="11" '+(data[key].bgxm=="11"?"selected":'')+'>开户行地址</option>'
														+'<option value="12" '+(data[key].bgxm=="12"?"selected":'')+'>上级单位</option>'
														+'<option value="13" '+(data[key].bgxm=="13"?"selected":'')+'>上级持股比例</option>'
														+'<option value="14" '+(data[key].bgxm=="14"?"selected":'')+'>经营范围</option>'
													+'</select>'
												+'</td>'
												+'<td>'
													+'<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ" value="'+(data[key].bgq==null?"":data[key].bgq)+'" type="text" readonly>'
												+'</td>'
												+'<td>'
													+'<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH" value="'+(data[key].bgh==null?"":data[key].bgh)+'" type="text" >'
												+'</td>'
										 +'</tr>';
									$("#tbodyInfoTr").append(dataTR);
								}
					    	});
								//变更记录不为空时进入页面初始化新的变更信息
								dataTR='<tr class="node" name="node" id="node" style="height: 30px;">'
											+'<td style="display: none;">'
												+'<input class="ocrId" name="uuid" value="" type="hidden">'
											+'</td>'
											+'<td>'
												+'<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" id="changeBGRQ" name="changeBGRQ" value=""/>'
											+'</td>'
											+'<td>'
												+'<select style="width: 98%;" class="changeXM" name="changeXM" id="changeXM" onchange="getSelectChange(this)">'
													+'<option value="16" '+(data[data.length -1].bgxm=="16"?'selected':"")+'>公司名称</option>'
													+'<option value="15" '+(data[data.length -1].bgxm=="15"?'selected':"")+'>社会信用代码</option>'
													+'<option value="0" '+(data[data.length -1].bgxm=="0"?'selected':"")+'>注册资本</option>'
													+'<option value="1" '+(data[data.length -1].bgxm=="1"?'selected':"")+'>法人代表</option>'
													+'<option value="2" '+(data[data.length -1].bgxm=="2"?'selected':"")+'>董事长/执行董事</option>'
													+'<option value="3" '+(data[data.length -1].bgxm=="3"?'selected':"")+'>总经理</option>'
													+'<option value="4" '+(data[data.length -1].bgxm=="4"?'selected':"")+'>财务总监</option>'
													+'<option value="5" '+(data[data.length -1].bgxm=="5"?'selected':"")+'>监事会主席/监事</option>'
													+'<option value="6" '+(data[data.length -1].bgxm=="6"?'selected':"")+'>联系电话</option>'
													+'<option value="7" '+(data[data.length -1].bgxm=="7"?'selected':"")+'>公司地址</option>'
													+'<option value="8" '+(data[data.length -1].bgxm=="8"?'selected':"")+'>公司账号</option>'
													+'<option value="9" '+(data[data.length -1].bgxm=="9"?'selected':"")+'>账户名称</option>'
													+'<option value="10" '+(data[data.length -1].bgxm=="10"?'selected':"")+'>开户银行</option>'
													+'<option value="11" '+(data[data.length -1].bgxm=="11"?'selected':"")+'>开户行地址</option>'
													+'<option value="12" '+(data[data.length -1].bgxm=="12"?'selected':"")+'>上级单位</option>'
													+'<option value="13" '+(data[data.length -1].bgxm=="13"?'selected':"")+' >上级持股比例</option>'
													+'<option value="14" '+(data[data.length -1].bgxm=="14"?'selected':"")+'>经营范围</option>'
												+'</select>'
											+'</td>'
											+'<td>'
												+'<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ" id="changeQ" value="" type="text" readonly>'
											+'</td>'
											+'<td>'
												+'<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH" value="" type="text" >'
											+'</td>'
									   +'</tr>';
								$("#tbodyInfoTr").append(dataTR);
								$("#changeBGRQ").val(new Date().pattern("yyyy-MM-dd"));
								$("#changeQ").val(data[data.length -1].bgh);
						}else{
							//变更记录为空时进入页面初始化新的变更信息
							dataTR='<tr class="node" name="node" id="node" style="height: 30px;">'
										+'<td style="display: none;">'
											+'<input class="ocrId" name="uuid" value="" type="hidden">'
										+'</td>'
										+'<td>'
											+'<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" name="changeBGRQ" id="changeBGRQ" value="" >'
										+'</td>'
										+'<td>'
											+'<select style="width: 98%;" class="changeXM" name="changeXM" onchange="getSelectChange(this)">'
												+'<option value="16">公司名称</option>'
												+'<option value="15">社会信用代码</option>'
												+'<option value="0" >注册资本</option>'
												+'<option value="1" >法人代表</option>'
												+'<option value="2" >董事长/执行董事</option>'
												+'<option value="3" >总经理</option>'
												+'<option value="4" >财务总监</option>'
												+'<option value="5" >监事会主席/监事</option>'
												+'<option value="6" >联系电话</option>'
												+'<option value="7" >公司地址</option>'
												+'<option value="8" >公司账号</option>'
												+'<option value="9" >账户名称</option>'
												+'<option value="10">开户银行</option>'
												+'<option value="11" >开户行地址</option>'
												+'<option value="12" >上级单位</option>'
												+'<option value="13" >上级持股比例</option>'
												+'<option value="14" >经营范围</option>'
											+'</select>'
										+'</td>'
										+'<td>'
											+'<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ" id="changeQ" value="" type="text" readonly>'
										+'</td>'
										+'<td>'
											+'<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH" value="" type="text">'
										+'</td>'
								   +'</tr>';
							$("#tbodyInfoTr").append(dataTR);
							$("#changeBGRQ").val(new Date().pattern("yyyy-MM-dd"));
							$("#changeQ").val(data1.ogn.name);
						}
						initDatetimepicker();//初始化日期
						selectOptData();
						modileChange()
					},
					error: function(data) {
						bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
						if($(window).width() < 578) {
						    $(".modal-dialog").css("margin","20px auto");
						}
					}
				})
					//initDatetimepicker();//初始化日期
			}
            initMenu();//初始化右键菜单
			$("#changeGSMC").attr("disabled","true");
			$("#changeSHXYDM").attr("disabled","true");
			$("#changeCLRQ").attr("disabled","true");
			$("#ognChangeInfoModal").modal("show");
			$("#ognInfoModal").modal("hide");

		},
		error: function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	});
}

//导出
function exportInfo() {
	var id=$("#changeId").val();
	var param = {
		"id" : id
	}
	window.open(web_ctx + "/manage/organization/toPDF?" + urlEncode(param));
}
function exportInfo1() {
	var id=$("#changeId").val();
	window.open(web_ctx+'/manage/organization/toText?id='+id, '_blank');
}


//普通用户导出
function exportInfo2() {
	var id=$("#changeId2").val();
	var param = {
		"id" : id
	}
	window.open(web_ctx + "/manage/organization/toPDF2?" + urlEncode(param));
}

//初始化变更记录右键菜单
function initMenu(){
	$.contextMenu({
	    selector: "#node",
	    items: {
	        add: {name: "新增", icon: "add",callback: function(key, opt){
		        	dataTR='<tr class="node" name="node" id="node" style="height: 30px;">'
			    	    +'<td style="display: none;">'
			    	    	+'<input class="ocrId" name="uuid" value="" type="hidden">'
			    	    +'</td>'
			    	    +'<td>'
	   	                	+'<input style="width:100%;border: none;text-align:center;" class="changeBGRQ" id="changeBGRQ" name="changeBGRQ" value="" readonly />'
	   	                +'</td>'
		   	            +'<td>'
	   	   					+'<select style="width: 98%;" class="changeXM" name="changeXM" onchange="getSelectChange(this)">'
							+'<option value="">请选择</option>'
                            +'<option value="16">公司名称</option>'
                            +'<option value="15">社会信用代码</option>'
	   	   					+'<option value="0">注册资本</option>'
	   	   					+'<option value="1">法人代表</option>'
	   	   					+'<option value="2">董事长/执行董事</option>'
	   	   					+'<option value="3">总经理</option>'
	   	   					+'<option value="4">财务总监</option>'
	   	   					+'<option value="5">监事会主席/监事</option>'
	   	   					+'<option value="6">联系电话</option>'
	   	   					+'<option value="7">公司地址</option>'
	   	   					+'<option value="8">公司账号</option>'
	   	   					+'<option value="9">账户名称</option>'
	   	   					+'<option value="10">开户银行</option>'
	   	   					+'<option value="11">开户行地址</option>'
	   	   					+'<option value="12">上级单位</option>'
	   	   					+'<option value="13">上级持股比例</option>'
	   	   					+'<option value="14">经营范围</option>'
	   	   					+'</select>'
	   	   				+'</td>'
	   	   				+'<td>'
	   	   					+'<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ" id="changeQ" value="" type="text" readonly>'
	   	   				+'</td>'
	   	   				+'<td>'
	   	   					+'<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH" value="" type="text">'
	   	   				+'</td>'
	   	   			+'</tr>';
			    	    $("#tbodyInfoTr").append(dataTR);
				    initDatetimepicker();//初始化日期
                    $("#changeBGRQ").val(new Date().pattern("yyyy-MM-dd"));
	          	}
	        },
	        verygood: {name: "删除",icon: "delete", callback: function(key, opt){
	        	var activeClass = $('.context-menu-active');
	        	var uuid2 = $('#table2').find(activeClass).children().eq(0).children("input[name='uuid']").val();
	        	if(uuid2!=""){
                    bootstrapConfirm("提示", "确定删除吗？", 300, function() {
		        		$.ajax({
							url:web_ctx + "/manage/organization/delChangeInfoById",
							dataType: "json",
							data:{"uuid":uuid2},
							cache:false,//false是不缓存，true为缓存
						    async:true,//true为异步，false为同步
							success: function(data) {
                                refreshPage();
							},
							error: function(data) {
								alert("删除失败，请联系管理员！");
							}
						});
		        	})
	        	}else{
	        		$('#table2').find(activeClass).remove();
	        		var firstTr = $("#table2").find("tr[name='node']:eq(0)").find("input").each(function(index, input) {
	        			$(this).trigger("keyup");
	        		});
	        	}
	        }
	      }
	   }
	});
}

//下拉选中
function getSelectChange(obj){
	//下拉菜单选中的值，后赋值到变更前输入框
	if($(obj).val()==""){
		$(obj).parent().siblings().children('.changeQ').val("");
		$(obj).parent().siblings().children('.changeH').val("");
	}
	if($(obj).val()=="0"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_zczb);	
	}
	if($(obj).val()=="1"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_frdb);	
	}
	if($(obj).val()=="2"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_dszzxds);		
	}
	if($(obj).val()=="3"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_zjl);		
	}
	if($(obj).val()=="4"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_cwzj);		
	}
	if($(obj).val()=="5"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_jshzxjs);		
	}
	if($(obj).val()=="6"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_lxdh);	
	}
	if($(obj).val()=="7"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_gsdz);	
	}
	if($(obj).val()=="8"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_gszh);		
	}
	if($(obj).val()=="9"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_zhmc);		
	}
	if($(obj).val()=="10"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_khyh);		
	}
	if($(obj).val()=="11"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_khhdz);		
	}
	if($(obj).val()=="12"){
		//下拉变更前
		$(obj).parent().siblings().children('.changeQ').after("<select id='changeQ' name='changeQ' style='width:98%'></select>")
		$(obj).parent().siblings().children('.changeQ').val(change_sjdw);
		$(selectData).each(function(index,ele){
			var html = "<option value="+selectData[index].id+">"+selectData[index].name+"</option> "
			$(obj).parent().siblings().children('#changeQ').find("option[value="+change_sjdw+"]").attr("selected",true);
			$(obj).parent().siblings().children('#changeQ').append(html)
		})
		$(obj).parent().siblings().children('.changeQ').remove();
		$(obj).parent().siblings().children('#changeQ').attr("class","changeQ")
		//下拉变更后
		$(obj).parent().siblings().children('.changeH').after("<select id='changeH' name='changeH' style='width:98%'></select>")
		$(obj).parent().siblings().children('#changeH').append("<option value=''></option>");
		$(selectData).each(function(index,ele){
			var html = "<option value="+selectData[index].id+">"+selectData[index].name+"</option> ";
			$(obj).parent().siblings().children('#changeH').append(html)
		})
		$(obj).parent().siblings().children('.changeH').remove();
		$(obj).parent().siblings().children('#changeH').attr("class","changeH")
		
		$("#saveChangeInfo").removeAttr("disabled");
	}
	if($(obj).val()=="13"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_sjcgbl);	
	}
	if($(obj).val()=="14"){
		changeInp(obj)
		$(obj).parent().siblings().children('.changeQ').val(change_jyfw);		
	}
    if($(obj).val()=="15"){
        changeInp(obj)
        $(obj).parent().siblings().children('.changeQ').val(change_code);
    }
    if($(obj).val()=="16"){
        changeInp(obj)
        $(obj).parent().siblings().children('.changeQ').val(change_name);
    }
	/*monitor();*/
}

function changeInp(obj){
	if($(obj).parent().siblings().children('.changeQ')[0].tagName == "SELECT"){
		$(obj).parent().siblings().children('.changeQ').after('<input style="width:100%;border: none;text-align:center;" class="changeQ" name="changeQ" id="changeIn" value="" type="text" readonly> ')
		$(obj).parent().siblings().children('.changeH').after('<input style="width:100%;border: none;text-align:center;" class="changeH" name="changeH" value="" type="text">')
		$(obj).parent().siblings().children('select').remove();
	}

}

//=======================================================================================================================================
function getFormJson() {
	var json = $("#form2").serializeJson();
	var formData = $.extend(true, {}, json);
	formData["changeInfoList"] = [];
	$("#tbodyInfoTr").find("tr[name='node']").each(function(index, tr) {
		var uuid = $(this).find("input[name='uuid']").val();
		var changeBGRQ = $(this).find("input[name='changeBGRQ']").val();
		var changeXM = $(this).find("select[name='changeXM']").val();
		var changeQ = $(this).find("input[name='changeQ']").val()==undefined?$(this).find("select[name='changeQ']").val():$(this).find("input[name='changeQ']").val();
		var changeH = $(this).find("input[name='changeH']").val()==undefined?$(this).find("select[name='changeH']").val():$(this).find("input[name='changeH']").val();
		
		var data = {};
		data["uuid"] = uuid;
		data["changeBGRQ"] = changeBGRQ;
		data["changeXM"] = changeXM;
		data["changeQ"] = changeQ;
		data["changeH"] = changeH;
		
		formData["changeInfoList"].push(data);
	});

	return formData;
}

//

//保存变更信息
function saveChangeInfo(){
	var formData = getFormJson();
    var checkMsg= checkForm(formData);
    if(! isNull(checkMsg)) {
        bootstrapAlert2("提示", checkMsg.join("<br/>"), 400, null);
        return ;
    }
	
	$.ajax({
	    url:web_ctx + "/manage/organization/saveChangeInfo",
	    data:JSON.stringify(formData),
	    type: 'post',
	    contentType: 'application/json;charset=UTF-8',
	    dataType: "json",
	    cache:false,//false是不缓存，true为缓存
	    async:true,//true为异步，false为同步
	    beforeSend:function(){
	        //请求前	    	
	    },
	    success:function(result){
	    	refreshPage();
//	    	//关闭模态框
//	    	$("#ognInfoModal").modal('hide');
//	        //重新查询
//	    	queryInfo($("#changeId").val());
	    },
	    complete:function(){
	        //请求结束时
	    },
	    error:function(){
	        //请求失败时
	    }
	});
}

//验证变更后的值不为空
function checkForm(formData) {
    var text = [];
    $("tr[id='node2']").each(function(business, tr) {
        var value = $(tr).find("input[name='changeH']").val();
        if (value == "" || value == null) {
            text.push("变更后的值不能为空！<br/>");
            return false
        }
    });

    return text;
}


function bootstrapAlert2(title,message,width,callBack) {
    //获取当前时间当作唯一标识符
    var startTime = new Date().getTime();
    var html = [];
    html.push(' <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="bootstrapAlert'+startTime+'" >');
    html.push('<div class="modal-dialog"><div class="modal-content" id="footer_id1'+startTime+'"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="display:none;">&times;</button>');
    html.push('<h4 class="modal-title">'+title+'</h4>');
    html.push('</div><div class="modal-body">'+message+'</div>');
    html.push('<div class="modal-footer"><button id="ok" type="button" class="btn btn-default" data-dismiss="modal" onclick="onModel()">确定</button>');
    html.push('</div></div></div></div>');

    $("body").append(html.join(''));

    //设置关闭按钮触发事件
    $("#bootstrapAlert"+startTime).find('button:eq(1)').click(function(e) {
        $("#bootstrapAlert"+startTime).modal('hide');
        //执行回调函数
        if((typeof callBack)=='function'){
            callBack();
        }
    });

    //设置宽度
    if(width!=undefined && width!=null){
        $("#bootstrapAlert"+startTime).find('.modal-dialog').width(width);
    }
    //设置文字自动换行
    $("#bootstrapAlert"+startTime).find('.modal-body').css({'word-wrap':'break-word','word-break':'break-all'});
    $("#bootstrapAlert"+startTime).modal({backdrop: 'static', keyboard: false}	);
    var div = $("#footer_id1"+startTime);
    if(window.parent.document.childNodes[1] != undefined && window.parent.document.childNodes[1] != 'undefined'){
        var scrollTop= window.parent.document.childNodes[1].scrollTop;
        div[0].style.top=scrollTop + "px";
    }else{
        div[0].style.top=+ "200px";
    }
    //显示弹框
    $("#bootstrapAlert"+startTime).modal('show');
}

//=============================================================================================================================
//正则校验start=============================================================================================================================
//验证中文
function is_name(name){
	if(name == ""){
	return false;
}else{
	if(! /^[\u4E00-\u9FA5]{2,5}$/.test(name)){
			return false;
		}
	}
	return true;
}
//验证账户名称
function is_LongName(name){
	if(name == ""){
	return false;
}else{
	if(! /^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]|[a-zA-Z0-9_]){5,15}$/.test(name)){
			return false;
		}
	}
	return true;
}

//验证国内电话
function is_mobile(mobile) {  
	if( mobile == "") {  
	return false;  
 } else {  
   if( ! /(\d{3}-\d{8}|\d{4}-\d{7})|(^1[3|5|8]\d{9}$)/.test(mobile) ) {  
        return false;  
      }  
      return true;  
    }  
} 

//验证正整数
function is_number(mobile) {  
	if( mobile == "") {  
	return false;  
} else {  
  if( ! /^\+?[1-9][0-9]*$/.test(mobile) ) {  
       return false;  
     }  
     return true;  
   }  
}

//验证持股比例
function is_Proportion(mobile) {  
	if( mobile == "") {  
	return false;  
} else {  
  if( ! /^(0)$|^100$|^[1-9][0-9]?$/.test(mobile) ) {  
       return false;  
     }  
     return true;  
   }  
}

//验证中文、数字、英文
function is_character(mobile) {  
    if( mobile == "") {  
	return false;  
} else {  
  if( ! /^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]|[a-zA-Z0-9_]){5,40}$/.test(mobile) ) {  
       return false;  
     }  
     return true;  
   }  
}
//限制字符
function is_LongCharacter(mobile) {  
    if( mobile == "") {  
	return false;  
} else {  
  if( ! /^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]|[a-zA-Z0-9_]){5,1000}$/.test(mobile) ) {  
       return false;  
     }  
     return true;  
   }  
}

//验证银行账号
function is_bank(mobile) {  
    if( mobile == "") {  
	return false;  
} else {  
  if( ! /^([1-9]{1})(\d{15}|\d{18})$/.test(mobile) ) {  
       return false;  
     }  
     return true;  
   }  
}
//正则校验end=============================================================================================================================


//刷新页面
function onBack(){
	try{
		var browserInfo = window.parent.getBrowserInfo();
		if( browserInfo.browser == "firefox" ) {
			window.location.reload(true);
		}
		else if(browserInfo.browser == "ie"){
			window.location.reload();
		}
		else {
			window.location.reload(true);
		}
	}
	catch(e){
		window.location.reload(true);
	}
}

//显示变更模态框
function onModel(){
	$("#ognChangeInfoModal").modal("show");
}

//显示变更模态框
function onModalLabel(){
	$("#tbodyInfoTr").html(""); //变更模态框返回或关闭时，数据清空，避免重复记载
    $("#ognInfoModal").modal("show");
	$("#ognChangeInfoModal").modal("hide");
}

var divIdS = "";
//组织关系图节点添加鼠标事件
$(function(){
	$(".node").bind('mousedown',function(e){
		e.preventDefault();
        divIdS = e.delegateTarget.firstChild.id;
		var v = e.which;
		if(e.which == 3){//右键
			var it = this;
			id = $(it).attr("id");
			initRightMenu();
		}
	});
	$(".node").click(function(e){
		var it = this;
		id = $(it).attr("id");
		initLeftMenu(e.delegateTarget.firstChild.id);
	})
    $("#hideData").hide();
});

function showDeptOrCompany(sign) {
	if(sign == 1) {
        $("#deptModal2").modal("hide");
        $("#parentId").val(id)
        $("#name").val("")
        $("#deptPerson").val("")
        $("#deptPhone").val("")
        $("#deptAddress").val("")
        $("#deptRevokeDate").val("")
        $("#createDate").val("")
        $("#content").val("")
        $("#deptId").val("")
        $("#name").attr("readonly",false)
        $("#deptPerson").attr("readonly",false)
        $("#deptPhone").attr("readonly",false)
        $("#deptAddress").attr("readonly",false)
        $("#content").attr("readonly",false)
        $("#saveDeptData").show();
        $("#editDeptData").hide();
        $("#deptModal").modal("show");
	}else {
		$("#deptModal2").modal("hide");
		//新增之前查询出选中的行的公司信息，并赋值到新增页面
		$.ajax({
			url: web_ctx + "/manage/organization/queryOrganizationById",
			dataType: "json",
			type: 'post',
			data: {id: id},
			success: function (data) {
				$("#id").val("");
				$("#pid").val(data.ogn.parentId);
				$("#gsmc").val("");
				$("#shxydm").val("");
				$("#clrq").val("");
				$("#zczb").val(data.ogn.zczb);
				$("#frdb").val(data.ogn.frdb);
				$("#dszzxds").val(data.ogn.dszzxds);
				$("#zjl").val(data.ogn.zjl);
				$("#cwzj").val(data.ogn.cwzj);
				$("#jshzxjs").val(data.ogn.jshzxjs);
				$("#gswz").val("");
				$("#lxdh").val("");
				$("#gsdz").val("");
				$("#gszh").val("");

				$("#zhmc").val("");
				$("#khyh").val("");
				$("#khhdz").val("");

				$("#sjdw").val(data.ogn.id);
				$("#sjcgbl").val("");
				$("#jyfw").val(data.ogn.jyfw);

				$("#save").show();
				$("#change").hide();
				$("#export").hide();
				$("#ognInfoModal").modal("show");

				$(".modal-body").find("input").each(function () {
					$(this).attr("readonly", false);
				})
				$(".modal-body").find("select").each(function () {
					$(this).attr("disabled", false);
				})
				$(".modal-body").find("textarea").attr("readonly", false);


			}
		})
	}
}

function showDeleteData(sign) {
    $("#chart-container").remove();
    $("#div").after("<div id = 'chart-container'></div>");
    setTreeInfo(sign);
    changeDate();
}


function changeDate() {
    $(".node").bind('mousedown',function(e){
        e.preventDefault();
        divIdS = e.delegateTarget.firstChild.id;
        var v = e.which;
        if(e.which == 3){//右键
            var it = this;
            id = $(it).attr("id");
            initRightMenu();
        }
    });
	$(".node").click(function(e){
		var it = this;
		id = $(it).attr("id");
		initLeftMenu(e.delegateTarget.firstChild.id);
	})
}

function editDeptData() {
	$("#name").attr("readonly",false)
	$("#deptPerson").attr("readonly",false)
	$("#deptPhone").attr("readonly",false)
	$("#deptAddress").attr("readonly",false)
	$("#deptRevokeDate").attr("readonly",false)
	$("#content").attr("readonly",false)
	$("#saveDeptData").show();
	$("#editDeptData").hide();
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
			data:{"name": $("#name").val() ,"id" : $("#deptId").val()},
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
                            $("#chart-container").remove();
                            $("#div").after("<div id = 'chart-container'></div>");
                            setTreeInfo(1);
                            changeDate();
                            $("#deptModal").modal("hide");
						}
					})
				}
			}
		})
	}
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


