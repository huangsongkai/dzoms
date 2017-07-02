package com.dz.kaiying.service;

import com.dz.kaiying.DTO.*;
import com.dz.kaiying.model.JobDuty;
import com.dz.kaiying.model.MyDutyScore;
import com.dz.kaiying.model.UserJobDuties;
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
import java.util.ArrayList;
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
    HibernateDao<MyDutyScore, Integer> myDutyScorceDao;
    private Result result = new Result();


    public List<JobDuty> queryAll() {
      List<JobDuty> JobDutiesList = jobDutyDao.find("from JobDuty");
        return JobDutiesList;
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
    public Result myjobdties(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        List <JobDutyDTO> jobDutyDTOList = new ArrayList<>();
        if (session != null){
            String userId = (String) session.getAttribute("userId");
            userId = "33";
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + userId);
            for (UserJobDuties userJobDuties: userJobDutiesList) {
                JobDutyDTO jobDutyDTO = new JobDutyDTO();
                List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + userJobDuties.getJobDutiesId());
                BeanUtils.copyProperties(jobDutyDTO, jobDutyList.get(0));  //前边是空值 后边是有值得  进行对象copy
                jobDutyDTO.setChildProValue(userJobDuties.getScore());
                jobDutyDTOList.add(jobDutyDTO);
            }
            result.setSuccess("查询成功",jobDutyDTOList);
        }
        return result;
    }

    public Result saveMyjobdties(SelfEvaluateDTO selfEvaluateDTO, String userId) {
        MyDutyScore  myDutyScore = new MyDutyScore();
        String inputs =  "";
        int index = 0;
        for (Map.Entry<Integer, String> entry : selfEvaluateDTO.getInputs().entrySet()) {
            index++;
            Integer key = entry.getKey();
            String value = entry.getValue().toString();
            System.out.println("key =" + key + " value = " + value);
            if (selfEvaluateDTO.getInputs().size() == index ){
                inputs +=value;
            }else{
                inputs +=value+"^";
            }
        }
        myDutyScore.setScore(selfEvaluateDTO.getZiping());
        myDutyScore.setInputes(inputs);
        myDutyScore.setPersonId(userId);
        myDutyScorceDao.save(myDutyScore);
        result.setSuccess("保存成功",null);
        return result;
    }

    public Result departmentEvaluate(HttpServletRequest request) {
        List<DepartmentEvaluate> departmentEvaluteList = new ArrayList<DepartmentEvaluate>();
        List<MyDutyScore> myDutyScoreList = myDutyScorceDao.find("from MyDutyScore");
            for ( MyDutyScore myDutyScore: myDutyScoreList ) {
                DepartmentEvaluate departmentEvalute = new DepartmentEvaluate();
                List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + myDutyScore.getPersonId());
                for (UserJobDuties userJobDuties : userJobDutiesList) {
                    List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + userJobDuties.getJobDutiesId());
                    for (JobDuty jobduty : jobDutyList  ) {
                        try {
                            BeanUtils.copyProperties(departmentEvalute, jobduty);
                            departmentEvalute.setChildProValue(userJobDuties.getScore());
                            departmentEvalute.setZiping(myDutyScore.getScore()+"");
                            String[] inputesList = myDutyScore.getInputes().split("^");
                            departmentEvalute.setInputs(inputesList);
                            departmentEvaluteList.add(departmentEvalute);
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        }
                    }

                }
            }
        result.setSuccess("查询成功",departmentEvaluteList);
        return result;
    }


    public Result savedepartmentEvaluate(HttpServletRequest request) {
        List<DepartmentEvaluate> departmentEvaluteList = new ArrayList<DepartmentEvaluate>();
        List<MyDutyScore> myDutyScoreList = myDutyScorceDao.find("from MyDutyScore");
        for ( MyDutyScore myDutyScore: myDutyScoreList ) {
            DepartmentEvaluate departmentEvalute = new DepartmentEvaluate();
            List<UserJobDuties> userJobDutiesList = userJobDutiesDao.find(" from UserJobDuties where personId = " + myDutyScore.getPersonId());
            for (UserJobDuties userJobDuties : userJobDutiesList) {
                List<JobDuty> jobDutyList = jobDutyDao.find(" from JobDuty where id = " + userJobDuties.getJobDutiesId());
                for (JobDuty jobduty : jobDutyList  ) {
                    try {
                        BeanUtils.copyProperties(departmentEvalute, jobduty);
                        departmentEvalute.setChildProValue(userJobDuties.getScore());
                        departmentEvalute.setZiping(myDutyScore.getScore()+"");
                        String[] inputesList = myDutyScore.getInputes().split("^");
                        departmentEvalute.setInputs(inputesList);
                        departmentEvaluteList.add(departmentEvalute);
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    }
                }

            }
        }
        result.setSuccess("保存成功",departmentEvaluteList);
        return result;
    }
}