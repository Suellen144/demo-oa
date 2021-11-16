/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	 config.language = 'zh-cn';
	// config.uiColor = '#AADC6E';
	
	//工具栏是否可以被收缩
    config.toolbarCanCollapse = true;
    
    // 回车和Shirf回车设置
    config.enterMode = CKEDITOR.ENTER_BR; // 直接回车用<br/>，可以减少行间距
    config.shiftEnterMode = CKEDITOR.ENTER_P;
    
    // 加入 tab 键支持，每次移动一个字符位
    config.tabSpaces = 1;
    
    // 设置默认字体
    config.font_names = '宋体/宋体;黑体/黑体;仿宋/仿宋_GB2312;楷体/楷体_GB2312;隶书/隶书;幼圆/幼圆;微软雅黑/微软雅黑;'+ config.font_names;
    config.font_defaultLabel = '宋体';
    config.fontSize_defaultLabel = '14';
    
    // Remove some buttons provided by the standard plugins, which are
	// not needed in the Standard(s) toolbar.
	config.removeButtons = 'Underline,Subscript,Superscript';

	// Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';

	// Simplify the dialog windows.
	config.removeDialogTabs = 'image:advanced;link:advanced';
	
	// upload img path
	config.filebrowserUploadUrl = web_ctx+"/ckeditor/upload";
};
