package cn.allab.airadar.api.catalog;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferingRepository extends JpaRepository<OfferingEntity, Long> {
    List<OfferingEntity> findByProviderIdAndStatusOrderBySortOrderAsc(Long providerId, String status);
}
