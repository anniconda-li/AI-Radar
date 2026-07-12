package cn.allab.airadar.api.catalog;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class CatalogService {

    private static final String ACTIVE = "active";

    private final ProviderRepository providerRepository;
    private final OfferingRepository offeringRepository;
    private final AiModelRepository aiModelRepository;
    private final ModelPriceRepository modelPriceRepository;
    private final ArticleRepository articleRepository;

    public CatalogService(
            ProviderRepository providerRepository,
            OfferingRepository offeringRepository,
            AiModelRepository aiModelRepository,
            ModelPriceRepository modelPriceRepository,
            ArticleRepository articleRepository
    ) {
        this.providerRepository = providerRepository;
        this.offeringRepository = offeringRepository;
        this.aiModelRepository = aiModelRepository;
        this.modelPriceRepository = modelPriceRepository;
        this.articleRepository = articleRepository;
    }

    @Transactional(readOnly = true)
    public List<ProviderResponse> findAll() {
        return providerRepository.findByStatusOrderBySortOrderAsc(ACTIVE).stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public ProviderResponse findBySlug(String slug) {
        ProviderEntity provider = providerRepository.findBySlugAndStatus(slug, ACTIVE)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Provider not found"));
        return toResponse(provider);
    }

    @Transactional(readOnly = true)
    public ArticleResponse findArticle(String providerSlug, int offeringIndex) {
        if (offeringIndex < 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Article not found");
        }
        ProviderEntity provider = providerRepository.findBySlugAndStatus(providerSlug, ACTIVE)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Provider not found"));
        List<OfferingEntity> offerings = offeringRepository
                .findByProviderIdAndStatusOrderBySortOrderAsc(provider.getId(), ACTIVE);
        if (offeringIndex >= offerings.size()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Offering not found");
        }
        ArticleEntity article = articleRepository
                .findByOfferingIdAndStatus(offerings.get(offeringIndex).getId(), "published")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Article not found"));

        List<ArticleResponse.SourceLink> sourceLinks = article.getSourceLinks() == null
                ? List.of()
                : article.getSourceLinks().stream()
                .map(source -> new ArticleResponse.SourceLink(source.get("label"), source.get("url")))
                .toList();
        return new ArticleResponse(
                article.getTitle(),
                article.getSummary(),
                article.getArticleType(),
                article.getContentMarkdown(),
                sourceLinks,
                article.getVerifiedAt().toString()
        );
    }

    private ProviderResponse toResponse(ProviderEntity provider) {
        List<OfferingEntity> offerings = offeringRepository
                .findByProviderIdAndStatusOrderBySortOrderAsc(provider.getId(), ACTIVE);
        List<AiModelEntity> models = aiModelRepository
                .findByProviderIdAndStatusOrderBySortOrderAsc(provider.getId(), ACTIVE);

        List<ProviderResponse.ProductResponse> products = offerings.stream()
                .map(item -> new ProviderResponse.ProductResponse(
                        item.getName(),
                        item.getOfferingType(),
                        item.getSummary(),
                        item.getOfficialUrl(),
                        item.getPlatforms() == null ? List.of() : item.getPlatforms()
                ))
                .toList();

        List<ProviderResponse.ModelResponse> modelResponses = models.stream()
                .map(model -> new ProviderResponse.ModelResponse(
                        model.getName(),
                        model.getSummary(),
                        formatTokens(model.getContextTokens()),
                        formatPrice(modelPriceRepository.findByModelIdOrderByIdAsc(model.getId()))
                ))
                .toList();

        List<ProviderResponse.SourceLinkResponse> sourceLinks = new ArrayList<>();
        sourceLinks.add(new ProviderResponse.SourceLinkResponse(provider.getName() + " 官方网站", provider.getOfficialUrl()));
        offerings.stream().limit(4).forEach(item -> sourceLinks.add(
                new ProviderResponse.SourceLinkResponse(item.getName(), item.getOfficialUrl())
        ));

        String docsUrl = offerings.stream()
                .filter(item -> "开发平台".equals(item.getOfferingType()))
                .map(OfferingEntity::getOfficialUrl)
                .findFirst()
                .orElse(provider.getOfficialUrl());
        String accent = provider.getAccentColor() == null ? "#315EFB" : provider.getAccentColor();
        List<String> categories = provider.getCategories() == null ? List.of() : provider.getCategories();

        return new ProviderResponse(
                provider.getSlug(),
                provider.getName(),
                provider.getEnglishName(),
                provider.getLogoUrl(),
                provider.getDisplayName() + " 官方标识",
                provider.getSummary(),
                provider.getDescription(),
                categories,
                accent,
                accent + "66",
                provider.getOfficialUrl(),
                docsUrl,
                provider.getVerifiedAt().toString(),
                products,
                sourceLinks,
                modelResponses,
                categories
        );
    }

    private String formatTokens(Long tokens) {
        if (tokens == null) return "以官方文档为准";
        if (tokens % 1_000_000 == 0) return (tokens / 1_000_000) + "M";
        if (tokens % 1_000 == 0) return (tokens / 1_000) + "K";
        return tokens.toString();
    }

    private String formatPrice(List<ModelPriceEntity> prices) {
        if (prices.isEmpty()) return "查看官方价格页";
        boolean tiered = prices.stream().anyMatch(price -> price.getMinContextTokens() != null)
                && prices.size() > 2;
        if (tiered) return "按上下文长度分档计价";

        ModelPriceEntity input = prices.stream()
                .filter(price -> price.getPriceKind().contains("未命中输入") || "输入".equals(price.getPriceKind()))
                .findFirst()
                .orElse(null);
        ModelPriceEntity output = prices.stream()
                .filter(price -> "输出".equals(price.getPriceKind()))
                .findFirst()
                .orElse(null);
        if (input == null || output == null) return "查看官方价格页";

        String symbol = "CNY".equals(input.getCurrency()) ? "¥" : "$";
        return "输入 " + symbol + amount(input.getAmount())
                + " / 输出 " + symbol + amount(output.getAmount())
                + "（" + input.getUnit() + "）";
    }

    private String amount(BigDecimal value) {
        return value.stripTrailingZeros().toPlainString();
    }
}
