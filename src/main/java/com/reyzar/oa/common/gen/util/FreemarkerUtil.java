package com.reyzar.oa.common.gen.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import com.reyzar.oa.common.gen.GenerateEntity;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

public class FreemarkerUtil {

	private static String templatePath = GenerateEntity.class.getResource("/").getPath()+"templates";
	private static Configuration cfg;
	static {
		try {
			cfg = new Configuration();
			cfg.setDirectoryForTemplateLoading(new File(templatePath));
			cfg.setObjectWrapper(new DefaultObjectWrapper());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void generateFile(String templateName, Object templateData, String targetFile) {
		try {
			Template template = cfg.getTemplate(templateName);
			File outFile = new File(GenerateEntity.class.getResource("/").getPath());
			outFile = new File(outFile.getParentFile().getParentFile(), "src/main/"+targetFile);
			FileWriter out = new FileWriter(outFile);
//			Writer out = new OutputStreamWriter(System.out); 

			template.process(templateData, out);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
