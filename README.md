## Introduction
This project is a prototype database designed for a Bank Management System.
This is very similar to the <a href="https://github.com/HedleyBenaiges/HealthcareDB/">Healthcare Database Management System</a> made previously, but includes an audit trail using trigger functions.

## Entity Relationship Diagram
<img src="https://github.com/user-attachments/assets/8b636dcd-334c-4e47-b61f-b8026824d502" style="width: 500px"/>


## Test Script
After importing the database, the test script `testing_script.sh` should be run as the postgres user, and from the postgres home directory (e.g. `/var/lib/postgresql`).
The script will run though a select few SQL queries to showcase the functions, triggers, views, and row-level security used in the database

The output of the testing script can be seen below:

![BankDB_test](https://github.com/user-attachments/assets/6d6abfeb-18b1-42e4-bd93-e825c27948a8)

## Access Control
Role-Based Access Control (RBAC) is used to give users their necessary permissions. These have been implemented with group roles for Patients, Staff, Doctors, and Admins in order to enforce the principle of least privilege, and only give users necessary access for their job role.

RBAC has been implemented with a series of features:
- Row-level security limits a user to only their own record in a table
- Views have been created to restrict the columns which a user has access to (with a similar effect to Column-level security)
- Any write operations (e.g. CREATE, UPDATE, DELETE) require the use of functions, which can be assigned to a specific role, and abstracts the user the database to help mitigate attacks like SQL injection

# Importing the Database
Run `./setup.sh` to import the SQL files. 

If you are doing this manually, please import roles.sql before HealthcareDB.sql

#### Important Notes
All scripts should be moved to the postgres home directory and ran as the postgres user to avoid errors (`./setup.sh` should do this)
Password used: `postgres`

#### ! Warning: !
Be careful as this will change postgresql.conf and pg_hba.conf files (although it will create a copy of each before)
