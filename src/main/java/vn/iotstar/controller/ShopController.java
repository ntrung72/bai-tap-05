package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.iotstar.entity.User;
import vn.iotstar.service.ProductService;

@Controller
public class ShopController {
    private final ProductService products;
    public ShopController(ProductService products) {
        this.products = products;
    }
    @GetMapping("/")
    public String index() {
        return "redirect:/home";
    }
    @GetMapping("/product")
    public String products( @RequestParam(defaultValue = "1") int page, Model model) {
        int size = 5;
        long total = products.count();
        int pages = (int) Math.ceil(total / (double) size);
        page = Math.max(1, Math.min(page, Math.max(1, pages)));
        model.addAttribute("products", products.findPage(page, size));
        model.addAttribute("totalProducts", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pages);
        return "product";
    }
    @GetMapping("/product/detail")
    public String detail(@RequestParam int id, Model model) {
        return products.findById(id) .map(product -> {
            model.addAttribute("product", product); return "product-detail";
        }
        ) .orElse("redirect:/product");
    }
    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("latestProducts", products.latest(10));
        return "home";
    }
    @GetMapping("/admin/home")
    public String adminHome(HttpSession session, Model model) {
        User user = (User) session.getAttribute("account");
        if (user == null) {
            return "redirect:/login";
        }
        if (user.getRoleid() != 1) {
            return "redirect:/home";
        }
        model.addAttribute("latestProducts", products.latest(10));
        return "home";
    }
    @GetMapping("/manager/home")
    public String managerHome(HttpSession session, Model model) {
        User user = (User) session.getAttribute("account");
        if (user == null) {
            return "redirect:/login";
        }
        if (user.getRoleid() != 2) {
            return "redirect:/home";
        }
        model.addAttribute("latestProducts", products.latest(10));
        return "home";
    }
    @GetMapping("/waiting")
    public String waiting(HttpSession session) {
        User user = (User) session.getAttribute("account");
        if (user == null) {
            return "redirect:/login";
        }
        if (user.getRoleid() == 1) {
            return "redirect:/admin/home";
        }
        if (user.getRoleid() == 2) {
            return "redirect:/manager/home";
        }
        return "redirect:/home";
    }
}
