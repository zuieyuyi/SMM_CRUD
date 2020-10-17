package com.smm.crud.controller;

import com.smm.crud.bean.Department;
import com.smm.crud.bean.Msg;
import com.smm.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;

    /**
     * 查询所有部门
     */
    @ResponseBody
    @RequestMapping("depts")
    public Msg getDepts(){
        List<Department> depts = departmentService.getDepts();
        return Msg.success().add("depts",depts);
    }
}
