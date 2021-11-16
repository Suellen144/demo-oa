
var phoneData = [];
var nameData = [];
var emailData = [];

var userData;
var and,len;

$(function(){
	//submit()
	
	$.fn.autocomplete = function(params) {

		//Selections
		var currentSelection = -1;
		var currentProposals = [];
		
		//Default parameters
		params = $.extend({
			hints: [],
			placeholder: '姓名/电话/邮箱',
			
			showButton: true,
			buttonText: '搜索',
			onSubmit: function(text){},
			onBlur: function(){}
		}, params);

		//Build messagess
		this.each(function() {
			//Container
			var searchContainer = $('<div></div>')
				.addClass('autocomplete-container');
					
				
			//Text input		
			var input = $('<input type="text" autocomplete="off" name="query" spellcheck ="false">')
				.attr('placeholder', params.placeholder)
				.addClass('autocomplete-input')
				
			
			if(params.showButton){
				input.css('border-radius', '3px 0 0 0px');
			}

			//Proposals
			var proposals = $('<div></div>')
				.addClass('proposal-box').css("top","34px");
			var proposalList = $('<ul></ul>')
				.addClass('proposal-list');

			proposals.append(proposalList);
			
			input.keydown(function(e) {
				switch(e.which) {
					case 38: // Up arrow
					e.preventDefault();
					$('ul.proposal-list li').removeClass('selected');
					if((currentSelection - 1) >= 0){
						currentSelection--;
						$( "ul.proposal-list li:eq(" + currentSelection + ")" )
							.addClass('selected');
					} else {
						currentSelection = -1;
					}
					break;
					case 40: // Down arrow
					e.preventDefault();
					if((currentSelection + 1) < currentProposals.length){
						$('ul.proposal-list li').removeClass('selected');
						currentSelection++;
						$( "ul.proposal-list li:eq(" + currentSelection + ")" )
							.addClass('selected');
					}
					break;
					case 13: // Enter
						if(currentSelection > -1){
							var text = $( "ul.proposal-list li:eq(" + currentSelection + ")" ).html();
							input.val(text);
						}
						currentSelection = -1;
						proposalList.empty();
						params.onSubmit(input.val());
						break;
					case 27: // Esc button
						currentSelection = -1;
						proposalList.empty();
						input.val('');
						break;
				}
			});
				
			input.bind("keyup", function(e){
				if(e.which != 13 && e.which != 27 
						&& e.which != 38 && e.which != 40){				
					currentProposals = [];
					currentSelection = -1;
					proposalList.empty();
					if(input.val() != ''){
						if(is_email(input.val()) || is_en(input.val())){
							and = 1;
							
						}else if(is_name(input.val())){
							and = 2;
							
						}else if(is_num(input.val())){
							and = 0;
							
						}		
					}else{
						and = undefined;
					}
				}
			});
			
			input.blur(function(e){
				currentSelection = -1;
				//proposalList.empty();
				params.onBlur();
			});
			
			searchContainer.append(input);
			searchContainer.append(proposals);		
			
			if(params.showButton){
				//Search button
				var button = $('<div></div>')
					.addClass('autocomplete-button')
					.html(params.buttonText)
					
					.click(function(){
						proposalList.empty();
						params.onSubmit(input.val());
	
					});
				searchContainer.append(button);	
			}
	
			$(this).append(searchContainer);	
			
			if(params.showButton){
				//Width fix
				/*searchContainer.css('width', params.width + button.width() + 50);*/
			}
		});

		return this;
	};
	$("#btn").css("display","none")
	
});

function is_email(str){		
	var re=/^[a-z]+@reyzar.com$/;
    if(re.test(str)){
        return true;
    }else{
        return false;
    }
}

function is_en(str){
	var re=/^[a-zA-Z]+$/;
    if(re.test(str)){
        return true;
    }else{
        return false;
    }
}


function is_name(str){
	var re=/^[\u4E00-\u9FA5]{1,5}$/;
    if(re.test(str)){
        return true;
    }else{
        return false;
    }
}

function is_num(str) {
    var re=/^[0-9]*$/;
    if(re.test(str)){
        return true;
    }else{
        return false;
    }
}

function is_phone(str) {
    var re=/(\d{3}-\d{8}|\d{4}-\d{7})|(^1[3|5|8]\d{9}$)/;
    if(re.test(str)){
        return true;
    }else{
        return false;
    }
}

function submit(val,and){
	if(and == 1){
		if(!is_email(val)){
			bootstrapAlert("提示", "输入邮箱不合法！", 300, null);
			return;
		}	
	}else if(and == 2){
		if(!is_name(val)){
			bootstrapAlert("提示", "请输入1-5中文字符！", 300, null);
			return;
		}
	}else if(and == 0){
		if(!is_phone(val)){
			bootstrapAlert("提示", "请输入合法手机号码！", 300, null);
			return;
		}
	}else if(and == undefined){
		bootstrapAlert("提示", "请输搜索条件值！", 300, null);
		return;
	}

	$.ajax({
		url: base + "/manage/addressbook/queryAddressBookList",
		dataType: "json",
		type: 'post',
		async:false,
		data: {"queryVal":val},
		success: function(data) {
			userData = data;
			len = data.length
			$.each(data,function(index){
				phoneData.push(data[index].phone);
				nameData.push(data[index].name);
				emailData.push(data[index].email)
			})
			$("#upPage").hide();
			$("#nextPage").hide();
			if(data.length==1){
				$("#gsName").text("睿哲科技股份有限公司");
				$("#deptName").text(data[0].deptName);
				$("#xmz").text(data[0].xmz);
				$("#name").text(data[0].name);
				$("#position").text(data[0].position);
				$("#phone").text(data[0].phone);
				$("#email").text(data[0].email)
				$(".message table").attr("data-i",'0');
				$("#btn").css("display","none")
				/*var html = '<table><tr><th>公司</th><td>睿哲科技股份有限公司</td></tr><tr><th>部门</th><td>'+userData[0].deptName+'</td></tr><tr><th>项目组</th><td>'+userData[0].xzm+'</td></tr><tr><th>姓名</th><td>'+userData[0].name+'</td></tr><tr><th>岗位</th><td>'+userData[0].position+'</td></tr><tr><th>电话</th><td>'+userData[0].phone+'</td></tr><tr><th>邮箱</th><td>'+userData[0].email+'</td></tr></table>';
				$('#message').html(html);*/
			}else if(data.length>1){
				$("#btn").css("display","block")
				$("#gsName").text("睿哲科技股份有限公司");
				$("#deptName").text(data[0].deptName);
				$("#xmz").text(data[0].xmz);
				$("#name").text(data[0].name);
				$("#position").text(data[0].position);
				$("#phone").text(data[0].phone);
				$("#email").text(data[0].email)
				$(".message table").attr("data-i",'0');
				/*var html = '<table><tr><th>公司</th><td>睿哲科技股份有限公司</td></tr><tr><th>部门</th><td>'+userData[0].deptName+'</td></tr><tr><th>项目组</th><td>'+userData[0].xzm+'</td></tr><tr><th>姓名</th><td>'+userData[0].name+'</td></tr><tr><th>岗位</th><td>'+userData[0].position+'</td></tr><tr><th>电话</th><td>'+userData[0].phone+'</td></tr><tr><th>邮箱</th><td>'+userData[0].email+'</td></tr></table>';
				$('#message').html(html);*/
			}else{
				bootstrapAlert("提示", "无数据！", 300, null);
				if($(window).width() < 578){
		    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
		    	}
			}
		}		
	});
}

$(document).ready(function(){
	//console.log(userData)
	
	$('#search-form').autocomplete({
		width: 300,
		height: 30,
		onSubmit: function(text){
			var data = text;
			submit(data,and)	
		}
	});
	
	$("#btn .lastPage").click(function(){
		//console.log($(this).attr("data-i"))
		if($(this).attr("data-i") == '-1'){
			bootstrapAlert("提示", "当前页为第一页", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}else{
			//console.log($("#message table").attr("data-i"),$(this).attr("data-i"));
			$("#gsName").text("睿哲科技股份有限公司");
			$("#deptName").text(userData[$(this).attr("data-i")].deptName);
			$("#xmz").text(userData[$(this).attr("data-i")].xmz);
			$("#name").text(userData[$(this).attr("data-i")].name);
			$("#position").text(userData[$(this).attr("data-i")].position);
			$("#phone").text(userData[$(this).attr("data-i")].phone);
			$("#email").text(userData[$(this).attr("data-i")].email)
			
			$("#btn .nextPage").attr("data-i",$("#message table").attr("data-i"));
			
			$("#message table").attr("data-i",$(this).attr("data-i"));
			
			$("#btn .lastPage").attr("data-i",$(this).attr("data-i")-1);
				
			
			
		}
		
	})
	$("#btn .nextPage").click(function(){
//		console.log($(this).attr("data-i") == len)
//		console.log(len)
		if($(this).attr("data-i") == len){
			bootstrapAlert("提示", "当前页为最后一页", 400, null);
			if($(window).width() < 578){
	    		$(".modal-dialog").css({"width":"95%","margin":"20px auto"});
	    	}
		}else{
			//console.log($("#message table").attr("data-i"),$(this).attr("data-i"));
			$("#gsName").text("睿哲科技股份有限公司");
			$("#deptName").text(userData[$(this).attr("data-i")].deptName);
			$("#xmz").text(userData[$(this).attr("data-i")].xmz);
			$("#name").text(userData[$(this).attr("data-i")].name);
			$("#position").text(userData[$(this).attr("data-i")].position);
			$("#phone").text(userData[$(this).attr("data-i")].phone);
			$("#email").text(userData[$(this).attr("data-i")].email)
			
			
			$("#btn .lastPage").attr("data-i",$("#message table").attr("data-i"));
			
			$("#message table").attr("data-i",$(this).attr("data-i"));
			
			$("#btn .nextPage").attr("data-i",parseInt($(this).attr("data-i"))+1);
		}
		
	})
});

//适配移动端
function mobilePage(){
	if($(window).width() < 578) {
		$("#wrapper").css("width","100%");
	}
}

