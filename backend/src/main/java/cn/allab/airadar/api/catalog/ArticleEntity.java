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
import java.util.Map;

@Entity
@Table(name = "articles")
public class ArticleEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "offering_id")
    private Long offeringId;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false, length = 500)
    private String summary;

    @Column(name = "article_type", nullable = false, length = 50)
    private String articleType;

    @Column(name = "content_markdown", nullable = false, columnDefinition = "LONGTEXT")
    private String contentMarkdown;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "source_links", columnDefinition = "json")
    private List<Map<String, String>> sourceLinks;

    @Column(nullable = false, length = 32)
    private String status;

    @Column(name = "verified_at", nullable = false)
    private LocalDate verifiedAt;

    protected ArticleEntity() {
    }

    public String getTitle() {
        return title;
    }

    public String getSummary() {
        return summary;
    }

    public String getArticleType() {
        return articleType;
    }

    public String getContentMarkdown() {
        return contentMarkdown;
    }

    public List<Map<String, String>> getSourceLinks() {
        return sourceLinks;
    }

    public LocalDate getVerifiedAt() {
        return verifiedAt;
    }
}
