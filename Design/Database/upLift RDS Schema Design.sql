CREATE TABLE `recipients` (
  `id` integer PRIMARY KEY,
  `cognito_id` uuid NOT NULL,
  `username` integer,
  `email` varchar(255) NOT NULL,
  `last_profile_text` text NOT NULL,
  `amount_received` double,
  `income_verified` bool,
  `nickname` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `donors` (
  `id` integer PRIMARY KEY,
  `cognito_id` uuid,
  `username` varchar(255),
  `email` varchar(255) NOT NULL,
  `last_quiz_text` text NOT NULL,
  `nickname` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `donations` (
  `id` integer PRIMARY KEY,
  `donor_id` integer NOT NULL,
  `recipient_id` integer NOT NULL,
  `amount` integer NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `tags` (
  `tag_name` varchar(255) PRIMARY KEY,
  `created_at` timestamp
);

CREATE TABLE `messages` (
  `id` integer PRIMARY KEY,
  `donor_id` integer NOT NULL,
  `recipient_id` integer NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `historical_recipient_promps` (
  `id` integer PRIMARY KEY,
  `recipient_id` integer,
  `prompt` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `historical_donor_promps` (
  `id` integer PRIMARY KEY,
  `donor_id` integer,
  `prompt` text NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `last_shown_tags` (
  `tag_name` varchar(255),
  `donor_id` integer,
  `shown_at` timestamp,
  PRIMARY KEY (`tag_name`, `donor_id`)
);

CREATE TABLE `tags_recipients` (
  `tags_tag_name` varchar,
  `recipients_id` integer,
  PRIMARY KEY (`tags_tag_name`, `recipients_id`)
);

ALTER TABLE `tags_recipients` ADD FOREIGN KEY (`tags_tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `tags_recipients` ADD FOREIGN KEY (`recipients_id`) REFERENCES `recipients` (`id`);


ALTER TABLE `last_shown_tags` ADD FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

ALTER TABLE `last_shown_tags` ADD FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

CREATE TABLE `donors_recipients` (
  `donors_id` integer,
  `recipients_id` integer,
  PRIMARY KEY (`donors_id`, `recipients_id`)
);

ALTER TABLE `donors_recipients` ADD FOREIGN KEY (`donors_id`) REFERENCES `donors` (`id`);

ALTER TABLE `donors_recipients` ADD FOREIGN KEY (`recipients_id`) REFERENCES `recipients` (`id`);


ALTER TABLE `donations` ADD FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `donations` ADD FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `historical_recipient_promps` ADD FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`);

ALTER TABLE `historical_donor_promps` ADD FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`);
