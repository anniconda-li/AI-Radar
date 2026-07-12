package cn.allab.airadar.api.catalog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProviderRepository extends JpaRepository<ProviderEntity, Long> {
    List<ProviderEntity> findByStatusOrderBySortOrderAsc(String status);

    Optional<ProviderEntity> findBySlugAndStatus(String slug, String status);
}
