/**
 * @author Linzs
 * @Desc 自定义表单验证规则
 * 扩展方法原型：jQuery.validator.addMethod(rulename, function(value, element, param) {}, message);
 * 方法参数解析：         rulename --- 规则名，放在rules: {表单元素:{rulename} } 
 * 			  function->value --- rulename后的值，rulename:value
 * 			function->element --- rulename元素本身
 * 			  function->param --- 参数
 * 			          message --- 当表单元素值不符合规则的时候默认 提示信息。可在messages:{}中进行覆盖
 */

/**
 * -------------------------------------------------------
 * 快速索引，可拷贝第一列(规则名)进行搜索跳转到对应的验证函数
 *   order-规则名		  		验证动作
 * 1-permissionRule    验证Shiro权限规则符号
 * -------------------------------------------------------
 * */


// 正则表达式组
var regexps = {
	// 权限字符串正则
	"permission": /^(((([a-zA-Z]+):([a-zA-Z]+):([a-zA-Z]+))|(([a-zA-Z]+):([a-zA-Z]+))|([a-zA-Z]+)),)*((([a-zA-Z]+):([a-zA-Z]+):([a-zA-Z]+))|(([a-zA-Z]+):([a-zA-Z]+))|([a-zA-Z]+))$/
};




// 1-permissionRule 验证Shiro权限规则符号
jQuery.validator.addMethod("permissionRule", function(value, element, param) {
	return this.optional(element) || regexps["permission"].test(value);
}, "权限符号格式错误");







