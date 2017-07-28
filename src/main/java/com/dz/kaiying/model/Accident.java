package com.dz.kaiying.model;


import javax.persistence.*;
import java.util.Date;

import static javax.persistence.GenerationType.IDENTITY;

//用户自评主表
@Entity
@Table(name = "ky_accident", catalog = "ky_dzomsdb")
public class Accident implements java.io.Serializable {

    @Id
    @GeneratedValue(strategy = IDENTITY)
    @Column(name = "id" )
    private Integer id;

    @Column(name = "bdh" )
    private String bdh; //保单号

    @Column(name = "cph" ) //车牌号
    private int cph;

    @Column(name = "bbxr")//被保险人
    private String bbxr;

    @Column(name = "bxqq" ) //保险启期
    private Date bxqq;

    @Column(name = "bxzq" ) //保险止期
    private Date bxzq;

    @Column(name = "zbe" ) //总保额
    private Date zbe;

    @Column(name = "zbf" ) //总保费
    private Date zbf;

    @Column(name = "lrsj" ) //录入时间
    private Date lrsj;

    @Column(name = "create_date" ) //创建时间
    private Date createDate;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBdh() {
        return bdh;
    }

    public void setBdh(String bdh) {
        this.bdh = bdh;
    }

    public int getCph() {
        return cph;
    }

    public void setCph(int cph) {
        this.cph = cph;
    }

    public String getBbxr() {
        return bbxr;
    }

    public void setBbxr(String bbxr) {
        this.bbxr = bbxr;
    }

    public Date getBxqq() {
        return bxqq;
    }

    public void setBxqq(Date bxqq) {
        this.bxqq = bxqq;
    }

    public Date getBxzq() {
        return bxzq;
    }

    public void setBxzq(Date bxzq) {
        this.bxzq = bxzq;
    }

    public Date getZbe() {
        return zbe;
    }

    public void setZbe(Date zbe) {
        this.zbe = zbe;
    }

    public Date getZbf() {
        return zbf;
    }

    public void setZbf(Date zbf) {
        this.zbf = zbf;
    }

    public Date getLrsj() {
        return lrsj;
    }

    public void setLrsj(Date lrsj) {
        this.lrsj = lrsj;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}