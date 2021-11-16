var option = null;

$(function() {
	initSearch();
	initChart();
});

function initChart() {
	var params = {
		"year": $.trim($("#year").val()),
		"month": $.trim($("#month").val()),
		"deptId": $.trim($("#dept").val())
	}

	$.ajax({   
        "type": "POST",    
        "url": web_ctx+"/manage/ad/chkattRecord/getLeaveChartData",
        "contentType": "application/json",
        "dataType": "json",   
        "data": JSON.stringify(params),
        "success": function(data) {   
        	initOption(data);
        	initTable(data);
        	var chartContainer = echarts.init(document.getElementById('chartContainer'));
        	chartContainer.setOption(option);
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
}

function initOption(chartData) {
	option = {
		title: {
			text: '请假考勤',
			subtext: ''
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {
				type: 'shadow'
			}
		},
		legend: {
			data: [ chartData.legendData ]
		},
		grid: {
			left: '3%',
			right: '4%',
			bottom: '3%',
			containLabel: true
		},
		xAxis: {
			type: 'value'
		},
		yAxis: {
			type: 'category',
			data: [ ]
		},
		series: [ {
			name: chartData.legendData,
			type: 'bar',
			data: [ ]
		} ]
	};
	
	option.yAxis.data = chartData.yAxisData;
	option.series[0].data = chartData.seriesData;

}

function initTable(chartData) {
	$("#leave_table").children("tbody").html("");
	$("h3.box-title").text(chartData.legendData);
	var dayCount = 0;
	$(chartData.yAxisData).each(function(index, yData) {
		var tr = document.createElement("tr");
		var nameTd = document.createElement("td");
		var daysTd = document.createElement("td");
		
		$(nameTd).text(yData);
		$(daysTd).text(!isNull(chartData.seriesData[index]) ? chartData.seriesData[index] : "");
		$(tr).append(nameTd);
		$(tr).append(daysTd);
		
		$("#leave_table").children("tbody").append(tr);
		dayCount += chartData.seriesData[index];
	});
	
	$("#leave_table").children("tfoot").find("td:eq(1)").text(dayCount);
}

var currMonth = 1;
var currDeptId = -1;
function initSearch() {
	currMonth = new Date().getMonth()+1;
	$("#month").children("option").each(function() {
		if($(this).val() == currMonth) {
			$(this).prop("selected", true);
			return false;
		}
	});
	
	$.ajax({
	    "type": "GET",    
	    "url": web_ctx+"/manage/sys/dept/getDeptListOnJson",
	    "async": false,
	    "dataType": "json",   
	    "success": function(data) {
	    	if(undefined != data && data != null) {
	    		$(data).each(function(index, dept) {
	    			if(index == 0) {
	    				currDeptId = dept.id;
	    			}
	    			$("#dept").append("<option value="+dept.id+">"+dept.name+"</option>");
	    		});
	    	}
	    },
	    "error": function(data) {
	    	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	    }
	});
	
}

function clearForm() {
	$("#searchForm").clear();
	$("#month").children("option").each(function() {
		if($(this).val() == currMonth) {
			$(this).prop("selected", true);
			return false;
		}
	});
	$("#dept").children("option").each(function() {
		if($(this).val() == currDeptId) {
			$(this).prop("selected", true);
			return false;
		}
	})
}

function search() {
	initChart();
}