package com.dz.kaiying.controller;

import com.dz.kaiying.model.L1Storage;
import com.dz.kaiying.service.ActivitiUtilService;
import com.dz.kaiying.service.ItemService;
import com.dz.kaiying.util.Result;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by huang on 2017/4/17.
 */
@Controller
@RequestMapping(value = "/item")
public class ItemController {

    @Resource
    ItemService itemService;
    @Resource
    ActivitiUtilService activitiUtilService;




    /**
     * 启动采购流程
     * @return
     */
    @RequestMapping(value = "/startPurchase", method = RequestMethod.GET)
    @ResponseBody
    public Result startPurchase(){
        Map map = new HashMap();
        return activitiUtilService.startProcessByRuntime("item_purchase",map);
    }

    /**
     * 结束一个task
     * @return
     */
    @RequestMapping(value = "/complete", method = RequestMethod.GET)
    @ResponseBody
    public Result complete(){
        Map map = new HashMap();
        return activitiUtilService.complete("", map, null);
    }

    /**
     * 库存查询
     */
    @RequestMapping(value = "",method = RequestMethod.GET)
    @ResponseBody
    public List<L1Storage> queryStorage(){
        return itemService.queryStorage();
    }




}
