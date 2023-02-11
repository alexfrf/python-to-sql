# -*- coding: utf-8 -*-
"""
Created on Wed Jul 14 21:31:55 2021

@author: aleex
"""

import sqlite3
import pandas as pd

ruta = 'C:\\Users\\aleex\\Data Science Projects\\Portfolio/Nashville Housing Data/'

# SQL


conn = sqlite3.connect(ruta+'Nashville Housing.db')
nashville = pd.read_excel(ruta+'Nashville Housing Data for Data Cleaning.xlsx')

c = conn.cursor()

nashville.to_sql('Nashville', conn, if_exists='replace', index = False)

conn.close()