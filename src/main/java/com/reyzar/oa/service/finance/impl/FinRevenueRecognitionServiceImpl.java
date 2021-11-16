package com.reyzar.oa.service.finance.impl;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IFinRevenueRecognitionDao;
import com.reyzar.oa.domain.FinRevenueRecognition;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinRevenueRecognitionService;

@Service
@Transactional
public class FinRevenueRecognitionServiceImpl implements IFinRevenueRecognitionService{

	@Autowired
	private IFinRevenueRecognitionDao iFinRevenueRecognition;

	@Override
	public FinRevenueRecognition findById(Integer id) {
		return iFinRevenueRecognition.findById(id);
	}

	@Override
	public void save(JSONObject json) {
		FinRevenueRecognition finRevenueRecognition=json.toJavaObject(FinRevenueRecognition.class);
		 iFinRevenueRecognition.save(finRevenueRecognition);
	}

	@Override
	public void saveOrUpdate(JSONObject json) {
		FinRevenueRecognition finRevenueRecognition=json.toJavaObject(FinRevenueRecognition.class);
		 iFinRevenueRecognition.update(finRevenueRecognition);
	}

	@Override
	public Page<FinRevenueRecognition> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, 1000);
        Page<FinRevenueRecognition> page = null;
        page = iFinRevenueRecognition.findByPage(params);
        double confirmAmount=0.0; //确认金额
		double resultsContribution=0.0;//业绩贡献
        if(page!=null && page.size()>0) {
        	FinRevenueRecognition finRevenueRecognition=new FinRevenueRecognition();
        	for(int i=0;i<page.size();i++) {
        		if(page.get(i).getConfirmAmount()!=null)
        		confirmAmount+=page.get(i).getConfirmAmount();
        		if(page.get(i).getResultsContribution()!=null)
        		resultsContribution+=page.get(i).getResultsContribution();
        	}
        	finRevenueRecognition.setConfirmAmount(confirmAmount);
        	finRevenueRecognition.setResultsContribution(resultsContribution);
        	finRevenueRecognition.setCumulative("累计");
        	page.add(finRevenueRecognition);
        }
        return page;
    }

	@Override
	public List<FinRevenueRecognition> findBybarginIds(List<String> barginId) {
		return iFinRevenueRecognition.findBybarginIds(barginId);
	}
}
