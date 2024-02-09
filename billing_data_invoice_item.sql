CREATE TABLE `ae-hiring-challenge-project1.billing_data.invoice_item_save` 
AS 
SELECT * 
FROM `ae-hiring-challenge-project1.billing_data.invoice_item`;

DROP TABLE `ae-hiring-challenge-project1.billing_data.invoice_item`;

CREATE OR REPLACE TABLE `ae-hiring-challenge-project1.billing_data.invoice_item`
PARTITION BY DATE(_synced)
AS
SELECT *
FROM `ae-hiring-challenge-project1.billing_data.invoice_item_save`;

DROP TABLE `ae-hiring-challenge-project1.billing_data.invoice_item_save`;