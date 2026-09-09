package vn.iotstar.service;

import java.sql.Date;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.User;
import vn.iotstar.repository.UserRepository;

@Service
@Transactional
public class UserServiceImpl implements UserService {
    private final UserRepository users;
    public UserServiceImpl(UserRepository users) {
        this.users=users;
    }
    @Transactional(readOnly=true)
    public User login(String n,String p) {
        return users.findByUserName(n).filter(u->p.equals(u.getPassWord())).orElse(null);
    }
    public boolean register(String n,String p,String e,String f,String phone) {
        if(usernameExists(n)||emailExists(e)||phoneExists(phone))return false;
        users.save(new User(e,n,f,p,null,5,phone,new Date(System.currentTimeMillis())));
        return true;
    }
    @Transactional(readOnly=true)
    public Optional<User> findById(int id) {
        return users.findById(id);
    }
    @Transactional(readOnly=true)
    public Optional<User> findByEmail(String e) {
        return users.findByEmail(e);
    }
    public User save(User u) {
        return users.save(u);
    }
    public void deleteById(int id) {
        users.deleteById(id);
    }
    @Transactional(readOnly=true)
    public Page<User> findAll(Pageable p) {
        return users.findAll(p);
    }
    @Transactional(readOnly=true)
    public Page<User> search(String k,Pageable p) {
        return users.findByUserNameContainingIgnoreCaseOrFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(k,k,k,p);
    }
    @Transactional(readOnly=true)
    public long count() {
        return users.count();
    }
    @Transactional(readOnly=true)
    public boolean emailExists(String e) {
        return users.existsByEmailIgnoreCase(e);
    }
    @Transactional(readOnly=true)
    public boolean usernameExists(String n) {
        return users.existsByUserNameIgnoreCase(n);
    }
    @Transactional(readOnly=true)
    public boolean phoneExists(String p) {
        return users.existsByPhone(p);
    }
    @Transactional(readOnly=true)
    public boolean phoneExists(String p,int id) {
        return users.existsByPhoneAndIdNot(p,id);
    }
}
