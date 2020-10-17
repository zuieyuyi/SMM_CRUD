package com.smm.crud.service;

import com.smm.crud.bean.Department;
import com.smm.crud.dao.DepartmentMapper;
import com.sun.org.apache.regexp.internal.RE;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper mapper;

    //查出所有部门
    public List<Department> getDepts(){
        List<Department> departments = mapper.selectByExample(null);
        return departments;
    }
}
