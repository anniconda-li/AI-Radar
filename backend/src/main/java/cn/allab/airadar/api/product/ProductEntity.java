package cn.allab.airadar.api.product;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "products")
public class ProductEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String vendor;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "website_url", nullable = false, length = 500)
    private String websiteUrl;

    @Column(nullable = false)
    private boolean favorite;

    protected ProductEntity() {
    }

    public ProductEntity(String vendor, String name, String websiteUrl) {
        this.vendor = vendor;
        this.name = name;
        this.websiteUrl = websiteUrl;
    }

    public Long getId() {
        return id;
    }

    public String getVendor() {
        return vendor;
    }

    public String getName() {
        return name;
    }

    public String getWebsiteUrl() {
        return websiteUrl;
    }

    public boolean isFavorite() {
        return favorite;
    }

    public void toggleFavorite() {
        favorite = !favorite;
    }
}
