/**
 * @author linzs
 * @description AES加密工具，默认使用ECB模式。
 * 				使用此脚本前，必须先导入crypto目录下的crypto-js.js和aes.js脚本，
 * 				crypto上级目录的md5.js脚本
 */

var aesUtils = (function() {
	var encryptECB = function(text, key) {
		key = hex_md5_16(key);
		var encryptContent = CryptoJS.AES.encrypt(text, CryptoJS.enc.Utf8.parse(key), {
			mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
	    });
		return encryptContent;
	};
	
	var decryptECB = function(text, key) {
		key = hex_md5_16(key);
		var decryptContent = CryptoJS.AES.decrypt(text, CryptoJS.enc.Utf8.parse(key), {
			mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
	    });
		return CryptoJS.enc.Utf8.stringify(decryptContent);
	};
	
	return {
		encryptECB: encryptECB,
		decryptECB: decryptECB
	};
})();