package cn.allab.airadar.api.catalog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ArticleRepository extends JpaRepository<ArticleEntity, Long> {
    Optional<ArticleEntity> findByOfferingIdAndStatus(Long offeringId, String status);
}
