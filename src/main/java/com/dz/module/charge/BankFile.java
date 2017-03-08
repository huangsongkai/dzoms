package com.dz.module.charge;

import javax.persistence.*;

/**
 * @author doggy
 *         Created on 15-11-20.
 */
@Entity
@Table(catalog = "dzomsdb",name = "bankfile")
public class BankFile {
    @Id
    @GeneratedValue
    @Column(name = "`id`")
    private int id;
    @Column(name="`md5`")
    private String md5;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMd5() {
        return md5;
    }

    public void setMd5(String md5) {
        this.md5 = md5;
    }
}
