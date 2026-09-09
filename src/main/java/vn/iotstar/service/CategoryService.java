package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.Category;

public interface CategoryService {
    Category save(Category category);
    Optional<Category> findById(int id);
    List<Category> findAll();
    Page<Category> findAll(Pageable page);
    Page<Category> findByNameContaining(String keyword, Pageable page);
    Optional<Category> findByName(String name);
    void deleteById(int id);
    long count();
}
