LOAD spatial;

CREATE TABLE liquor_sales AS SELECT * FROM 'data\iowa_liquor_sales.csv';

SELECT * FROM liquor_sales LIMIT 10;

describe liquor_sales;

FROM liquor_sales SELECT "Store Location";

-- This line uses regex to match the pattern of the coordinates in the column

--FROM liquor_sales SELECT regexp_extract("Store Location", '\(.*\)', 0) AS coordinates;

-- This excerpt uses a function that slice the string and locate the target substring
-- In this case, we want the coordinates within the complete string

SELECT
        "Store Location",
        SUBSTRING(
            "Store Location",
            POSITION('(' IN "Store Location") + 1,
            POSITION(')' IN "Store Location") - POSITION('(' IN "Store Location") - 1
        ) AS coordinates
    FROM liquor_sales;

ALTER TABLE liquor_sales ADD COLUMN coordinates STRING;


-- Step 1: Add New Columns to the liquor_sales Table
ALTER TABLE liquor_sales
ADD COLUMN X NUMERIC;

ALTER TABLE liquor_sales
ADD COLUMN Y NUMERIC;

-- Step 2: Extract, Convert, and Update the liquor_sales Table
WITH coordinates_extracted AS (
    SELECT
        "Store Location",
        SUBSTRING(
            "Store Location",
            POSITION('(' IN "Store Location") + 1,
            POSITION(')' IN "Store Location") - POSITION('(' IN "Store Location") - 1
        ) AS coordinates
    FROM liquor_sales
),

x_y_extracted AS (
    SELECT
        "Store Location",
        coordinates,
        SUBSTRING(coordinates, 1, POSITION(', ' IN coordinates) - 1) AS X,
        SUBSTRING(coordinates, POSITION(', ' IN coordinates) + 2) AS Y
    FROM coordinates_extracted
),

x_y_converted AS (
    SELECT
        "Store Location",
        CASE
            WHEN X IS NOT NULL AND X != '' AND X ~ '^-?[0-9]*\.?[0-9]+$' THEN CAST(X AS NUMERIC)
            ELSE NULL
        END AS X,
        CASE
            WHEN Y IS NOT NULL AND Y != '' AND Y ~ '^-?[0-9]*\.?[0-9]+$' THEN CAST(Y AS NUMERIC)
            ELSE NULL
        END AS Y
    FROM x_y_extracted
)

UPDATE liquor_sales

SET X = x_y_converted.X,
    Y = x_y_converted.Y

FROM x_y_converted;

SELECT ST_Point(X, Y) as points from liquor_sales;