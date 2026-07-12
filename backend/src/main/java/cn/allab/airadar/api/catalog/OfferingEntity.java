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
@Table(name = "offerings")
public class OfferingEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "provider_id", nullable = false)
    private Long providerId;

    @Column(nullable = false, length = 80)
    private String slug;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "offering_type", nullable = false, length = 50)
    private String offeringType;

    @Column(nullable = false, length = 500)
    private String summary;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "official_url", nullable = false, length = 1000)
    private String officialUrl;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "json")
    private List<String> platforms;

    @Column(name = "verified_at", nullable = false)
    private LocalDate verifiedAt;

    @Column(nullable = false, length = 32)
    private String status;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected OfferingEntity() {
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getOfferingType() {
        return offeringType;
    }

    public String getSummary() {
        return summary;
    }

    public String getOfficialUrl() {
        return officialUrl;
    }

    public List<String> getPlatforms() {
        return platforms;
    }
}
