package com.reyzar.oa.common.util;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Workbook;

/**
 * <pre>
 * ExportexcelUtil.java 公用导出excel文件工具类
 * </pre>
 * 
 * @author lwy
 * @version 1.00.00
 * <pre>
 * 添加时间 2018-7-17
 * 
 * 修改记录
 * 修改后版本:     
 * 修改人：  
 * 修改日期:     
 * 修改内容:
 * </pre>
 */
public class ExportexcelUtil {
	private static final Logger logger = Logger
			.getLogger(ExportexcelUtil.class);

	/**
	 * 导出list数据至excel文件中
	 * 
	 * ExportexcelUtil.expRptDataToExcel(response, this.getClass()
	 *					.getResource(RESULTEXCEL), list, "数据列表");
	 * 
	 * @param response
	 * @param resource
	 * @param list
	 * @param outfileName
	 * @throws IOException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 */
	public static void expRptDataToExcel(HttpServletResponse response,
			URL resource, List<?> list, String outfileName) throws IOException,
			IllegalAccessException, InvocationTargetException,
			NoSuchMethodException {
		OutputStream outputStream = response.getOutputStream();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("name", new String(outfileName.getBytes("GB2312"),
				"ISO-8859-1"));
		response.setHeader("Content-Disposition:", "attachment; filename="
				+ new String(outfileName.getBytes("gb2312"), "ISO8859_1")
				+ ".xls");
		response.setCharacterEncoding("gbk");
		InputStream fileIn = null;
		HSSFWorkbook wb = null;
		try {
			fileIn = resource.openStream();
			POIFSFileSystem fs = new POIFSFileSystem(fileIn);
			wb = new HSSFWorkbook(fs);
			HSSFCellStyle setBorder = wb.createCellStyle();
			setBorder.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderTop(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderRight(HSSFCellStyle.BORDER_THIN);

			HSSFSheet sheet = wb.getSheetAt(0);
			int beginX = 0;
			int beginY = 0;
			for (int i = sheet.getLastRowNum(); i > 0; i--) {
				HSSFRow row = sheet.getRow(i);
				if (row != null) {
					for (int j = 0; j < 100; j++) {
						HSSFCell cell = row.getCell((short) j);
					//	if (cell != null) {
							//if (i == 0 && j == 0) {// 第一行第一列报表表头加上时间段
							//	String cellValue = cell.getStringCellValue();
								// if (!date.isEmpty()) {
								// cellValue += "(" + date + ")";
								// }
							//	cell.setCellValue(cellValue);
						//	}
						try {
							if (cell != null) {
								cell.setCellType(1);
								if (cell.getStringCellValue().indexOf("$") != -1
										|| cell.getStringCellValue().indexOf(
												"#") != -1) {
									beginX = i;
									beginY = j;
									break;
								}
							}
						} catch (Exception e) {
							logger.info("读取单元格出错，跳过处理", e);
							break;
						}	
					//	}
					}
				}
			}

			HSSFRow modlRow = sheet.getRow(beginX);
			int endY = 0;
			for (int i = beginY; i <= 1000; i++) {
				HSSFCell modlCell = modlRow.getCell((short) i);
				if (modlCell == null) {
					endY = i;
					break;
				}
			}
			int rowIndex = 0;
			if (list != null && list.size() > 0) {
				for (Object obj : list) {
					int index = 0;
					HSSFRow newRow = sheet.createRow(beginX + rowIndex);
					for (int i = beginY; i < endY; i++) {
						// if (index > (endY - beginX))
						// break;
						HSSFCell newCell = newRow.createCell((short) i);
						String modlCellV = modlRow.getCell(
								(short) (beginY + index)).getStringCellValue();
						/** 当为对象 */
						if (modlCellV.indexOf("$") != -1) {
							modlCellV = modlCellV.replaceAll("\\$", "");
							Object o1 = null;
							boolean bDate = false;
							if ("java.util.HashMap".equals(obj.getClass()
									.getName())) {
								o1 = ((java.util.HashMap) obj).get(modlCellV);
							} else {
								o1 = BeanUtils.getProperty(obj, modlCellV);
								try {
									String cellType = obj.getClass()
											.getDeclaredField(modlCellV)
											.getType().toString();
									if (cellType.contains("java.lang.Double")||cellType.contains("double")) {
										o1 = fmtMicrometer(o1.toString());
									}else if (cellType.contains("java.lang.Float")) {
										o1 = fmtMicrometer(o1.toString());
									}
									bDate = cellType.contains("java.util.Date");
								} catch (Exception e) {
								}
							}
							if (o1 != null) {
								newCell.setCellValue(o1.toString());
							}

							try {
								// 修改时间类型
								if (bDate) {
									PropertyDescriptor oldpd = new PropertyDescriptor(
											modlCellV, obj.getClass());
									Method getMthod4old = oldpd.getReadMethod();
									o1 = getMthod4old.invoke(obj);
									SimpleDateFormat f = new SimpleDateFormat(
											"yyyy-MM-dd");
									SimpleDateFormat hms = new SimpleDateFormat(
											"HH:mm:ss");
									if (o1 != null
											&& (o1.getClass().getName()
													.equals("java.util.Date") || o1
													.getClass()
													.getName()
													.equals("java.sql.Timestamp"))) {
										String strTime = hms.format(o1);
										if (!strTime.isEmpty()
												&& !strTime.equals("00:00:00")) {
											newCell.setCellValue(f.format(o1)
													+ " " + strTime);
										} else
											newCell.setCellValue(f.format(o1));
									}
								}
							} catch (Exception e) {
								logger.error("", e);
							}
						} else if (modlCellV.indexOf("#") != -1) {
							modlCellV = modlCellV.replaceAll("\\#", "");
							Object o = (((Object[]) obj)[new Integer(modlCellV)]) != null ? (((Object[]) obj)[new Integer(
									modlCellV)]) : "";
							newCell.setCellValue(o.toString());
						}
						newCell.setCellStyle(setBorder);
						index++;
					}
					rowIndex++;
				}
			} else {
				sheet.removeRow(modlRow);
			}

			wb.write(outputStream);
			outputStream.flush();
		} finally {
			if (outputStream != null) {
				outputStream.close();
			}
			if (fileIn != null)
				fileIn.close();
		}
	}
	

	/**
	 * @param response
	 * @param resource
	 * @param list        导出的数据集合
	 * @param outfileName 输出的文件名
	 * @param map  自定义参数
	 * @throws IOException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 */
	public static void expRptDataToExcel2(HttpServletResponse response,
			URL resource, List<?> list, String outfileName,Map<String,Object> map) throws IOException,
	IllegalAccessException, InvocationTargetException,
	NoSuchMethodException {
		OutputStream outputStream = response.getOutputStream();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("name", new String(outfileName.getBytes("GB2312"),
				"ISO-8859-1"));
		response.setHeader("Content-Disposition:", "attachment; filename="
				+ new String(outfileName.getBytes("gb2312"), "ISO8859_1")
				+ ".xls");
		response.setCharacterEncoding("gbk");
		InputStream fileIn = null;
		HSSFWorkbook wb = null;
		try {
			fileIn = resource.openStream();
			POIFSFileSystem fs = new POIFSFileSystem(fileIn);
			wb = new HSSFWorkbook(fs);
			HSSFCellStyle setBorder = wb.createCellStyle();
			setBorder.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderTop(HSSFCellStyle.BORDER_THIN);
			setBorder.setBorderRight(HSSFCellStyle.BORDER_THIN);
			
			HSSFSheet sheet = wb.getSheetAt(0);
			int beginX = 0;
			int beginY = 0;
			
			//标题设置
			HSSFRow row1 = sheet.getRow(0);
			HSSFCell cell1 = row1.getCell(0);
			cell1.setCellValue("睿哲科技股份有限公司"+map.get("year")+"年"+map.get("calcMonth")+"月考勤统计");
			
			HSSFRow row2 = sheet.getRow(1);
			HSSFCell cell2 = row2.getCell(0);
			cell2.setCellValue("考勤统计时段："+map.get("beginDate")+"至"+map.get("endDate"));
			HSSFCell cell22 = row2.getCell(21);
			cell22.setCellValue("满勤天数："+map.get("saleDays"));
			
			HSSFRow row3 = sheet.getRow(2);
			HSSFCell cell3 = row3.getCell(16);
			cell3.setCellValue(map.get("lastYear")+"年累休年假");
			
			HSSFCell cell33 = row3.getCell(17);
			cell33.setCellValue(map.get("year")+"年累休年假");
			
			for (int i = sheet.getLastRowNum(); i > 0; i--) {
				HSSFRow row = sheet.getRow(i);
				if (row != null) {
					for (int j = 0; j < 100; j++) {
						HSSFCell cell = row.getCell((short) j);
						//	if (cell != null) {
						//if (i == 0 && j == 0) {// 第一行第一列报表表头加上时间段
						//	String cellValue = cell.getStringCellValue();
						// if (!date.isEmpty()) {
						// cellValue += "(" + date + ")";
						// }
						//	cell.setCellValue(cellValue);
						//	}
						try {
							if (cell != null) {
								cell.setCellType(1);
								if (cell.getStringCellValue().indexOf("$") != -1
										|| cell.getStringCellValue().indexOf(
												"#") != -1) {
									beginX = i;
									beginY = j;
									break;
								}
							}
						} catch (Exception e) {
							logger.info("读取单元格出错，跳过处理", e);
							break;
						}	
						//	}
					}
				}
			}
			
			HSSFRow modlRow = sheet.getRow(beginX);
			int endY = 0;
			for (int i = beginY; i <= 1000; i++) {
				HSSFCell modlCell = modlRow.getCell((short) i);
				if (modlCell == null) {
					endY = i;
					break;
				}
			}
			int rowIndex = 0;
			if (list != null && list.size() > 0) {
				for (Object obj : list) {
					int index = 0;
					HSSFRow newRow = sheet.createRow(beginX + rowIndex);
					for (int i = beginY; i < endY; i++) {
						// if (index > (endY - beginX))
						// break;
						HSSFCell newCell = newRow.createCell((short) i);
						String modlCellV = modlRow.getCell(
								(short) (beginY + index)).getStringCellValue();
						/** 当为对象 */
						if (modlCellV.indexOf("$") != -1) {
							modlCellV = modlCellV.replaceAll("\\$", "");
							Object o1 = null;
							boolean bDate = false;
							if ("java.util.HashMap".equals(obj.getClass()
									.getName())) {
								o1 = ((java.util.HashMap) obj).get(modlCellV);
							} else {
								o1 = BeanUtils.getProperty(obj, modlCellV);
								try {
									String cellType = obj.getClass()
											.getDeclaredField(modlCellV)
											.getType().toString();
									if (cellType.contains("java.lang.Double")||cellType.contains("double")) {
										o1 = fmtMicrometer(o1.toString());
									}else if (cellType.contains("java.lang.Float")) {
										o1 = fmtMicrometer(o1.toString());
									}
									bDate = cellType.contains("java.util.Date");
								} catch (Exception e) {
								}
							}
							if (o1 != null) {
								newCell.setCellValue(o1.toString());
							}
							
							try {
								// 修改时间类型
								if (bDate) {
									PropertyDescriptor oldpd = new PropertyDescriptor(
											modlCellV, obj.getClass());
									Method getMthod4old = oldpd.getReadMethod();
									o1 = getMthod4old.invoke(obj);
									SimpleDateFormat f = new SimpleDateFormat(
											"yyyy-MM-dd");
									SimpleDateFormat hms = new SimpleDateFormat(
											"HH:mm:ss");
									if (o1 != null
											&& (o1.getClass().getName()
													.equals("java.util.Date") || o1
													.getClass()
													.getName()
													.equals("java.sql.Timestamp"))) {
										String strTime = hms.format(o1);
										if (!strTime.isEmpty()
												&& !strTime.equals("00:00:00")) {
											newCell.setCellValue(f.format(o1)
													+ " " + strTime);
										} else
											newCell.setCellValue(f.format(o1));
									}
								}
							} catch (Exception e) {
								logger.error("", e);
							}
						} else if (modlCellV.indexOf("#") != -1) {
							modlCellV = modlCellV.replaceAll("\\#", "");
							Object o = (((Object[]) obj)[new Integer(modlCellV)]) != null ? (((Object[]) obj)[new Integer(
									modlCellV)]) : "";
							newCell.setCellValue(o.toString());
						}
						newCell.setCellStyle(setBorder);
						index++;
					}
					rowIndex++;
				}
			} else {
				sheet.removeRow(modlRow);
			}
			
			wb.write(outputStream);
			outputStream.flush();
		} finally {
			if (outputStream != null) {
				outputStream.close();
			}
			if (fileIn != null)
				fileIn.close();
		}
	}

	/**
	 * 格式化数字为千分位显示
	 * 
	 * @param text
	 *            String 要格式化的数字的字符串
	 * @return String
	 */
	public static String fmtMicrometer(String text) {
		DecimalFormat df = null;
		if (text == null) {
			return "";
		}
		if (text.indexOf(".") > 0) {
			if (text.length() - text.indexOf(".") - 1 == 0) {
				df = new DecimalFormat("######0.");
			} else if (text.length() - text.indexOf(".") - 1 == 1) {
				df = new DecimalFormat("######0.0");
			} else {
				df = new DecimalFormat("######0.00");
			}
		} else {
			df = new DecimalFormat("######0");
		}
		double number = 0.0;
		try {
			number = Double.parseDouble(text);
		} catch (Exception e) {
			number = 0.0;
		}
		return df.format(number);
	}
	
	/**
	 * 创建单元格样式
	 * @param workbook 工作簿
	 * @param fontSize 字体大小
	 * @return 单元格样式
	 */
	public static CellStyle createCellStyle(Workbook workbook, short fontSize){
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);//水平居中
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直居中
		//1.1.1、创建头标题字体
		Font font = workbook.createFont();
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//字体加粗
		font.setFontHeightInPoints(fontSize);
		//在样式中加载字体
		style.setFont(font);
		return style;
	}

}
