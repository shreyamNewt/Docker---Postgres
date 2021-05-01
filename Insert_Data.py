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
