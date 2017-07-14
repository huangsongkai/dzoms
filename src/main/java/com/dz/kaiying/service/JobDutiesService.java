package com.dz.kaiying.service;

import com.dz.kaiying.DTO.*;
import com.dz.kaiying.model.*;
import com.dz.kaiying.repository.hiber.HibernateDao;
import com.dz.kaiying.util.Result;
import com.dz.module.user.User;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
* Created by song.
*/
@Service
public class JobDutiesService extends BaseService{
    @Resource
    HibernateDao<JobDuty, Integer> jobDutyDao;
    @Resource
    HibernateDao<User, Integer> userDao;
    @Resource
    HibernateDao<UserJobDuties, Integer> userJobDutiesDao;
    @Resource
    HibernateDao<SelfEvaluate, Integer> selfEvaluateDao;
    @Resource
    HibernateDao<SelfEvaluateDetail, Integer> selfEvaluateDetailDao;
    @Resource
    HibernateDao<DeparmentEvaluate, Integer> deparmentEvaluateDao;
    @Resource
    HibernateDao<DeparmentEvaluateDetail, Integer> deparmentEvaluateDetailDao;
    @Resource
    HibernateDao<ManagerEvaluate, Integer> managerEvaluateDao;
    @Resource
    HibernateDao<ManagerEvaluateDetail, Integer> managerEvaluateDetailDao;
    //流程相关
    @Resource
    private ActivitiService activitiService;

    private Result result = new Result();




    public Result<JobDuty> queryAll() {
      List<JobDuty> JobDutiesList = jobDutyDao.find("from JobDuty");
        result.setSuccess("查询成功",JobDutiesList);
        return result;
    }

    public JobDuty queryById(int id) {
        return jobDutyDao.get(JobDuty.class, id);
    }

    public Result save(JobDuty jobDuties) {
        Integer id = jobDutyDao.save(jobDuties);
  //      jobDuties.setId(id);
        result.setSuccess("保存成功",jobDuties);
        return result;
    }
    @Transactional
    public Result delete(int[] ids) {
        for (int id : ids) {
            jobDutyDao.deleteByKey(JobDuty.class, id);
        }

        result.setSuccess("删除成功",null);
        return result;
    }
    @Transactional
    public Result upadte(JobDuty jobDuties) {
        jobDutyDao.update(jobDuties);
        result.setSuccess("保存成功",jobDuties);
        return result;
    }

    public  List<User> queryUser() {
        List userList = userDao.find(" from User");
        return userList;
    }

    public User queryUserById(int id) {
      return  userDao.get(User.class, id);
    }

    public Result queryUserJob(int id) {
        List<UserJobDuties> userJobDuties = userJobDutiesDao.find(" from UserJobDuties where personId = "+id);
        List<UserJobDutyDTO> userJobDutiesDTOList = new ArrayList<>();

        for (UserJobDuties userJobs :userJobDuties ) {
            UserJobDutyDTO userJobDutiesDTO = new UserJobDutyDTO();
            userJobDutiesDTO.setKey(userJobs.getJobDutiesId());
            userJobDutiesDTO.setScore(userJobs.getScore());
            userJobDutiesDTOList.add(userJobDutiesDTO);
        }
        result.setSuccess("查询成功",userJobDutiesDTOList);
        return result;
    }

    public Result saveUserJob(SaveUserJobDutyDTO saveUserJobDutiesDTO) {
        //每次变更之前先把这个人的才删除掉
        List<UserJobDuties> userJobDutieList = userJobDutiesDao.find("from UserJobDuties where personId = " + saveUserJobDutiesDTO.getPersonId());
        for (UserJobDuties userJob: userJobDutieList) {
            userJobDutiesDao.delete(userJob);
        }

        Map<Integer, String > JobListMap = saveUserJobDutiesDTO.getJobList();
        for (Map.Entry<Integer, String> entry : JobListMap.entrySet()) {
            Integer key = entry.getKey();
            String value = entry.getValue().toString();
            System.out.println("key =" + key + " value = " + value);
            UserJobDuties userJobDuties = new UserJobDuties();
            userJobDuties.setPersonId(saveUserJobDutiesDTO.getPersonId());
            userJobDuties.setScore(Integer.parseInt(value));
            userJobDuties.setJobDutiesId(key);
            userJobDutiesDao.save(userJobDuties);
        }
        result.setSuccess("保存成功",null);
        return result;
    }

    // TODO: 2017/5/24  session 获取那块的用户Id 
    public Result myEvaluate(HttpServletRequest request) throws Exception {
        SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM");
        HttpSession session = request.getSession();
        List <SelfEvaluateDTO> SelfEvaluateDTOList = new ArrayList<>();
        if (session != null){
            User user = (User) session.getAttribute("user");
            Integer userId = user.getUid();
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + userId);
            for (UserJobDuties userJobDuties: userJobDutiesList) {
                SelfEvaluateDTO SelfEvaluateDTO = new SelfEvaluateDTO();
                List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + userJobDuties.getJobDutiesId());
                BeanUtils.copyProperties(SelfEvaluateDTO, jobDutyList.get(0));  //前边是空值 后边是有值得  进行对象copy
                SelfEvaluateDTO.setChildProValue(userJobDuties.getScore());
                SelfEvaluateDTO.setEvaluateName(dateFormater.format(new Date())+"绩效考核");
                SelfEvaluateDTOList.add(SelfEvaluateDTO);
            }
            result.setSuccess("查询成功", SelfEvaluateDTOList);
        }
        return result;
    }
    //把主表的id存在流程中 名称 selfEvaluateId
    public Result saveMyEvaluate(SaveSelfEvaluateDTO SelfEvaluateDTO, String userId) {
        SelfEvaluate selfEvaluate = new SelfEvaluate();
        selfEvaluate.setCreateDate(new Date());
        selfEvaluate.setPersonId(userId);
        selfEvaluate.setEvaluateName("从流程或者从页面中取出");
        selfEvaluate.setTotal(SelfEvaluateDTO.getTotal());//总分
        Integer id = selfEvaluateDao.save(selfEvaluate);

        for (Map.Entry<Integer, SaveSelfEvaluateDetailDTO> entry : SelfEvaluateDTO.getSelfEvaluate().entrySet()) {
            Integer key = entry.getKey();
            SaveSelfEvaluateDetailDTO selfEvaluateDetailDTO = entry.getValue();
            String inputs =  "";
            SelfEvaluateDetail selfEvaluateDetail = new SelfEvaluateDetail();
            for (String input : selfEvaluateDetailDTO.getInputs()) {
                if (selfEvaluateDetailDTO.getInputs().length == selfEvaluateDetailDTO.getInputs().length ){
                    inputs +=input;
                }else{
                    inputs +=input+"^";
                }
            }
            selfEvaluateDetail.setInputs(inputs);
            selfEvaluateDetail.setScore(selfEvaluateDetailDTO.getScore());
            selfEvaluateDetail.setSelfEvaluateId(id);
            selfEvaluateDetail.setJobDutyId(key);
            selfEvaluateDetailDao.save(selfEvaluateDetail);
        }
        result.setSuccess("保存成功",null);
        return result;
    }


    //从主表的id存在流程中 名称 selfEvaluateId
    public Result departmentEvaluate(HttpServletRequest request) throws InvocationTargetException, IllegalAccessException {
        List<DepartmentEvaluateDTO> DepartmentEvaluateDTOList = new ArrayList<DepartmentEvaluateDTO>();
        List<SelfEvaluate> selfEvaluate = selfEvaluateDao.find("from SelfEvaluate"); //自评分主表 拼条件
        List<SelfEvaluateDetail>  selfEvaluateDetailList = selfEvaluateDetailDao.find("from SelfEvaluateDetail where selfEvaluateId =" + selfEvaluate.get(0).getId());
        for ( SelfEvaluateDetail selfEvaluateDetail: selfEvaluateDetailList ) {
            List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + selfEvaluateDetail.getJobDutyId());
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + "从流程中获取"+" and jobDutiesId = "+selfEvaluateDetail.getJobDutyId() );
            UserJobDuties userJobDuties = userJobDutiesList.get(0);
            JobDuty jobDuty = jobDutyList.get(0);
            DepartmentEvaluateDTO departmentEvaluateDTO = new DepartmentEvaluateDTO();
            departmentEvaluateDTO.setChildProName(jobDuty.getChildProName());
            departmentEvaluateDTO.setChildProValue(userJobDuties.getScore());
            departmentEvaluateDTO.setComplete(jobDuty.getComplete());
            departmentEvaluateDTO.setInputs(selfEvaluateDetail.getInputs().split("^"));
            departmentEvaluateDTO.setJobResponsibility(jobDuty.getJobResponsibility());
            departmentEvaluateDTO.setJobStandard(jobDuty.getJobStandard());
            departmentEvaluateDTO.setScoreStandard(jobDuty.getScoreStandard());
            departmentEvaluateDTO.setId(selfEvaluateDetail.getJobDutyId());
            departmentEvaluateDTO.setProName(jobDuty.getProName());
            departmentEvaluateDTO.setZiping( selfEvaluateDetail.getScore());
            departmentEvaluateDTO.setEvaluateName(selfEvaluate.get(0).getEvaluateName());
            DepartmentEvaluateDTOList.add(departmentEvaluateDTO);
            }
        result.setSuccess("查询成功",DepartmentEvaluateDTOList);
        return result;
    }


    public Result savedepartmentEvaluate(SaveDepartmentEvaluateDTO saveDepartmentEvaluateDTO) {
        SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
        DeparmentEvaluate deparmentEvaluate = new DeparmentEvaluate();
        deparmentEvaluate.setCreateDate(new Date());
        deparmentEvaluate.setPersonId("流程中取出人的Id");
        deparmentEvaluate.setEvaluateName("从流程或者从页面中取出");
        deparmentEvaluate.setTotal(saveDepartmentEvaluateDTO.getTotal());//总分
        Integer id = deparmentEvaluateDao.save(deparmentEvaluate);
        if (saveDepartmentEvaluateDTO != null){
            for (Map.Entry<Integer, Integer> entry : saveDepartmentEvaluateDTO.getDepartmentEvaluate().entrySet()) {
                Integer key = entry.getKey();
                Integer value = entry.getValue();
                DeparmentEvaluateDetail deparmentEvaluateDetail = new DeparmentEvaluateDetail();
                deparmentEvaluateDetail.setScore(value);
                deparmentEvaluateDetail.setDeparmentEvaluateId(id);
                deparmentEvaluateDetail.setJobDutyId(key);
                deparmentEvaluateDetailDao.save(deparmentEvaluateDetail);
            }
        }
        result.setSuccess("保存成功",null);
        return result;
    }

    public Result managerEvaluate(HttpServletRequest request) {
        List<ManagerEvaluateDTO> managerEvaluateDTOList = new ArrayList<ManagerEvaluateDTO>();
        List<DeparmentEvaluate> deparmentEvaluate = deparmentEvaluateDao.find("from DeparmentEvaluate where evaluateName = "+"从流程取出name"); //自评分主表 拼条件
        List<DeparmentEvaluateDetail>  deparmentEvaluateDetailList = deparmentEvaluateDetailDao.find("from DeparmentEvaluateDetail where deparmentEvaluateId =" + deparmentEvaluate.get(0).getId());
        for ( DeparmentEvaluateDetail deparmentEvaluateDetail: deparmentEvaluateDetailList ) {
            List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + deparmentEvaluateDetail.getJobDutyId());
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + "从流程中获取"+" and jobDutiesId = "+deparmentEvaluateDetail.getJobDutyId() );
            UserJobDuties userJobDuties = userJobDutiesList.get(0);
            JobDuty jobDuty = jobDutyList.get(0);
            List<SelfEvaluate> selfEvaluate = selfEvaluateDao.find("from SelfEvaluate "); //自评分主表 拼条件
            List<SelfEvaluateDetail>  selfEvaluateDetailList = selfEvaluateDetailDao.find("from SelfEvaluateDetail where selfEvaluateId =" + selfEvaluate.get(0).getId() +"and jobDutyId ="+deparmentEvaluateDetail.getJobDutyId());
            ManagerEvaluateDTO managerEvaluateDTO = new ManagerEvaluateDTO();
            managerEvaluateDTO.setChildProName(jobDuty.getChildProName());
            managerEvaluateDTO.setChildProValue(userJobDuties.getScore());
            managerEvaluateDTO.setComplete(jobDuty.getComplete());
            managerEvaluateDTO.setInputs(deparmentEvaluateDetail.getInputs().split("^"));
            managerEvaluateDTO.setJobResponsibility(jobDuty.getJobResponsibility());
            managerEvaluateDTO.setJobStandard(jobDuty.getJobStandard());
            managerEvaluateDTO.setScoreStandard(jobDuty.getScoreStandard());
            managerEvaluateDTO.setId(deparmentEvaluateDetail.getJobDutyId());
            managerEvaluateDTO.setProName(jobDuty.getProName());
            managerEvaluateDTO.setZiping(selfEvaluateDetailList.get(0).getScore());
            managerEvaluateDTO.setBumen(deparmentEvaluateDetail.getScore());
            managerEvaluateDTO.setEvaluateName(selfEvaluate.get(0).getEvaluateName());
            managerEvaluateDTOList.add(managerEvaluateDTO);
        }
        result.setSuccess("查询成功",managerEvaluateDTOList);
        return result;
    }



    public Result saveManagerEvaluate(SaveManagerEvaluateDTO saveManagerEvaluateDTO, HttpServletRequest request) {
        SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
        ManagerEvaluate managerEvaluate = new ManagerEvaluate();
        managerEvaluate.setCreateDate(new Date());
        managerEvaluate.setPersonId("流程中取出人的Id");
        managerEvaluate.setEvaluateName("从流程或者从页面中取出");
        managerEvaluate.setTotal(saveManagerEvaluateDTO.getTotal());//总分
        Integer id = managerEvaluateDao.save(managerEvaluate);
        if (saveManagerEvaluateDTO != null){
            for (Map.Entry<Integer, Integer> entry : saveManagerEvaluateDTO.getManagerEvaluate().entrySet()) {
                Integer key = entry.getKey();
                Integer value = entry.getValue();
                ManagerEvaluateDetail managerEvaluateDetail = new ManagerEvaluateDetail();
                managerEvaluateDetail.setScore(value);
                managerEvaluateDetail.setManagerEvaluateId(id);
                managerEvaluateDetail.setJobDutyId(key);
                managerEvaluateDetailDao.save(managerEvaluateDetail);
            }
        }
        result.setSuccess("保存成功",null);
        return result;
    }

    public Result listHistory(String personId) {
        List<ManagerEvaluateDTO> managerEvaluateDTOList = new ArrayList<ManagerEvaluateDTO>();
        List<DeparmentEvaluate> deparmentEvaluate = deparmentEvaluateDao.find("from DeparmentEvaluate where evaluateName = "+"从流程取出name"); //自评分主表 拼条件
        List<DeparmentEvaluateDetail>  deparmentEvaluateDetailList = deparmentEvaluateDetailDao.find("from DeparmentEvaluateDetail where deparmentEvaluateId =" + deparmentEvaluate.get(0).getId());
        for ( DeparmentEvaluateDetail deparmentEvaluateDetail: deparmentEvaluateDetailList ) {
            List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + deparmentEvaluateDetail.getJobDutyId());
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + "从流程中获取"+" and jobDutiesId = "+deparmentEvaluateDetail.getJobDutyId() );
            UserJobDuties userJobDuties = userJobDutiesList.get(0);
            JobDuty jobDuty = jobDutyList.get(0);
            List<SelfEvaluate> selfEvaluate = selfEvaluateDao.find("from SelfEvaluate "); //自评分主表 拼条件
            List<SelfEvaluateDetail>  selfEvaluateDetailList = selfEvaluateDetailDao.find("from SelfEvaluateDetail where selfEvaluateId =" + selfEvaluate.get(0).getId() +"and jobDutyId ="+deparmentEvaluateDetail.getJobDutyId());
            ManagerEvaluateDTO managerEvaluateDTO = new ManagerEvaluateDTO();
            managerEvaluateDTO.setChildProName(jobDuty.getChildProName());
            managerEvaluateDTO.setChildProValue(userJobDuties.getScore());
            managerEvaluateDTO.setComplete(jobDuty.getComplete());
            managerEvaluateDTO.setInputs(deparmentEvaluateDetail.getInputs().split("^"));
            managerEvaluateDTO.setJobResponsibility(jobDuty.getJobResponsibility());
            managerEvaluateDTO.setJobStandard(jobDuty.getJobStandard());
            managerEvaluateDTO.setScoreStandard(jobDuty.getScoreStandard());
            managerEvaluateDTO.setId(deparmentEvaluateDetail.getJobDutyId());
            managerEvaluateDTO.setProName(jobDuty.getProName());
            managerEvaluateDTO.setZiping(selfEvaluateDetailList.get(0).getScore());
            managerEvaluateDTO.setBumen(deparmentEvaluateDetail.getScore());
            managerEvaluateDTO.setEvaluateName(selfEvaluate.get(0).getEvaluateName());
            managerEvaluateDTOList.add(managerEvaluateDTO);
        }

        result.setSuccess("查询成功",null);
        return result;
    }
}