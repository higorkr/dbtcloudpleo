--## Creating a backup table
CREATE TABLE billing_data.invoice_save AS
SELECT string_field_0, string_field_1 FROM `billing_data.invoice` WHERE string_field_0<>'id';

--## Dropping original table
DROP TABLE billing_data.invoice;

--## Recreating original table
CREATE TABLE billing_data.invoice 
(
invoice_id STRING OPTIONS(description = "Primary key. ID of an invoice"),
customer_id STRING OPTIONS(description = "Foreign key. ID of a customer")
) AS
SELECT string_field_0, string_field_1 FROM `billing_data.invoice_save`;

--## Dropping backup table
DROP TABLE billing_data.invoice_save;