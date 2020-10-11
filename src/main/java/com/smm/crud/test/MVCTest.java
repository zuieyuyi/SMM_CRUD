package com.smm.crud.test;

import com.github.pagehelper.PageInfo;
import com.smm.crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用spring测试模块提供的测试请求功能，测试crud的正确性
 *
 * - @WebAppConfiguration
 * 该注解可以通过@Autowired注解，自动装配容器本身
 */
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml","classpath:dispatcherServlet-servlet.xml"})
public class MVCTest {
    //传入springmvc的ioc容器
    @Autowired
    WebApplicationContext webApplicationContext;
    //虚拟mvc请求，获取到处理结果。
    MockMvc mockMvc;

    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }

    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值
        //通过MockMvcRequestBuilders中的方法发送请求
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "6")).andReturn();

        //请求成功后请求域中会有pageInfo，我们可以取出pageInfo进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo<Employee> pageInfo = (PageInfo<Employee>) request.getAttribute("pageInfo");

        System.out.println("当前页码"+pageInfo.getPageNum());
        System.out.println("总页码"+pageInfo.getPages());
        System.out.println("总记录数"+pageInfo.getTotal());
        int[] navigatepageNums = pageInfo.getNavigatepageNums();
        for(int i:navigatepageNums){
            System.out.print(" "+i);
        }
        System.out.println();

        //获取员工数据
        List<Employee> emps = pageInfo.getList();
        for (Employee emp:emps){
            System.out.println("EmpId:"+emp.getEmpId()+"==== EmpName:"+emp.getEmpName());
        }

    }

}
