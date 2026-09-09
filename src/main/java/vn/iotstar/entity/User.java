package vn.iotstar.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.io.Serializable;
import java.sql.Date;

@Entity
@Table(name = "[User]", schema = "dbo")
public class User implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
    @NotBlank(message = "Email không được để trống.")
    @Email(message = "Email không đúng định dạng.")
    @Size(max = 100, message = "Email không được vượt quá 100 ký tự.")
    @Column(name = "email", columnDefinition = "VARCHAR(255)")
    private String email;
    @NotBlank(message = "Tên đăng nhập không được để trống.")
    @Size(min = 3, max = 50, message = "Tên đăng nhập phải từ 3 đến 50 ký tự.")
    @Pattern(regexp = "^[A-Za-z0-9._]+$", message = "Tên đăng nhập chỉ gồm chữ cái, số, dấu chấm và dấu gạch dưới.")
    @Column(name = "username", columnDefinition = "VARCHAR(255)")
    private String userName;
    @NotBlank(message = "Họ tên không được để trống.")
    @Size(min = 2, max = 100, message = "Họ tên phải từ 2 đến 100 ký tự.")
    @Column(name = "fullname", columnDefinition = "NVARCHAR(255)")
    private String fullName;
    @NotBlank(message = "Mật khẩu không được để trống.")
    @Size(min = 6, max = 72, message = "Mật khẩu phải từ 6 đến 72 ký tự.")
    @Column(name = "password", columnDefinition = "VARCHAR(255)")
    private String passWord;
    @Column(name = "avatar", columnDefinition = "NVARCHAR(255)")
    private String avatar;
    @Column(name = "roleid")
    private int roleid;
    @NotBlank(message = "Số điện thoại không được để trống.")
    @Pattern(regexp = "^[0-9]{9,11}$", message = "Số điện thoại phải gồm 9 đến 11 chữ số.")
    @Column(name = "phone", columnDefinition = "NVARCHAR(255)")
    private String phone;
    @Column(name = "createdDate")
    private Date createdDate;
    public User() {
    }
    public User(String email, String userName, String fullName, String passWord, String avatar, int roleid, String phone, Date createdDate) {
        this.email=email;
        this.userName=userName;
        this.fullName=fullName;
        this.passWord=passWord;
        this.avatar=avatar;
        this.roleid=roleid;
        this.phone=phone;
        this.createdDate=createdDate;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id=id;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email=email;
    }
    public String getUserName() {
        return userName;
    }
    public void setUserName(String v) {
        this.userName=v;
    }
    public String getFullName() {
        return fullName;
    }
    public void setFullName(String v) {
        this.fullName=v;
    }
    public String getPassWord() {
        return passWord;
    }
    public void setPassWord(String v) {
        this.passWord=v;
    }
    public String getAvatar() {
        return avatar;
    }
    public void setAvatar(String v) {
        this.avatar=v;
    }
    public int getRoleid() {
        return roleid;
    }
    public void setRoleid(int v) {
        this.roleid=v;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String v) {
        this.phone=v;
    }
    public Date getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(Date v) {
        this.createdDate=v;
    }
}
