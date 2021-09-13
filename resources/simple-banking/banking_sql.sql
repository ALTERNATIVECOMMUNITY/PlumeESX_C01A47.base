CREATE TABLE IF NOT EXISTS `banking_access` (
    `id` int NOT NULL AUTO_INCREMENT,
    `owner_identifier` text NOT NULL,
    `target_identifier` text NOT NULL,
    `owner_name` text NOT NULL,
    `target_name` text NOT NULL,
    `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

CREATE TABLE IF NOT EXISTS `transaction_history` (
    `id` int NOT NULL AUTO_INCREMENT,
    `identifier` text NOT NULL,
    `trans_id` int NOT NULL,
    `account` text NOT NULL,
    `amount` int NOT NULL,
    `trans_type` text NOT NULL,
    `receiver` text NOT NULL,
    `message` text NOT NULL,
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1;