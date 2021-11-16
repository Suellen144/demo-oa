package com.reyzar.oa.service.finance.impl;

import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IFinResultsRecognitionDao;
import com.reyzar.oa.domain.FinResultsRecognition;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinResultsRecognitionService;

@Service
@Transactional
public class FinResultsRecognitionServiceImpl implements IFinResultsRecognitionService{

	@Autowired
	private IFinResultsRecognitionDao iFinResultsRecognitionDao;

	@Override
	public FinResultsRecognition findById(Integer id) {
		return iFinResultsRecognitionDao.findById(id);
	}

	@Override
	public void save(JSONObject json) {
		FinResultsRecognition finResultsRecognition=json.toJavaObject(FinResultsRecognition.class);
		 iFinResultsRecognitionDao.save(finResultsRecognition);
	}

	@Override
	public void saveOrUpdate(JSONObject json) {
		FinResultsRecognition finResultsRecognition=json.toJavaObject(FinResultsRecognition.class);
		 iFinResultsRecognitionDao.update(finResultsRecognition);
	}

	@Override
	public Page<FinResultsRecognition> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, 1000);
        Page<FinResultsRecognition> page = null;
        page = iFinResultsRecognitionDao.findByPage(params);
        double confirmAmount=0.0; //确认金额
		double resultsContribution=0.0;//业绩贡献
        if(page!=null && page.size()>0) {
        	FinResultsRecognition finResultsRecognition=new FinResultsRecognition();
        	for(int i=0;i<page.size();i++) {
        		
        	}
        }
        return page;
    }
}
