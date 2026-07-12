package cn.allab.airadar.api.catalog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AiModelRepository extends JpaRepository<AiModelEntity, Long> {
    List<AiModelEntity> findByProviderIdAndStatusOrderBySortOrderAsc(Long providerId, String status);
}
