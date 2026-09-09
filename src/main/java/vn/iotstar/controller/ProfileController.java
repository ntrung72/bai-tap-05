package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Validator;
import java.io.IOException;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.User;
import vn.iotstar.service.StorageService;
import vn.iotstar.service.UserService;
import vn.iotstar.util.ValidationUtils;

@Controller
@RequestMapping("/member/myaccount")
public class ProfileController {
    private final UserService users;
    private final StorageService storage;
    private final Validator validator;
    public ProfileController(UserService u,StorageService s,Validator v) {
        users=u;
        storage=s;
        validator=v;
    }
    @GetMapping
    public String view(HttpSession session) {
        User current=(User)session.getAttribute("account");
        if(current==null)return "redirect:/login";
        return users.findById(current.getId()).map(u-> {
            session.setAttribute("account",u);return "myaccount";
        }
        ).orElse("redirect:/logout");
    }
    @PostMapping
    public String update(
        @RequestParam String fullname,
        @RequestParam String phone,
        @RequestParam(name="image",required=false) MultipartFile image,
        HttpSession session,
        Model model
    ) throws IOException {
        User u=(User)session.getAttribute("account");
        if(u==null)return "redirect:/login";
        u=users.findById(u.getId()).orElseThrow();
        u.setFullName(fullname.trim());
        u.setPhone(phone.trim());
        Map<String,String> e=ValidationUtils.properties(validator,u,"fullName","phone");
        if(users.phoneExists(u.getPhone(),u.getId()))e.put("phone","Số điện thoại này đã được sử dụng bởi tài khoản khác.");
        String ie=ValidationUtils.imageError(image,5*1024*1024L);
        if(ie!=null)e.put("image",ie);
        if(!e.isEmpty()) {
            model.addAttribute("errors",e);
            model.addAttribute("hasFormData",true);
            model.addAttribute("formFullname",fullname);
            model.addAttribute("formPhone",phone);
            return "myaccount";
        }
        String old=u.getAvatar();
        if(image!=null&&!image.isEmpty())u.setAvatar(storage.save(image,"avatar"));
        users.save(u);
        if(!java.util.Objects.equals(old,u.getAvatar()))storage.delete(old);
        session.setAttribute("account",u);
        session.setAttribute("profileSuccess","Cập nhật profile thành công.");
        return "redirect:/member/myaccount";
    }
}
