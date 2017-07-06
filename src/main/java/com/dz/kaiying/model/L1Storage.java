package com.dz.kaiying.model;


import javax.persistence.*;

import static javax.persistence.GenerationType.IDENTITY;


@Entity
@Table(name = "ky_l1_storage", catalog = "ky_dzomsdb")
public class L1Storage implements java.io.Serializable {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "id")
	private Integer id;

	@Column(name = "item_id")//物品表Id
	private Integer itemId;

	@Column(name = "item_total_num")//总数量
	private Integer itemTotalNum;

	@Column(name = "item_purchasing_price")//采购价格
	private Double itemPurchasingPrice;

	@Column(name = "item_remarks")//备注
	private String itemRemarks;

	@Column(name = "item_state")//状态 1 正常状态
	private String itemState;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getItemId() {
		return itemId;
	}

	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}

	public Integer getItemTotalNum() {
		return itemTotalNum;
	}

	public void setItemTotalNum(Integer itemTotalNum) {
		this.itemTotalNum = itemTotalNum;
	}

	public Double getItemPurchasingPrice() {
		return itemPurchasingPrice;
	}

	public void setItemPurchasingPrice(Double itemPurchasingPrice) {
		this.itemPurchasingPrice = itemPurchasingPrice;
	}

	public String getItemRemarks() {
		return itemRemarks;
	}

	public void setItemRemarks(String itemRemarks) {
		this.itemRemarks = itemRemarks;
	}

	public String getItemState() {
		return itemState;
	}

	public void setItemState(String itemState) {
		this.itemState = itemState;
	}
}


