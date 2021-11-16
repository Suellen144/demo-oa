package com.reyzar.oa.common.dto;

public class StatisticsTravelReimburseDTO {
    /**主表的招待(type = 3)主键 */
    private String travelReceptionMainId;
    /**主表的差旅 补贴(type = 其他)主键 */
    private String travelSubsidyMainId;
    /** 项目ID*/
    private Integer projectId;
    /** 接待所付的费用*/
    private Double travelReceptionAttach;
    /** 差旅所付的费用（包含 补贴）*/
    private Double travelExpenseAttach;

    public String getTravelReceptionMainId() {
        return travelReceptionMainId;
    }

    public void setTravelReceptionMainId(String travelReceptionMainId) {
        this.travelReceptionMainId = travelReceptionMainId;
    }

    public String getTravelSubsidyMainId() {
        return travelSubsidyMainId;
    }

    public void setTravelSubsidyMainId(String travelSubsidyMainId) {
        this.travelSubsidyMainId = travelSubsidyMainId;
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public Double getTravelReceptionAttach() {
        return travelReceptionAttach;
    }

    public void setTravelReceptionAttach(Double travelReceptionAttach) {
        this.travelReceptionAttach = travelReceptionAttach;
    }

    public Double getTravelExpenseAttach() {
        return travelExpenseAttach;
    }

    public void setTravelExpenseAttach(Double travelExpenseAttach) {
        this.travelExpenseAttach = travelExpenseAttach;
    }
}
