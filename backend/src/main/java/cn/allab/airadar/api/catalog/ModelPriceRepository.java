package cn.allab.airadar.api.catalog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ModelPriceRepository extends JpaRepository<ModelPriceEntity, Long> {
    List<ModelPriceEntity> findByModelIdOrderByIdAsc(Long modelId);
}
