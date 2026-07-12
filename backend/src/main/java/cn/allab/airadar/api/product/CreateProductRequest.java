package cn.allab.airadar.api.product;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateProductRequest(
        @NotBlank @Size(max = 100) String vendor,
        @NotBlank @Size(max = 100) String name,
        @NotBlank @Size(max = 500) String websiteUrl
) {
}
