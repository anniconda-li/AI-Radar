package cn.allab.airadar.api.catalog;

import java.util.List;

public record ProviderResponse(
        String slug,
        String name,
        String englishName,
        String logoUrl,
        String logoAlt,
        String description,
        String introduction,
        List<String> categories,
        String accent,
        String aura,
        String officialUrl,
        String docsUrl,
        String sourceUpdated,
        List<ProductResponse> products,
        List<SourceLinkResponse> sourceLinks,
        List<ModelResponse> models,
        List<String> highlights
) {
    public record ProductResponse(
            String name,
            String type,
            String description,
            String url,
            List<String> platforms
    ) {
    }

    public record SourceLinkResponse(String label, String url) {
    }

    public record ModelResponse(String name, String ability, String context, String pricing) {
    }
}
