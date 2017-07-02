package com.dz.module.charge;

import com.dz.module.contract.BankCard;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

/**
 * @author doggy
 *         Created on 15-11-17.
 */
public class BankRecord {
	private String licenseNum;
	private String driverName;
	private Map<String,BankCard> bankCards;
	private BigDecimal money;
	private Date inTime;

	public String getLicenseNum() {
		return licenseNum;
	}

	public void setLicenseNum(String licenseNum) {
		this.licenseNum = licenseNum;
	}

	public String getDriverName() {
		return driverName;
	}

	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}

	public BigDecimal getMoney() {
		return money;
	}

	public void setMoney(BigDecimal money) {
		this.money = money;
	}

	public Map<String, BankCard> getBankCards() {
		return bankCards;
	}

	@Override
	public String toString() {
		return "BankRecord{" +
				"licenseNum='" + licenseNum + '\'' +
				", driverName='" + driverName + '\'' +
				", bankCards=" + bankCards +
				", money=" + money +
				'}';
	}

	public void setBankCards(Map<String, BankCard> bankCards) {

		this.bankCards = bankCards;
	}

	public Date getInTime() {
		return inTime;
	}

	public void setInTime(Date inTime) {
		this.inTime = inTime;
	}
}
