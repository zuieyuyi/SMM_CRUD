package com.smm.crud.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.smm.crud.bean.Employee;
import com.smm.crud.bean.Msg;
import com.smm.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理员工的crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //引入pageHelper插件
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        //封装了详细的分页信息，包括我们所有的查询数据,传入连续显示的页数。
        PageInfo page = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }

    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg saveEmp(Employee employee){
        employeeService.saveEmp(employee);
        return Msg.success();
    }

    /**
     * 查询员工数据（分页查询)
     * 只能用于BS
     */
//    @RequestMapping("emps")
//    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
//        //引入pageHelper插件
//        PageHelper.startPage(pn,5);
//        //startPage后面紧跟的这个查询就是一个分页查询
//        List<Employee> emps = employeeService.getAll();
//        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
//        //封装了详细的分页信息，包括我们所有的查询数据,传入连续显示的页数。
//        PageInfo page = new PageInfo(emps,5);
//        model.addAttribute("pageInfo", page);
//
//        return "list";
//    }

}
