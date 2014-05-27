-- Function: generate_report_states(integer, integer, integer, integer)

-- DROP FUNCTION generate_report_states(integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION generate_report_states(IN product_offset integer, IN state_offset integer, IN categoryid integer, IN age_rangeid integer)
  RETURNS TABLE(state_name text, product_name text, sales bigint) AS
$BODY$

DECLARE 
age_lower integer := (SELECT lower_limit FROM agerange WHERE rangeid = age_rangeid);
age_upper integer := (SELECT upper_limit FROM agerange WHERE rangeid = age_rangeid);
--implementing check for Next20states button only. Next10products button is supposed to show up all the time
new_state_offset integer := state_offset+20;
new_product_offset integer := product_offset+10;
exist_more_states integer :=0;

BEGIN

CREATE TEMP TABLE top20states(
    id              INTEGER,
    name            TEXT,
    
    sales	    INTEGER,
    state_sort_id    INTEGER,
    product_sort_id INTEGER
);

CREATE TEMP TABLE top10products(
    id              INTEGER,
    name            TEXT,
    sales	    INTEGER,
    state_sort_id    INTEGER,
    product_sort_id INTEGER
);


INSERT INTO top20states
SELECT top20.*, SUM(S.price*S.quantity) AS sales, 1 AS state_sort_id, 0 AS product_sort_id
FROM
(SELECT DISTINCT St.id, St.name
FROM states St
LEFT JOIN users U
ON U.state = St.name
LEFT JOIN sales S
ON U.id = S.uid
LEFT JOIN products P
ON P.id = S.pid
WHERE (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR (P.cid = categoryid))
--GROUP BY St.id, St.name
ORDER BY St.name ASC
OFFSET state_offset
LIMIT 20
)AS top20
LEFT JOIN users U
ON top20.name = U.state
LEFT JOIN sales S
ON U.id = S.uid
GROUP BY top20.id, top20.name
ORDER BY top20.name ASC;

PERFORM DISTINCT St.name
FROM states St
LEFT JOIN users U
ON U.state = St.name
LEFT JOIN sales S
ON U.id = S.uid
LEFT JOIN products P
ON P.id = S.pid
WHERE (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR (P.cid = categoryid))
ORDER BY St.name ASC
OFFSET new_state_offset
LIMIT 1;

GET DIAGNOSTICS exist_more_states = ROW_COUNT;

INSERT INTO top10products
SELECT top10.id, top10.name, SUM(S.price*S.quantity) AS sales, 0 AS user_sort_id, 1 AS product_sort_id
FROM 
(SELECT DISTINCT P.id, P.name, P.cid
FROM products P
LEFT JOIN sales S
ON P.id = S.pid
LEFT JOIN users U
ON S.uid = U.id
WHERE (categoryid = -1 OR P.cid = categoryid)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
ORDER BY P.name ASC
OFFSET product_offset
LIMIT 10
)AS top10
LEFT JOIN sales S
ON top10.id = S.pid
GROUP BY top10.id, top10.name
ORDER BY top10.name ASC;


RETURN QUERY
SELECT t.state_name, t.product_name, t.sales
FROM 
(
SELECT CASE WHEN (exist_more_states = 1) THEN CAST(new_state_offset AS TEXT) ELSE CAST(0 AS TEXT) END AS state_name, CAST(new_product_offset AS TEXT) AS product_name, 0 AS sales, 0  AS state_sort_id, 0 AS product_sort_id
UNION
SELECT St.name AS state_name, P.name AS product_name, COALESCE(SUM(S.price*S.quantity),0) AS sales, 1 AS state_sort_id, 1 AS product_sort_id
FROM top20states St
CROSS JOIN top10products P
LEFT JOIN users U
ON St.name = U.state
LEFT JOIN sales S
ON (P.id = S.pid AND U.id = S.uid)
GROUP BY St.name, P.name
UNION
SELECT t20s.name AS state_name, 'all' AS product_name, t20s.sales AS sales, t20s.state_sort_id,  t20s.product_sort_id
FROM top20states t20s
UNION
SELECT 'all' AS state_name, t10p.name AS product_name, t10p.sales AS sales, t10p.state_sort_id,  t10p.product_sort_id
FROM top10products t10p
) AS t
ORDER BY t.state_sort_id, t.state_name, t.product_sort_id, t.product_name;


drop table top20states;
drop table top10products;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION generate_report_states(integer, integer, integer, integer)
  OWNER TO postgres;
