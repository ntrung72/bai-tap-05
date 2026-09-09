package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Category;
import vn.iotstar.repository.CategoryRepository;
import vn.iotstar.repository.ProductRepository;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository categories;
    private final ProductRepository products;
    public CategoryServiceImpl(CategoryRepository categories, ProductRepository products) {
        this.categories=categories;
        this.products=products;
    }
    public Category save(Category c) {
        return categories.save(c);
    }
    @Transactional(readOnly=true)
    public Optional<Category> findById(int id) {
        return categories.findById(id);
    }
    @Transactional(readOnly=true)
    public List<Category> findAll() {
        return categories.findAll();
    }
    @Transactional(readOnly=true)
    public Page<Category> findAll(Pageable p) {
        return categories.findAll(p);
    }
    @Transactional(readOnly=true)
    public Page<Category> findByNameContaining(String k, Pageable p) {
        return categories.findByNameContaining(k,p);
    }
    @Transactional(readOnly=true)
    public Optional<Category> findByName(String n) {
        return categories.findByNameIgnoreCase(n);
    }
    public void deleteById(int id) {
        if(products.existsByCategoryId(id)) throw new IllegalStateException("Không thể xóa danh mục đang chứa sản phẩm!");
        categories.deleteById(id);
    }
    @Transactional(readOnly=true)
    public long count() {
        return categories.count();
    }
}
