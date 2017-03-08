package com.dz.module.charge;

import java.util.Date;

/**
 * @author doggy
 *         Created on 15-11-18.
 */
public interface ClearTimeDao {
    Date getCurrent(String department);
    boolean plusAMonth(String department);
}
