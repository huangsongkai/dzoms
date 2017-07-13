package com.dz.kaiying.service.statistics;

import com.dz.kaiying.repository.hiber.HibernateDao;
import com.dz.module.charge.CheckChargeTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * Created by song on 2017/7/13.
 */
@Service
public class FinanceStatisticsService extends StatisticsService{
    @Autowired
    HibernateDao<CheckChargeTable, Integer> financeStatisticsDao;
    public StatisticsService.MonthsCountDto getStatusDistribution() {
        StatisticsService.MonthsCountDto monthsCountDto = new StatisticsService.MonthsCountDto();
        String[] sqls = {
                "select sum(planAll) from CheckChargeTable where time >= $firstDay and time<=$lastDay",
                "select sum(thisMonthTotalOwe) from CheckChargeTable where time >= $firstDay and time<=$lastDay",
//                "from Contract where contract_begin_date > $firstDay and contract_begin_date<$lastDay and branch_firm='二部'",
//                "from Contract where contract_begin_date > $firstDay and contract_begin_date<$lastDay and branch_firm='三部'"
        };
        monthsCountDto =  wholeYearBar(sqls, financeStatisticsDao);
        for(int i = 0 ; i < 12 ;i++){
            monthsCountDto.counts[1][i] =  monthsCountDto.counts[0][i]-  monthsCountDto.counts[1][i];
        }

        return monthsCountDto;
    }
    @Override
    public int fetchCountsBySql(HibernateDao contractStatisticsDao, String sql, String firstDay, String lastDay){
        sql = sql.replace("$firstDay",firstDay).replace("$lastDay",lastDay);
        if(contractStatisticsDao.find(sql).get(0) == null)
            return 0;
        return ((BigDecimal)contractStatisticsDao.find(sql).get(0)).intValue();
    }
}
