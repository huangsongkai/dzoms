package com.dz.module.user;

import java.util.List;

/**
 * @author doggy
 *         Created on 16-3-16.
 */
public interface ManagerDao {
    void addUser(User user);
    void deleteUser(User user);
    List<User> selectAllUser();
    List<RelationUr> getRelationsByUser(User user);
    void addRelationUr(RelationUr relationUr);
    void deleteRelationUrs(User user);
}
