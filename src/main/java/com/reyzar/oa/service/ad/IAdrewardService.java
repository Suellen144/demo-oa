package com.reyzar.oa.service.ad;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.Adreward;

import javax.servlet.ServletOutputStream;
import java.util.List;
import java.util.Map;

/**
 * @author since
 */
public interface IAdrewardService {
    public Page<Adreward> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize);

    public Adreward findById(Integer id);

    public List<Adreward> findAll();

    public CrudResultDTO save(JSONObject json);

    public CrudResultDTO update(JSONObject json);

    public CrudResultDTO lock(JSONObject json);

    public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap);
}
