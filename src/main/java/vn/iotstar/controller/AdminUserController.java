package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Validator;
import java.sql.Date;
import java.util.*;
import java.util.stream.IntStream;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.ValidationUtils;

@Controller
@RequestMapping( {
    "/admin/user","/admin/users"
}
) public class AdminUserController {
    private final UserService users;
    private final Validator validator;
    public AdminUserController(UserService u,Validator v) {
        users=u;
        validator=v;
    }
    @GetMapping({"", "/list", "/searchpaginated"})
    public String list(
        @RequestParam(required=false) String keyword,
        @RequestParam(defaultValue="1") int page,
        @RequestParam(defaultValue="5") int size,
        HttpSession s,
        Model m
    ) {
        if(!admin(s))return "redirect:/waiting";
        size=List.of(3,5,10,15,20).contains(size)?size:5;
        Pageable p=PageRequest.of(Math.max(0,page-1),size,Sort.by("userName"));
        Page<User> result=StringUtils.hasText(keyword)?users.search(keyword.trim(),p):users.findAll(p);
        m.addAttribute("userPage",result);
        m.addAttribute("keyword",keyword);
        if(result.getTotalPages()>0) {
            int start=Math.max(1,page-2),end=Math.min(page+2,result.getTotalPages());
            m.addAttribute("pageNumbers",IntStream.rangeClosed(start,end).boxed().toList());
        }
        return "admin/list-user";
    }
    @GetMapping("/add")
    public String add(HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        User u=new User();
        u.setRoleid(5);
        m.addAttribute("user",u);
        m.addAttribute("isEdit",false);
        return "admin/user-form";
    }
    @GetMapping("/edit")
    public String edit(@RequestParam int id,HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        return users.findById(id).map(u-> {
            m.addAttribute("user",u);m.addAttribute("isEdit",true);return "admin/user-form";
        }
        ).orElse("redirect:/admin/user/list");
    }
    @PostMapping("/save")
    public String save(
        @RequestParam(defaultValue="0") int id,
        @RequestParam String username,
        @RequestParam String fullname,
        @RequestParam String email,
        @RequestParam String phone,
        @RequestParam(required=false) String password,
        @RequestParam int roleid,
        HttpSession s,
        Model m
    ) {
        if(!admin(s))return "redirect:/waiting";
        boolean edit=id>0;
        User u=edit?users.findById(id).orElseThrow():new User();
        u.setUserName(username.trim());
        u.setFullName(fullname.trim());
        u.setEmail(email.trim());
        u.setPhone(phone.trim());
        u.setRoleid(roleid);
        if(!edit||StringUtils.hasText(password))u.setPassWord(password);
        if(!edit)u.setCreatedDate(new Date(System.currentTimeMillis()));
        Map<String,String> e=ValidationUtils.properties(validator,u,"userName","fullName","email","phone","passWord");
        if((!edit&&users.usernameExists(u.getUserName())))e.put("userName","Tên đăng nhập đã tồn tại.");
        if(!edit&&users.emailExists(u.getEmail()))e.put("email","Email đã tồn tại.");
        if(!edit&&users.phoneExists(u.getPhone()))e.put("phone","Số điện thoại đã tồn tại.");
        if(edit) {
            users.findAll(Pageable.unpaged()).stream().filter(x->x.getId()!=id).forEach(x-> {
                if(x.getUserName().equalsIgnoreCase(u.getUserName()))e.put("userName","Tên đăng nhập đã tồn tại.");
                if(x.getEmail().equalsIgnoreCase(u.getEmail()))e.put("email","Email đã tồn tại.");
                if(x.getPhone().equals(u.getPhone()))e.put("phone","Số điện thoại đã tồn tại.");
            }
            );
        }
        if(!e.isEmpty()) {
            m.addAttribute("errors",e);
            m.addAttribute("user",u);
            m.addAttribute("isEdit",edit);
            return "admin/user-form";
        }
        users.save(u);
        return "redirect:/admin/user/list";
    }
    @GetMapping("/delete")
    public String delete(@RequestParam int id,HttpSession s) {
        if(!admin(s))return "redirect:/waiting";
        User current=(User)s.getAttribute("account");
        if(current.getId()!=id)users.deleteById(id);
        else s.setAttribute("userDeleteError","Không thể xóa tài khoản đang đăng nhập.");
        return "redirect:/admin/user/list";
    }
    private boolean admin(HttpSession s) {
        return s.getAttribute("account") instanceof User u&&u.getRoleid()==1;
    }
}
