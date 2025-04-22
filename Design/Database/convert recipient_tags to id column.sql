/*
   This script should be run with admin rights on the database to convert
   recipient_tags from using a composite primary key to using a single
   auto-incremented id column as the primary key.  It will handle tables
   that already include data and set the id value appropriately.

   Note that the overall upLift RDS Schema Design.sql script already includes
   the changes that are made here, so this should ONLY be run on an existing
   database generated from the previous version of the Schema SQL script.
 */

USE uplift;

SELECT * FROM recipient_tags;

-- Drop the foreign key constraint to tags, seems to be causing problems
ALTER TABLE recipient_tags DROP FOREIGN KEY FK_recipient_tags_tag;

-- First drop the primary key
ALTER TABLE recipient_tags DROP PRIMARY KEY;

-- Then add in a new id column
ALTER TABLE recipient_tags ADD COLUMN id INTEGER FIRST;

-- Now fill in the appropriate values for the new id column based on when entries were added

-- Step 1: Create a temporary table with the new sequential IDs
CREATE TEMPORARY TABLE temp_recipient_tags_ids AS
SELECT
    tag_name,
    recipient_id,
    ROW_NUMBER() OVER (ORDER BY added_at, tag_name) AS new_id
FROM recipient_tags;

-- Step 2: Update the original table using a join on the composite key
# noinspection SqlWithoutWhere
UPDATE recipient_tags rt
    JOIN temp_recipient_tags_ids tmp
    ON rt.tag_name = tmp.tag_name AND rt.recipient_id = tmp.recipient_id
SET rt.id = tmp.new_id;

-- Step 3: Drop the temporary table
DROP TEMPORARY TABLE temp_recipient_tags_ids;

-- Now make the id column an auto-incrementing PK
-- Note that this will automatically advance the next sequence number to 1 + the highest current id value
ALTER TABLE recipient_tags MODIFY id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- Add back tags FK
ALTER TABLE `recipient_tags` ADD CONSTRAINT `FK_recipient_tags_tag` FOREIGN KEY (`tag_name`) REFERENCES `tags` (`tag_name`);

CREATE UNIQUE INDEX `UQ_recipient_tags_recipient_id_tag_name` ON `recipient_tags` (`recipient_id`, `tag_name`);

SELECT * FROM recipient_tags;
