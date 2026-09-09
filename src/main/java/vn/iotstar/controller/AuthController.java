package vn.iotstar.controller;

import jakarta.servlet.http.*;
import jakarta.validation.Validator;
import java.util.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.ValidationUtils;

@Controller
public class AuthController {
    private static final long OTP_TTL=5*60*1000L;
    private final UserService users;
    private final Validator validator;
    private final JavaMailSender mail;
    private final String sender;
    public AuthController(UserService users,Validator validator,JavaMailSender mail,@Value("${spring.mail.username:}") String sender) {
        this.users=users;
        this.validator=validator;
        this.mail=mail;
        this.sender=sender;
    }
    @GetMapping("/login")
    public String login(HttpServletRequest req,Model model) {
        if(req.getSession(false)!=null&&req.getSession(false).getAttribute("account")!=null)return "redirect:/waiting";
        if(req.getCookies()!=null)for(Cookie c:req.getCookies())if("username".equals(c.getName())) {
            model.addAttribute("rememberedUsername",c.getValue());
            model.addAttribute("rememberChecked",true);
        }
        return "login";
    }
    @PostMapping("/login")
    public String loginPost(
        @RequestParam(required=false) String username,
        @RequestParam(required=false) String password,
        @RequestParam(required=false) String remember,
        HttpServletRequest req,
        HttpServletResponse resp,
        Model model
    ) {
        User form=new User();
        form.setUserName(trim(username));
        form.setPassWord(password);
        Map<String,String> errors=ValidationUtils.properties(validator,form,"userName","passWord");
        if(!errors.isEmpty()) {
            model.addAttribute("errors",errors);
            model.addAttribute("rememberedUsername",username);
            model.addAttribute("rememberChecked","on".equals(remember));
            return "login";
        }
        User user=users.login(form.getUserName(),password);
        if(user==null) {
            model.addAttribute("alert","Tài khoản hoặc mật khẩu không đúng");
            model.addAttribute("rememberedUsername",username);
            return "login";
        }
        req.getSession(true).setAttribute("account",user);
        Cookie c=new Cookie("username","on".equals(remember)?username:"");
        c.setMaxAge("on".equals(remember)?1800:0);
        c.setHttpOnly(true);
        c.setPath("/");
        resp.addCookie(c);
        return "redirect:/waiting";
    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    @GetMapping("/register")
    public String register(HttpServletRequest req) {
        return req.getSession(false)!=null&&req.getSession(false).getAttribute("account")!=null?"redirect:/waiting":"register";
    }
    @PostMapping("/register")
    public String registerPost(
        @RequestParam String username,
        @RequestParam String password,
        @RequestParam String repassword,
        @RequestParam String email,
        @RequestParam String fullname,
        @RequestParam String phone,
        HttpSession session,
        Model model
    ) {
        User f=new User();
        f.setUserName(trim(username));
        f.setPassWord(password);
        f.setEmail(trim(email));
        f.setFullName(trim(fullname));
        f.setPhone(trim(phone));
        Map<String,String> e=ValidationUtils.properties(validator,f,"userName","passWord","email","fullName","phone");
        if(!Objects.equals(password,repassword))e.put("repassword","Mật khẩu nhập lại không đúng.");
        if(users.emailExists(f.getEmail()))e.put("email","Email đã tồn tại.");
        if(users.usernameExists(f.getUserName()))e.put("userName","Tên đăng nhập đã tồn tại.");
        if(users.phoneExists(f.getPhone()))e.put("phone","Số điện thoại đã tồn tại.");
        if(!e.isEmpty()) {
            model.addAttribute("errors",e);
            return "register";
        }
        String otp=otp();
        if(!sendOtp(email,otp,"kích hoạt tài khoản")) {
            model.addAttribute("alert","Không thể gửi OTP. Hãy kiểm tra MAIL_USERNAME và MAIL_APP_PASSWORD!");
            return "register";
        }
        session.setAttribute("registerData",List.of(f.getUserName(),password,f.getEmail(),f.getFullName(),f.getPhone()));
        session.setAttribute("registerOtp",otp);
        session.setAttribute("registerOtpExpired",System.currentTimeMillis()+OTP_TTL);
        return "redirect:/verify-register";
    }
    @GetMapping("/verify-register")
    public String verifyRegister(HttpSession s,Model m) {
        if(s.getAttribute("registerOtp")==null)return "redirect:/register";
        List<?> d=(List<?>)s.getAttribute("registerData");
        m.addAttribute("email",d.get(2));
        return "verify-register";
    }
    @PostMapping("/verify-register")
    public String verifyRegisterPost(@RequestParam String otp,HttpSession s,Model m) {
        String err=checkOtp(otp,(String)s.getAttribute("registerOtp"),(Long)s.getAttribute("registerOtpExpired"));
        if(err!=null) {
            m.addAttribute("errors",Map.of("otp",err));
            return verifyRegister(s,m);
        }
        List<?> d=(List<?>)s.getAttribute("registerData");
        users.register((String)d.get(0),(String)d.get(1),(String)d.get(2),(String)d.get(3),(String)d.get(4));
        clear(s,"register");
        s.setAttribute("success","Kích hoạt tài khoản thành công. Bạn có thể đăng nhập ngay!");
        return "redirect:/login";
    }
    @GetMapping("/forgot-password")
    public String forgot() {
        return "forgot-password";
    }
    @PostMapping("/forgot-password")
    public String forgotPost(@RequestParam String email,HttpSession s,Model m) {
        Optional<User> u=users.findByEmail(trim(email));
        if(u.isEmpty()) {
            m.addAttribute("errors",Map.of("email","Email không tồn tại trong hệ thống."));
            return "forgot-password";
        }
        String otp=otp();
        if(!sendOtp(email,otp,"quên mật khẩu")) {
            m.addAttribute("alert","Không thể gửi OTP. Hãy kiểm tra cấu hình email của project!");
            return "forgot-password";
        }
        s.setAttribute("forgotEmail",email);
        s.setAttribute("forgotOtp",otp);
        s.setAttribute("forgotOtpExpired",System.currentTimeMillis()+OTP_TTL);
        return "redirect:/verify-forgot-otp";
    }
    @GetMapping("/verify-forgot-otp")
    public String verifyForgot(HttpSession s,Model m) {
        if(s.getAttribute("forgotOtp")==null)return "redirect:/forgot-password";
        m.addAttribute("email",s.getAttribute("forgotEmail"));
        return "verify-forgot-otp";
    }
    @PostMapping("/verify-forgot-otp")
    public String verifyForgotPost(@RequestParam String otp,HttpSession s,Model m) {
        String err=checkOtp(otp,(String)s.getAttribute("forgotOtp"),(Long)s.getAttribute("forgotOtpExpired"));
        if(err!=null) {
            m.addAttribute("errors",Map.of("otp",err));
            return verifyForgot(s,m);
        }
        s.setAttribute("forgotOtpVerified",true);
        s.removeAttribute("forgotOtp");
        return "redirect:/reset-password";
    }
    @GetMapping("/reset-password")
    public String reset(HttpSession s) {
        return Boolean.TRUE.equals(s.getAttribute("forgotOtpVerified"))?"reset-password":"redirect:/forgot-password";
    }
    @PostMapping("/reset-password")
    public String resetPost(@RequestParam String password,@RequestParam String repassword,HttpSession s,Model m) {
        User f=new User();
        f.setPassWord(password);
        Map<String,String> e=ValidationUtils.properties(validator,f,"passWord");
        if(!Objects.equals(password,repassword))e.put("repassword","Mật khẩu nhập lại không đúng.");
        if(!e.isEmpty()) {
            m.addAttribute("errors",e);
            return "reset-password";
        }
        User u=users.findByEmail((String)s.getAttribute("forgotEmail")).orElseThrow();
        u.setPassWord(password);
        users.save(u);
        clear(s,"forgot");
        s.setAttribute("success","Đổi mật khẩu thành công. Bạn có thể đăng nhập bằng mật khẩu mới!");
        return "redirect:/login";
    }
    private boolean sendOtp(String to,String otp,String purpose) {
        if(sender==null||sender.isBlank())return false;
        try {
            SimpleMailMessage msg=new SimpleMailMessage();
            msg.setFrom(sender);
            msg.setTo(to);
            msg.setSubject("Mã OTP "+purpose);
            msg.setText("Mã OTP của bạn là: "+otp+"\nMã có hiệu lực trong 5 phút.");
            mail.send(msg);
            return true;
        } catch(Exception e) {
            return false;
        }
    }
    private String checkOtp(String input,String saved,Long expiry) {
        if(saved==null||expiry==null||System.currentTimeMillis()>expiry)return "OTP đã hết hạn. Vui lòng thực hiện lại!";
        if(input==null||!input.trim().matches("[0-9]{6}"))return "Mã OTP phải gồm đúng 6 chữ số.";
        return saved.equals(input.trim())?null:"Mã OTP không đúng.";
    }
    private void clear(HttpSession s,String p) {
        new ArrayList<>(Collections.list(s.getAttributeNames())).stream().filter(n->n.startsWith(p)).forEach(s::removeAttribute);
    }
    private String otp() {
        return String.format("%06d",new java.security.SecureRandom().nextInt(1_000_000));
    }
    private String trim(String s) {
        return s==null?null:s.trim();
    }
}
