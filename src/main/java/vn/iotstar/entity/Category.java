package vn.iotstar.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Category", schema = "dbo")
public class Category implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cate_id")
    private int id;
    @NotBlank(message = "Tên danh mục không được để trống.")
    @Size(min = 2, max = 100, message = "Tên danh mục phải từ 2 đến 100 ký tự.")
    @Column(name = "cate_name", columnDefinition = "NVARCHAR(255)")
    private String name;
    @Column(name = "icons", columnDefinition = "NVARCHAR(255)")
    private String icon;
    @OneToMany(mappedBy = "category")
    private List<Product> products = new ArrayList<>();
    public Category() {
    }
    public Category(String name, String icon) {
        this.name = name;
        this.icon = icon;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getIcon() {
        return icon;
    }
    public void setIcon(String icon) {
        this.icon = icon;
    }
    public List<Product> getProducts() {
        return products;
    }
    public void setProducts(List<Product> products) {
        this.products = products;
    }
}
