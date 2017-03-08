package com.dz.module.charge;

/**
 * @author doggy
 *         Created on 15-11-20.
 */

public interface BankFileDao {
    boolean isFileImported(String md5);
    boolean importFile(String md5);
}
