package vn.iotstar.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByUserName(String userName);
    Optional<User> findByEmail(String email);
    boolean existsByEmailIgnoreCase(String email);
    boolean existsByUserNameIgnoreCase(String userName);
    boolean existsByPhone(String phone);
    boolean existsByPhoneAndIdNot(String phone, int id);
    boolean existsByEmailIgnoreCaseAndIdNot(String email, int id);
    boolean existsByUserNameIgnoreCaseAndIdNot(String userName, int id);
    Page<User> findByUserNameContainingIgnoreCaseOrFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String a, String b, String c, Pageable page);
}
