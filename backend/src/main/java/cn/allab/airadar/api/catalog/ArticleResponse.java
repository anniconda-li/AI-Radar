package cn.allab.airadar.api.catalog;

import java.util.List;

public record ArticleResponse(
        String title,
        String summary,
        String articleType,
        String contentMarkdown,
        List<SourceLink> sourceLinks,
        String verifiedAt
) {
    public record SourceLink(String label, String url) {
    }
}
