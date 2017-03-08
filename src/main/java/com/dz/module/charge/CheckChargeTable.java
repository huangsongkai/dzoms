package com.dz.module.charge;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @author doggy
 *         Created on 15-11-15.
 */
public class CheckChargeTable {
    private int contractId;
    private Date time;
    private String driverName;
    private String carNumber;
    private String driverId;
    private String dept;

    private BigDecimal planAll;

    private BigDecimal cash;
    private BigDecimal other;
    private BigDecimal bank;
    private BigDecimal oilAdd;
    private BigDecimal insurance;
    private BigDecimal total;

    //本月欠款(计划总额-收入合计)
    private BigDecimal thisMonthOwe;
    //上月累欠(上月存款)
    private BigDecimal lastMonthOwe;
    //本月存款(本月剩余)
    private BigDecimal thisMonthLeft;
    //本月累欠
    private BigDecimal thisMonthTotalOwe;

    public BigDecimal getPlanAll() {
        return planAll;
    }

    public void setPlanAll(BigDecimal planAll) {
        this.planAll = planAll;
    }

    public BigDecimal getCash() {
        return cash;
    }

    public void setCash(BigDecimal cash) {
        this.cash = cash;
    }

    public BigDecimal getBank() {
        return bank;
    }

    public void setBank(BigDecimal bank) {
        this.bank = bank;
    }

    public BigDecimal getOilAdd() {
        return oilAdd;
    }

    public void setOilAdd(BigDecimal oilAdd) {
        this.oilAdd = oilAdd;
    }

    public BigDecimal getInsurance() {
        return insurance;
    }

    public void setInsurance(BigDecimal insurance) {
        this.insurance = insurance;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public BigDecimal getThisMonthOwe() {
        return thisMonthOwe;
    }

    public void setThisMonthOwe(BigDecimal thisMonthOwe) {
        this.thisMonthOwe = thisMonthOwe;
    }

    public BigDecimal getLastMonthOwe() {
        return lastMonthOwe;
    }

    public void setLastMonthOwe(BigDecimal lastMonthOwe) {
        this.lastMonthOwe = lastMonthOwe;
    }

    public BigDecimal getThisMonthLeft() {
        return thisMonthLeft;
    }

    public void setThisMonthLeft(BigDecimal thisMonthLeft) {
        this.thisMonthLeft = thisMonthLeft;
    }

    public BigDecimal getThisMonthTotalOwe() {
        return thisMonthTotalOwe;
    }

    public void setThisMonthTotalOwe(BigDecimal thisMonthTotalOwe) {
        this.thisMonthTotalOwe = thisMonthTotalOwe;

    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getCarNumber() {
        return carNumber;
    }

    public void setCarNumber(String carNumber) {
        this.carNumber = carNumber;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getDriverId() {
        return driverId;
    }

    public void setDriverId(String driverId) {
        this.driverId = driverId;
    }

    public BigDecimal getOther() {
        return other;
    }

    public void setOther(BigDecimal other) {
        this.other = other;
    }
    //需要提前设置各项收入，与总计划
    public void generated(BigDecimal lastMonthOwe){
        this.total = new BigDecimal(0);
        if(cash == null) cash = new BigDecimal(0.00);
        if(bank == null) bank = new BigDecimal(0.00);
        if(oilAdd == null) oilAdd = new BigDecimal(0.00);
        if(insurance == null) insurance = new BigDecimal(0.00);
        if(other == null) other = new BigDecimal(0.00);
        this.total = this.total.add(cash).add(bank).add(oilAdd).add(insurance).add(other);
        BigDecimal owe = this.total.subtract(this.planAll).add(lastMonthOwe);
        //上月累欠
        this.lastMonthOwe = lastMonthOwe;
        //本月欠款
        this.thisMonthOwe = owe.doubleValue() > 0?new BigDecimal(0.00):owe;
        //本月存款
        this.thisMonthLeft = owe.doubleValue() > 0?owe:new BigDecimal(0.00);
        //本月累欠
        this.thisMonthTotalOwe = owe;
    }

    public String getDept() {
        return dept;
    }

    public void setDept(String dept) {
        this.dept = dept;
    }
}
