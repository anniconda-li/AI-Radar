package cn.allab.airadar.api.catalog;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ai_models")
public class AiModelEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "provider_id", nullable = false)
    private Long providerId;

    @Column(nullable = false, length = 100)
    private String slug;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "model_type", nullable = false, length = 50)
    private String modelType;

    @Column(nullable = false, length = 500)
    private String summary;

    @Column(name = "context_tokens")
    private Long contextTokens;

    @Column(name = "official_url", nullable = false, length = 1000)
    private String officialUrl;

    @Column(nullable = false, length = 32)
    private String status;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected AiModelEntity() {
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getModelType() {
        return modelType;
    }

    public String getSummary() {
        return summary;
    }

    public Long getContextTokens() {
        return contextTokens;
    }

    public String getOfficialUrl() {
        return officialUrl;
    }
}
