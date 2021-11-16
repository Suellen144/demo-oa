<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<style>
		body {
			background: none !important;
		}

		#table {
			table-collapse: collapse;
			border: none;
			width: 96%;
			margin: 0 auto;
		}

		#table td {
			border: solid #999 1px;
			padding: 5px;
			word-break: break-all;
			text-align: center;
		}

		select {
			appearance: none;
			-moz-appearance: none;
			-webkit-appearance: none;
			border: none;
			text-align-last: center;
		}

		/* IE10以上生效 */
		select::-ms-expand {
			display: none;
		}

		#table td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
			text-align: center;
		}

		#table td span {
			padding: 0px 6px;
		}

		#table th {
			text-align: center;
			font-size: 1.5em;
			font-weight: bold;
		}

		.td_weight {
			font-weight: bold;
			text-align: center;
		}

		#table2 {
			width: 96%;
			margin: 0 auto;
			margin-top: 1.3em;
		}

		#table2 td {
			font-weight: bold;
			font-size: 1em;
			width: 13%;
		}

		.td_left {
			text-align: left !important;
			white-space: pre-line;
		}

		/******** 打印机样式 ********/
		@media print {
			/* portrait： 纵向打印       landscape: 横向 打印  */
			@page {
				size: A5 landscape;
				/* margin: 2cm 0cm 1.4cm 3cm; */
			}
			* {
				text-shadow: none !important;
				box-shadow: none !important;
			}
			body {
				background-color: #FFF;
				background-image: none;
				width: 100%;
				margin: 0;
				padding: 0;
			}
			#table {
				width: 98%;
				table-collapse: collapse;
				border: none;
				padding: 0;
				margin: 0;
			}
			#table tr {
				/* page-break-after: always; */
				/* page-break-after: avoid; */

			}
			#table th {
				text-align: center;
				font-weight: bold;
				font-size: 12pt;
			}
			#table td {
				font-family: 宋体;
				font-size: 8pt !important;
				border: solid #999 0.5pt;
				padding: 1pt;
				word-break: break-all;
				word-wrap: break-word;
				text-align: center;
			}
			#table td span {
				padding: 0pt 1pt;
			}
			#table th {
				text-align: center;
				font-weight: bold;
				font-size: 12pt;
			}
			#table td.td_left {
				text-align: left;
			}
			#table2 {
				width: 96%;
				margin-top: 1em;
			}
			#table2 td {
				font-weight: bold;
				font-size: 8pt;
				width: 13%;
			}
			.padding_left {
				padding-left: 1em;
			}
		}
	</style>
</head>
<body>

<div class="tbspace">
	<input type="hidden" id="status" value="${map.business.status }">
	<input type="hidden" id="title_val" value="${map.business.title }">
	<%-- <input type="hidden" id="encrypted" value="${map.business.encrypted }"> --%>
	<select id="title_hidden" style="display: none;"><custom:dictSelect
			type="流程所属公司" /></select>
	<button type="button" id="button3" onclick="hiddenall()">编辑完毕</button>
	<table id="table">
		<thead>
		<tr>
			<th id="" colspan="20" style="padding-bottom: 0.5em;">
				<span id="title_name" contenteditable="true"></span>
				<span>( 合同 ) 付款申请表</span>
			</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td class="td_weight"><span>申请部门</span></td>
			<td contenteditable="true" id="dape_name">${map.business.dept.name }</td>
			<td class="td_weight"><span>申请人</span></td>
			<td contenteditable="true" id="name" style="width: 18%">${map.business.sysUser.name }</td>
			<td class="td_weight" style="width: 20%"><span>申请日期</span></td>
			<td contenteditable="true" colspan="2" id="applyTime"><fmt:formatDate
					value="${map.business.applyTime }" pattern="yyyy年MM月dd日" /></td>
		</tr>
		<tr>
			<td class="td_weight" style="width: 9%"><span>项目名称</span></td>
			<td contenteditable="true" colspan="6">${map.business.projectManage.name }</td>
		</tr>
		<tr>
			<td class="td_weight" style="width: 9%" rowspan="4"><span>收款单位</span></td>
		</tr>
		<tr>
			<td class="td_weight" style="width: 9%"><span>单位名称</span></td>
			<td contenteditable="true" colspan="5">${map.business.collectCompany }</td>
		</tr>
		<tr style="height: 50px">
			<td class="td_weight" style="width: 9%" rowspan="2"><span>开户行</span></td>
			<td contenteditable="true" colspan="2" rowspan="2">${map.business.bankAddress }</td>
			<td class="td_weight" style="width: 9%" rowspan="2"><span>账号</span></td>
			<td contenteditable="true" id="bankAccount" colspan="2" rowspan="2">${map.business.bankAccount }</td>
		</tr>
		<tr>
		</tr>
		<tr>
			<td class="td_weight" style="width: 9%"><span>合同名称</span></td>
			<td contenteditable="true" colspan="3">${map.business.barginManage.barginName }</td>
			<td class="td_weight" style="width: 9%"><span>合同编号</span></td>
			<td contenteditable="true" colspan="2">${map.business.barginManage.barginCode }</td>
		</tr>
		<tr>
			<td class="td_weight" style="width: 12%"><span>合同总金额</span></td>
			<td contenteditable="true" id="totalMoney" colspan="2" onblur="initInputBlur()" ><fmt:formatNumber value='${map.business.totalMoney }' pattern='0.00' /></td>
			<td class="td_weight" style="width: 9%" ><span>申请金额</span></td>
			<td contenteditable="true" id="applyMoney" onblur="initInputBlur()"><fmt:formatNumber value='${map.business.applyMoney }' pattern='0.00' /></td>
			<td class="td_weight" style="width: 12%"><span>本次申请比例</span></td>
			<td contenteditable="true" id="applyProportion">${map.business.applyProportion }</td>
		</tr>
		<tr>
			<td class="td_weight" style="width: 9%" rowspan="2"><span>用途</span></td>
			<td contenteditable="true" colspan="6">${map.business.purpose }</td>
		</tr>
		</tbody>
	</table>

	<table id="table2">
		<tbody>
		<tr>
			<td id="fuhe" style="text-align: center;">审批：</td>
			<td id="ceo" style="text-align: center;">复核：</td>
		</tr>
		</tbody>
	</table>
</div>

<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
    base = "<%=base%>";
</script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<shiro:hasPermission name="fin:reimburse:decrypt">
	<script type="text/javascript"
			src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
	<script type="text/javascript"
			src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
	<script type="text/javascript"
			src="<%=base%>/common/js/encrypt/md5.js"></script>
	<script type="text/javascript"
			src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
</shiro:hasPermission>

<script>
    var variables = JSON.parse('${map.jsonMap.variables}');
    var titleMap = {};

    $(function() {
        initMap();
        initPage();
        initDatetimepicker();
    });

    function initInputBlur(){
        var totalMoney = $("#totalMoney").text();
        var applyMoney = $("#applyMoney").text();
        if(!isNull(totalMoney) && parseInt(totalMoney)> 0 && !isNull(applyMoney) && parseInt(applyMoney) > 0){

            $("#applyProportion").text(digitTool.divide(parseFloat(applyMoney),parseFloat(totalMoney)).toFixed(4)* 100+ "%");
        }else{
            $("#applyProportion").text("");
        }
    }



    function hiddenall() {
        bootstrapConfirm("提示", "执行此操作后无法再次更改表格，确定吗？", 300, function() {
            /* hiddenvalues(); */
            /* $("#button1")[0].style.display = 'none';
            $("#button2")[0].style.display = 'none'; */
            $("#button3")[0].style.display = 'none';
            /* 		updatereimbursetotal(); */
        });
        $("#table").find("td").prop("contenteditable", false);
        var totalMoney = $("#totalMoney").text();
        var applyMoney = $("#applyMoney").text();
        $("#totalMoney").text(parseFloat(totalMoney).toFixed(2));
        $("#applyMoney").text(parseFloat(applyMoney).toFixed(2));

    }

    function initDatetimepicker() {
        $("input.datetimepick").datetimepicker({
            minView : "month",
            language : "zh-CN",
            format : "yyyy-mm-dd",
            toDay : true,
            bootcssVer : 3,
            pickDate : true,
            pickTime : false,
            autoclose : true,
        });
    }

    function initMap() {
        $("#title_hidden").find("option").each(function(index, option) {
            titleMap[$(option).attr("value")] = $(option).text();
        });
    }

    function initPage() {
        var title = titleMap[$("#title_val").val()];
        $("#title_name").text(title);
        var status = $("#status").val();
        // 初始化签名
        var node2td = {
            "总经理" : (status == "3" || status == "4" || status == "11") ? ""
                : "ceo",
            "复核" : (status == "3" || status == "11") ? "" : "fuhe",
            "部门经理" : "manager"
        };
    }




    function encryptPageText(encryptionKey) {
        $("td[name='reason'],td[name='detail']").each(function(index, td) {
            var val = $(td).text();
            try {
                val = aesUtils.decryptECB(val, encryptionKey);
                if (!isNull(val)) {
                    $(td).text(val);
                }
            } catch (e) {
            }
        });
    }
    function disabledEncryptPageText() {
        $("tr[name='node']").each(function(index, tr) {
            $(tr).find("td").prop("contenteditable", false);
        });
    }
</script>
</body>
</html>