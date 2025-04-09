--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Debian 15.10-0+deb12u1)
-- Dumped by pg_dump version 15.10 (Debian 15.10-0+deb12u1)

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
-- Name: account_audit_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.account_audit_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
BEGIN
	INSERT INTO audit_trail (account_id, customer_id, balance, status, operation, timestamp)
	VALUES (old.account_id, old.customer_id, old.balance, old.status, 'DELETE', now());
	RETURN new;
END;$$;


ALTER FUNCTION public.account_audit_delete() OWNER TO postgres;

--
-- Name: account_audit_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.account_audit_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
BEGIN
	INSERT INTO audit_trail (account_id, customer_id, balance, status, operation, timestamp)
	VALUES (new.account_id, new.customer_id, new.balance, new.status, 'INSERT', now());
	RETURN new;
END;$$;


ALTER FUNCTION public.account_audit_insert() OWNER TO postgres;

--
-- Name: account_audit_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.account_audit_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
BEGIN
	INSERT INTO audit_trail (account_id, customer_id, balance, status, operation, timestamp)
	VALUES (old.account_id, old.customer_id, old.balance, old.status, 'UPDATE', now());
	RETURN new;
END;$$;


ALTER FUNCTION public.account_audit_update() OWNER TO postgres;

--
-- Name: customer_id_from_username(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.customer_id_from_username() RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
	_customer_id integer;
BEGIN
    SELECT customers.customer_id
    INTO _customer_id
    FROM customers
    WHERE customers.username = CURRENT_USER;

    IF FOUND THEN
        RETURN _customer_id;
    ELSE
        RETURN NULL; -- Or RAISE EXCEPTION if you prefer.
    END IF;
END;$$;


ALTER FUNCTION public.customer_id_from_username() OWNER TO postgres;

--
-- Name: employee_id_from_username(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_id_from_username() RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
	_employee_id integer;
BEGIN
    SELECT employee_id
    INTO _employee_id
    FROM employees
    WHERE employees.username = CURRENT_USER;

    IF FOUND THEN
        RETURN _employee_id;
    ELSE
        RETURN NULL;
    END IF;
END;$$;


ALTER FUNCTION public.employee_id_from_username() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    customer_id integer NOT NULL,
    account_type character varying(20),
    balance integer DEFAULT 0,
    status character varying(20) DEFAULT 'Pending'::character varying
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_id_seq OWNER TO postgres;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- Name: audit_trail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_trail (
    audit_id integer NOT NULL,
    account_id integer,
    balance integer,
    customer_id integer,
    status character varying(30),
    operation character varying(30),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.audit_trail OWNER TO postgres;

--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_trail_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_trail_audit_id_seq OWNER TO postgres;

--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_trail_audit_id_seq OWNED BY public.audit_trail.audit_id;


--
-- Name: customer_view_accounts; Type: VIEW; Schema: public; Owner: Customer
--

CREATE VIEW public.customer_view_accounts WITH (security_invoker='false', security_barrier='false') AS
 SELECT accounts.account_id,
    accounts.account_type,
    accounts.balance
   FROM public.accounts;


ALTER TABLE public.customer_view_accounts OWNER TO "Customer";

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    first_name character varying(20),
    last_name character varying(20),
    address character varying(40),
    username character varying(20),
    password character varying(20)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customer_view_customers; Type: VIEW; Schema: public; Owner: Customer
--

CREATE VIEW public.customer_view_customers AS
 SELECT customers.first_name,
    customers.last_name,
    customers.address,
    customers.username,
    customers.password
   FROM public.customers;


ALTER TABLE public.customer_view_customers OWNER TO "Customer";

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: employee_view_customers; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_view_customers AS
 SELECT customers.first_name,
    customers.last_name,
    customers.address
   FROM public.customers;


ALTER TABLE public.employee_view_customers OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    job_title character varying(30),
    username character varying(20),
    password character varying(20)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: loan_officer_view_accounts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.loan_officer_view_accounts AS
 SELECT accounts.account_id,
    accounts.customer_id
   FROM public.accounts;


ALTER TABLE public.loan_officer_view_accounts OWNER TO postgres;

--
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    loan_id integer NOT NULL,
    total integer,
    interest integer,
    maturity date,
    amount_paid integer,
    status character varying(20) DEFAULT 'Pending'::character varying,
    account_id integer NOT NULL
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- Name: loans_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loans_loan_id_seq OWNER TO postgres;

--
-- Name: loans_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_loan_id_seq OWNED BY public.loans.loan_id;


--
-- Name: teller_view_accounts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.teller_view_accounts AS
 SELECT accounts.account_id,
    accounts.account_type,
    accounts.status
   FROM public.accounts;


ALTER TABLE public.teller_view_accounts OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    amount_sent integer NOT NULL,
    sender_id integer NOT NULL,
    recipient_id integer NOT NULL,
    status character varying DEFAULT 'Pending'::character varying
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- Name: audit_trail audit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_trail ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_trail_audit_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: loans loan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans ALTER COLUMN loan_id SET DEFAULT nextval('public.loans_loan_id_seq'::regclass);


--
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, customer_id, account_type, balance, status) FROM stdin;
3	2	Savings	130183	Active
2	1	Current	0	Active
1	1	Savings	1515000	Active
\.


--
-- Data for Name: audit_trail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_trail (audit_id, account_id, balance, customer_id, status, operation, "timestamp") FROM stdin;
1	1	1500000	1	Active	INSERT	2025-03-07 12:18:21.228997
2	2	1000	1	Active	INSERT	2025-03-07 12:18:21.272761
3	3	130183	2	Active	INSERT	2025-03-07 12:18:21.314787
4	2	1000	1	Active	UPDATE	2025-03-07 12:18:51.169812
5	2	0	1	Active	DELETE	2025-03-07 12:18:51.212143
6	1	1500000	1	Active	UPDATE	2025-03-07 12:18:51.257848
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, first_name, last_name, address, username, password) FROM stdin;
1	Alphonso	Customer1	160 Tulip St, Emporia, KS	Customer1	password
2	Dorian	Nieves	84 Old Pinbrick Dr, Passadena, CA	Customer2	password
3	Carmella	Cunningham	404 Stonehenge Blvd, Mentor, OH	Customer3	password
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, job_title, username, password) FROM stdin;
1	Loan Officer	LoanOfficer1	password
2	Bank Manager	BankManager1	password
3	Teller	Teller1	password
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loans (loan_id, total, interest, maturity, amount_paid, status, account_id) FROM stdin;
1	10000	4	2026-01-01	5000	Active	2
2	50000	2	2026-01-01	0	Pending	1
3	100	60	2020-01-01	100	Paid	3
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, amount_sent, sender_id, recipient_id, status) FROM stdin;
1	3799	1	2	Successful
2	350	2	1	Successful
3	4000	1	3	Pending
4	2200	3	2	Declined
\.


--
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 3, true);


--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_trail_audit_id_seq', 6, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 3, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 3, true);


--
-- Name: loans_loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_loan_id_seq', 3, true);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 4, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- Name: audit_trail audit_trail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_trail
    ADD CONSTRAINT audit_trail_pkey PRIMARY KEY (audit_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: accounts account_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER account_delete BEFORE DELETE ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.account_audit_delete();


--
-- Name: accounts account_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER account_insert BEFORE INSERT ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.account_audit_insert();


--
-- Name: accounts account_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER account_update AFTER UPDATE ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.account_audit_update();


--
-- Name: loans account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT account_id FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) NOT VALID;


--
-- Name: accounts customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) NOT VALID;


--
-- Name: transactions recipient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT recipient_id FOREIGN KEY (recipient_id) REFERENCES public.customers(customer_id) NOT VALID;


--
-- Name: transactions sender_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT sender_id FOREIGN KEY (sender_id) REFERENCES public.customers(customer_id) NOT VALID;


--
-- Name: accounts account_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY account_rls ON public.accounts FOR SELECT TO "Customer" USING ((customer_id = public.customer_id_from_username()));


--
-- Name: accounts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

--
-- Name: customers customer_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY customer_rls ON public.customers TO "Customer" USING (((username)::text = CURRENT_USER));


--
-- Name: loans customer_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY customer_rls ON public.loans FOR SELECT TO "Customer" USING ((account_id IN ( SELECT accounts.account_id
   FROM public.accounts
  WHERE (accounts.customer_id = public.customer_id_from_username()))));


--
-- Name: transactions customer_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY customer_rls ON public.transactions TO "Customer" USING (((sender_id IN ( SELECT accounts.account_id
   FROM public.accounts
  WHERE (accounts.customer_id = public.customer_id_from_username()))) OR (recipient_id IN ( SELECT accounts.account_id
   FROM public.accounts
  WHERE (accounts.customer_id = public.customer_id_from_username())))));


--
-- Name: customers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

--
-- Name: employees employee_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY employee_rls ON public.employees FOR SELECT TO "Employee" USING (((username)::text = CURRENT_USER));


--
-- Name: employees; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

--
-- Name: loans loan_officer_bypass_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY loan_officer_bypass_rls ON public.loans TO "LoanOfficer" USING (true);


--
-- Name: accounts loan_officer_rls_bypass; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY loan_officer_rls_bypass ON public.accounts FOR SELECT TO "LoanOfficer" USING (true);


--
-- Name: customers loan_officer_rls_bypass; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY loan_officer_rls_bypass ON public.customers FOR SELECT TO "Employee" USING (true);


--
-- Name: loans; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.loans ENABLE ROW LEVEL SECURITY;

--
-- Name: accounts teller_bypass_rls; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teller_bypass_rls ON public.accounts FOR SELECT TO "Teller" USING (true);


--
-- Name: customers teller_rls_bypass; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teller_rls_bypass ON public.customers FOR SELECT TO "Teller" USING (true);


--
-- Name: transactions teller_rls_bypass; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY teller_rls_bypass ON public.transactions FOR SELECT TO "Teller" USING (true);


--
-- Name: transactions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE accounts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.accounts TO "BankManager";
GRANT SELECT,INSERT ON TABLE public.accounts TO "Customer";


--
-- Name: TABLE audit_trail; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.audit_trail TO "BankManager";


--
-- Name: TABLE customers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customers TO "Customer";
GRANT ALL ON TABLE public.customers TO "BankManager";


--
-- Name: TABLE employee_view_customers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.employee_view_customers TO "Employee";


--
-- Name: TABLE employees; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.employees TO "BankManager";
GRANT SELECT,DELETE,UPDATE ON TABLE public.employees TO "Employee";


--
-- Name: TABLE loan_officer_view_accounts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.loan_officer_view_accounts TO "LoanOfficer";


--
-- Name: TABLE loans; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.loans TO "BankManager";
GRANT SELECT,INSERT ON TABLE public.loans TO "Customer";
GRANT SELECT,INSERT,UPDATE ON TABLE public.loans TO "LoanOfficer";


--
-- Name: TABLE teller_view_accounts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.teller_view_accounts TO "Teller";


--
-- Name: TABLE transactions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.transactions TO "Customer";
GRANT SELECT ON TABLE public.transactions TO "BankManager";
GRANT SELECT ON TABLE public.transactions TO "Teller";


--
-- PostgreSQL database dump complete
--

