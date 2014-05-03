--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: CSE135DB; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE "CSE135DB" IS 'Database for a Shopping Website application for CSE135 class on Online Analytics (Spring 2014 at UCSD).';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: OrderDetails; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "OrderDetails" (
    "OrderID" character varying(255) NOT NULL,
    "Quantity" integer,
    "ID" integer
);


--
-- Name: ProductCategories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "ProductCategories" (
    "ID" integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(511) NOT NULL,
    CONSTRAINT "ProductCategories_description_check" CHECK (((description)::text <> ''::text)),
    CONSTRAINT "ProductCategories_name_check" CHECK (((name)::text <> ''::text))
);


--
-- Name: ProductCategories_ID_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "ProductCategories_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ProductCategories_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "ProductCategories_ID_seq" OWNED BY "ProductCategories"."ID";


--
-- Name: Products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Products" (
    name character varying(50) NOT NULL,
    sku character(10) NOT NULL,
    price integer NOT NULL,
    "ID" integer NOT NULL,
    category integer NOT NULL,
    CONSTRAINT "Products_name_check" CHECK (((name)::text <> ''::text)),
    CONSTRAINT "Products_price_check" CHECK ((price >= 0)),
    CONSTRAINT "Products_sku_check" CHECK ((sku <> ''::bpchar))
);


--
-- Name: Products_ID_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Products_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Products_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Products_ID_seq" OWNED BY "Products"."ID";


--
-- Name: UserOrders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "UserOrders" (
    "Username" character varying(255),
    "OrderID" character varying(255) NOT NULL,
    "OrderDate" timestamp without time zone
);


--
-- Name: Users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Users" (
    name character varying(255) NOT NULL,
    role character(1) NOT NULL,
    age integer NOT NULL,
    state character varying(2) NOT NULL,
    CONSTRAINT "Users_age_check" CHECK ((age > 0)),
    CONSTRAINT "Users_age_check1" CHECK ((age < 200)),
    CONSTRAINT "Users_role_check" CHECK (((role = 'O'::bpchar) OR (role = 'U'::bpchar)))
);


--
-- Name: ID; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "ProductCategories" ALTER COLUMN "ID" SET DEFAULT nextval('"ProductCategories_ID_seq"'::regclass);


--
-- Name: ID; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Products" ALTER COLUMN "ID" SET DEFAULT nextval('"Products_ID_seq"'::regclass);


--
-- Name: PK_UserOrders; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "UserOrders"
    ADD CONSTRAINT "PK_UserOrders" PRIMARY KEY ("OrderID");


--
-- Name: ProductCategories_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "ProductCategories"
    ADD CONSTRAINT "ProductCategories_name_key" UNIQUE (name);


--
-- Name: ProductCategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "ProductCategories"
    ADD CONSTRAINT "ProductCategories_pkey" PRIMARY KEY ("ID");


--
-- Name: Products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY ("ID");


--
-- Name: Products_sku_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Products"
    ADD CONSTRAINT "Products_sku_key" UNIQUE (sku);


--
-- Name: Users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (name);


--
-- Name: fki_user_owner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_user_owner ON "ProductCategories" USING btree (name);


--
-- Name: OrderDetails_OrderID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "OrderDetails"
    ADD CONSTRAINT "OrderDetails_OrderID_fkey" FOREIGN KEY ("OrderID") REFERENCES "UserOrders"("OrderID");


--
-- Name: Products_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Products"
    ADD CONSTRAINT "Products_category_fkey" FOREIGN KEY (category) REFERENCES "ProductCategories"("ID");


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

