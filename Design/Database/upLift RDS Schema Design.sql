CREATE TABLE `recipients` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `cognito_id` uuid NOT NULL,
  `email` varchar(320) UNIQUE NOT NULL,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `street_address1` nvarchar(255),
  `street_address2` nvarchar(255),
  `city` nvarchar(255),
  `state` char(2),
  `zip_code` varchar(10),
  `last_about_me` text NOT NULL,
  `last_reason_for_help` text NOT NULL,
  `identity_last_verified` timestamp,
  `income_last_verified` timestamp,
  `nickname` nvarchar(64),
  `created_at` timestamp
);

CREATE TABLE `donors` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `cognito_id` uuid,
  `email` varchar(320),
  `nickname` nvarchar(64),
  `created_at` timestamp
);

CREATE TABLE `donor_sessions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer NOT NULL,
  `session_started` timestamp
);

CREATE TABLE `donations` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer NOT NULL,
  `recipient_id` integer NOT NULL,
  `amount` integer NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `tags` (
  `tag_name` varchar(64) PRIMARY KEY,
  `created_at` timestamp
);

CREATE TABLE `messages` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer NOT NULL,
  `recipient_id` integer NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `historical_recipient_prompts` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `recipient_id` integer,
  `prompt` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `historical_donor_prompts` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer,
  `prompt` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `recipient_tags` (
  `tag_name` varchar(64),
  `recipient_id` integer,
  PRIMARY KEY (`tag_name`, `recipient_id`)
);

CREATE TABLE `last_shown_tags` (
  `tag_name` varchar(64),
  `donor_session_id` integer,
  PRIMARY KEY (`tag_name`, `donor_session_id`)
);

CREATE TABLE `last_selected_tags` (
  `tag_name` varchar(64),
  `donor_session_id` integer,
  PRIMARY KEY (`tag_name`, `donor_session_id`)
);

CREATE TABLE `favorite_recipients` (
  `donor_id` integer,
  `recipient_id` integer,
  PRIMARY KEY (`donor_id`, `recipient_id`)
);

ALTER TABLE `donations` ADD CONSTRAINT `FK_donations_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `donations` ADD CONSTRAINT `FK_donations_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `messages` ADD CONSTRAINT `FK_messages_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `messages` ADD CONSTRAINT `FK_messages_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `historical_recipient_prompts` ADD CONSTRAINT `FK_historical_recipient_prompts_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `historical_donor_prompts` ADD CONSTRAINT `FK_historical_donor_prompts_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `recipient_tags` ADD CONSTRAINT `FK_recipient_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `recipient_tags` ADD CONSTRAINT `FK_recipient_tags_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `last_shown_tags` ADD CONSTRAINT `FK_last_shown_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `last_shown_tags` ADD CONSTRAINT `FK_last_shown_tags_donor_session` FOREIGN KEY (`donor_session_id`) REFERENCES `donor_sessions` (`id`);

ALTER TABLE `last_selected_tags` ADD CONSTRAINT `FK_last_selected_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `last_selected_tags` ADD CONSTRAINT `FK_last_shown_tags_donor_session` FOREIGN KEY (`donor_session_id`) REFERENCES `donor_sessions` (`id`);

ALTER TABLE `favorite_recipients` ADD CONSTRAINT `FK_favorite_recipients_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `favorite_recipients` ADD CONSTRAINT `FK_favorite_recipients_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);
