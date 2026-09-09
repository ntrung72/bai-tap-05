package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import vn.iotstar.entity.Product;

public interface ProductService {
    Product save(Product p);
    Optional<Product> findById(int id);
    List<Product> findAll();
    List<Product> findPage(int page,int size);
    List<Product> latest(int limit);
    long count();
    void deleteById(int id);
}
