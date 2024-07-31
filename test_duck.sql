LOAD spatial;

CREATE TABLE liquor_sales AS SELECT * FROM 'C:\Users\jales\OneDrive\Documentos\GitHub\liquor-distribution-problem\data\iowa_liquor_sales.csv';

SHOW liquor_sales;

describe liquor_sales;

SELECT "Store Location" from liquor_sales;

