package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Product;
import vn.iotstar.repository.ProductRepository;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {
    private final ProductRepository repository;
    public ProductServiceImpl(ProductRepository repository) {
        this.repository=repository;
    }
    public Product save(Product p) {
        return repository.save(p);
    }
    @Transactional(readOnly=true)
    public Optional<Product> findById(int id) {
        return repository.findById(id);
    }
    @Transactional(readOnly=true)
    public List<Product> findAll() {
        return repository.findAllByOrderByIdDesc();
    }
    @Transactional(readOnly=true)
    public List<Product> findPage(int page,int size) {
        return repository.findAllByOrderByIdDesc(PageRequest.of(Math.max(0,page-1),size));
    }
    @Transactional(readOnly=true)
    public List<Product> latest(int limit) {
        return repository.findAllByOrderByIdDesc(PageRequest.of(0,limit));
    }
    @Transactional(readOnly=true)
    public long count() {
        return repository.count();
    }
    public void deleteById(int id) {
        repository.deleteById(id);
    }
}
