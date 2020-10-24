package com.smm.crud.service;

import com.smm.crud.bean.Employee;
import com.smm.crud.bean.EmployeeExample;
import com.smm.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 员工查重
     */
    public Boolean checkEmp(String empName){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }

    /**
     * 查询所有员工
     */
    public List<Employee> getAll(){
        EmployeeExample employeeExample = new EmployeeExample();
        employeeExample.setOrderByClause("emp_id asc");
        return employeeMapper.selectByExampleWithDept(employeeExample);
    }

    public void saveEmp(Employee employee){
        employeeMapper.insertSelective(employee);
    }

    /**
     * 通过ID查员工
     */
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 更新员工数据
     */
    public void updateEmp(Employee employee){
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 员工删除
     */
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }
}
