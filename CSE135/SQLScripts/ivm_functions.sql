DROP FUNCTION insert_sales(integer, integer, integer, integer, text, integer);

CREATE OR REPLACE FUNCTION insert_sales(IN p_uid integer, IN p_pid integer, IN p_quantity integer, IN p_price integer, IN p_state text, IN p_cid integer)
returns integer  as $$
DECLARE 

BEGIN
	-- insert in sales tables
	INSERT INTO sales("uid", "pid", "quantity", "price") VALUES (p_uid, p_pid, p_quantity, p_price);
	
	-- update IVM tables
	UPDATE pre_customers_cat SET sales=sales + (p_quantity*p_price)	WHERE "uid"=p_uid AND "cid"=p_cid;
	IF NOT FOUND THEN
		INSERT INTO pre_customers_cat ("uid", "cid", "sales", "state") VALUES (p_uid, p_cid, p_quantity*p_price, p_state);
	END IF;
	
	UPDATE pre_customers SET sales=sales + (p_quantity*p_price) WHERE "uid"=p_uid;
	IF NOT FOUND THEN
		INSERT INTO pre_customers ("uid", "sales", "state") VALUES (p_uid, p_quantity*p_price, p_state);
	END IF;
	
	UPDATE pre_states SET sales=sales + (p_quantity*p_price) WHERE "state"=p_state AND "cid"=p_cid;
	IF NOT FOUND THEN
		INSERT INTO pre_states ("state", "cid", "sales") VALUES (p_state, p_cid, p_quantity*p_price);
	END IF;
	
	UPDATE pre_products SET sales=sales + (p_quantity*p_price) WHERE "pid"=p_pid AND "state"=p_state AND "cid"=p_cid;
	IF NOT FOUND THEN
		INSERT INTO pre_products ("pid", "state", "cid", "sales") VALUES (p_pid, p_state, p_cid, p_quantity*p_price);
	END IF;
	
	UPDATE pre_customers_products SET sales=sales + (p_quantity*p_price) WHERE "uid" = p_uid AND "pid"=p_pid;
	IF NOT FOUND THEN
		INSERT INTO pre_customers_products ("uid", "pid", "sales") VALUES (p_uid, p_pid, p_quantity*p_price);
	END IF;
	
	RETURN (SELECT 1);
END;
$$ language plpgsql;
  