package vn.iotstar.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "Products", schema = "dbo")
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private int id;
    @NotBlank(message = "Tên sản phẩm không được để trống.")
    @Size(min = 2, max = 255, message = "Tên sản phẩm phải từ 2 đến 255 ký tự.")
    @Column(name = "product_name", columnDefinition = "NVARCHAR(255)")
    private String name;
    @Column(name = "images", columnDefinition = "NVARCHAR(255)")
    private String image;
    @NotNull(message = "Giá sản phẩm không được để trống.")
    @DecimalMin(value = "0.0", message = "Giá sản phẩm không được nhỏ hơn 0.")
    @Column(name = "price", precision = 18, scale = 2, nullable = false)
    private BigDecimal price;
    @Min(value = 0, message = "Số lượng sản phẩm không được nhỏ hơn 0.")
    @Column(name = "quantity", nullable = false)
    private int quantity;
    @Size(max = 2000, message = "Mô tả không được vượt quá 2000 ký tự.")
    @Column(name = "description", columnDefinition = "NVARCHAR(MAX)")
    private String description;
    @NotNull(message = "Vui lòng chọn danh mục.")
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cate_id", nullable = false)
    private Category category;
    public Product() {
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
    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
    public BigDecimal getPrice() {
        return price;
    }
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
}
