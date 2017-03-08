package com.dz.module.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author doggy
 *         Created on 16-3-16.
 */
@Service
public class ManagerService {
    @Autowired
    private ManagerDao managerDao;
    public void addUser(User user){
        managerDao.addUser(user);
    }
    public void deleteUser(User user){
        managerDao.deleteUser(user);
    }
    public List<User> searchAllUser(){
        return managerDao.selectAllUser();
    }
    public void assignAuthority(User user,int[] roleIds){
        managerDao.deleteRelationUrs(user);
        for(int roleId:roleIds){
            RelationUr relationUr = new RelationUr();
            relationUr.setRid(roleId);
            relationUr.setUid(user.getUid());
            managerDao.addRelationUr(relationUr);
        }
    }
    public List<RelationUr> searchAuthoritiesByUser(User user){
        return managerDao.getRelationsByUser(user);
    }
}
