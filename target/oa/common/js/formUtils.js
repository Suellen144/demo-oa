/**
 * @Description serializeJson: 序列化表单为JSON对象
 * 				clear: 清空表单值
 * 
 * */
;(function( $ ) { 
	$.fn.serializeJson = function(){ 
		var serializeObj = {};  
        var array = this.serializeArray();  
        var str = this.serialize();
        
        $(array).each(function(){  
            if(serializeObj[this.name]){  
                if($.isArray(serializeObj[this.name])){  
                    serializeObj[this.name].push(this.value);  
                }else{  
                    serializeObj[this.name] = [serializeObj[this.name],this.value];  
                }  
            }else{  
                serializeObj[this.name] = this.value;   
            }  
        });
        return serializeObj;
	}
	
	$.fn.clear = function() {
		$(":input", $(this))
			.not(":button, :submit, :reset, :radio, :checkbox")
			.val("")
			.removeAttr("checked")
			.removeAttr("selected")
			.removeAttr("disabled")
			.removeAttr("readonly");
	}
	
	$.fn.prop2form = function(object) {
		var elements = $(":input", $(this)).not(":button, :submit, :reset");
		for(var prop in object) {
			var ele = findElementByName(elements, prop);

			if(ele.length == 1) {
				$(ele[0]).val(object[prop]);
			} else if(ele.length > 1) {
				if(ele[0].type .indexOf("select") > -1) {
					$(ele).each(function(index, obj) {
						if($(this).val() == object[prop]) {
							$(this).prop("selected", true);
							return false;
						}
					});
				} else {
					$(ele).each(function(index, obj) {
						if($(this).val() == object[prop]) {
							$(this).prop("checked", true);
						} else {
							$(this).prop("checked", false);
						}
					});
				}
			}
		}
		
		function findElementByName(elements, name) {
			var result = [];
			$(elements).each(function(index, ele) {
				if(ele.name == name) {
					result.push(ele);
					if(ele.type.indexOf("radio") < 0 
							&& ele.type.indexOf("select") < 0
							&& ele.type.indexOf("checkbox") < 0) {
						// 单个元素则退出
						return false;
					}
				}
			});
			return result;
		}
	}
})( jQuery );