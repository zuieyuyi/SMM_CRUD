package com.smm.crud.test;

import com.smm.crud.bean.Department;
import com.smm.crud.bean.Employee;
import com.smm.crud.dao.DepartmentMapper;
import com.smm.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 用spring的单元测试
 * 1、导入spring-test模块
 * 2、用@ContextConfiguration注解指定spring的配置文件
 * 3、直接autowired要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){
        //1、插入几个部门
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));
        //2、生成员工数据，测试员工插入
//        employeeMapper.insertSelective(new Employee(null,"lisa","M","lisa@qq.com",1));
        //3、批量插入员工
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0 ; i < 1000 ; i++){
            String empName = UUID.randomUUID().toString().substring(1,6)+i;
            mapper.insertSelective(new Employee(null,empName,"M",empName+"@qq.com",1));
        }

    }

}
