LOAD spatial;

CREATE TABLE liquor_sales AS SELECT * FROM 'data\iowa_liquor_sales.csv';

SELECT * FROM liquor_sales LIMIT 10;

SELECT "Store Location" FROM liquor_sales LIMIT 10;

describe liquor_sales;

CREATE TABLE points_geom AS
SELECT
    *,
    CASE
        WHEN x IS NOT NULL AND y IS NOT NULL THEN ST_Point(x, y)
        ELSE NULL
    END AS geom
FROM (
    SELECT
        *,
        CASE
            WHEN SUBSTRING(coordinates, 1, POSITION(', ' IN coordinates) - 1) ~ '^-?[0-9]*\.?[0-9]+$' THEN CAST(SUBSTRING(coordinates, 1, POSITION(', ' IN coordinates) - 1) AS NUMERIC(18,7))
            ELSE NULL
        END AS y,
        CASE
            WHEN SUBSTRING(coordinates, POSITION(', ' IN coordinates) + 2) ~ '^-?[0-9]*\.?[0-9]+$' THEN CAST(SUBSTRING(coordinates, POSITION(', ' IN coordinates) + 2) AS NUMERIC(18, 7))
            ELSE NULL
        END AS x
    FROM (
        SELECT
            *,
            SUBSTRING(
                "Store Location",
                POSITION('(' IN "Store Location") + 1,
                POSITION(')' IN "Store Location") - POSITION('(' IN "Store Location") - 1
            ) AS coordinates
        FROM liquor_sales
    ) AS temp_coordinates
) AS temp_xy_converted;

-- Step 3: Add New Columns to the liquor_sales Table
ALTER TABLE points_geom DROP COLUMN x;
ALTER TABLE points_geom DROP COLUMN y;
ALTER TABLE points_geom DROP coordinates;

SELECT DISTINCT * FROM points_geom LIMIT 10;

SELECT DISTINCT COUNT(geom) from points_geom;

-- Drop rows where any column has a null value
DELETE FROM points_geom
WHERE geom IS NULL;

SELECT COUNT(geom) from points_geom;

SELECT DISTINCT ON (geom) * FROM points_geom LIMIT 10;

COPY (SELECT DISTINCT ON (geom) * FROM points_geom) TO 'test03_duck.geojson'
WITH (FORMAT GDAL, DRIVER 'GeoJSON');