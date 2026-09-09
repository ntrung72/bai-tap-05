package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Validator;
import java.io.IOException;
import java.util.*;
import java.util.stream.*;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.*;
import vn.iotstar.service.*;
import vn.iotstar.util.ValidationUtils;

@Controller
@RequestMapping( {
    "/admin/category","/admin/categories"
}
) public class AdminCategoryController {
    private final CategoryService categories;
    private final StorageService storage;
    private final Validator validator;
    public AdminCategoryController(CategoryService c,StorageService s,Validator v) {
        categories=c;
        storage=s;
        validator=v;
    }
    @GetMapping({"", "/list", "/searchpaginated"})
    public String list(
        @RequestParam(required=false) String name,
        @RequestParam(defaultValue="1") int page,
        @RequestParam(defaultValue="5") int size,
        HttpSession session,
        Model model
    ) {
        if(!admin(session))return "redirect:/waiting";
        size=List.of(3,5,10,15,20).contains(size)?size:5;
        Pageable pageable=PageRequest.of(Math.max(0,page-1),size,Sort.by("name"));
        Page<Category> result=StringUtils.hasText(name)?categories.findByNameContaining(name.trim(),pageable):categories.findAll(pageable);
        model.addAttribute("categoryPage",result);
        model.addAttribute("cateList",result.getContent());
        model.addAttribute("name",name);
        if(result.getTotalPages()>0) {
            int start=Math.max(1,page-2),end=Math.min(page+2,result.getTotalPages());
            model.addAttribute("pageNumbers",IntStream.rangeClosed(start,end).boxed().toList());
        }
        return "admin/list-category";
    }
    @GetMapping("/add")
    public String add(HttpSession s) {
        return admin(s)?"admin/add-category":"redirect:/waiting";
    }
    @PostMapping("/add")
    public String addPost(@RequestParam String name,@RequestParam(required=false) MultipartFile icon,HttpSession s,Model m) throws IOException {
        if(!admin(s))return "redirect:/waiting";
        Category c=new Category();
        c.setName(name.trim());
        Map<String,String> e=ValidationUtils.properties(validator,c,"name");
        if(categories.findByName(c.getName()).isPresent())e.put("name","Tên danh mục đã tồn tại.");
        String ie=ValidationUtils.imageError(icon,5*1024*1024L);
        if(ie!=null)e.put("icon",ie);
        if(!e.isEmpty()) {
            m.addAttribute("errors",e);
            m.addAttribute("formName",name);
            return "admin/add-category";
        }
        c.setIcon(storage.save(icon,"category"));
        categories.save(c);
        return "redirect:/admin/category/list";
    }
    @GetMapping("/edit")
    public String edit(@RequestParam int id,HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        return categories.findById(id).map(c-> {
            m.addAttribute("category",c);return "admin/edit-category";
        }
        ).orElse("redirect:/admin/category/list");
    }
    @PostMapping("/edit")
    public String editPost(@RequestParam int id,@RequestParam String name,@RequestParam(required=false) MultipartFile icon,HttpSession s,Model m) throws IOException {
        if(!admin(s))return "redirect:/waiting";
        Category c=categories.findById(id).orElseThrow();
        String old=c.getIcon();
        c.setName(name.trim());
        Map<String,String> e=ValidationUtils.properties(validator,c,"name");
        categories.findByName(c.getName()).filter(x->x.getId()!=id).ifPresent(x->e.put("name","Tên danh mục đã tồn tại."));
        String ie=ValidationUtils.imageError(icon,5*1024*1024L);
        if(ie!=null)e.put("icon",ie);
        if(!e.isEmpty()) {
            m.addAttribute("errors",e);
            m.addAttribute("hasFormData",true);
            m.addAttribute("formName",name);
            m.addAttribute("category",c);
            return "admin/edit-category";
        }
        if(icon!=null&&!icon.isEmpty())c.setIcon(storage.save(icon,"category"));
        categories.save(c);
        if(!Objects.equals(old,c.getIcon()))storage.delete(old);
        return "redirect:/admin/category/list";
    }
    @GetMapping("/delete")
    public String delete(@RequestParam int id,HttpSession s) {
        if(!admin(s))return "redirect:/waiting";
        try {
            Category c=categories.findById(id).orElse(null);
            categories.deleteById(id);
            if(c!=null)storage.delete(c.getIcon());
        } catch(RuntimeException e) {
            s.setAttribute("categoryDeleteError",e.getMessage());
        }
        return "redirect:/admin/category/list";
    }
    private boolean admin(HttpSession s) {
        return s.getAttribute("account") instanceof User u&&u.getRoleid()==1;
    }
}
