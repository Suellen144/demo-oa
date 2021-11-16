package com.reyzar.oa.common.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jxls.common.Context;
import org.jxls.util.JxlsHelper;

import com.reyzar.oa.common.exception.BusinessException;

public class ExcelUtil {
 
    protected static final String dateTimeFmtPattern = "yyyy-MM-dd HH:mm:ss";
 
    protected static final String dateFmtPattern = "yyyy-MM-dd";
 
    protected static final DataFormatter formatter = new DataFormatter();
 
    /**
     * 读取excel文件（同时支持2003和2007格式）
     *
     * @param fileName
     *            文件名，绝对路径
     * @return list中的map的key是列的序号
     * @throws Exception
     *             io异常等
     */
    public static List<Map<String, Object>> readExcel(String fileName) throws Exception {
        FileInputStream fis = null;
        Workbook wb = null;
        List<Map<String, Object>> list = null;
        try {
            String extension = FilenameUtils.getExtension(fileName);
 
            fis = new FileInputStream(fileName);
            list = read(fis, extension);
 
            return list;
 
        } finally {
            if (null != wb) {
                wb.close();
            }
 
            if (null != fis) {
                fis.close();
            }
        }
 
    }
 
    /**
     * 读取excel文件（同时支持2003和2007格式）
     *
     * @param fis
     *            文件输入流
     * @param extension
     *            文件名扩展名: xls 或 xlsx 不区分大小写
     * @return list中的map的key是列的序号
     * @throws Exception
     *             io异常等
     */
    public static List<Map<String, Object>> read(FileInputStream fis, String extension) throws Exception {
 
        Workbook wb = null;
        List<Map<String, Object>> list = null;
        try {
 
            if ("xls".equalsIgnoreCase(extension)) {
                wb = new HSSFWorkbook(fis);
            } else if ("xlsx".equalsIgnoreCase(extension)) {
                wb = new XSSFWorkbook(fis);
            } else {
                throw new Exception("file is not office excel");
            }
 
            list = readWorkbook(wb);
 
            return list;
 
        } finally {
            if (null != wb) {
                wb.close();
            }
        }
 
    }
 
    protected static List<Map<String, Object>> readWorkbook(Workbook wb) throws Exception {
        List<Map<String, Object>> list = new LinkedList<Map<String, Object>>();
        //遍历所有sheet
        for (int k = 0; k < wb.getNumberOfSheets(); k++) {
            Sheet sheet = wb.getSheetAt(k);
            int rows = sheet.getPhysicalNumberOfRows();
 
            for (int r = 1; r < rows; r++) {
                Row row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }
                Map<String, Object> map = new HashMap<String, Object>();
                int cells = row.getPhysicalNumberOfCells();
 
                for (int c = 0; c < cells; c++) {
                    Cell cell = row.getCell(c);
                    if (cell == null) {
                        continue;
                    }
                    String value = getCellValue(cell);
                    map.put(String.valueOf(cell.getColumnIndex() + 1), value);
                }
                list.add(map);
            }
 
        }
 
        return list;
    }
 
    protected static String getCellValue(Cell cell) {
        String value = null;
 
        switch (cell.getCellType()) {
            case Cell.CELL_TYPE_FORMULA: // 公式
            case Cell.CELL_TYPE_NUMERIC: // 数字
 
                double doubleVal = cell.getNumericCellValue();
                short format = cell.getCellStyle().getDataFormat();
                @SuppressWarnings("unused")
				String formatString = cell.getCellStyle().getDataFormatString();
 
                if (format == 14 || format == 31 || format == 57 || format == 58 || (format >= 176 && format <= 183)) {
                    // 日期
                    Date date = DateUtil.getJavaDate(doubleVal);
                    value = formatDate(date, dateFmtPattern);
                } else if (format == 20 || format == 32 || (format >= 184 && format <= 187)) {
                    // 时间
                    Date date = DateUtil.getJavaDate(doubleVal);
                    value = formatDate(date, "HH:mm");
                } else {
                	BigDecimal bd = new BigDecimal(doubleVal);
                    value = bd.toPlainString();
                }
 
                break;
            case Cell.CELL_TYPE_STRING: // 字符串
                value = cell.getStringCellValue();
 
                break;
            case Cell.CELL_TYPE_BLANK: // 空白
                value = "";
                break;
            case Cell.CELL_TYPE_BOOLEAN: // Boolean
                value = String.valueOf(cell.getBooleanCellValue());
                break;
            case Cell.CELL_TYPE_ERROR: // Error，返回错误码
                value = String.valueOf(cell.getErrorCellValue());
                break;
            default:
                value = "";
                break;
        }
        return value;
    }
 
	private static String formatDate(Date d, String sdf) {
        String value = null;
        try {
	        SimpleDateFormat df = new SimpleDateFormat(sdf);
	        value = df.format(d);
        } catch(Exception e) {}
        
        return value;
    }
 
    /**
    * @Title: export
    * @Description: 导出Excel
      @param templateName 模板文件名
      @param out 输出到目的的流
      @param context 存放Excel变量数据的容器，jxls根据Context的数据渲染模板
    * @return void
     */
    public static void export(String templateName, OutputStream out, Context context) {
    	if( templateName == null || "".equals(templateName.trim()) ) {
    		throw new BusinessException("Excel模板名不能为空！");
    	}
    	
    	InputStream in = ExcelUtil.class.getClassLoader().getResourceAsStream("excelTemplate/" + templateName);
    	try {
			JxlsHelper.getInstance().processTemplate(in, out, context);
		} catch (IOException e) {
			throw new BusinessException(e);
		}
    }
}