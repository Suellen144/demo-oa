package com.reyzar.oa.dao; 
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.AttendanceRecordDTO;
import com.reyzar.oa.domain.AdAttendance;
import com.reyzar.oa.domain.FinCollectionAttach;
import com.reyzar.oa.domain.SysUser;

/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2016年9月9日 上午10:34:08 
 *
 */
@MyBatisDao
public interface IAdAttendanceDao   {
	
	
	public void save(List<AdAttendance> adAttendance);
//	public void save(AdAttendance adAttendance);
	
	public void delete();
	
	public List<AdAttendance> getAdattendance(); //查找所有
	
	public List<AdAttendance> getAdattendanceByFlag();//查找缺勤或出差或出外勤
	
	public List<String> getAdAttendanceName(); 
	
	public List<AttendanceRecordDTO> getAdAttendanceDTO(Map<String, Object> paramMap); 
	
	public void batchUpdate(@Param(value="adAttendances") List<AdAttendance> adAttendances);
	
	public List<SysUser> findUser();

	public AttendanceRecordDTO getAdAttendanceDTO2(Map<String, Object> param);

	public void save2(Map<String, Object> mapParam);

	public List<AdAttendance> queryAttendanceData();
	
}
 