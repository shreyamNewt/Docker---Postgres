import pandas as pd
import psycopg2
import numpy as np

try:
        connection = psycopg2.connect(user='postgres', password='Monika96@',host='127.0.0.1', port='5432', database='hpi_data')
        ds1 = pd.read_csv('/home/sugaanth/HPI_master.csv')

        query1='SELECT hpi1.hpi_type,hpi1.hpi_flavor,hpi1.frequency,hpi1.level,hpi2.place_name, hpi2.place_id,hpi2.yr, hpi2.period, hpi2.index_nsa,hpi2.index_sa FROM hpi1 INNER JOIN hpi2 ON hpi1.id = hpi2.id where date_month_year=\'2021-05-01\';'
        ds2= pd.read_sql(con=connection,sql=query1)
        ds2 = ds2.drop(ds2.index[[0]])
        ds2.reset_index(drop=True)
        ds2.index_sa=ds2.index_sa.astype('str').replace(r'^\s*$',np.nan, regex=True)
        ds2.yr=ds2.yr.astype(int)
        ds2.period=ds2.period.astype(int)
        ds2.index_nsa=ds2.index_nsa.astype(float)
        ds2.index_sa=ds2.index_sa.astype(float)
        #df = pd.concat([ds1, ds2])
        #print(df)
        cols = ds1.columns.to_list()
        ds1['combined'] = ds1[cols].apply(lambda row: '_'.join(row.values.astype(str)), axis=1)
        ds2['combined'] = ds2[cols].apply(lambda row: '_'.join(row.values.astype(str)), axis=1)
        print(ds1["combined"][~ds1["combined"].isin(ds2["combined"])].drop_duplicates())

        #print(ds1.dtypes)
        #print(ds2.dtypes)
        #print(len(ds1.index))
        #print(len(ds2.index))
        #print(ds1.reset_index(drop=True) == ds2.reset_index(drop=True))

        #print(ds1.columns.to_list())
        #print(ds2.columns.to_list())
        #print(ds2['combined'].compare(ds2['combined']))


finally:

        if connection is not None:
                connection.close()