#!/bin/bash

# =========== Truncating all Tables ========-
echo
echo "Wiping All Tables"; #sleep 1
echo 'TRUNCATE public.customers, public.accounts, public.audit_trail, public.employees, public.loans, public.transactions CASCADE;'
psql -U postgres -d BankDB -c 'TRUNCATE public.customers, public.accounts, public.audit_trail, public.employees, public.loans, public.transactions CASCADE;' > /dev/null
#sleep 1

echo
echo "Resetting All Primary Key Sequences"; #sleep 1
echo 'ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;'
echo 'ALTER SEQUENCE accounts_account_id_seq RESTART WITH 1;'
echo 'ALTER SEQUENCE audit_trail_audit_id_seq RESTART WITH 1;'
echo 'ALTER SEQUENCE loans_loan_id_seq RESTART WITH 1;'
echo 'ALTER SEQUENCE transactions_transaction_id_seq RESTART WITH 1;'
echo 'ALTER SEQUENCE employees_employee_id_seq RESTART WITH 1;'; #sleep 1
psql -U postgres -d BankDB -c 'ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;' > /dev/null
psql -U postgres -d BankDB -c 'ALTER SEQUENCE accounts_account_id_seq RESTART WITH 1;' > /dev/null
psql -U postgres -d BankDB -c 'ALTER SEQUENCE audit_trail_audit_id_seq RESTART WITH 1;' > /dev/null
psql -U postgres -d BankDB -c 'ALTER SEQUENCE loans_loan_id_seq RESTART WITH 1;' > /dev/null
psql -U postgres -d BankDB -c 'ALTER SEQUENCE transactions_transaction_id_seq RESTART WITH 1;' > /dev/null
psql -U postgres -d BankDB -c 'ALTER SEQUENCE employees_employee_id_seq RESTART WITH 1;' > /dev/null

# =========== Filling tables =========== 
# ----------- Inserting Customers -------------
echo 
echo "Inserting Customers";
echo "INSERT INTO public.customers (first_name, last_name, address, username, password) VALUES ('Alphonso', 'Casey', '160 Tulip St, Emporia, KS', 'Customer1', 'password')"
echo "INSERT INTO public.customers (first_name, last_name, address, username, password) VALUES ('Dorian', 'Nieves', '84 Old Pinbrick Dr, Passadena, CA', 'Customer2', 'password')"
echo "INSERT INTO public.customers (first_name, last_name, address, username, password) VALUES ('Carmella', 'Cunningham', '404 Stonehenge Blvd, Mentor, OH', 'Customer3', 'password')"
psql -U postgres -d BankDB -c "INSERT INTO customers (first_name, last_name, address, username, password) VALUES ('Alphonso', 'Customer1', '160 Tulip St, Emporia, KS', 'Customer1', 'password')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO customers (first_name, last_name, address, username, password) VALUES ('Dorian', 'Nieves', '84 Old Pinbrick Dr, Passadena, CA', 'Customer2', 'password')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO customers (first_name, last_name, address, username, password) VALUES ('Carmella', 'Cunningham', '404 Stonehenge Blvd, Mentor, OH', 'Customer3', 'password')" > /dev/null

# ----------- Inserting Employees -------------
echo
echo "Inserting employees"
echo "INSERT INTO employees (job_title, username, password) VALUES ('Loan Officer', 'LoanOfficer1', 'password')"
echo "INSERT INTO employees (job_title, username, password) VALUES ('Bank Manager', 'BankManager1', 'password')"
echo "INSERT INTO employees (job_title, username, password) VALUES ('Teller', 'Teller1', 'password')"
psql -U postgres -d BankDB -c "INSERT INTO employees (job_title, username, password) VALUES ('Loan Officer', 'LoanOfficer1', 'password')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO employees (job_title, username, password) VALUES ('Bank Manager', 'BankManager1', 'password')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO employees (job_title, username, password) VALUES ('Teller', 'Teller1', 'password')" > /dev/null

# ----------- Creating Accounts -------------
echo
echo "Inserting Accounts"; #sleep 1
echo "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (1, 'Savings', 1500000, 'Active')"
echo "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (1, 'Current', 1000, 'Active')"
echo "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (2, 'Savings', 130183, 'Active')"
psql -U postgres -d BankDB -c "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (1, 'Savings', 1500000, 'Active')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (1, 'Current', 1000, 'Active')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO accounts (customer_id, account_type, balance, status) VALUES (2, 'Savings', 130183, 'Active')" > /dev/null

# ----------- Inserting Loans -------------
echo
echo "Inserting Loans"
echo "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (10000, 4.1, '2026-01-01', 5000, 'Active', 2)"
echo "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (50000, 2.0, '2026-01-01', 0, 'Pending', 1)"
echo "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (100, 60, '2020-01-01', 100, 'Paid', 3)"
psql -U postgres -d BankDB -c "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (10000, 4.1, '2026-01-01', 5000, 'Active', 2)" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (50000, 2.0, '2026-01-01', 0, 'Pending', 1)" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO loans (total, interest, maturity, amount_paid, status, account_id) VALUES (100, 60, '2020-01-01', 100, 'Paid', 3)" > /dev/null

# ----------- Inserting Transactions -------------
echo
echo "Inserting Transactions"
echo "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (1, 2, 3799, 'Successful')"
echo "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (2, 1, 350, 'Successful')"
echo "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (1, 3, 4000, 'Pending')"
echo "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (3, 2, 2200, 'Declined')"
psql -U postgres -d BankDB -c "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (1, 2, 3799, 'Successful')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (2, 1, 350, 'Successful')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (1, 3, 4000, 'Pending')" > /dev/null
psql -U postgres -d BankDB -c "INSERT INTO transactions (sender_id, recipient_id, amount_sent, status) VALUES (3, 2, 2200, 'Declined')" > /dev/null


echo
echo "Tables Successfully Populated"; sleep 1
#
# ====================================== Selecting All Tables ===========================================
#
echo
echo "Printing all tables"; sleep 1
#
# ----------- Selecting Employees -------------
echo "Showing All Tables"; #sleep 1
echo
echo "Employees Table"
echo 'SELECT * from public.employees ORDER BY employee_id ASC'; #sleep 1
psql -U postgres -d BankDB -c 'SELECT * from public.employees ORDER BY employee_id ASC' | cat; sleep 1

# ----------- Selecting Customers Tables -------------
echo
echo "Customers Table"; #sleep 1
echo 'SELECT * FROM customers ORDER BY customer_id ASC'; #sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM customers ORDER BY customer_id ASC' | cat ; sleep 1

# ----------- Selecting Accounts Tables -------------
echo
echo "Accounts Table"; #sleep 1
echo 'SELECT * FROM accounts ORDER BY account_id ASC'; #sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM accounts ORDER BY account_id ASC' | cat ; sleep 1

# ----------- Selecting Transactions Tables -------------
echo
echo "Transactions Table"; #sleep 1
echo 'SELECT * FROM transactions ORDER BY transaction_id ASC'; #sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM transactions ORDER BY transaction_id ASC' | cat ; sleep 1

# ----------- Selecting Loans Tables -------------
echo
echo "Loans Table"; #sleep 1
echo 'SELECT * FROM loans ORDER BY loan_id ASC'; #sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM loans ORDER BY loan_id ASC' | cat ; sleep 1



# =========== Access Controls ========-

echo
echo "Demonstrating Access Control (using RLS and Views)"; sleep 1
echo "Demonstration will be done on the 'accounts' table,"
echo "however access controls have been added across the database "; sleep 1
echo
echo 'Select all from accounts (as "Customer1")'; sleep 1
echo 'SET ROLE "Customer1"; SELECT * FROM customer_view_accounts'; sleep 1
psql -U postgres -d BankDB -c 'set role "Customer1"; SELECT * FROM customer_view_accounts' | cat ; sleep 1

echo 'Select all from accounts (as "Customer2")'; sleep 1
echo 'SET ROLE "Customer2"; SELECT * FROM customer_view_accounts'; sleep 1
psql -U postgres -d BankDB -c 'set role "Customer2"; SELECT * FROM customer_view_accounts' | cat ; sleep 1

echo 'Select all from accounts (as "Teller1")'; sleep 1
echo 'SET ROLE "Teller1"; SELECT * FROM teller_view_accounts'; sleep 1
psql -U postgres -d BankDB -c 'set role "Teller1"; SELECT * FROM teller_view_accounts' | cat ; sleep 1

echo 'Select all from accounts (as "LoanOfficer1")'; sleep 1
echo 'SET ROLE "LoanOfficer1"; SELECT * FROM loan_officer_view_accounts'; sleep 1
psql -U postgres -d BankDB -c 'set role "LoanOfficer1"; SELECT * FROM loan_officer_view_accounts' | cat ; sleep 1

echo 'Select all from accounts (as "BankManager1")'; sleep 1
echo 'SET ROLE "BankManager1"; SELECT * FROM accounts'; sleep 1
psql -U postgres -d BankDB -c 'set role "BankManager1"; SELECT * FROM accounts' | cat ; sleep 1

echo
echo "Demonstrating Audit Trail (on Accounts table)"; sleep 1

echo
echo "Audit Trail before update"; sleep 1
echo 'SELECT * FROM audit_trail'; sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM audit_trail' | cat ; sleep 1

echo 'UPDATE accounts SET balance = 0 WHERE account_id = 2';
echo 'DELETE FROM accounts WHERE account_id = 2';sleep 1
echo 'UPDATE accounts SET balance = 1515000 WHERE account_id = 1';
psql -U postgres -d BankDB -c 'UPDATE accounts SET balance = 0 WHERE account_id = 2' > /dev/null ;
psql -U postgres -d BankDB -c 'DELETE FROM accounts WHERE account_id = 2' > /dev/null ;
psql -U postgres -d BankDB -c 'UPDATE accounts SET balance = 1515000 WHERE account_id = 1' > /dev/null; sleep 1

echo
echo "Audit Trail after update"; sleep 1
echo 'SELECT * FROM audit_trail'; sleep 1
psql -U postgres -d BankDB -c 'SELECT * FROM audit_trail' | cat ; sleep 1

echo

exit
