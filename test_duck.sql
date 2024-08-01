LOAD spatial;

CREATE TABLE liquor_sales AS SELECT * FROM 'C:\Users\jales\OneDrive\Documentos\GitHub\liquor-distribution-problem\data\iowa_liquor_sales.csv';

SHOW liquor_sales;

describe liquor_sales;

FROM liquor_sales SELECT "Store Location";

FROM liquor_sales SELECT regexp_extract("Store Location", '\(.*\)', 0) AS coordinates;

ALTER TABLE liquor_sales ADD COLUMN coordinates STRING;
