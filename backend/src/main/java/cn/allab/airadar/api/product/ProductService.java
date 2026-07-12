package cn.allab.airadar.api.product;

import org.springframework.http.HttpStatus;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Transactional(readOnly = true)
    public List<Product> findAll() {
        return productRepository.findAll(Sort.by(Sort.Direction.ASC, "id")).stream()
                .map(this::toProduct)
                .toList();
    }

    public Product create(CreateProductRequest request) {
        ProductEntity entity = new ProductEntity(
                request.vendor().trim(),
                request.name().trim(),
                request.websiteUrl().trim()
        );
        return toProduct(productRepository.save(entity));
    }

    public Product toggleFavorite(long id) {
        ProductEntity entity = findEntity(id);
        entity.toggleFavorite();
        return toProduct(entity);
    }

    public void delete(long id) {
        productRepository.delete(findEntity(id));
    }

    private ProductEntity findEntity(long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
    }

    private Product toProduct(ProductEntity entity) {
        return new Product(
                entity.getId(),
                entity.getVendor(),
                entity.getName(),
                entity.getWebsiteUrl(),
                entity.isFavorite()
        );
    }
}
