--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

-- Started on 2021-04-18 14:05:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3099 (class 1262 OID 13442)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_Canada.1252';


ALTER DATABASE postgres OWNER TO postgres;

connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3100 (class 0 OID 0)
-- Dependencies: 3099
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 4 (class 2615 OID 25057)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 25195)
-- Name: newUserShoppingList(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."newUserShoppingList"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
INSERT INTO public.shoppinglist(
	"ListID", "ExpiryDate", "RecurringItem")
	VALUES (new."ListID", '2023-01-01', false);
	RETURN NULL;
END
$$;


ALTER FUNCTION public."newUserShoppingList"() OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 25186)
-- Name: userList(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."userList"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	INSERT INTO list ("Name", "UserID") 
	VALUES ('shoppingList', new.user_id);
	
	RETURN NULL;
END
$$;


ALTER FUNCTION public."userList"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 25058)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    "DepartmentID" integer NOT NULL,
    "Name" character(100)
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 25061)
-- Name: department_DepartmentID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.department ALTER COLUMN "DepartmentID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."department_DepartmentID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1
);


--
-- TOC entry 203 (class 1259 OID 25063)
-- Name: list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.list (
    "ListID" integer NOT NULL,
    "Name" character(50),
    "UserID" integer NOT NULL
);


ALTER TABLE public.list OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 25066)
-- Name: list_ListID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.list ALTER COLUMN "ListID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."list_ListID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 25068)
-- Name: listitems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listitems (
    "ListID" integer NOT NULL,
    "UPC" bigint NOT NULL
);


ALTER TABLE public.listitems OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 25071)
-- Name: particularproductpricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.particularproductpricing (
    "UPC" bigint NOT NULL,
    "RetailID" integer NOT NULL,
    "Price" double precision,
    "Availability" boolean
);


ALTER TABLE public.particularproductpricing OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 25074)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    "ProductID" integer NOT NULL,
    "Description" character(100),
    "DepartmentID" integer NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25077)
-- Name: product_ProductID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.product ALTER COLUMN "ProductID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."product_ProductID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1
);


--
-- TOC entry 209 (class 1259 OID 25079)
-- Name: retailcompany; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retailcompany (
    "RetailID" integer NOT NULL,
    "Name" character(100) NOT NULL,
    "Address" character(100) NOT NULL
);


ALTER TABLE public.retailcompany OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 25082)
-- Name: retailcompany_RetailID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.retailcompany ALTER COLUMN "RetailID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."retailcompany_RetailID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1
);


--
-- TOC entry 211 (class 1259 OID 25084)
-- Name: shoppinglist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shoppinglist (
    "ListID" integer NOT NULL,
    "ExpiryDate" date NOT NULL,
    "RecurringItem" boolean
);


ALTER TABLE public.shoppinglist OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25087)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(25) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 25093)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3101 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 214 (class 1259 OID 25095)
-- Name: variety; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variety (
    "ProductID" integer NOT NULL,
    "UPC" bigint NOT NULL,
    "StorageType" character(100),
    "Brand" character(100),
    "Size" character(100)
);


ALTER TABLE public.variety OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25098)
-- Name: wishlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlist (
    "ListID" integer NOT NULL,
    "DesiredPrice" double precision NOT NULL,
    "UPC" bigint NOT NULL
);


ALTER TABLE public.wishlist OWNER TO postgres;

--
-- TOC entry 2898 (class 2604 OID 25101)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3079 (class 0 OID 25058)
-- Dependencies: 201
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department ("DepartmentID", "Name") OVERRIDING SYSTEM VALUE VALUES (6, 'dairy                                                                                               ');


--
-- TOC entry 3081 (class 0 OID 25063)
-- Dependencies: 203
-- Data for Name: list; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (12, 'shoppinglist                                      ', 3);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (13, 'shoppinglist                                      ', 4);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (14, 'shoppinglist                                      ', 5);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (15, 'Christmas Wishes                                  ', 3);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (16, 'Birthday Gifts                                    ', 4);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (17, 'Retirement Party                                  ', 5);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (22, 'Red                                               ', 6);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (23, 'Rick                                              ', 6);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (28, 'shoppingList                                      ', 22);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (29, 'shoppingList                                      ', 23);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (30, 'red1234                                           ', 23);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (31, 'abcdef                                            ', 23);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (39, 'shoppingList                                      ', 31);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (40, 'shoppingList                                      ', 32);
INSERT INTO public.list ("ListID", "Name", "UserID") OVERRIDING SYSTEM VALUE VALUES (41, 'milk                                              ', 32);


--
-- TOC entry 3083 (class 0 OID 25068)
-- Dependencies: 205
-- Data for Name: listitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.listitems ("ListID", "UPC") VALUES (12, 6000100070546);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (13, 6000196397989);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (14, 6000001843796);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (15, 6000079799949);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (16, 6000079799949);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (17, 6000079799949);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (15, 6000056691117);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (16, 6000056691117);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (17, 6000056691117);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (31, 6000201423066);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (29, 6000201423066);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (41, 6000196210378);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (40, 6000201423066);
INSERT INTO public.listitems ("ListID", "UPC") VALUES (40, 6000196210378);


--
-- TOC entry 3084 (class 0 OID 25071)
-- Dependencies: 206
-- Data for Name: particularproductpricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000196210378, 1, 0.19, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000016935598, 1, 0.66, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000023804492, 1, 1.71, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000016937326, 1, 1.09, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201234475, 1, 1.57, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000020748101, 1, 0.41, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000100070546, 1, 0.29, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000196397989, 1, 0.49, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000091056750, 1, 0.22, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201734277, 1, 1.49, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201423066, 1, 4.97, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001850463, 1, 0.99, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000198861824, 1, 1.77, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843483, 1, 0.29, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000077654180, 1, 0.5, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201234784, 1, 1.57, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000075688907, 1, 0.23, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201085803, 1, 0.85, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000198861640, 1, 1.77, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000079799949, 1, 1.13, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843796, 1, 0.59, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000198860442, 1, 1.77, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001848203, 1, 0.59, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201234243, 1, 1.57, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000191270097, 1, 0.41, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843486, 1, 0.29, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000191278404, 1, 1.32, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000194056994, 1, 1.54, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000199838553, 1, 1.21, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000016948829, 1, 1.48, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000137479821, 1, 0.59, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000195508948, 1, 0.68, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000159562732, 1, 0.76, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843132, 1, 0.39, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000079337667, 1, 0.6, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000201080299, 1, 0.66, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000198860846, 1, 1.77, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000056691117, 1, 6.74, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000069571541, 1, 1.07, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843135, 1, 0.39, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001849020, 1, 0.39, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000091056539, 1, 4.17, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000198861221, 1, 2.03, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000196823263, 1, 5.47, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000077654065, 1, 0.5, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000194056994, 2, 1.39, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000159562732, 2, 3.78, false);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000191270097, 2, 0.22, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000079799949, 2, 1.13, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000191278404, 2, 3.98, false);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000001843486, 2, 1.89, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000075688907, 2, 2.38, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000077654180, 2, 4.98, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000016935598, 2, 4.98, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000069571541, 2, 2.96, true);
INSERT INTO public.particularproductpricing ("UPC", "RetailID", "Price", "Availability") VALUES (6000196823263, 2, 5.73, false);


--
-- TOC entry 3085 (class 0 OID 25074)
-- Dependencies: 207
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (5, 'coffee creamer                                                                                      ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (6, '33% whipping cream                                                                                  ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (7, 'parmesan cheese                                                                                     ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (8, 'original almond milk                                                                                ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (9, 'strawberry-banana yogurt                                                                            ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (10, 'grape-raspberry yogurt                                                                              ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (11, 'strawberry yogurt                                                                                   ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (12, 'raspberry yogurt                                                                                    ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (13, 'shredded cheese                                                                                     ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (14, 'olive oil margarine                                                                                 ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (15, 'sour cream                                                                                          ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (16, 'cherry strawberry yogurt                                                                            ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (17, 'banana yogurt                                                                                       ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (18, 'margarine                                                                                           ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (19, 'peach yogurt                                                                                        ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (20, 'mozarella cheesestring                                                                              ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (21, 'cheese slices                                                                                       ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (22, 'cream cheese                                                                                        ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (23, 'whipped cream                                                                                       ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (24, 'vanilla yogurt                                                                                      ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (25, 'unsalted butter                                                                                     ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (26, '2% skimmed milk                                                                                     ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (27, 'lactose free 2%                                                                                     ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (28, 'cresents                                                                                            ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (29, 'salted butter                                                                                       ', 6);
INSERT INTO public.product ("ProductID", "Description", "DepartmentID") OVERRIDING SYSTEM VALUE VALUES (30, 'chocolate milk                                                                                      ', 6);


--
-- TOC entry 3087 (class 0 OID 25079)
-- Dependencies: 209
-- Data for Name: retailcompany; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.retailcompany ("RetailID", "Name", "Address") OVERRIDING SYSTEM VALUE VALUES (1, 'Walmart                                                                                             ', '610 6th St, New Westminster, BC V3L 3C2                                                             ');
INSERT INTO public.retailcompany ("RetailID", "Name", "Address") OVERRIDING SYSTEM VALUE VALUES (2, 'Real Canadian Superstore                                                                            ', '1301 Lougheed Hwy, Coquitlam, BC V3K 6P9                                                            ');


--
-- TOC entry 3089 (class 0 OID 25084)
-- Dependencies: 211
-- Data for Name: shoppinglist; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (12, '2022-05-05', true);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (13, '2021-06-06', false);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (14, '2021-07-03', true);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (28, '2023-01-01', false);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (29, '2023-01-01', false);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (39, '2023-01-01', false);
INSERT INTO public.shoppinglist ("ListID", "ExpiryDate", "RecurringItem") VALUES (40, '2023-01-01', false);


--
-- TOC entry 3090 (class 0 OID 25087)
-- Dependencies: 212
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (user_id, username, password, email, name) VALUES (3, 'monke', 'password', 'monke@gmail.com', 'Monke Jim');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (4, 'Sam', 'password', 'sam@gmail.com', 'Samson');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (5, 'Roy', 'password', 'roy@gmail.com', 'roy@gmail.com');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (6, 'r1234', '$5$rounds=535000$CI7RLJYoekw9zqHQ$TMLPxQY72gVAmKD0r1VS9/XmD.bX2JBvY/XCpTVAks9', 'red@123', 'Red');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (11, 'rick123', '$5$rounds=535000$Ju21YDVUM2eyKwVB$oGdovij/HysHzwy2Stx4/YugxCLnXW.xkGXHWsXl2I4', 'ed@124', 'rick');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (12, 'rick1234', '$5$rounds=535000$DaKZMhCWTnjjZx7Y$aGgvVYKnlnqHY1jZC50JSx/P9od2WS6UbZxeDrouPfC', 'lol@1234', 'Rick');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (22, 'cena', '$5$rounds=535000$FHbrB5cDT6Nu02M2$bdWOAiW52Oq5n5FpETonG1./5fObkCMUpwpfikwXAO2', 'Cena@123', 'John');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (23, 'meme', '$5$rounds=535000$v4s.XNLdAEfoShQP$wM7NKGtvriIw3F3Bt0T8mf2Oj072tPhC/gWxAKU3pK6', 'meme@1234', 'meme ');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (31, 'eeeeeeeeee', '$5$rounds=535000$rH6TszBeNqsL9wGF$BOsHBDXRiIgN/CmeSZYJXGlHPyWmq/qqpt27W2s4GA8', 'eeeeeeeee', 'eeeeeeee');
INSERT INTO public.users (user_id, username, password, email, name) VALUES (32, 'red12345', '$5$rounds=535000$MIrfgo1v7PEZ5DhL$9q9IXq4ekwEkxNuQGSd6hN6XLRVKJQy/zZgsOWNFuR3', 'red1234', 'red');


--
-- TOC entry 3092 (class 0 OID 25095)
-- Dependencies: 214
-- Data for Name: variety; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (30, 6000196210378, 'fridge                                                                                              ', 'Dairyland                                                                                           ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (7, 6000201234475, 'fridge                                                                                              ', 'Black Diamond Old                                                                                   ', '400 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (18, 6000016935598, 'fridge                                                                                              ', 'Becel                                                                                               ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (22, 6000023804492, 'fridge                                                                                              ', 'Philadelphia Original                                                                               ', '500 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (29, 6000016937326, 'fridge                                                                                              ', 'Great Value                                                                                         ', '454 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (28, 6000020748101, 'fridge                                                                                              ', 'Phillsbury Original                                                                                 ', '235 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (27, 6000100070546, 'fridge                                                                                              ', 'Natrel                                                                                              ', '150 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (15, 6000196397989, 'fridge                                                                                              ', 'Great Value                                                                                         ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (8, 6000091056750, 'fridge                                                                                              ', 'Silk                                                                                                ', '1.89 L                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (7, 6000201734277, 'fridge                                                                                              ', 'Great Value                                                                                         ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (5, 6000201423066, 'fridge                                                                                              ', 'International Delight                                                                               ', '946 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (22, 6000001850463, 'fridge                                                                                              ', 'Great Value                                                                                         ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (13, 6000198861824, 'fridge                                                                                              ', 'Great Value                                                                                         ', '340 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (24, 6000001843483, 'fridge                                                                                              ', 'Yoplait                                                                                             ', '50 mL                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (5, 6000077654180, 'fridge                                                                                              ', 'International Delight                                                                               ', '946 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (20, 6000201234784, 'fridge                                                                                              ', 'Black Diamond                                                                                       ', '400 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (26, 6000075688907, 'fridge                                                                                              ', 'Dairyland                                                                                           ', '100 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (21, 6000201085803, 'fridge                                                                                              ', 'Black Diamond                                                                                       ', '22 slices                                                                                           ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (13, 6000198861640, 'fridge                                                                                              ', 'Great Value                                                                                         ', '200 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (25, 6000079799949, 'fridge                                                                                              ', 'Dairyland                                                                                           ', '454 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (9, 6000001843796, 'fridge                                                                                              ', 'Yop by Yoplait                                                                                      ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (13, 6000198860442, 'fridge                                                                                              ', 'Great Value                                                                                         ', '340 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (11, 6000001848203, 'fridge                                                                                              ', 'Yop by Yoplait                                                                                      ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (7, 6000201234243, 'fridge                                                                                              ', 'Black Diamond                                                                                       ', '400 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (24, 6000191270097, 'fridge                                                                                              ', 'Activia                                                                                             ', '650 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (11, 6000001843486, 'fridge                                                                                              ', 'Yoplait                                                                                             ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (23, 6000191278404, 'fridge                                                                                              ', 'Gaye Lea                                                                                            ', '225 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (22, 6000194056994, 'fridge                                                                                              ', 'Philadelphia                                                                                        ', '340 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (21, 6000199838553, 'fridge                                                                                              ', 'Kraft                                                                                               ', '22 slices                                                                                           ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (20, 6000016948829, 'fridge                                                                                              ', 'Black Diamond                                                                                       ', '16 pack                                                                                             ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (19, 6000137479821, 'fridge                                                                                              ', 'Yop by Yoplait                                                                                      ', '60 mL                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (17, 6000195508948, 'fridge                                                                                              ', 'iÖGO nanö                                                                                           ', '60 mL                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (18, 6000159562732, 'fridge                                                                                              ', 'Becel                                                                                               ', '50 mL                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (16, 6000001843132, 'fridge                                                                                              ', 'Yoplait                                                                                             ', '8*60mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (15, 6000079337667, 'fridge                                                                                              ', 'Dairyland                                                                                           ', '250  mL                                                                                             ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (14, 6000201080299, 'fridge                                                                                              ', 'Becel                                                                                               ', '250 mL                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (13, 6000198860846, 'fridge                                                                                              ', 'Great Value                                                                                         ', '300 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (12, 6000056691117, 'fridge                                                                                              ', 'iÖGO nanö                                                                                           ', '6*93 mL                                                                                             ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (11, 6000069571541, 'fridge                                                                                              ', 'Oikos                                                                                               ', '4*100 mL                                                                                            ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (10, 6000001843135, 'fridge                                                                                              ', 'Yoplait                                                                                             ', '8*60 mL                                                                                             ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (9, 6000001849020, 'fridge                                                                                              ', 'Yoplait                                                                                             ', '8*60 mL                                                                                             ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (8, 6000091056539, 'fridge                                                                                              ', 'Silk                                                                                                ', '1.89 L                                                                                              ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (7, 6000198861221, 'fridge                                                                                              ', 'Great Value                                                                                         ', '280 g                                                                                               ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (6, 6000196823263, 'fridge                                                                                              ', 'Dairyland                                                                                           ', '1 L                                                                                                 ');
INSERT INTO public.variety ("ProductID", "UPC", "StorageType", "Brand", "Size") VALUES (5, 6000077654065, 'fridge                                                                                              ', 'International Delight                                                                               ', '946 mL                                                                                              ');


--
-- TOC entry 3093 (class 0 OID 25098)
-- Dependencies: 215
-- Data for Name: wishlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (15, 12, 6000079799949);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (16, 2.03, 6000079799949);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (17, 1.02, 6000079799949);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (15, 254.64, 6000056691117);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (16, 3.24, 6000056691117);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (17, 0.2, 6000056691117);
INSERT INTO public.wishlist ("ListID", "DesiredPrice", "UPC") VALUES (41, 30.1, 6000196210378);


--
-- TOC entry 3102 (class 0 OID 0)
-- Dependencies: 202
-- Name: department_DepartmentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."department_DepartmentID_seq"', 6, true);


--
-- TOC entry 3103 (class 0 OID 0)
-- Dependencies: 204
-- Name: list_ListID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."list_ListID_seq"', 41, true);


--
-- TOC entry 3104 (class 0 OID 0)
-- Dependencies: 208
-- Name: product_ProductID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."product_ProductID_seq"', 30, true);


--
-- TOC entry 3105 (class 0 OID 0)
-- Dependencies: 210
-- Name: retailcompany_RetailID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."retailcompany_RetailID_seq"', 2, true);


--
-- TOC entry 3106 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 32, true);


--
-- TOC entry 2900 (class 2606 OID 25103)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY ("DepartmentID");


--
-- TOC entry 2902 (class 2606 OID 25105)
-- Name: list list_ListID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list
    ADD CONSTRAINT "list_ListID_key" UNIQUE ("ListID");


--
-- TOC entry 2904 (class 2606 OID 25107)
-- Name: list list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list
    ADD CONSTRAINT list_pkey PRIMARY KEY ("ListID");


--
-- TOC entry 2908 (class 2606 OID 25109)
-- Name: listitems listitems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listitems
    ADD CONSTRAINT listitems_pkey PRIMARY KEY ("ListID", "UPC");


--
-- TOC entry 2912 (class 2606 OID 25111)
-- Name: particularproductpricing particularproductpricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.particularproductpricing
    ADD CONSTRAINT particularproductpricing_pkey PRIMARY KEY ("UPC", "RetailID");


--
-- TOC entry 2915 (class 2606 OID 25113)
-- Name: product product_ProductID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "product_ProductID_key" UNIQUE ("ProductID");


--
-- TOC entry 2917 (class 2606 OID 25115)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY ("ProductID");


--
-- TOC entry 2919 (class 2606 OID 25117)
-- Name: retailcompany retailcompany_RetailID_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailcompany
    ADD CONSTRAINT "retailcompany_RetailID_key" UNIQUE ("RetailID");


--
-- TOC entry 2921 (class 2606 OID 25119)
-- Name: retailcompany retailcompany_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailcompany
    ADD CONSTRAINT retailcompany_pkey PRIMARY KEY ("RetailID");


--
-- TOC entry 2923 (class 2606 OID 25121)
-- Name: shoppinglist shoppinglist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shoppinglist
    ADD CONSTRAINT shoppinglist_pkey PRIMARY KEY ("ListID");


--
-- TOC entry 2932 (class 2606 OID 25123)
-- Name: variety uniquefk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT uniquefk UNIQUE ("UPC");


--
-- TOC entry 2925 (class 2606 OID 25125)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2927 (class 2606 OID 25127)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2929 (class 2606 OID 25129)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 2934 (class 2606 OID 25131)
-- Name: variety variety_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT variety_pkey PRIMARY KEY ("UPC", "ProductID");


--
-- TOC entry 2937 (class 2606 OID 25133)
-- Name: wishlist wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY ("ListID", "UPC");


--
-- TOC entry 2930 (class 1259 OID 25134)
-- Name: fki_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk ON public.variety USING btree ("ProductID");


--
-- TOC entry 2913 (class 1259 OID 25135)
-- Name: fki_fkConstraint; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_fkConstraint" ON public.product USING btree ("DepartmentID");


--
-- TOC entry 2905 (class 1259 OID 25136)
-- Name: fki_fk_list_items; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_list_items ON public.listitems USING btree ("ListID");


--
-- TOC entry 2909 (class 1259 OID 25137)
-- Name: fki_fk_particular_product_pricing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_particular_product_pricing ON public.particularproductpricing USING btree ("UPC");


--
-- TOC entry 2935 (class 1259 OID 25138)
-- Name: fki_fk_upc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_upc ON public.wishlist USING btree ("UPC");


--
-- TOC entry 2906 (class 1259 OID 25139)
-- Name: fki_fk_upc_list_item; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_upc_list_item ON public.listitems USING btree ("UPC");


--
-- TOC entry 2910 (class 1259 OID 25140)
-- Name: fki_retailID_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_retailID_fk" ON public.particularproductpricing USING btree ("RetailID");


--
-- TOC entry 2948 (class 2620 OID 25191)
-- Name: users NewUserList; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "NewUserList" AFTER INSERT ON public.users FOR EACH ROW WHEN ((new.user_id IS NOT NULL)) EXECUTE FUNCTION public."userList"();


--
-- TOC entry 2947 (class 2620 OID 25196)
-- Name: list newShoppingItem; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "newShoppingItem" AFTER INSERT ON public.list FOR EACH ROW WHEN (((new."ListID" IS NOT NULL) AND (new."Name" = 'shoppingList'::bpchar))) EXECUTE FUNCTION public."newUserShoppingList"();


--
-- TOC entry 2940 (class 2606 OID 25141)
-- Name: particularproductpricing  fk_particular_product_pricing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.particularproductpricing
    ADD CONSTRAINT " fk_particular_product_pricing" FOREIGN KEY ("UPC") REFERENCES public.variety("UPC") NOT VALID;


--
-- TOC entry 2943 (class 2606 OID 25146)
-- Name: shoppinglist fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shoppinglist
    ADD CONSTRAINT fk FOREIGN KEY ("ListID") REFERENCES public.list("ListID") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 2938 (class 2606 OID 25151)
-- Name: listitems fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listitems
    ADD CONSTRAINT fk FOREIGN KEY ("ListID") REFERENCES public.list("ListID") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 2942 (class 2606 OID 25156)
-- Name: product fkConstraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "fkConstraint" FOREIGN KEY ("DepartmentID") REFERENCES public.department("DepartmentID") NOT VALID;


--
-- TOC entry 2945 (class 2606 OID 25161)
-- Name: wishlist fk_listid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT fk_listid FOREIGN KEY ("ListID") REFERENCES public.list("ListID") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 2946 (class 2606 OID 25166)
-- Name: wishlist fk_upc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT fk_upc FOREIGN KEY ("UPC") REFERENCES public.variety("UPC") NOT VALID;


--
-- TOC entry 2939 (class 2606 OID 25171)
-- Name: listitems fk_upc_list_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listitems
    ADD CONSTRAINT fk_upc_list_item FOREIGN KEY ("UPC") REFERENCES public.variety("UPC") NOT VALID;


--
-- TOC entry 2944 (class 2606 OID 25176)
-- Name: variety product_fkconstraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT product_fkconstraint FOREIGN KEY ("ProductID") REFERENCES public.product("ProductID") NOT VALID;


--
-- TOC entry 2941 (class 2606 OID 25181)
-- Name: particularproductpricing retailID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.particularproductpricing
    ADD CONSTRAINT "retailID_fk" FOREIGN KEY ("RetailID") REFERENCES public.retailcompany("RetailID") NOT VALID;


-- Completed on 2021-04-18 14:05:14

--
-- PostgreSQL database dump complete
--

