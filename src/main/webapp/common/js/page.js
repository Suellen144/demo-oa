/**
 * @Description 封装DataTables分页插件，使其更容易使用
 * @return dataTable 
 * 				数据表格对象，可重新设置参数或其他操作
 * */
;(function( $ ) { 
	$.fn.dataTable.ext.errMode = 'none'; // 上线时启用
	$.fn.datatable = function( options ) {
		var dataTable = null;
		var options_ = {
			"id": "dataTable",
			"url": "",
			"pageSize": 10,
			"search": null, // 获取搜索参数的回调函数
			"columns": [], // 所有的列
			"defaultOrders": [], // 默认的排序列集合
			// 排序时，页面属性和表字段的映射，比如页面有个排序属性是createDate，表字段是create_date。如果不做此映射，表排序会报没有createDate字段的错误
			"orders2Columns": [],
			"orderable": false, // 是否开启排序，默认不开启
			"rowCallBack": null, // 在数据返回后调用此函数
			"drawCallBack": null,// 在重绘表格后调用
			"deferRender": true,
			"paging": true,//是否关闭分页 默认关闭
			"info":true,//是否显示页脚
			"oLanguage": initLanguageOfChinese()
		};
		$.extend( options_, options );

		dataTable = $("#"+options_.id).DataTable({
			"bPaginate": true,
			"lengthMenu": [10, 25, 50],
			"bLengthChange" : false, // 用户可否改变每页的数据量，默认不可改
			"searching" : false,
			"paging": options_.paging, 
			"ordering" : options_.orderable, // 是否开启排序功能
			"order": options_.defaultOrders,
			"bRedraw": false,
			"info" : options_.info,
			"timeout": 5000, // 超时
			"bAutoWidth" : false,
			"bProcessing": true, // 开启读取服务器数据时显示正在加载中……
			"bServerSide": true, //开启服务器模式，使用服务器端处理配置datatable
			"bStateSave": true, // 保存上次关闭页面时的内容
			"sAjaxSource": options_.url, //给服务器发请求的url
			"iDisplayLength": options_.pageSize, //每页显示10条数据
			"sPaginationType": "full_numbers", // 显示全部分页按钮
			"oLanguage": options_.oLanguage,
			"aoColumns": options_.columns,
			"fnServerData": retrieveData_,  //获取数据的处理函数
			"fnRowCallback": rowCallBack_, // 数据返回后调用
			"drawCallback": drawCallBack_, // 重绘后调用
			"error": handleAjaxError_, // 错误处理
			stateSaveCallback: function(settings,data) {
				localStorage.setItem( 'reyzar_datatables', JSON.stringify(data) );
			},
			stateLoadCallback: function(settings) {
				var page = localStorage.getItem( 'reyzar_datatables');
				if(!isNull(page)) {
					return JSON.parse( page );
				} else {
					return null;
				}
			}
		});
		
		function initLanguageOfChinese() {
			var language = {
				"sLengthMenu": "每页显示 _MENU_ 条记录",
		        "sInfo": "从 _START_ 到 _END_ / 共 _TOTAL_ 条数据 &nbsp;&nbsp;&nbsp;第 _PAGE_页 / 共_PAGES_页",
		        "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
		        "sInfoEmpty": "没有数据",
		        "sZeroRecords": "没有检索到数据",
		        "sProcessing": "正在加载数据...",
		        "sSearch": "名称:",
		        "oPaginate": {
			        "sFirst": "首页",
			        "sPrevious": "上一页",
			        "sNext": "下一页",
			        "sLast": "尾页"
		        },
		        "aria": {
                    "sortAscending": ": 升序",
                    "sortDescending": ": 降序"
                }
			}
			
			return language;
		}
		
		/**
		 * 请求后台分页数据
		 * */
		function retrieveData_(sSource, aoData, fnCallback) {
			var pageData = recoverPage(aoData);
			var searchData = {};
			
			if(options_.search != null && typeof options_.search === "function") {
				searchData = options_.search.call(); 
			}
			
			var params = {
				"pageData": pageData,
				// 搜索条件框的值
				"search": searchData,
				// 获取排序列
				"orderColumns": getSortColumns(aoData)
			}

			$.ajax( {   
		        "type": "POST",    
		        "url": sSource,    
		        "contentType": "application/json",   
		        "dataType": "json",   
		        "data": JSON.stringify(params), //以json格式传递   
		        "success": function(resp) {   
		            fnCallback(resp); //服务器端返回的对象的returnObject部分是要求的格式  
		        },
		        "error": function(error) {
		        	if(error.status == 500) {
		        		bootstrapAlert("提示", "请求服务器发生错误，请联系管理员！", 400, null);
		        		$("#dataTable_processing").hide();
		        	}
		        }
		    });   
		}
		
		/**
		 * 设置正确的页码
		 * */
		function recoverPage(aoData) {
			var newData = [];
			var pageSize = 0;
			
			$.each(aoData, function(index, obj) {
				if(obj.name == "iDisplayLength") {
					pageSize = obj.value;
				}
				if(obj.name == "sEcho" 
					|| obj.name == "iDisplayStart" 
					|| obj.name == "iDisplayLength") {
					newData.push(obj);
				}
			});
			$.each(newData, function(index, obj) {
				if(obj.name == "iDisplayStart" && obj.value > 0) {
					obj.value = obj.value / pageSize + 1; 
				}
			});

			return newData;
		}
		/**
		 * 获取排序列
		 * */
		function getSortColumns(aoData) {
			var sortColumns = {};
			try {
				if(aoData[aoData.length-1].name == 'iSortingCols') {
					var columns = {};
					var sortables = {};
					$.each(aoData, function(index, obj) {
						var name = obj.name;
						if(name.indexOf('mDataProp') > -1) {
							columns[ obj.name.split('_')[1] ] = obj.value;
						} else if(name.indexOf('bSortable') > -1) {
							sortables[ obj.name.split('_')[1] ] = obj.value;
						}
					});
					
					var orders2Columns = {};
					if(options_.orders2Columns.length > 0) {
						$.each(options_.orders2Columns, function(index, obj) {
							orders2Columns[obj[0]] = obj[1];
						});
					}
					
					var sortingCols = aoData[aoData.length-1].value; // 共计有几个排序列
					var begin = aoData.length - sortingCols * 2 - 1;
					var end = aoData.length - 2;
					for(var index=begin; index < end; index+=2) {
						var columnIndex = aoData[index].value;
						if( sortables[columnIndex] ) { // 判断该列是否可排序，如果为true，则保存该列的排序情况
							var column = columns[columnIndex] + "";
							column = !isNull(orders2Columns[columnIndex]) ? orders2Columns[columnIndex] + "" : column; 
							var order = aoData[index+1].value + "";
							sortColumns[column] = order;
						}
					}
				}
			} catch(e) {
				console.error('获取排序列发生异常，异常信息：' + e);
			}
			
			return sortColumns;
		}
		
		/**
		 * 服务端返回数据后开始渲染表格时调用
		 **/
		function rowCallBack_(nRow, aData, iDisplayIndex) {
			if(options_.rowCallBack != null && typeof options_.rowCallBack === "function") {
				return options_.rowCallBack.call(this, nRow, aData, iDisplayIndex);
			}
		}
		
		/**
		 * 服务端返回数据后开始渲染表格时调用
		 **/
		function drawCallBack_(settings) {
			if(options_.drawCallBack != null && typeof options_.drawCallBack === "function") {
				return options_.drawCallBack.call(this, settings);
			}
		}
		
		/**
		 * 错误处理
		 * */
		function handleAjaxError_( xhr, textStatus, error ) {
			
		}
		
		return dataTable;
	}
})(jQuery);