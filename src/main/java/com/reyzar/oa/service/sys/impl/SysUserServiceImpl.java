package com.reyzar.oa.service.sys.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.dao.*;
import com.reyzar.oa.domain.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.encrypt.MD5Utils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.shiro.CustomRealm;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.service.ad.IAdLeaveService;
import com.reyzar.oa.service.ad.IAdPositionService;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.ad.IAdTravelService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

import javax.mail.Message;

@Service
@Transactional
public class SysUserServiceImpl implements ISysUserService {

	@Autowired
	private IAdLeaveService leaveService;
	@Autowired
	private IAdTravelService travelService;
	@Autowired
	private ISysUserDao userDao;
	@Autowired
	private IUserRoleDao userRoleDao;
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private IAdMeetingDao meetingDao;
	@Autowired
	private IAdRecordDao recordDao;
	@Autowired
	private IAdRecordService recordService;
	@Lazy
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private IAdPositionService positionService;
	@Autowired
	private CustomRealm realm;
	@Value("${user.password}")
	private String userPassword;
	
	@Autowired
	private IAdRecordDeptHistoryDao recordDeptHistoryDao;

	@Autowired
	private IAdRecordPositionHistoryDao positionHistoryDao;
	
	@Autowired
	private IAdRecordSalaryHistoryDao salaryHistoryDao;
	
	@Override
	public Page<SysUser> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<SysUser> page = userDao.findByPage(params);
		
		return page;
	}
	
	@Override
	public Page<SysUser> findByPage2(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<SysUser> page = userDao.findByPage2(params);	
		return page;
	}
	
	@Override
	public SysUser findByAccount(String account) {
		return userDao.findByAccount(account);
	}
	
	@Override
	public SysUser findById(Integer id) {
		return userDao.findById(id);
	}
	
	@Override
	public SysUser findAllById(Integer id) {
		return userDao.findAllById(id);
	}

	@Override
	public void sendMail(SysUser user,String passwd,Integer type) {
		// 获取有可视权限部门下的人员邮箱
		List<String> recipientsList = Lists.newArrayList();
		String mail = user.getAccount()+"@reyzar.com";
		recipientsList.add(mail);
		String subject;
		String content;
		if (type.equals(1)){
			subject = "OA账号已成功创建";
			content = "<h3>"
					+"员工"+ user.getName() +"<span style=\"font-family:微软雅黑, Microsoft YaHei\">"
					+ "的OA账号已成功创建"
					+ "<br>账号为"+user.getAccount()
					+ "<br>初始密码为"+passwd
					+ "<br>请及时登陆OA进行密码修改!</br>"
					+ "</span>\r\n" + "</h3>";
		}else{
			 subject = "OA密码已重置";
			 content = "<h3>"
					+"员工"+ user.getName() +"<span style=\"font-family:微软雅黑, Microsoft YaHei\">"
					+ "的OA账号已被管理员重置"
					+ "<br>账号为"+user.getAccount()
					+ "<br>重置密码为"+passwd
					+ "<br>请及时登陆OA进行密码修改!</br>"
					+ "</span>\r\n" + "</h3>";
		}

		// 以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
		Thread thread = new Thread() {
			private List<String> recipientsList;
			private String subject;
			private String content;
			private Message.RecipientType recipientType;

			@Override
			public void run() {
				// 发送邮件
				// 以暗送的方式发送邮件
				MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType);
			}

			public Thread setParams(List<String> recipientsList, String subject, String content, Message.RecipientType recipientType) {
				this.recipientsList = recipientsList;
				this.subject = subject;
				this.content = content;
				this.recipientType = recipientType;

				return this;
			}
		}.setParams(recipientsList, subject, content, MailUtils.BCC);

		if( !"y".equals(SystemConstant.getValue("devMode")) ) {
			thread.start();
		}
	}

	/**
	 * 找出该用户所负责的用户ID
	 * @param user
	 * @return
	 */
	@Override
	public List<Integer> findIdByPrincipalId(SysUser user) {
		List<Integer> userList= userDao.findIdByPrincipalId(user.getId());
		return userList;
	}

	@Override
	public CrudResultDTO save(SysUser user, String positionId, List<Integer> roleidList, SysUser currUser) {
		
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		AdPosition position=null;
		//获取职位，从公司到职位展示
		StringBuffer positionUpName = new StringBuffer();
		List<String> positionList = new ArrayList<>();
		if(positionId != null && !"".equals(positionId.trim())) {
			String[] positionIds = positionId.split(",");
			List<Integer> pIds = new ArrayList<>();
			for (String pid : positionIds) {
				pIds.add(Integer.parseInt(pid));
			}
			for (int i = 0; i < pIds.size(); i++) {
				 position = positionService.findById(pIds.get(i));
				/*SysDept dept = deptService.findById(position.getDeptId());
				CrudResultDTO pResult = deptService.findUpDept(dept.getId());*/
				String upDeptName = /*(String) pResult.getResult()+*/position.getName(); 
				
				if (i==pIds.size()-1) {
					positionUpName.append(upDeptName);
				}else {
					positionUpName.append(upDeptName+"\r\n,");
				}
				positionList.add(upDeptName);
			}
		}
		
		try {
			if(user.getId() == null) {
				final String passwd = user.getPassword();
				user.setPassword(MD5Utils.get32Code(user.getPassword()));
				user.setCreateBy(currUser.getAccount().trim());
				user.setCreateDate(new Date());
				userDao.save(user);
				sendMail(user,passwd,1);
				
				//初始化薪酬历史表
				AdRecordSalaryHistory salaryHistory = new AdRecordSalaryHistory();
				salaryHistory.setUserId(user.getId());
				salaryHistory.setCreateBy(user.getAccount());
				salaryHistory.setCreateDate(new Date());
				salaryHistory.setStartTime(new Date());
				salaryHistoryDao.save(salaryHistory);
				
				/*AdRecord record = new AdRecord();
				record.setUserId(user.getId());
				record.setName(user.getName().replace(" ", ""));
				record.setEntrystatus(2);*/
				
				if (user.getDeptId() != null) {
					String deptName = (String) deptService.findUpDept(user.getDeptId()).getResult();
					String company=(String) deptService.findCompany(user.getDeptId()).getResult();
					String[] strs=company.split(",");
					/*record.setCompany(strs[0]);
					record.setDept(deptName);*/
					//初始化部门历史表
					AdRecordDeptHistory deptHistory = new AdRecordDeptHistory();
					deptHistory.setUserId(user.getId());
					deptHistory.setStartTime(new Date());
					deptHistory.setDept(deptName);
					deptHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
					deptHistory.setCreateDate(new Date());
					recordDeptHistoryDao.save(deptHistory);

					//将新增加市场部用户ID，添加到 市场部会议纪要的USERIDS字段中
					if(user.getDeptId().equals(3)){
						List<AdMeeting> adMeetingList=meetingDao.findByDeptId(user.getDeptId());
						for (AdMeeting adMeetingItem:adMeetingList) {
							StringBuilder userIds=new StringBuilder();
							userIds.append(adMeetingItem.getUserids());
							userIds.append(",");
							userIds.append(user.getId());
							adMeetingItem.setUserids(String.valueOf(userIds));
							StringBuilder userNames=new StringBuilder();
							userNames.append(adMeetingItem.getParticipant());
							userNames.append(",");
							userNames.append(user.getName());
							adMeetingItem.setParticipant(String.valueOf(userNames));
						}
						meetingDao.updateList(adMeetingList);
					}
				}
				//初始化职位历史表
				if (positionUpName != null && !positionUpName.toString().equals("")) {
					/*record.setPosition(positionUpName.toString());*/
					/*record.setPosition(position.getName());*/
				}
				if (positionList != null && positionList.size()>0) {
					for (String positions : positionList) {
						AdRecordPositionHistory positionHistory = new AdRecordPositionHistory();
						positionHistory.setUserId(user.getId());
						positionHistory.setStartTime(new Date());
						positionHistory.setPosition(positions);
						positionHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
						positionHistory.setCreateDate(new Date());
						positionHistoryDao.save(positionHistory);
					}
				}
				/*recordDao.save(record);*/
			
			} else {
				SysUser old = userDao.findById(user.getId());
				user.setUpdateBy(currUser.getAccount());
				user.setUpdateDate(new Date());
				BeanUtils.copyProperties(user, old);
				userDao.update(old);
				
				AdRecord record = recordService.findByUserid(user.getId());
				record.setName(user.getName().replace(" ", ""));
				if (user.getDeptId() != null) {
					String deptName = (String) deptService.findUpDept(user.getDeptId()).getResult();
					record.setDept(deptName);
					updateDeptHistory(user,user.getDeptId());//更新部门历史记录
				}
					
				if (positionUpName != null && !positionUpName.toString().equals("")) {
					record.setPosition(positionUpName.toString());
					updatePositionHistory(user,positionId);//更新职位历史表
				}
				recordDao.update(record);
			}
	
			
			// 更新用户角色
			List<Integer> newRoleidList = Lists.newArrayList();
			if(roleidList != null && roleidList.size() > 0) {
				List<Integer> oldRoleidList = userRoleDao.findRoleidByUserid(user.getId());
				Set<Integer> oldRoleidSet = Sets.newHashSet(oldRoleidList);
				
				for(Integer roleid : roleidList) {
					if(!oldRoleidSet.contains(roleid)) {
						newRoleidList.add(roleid);
					}
				}
				
			}
			
			userRoleDao.delByUseridAndNotRoleid(user.getId(), roleidList);
			if(newRoleidList.size() > 0) {
				userRoleDao.insertAll(user.getId(), newRoleidList);
			}
			
			realm.reloadAuthorizing(user.getAccount());
			
			// 更新职位
			if(positionId != null && !"".equals(positionId.trim())) {
				List<Integer> positionIdList = Lists.newArrayList();
				String[] ids = positionId.split(",");
				for(String id : ids) {
					positionIdList.add(Integer.valueOf(id));
				}
				userPositionDao.delByUserId(user.getId());
				userPositionDao.insertAll(user.getId(), positionIdList);	
			}
		} catch(Exception e) {
			e.printStackTrace();
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
		}
		
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			SysUser user = userDao.findById(id);
			user.setIsDeleted("1");
			user.setUpdateDate(new Date());
			userDao.update(user);
			userRoleDao.delByUserid(id);
			deptService.setNullByUserid(id);
			AdRecord record = recordDao.findByUserid(id);
			if(record != null) {
				record.setIsDeleted("1");
				recordDao.update(record);
			}
		} catch(Exception e) {
			e.printStackTrace();
			result = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败！");
		}
		
		return result;
	}

	@Override
	public void setNullByDeptid(Integer deptId) {
		userDao.setNullByDeptid(deptId);
	}

	@Override
	public List<SysUser> findByDeptid(Integer deptId) {
		return userDao.findByDeptid(deptId);
	}

	@Override
	public SysUser findManagerByDeptcode(String deptCode) {
		return userDao.findManagerByDeptcode(deptCode);
	}

	@Override
	public CrudResultDTO save(SysUser user,SysUser currUser) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(user.getId() == null) {
				user.setPassword(MD5Utils.get32Code(user.getPassword()));
				user.setCreateBy(currUser.getAccount());
				user.setCreateDate(new Date());
				userDao.save(user);
			} else {
				SysUser old = userDao.findById(user.getId());
//				user.setPassword(user.getPassword());
				user.setUpdateBy(currUser.getAccount());
				user.setUpdateDate(new Date());
				BeanUtils.copyProperties(user, old);
				userDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
		}
		return result;
	}

	@Override
	public CrudResultDTO modifyPassword(String account, String password) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, "密码修改失败！");
		try {
			SysUser user = userDao.findByAccount(account);
			if(user != null) {
				user.setPassword(MD5Utils.get32Code(password));
				userDao.update(user);
				result = new CrudResultDTO(CrudResultDTO.SUCCESS, "密码修改成功！");
				
				// 刷新Session中的用户信息
				realm.refreshUserInSession(account);
			}
		} catch(Exception e) {}
		
		return result;
	}
	
	
	@Override
	public CrudResultDTO modifyPhoto(String account, String photo) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, "头像修改失败！");
		try {
			SysUser user = userDao.findByAccount(account);
			if(user != null) {
				user.setPhoto(photo);
				userDao.update(user);
				result = new CrudResultDTO(CrudResultDTO.SUCCESS, "头像修改成功！");
				
				realm.refreshUserInSession(account);
			}
		} catch(Exception e) {}
		return result;
	}

	@Override
	public CrudResultDTO resetPassword(Integer userId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, "密码重置失败！");
		try {
			SysUser user = userDao.findById(userId);
			if(user != null) {
				String passwd = String.valueOf((int)(Math.random()*100000000));
				user.setPassword(MD5Utils.get32Code(passwd));
				userDao.update(user);
				sendMail(user,passwd,2);
				result = new CrudResultDTO(CrudResultDTO.SUCCESS, "密码重置成功！密码将发至用户企业邮箱，请注意查收！");
			}
		} catch(Exception e) {}
		
		return result;
	}

	@Override
	public List<SysUser> findByUserIds(List<Integer> userIdList) {
		return userDao.findByUserIds(userIdList);
	}

	@Override
	public List<SysUser> findByDeptIds(List<Integer> deptIdList) {
		return userDao.findByDeptIds(deptIdList);
	}

	@Override
	public List<SysUser> findAll() {
		return userDao.findAll();
	}

	@Override
	public List<SysUser> findByPositionCode(String positionCode) {
		return userDao.findByPositionCode(positionCode);
	}
	
	
	
	/*获取考勤页面请假统计数据，用于个人主页考勤显示*/
	@Override
	public Map<String, Object> getLeaveChartData(Map<String, Object> paramsMap) {
		Map<String, Object> result = Maps.newHashMap();
		// 获取参数
		List<Integer> deptIdList = Lists.newArrayList();
		String year = paramsMap.get("year") == null || "".equals(paramsMap.get("year").toString().trim()) 
							? String.valueOf(Calendar.getInstance().get(Calendar.YEAR)) 
							: paramsMap.get("year").toString();
		String temp = paramsMap.get("month") == null  || "".equals(paramsMap.get("month").toString().trim()) 
									? String.valueOf(Calendar.getInstance().get(Calendar.MONTH)+1) 
								: paramsMap.get("month").toString();
		String yearWithMonth=null;
		Integer month=Integer.parseInt(temp);
		if (month>=10) {
			yearWithMonth = year+"-"+month;
		}
		else {
			yearWithMonth= year+"-"+"0"+month;
		}
		SysDept dept = deptService.findById(12);
		if(dept != null) {
			getIds(dept, deptIdList);
		}
		// 构造参数条件
		Map<String, Object> params = Maps.newHashMap();
		params.put("yearWithMonth", yearWithMonth);
		params.put("deptIdList", deptIdList);
		
		// 获取数据与构建返回结果
		List<Map<String, Object>> daysList = leaveService.getLeaveDays(params);
		if(daysList != null) {
			List<Object> yAxisData = Lists.newArrayList();
			//休假小时数List
			List<Object> seriesData = Lists.newArrayList();
			for(Map<String, Object> map : daysList) {
				yAxisData.add(map.get("NAME"));
				seriesData.add(map.get("DAYS"));
			}
			result.put("legendData", yearWithMonth);
			result.put("yAxisData", yAxisData);
			result.put("seriesData", seriesData);
		}
		return result;
	}
	
	private void getIds(SysDept dept, List<Integer> idList) {
		if(dept.getChildren() != null || dept.getChildren().size() > 0) {
			for(SysDept child : dept.getChildren()) {
				getIds(child, idList);
			}
			idList.add(dept.getId());
		} else {
			idList.add(dept.getId());
		}
		
	}
	
	
	
	
	@Override
	public Map<String, Object> getLeaveData(Map<String, Object> paramsMap) {
		Map<String, Object> result = Maps.newHashMap();
		// 获取参数
		String year = paramsMap.get("year") == null || "".equals(paramsMap.get("year").toString().trim()) 
							? String.valueOf(Calendar.getInstance().get(Calendar.YEAR)) 
							: paramsMap.get("year").toString();
		String temp = paramsMap.get("month") == null  || "".equals(paramsMap.get("month").toString().trim()) 
									? String.valueOf(Calendar.getInstance().get(Calendar.MONTH)+1) 
								: paramsMap.get("month").toString();
									
		Integer userId = Integer.valueOf( paramsMap.get("userId").toString() );
		String yearWithMonth = null;
		Integer month = Integer.parseInt(temp);
		if (month >= 10) {
			yearWithMonth = year+"-"+month;
		}
		else {
			yearWithMonth = year+"-"+"0"+month;
		}
		
		// 构造参数条件
		Map<String, Object> params = Maps.newHashMap();
		params.put("yearWithMonth", yearWithMonth);
		params.put("userId", userId);
		
		
		// 获取数据与构建返回结果
		List<Map<String, Object>> dataList = leaveService.getLeaveDays(params);
		if(dataList != null && dataList.size() > 0) {
			Integer days = 0;
			Double hours = 0.0;
			for(Map<String, Object> map : dataList) {
				if (map.get("DAYS") != null) {
					days += Integer.valueOf(map.get("DAYS").toString());
				}
				if (map.get("HOURS") != null) {
					hours += Double.valueOf(map.get("HOURS").toString());
				}
			}
			
			if(hours > 7.5) {
				Double tempDays = hours / 7.5;
				days += tempDays.intValue();
				hours = hours % 7.5;
			}
			
			result.put("days", days);
			result.put("hours", hours);
		}
		
		return result;
	}

	@Override
	public Map<String, Object> getTravelData(Map<String, Object> paramsMap) {
		Map<String, Object> result = Maps.newHashMap();
		String year = paramsMap.get("year") == null || "".equals(paramsMap.get("year").toString().trim()) 
							? String.valueOf(Calendar.getInstance().get(Calendar.YEAR)) 
							: paramsMap.get("year").toString();
		String temp = paramsMap.get("month") == null  || "".equals(paramsMap.get("month").toString().trim()) 
									? String.valueOf(Calendar.getInstance().get(Calendar.MONTH)+1) 
								: paramsMap.get("month").toString();
		Integer userId = Integer.valueOf( paramsMap.get("userId").toString() );
		String yearWithMonth=null;
		Integer month=Integer.parseInt(temp);
		if (month>=10) {
			yearWithMonth = year+"-"+month;
		}
		else {
			yearWithMonth= year+"-"+"0"+month;
		}
		// 构造参数条件
		Map<String, Object> params = Maps.newHashMap();
		params.put("yearWithMonth", yearWithMonth);
		params.put("userId", userId);
		
		
		List<Map<String, Object>> dataList = travelService.getTraveData(params);
		if(dataList != null && dataList.size() > 0) {
			Integer times = dataList.size();
			result.put("times", times);
			
		}
		return result;
	}
	
	public void  updateDeptHistory(SysUser user,Integer deptId){
		
		try {
			Integer userId = user.getId();
			List<AdRecordDeptHistory> adRecordDeptHistorys =  recordDeptHistoryDao.findActiveDept(userId);
			
			String newDept = (String) deptService.findUpDept(deptId).getResult();
			
			if (adRecordDeptHistorys != null && adRecordDeptHistorys.size()>0) {
				Integer count = 0;
				for (int i = 0; i < adRecordDeptHistorys.size(); i++) {
					String oldDept = adRecordDeptHistorys.get(i).getDept().replaceAll(" ", "");
					if (!newDept.equals(oldDept)) {
						count = count +1;
					}
				}
				if ( count.equals(adRecordDeptHistorys.size())) {
					AdRecordDeptHistory deptHistory = new AdRecordDeptHistory();
					deptHistory.setUserId(userId);
					deptHistory.setStartTime(new Date());
					deptHistory.setDept(newDept);
					deptHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
					deptHistory.setCreateDate(new Date());
					recordDeptHistoryDao.save(deptHistory);
				}
			}else {
				AdRecordDeptHistory deptHistory = new AdRecordDeptHistory();
				deptHistory.setUserId(userId);
				deptHistory.setStartTime(new Date());
				deptHistory.setDept(newDept);
				deptHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
				deptHistory.setCreateDate(new Date());
				recordDeptHistoryDao.save(deptHistory);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusinessException();
		}
	}

	//与用户有关的档案表都没有保存，此方法为做完
	 public void  updatePositionHistory(SysUser user,String positionId){
		try {
			Integer userId = user.getId();
			String[] positionIds = positionId.split(",");
			
			List<String> positionNames = new ArrayList<>();
			for (String pid : positionIds) {
				AdPosition position = positionService.findById(Integer.parseInt(pid));
				
				SysDept dept = deptService.findById(position.getDeptId());
				CrudResultDTO result = deptService.findUpDept(dept.getId());
				String upDeptName = (String) result.getResult()+position.getName(); 
				positionNames.add(upDeptName);
			}
			
			
			List<AdRecordPositionHistory> adRecordPositionHistorys =  positionHistoryDao.findActivePosition(userId);
			
			if (adRecordPositionHistorys != null && adRecordPositionHistorys.size()>0) {
				for (String newPosition : positionNames) {
					Integer count = 0;
					for (AdRecordPositionHistory positionHistory : adRecordPositionHistorys) {
						String  oldPosition = positionHistory.getPosition();
						if (newPosition != null && !newPosition.equals("") && !newPosition.equals(oldPosition)) {
							count = count+1;
						}
					}
					if (count.equals(adRecordPositionHistorys.size())) {
						AdRecordPositionHistory positionHistory = new AdRecordPositionHistory();
						positionHistory.setUserId(userId);
						positionHistory.setStartTime(new Date());
						positionHistory.setPosition(newPosition.toString());
						positionHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
						positionHistory.setCreateDate(new Date());
						positionHistoryDao.save(positionHistory);
					}
				}
			}else {
				if (positionNames!= null && positionNames.size()>0) {
					for (String positionName : positionNames) {
						AdRecordPositionHistory positionHistory = new AdRecordPositionHistory();
						positionHistory.setUserId(userId);
						positionHistory.setStartTime(new Date());
						positionHistory.setPosition(positionName);
						positionHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
						positionHistory.setCreateDate(new Date());
						positionHistoryDao.save(positionHistory);
					}
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusinessException();
		}
	}

	@Override
	public List<SysUser> findAllByMeeting() {
		return userDao.findAllByMeeting();
	}

	@Override
	public Integer findMaxId() {
		return userDao.findMaxId();
	}

	@Override
	public SysUser finNewUser() {
		return userDao.finNewUser();
	}

	@Override
	public List<SysUser> findDeleteUsersByMonth(Map<String, Object> params) {
		return userDao.findDeleteUsersByMonth(params);
	}

	@Override
	public int modify(SysUser user) {
		int result = userDao.updateLogin(user);
		return result;
	}

	@Override
	public List<SysUser> findByName(String name) {
		return userDao.findByName(name);
	}
	
}