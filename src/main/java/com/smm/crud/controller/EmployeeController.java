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
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            //校验失败应该返回失败，在模态框中显示错误信息
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for(FieldError error:errors){
                System.out.println("错误字段名："+error.getField());
                System.out.println("错误信息："+error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorField",map);
        }
        else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 员工数据校验
     */
    @ResponseBody
    @RequestMapping("checkemp")
    public Msg checkEmp(@RequestParam("empName") String empName){
        //员工姓名合法值校验
        String reg = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(reg)){
            return Msg.fail().add("va_msg","用户名可以是2-5位中文或者是6-16位字母数字组合");
        }

        //员工名查重
        Boolean result = employeeService.checkEmp(empName);
        if(result)
            return Msg.success();
        else
            return Msg.fail().add("va_msg","用户名不可用");
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
