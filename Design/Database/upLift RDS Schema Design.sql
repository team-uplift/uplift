CREATE TABLE `users` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `cognito_id` uuid,
  `email` varchar(320),
  `recipient` boolean NOT NULL,
  `created_at` timestamp(3) NOT NULL,
  `deleted` boolean NOT NULL DEFAULT false
);

CREATE TABLE `recipients` (
  `id` integer PRIMARY KEY,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `street_address1` nvarchar(255),
  `street_address2` nvarchar(255),
  `city` nvarchar(255),
  `state` char(2),
  `zip_code` varchar(10),
  `last_about_me` text NOT NULL,
  `last_reason_for_help` text NOT NULL,
  `form_questions` json NOT NULL,
  `image_url` varchar(512),
  `identity_last_verified` timestamp(3),
  `income_last_verified` timestamp(3),
  `nickname` nvarchar(64),
  `tags_last_generated_at` timestamp(3),
  `created_at` timestamp(3) NOT NULL,
  `last_donation_timestamp` timestamp(3)
);

CREATE TABLE `donors` (
  `id` integer PRIMARY KEY,
  `nickname` nvarchar(64),
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `donor_sessions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer NOT NULL,
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `donations` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_id` integer NOT NULL,
  `recipient_id` integer NOT NULL,
  `amount` integer NOT NULL,
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `tags` (
  `tag_name` varchar(64) PRIMARY KEY,
  `category` varchar(128),
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `messages` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donation_id` integer NOT NULL,
  `message` text NOT NULL,
  `donor_read` boolean NOT NULL,
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `donor_prompts` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `donor_session_id` integer NOT NULL,
  `prompt` text NOT NULL,
  `created_at` timestamp(3) NOT NULL
);

CREATE TABLE `recipient_tags` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `tag_name` varchar(64) NOT NULL,
  `recipient_id` integer NOT NULL,
  `weight` double,
  `selected` boolean NOT NULL,
  `added_at` timestamp(3) NOT NULL
);

CREATE TABLE `donor_shown_tags` (
  `tag_name` varchar(64),
  `donor_session_id` integer,
  PRIMARY KEY (`tag_name`, `donor_session_id`)
);

CREATE TABLE `donor_selected_tags` (
  `tag_name` varchar(64),
  `donor_session_id` integer,
  PRIMARY KEY (`tag_name`, `donor_session_id`)
);

CREATE TABLE `favorite_recipients` (
  `donor_id` integer,
  `recipient_id` integer,
  PRIMARY KEY (`donor_id`, `recipient_id`)
);

CREATE UNIQUE INDEX `UQ_users_cognito_id` ON `users` (`cognito_id`);

CREATE UNIQUE INDEX `UQ_recipient_tags_recipient_id_tag_name` ON `recipient_tags` (`recipient_id`, `tag_name`);

ALTER TABLE `recipients` ADD CONSTRAINT `FK_recipients_user` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

ALTER TABLE `donors` ADD CONSTRAINT `FK_donors_user` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

ALTER TABLE `donations` ADD CONSTRAINT `FK_donations_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `donations` ADD CONSTRAINT `FK_donations_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `messages` ADD CONSTRAINT `FK_messages_donation` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`id`);

ALTER TABLE `donor_sessions` ADD CONSTRAINT `FK_donor_sessions_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `donor_prompts` ADD CONSTRAINT `FK_donor_prompts_donor_session` FOREIGN KEY (`donor_session_id`) REFERENCES `donor_sessions` (`id`);

ALTER TABLE `recipient_tags` ADD CONSTRAINT `FK_recipient_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `recipient_tags` ADD CONSTRAINT `FK_recipient_tags_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `donor_shown_tags` ADD CONSTRAINT `FK_donor_shown_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `donor_shown_tags` ADD CONSTRAINT `FK_donor_shown_tags_donor_session` FOREIGN KEY (`donor_session_id`) REFERENCES `donor_sessions` (`id`);

ALTER TABLE `donor_selected_tags` ADD CONSTRAINT `FK_donor_selected_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `donor_selected_tags` ADD CONSTRAINT `FK_donor_selected_tags_donor_session` FOREIGN KEY (`donor_session_id`) REFERENCES `donor_sessions` (`id`);

ALTER TABLE `favorite_recipients` ADD CONSTRAINT `FK_favorite_recipients_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `favorite_recipients` ADD CONSTRAINT `FK_favorite_recipients_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);
