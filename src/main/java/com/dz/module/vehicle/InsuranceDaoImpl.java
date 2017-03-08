package com.dz.module.vehicle;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.stereotype.Repository;

import com.dz.common.factory.HibernateSessionFactory;
import com.dz.common.global.Page;
import com.dz.module.driver.Driver;
@Repository(value = "insuranceDao")
public class InsuranceDaoImpl implements InsuranceDao {

	@Override
	public void addInsurance(Insurance insurance) throws HibernateException {
		Session session = null;
		Transaction tx = null;
		try {	
			session = HibernateSessionFactory.getSession();
			tx = (Transaction) session.beginTransaction();
			
			session.save(insurance);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {			
			HibernateSessionFactory.closeSession();
		}
	}

	@Override
	public void updateInsurance(Insurance insurance)
			throws HibernateException {
		Session session = null;
		Transaction tx = null;
		try {	
			session = HibernateSessionFactory.getSession();
			tx = (Transaction) session.beginTransaction();
			
			session.update(insurance);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {			
			HibernateSessionFactory.closeSession();
		}
	}

	@Override
	public void deleteInsurance(Insurance insurance)
			throws HibernateException {
		Session session = null;
		Transaction tx = null;
		try {	
			session = HibernateSessionFactory.getSession();
			tx = (Transaction) session.beginTransaction();
			
			session.delete(insurance);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {			
			HibernateSessionFactory.closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Insurance> selectAll() {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			Query query = session.createQuery("from Insurance ");
			return query.list();
			
		} catch (HibernateException e) {
			throw e;
		}finally {
			HibernateSessionFactory.closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Insurance> selectByVehicle(Vehicle vehicle) {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			Query query = session.createQuery("from Insurance where carframeNum=:carframeNum");
			query.setString("carframeNum", vehicle.getCarframeNum());
			return query.list();
			
		} catch (HibernateException e) {
			throw e;
		}finally {
			HibernateSessionFactory.closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Insurance> selectByDriver(Driver driver) {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			Query query = session.createQuery("from Insurance where driverId=:driverId");
			query.setString("driverId", driver.getIdNum());
			return query.list();
			
		} catch (HibernateException e) {
			throw e;
		}finally {
			HibernateSessionFactory.closeSession();
		}
	}

	@Override
	public int selectByConditionCount(Insurance insurance) {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			String sql="select count(*) from Insurance where 1=1 ";
			
			
			if(!StringUtils.isEmpty(insurance.getCarframeNum())){
				sql+="and carframeNum=:carframeNum ";
			}
			
			if(!StringUtils.isEmpty(insurance.getInsuranceNum())){
				sql+="and insuranceNum=:insuranceNum ";
			}
			Query query = session.createQuery(sql);
			
			if(!StringUtils.isEmpty(insurance.getCarframeNum())){
				query.setString("carframeNum", insurance.getCarframeNum());
			}
			
			if(!StringUtils.isEmpty(insurance.getInsuranceNum())){
				query.setString("insuranceNum", insurance.getInsuranceNum());
			}
			return Integer.parseInt(query.uniqueResult().toString());
			
		} catch (HibernateException e) {
			throw e;
		}finally {
			HibernateSessionFactory.closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Insurance> selectByCondition(Page page, Insurance insurance) {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			String sql="from Insurance where 1=1 ";
			
			
			if(!StringUtils.isEmpty(insurance.getCarframeNum())){
				sql+="and carframeNum=:carframeNum ";
			}
			
			if(!StringUtils.isEmpty(insurance.getInsuranceNum())){
				sql+="and insuranceNum=:insuranceNum ";
			}
			Query query = session.createQuery(sql);
			
			if(!StringUtils.isEmpty(insurance.getCarframeNum())){
				query.setString("carframeNum", insurance.getCarframeNum());
			}
			
			if(!StringUtils.isEmpty(insurance.getInsuranceNum())){
				query.setString("insuranceNum", insurance.getInsuranceNum());
			}
			query.setFirstResult(page.getBeginIndex());
			query.setMaxResults(page.getEveryPage());
			return query.list();
			
		} catch (HibernateException e) {
			throw e;
		}finally {
			HibernateSessionFactory.closeSession();
		}
	}

}
