<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome-dark.min.css">
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome.min.css">

<style type="text/css">
  	.page-header {clear:both;margin:0 20px;padding-top:20px;}
	.the-icons {padding:25px 10px 15px;list-style:none;}
	.the-icons li {float:left;width:22%;line-height:25px;margin:2px 5px;cursor:pointer;}
	.the-icons i {margin:1px 5px;font-size:16px;} .the-icons li:hover {background-color:#efefef;}
    .the-icons li.active {background-color:#0088CC;color:#ffffff;}
    .the-icons li:hover i{font-size:20px;}
</style>
</head>
<body>

<div id="icons">
		
	    <h2 class="page-header"> Web 应用的图标</h2>
	    
	    <!-- <ul class="the-icons">
	      <li><i class="icon-adjust"></i> icon-adjust</li>
	      <li><i class="icon-asterisk"></i> icon-asterisk</li>
	      <li><i class="icon-ban-circle"></i> icon-ban-circle</li>
	      <li><i class="icon-bar-chart"></i> icon-bar-chart</li>
	      <li><i class="icon-barcode"></i> icon-barcode</li>
	      <li><i class="icon-beaker"></i> icon-beaker</li>
	      <li><i class="icon-beer"></i> icon-beer</li>
	      <li><i class="icon-bell"></i> icon-bell</li>
	      <li><i class="icon-bell-alt"></i> icon-bell-alt</li>
	      <li><i class="icon-bolt"></i> icon-bolt</li>
	      <li><i class="icon-book"></i> icon-book</li>
	      <li><i class="icon-bookmark"></i> icon-bookmark</li>
	      <li><i class="icon-bookmark-empty"></i> icon-bookmark-empty</li>
	      <li><i class="icon-briefcase"></i> icon-briefcase</li>
	      <li><i class="icon-bullhorn"></i> icon-bullhorn</li>
	      <li><i class="icon-calendar"></i> icon-calendar</li>
	      <li><i class="icon-camera"></i> icon-camera</li>
	      <li><i class="icon-camera-retro"></i> icon-camera-retro</li>
	      <li><i class="icon-certificate"></i> icon-certificate</li>
	      <li><i class="icon-check"></i> icon-check</li>
	      <li><i class="icon-check-empty"></i> icon-check-empty</li>
	      <li><i class="icon-circle"></i> icon-circle</li>
	      <li><i class="icon-circle-blank"></i> icon-circle-blank</li>
	      <li><i class="icon-cloud"></i> icon-cloud</li>
	      <li><i class="icon-cloud-download"></i> icon-cloud-download</li>
	      <li><i class="icon-cloud-upload"></i> icon-cloud-upload</li>
	      <li><i class="icon-coffee"></i> icon-coffee</li>
	      <li><i class="icon-cog"></i> icon-cog</li>
	      <li><i class="icon-cogs"></i> icon-cogs</li>
	      <li><i class="icon-comment"></i> icon-comment</li>
	      <li><i class="icon-comment-alt"></i> icon-comment-alt</li>
	      <li><i class="icon-comments"></i> icon-comments</li>
	      <li><i class="icon-comments-alt"></i> icon-comments-alt</li>
	      <li><i class="icon-credit-card"></i> icon-credit-card</li>
	      <li><i class="icon-dashboard"></i> icon-dashboard</li>
	      <li><i class="icon-desktop"></i> icon-desktop</li>
	      <li><i class="icon-download"></i> icon-download</li>
	      <li><i class="icon-download-alt"></i> icon-download-alt</li>
	    

	      <li><i class="icon-edit"></i> icon-edit</li>
	      <li><i class="icon-envelope"></i> icon-envelope</li>
	      <li><i class="icon-envelope-alt"></i> icon-envelope-alt</li>
	      <li><i class="icon-exchange"></i> icon-exchange</li>
	      <li><i class="icon-exclamation-sign"></i> icon-exclamation-sign</li>
	      <li><i class="icon-external-link"></i> icon-external-link</li>
	      <li><i class="icon-eye-close"></i> icon-eye-close</li>
	      <li><i class="icon-eye-open"></i> icon-eye-open</li>
	      <li><i class="icon-facetime-video"></i> icon-facetime-video</li>
	      <li><i class="icon-fighter-jet"></i> icon-fighter-jet</li>
	      <li><i class="icon-film"></i> icon-film</li>
	      <li><i class="icon-filter"></i> icon-filter</li>
	      <li><i class="icon-fire"></i> icon-fire</li>
	      <li><i class="icon-flag"></i> icon-flag</li>
	      <li><i class="icon-folder-close"></i> icon-folder-close</li>
	      <li><i class="icon-folder-open"></i> icon-folder-open</li>
	      <li><i class="icon-folder-close-alt"></i> icon-folder-close-alt</li>
	      <li><i class="icon-folder-open-alt"></i> icon-folder-open-alt</li>
	      <li><i class="icon-food"></i> icon-food</li>
	      <li><i class="icon-gift"></i> icon-gift</li>
	      <li><i class="icon-glass"></i> icon-glass</li>
	      <li><i class="icon-globe"></i> icon-globe</li>
	      <li><i class="icon-group"></i> icon-group</li>
	      <li><i class="icon-hdd"></i> icon-hdd</li>
	      <li><i class="icon-headphones"></i> icon-headphones</li>
	      <li><i class="icon-heart"></i> icon-heart</li>
	      <li><i class="icon-heart-empty"></i> icon-heart-empty</li>
	      <li><i class="icon-home"></i> icon-home</li>
	      <li><i class="icon-inbox"></i> icon-inbox</li>
	      <li><i class="icon-info-sign"></i> icon-info-sign</li>
	      <li><i class="icon-key"></i> icon-key</li>
	      <li><i class="icon-leaf"></i> icon-leaf</li>
	      <li><i class="icon-laptop"></i> icon-laptop</li>
	      <li><i class="icon-legal"></i> icon-legal</li>
	      <li><i class="icon-lemon"></i> icon-lemon</li>
	      <li><i class="icon-lightbulb"></i> icon-lightbulb</li>
	      <li><i class="icon-lock"></i> icon-lock</li>
	      <li><i class="icon-unlock"></i> icon-unlock</li>
	    

	      <li><i class="icon-magic"></i> icon-magic</li>
	      <li><i class="icon-magnet"></i> icon-magnet</li>
	      <li><i class="icon-map-marker"></i> icon-map-marker</li>
	      <li><i class="icon-minus"></i> icon-minus</li>
	      <li><i class="icon-minus-sign"></i> icon-minus-sign</li>
	      <li><i class="icon-mobile-phone"></i> icon-mobile-phone</li>
	      <li><i class="icon-money"></i> icon-money</li>
	      <li><i class="icon-move"></i> icon-move</li>
	      <li><i class="icon-music"></i> icon-music</li>
	      <li><i class="icon-off"></i> icon-off</li>
	      <li><i class="icon-ok"></i> icon-ok</li>
	      <li><i class="icon-ok-circle"></i> icon-ok-circle</li>
	      <li><i class="icon-ok-sign"></i> icon-ok-sign</li>
	      <li><i class="icon-pencil"></i> icon-pencil</li>
	      <li><i class="icon-picture"></i> icon-picture</li>
	      <li><i class="icon-plane"></i> icon-plane</li>
	      <li><i class="icon-plus"></i> icon-plus</li>
	      <li><i class="icon-plus-sign"></i> icon-plus-sign</li>
	      <li><i class="icon-print"></i> icon-print</li>
	      <li><i class="icon-pushpin"></i> icon-pushpin</li>
	      <li><i class="icon-qrcode"></i> icon-qrcode</li>
	      <li><i class="icon-question-sign"></i> icon-question-sign</li>
	      <li><i class="icon-quote-left"></i> icon-quote-left</li>
	      <li><i class="icon-quote-right"></i> icon-quote-right</li>
	      <li><i class="icon-random"></i> icon-random</li>
	      <li><i class="icon-refresh"></i> icon-refresh</li>
	      <li><i class="icon-remove"></i> icon-remove</li>
	      <li><i class="icon-remove-circle"></i> icon-remove-circle</li>
	      <li><i class="icon-remove-sign"></i> icon-remove-sign</li>
	      <li><i class="icon-reorder"></i> icon-reorder</li>
	      <li><i class="icon-reply"></i> icon-reply</li>
	      <li><i class="icon-resize-horizontal"></i> icon-resize-horizontal</li>
	      <li><i class="icon-resize-vertical"></i> icon-resize-vertical</li>
	      <li><i class="icon-retweet"></i> icon-retweet</li>
	      <li><i class="icon-road"></i> icon-road</li>
	      <li><i class="icon-rss"></i> icon-rss</li>
	      <li><i class="icon-screenshot"></i> icon-screenshot</li>
	      <li><i class="icon-search"></i> icon-search</li>
	    

	      <li><i class="icon-share"></i> icon-share</li>
	      <li><i class="icon-share-alt"></i> icon-share-alt</li>
	      <li><i class="icon-shopping-cart"></i> icon-shopping-cart</li>
	      <li><i class="icon-signal"></i> icon-signal</li>
	      <li><i class="icon-signin"></i> icon-signin</li>
	      <li><i class="icon-signout"></i> icon-signout</li>
	      <li><i class="icon-sitemap"></i> icon-sitemap</li>
	      <li><i class="icon-sort"></i> icon-sort</li>
	      <li><i class="icon-sort-down"></i> icon-sort-down</li>
	      <li><i class="icon-sort-up"></i> icon-sort-up</li>
	      <li><i class="icon-spinner"></i> icon-spinner</li>
	      <li><i class="icon-star"></i> icon-star</li>
	      <li><i class="icon-star-empty"></i> icon-star-empty</li>
	      <li><i class="icon-star-half"></i> icon-star-half</li>
	      <li><i class="icon-tablet"></i> icon-tablet</li>
	      <li><i class="icon-tag"></i> icon-tag</li>
	      <li><i class="icon-tags"></i> icon-tags</li>
	      <li><i class="icon-tasks"></i> icon-tasks</li>
	      <li><i class="icon-thumbs-down"></i> icon-thumbs-down</li>
	      <li><i class="icon-thumbs-up"></i> icon-thumbs-up</li>
	      <li><i class="icon-time"></i> icon-time</li>
	      <li><i class="icon-tint"></i> icon-tint</li>
	      <li><i class="icon-trash"></i> icon-trash</li>
	      <li><i class="icon-trophy"></i> icon-trophy</li>
	      <li><i class="icon-truck"></i> icon-truck</li>
	      <li><i class="icon-umbrella"></i> icon-umbrella</li>
	      <li><i class="icon-upload"></i> icon-upload</li>
	      <li><i class="icon-upload-alt"></i> icon-upload-alt</li>
	      <li><i class="icon-user"></i> icon-user</li>
	      <li><i class="icon-user-md"></i> icon-user-md</li>
	      <li><i class="icon-volume-off"></i> icon-volume-off</li>
	      <li><i class="icon-volume-down"></i> icon-volume-down</li>
	      <li><i class="icon-volume-up"></i> icon-volume-up</li>
	      <li><i class="icon-warning-sign"></i> icon-warning-sign</li>
	      <li><i class="icon-wrench"></i> icon-wrench</li>
	      <li><i class="icon-zoom-in"></i> icon-zoom-in</li>
	      <li><i class="icon-zoom-out"></i> icon-zoom-out</li>
	    </ul>
	
	  
	    <h2 class="page-header">文本编辑器图标</h2>
	  
	    <ul class="the-icons">
	      <li><i class="icon-file"></i> icon-file</li>
	      <li><i class="icon-file-alt"></i> icon-file-alt</li>
	      <li><i class="icon-cut"></i> icon-cut</li>
	      <li><i class="icon-copy"></i> icon-copy</li>
	      <li><i class="icon-paste"></i> icon-paste</li>
	      <li><i class="icon-save"></i> icon-save</li>
	      <li><i class="icon-undo"></i> icon-undo</li>
	      <li><i class="icon-repeat"></i> icon-repeat</li>
	    

	      <li><i class="icon-text-height"></i> icon-text-height</li>
	      <li><i class="icon-text-width"></i> icon-text-width</li>
	      <li><i class="icon-align-left"></i> icon-align-left</li>
	      <li><i class="icon-align-center"></i> icon-align-center</li>
	      <li><i class="icon-align-right"></i> icon-align-right</li>
	      <li><i class="icon-align-justify"></i> icon-align-justify</li>
	      <li><i class="icon-indent-left"></i> icon-indent-left</li>
	      <li><i class="icon-indent-right"></i> icon-indent-right</li>
	    

	      <li><i class="icon-font"></i> icon-font</li>
	      <li><i class="icon-bold"></i> icon-bold</li>
	      <li><i class="icon-italic"></i> icon-italic</li>
	      <li><i class="icon-strikethrough"></i> icon-strikethrough</li>
	      <li><i class="icon-underline"></i> icon-underline</li>
	      <li><i class="icon-link"></i> icon-link</li>
	      <li><i class="icon-paper-clip"></i> icon-paper-clip</li>
	      <li><i class="icon-columns"></i> icon-columns</li>
	    

	      <li><i class="icon-table"></i> icon-table</li>
	      <li><i class="icon-th-large"></i> icon-th-large</li>
	      <li><i class="icon-th"></i> icon-th</li>
	      <li><i class="icon-th-list"></i> icon-th-list</li>
	      <li><i class="icon-list"></i> icon-list</li>
	      <li><i class="icon-list-ol"></i> icon-list-ol</li>
	      <li><i class="icon-list-ul"></i> icon-list-ul</li>
	      <li><i class="icon-list-alt"></i> icon-list-alt</li>
	    </ul>
	
	    <h2 class="page-header">指示方向的图标</h2>
	  
	    <ul class="the-icons">
	      <li><i class="icon-angle-left"></i> icon-angle-left</li>
	      <li><i class="icon-angle-right"></i> icon-angle-right</li>
	      <li><i class="icon-angle-up"></i> icon-angle-up</li>
	      <li><i class="icon-angle-down"></i> icon-angle-down</li>
	      <li><i class="icon-arrow-down"></i> icon-arrow-down</li>
	      <li><i class="icon-arrow-left"></i> icon-arrow-left</li>
	      <li><i class="icon-arrow-right"></i> icon-arrow-right</li>
	      <li><i class="icon-arrow-up"></i> icon-arrow-up</li>
	    

	      <li><i class="icon-caret-down"></i> icon-caret-down</li>
	      <li><i class="icon-caret-left"></i> icon-caret-left</li>
	      <li><i class="icon-caret-right"></i> icon-caret-right</li>
	      <li><i class="icon-caret-up"></i> icon-caret-up</li>
	      <li><i class="icon-chevron-down"></i> icon-chevron-down</li>
	      <li><i class="icon-chevron-left"></i> icon-chevron-left</li>
	      <li><i class="icon-chevron-right"></i> icon-chevron-right</li>
	      <li><i class="icon-chevron-up"></i> icon-chevron-up</li>
	    

	      <li><i class="icon-circle-arrow-down"></i> icon-circle-arrow-down</li>
	      <li><i class="icon-circle-arrow-left"></i> icon-circle-arrow-left</li>
	      <li><i class="icon-circle-arrow-right"></i> icon-circle-arrow-right</li>
	      <li><i class="icon-circle-arrow-up"></i> icon-circle-arrow-up</li>
	      <li><i class="icon-double-angle-left"></i> icon-double-angle-left</li>
	      <li><i class="icon-double-angle-right"></i> icon-double-angle-right</li>
	      <li><i class="icon-double-angle-up"></i> icon-double-angle-up</li>
	      <li><i class="icon-double-angle-down"></i> icon-double-angle-down</li>
	    

	      <li><i class="icon-hand-down"></i> icon-hand-down</li>
	      <li><i class="icon-hand-left"></i> icon-hand-left</li>
	      <li><i class="icon-hand-right"></i> icon-hand-right</li>
	      <li><i class="icon-hand-up"></i> icon-hand-up</li>
	      <li><i class="icon-circle"></i> icon-circle</li>
	      <li><i class="icon-circle-blank"></i> icon-circle-blank</li>
	    </ul>
	  
	
	    <h2 class="page-header">视频播放器图标</h2>
	  
	    <ul class="the-icons">
	      <li><i class="icon-play-circle"></i> icon-play-circle</li>
	      <li><i class="icon-play"></i> icon-play</li>
	      <li><i class="icon-pause"></i> icon-pause</li>
	      <li><i class="icon-stop"></i> icon-stop</li>
	    

	      <li><i class="icon-step-backward"></i> icon-step-backward</li>
	      <li><i class="icon-fast-backward"></i> icon-fast-backward</li>
	      <li><i class="icon-backward"></i> icon-backward</li>
	      <li><i class="icon-forward"></i> icon-forward</li>
	    

	      <li><i class="icon-fast-forward"></i> icon-fast-forward</li>
	      <li><i class="icon-step-forward"></i> icon-step-forward</li>
	      <li><i class="icon-eject"></i> icon-eject</li>
	    

	      <li><i class="icon-fullscreen"></i> icon-fullscreen</li>
	      <li><i class="icon-resize-full"></i> icon-resize-full</li>
	      <li><i class="icon-resize-small"></i> icon-resize-small</li>
	    </ul>
	
	
	    <h2 class="page-header">SNS图标</h2>
	  
	    <ul class="the-icons">
	      <li><i class="icon-phone"></i> icon-phone</li>
	      <li><i class="icon-phone-sign"></i> icon-phone-sign</li>
	      <li><i class="icon-facebook"></i> icon-facebook</li>
	      <li><i class="icon-facebook-sign"></i> icon-facebook-sign</li>
	    

	      <li><i class="icon-twitter"></i> icon-twitter</li>
	      <li><i class="icon-twitter-sign"></i> icon-twitter-sign</li>
	      <li><i class="icon-github"></i> icon-github</li>
	      <li><i class="icon-github-alt"></i> icon-github-alt</li>
	    

	      <li><i class="icon-github-sign"></i> icon-github-sign</li>
	      <li><i class="icon-linkedin"></i> icon-linkedin</li>
	      <li><i class="icon-linkedin-sign"></i> icon-linkedin-sign</li>
	      <li><i class="icon-pinterest"></i> icon-pinterest</li>
	    

	      <li><i class="icon-pinterest-sign"></i> icon-pinterest-sign</li>
	      <li><i class="icon-google-plus"></i> icon-google-plus</li>
	      <li><i class="icon-google-plus-sign"></i> icon-google-plus-sign</li>
	      <li><i class="icon-sign-blank"></i> icon-sign-blank</li>
	    </ul>
	  
	  
	    <h2 class="page-header">医疗图标</h2>
	  
	    <ul class="the-icons">
	      <li><i class="icon-ambulance"></i> icon-ambulance</li>
	      <li><i class="icon-beaker"></i> icon-beaker</li>
	    

	      <li><i class="icon-h-sign"></i> icon-h-sign</li>
	      <li><i class="icon-hospital"></i> icon-hospital</li>
	    

	      <li><i class="icon-medkit"></i> icon-medkit</li>
	      <li><i class="icon-plus-sign-alt"></i> icon-plus-sign-alt</li>
	    

	      <li><i class="icon-stethoscope"></i> icon-stethoscope</li>
	      <li><i class="icon-user-md"></i> icon-user-md</li>
	    </ul> -->
	    
	    <ul class="the-icons">
	      <li><i class="icon-adjust"></i> </li>
	      <li><i class="icon-asterisk"></i> </li>
	      <li><i class="icon-ban-circle"></i> </li>
	      <li><i class="icon-bar-chart"></i> </li>
	      <li><i class="icon-barcode"></i> </li>
	      <li><i class="icon-beaker"></i> </li>
	      <li><i class="icon-beer"></i> </li>
	      <li><i class="icon-bell"></i> </li>
	      <li><i class="icon-bell-alt"></i> </li>
	      <li><i class="icon-bolt"></i> </li>
	      <li><i class="icon-book"></i> </li>
	      <li><i class="icon-bookmark"></i> </li>
	      <li><i class="icon-bookmark-empty"></i> </li>
	      <li><i class="icon-briefcase"></i> </li>
	      <li><i class="icon-bullhorn"></i> </li>
	      <li><i class="icon-calendar"></i> </li>
	      <li><i class="icon-camera"></i> </li>
	      <li><i class="icon-camera-retro"></i> </li>
	      <li><i class="icon-certificate"></i> </li>
	      <li><i class="icon-check"></i> </li>
	      <li><i class="icon-check-empty"></i> </li>
	      <li><i class="icon-circle"></i> </li>
	      <li><i class="icon-circle-blank"></i> </li>
	      <li><i class="icon-cloud"></i> </li>
	      <li><i class="icon-cloud-download"></i> </li>
	      <li><i class="icon-cloud-upload"></i> </li>
	      <li><i class="icon-coffee"></i> </li>
	      <li><i class="icon-cog"></i> </li>
	      <li><i class="icon-cogs"></i> </li>
	      <li><i class="icon-comment"></i> </li>
	      <li><i class="icon-comment-alt"></i> </li>
	      <li><i class="icon-comments"></i> </li>
	      <li><i class="icon-comments-alt"></i> </li>
	      <li><i class="icon-credit-card"></i> </li>
	      <li><i class="icon-dashboard"></i> </li>
	      <li><i class="icon-desktop"></i> </li>
	      <li><i class="icon-download"></i> </li>
	      <li><i class="icon-download-alt"></i> </li>

	      <li><i class="icon-edit"></i> </li>
	      <li><i class="icon-envelope"></i> </li>
	      <li><i class="icon-envelope-alt"></i> </li>
	      <li><i class="icon-exchange"></i> </li>
	      <li><i class="icon-exclamation-sign"></i> </li>
	      <li><i class="icon-external-link"></i> </li>
	      <li><i class="icon-eye-close"></i> </li>
	      <li><i class="icon-eye-open"></i> </li>
	      <li><i class="icon-facetime-video"></i> </li>
	      <li><i class="icon-fighter-jet"></i> </li>
	      <li><i class="icon-film"></i> </li>
	      <li><i class="icon-filter"></i> </li>
	      <li><i class="icon-fire"></i> </li>
	      <li><i class="icon-flag"></i> </li>
	      <li><i class="icon-folder-close"></i> </li>
	      <li><i class="icon-folder-open"></i> </li>
	      <li><i class="icon-folder-close-alt"></i> </li>
	      <li><i class="icon-folder-open-alt"></i> </li>
	      <li><i class="icon-food"></i> </li>
	      <li><i class="icon-gift"></i> </li>
	      <li><i class="icon-glass"></i> </li>
	      <li><i class="icon-globe"></i> </li>
	      <li><i class="icon-group"></i> </li>
	      <li><i class="icon-hdd"></i> </li>
	      <li><i class="icon-headphones"></i> </li>
	      <li><i class="icon-heart"></i> </li>
	      <li><i class="icon-heart-empty"></i> </li>
	      <li><i class="icon-home"></i> </li>
	      <li><i class="icon-inbox"></i> </li>
	      <li><i class="icon-info-sign"></i> </li>
	      <li><i class="icon-key"></i> </li>
	      <li><i class="icon-leaf"></i> </li>
	      <li><i class="icon-laptop"></i> </li>
	      <li><i class="icon-legal"></i> </li>
	      <li><i class="icon-lemon"></i> </li>
	      <li><i class="icon-lightbulb"></i> </li>
	      <li><i class="icon-lock"></i> </li>
	      <li><i class="icon-unlock"></i> </li>

	      <li><i class="icon-magic"></i> </li>
	      <li><i class="icon-magnet"></i> </li>
	      <li><i class="icon-map-marker"></i> </li>
	      <li><i class="icon-minus"></i> </li>
	      <li><i class="icon-minus-sign"></i> </li>
	      <li><i class="icon-mobile-phone"></i> </li>
	      <li><i class="icon-money"></i> </li>
	      <li><i class="icon-move"></i> </li>
	      <li><i class="icon-music"></i> </li>
	      <li><i class="icon-off"></i> </li>
	      <li><i class="icon-ok"></i> </li>
	      <li><i class="icon-ok-circle"></i> </li>
	      <li><i class="icon-ok-sign"></i> </li>
	      <li><i class="icon-pencil"></i> </li>
	      <li><i class="icon-picture"></i> </li>
	      <li><i class="icon-plane"></i> </li>
	      <li><i class="icon-plus"></i> </li>
	      <li><i class="icon-plus-sign"></i> </li>
	      <li><i class="icon-print"></i> </li>
	      <li><i class="icon-pushpin"></i> </li>
	      <li><i class="icon-qrcode"></i> </li>
	      <li><i class="icon-question-sign"></i> </li>
	      <li><i class="icon-quote-left"></i> </li>
	      <li><i class="icon-quote-right"></i> </li>
	      <li><i class="icon-random"></i> </li>
	      <li><i class="icon-refresh"></i> </li>
	      <li><i class="icon-remove"></i> </li>
	      <li><i class="icon-remove-circle"></i> </li>
	      <li><i class="icon-remove-sign"></i> </li>
	      <li><i class="icon-reorder"></i> </li>
	      <li><i class="icon-reply"></i> </li>
	      <li><i class="icon-resize-horizontal"></i> </li>
	      <li><i class="icon-resize-vertical"></i> </li>
	      <li><i class="icon-retweet"></i> </li>
	      <li><i class="icon-road"></i> </li>
	      <li><i class="icon-rss"></i> </li>
	      <li><i class="icon-screenshot"></i> </li>
	      <li><i class="icon-search"></i> </li>

	      <li><i class="icon-share"></i> </li>
	      <li><i class="icon-share-alt"></i> </li>
	      <li><i class="icon-shopping-cart"></i> </li>
	      <li><i class="icon-signal"></i> </li>
	      <li><i class="icon-signin"></i> </li>
	      <li><i class="icon-signout"></i> </li>
	      <li><i class="icon-sitemap"></i> </li>
	      <li><i class="icon-sort"></i> </li>
	      <li><i class="icon-sort-down"></i> </li>
	      <li><i class="icon-sort-up"></i> </li>
	      <li><i class="icon-spinner"></i> </li>
	      <li><i class="icon-star"></i> </li>
	      <li><i class="icon-star-empty"></i> </li>
	      <li><i class="icon-star-half"></i> </li>
	      <li><i class="icon-tablet"></i> </li>
	      <li><i class="icon-tag"></i> </li>
	      <li><i class="icon-tags"></i> </li>
	      <li><i class="icon-tasks"></i> </li>
	      <li><i class="icon-thumbs-down"></i> </li>
	      <li><i class="icon-thumbs-up"></i> </li>
	      <li><i class="icon-time"></i> </li>
	      <li><i class="icon-tint"></i> </li>
	      <li><i class="icon-trash"></i> </li>
	      <li><i class="icon-trophy"></i> </li>
	      <li><i class="icon-truck"></i> </li>
	      <li><i class="icon-umbrella"></i> </li>
	      <li><i class="icon-upload"></i> </li>
	      <li><i class="icon-upload-alt"></i> </li>
	      <li><i class="icon-user"></i> </li>
	      <li><i class="icon-user-md"></i> </li>
	      <li><i class="icon-volume-off"></i> </li>
	      <li><i class="icon-volume-down"></i> </li>
	      <li><i class="icon-volume-up"></i> </li>
	      <li><i class="icon-warning-sign"></i> </li>
	      <li><i class="icon-wrench"></i> </li>
	      <li><i class="icon-zoom-in"></i> </li>
	      <li><i class="icon-zoom-out"></i> </li>
	    </ul>
	
	  
	    <h2 class="page-header">文本编辑器图标</h2>
	    <ul class="the-icons">
	      <li><i class="icon-file"></i> </li>
	      <li><i class="icon-file-alt"></i> </li>
	      <li><i class="icon-cut"></i> </li>
	      <li><i class="icon-copy"></i> </li>
	      <li><i class="icon-paste"></i> </li>
	      <li><i class="icon-save"></i> </li>
	      <li><i class="icon-undo"></i> </li>
	      <li><i class="icon-repeat"></i> </li>

	      <li><i class="icon-text-height"></i> </li>
	      <li><i class="icon-text-width"></i> </li>
	      <li><i class="icon-align-left"></i> </li>
	      <li><i class="icon-align-center"></i> </li>
	      <li><i class="icon-align-right"></i> </li>
	      <li><i class="icon-align-justify"></i> </li>
	      <li><i class="icon-indent-left"></i> </li>
	      <li><i class="icon-indent-right"></i> </li>

	      <li><i class="icon-font"></i> </li>
	      <li><i class="icon-bold"></i> </li>
	      <li><i class="icon-italic"></i> </li>
	      <li><i class="icon-strikethrough"></i> </li>
	      <li><i class="icon-underline"></i> </li>
	      <li><i class="icon-link"></i> </li>
	      <li><i class="icon-paper-clip"></i> </li>
	      <li><i class="icon-columns"></i> </li>

	      <li><i class="icon-table"></i> </li>
	      <li><i class="icon-th-large"></i> </li>
	      <li><i class="icon-th"></i> </li>
	      <li><i class="icon-th-list"></i> </li>
	      <li><i class="icon-list"></i> </li>
	      <li><i class="icon-list-ol"></i> </li>
	      <li><i class="icon-list-ul"></i> </li>
	      <li><i class="icon-list-alt"></i> </li>
	    </ul>
	    
	
	    <h2 class="page-header">指示方向的图标</h2>
	    <ul class="the-icons">
	      <li><i class="icon-angle-left"></i> </li>
	      <li><i class="icon-angle-right"></i> </li>
	      <li><i class="icon-angle-up"></i> </li>
	      <li><i class="icon-angle-down"></i> </li>
	      <li><i class="icon-arrow-down"></i> </li>
	      <li><i class="icon-arrow-left"></i> </li>
	      <li><i class="icon-arrow-right"></i> </li>
	      <li><i class="icon-arrow-up"></i> </li>

	      <li><i class="icon-caret-down"></i> </li>
	      <li><i class="icon-caret-left"></i> </li>
	      <li><i class="icon-caret-right"></i> </li>
	      <li><i class="icon-caret-up"></i> </li>
	      <li><i class="icon-chevron-down"></i> </li>
	      <li><i class="icon-chevron-left"></i> </li>
	      <li><i class="icon-chevron-right"></i> </li>
	      <li><i class="icon-chevron-up"></i> </li>

	      <li><i class="icon-circle-arrow-down"></i> </li>
	      <li><i class="icon-circle-arrow-left"></i> </li>
	      <li><i class="icon-circle-arrow-right"></i> </li>
	      <li><i class="icon-circle-arrow-up"></i> </li>
	      <li><i class="icon-double-angle-left"></i> </li>
	      <li><i class="icon-double-angle-right"></i> </li>
	      <li><i class="icon-double-angle-up"></i> </li>
	      <li><i class="icon-double-angle-down"></i> </li>

	      <li><i class="icon-hand-down"></i> </li>
	      <li><i class="icon-hand-left"></i> </li>
	      <li><i class="icon-hand-right"></i> </li>
	      <li><i class="icon-hand-up"></i> </li>
	      <li><i class="icon-circle"></i> </li>
	      <li><i class="icon-circle-blank"></i> </li>
	    </ul>
	  
	
	    <h2 class="page-header">视频播放器图标</h2>
	    <ul class="the-icons">
	      <li><i class="icon-play-circle"></i> </li>
	      <li><i class="icon-play"></i> </li>
	      <li><i class="icon-pause"></i> </li>
	      <li><i class="icon-stop"></i> </li>

	      <li><i class="icon-step-backward"></i> </li>
	      <li><i class="icon-fast-backward"></i> </li>
	      <li><i class="icon-backward"></i> </li>
	      <li><i class="icon-forward"></i> </li>
	    
	      <li><i class="icon-fast-forward"></i> </li>
	      <li><i class="icon-step-forward"></i> </li>
	      <li><i class="icon-eject"></i> </li>
	    
	      <li><i class="icon-fullscreen"></i> </li>
	      <li><i class="icon-resize-full"></i> </li>
	      <li><i class="icon-resize-small"></i> </li>
	    </ul>
	
	
	    <h2 class="page-header">SNS图标</h2>
	    <ul class="the-icons">
	      <li><i class="icon-phone"></i> </li>
	      <li><i class="icon-phone-sign"></i> </li>
	      <li><i class="icon-facebook"></i> </li>
	      <li><i class="icon-facebook-sign"></i> </li>

	      <li><i class="icon-twitter"></i> </li>
	      <li><i class="icon-twitter-sign"></i> </li>
	      <li><i class="icon-github"></i> </li>
	      <li><i class="icon-github-alt"></i> </li>

	      <li><i class="icon-github-sign"></i> </li>
	      <li><i class="icon-linkedin"></i> </li>
	      <li><i class="icon-linkedin-sign"></i> </li>
	      <li><i class="icon-pinterest"></i> </li>

	      <li><i class="icon-pinterest-sign"></i> </li>
	      <li><i class="icon-google-plus"></i> </li>
	      <li><i class="icon-google-plus-sign"></i> </li>
	      <li><i class="icon-sign-blank"></i> </li>
	    </ul>
	  
	  
	    <h2 class="page-header">医疗图标</h2>
	    <ul class="the-icons">
	      <li><i class="icon-ambulance"></i> </li>
	      <li><i class="icon-beaker"></i> </li>

	      <li><i class="icon-h-sign"></i> </li>
	      <li><i class="icon-hospital"></i> </li>

	      <li><i class="icon-medkit"></i> </li>
	      <li><i class="icon-plus-sign-alt"></i> </li>

	      <li><i class="icon-stethoscope"></i> </li>
	      <li><i class="icon-user-md"></i> </li>
	    </ul>
	<br/><br/>
</div>

<%@ include file="../footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/nicescroll/jquery.nicescroll.min.js"></script>
<script type="text/javascript">
var iconClass = null;

$(document).ready(function(){
	$("#icons li").click(function(){
		$("#icons li").removeClass("active");
		$("#icons li i").removeClass("icon-white");
		$(this).addClass("active");
		$(this).children("i").addClass("icon-white");
		$("#icon").val($(this).text());
	});
	$("#icons li").each(function(){
		if ($(this).text()=="${value}"){
			$(this).click();
		}
	});
	$("#icons li").dblclick(function(){
		iconClass = $(this).children("i").attr("class");
		var closeBtn = parent.window.document.getElementById("_closeBtn_");
		$(closeBtn).trigger("click");		
	});
	
	$("html").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
});

function getIconClass() {
	return iconClass;
}
</script>
</body>
</html>