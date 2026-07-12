package cn.allab.airadar.api.catalog;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "providers")
public class ProviderEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 64)
    private String slug;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "english_name", length = 150)
    private String englishName;

    @Column(name = "display_name", nullable = false, length = 150)
    private String displayName;

    @Column(nullable = false, length = 500)
    private String summary;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "logo_url", length = 1000)
    private String logoUrl;

    @Column(name = "accent_color", columnDefinition = "char(7)")
    private String accentColor;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "json")
    private List<String> categories;

    @Column(name = "official_url", nullable = false, length = 1000)
    private String officialUrl;

    @Column(nullable = false, length = 32)
    private String status;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    @Column(name = "verified_at", nullable = false)
    private LocalDate verifiedAt;

    protected ProviderEntity() {
    }

    public Long getId() {
        return id;
    }

    public String getSlug() {
        return slug;
    }

    public String getName() {
        return name;
    }

    public String getEnglishName() {
        return englishName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getSummary() {
        return summary;
    }

    public String getDescription() {
        return description;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public String getAccentColor() {
        return accentColor;
    }

    public List<String> getCategories() {
        return categories;
    }

    public String getOfficialUrl() {
        return officialUrl;
    }

    public LocalDate getVerifiedAt() {
        return verifiedAt;
    }
}
