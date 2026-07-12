package cn.allab.airadar.api.catalog;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "model_prices")
public class ModelPriceEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "model_id", nullable = false)
    private Long modelId;

    @Column(nullable = false, columnDefinition = "char(3)")
    private String currency;

    @Column(name = "price_kind", nullable = false, length = 50)
    private String priceKind;

    @Column(nullable = false, precision = 18, scale = 8)
    private BigDecimal amount;

    @Column(nullable = false, length = 80)
    private String unit;

    @Column(name = "min_context_tokens")
    private Long minContextTokens;

    @Column(name = "max_context_tokens")
    private Long maxContextTokens;

    protected ModelPriceEntity() {
    }

    public String getCurrency() {
        return currency;
    }

    public String getPriceKind() {
        return priceKind;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getUnit() {
        return unit;
    }

    public Long getMinContextTokens() {
        return minContextTokens;
    }

    public Long getMaxContextTokens() {
        return maxContextTokens;
    }
}
