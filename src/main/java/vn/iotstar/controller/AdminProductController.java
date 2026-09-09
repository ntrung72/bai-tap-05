package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Validator;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.*;
import vn.iotstar.service.*;
import vn.iotstar.util.ValidationUtils;

@Controller
@RequestMapping("/admin/product")
public class AdminProductController {
    private final ProductService products;
    private final CategoryService categories;
    private final StorageService storage;
    private final Validator validator;
    public AdminProductController(ProductService p,CategoryService c,StorageService s,Validator v) {
        products=p;
        categories=c;
        storage=s;
        validator=v;
    }
    @GetMapping({"", "/list"})
    public String list(HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        m.addAttribute("productList",products.findAll());
        return "admin/list-product";
    }
    @GetMapping("/add")
    public String add(HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        m.addAttribute("cateList",categories.findAll());
        return "admin/add-product";
    }
    @PostMapping("/add")
    public String addPost(
        @RequestParam String name,
        @RequestParam String price,
        @RequestParam String quantity,
        @RequestParam String categoryId,
        @RequestParam(required=false) String description,
        @RequestParam(required=false) MultipartFile image,
        HttpSession s,
        Model m
    ) throws IOException {
        if(!admin(s))return "redirect:/waiting";
        Product p=new Product();
        Map<String,String> e=fill(p,name,price,quantity,categoryId,description);
        String ie=ValidationUtils.imageError(image,10*1024*1024L);
        if(ie!=null)e.put("image",ie);
        if(!e.isEmpty())return productErrors("admin/add-product",p,e,name,price,quantity,categoryId,description,m);
        p.setImage(storage.save(image,"product"));
        products.save(p);
        return "redirect:/admin/product/list";
    }
    @GetMapping("/edit")
    public String edit(@RequestParam int id,HttpSession s,Model m) {
        if(!admin(s))return "redirect:/waiting";
        return products.findById(id).map(p-> {
            m.addAttribute("product",p);m.addAttribute("cateList",categories.findAll());return "admin/edit-product";
        }
        ).orElse("redirect:/admin/product/list");
    }
    @PostMapping("/edit")
    public String editPost(
        @RequestParam int id,
        @RequestParam String name,
        @RequestParam String price,
        @RequestParam String quantity,
        @RequestParam String categoryId,
        @RequestParam(required=false) String description,
        @RequestParam(required=false) MultipartFile image,
        HttpSession s,
        Model m
    ) throws IOException {
        if(!admin(s))return "redirect:/waiting";
        Product p=products.findById(id).orElseThrow();
        String old=p.getImage();
        Map<String,String> e=fill(p,name,price,quantity,categoryId,description);
        String ie=ValidationUtils.imageError(image,10*1024*1024L);
        if(ie!=null)e.put("image",ie);
        if(!e.isEmpty())return productErrors("admin/edit-product",p,e,name,price,quantity,categoryId,description,m);
        if(image!=null&&!image.isEmpty())p.setImage(storage.save(image,"product"));
        products.save(p);
        if(!Objects.equals(old,p.getImage()))storage.delete(old);
        return "redirect:/admin/product/list";
    }
    @GetMapping("/delete")
    public String delete(@RequestParam int id,HttpSession s) {
        if(!admin(s))return "redirect:/waiting";
        products.findById(id).ifPresent(p-> {
            products.deleteById(id);storage.delete(p.getImage());
        }
        );
        return "redirect:/admin/product/list";
    }
    private Map<String,String> fill(Product p,String name,String price,String quantity,String categoryId,String description) {
        Map<String,String> e=new LinkedHashMap<>();
        p.setName(name==null?null:name.trim());
        p.setDescription(description==null?null:description.trim());
        try {
            p.setPrice(new BigDecimal(price.replace(".","").replace(",","")));
        } catch(Exception x) {
            e.put("price","Giá sản phẩm không hợp lệ.");
        }
        try {
            p.setQuantity(Integer.parseInt(quantity));
        } catch(Exception x) {
            e.put("quantity","Số lượng không hợp lệ.");
        }
        try {
            p.setCategory(categories.findById(Integer.parseInt(categoryId)).orElse(null));
        } catch(Exception x) {
            p.setCategory(null);
        }
        e.putAll(ValidationUtils.properties(validator,p,"name","price","quantity","category","description"));
        return e;
    }
    private String productErrors(String view,Product p,Map<String,String> e,String n,String price,String q,String c,String d,Model m) {
        m.addAttribute("errors",e);
        m.addAttribute("product",p);
        m.addAttribute("hasFormData",true);
        m.addAttribute("formName",n);
        m.addAttribute("formPrice",price);
        m.addAttribute("formQuantity",q);
        m.addAttribute("formCategoryId",c);
        m.addAttribute("formDescription",d);
        m.addAttribute("cateList",categories.findAll());
        return view;
    }
    private boolean admin(HttpSession s) {
        return s.getAttribute("account") instanceof User u&&u.getRoleid()==1;
    }
}
