CREATE TABLE providers (
    id BIGINT NOT NULL AUTO_INCREMENT,
    slug VARCHAR(64) NOT NULL,
    name VARCHAR(100) NOT NULL,
    english_name VARCHAR(150),
    display_name VARCHAR(150) NOT NULL,
    summary VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    logo_url VARCHAR(1000),
    accent_color CHAR(7),
    categories JSON,
    official_url VARCHAR(1000) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    sort_order INT NOT NULL DEFAULT 0,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_providers_slug (slug),
    KEY idx_providers_status_sort (status, sort_order)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE offerings (
    id BIGINT NOT NULL AUTO_INCREMENT,
    provider_id BIGINT NOT NULL,
    slug VARCHAR(80) NOT NULL,
    name VARCHAR(150) NOT NULL,
    offering_type VARCHAR(50) NOT NULL,
    summary VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    official_url VARCHAR(1000) NOT NULL,
    platforms JSON,
    capabilities JSON,
    pricing_mode VARCHAR(32) NOT NULL,
    requires_install BOOLEAN NOT NULL DEFAULT FALSE,
    requires_account BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    sort_order INT NOT NULL DEFAULT 0,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_offerings_provider_slug (provider_id, slug),
    KEY idx_offerings_provider_type_sort (provider_id, offering_type, sort_order),
    CONSTRAINT fk_offerings_provider
        FOREIGN KEY (provider_id) REFERENCES providers (id)
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE ai_models (
    id BIGINT NOT NULL AUTO_INCREMENT,
    provider_id BIGINT NOT NULL,
    slug VARCHAR(100) NOT NULL,
    name VARCHAR(150) NOT NULL,
    api_model_id VARCHAR(150),
    model_family VARCHAR(100),
    model_type VARCHAR(50) NOT NULL,
    summary VARCHAR(500) NOT NULL,
    modalities JSON,
    context_tokens BIGINT,
    max_output_tokens BIGINT,
    supports_thinking BOOLEAN NOT NULL DEFAULT FALSE,
    supports_tool_calls BOOLEAN NOT NULL DEFAULT FALSE,
    openai_compatible BOOLEAN NOT NULL DEFAULT FALSE,
    official_url VARCHAR(1000) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    sort_order INT NOT NULL DEFAULT 0,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_ai_models_provider_slug (provider_id, slug),
    KEY idx_ai_models_provider_type_sort (provider_id, model_type, sort_order),
    KEY idx_ai_models_api_model_id (api_model_id),
    CONSTRAINT fk_ai_models_provider
        FOREIGN KEY (provider_id) REFERENCES providers (id)
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE model_prices (
    id BIGINT NOT NULL AUTO_INCREMENT,
    model_id BIGINT NOT NULL,
    region VARCHAR(50) NOT NULL,
    currency CHAR(3) NOT NULL,
    price_kind VARCHAR(50) NOT NULL,
    amount DECIMAL(18, 8) NOT NULL,
    unit VARCHAR(80) NOT NULL,
    min_context_tokens BIGINT,
    max_context_tokens BIGINT,
    conditions VARCHAR(500),
    effective_from DATE NOT NULL,
    effective_to DATE,
    source_url VARCHAR(1000) NOT NULL,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_model_prices_model_region_effective (model_id, region, effective_from),
    CONSTRAINT fk_model_prices_model
        FOREIGN KEY (model_id) REFERENCES ai_models (id)
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE subscription_plans (
    id BIGINT NOT NULL AUTO_INCREMENT,
    offering_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    region VARCHAR(50) NOT NULL,
    currency CHAR(3) NOT NULL,
    amount DECIMAL(18, 2),
    billing_period VARCHAR(32) NOT NULL,
    quota_summary VARCHAR(500),
    restrictions TEXT,
    source_url VARCHAR(1000) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    effective_from DATE NOT NULL,
    effective_to DATE,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_subscription_plans_offering_status (offering_id, status),
    CONSTRAINT fk_subscription_plans_offering
        FOREIGN KEY (offering_id) REFERENCES offerings (id)
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE articles (
    id BIGINT NOT NULL AUTO_INCREMENT,
    provider_id BIGINT NOT NULL,
    offering_id BIGINT,
    model_id BIGINT,
    slug VARCHAR(120) NOT NULL,
    title VARCHAR(200) NOT NULL,
    summary VARCHAR(500) NOT NULL,
    article_type VARCHAR(50) NOT NULL,
    content_markdown LONGTEXT NOT NULL,
    hero_image_url VARCHAR(1000),
    source_links JSON,
    status VARCHAR(32) NOT NULL DEFAULT 'draft',
    sort_order INT NOT NULL DEFAULT 0,
    published_at TIMESTAMP NULL,
    verified_at DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_articles_provider_slug (provider_id, slug),
    KEY idx_articles_provider_status_sort (provider_id, status, sort_order),
    KEY idx_articles_offering (offering_id),
    KEY idx_articles_model (model_id),
    CONSTRAINT fk_articles_provider
        FOREIGN KEY (provider_id) REFERENCES providers (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_articles_offering
        FOREIGN KEY (offering_id) REFERENCES offerings (id)
        ON DELETE SET NULL,
    CONSTRAINT fk_articles_model
        FOREIGN KEY (model_id) REFERENCES ai_models (id)
        ON DELETE SET NULL
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
