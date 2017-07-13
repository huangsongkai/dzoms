package com.dz.kaiying.model;


import javax.persistence.*;

import static javax.persistence.GenerationType.IDENTITY;


@Entity
@Table(name = "ky_zuo_tao", catalog = "ky_dzomsdb")
public class ZuoTao implements java.io.Serializable {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "che_pai")//车牌号
	private Integer chePai;

	@Column(name = "xiao_zuo_po_sun")//小坐破损
	private String xiaoZuoPoSun;

	@Column(name = "xiao_zuo_wo_zi")//小坐污渍
	private String xiaoZoWuZi;

	@Column(name = "da_zuo_po_sun")//大坐破损
	private String DaZuoPoSun;

	@Column(name = "da_zuo_wu_zi")//大坐污渍
	private String DaZuoWuZi;

	@Column(name = "yuan_gong_gong_hao")//大坐污渍
	private String yuanGongGongHao;


	public Integer getChePai() {
		return chePai;
	}

	public void setChePai(Integer chePai) {
		this.chePai = chePai;
	}

	public String getXiaoZuoPoSun() {
		return xiaoZuoPoSun;
	}

	public void setXiaoZuoPoSun(String xiaoZuoPoSun) {
		this.xiaoZuoPoSun = xiaoZuoPoSun;
	}

	public String getXiaoZoWuZi() {
		return xiaoZoWuZi;
	}

	public void setXiaoZoWuZi(String xiaoZoWuZi) {
		this.xiaoZoWuZi = xiaoZoWuZi;
	}

	public String getDaZuoPoSun() {
		return DaZuoPoSun;
	}

	public void setDaZuoPoSun(String daZuoPoSun) {
		DaZuoPoSun = daZuoPoSun;
	}

	public String getDaZuoWuZi() {
		return DaZuoWuZi;
	}

	public void setDaZuoWuZi(String daZuoWuZi) {
		DaZuoWuZi = daZuoWuZi;
	}

	public String getYuanGongGongHao() {
		return yuanGongGongHao;
	}

	public void setYuanGongGongHao(String yuanGongGongHao) {
		this.yuanGongGongHao = yuanGongGongHao;
	}
}


