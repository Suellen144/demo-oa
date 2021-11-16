package com.reyzar.oa.common.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;


public class FileUtil {
	
	
	private final static String rootPath = System.getProperty("oa.webroot"); // Web应用物理路径
	private final static String linuxPath = "/opt/data/oa_upload" ;

	/**
	 * 删除目录
	 * @param directory
	 * @throws IOException
	 */
	public static void deleteDirectory(File directory) throws IOException {
        if (!directory.exists()) {
            return;
        }
        cleanDirectory(directory);
        if (!directory.delete()) {
            String message =
                "无法删除目录" + directory + "。";
            throw new IOException(message);
        }
    }
	
	/**
	 * 清空目录文件
	 * @param directory
	 * @throws IOException
	 */
	public static void cleanDirectory(File directory) throws IOException {
        if (!directory.exists()) {
            String message = directory + " 文件不存在";
            throw new IllegalArgumentException(message);
        }

        if (!directory.isDirectory()) {
            String message = directory + " 文件不是目录";
            throw new IllegalArgumentException(message);
        }

        File[] files = directory.listFiles();
        if (files == null) {  // null if security restricted
            throw new IOException("无法显示目录内容 " + directory);
        }

        IOException exception = null;
        for (int i = 0; i < files.length; i++) {
            File file = files[i];
            try {
                forceDelete(file);
            } catch (IOException ioe) {
                exception = ioe;
            }
        }

        if (null != exception) {
            throw exception;
        }
	}
	
	/**
	 * 删除文件
	 * @param file
	 * @throws IOException
	 */
	public static void forceDelete(File file) throws IOException {
        if (file.isDirectory()) {
            deleteDirectory(file);
        } else {
            boolean filePresent = file.exists();
            if (!file.delete()) {
                if (!filePresent){
                    throw new FileNotFoundException("File does not exist: " + file);
                }
                String message =
                    "Unable to delete file: " + file;
                throw new IOException(message);
            }
        }
    }
	
	/**
	 * 通过文件相对路径删除文件
	 * @param filePath
	 * @throws IOException
	 * */
	public static void forceDelete(String filePath) throws IOException {
		if(System.getProperty("os.name").toLowerCase().indexOf("windows") > -1) {
			   File file = new File(rootPath, filePath);
		       forceDelete(file);
		} else {
			   File file = new File(linuxPath, filePath);
		       forceDelete(file);
		}

    }
	
	
	/**获取当前项目绝对路径*/
	public static String getProjectPath() throws Exception{
		File directory = new File("");//设定为当前文件夹 
		//directory.getCanonicalPath();//获取标准的路径 
		return directory.getAbsolutePath();////获取绝对路径 
	}
	
	/**复制文件*/
	public static void copyAndClose(InputStream in,OutputStream out) throws IOException {
        try {
        	 byte[] buf = new byte[1024];
             int n = 0;
             while((n = in.read(buf)) != -1) {
                 out.write(buf,0,n);
             }
        }finally {
        	 try { if(in != null) in.close();}catch(Exception e){};
             try { if(out != null) out.close();}catch(Exception e){};
        }
    }
	
	/**根据文件地址生成文件*/
	public static File makeFileByPath(String filePath){
		try {
			File file = new File(filePath);
			if(!file.getParentFile().exists())//如果文件的目录不存在，创建目录
	            file.getParentFile().mkdirs();
			file.createNewFile();//创建文件
			return file;
		} catch (Exception e) {
			return null;
		}
	}
	
	/**获取文件后缀名*/
	public static String getPrefixOfFile(String fileName){
		if(fileName.contains(".")){
			return fileName.substring(fileName.lastIndexOf(".")+1);
		}
		return "";
	}
	
}
