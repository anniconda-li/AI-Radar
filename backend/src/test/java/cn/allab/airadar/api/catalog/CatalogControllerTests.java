package cn.allab.airadar.api.catalog;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class CatalogControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void returnsProviderDirectoryFromDatabase() throws Exception {
        mockMvc.perform(get("/api/providers"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(6)))
                .andExpect(jsonPath("$[0].slug").value("deepseek"))
                .andExpect(jsonPath("$[0].products", hasSize(2)))
                .andExpect(jsonPath("$[0].models", hasSize(2)));
    }

    @Test
    void returnsOneProviderBySlug() throws Exception {
        mockMvc.perform(get("/api/providers/moonshot"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("月之暗面"))
                .andExpect(jsonPath("$.products", hasSize(5)));
    }

    @Test
    void returnsPublishedArticleForOffering() throws Exception {
                mockMvc.perform(get("/api/providers/moonshot/offerings/2/article"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Kimi Code：在终端里与 AI 一起完成开发任务"))
                .andExpect(jsonPath("$.contentMarkdown").isNotEmpty())
                .andExpect(jsonPath("$.sourceLinks", hasSize(3)));
    }
}
