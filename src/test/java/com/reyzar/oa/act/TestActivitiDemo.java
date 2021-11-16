package com.reyzar.oa.act;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.common.util.ActivitiUtils;

public class TestActivitiDemo extends JUnitActionBase {

	@Autowired
	private ActivitiUtils utils;
	
	@Test
	public void test() {
		//utils.deployProcess("act/leave/leave.bpmn");
		
		/*utils.deleteProcessDefinition("1", true);
		utils.deleteProcessDefinition("7515", true);
		utils.deleteProcessDefinition("7522", true);
		utils.deleteProcessDefinition("7526", true);*/
	}
}
