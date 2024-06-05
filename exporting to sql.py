# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
from sqlalchemy import create_engine

#reading the housing data into the IDE before loading it into the database for cleaning in sql
NashvilleHousingData = pd.read_excel(
    'C:/Users/akinola/Documents/datasets/data-alex the analyst/SQL/Nashville Housing Data for Data Cleaning.xlsx',
    )

# creating a connection to my local database
data = create_engine(
    'mssql+pyodbc://localhost/portfolio project?trusted_connection=yes&driver=ODBC+driver+17+for+Sql+Server'
    )

#exporting the housing data to the database for cleaning in sql
export = NashvilleHousingData.to_sql(
    name = 'NashvilleHousingData',
    con = data,
    if_exists = 'append',
    index = True
    )
