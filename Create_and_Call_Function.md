### Create Function to insert data into respective tables

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
 
 
 ### Call the function created
 
 SELECT "insertpartitionhpi1"('traditional','purchase-only','monthly','USA or Census Division','East North Central Division','DV_ENC','1991','1','100.00','100.00');
SELECT "insertpartitionhpi1"('traditional','purchase-only','monthly','USA or Census Division','East North Central Division','DV_ENC','1991','2','100.98','101.06');

 
