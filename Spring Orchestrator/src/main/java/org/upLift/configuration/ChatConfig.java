package org.upLift.configuration;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatConfig {

	@Bean
	ChatClient chatClient(ChatClient.Builder builder) {
		return builder.defaultSystem("You should only respond in comma seperated tags or descriptors of the prompts.")
			.build();
	}

}
