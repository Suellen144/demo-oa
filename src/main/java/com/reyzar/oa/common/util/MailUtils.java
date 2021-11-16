package com.reyzar.oa.common.util;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.PostConstruct;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;

/** 
* @ClassName: MailUtils 
* @Description: 邮件公共类
* @author Lin 
* @date 2016年11月23日 下午4:32:16 
*  
*/
@Component
public class MailUtils {
	
	private final static Logger logger = Logger.getLogger(MailUtils.class);
	
	public final static RecipientType TO = RecipientType.TO; // 发送
	public final static RecipientType CC = RecipientType.CC; // 抄送
	public final static RecipientType BCC = RecipientType.BCC; // 暗送
	
	public static int sendBase = 15; // 发送基数，一次性最多发送给多少个收件人
	public static int retry = 3; // 发送失败重试的次数
	public static long timeout = 20 * 1000; // 邮件发送超时标识

	private static String smtpHostText;
	private static String accountText;
	private static String passwordText;
	private static String fromText;
	
	private static Session mailSession;
	private static InternetAddress from;
	
	@Value("${smtpHost}")
	private void setSmtpHost(String smtpHost) {
		MailUtils.smtpHostText = smtpHost;
	}
	@Value("${mailAccount}")
	private void setAccount(String account) {
		MailUtils.accountText = account;
	}
	@Value("${mailPassword}")
	private void setPassword(String password) {
		MailUtils.passwordText = password;
	}
	@Value("${mailFrom}")
	private void setFrom(String from) {
		MailUtils.fromText = from;
	}
	
	@Value("${ckeditor.file.root}")
	private String rootPath;
	private static String filePath;
	
	@Value("${ckeditor.file.path}")
	private String filePathForLinux;
	private String filePathForWindows = System.getProperty("oa.webroot") + "/upload/ckeditor";
	
	@PostConstruct
	private void initSession() throws UnsupportedEncodingException {
		// 构造邮箱服务器相关信息
		Properties props = new Properties();
		props.put("mail.smtp.host", MailUtils.smtpHostText);
		props.put("mail.smtp.starttls.enable", "true"); // 使用 STARTTLS安全连接
		props.put("mail.smtp.auth", "true"); // 使用验证
		props.put("mail.stmp.timeout", timeout); // 设置超时时间
		
		// 设置会话
		Authenticator authen = new CustomMailAuthenticator(MailUtils.accountText, MailUtils.passwordText);
		mailSession = Session.getDefaultInstance(props, authen); // 获取单例Session
		from = new InternetAddress(accountText, MimeUtility.encodeText(fromText));
		
		
		
		
		// 判断操作系统平台
		if(System.getProperty("os.name").toLowerCase().indexOf("windows") > -1) {
			filePath = filePathForWindows;
		} else {
			filePath = filePathForLinux;
		}
	}

	/**
	* @Title: sendTextMail
	* @Description: 发送普通文本格式的邮件
	* @param recipientsList 收件人列表
	* @param subject 邮件主题
	* @param content 邮件内容
	* @return void
	* @throws
	 */
	public static boolean sendTextMail(List<String> recipientsList, String subject, String content) {
		return sendTextMail(recipientsList, subject, content, MailUtils.TO);
	}
	
	/**
	* @Title: sendTextMail
	* @Description: 以指定发送方式发送普通文本格式的邮件
	* @param recipientsList 收件人列表
	* @param subject 邮件主题
	* @param content 邮件内容
	* @param recipientType 发送邮件的方式，有发送、抄送、暗送 3 种
	* @return void
	* @throws
	 */
	public static boolean sendTextMail(List<String> recipientsList, String subject, String content, RecipientType recipientType) {
		return sendMail(recipientsList, subject, content, recipientType, "text");
	}
	
	/**
	 * 
	* @Title: sendHtmlMail
	* @Description: 发送HTML格式的邮件
	* @param recipientsList 收件人列表
	* @param subject 邮件主题
	* @param content 邮件内容
	* @return void
	* @throws
	 */
	public static boolean sendHtmlMail(List<String> recipientsList, String subject, String content) {
		return sendHtmlMail(recipientsList, subject, content, TO);
	}

	/**
	 * 
	* @Title: sendHtmlMail
	* @Description: 以指定发送方式发送HTML格式的邮件
	* @param recipientsList 收件人列表
	* @param subject 邮件主题
	* @param content 邮件内容
	* @return void
	* @throws
	 */
	public static boolean sendHtmlMail(List<String> recipientsList, String subject, String content, RecipientType recipientType) {
		return sendMail(recipientsList, subject, content, recipientType, "html");
	}
	
	/**
	 * 
	* @Title: sendMail
	* @Description: 以线程方式发送邮件
	* @param recipientsList 收件人列表
	* @param subject 邮件主题
	* @param content 邮件内容
	* @param mailType 邮件类型：文本或HTML邮件
	* @return void
	* @throws
	 */
	@SuppressWarnings("rawtypes")
	private static boolean sendMail(List<String> recipientsList, String subject, String content, RecipientType recipientType, String mailType) {
		boolean result = false;
		
		ExecutorService fixedThreadPool = Executors.newFixedThreadPool(sendBase); // 最多有 sendBase 个线程进行发送邮件
		try {
			if(recipientsList == null || recipientsList.size() <= 0) {
				throw new BusinessException("邮件发送失败，邮件收件人列表为空！");
			}
			
			List<Future> futureList = Lists.newArrayList();

			MimeMultipart htmlContent = null;
			if( "html".equals(mailType) ) {
				htmlContent = createContent(content); // 将HTML内容里的图片换成附件形式
			}
			
			int index = 0;
			Date date = new Date();
			long id = date.getTime();
			for(String recipient : recipientsList) {
				// 设置邮件Bean
				MailBean mailBean = new MailBean();
				mailBean.setId(id);
				mailBean.setSendDate(date);
				mailBean.setRecipient(recipient);
				mailBean.setMailType(mailType);
				mailBean.setRecipientType(recipientType);
				mailBean.setSubject(subject);
				
				if( htmlContent != null ) {
					mailBean.setHtmlContent(htmlContent);
				} else {
					mailBean.setTextContent(content);
				}
				
				if( ++index % sendBase == 0 ) {
					try {
						TimeUnit.MINUTES.sleep(1); // 发完 sendBase 个邮件后，休眠 1 分钟再发送
					} catch (InterruptedException e) {}
				}
				
				SendMailThread st = new SendMailThread(mailBean);
				futureList.add(fixedThreadPool.submit(st)); // 调用邮件线程进行邮件发送
			}
			fixedThreadPool.shutdown();
			
			for(Future future : futureList) {
				try {
					CrudResultDTO execRes = (CrudResultDTO) future.get(timeout, TimeUnit.MILLISECONDS);
					logger.info(execRes.getResult());
					if( execRes.getCode() == CrudResultDTO.SUCCESS ) {
						result = true; // 一个邮件发送成功则标识为成功！
					}
				} catch (TimeoutException e) {
					logger.error("发送邮件超时！");
				}
			}
		} catch(Exception e) {
			result = false;
			logger.error(e.getMessage());
		} finally {
			fixedThreadPool.shutdown();
		}
		
		return result;
	}
	
	// 将HTML内容中的IMG图片改为附件形式，这样允许在邮箱中看到有图片的邮件
	private static MimeMultipart createContent(String content) {
		// 用于组合文本和图片，"related"型的MimeMultipart对象  
        MimeMultipart contentMulti = new MimeMultipart("related");  
		
		try {
	        Pattern pattern = Pattern.compile("(<img[^<]*src=\"[^<]*\"[^<]*>)");
			Pattern srcPattern = Pattern.compile("src=\"([^\"]*?)\"");
			Matcher matcher = pattern.matcher(content);
			
			List<MimeBodyPart> imgBodyPartList = Lists.newArrayList();
			StringBuffer sb = new StringBuffer();
			while( matcher.find() ) {
				String img = matcher.group(1);
				if( img.indexOf("ckeditor/upload/ckeditor/") > -1 ) { // 由ckeditor编辑器上传的图片才做替换
					Matcher srcMatcher = srcPattern.matcher(img);
					if( srcMatcher.find() ) {
						String src = srcMatcher.group(1);
						String[] srcSplit = src.split("/");
						
						String imgName = "cid:" + srcSplit[srcSplit.length-1];
						img = img.replaceAll("src=\"([^\"]*?)\"", "src=\""+imgName+"\"");
						matcher.appendReplacement(sb, img);
						
						String imgPath = filePath+"/"+srcSplit[srcSplit.length-2]+ "/"+srcSplit[srcSplit.length-1];
						File imgFile = new File(imgPath);
						if( imgFile.exists() ) {
							// 正文的图片部分  
							MimeBodyPart imgBodyPart = new MimeBodyPart();  
							FileDataSource fds = new FileDataSource(filePath+"/"+srcSplit[srcSplit.length-2]+"/"+srcSplit[srcSplit.length-1]);  
							imgBodyPart.setDataHandler(new DataHandler(fds));
							imgBodyPart.setContentID(srcSplit[srcSplit.length-1]);
							imgBodyPartList.add(imgBodyPart);
						}
					}
				}
			}
			
			// 正文的文本部分  
	        MimeBodyPart textBody = new MimeBodyPart();  
			if( sb.length() > 0 ) {
				matcher.appendTail(sb);
				textBody.setContent(sb.toString(), "text/html; charset=utf-8");  
			} else {
				textBody.setContent(content, "text/html; charset=utf-8");
			}
		
			// 先添加正文内容，后添加附件
			contentMulti.addBodyPart(textBody);
			for(MimeBodyPart imgBodyPart : imgBodyPartList) {
				contentMulti.addBodyPart(imgBodyPart);
			}
		} catch(Exception e) {
			logger.error("将HTML邮件内容中的图片转换为附件时发生异常！异常信息：" + e.getMessage());
			throw new BusinessException(e);
		}
		
		return contentMulti;
	}
	
	
	
	
	
	
	// 邮件发送线程
	static class SendMailThread implements Callable<CrudResultDTO> {
		private CrudResultDTO result;
		private MailBean mailBean;
		
		public SendMailThread(MailBean mailBean) {
			this.mailBean = mailBean;
		}

		@Override
		public CrudResultDTO call() {
			String resText = "邮件ID["+mailBean.getId()+"]---->发送邮件... 接收帐号["+mailBean.getRecipient()+"]！";
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, resText + "邮件发送成功！");
			
			for(int index=0; index < retry; index++) {
				try {
					// 设置收件人
					InternetAddress address =new InternetAddress(mailBean.getRecipient());
					// 设置消息
					MimeMessage message = new MimeMessage(MailUtils.mailSession);
					message.setFrom(from);
					
					// 设置邮件内容信息
					if( "html".equals(mailBean.getMailType()) ) {
						message.setContent(mailBean.getHtmlContent(), "text/html; charset=utf-8");
					} else {
						message.setText(mailBean.getTextContent());
					}
					
					message.setSentDate(mailBean.getSendDate());
					message.setSubject(mailBean.getSubject());
					message.setRecipient(mailBean.getRecipientType(), address);
					Transport.send(message);
					
					break ; // 发送成功则跳出循环，否则重试！
				} catch(AddressException e) {
					result.setCode(CrudResultDTO.EXCEPTION);
					result.setResult(resText + "邮件发送失败！失败信息：" + e.getMessage());
				} catch (MessagingException e) {
					result.setCode(CrudResultDTO.EXCEPTION);
					result.setResult(resText + "邮件发送失败！失败信息：" + e.getMessage());
				}
			}
			
			return result;
		}
		
	}
	
	static class MailBean {
		private Long id;
		private String recipient; // 邮件接收人
		private String subject; // 邮件主题
		private String textContent; // 文本邮件内容
		private MimeMultipart htmlContent; // HTML邮件内容
		private Date sendDate; // 发送时间
		private RecipientType recipientType; // 邮件发送方式
		private String mailType; // 邮件类型：文本或HTML类型
		
		public Long getId() {
			return id;
		}
		public void setId(Long id) {
			this.id = id;
		}
		public String getRecipient() {
			return recipient;
		}
		public void setRecipient(String recipient) {
			this.recipient = recipient;
		}
		public String getSubject() {
			return subject;
		}
		public void setSubject(String subject) {
			this.subject = subject;
		}
		public String getTextContent() {
			return textContent;
		}
		public void setTextContent(String textContent) {
			this.textContent = textContent;
		}
		public MimeMultipart getHtmlContent() {
			return htmlContent;
		}
		public void setHtmlContent(MimeMultipart htmlContent) {
			this.htmlContent = htmlContent;
		}
		public Date getSendDate() {
			return sendDate;
		}
		public void setSendDate(Date sendDate) {
			this.sendDate = sendDate;
		}
		public RecipientType getRecipientType() {
			return recipientType;
		}
		public void setRecipientType(RecipientType recipientType) {
			this.recipientType = recipientType;
		}
		public String getMailType() {
			return mailType;
		}
		public void setMailType(String mailType) {
			this.mailType = mailType;
		}
	}
	
	
	class CustomMailAuthenticator extends Authenticator {
		
		private String account;
		private String password;
		
		public CustomMailAuthenticator(String account, String password) {
			this.account = account;
			this.password = password;
		}
		
		@Override
		protected PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication(account, password);
		}
	}
}