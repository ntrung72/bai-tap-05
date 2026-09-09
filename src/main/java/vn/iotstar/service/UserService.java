package vn.iotstar.service;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.User;

public interface UserService {
    User login(String username,String password);
    boolean register(String username,String password,String email,String fullname,String phone);
    Optional<User> findById(int id);
    Optional<User> findByEmail(String email);
    User save(User u);
    void deleteById(int id);
    Page<User> findAll(Pageable p);
    Page<User> search(String keyword,Pageable p);
    long count();
    boolean emailExists(String email);
    boolean usernameExists(String username);
    boolean phoneExists(String phone);
    boolean phoneExists(String phone,int excludeId);
}
