# Downloag csv file

wget xyz.csv

# Create table hpimaster

CREATE TABLE HPIMaster(id  SERIAL PRIMARY KEY, hpi_type varchar(100),	hpi_flavor varchar(100),	frequency varchar(100),	level varchar(100),	place_name varchar(100),	place_id varchar(100),	yr varchar(100),	period	varchar(100), index_nsa varchar(100),	index_sa varchar(100),	date_month_year DATE DEFAULT CURRENT_DATE);

#create table hpi1

CREATE TABLE HPI1(id  SERIAL PRIMARY KEY, hpi_type varchar(100),	hpi_flavor varchar(100),	frequency varchar(100),	level varchar(100));

#create table hpi2

CREATE TABLE HPI2(id  SERIAL PRIMARY KEY, place_name varchar(100),	place_id varchar(100),	yr varchar(100),	period	varchar(100), index_nsa varchar(100),	index_sa varchar(100),	date_month_year date



# Create Function 

CREATE FUNCTION insertpartitionhpi1(hpi_type_gb varchar(100),hpi_flavor_gb varchar(100),frequency_gb varchar(100),level_gb varchar(100),place_name_gb varchar(100),place_id_gb varchar(100),yr_gb varchar(100),period_gb varchar(100),index_nsa_gb varchar(100),index_sa_gb varchar(100)) 
RETURNS void as $$
DECLARE id_gb INTEGER;
BEGIN
if exists (SELECT id FROM hpi1 where hpi_type = hpi_type_gb and hpi_flavor=hpi_flavor_gb and frequency= frequency_gb and level=level_gb)
    then
 SELECT id INTO id_gb FROM HPI1 where hpi_type = hpi_type_gb and hpi_flavor=hpi_flavor_gb and frequency= frequency_gb and level=level_gb;
else
 INSERT INTO hpi1(hpi_type,hpi_flavor,frequency,level) VALUES (hpi_type_gb,hpi_flavor_gb,frequency_gb,level_gb);
 SELECT id INTO id_gb FROM HPI1 where hpi_type = hpi_type_gb and hpi_flavor=hpi_flavor_gb and frequency= frequency_gb and level=level_gb;
end if;

INSERT INTO hpi2(id, place_name,place_id,yr,period,index_nsa,index_sa,date_month_year) VALUES (id_gb, place_name_gb, place_id_gb, yr_gb, period_gb, index_nsa_gb, index_sa_gb, date(current_timestamp));
 end; $$ LANGUAGE plpgsql;
 
# sourcing file as "hpi_insert_function".sql
\i hpi_insert_function
 
 
# Edit This function in vi editor

 vi hpi_insert_function
 
#Call function "insertpartitionhpi1"

SELECT "insertpartitionhpi1"('traditional','purchase-only','monthly','USA or Census Division','East North Central Division','DV_ENC','1991','1','100.00','100.00');
SELECT "insertpartitionhpi1"('traditional','purchase-only','monthly','USA or Census Division','East North Central Division','DV_ENC','1991','2','100.98','101.06');



# Python Image
docker exec --user postgress -it db bash

# edit python file in VI editor
vi readcsv.py

# Python executing script
python3.6 readcsv.py 
 
 
# Read csv file 
python3.6 readcsv.py | head -6


# Install psycopg2
apt install python3-distutils
python3.6 get-pip.py
python3.6 -m pip install psycopg2

# Call Function to insert data
import psycopg2
import csv


try:
        connection = psycopg2.connect(user='postgres', password='Monika96@',host='127.0.0.1', port='5432', database='hpi_data')
        cursor = connection.cursor()

        with open('/home/sugaanth/HPI_master.csv') as csvFile:
            CSVdata = csv.reader(csvFile, delimiter=',')
            for row in CSVdata:
               cursor.callproc('insertpartitionhpi1', row)
               connection.commit()
finally:

         if connection is not None:
           connection.close()

# Run File to insert data
python3.6 insert_data.py








 

 
