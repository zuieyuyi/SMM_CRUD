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
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
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

    /**
     * 单次批量删除二合一
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids){
        //如果带-就表示是批量操作
        if(ids.contains("-")){
            List<Integer> idList = new ArrayList<>();
            String[] strIds = ids.split("-");
            for (String id:strIds) {
                idList.add(Integer.parseInt(id));
            }
            employeeService.deleteEmpBatch(idList);
        }else{
            employeeService.deleteEmp(Integer.parseInt(ids));
        }
        return Msg.success();
    }

    /**
     * 员工修改
     * 直接发送ajax PUT形式的请求
     * 会导致除了empId能获取到其他数据获取不到
     *
     * 问题：
     *      请求体中有数据;
     *      但是emp对象封装不上除了empId不为null，其他属性都获取不到都为NULL
     *      sql拼串就为 update 表名 where 条件
     * 原因：Tomcat：
     *      1、将请求体中的数据，封装成一个map。
     *      2、request.getParameter("empName")就会从这个map中取值
     *      3、SpringMVC封装POJO对象的时候，会把POJO对象的每一个属性值用2方法取出
     *
     * ajax发送PUT请求引发的血案：
     *      1、PUT请求,HttpServletRequest中获取不到属性
     *      2、Tomcat一看是PUT请求不会将请求体中的数据封装为map，只有POST形式的请求才封装请求体为map
     *
     * 解决方案：
     * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
     * 1、配置上HttpPutFormContentFilter
     * 2、它的作用是将请求体中的数据解析包装成一个map
     * 3、request被重新包装，request。getParameter()被重写，就会自己封装map中取数据
     *
     * 员工更新
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
//        System.out.println(employee);
//        System.out.println(request);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 更具Id查询员工数据
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    /**
     * 翻页封装员工数据
     */
    @RequestMapping("emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //引入pageHelper5.12以上插件
        PageHelper.startPage(pn,5);
//        PageHelper.orderBy("emp_id asc");
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        //封装了详细的分页信息，包括我们所有的查询数据,传入连续显示的页数。
        PageInfo page = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 员工添加
     */
    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg addEmp(@Valid Employee employee, BindingResult result){
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
