var option = null;

$(function() {
	initChart();
});

function initChart() {
	var params = {
		"year": $.trim($("#year").val()),
		"month": $.trim($("#month").val()),
		"number": $.trim($("#number").val()),
		"deptId": $.trim($("#deptId").val()),
		"userId": $.trim($("#userId").val())
	}
	
	$.ajax({   
        "type": "POST",    
        "url": web_ctx + "/manage/ad/workReport/getWorkReportChartsData",
        "contentType": "application/json",
        "dataType": "json",   
        "data": JSON.stringify(params),
        "success": function(data) {   
        	initOption(data);
        	initTable(data);
        	var chartContainer = echarts.init(document.getElementById('chartContainer'));
        	chartContainer.setOption(option);
        	
        	chartContainer.on('legendselected', function(params) {
        	});
        },
        "error": function(data) {
        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
        }
    });
	
}

function initOption(chartsData) {
	option = {
		title: {
			text: '工作汇报工时统计',
			subtext: ''
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {
				type: 'shadow'
			}
		},
		legend: {
			data: [ chartsData.legendData ]
		},
		grid: {
			left: '3%',
			right: '4%',
			bottom: '3%',
			containLabel: true
		},
		xAxis: {
			type : 'category',
		},
		yAxis: {
			type: 'value'
		},
		series: [ {
			name: chartsData.legendData,
			type: 'bar',
			data: [ ]
		} ]
	};
	option.xAxis.data = chartsData.yAxisData;
//	option.series[0].data = chartsData.seriesData;
	option.series = chartsData.seriesData;

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

function search() {
	initChart();
}

function yearOp(btn, op) {
	var value = $(btn).siblings("input").val();
	switch(op) {
		case '+':
			value++; break ;
		case '-':
			if(value > 0) value --;
	}
	$(btn).siblings("input").val(value);
}