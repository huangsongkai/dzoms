package com.dz.kaiying.service;

import com.dz.kaiying.model.JobDuty;
import com.dz.kaiying.model.L1Storage;
import com.dz.kaiying.repository.hiber.HibernateDao;
import com.dz.module.user.User;
import org.activiti.engine.*;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.task.Task;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
* Created by song.
*/
@Service
public class ItemService extends BaseService{
    @Resource
    ActivitiUtilService activitiUtilService;
    @Resource
    HibernateDao<JobDuty, Integer> jobDutiesDao;
    @Resource
    HibernateDao<User, Integer> userDao;
    @Resource
    HibernateDao<L1Storage, Integer> stairStorageDao;
    @Resource
    RuntimeService runtimeService;
    @Resource
    ProcessEngine processEngine;
    @Resource
    TaskService taskService;
    @Resource
    RepositoryService repositoryService;
    @Resource
    HistoryService historyService;

    /**
     * 采购流程(采购入库管理一级库)
     * @param task
     * @param eventName
     */
    public void putInL1Storage(Task task, String eventName){
        String processInstanceId = task.getProcessInstanceId();
        Map<String, Object> map = new HashMap<String, Object>();
        List<HistoricVariableInstance> historyVariableList = historyService.createHistoricVariableInstanceQuery().processInstanceId(processInstanceId).list();
        if (historyVariableList.size() != 0){
            for (HistoricVariableInstance variableInstance : historyVariableList) {
                map.put(variableInstance.getVariableName(),variableInstance.getValue() );
                System.out.println("variable: " + variableInstance.getVariableName() + " = " + variableInstance.getValue());
            }
            String item_id = map.get("item_id").toString();
            String purchase_num = map.get("purchase_num").toString();
            List stairStorageList = stairStorageDao.find("from L1Storage where itemId = "+item_id);
            if (stairStorageList.size() != 0){
                L1Storage stairStorage = (L1Storage) stairStorageList.get(0);
                stairStorage.setItemTotalNum(stairStorage.getItemTotalNum()+Integer.parseInt(purchase_num));
                stairStorageDao.update(stairStorage);
            }else{
                L1Storage stairStorage = new L1Storage();
                stairStorage.setItemId(Integer.parseInt(item_id));
                stairStorage.setItemState("1");
                stairStorage.setItemTotalNum(Integer.parseInt(purchase_num));
                stairStorageDao.save(stairStorage);
            }
        }
    }

    public void getL1Storage(Task task, String eventName){

    }

    public List<L1Storage> queryStorage() {
       return stairStorageDao.find("from ItemStocks");
    }
}