package cn.allab.airadar.api.catalog;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/providers")
public class CatalogController {

    private final CatalogService catalogService;

    public CatalogController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping
    public List<ProviderResponse> findAll() {
        return catalogService.findAll();
    }

    @GetMapping("/{slug}")
    public ProviderResponse findBySlug(@PathVariable String slug) {
        return catalogService.findBySlug(slug);
    }

    @GetMapping("/{slug}/offerings/{index}/article")
    public ArticleResponse findArticle(@PathVariable String slug, @PathVariable int index) {
        return catalogService.findArticle(slug, index);
    }
}
