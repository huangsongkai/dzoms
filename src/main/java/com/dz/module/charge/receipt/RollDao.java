package com.dz.module.charge.receipt;

/**
 * @author doggy
 *         Created on 15-12-28.
 */
public interface RollDao {
    boolean addFromSeg(int startNum, int endNum);
    boolean markAsUsed(int startNum, int endNum);
    boolean markAsUnUsed(int startNum, int endNum);
    boolean isValidForIn(int startNum, int endNum);
    boolean isValidForSold(int startNum, int endNum);
    long getStorage();
    boolean deleteRoll(int startNum, int endNum);
}
