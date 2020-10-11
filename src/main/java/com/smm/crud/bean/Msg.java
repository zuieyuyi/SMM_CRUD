package com.smm.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用返回的类
 */
public class Msg {
    //状态码 100-成功 200-失败
    private Integer code;
    //提示信息
    private String message;
    //用户要返回给浏览器的数据
    private Map<String,Object> map = new HashMap<>();

    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMessage("处理成功");
        return result;
    }

    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMessage("处理失败");
        return result;
    }

    public Msg add(String key,Object object){
        this.getMap().put(key,object);
        return this;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> getMap() {
        return map;
    }

    public void setMap(Map<String, Object> map) {
        this.map = map;
    }
}
