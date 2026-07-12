package cn.allab.airadar.api.product;

public record Product(
        long id,
        String vendor,
        String name,
        String websiteUrl,
        boolean favorite
) {
}