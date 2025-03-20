package org.upLift.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Configuration
public class SwaggerDocumentationConfig {

    @Bean
    public OpenAPI openApi() {
        return new OpenAPI()
            .info(new Info()
                .title("upLift Orchestrator - OpenAPI 3.0")
                .description("This is the upLift's Orchestrator API that enables the UI to interact with our complex back end functionality to facilite key behaviors.   Some useful links: - [The Orchestrator repository](https://github.com/team-uplift/uplift)")
                .termsOfService("")
                .version("1.0.11")
                .license(new License()
                    .name("Apache 2.0")
                    .url("http://www.apache.org/licenses/LICENSE-2.0.html"))
                .contact(new io.swagger.v3.oas.models.info.Contact()
                    .email("todo@todo.com")));
    }

}
