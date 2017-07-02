package com.dz.kaiying.controller;

import com.dz.kaiying.DTO.SaveUserJobDutyDTO;
import com.dz.kaiying.DTO.SelfEvaluateDTO;
import com.dz.kaiying.model.JobDuty;
import com.dz.kaiying.service.JobDutiesService;
import com.dz.kaiying.util.Result;
import com.dz.module.user.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by huang on 2017/4/17.
 */
@Controller
@RequestMapping(value = "/duty")
public class JobDutyController {
    @Resource
    JobDutiesService jobDutiesService;

        /**
         * （总）工作职责
         * @return
         */
        @RequestMapping(value = "", method = RequestMethod.GET)
        @ResponseBody
        public List<JobDuty> Query(){
            System.out.println("查询全部");
            return jobDutiesService.queryAll();
        }

        @RequestMapping(value = "/{dutyId}", method = RequestMethod.GET)
            @ResponseBody
            public JobDuty QueryById(@PathVariable  Integer dutyId){
                JobDuty jobDutiesList = jobDutiesService.queryById(dutyId);
                System.out.println("根据id查询");
                return jobDutiesList;
        }

        @RequestMapping(value = "", method = RequestMethod.POST)
        @ResponseBody
        public Result save(@RequestBody JobDuty jobDuty){
            return jobDutiesService.save(jobDuty);
        }

        @RequestMapping(value = "", method = RequestMethod.PUT)
        @ResponseBody
        public Result upadte(@RequestBody JobDuty jobDuties){
            return jobDutiesService.upadte(jobDuties);
        }

        @RequestMapping(value = "", method = RequestMethod.DELETE)
        @ResponseBody
        public Result saveOrUpadte(@RequestBody int[] ids){
            return jobDutiesService.delete(ids);
        }


        /**
         * 用户信息
         * @return
         */
        @RequestMapping(value = "/user", method = RequestMethod.GET)
        @ResponseBody
        public List<User> queryUser(){
            return jobDutiesService.queryUser();
        }


        @RequestMapping(value = "/user/{id}", method = RequestMethod.GET)
        @ResponseBody
        public User queryUserById(@PathVariable int id){
            System.out.println("查询User");
            return jobDutiesService.queryUserById(id);
        }
        /**
         * 用户的工作职责
         * @return
         */
        @RequestMapping(value = "/userJob/{id}", method = RequestMethod.GET)
        @ResponseBody

        public Result queryUserJob(@PathVariable int id){
            return jobDutiesService.queryUserJob(id);
        }

        @RequestMapping(value = "/userJob", method = RequestMethod.POST)
        @ResponseBody
        public Result saveUserUserJob(@RequestBody SaveUserJobDutyDTO saveUserJobDutiesDTO){
            return jobDutiesService.saveUserJob(saveUserJobDutiesDTO);
        }

        /**
         * 绩效考核自评
         * @param request
         * @return
         * @throws Exception
         */
        @RequestMapping(value = "/selfEvaluate", method = RequestMethod.GET)
        @ResponseBody
        public Result myJobDuties(HttpServletRequest request) throws Exception {
            return jobDutiesService.myjobdties(request);
        }

        @RequestMapping(value = "/selfEvaluate", method = RequestMethod.POST)
        @ResponseBody
        public Result saveMyJobDuties( @RequestBody SelfEvaluateDTO selfEvaluateDTO, HttpServletRequest request) throws Exception {
            HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("userId");
            return jobDutiesService.saveMyjobdties(selfEvaluateDTO,userId);
        }

        /**
         * 绩效考核 部门考评
         */

        @RequestMapping(value = "/departmentEvaluate", method = RequestMethod.GET)
        @ResponseBody
        public Result departmentEvaluate( HttpServletRequest request ) throws Exception {
            return jobDutiesService.departmentEvaluate(request);
        }
        @RequestMapping(value = "/savedepartmentEvaluate", method = RequestMethod.POST)
        @ResponseBody
        public Result savedepartmentEvaluate( HttpServletRequest request ) throws Exception {
            return jobDutiesService.savedepartmentEvaluate(request);
        }


        /**
         * 跳转职责增删查改页面
         */
        @RequestMapping(value = "/listduty", method = RequestMethod.GET)
        public String listduty () throws Exception {
            return "duty/duty_manager";
        }
        /**
         * 跳转用户职责分配页面
         */
        @RequestMapping(value = "/listuserduty", method = RequestMethod.GET)
        public String listuserduty () throws Exception {
            return "duty/user_duty";
        }
        /**
         * 跳转用户自评页面
         */
        @RequestMapping(value = "/listselfEvaluate", method = RequestMethod.GET)
        public String listselfEvaluate () throws Exception {
            return "duty/self_evaluate";
        }





}
