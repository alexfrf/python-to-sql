# -*- coding: utf-8 -*-
"""
Created on Mon Jul  5 19:38:11 2021

@author: aleex
"""

import sqlite3
import pandas as pd
import requests
from selenium import webdriver # SELENIUM
from bs4 import BeautifulSoup # BEAUTIFULSOUP
import time
import os

# WEBSCRAPING

link = "https://ourworldindata.org/covid-deaths"

headers = {'User-Agent': 
           'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'}

driver = webdriver.Chrome("C:\\Users\\aleex\\chromedriver_win32/chromedriver.exe")
driver.get(link)
time.sleep(3)
driver.maximize_window()
driver.execute_script("window.scrollTo(0, 600)")
driver.find_element_by_xpath("//a[text()='.xslx']").click()
dir_name = "C:/Users/aleex/Downloads"

time.sleep(40)

index=0
files = []
times=[]
df = pd.DataFrame(columns=['file','time'])
# for filename in os.listdir(dir_name):
#     if filename.startswith("owid-covid-data") and filename.endswith(".xlsx"):
#         index+=1
#         files.append(os.path.join(dir_name,filename))
#         times.append(os.path.getmtime(os.path.join(dir_name,filename)))
        
#     else:
#         continue

for i in range(0,30):
    if index>0:
        driver.close()
        break
    else:
        time.sleep(40)
        for filename in os.listdir(dir_name):
            if filename.startswith("owid-covid-data") and filename.endswith(".xlsx"):
                index+=1
                files.append(os.path.join(dir_name,filename))
                times.append(os.path.getmtime(os.path.join(dir_name,filename)))    
            else:
                continue
            continue
    
df['file'] = files
df['time'] = times

df = df.sort_values(by='time',ascending=False).head(1)['file']
for i in df:
    file = i
    
ruta = 'C:\\Users\\aleex\\Data Science Projects\\Portfolio/Covid'

try:
    os.rename("{}".format(file), "{}/owid-covid-data.xlsx".format(ruta))
except:
    os.replace("{}".format(file), "{}/owid-covid-data.xlsx".format(ruta))

data = pd.read_excel("{}/owid-covid-data.xlsx".format(ruta))   
covid_deaths = data[['iso_code', 'continent', 'location', 'date', 'population',
       'total_cases', 'new_cases', 'new_cases_smoothed', 'total_deaths',
       'new_deaths', 'new_deaths_smoothed', 'total_cases_per_million',
       'new_cases_per_million', 'new_cases_smoothed_per_million',
       'total_deaths_per_million', 'new_deaths_per_million',
       'new_deaths_smoothed_per_million', 'reproduction_rate', 'icu_patients',
       'icu_patients_per_million', 'hosp_patients',
       'hosp_patients_per_million', 'weekly_icu_admissions',
       'weekly_icu_admissions_per_million', 'weekly_hosp_admissions',
       'weekly_hosp_admissions_per_million']]
                    
                    
covid_vac = data[['iso_code', 'continent', 'location', 'date', 'population', 'new_tests',
       'total_tests', 'total_tests_per_thousand', 'new_tests_per_thousand',
       'new_tests_smoothed', 'new_tests_smoothed_per_thousand',
       'positive_rate', 'tests_per_case', 'tests_units', 'total_vaccinations',
       'people_vaccinated', 'people_fully_vaccinated', 'new_vaccinations',
       'new_vaccinations_smoothed', 'total_vaccinations_per_hundred',
       'people_vaccinated_per_hundred', 'people_fully_vaccinated_per_hundred',
       'new_vaccinations_smoothed_per_million', 'stringency_index',
       'population_density', 'median_age', 'aged_65_older', 'aged_70_older',
       'gdp_per_capita', 'extreme_poverty', 'cardiovasc_death_rate',
       'diabetes_prevalence', 'female_smokers', 'male_smokers',
       'handwashing_facilities', 'hospital_beds_per_thousand',
       'life_expectancy', 'human_development_index', 'excess_mortality']]

# SQL


conn = sqlite3.connect(ruta+'/covid.db')

c = conn.cursor()

covid_deaths.to_sql('covid_deaths', conn,if_exists='replace',index = False)
covid_vac.to_sql('covid_vaccinations',conn,if_exists='replace',index = False)

c.execute('''  
SELECT * FROM covid_deaths
          ''')

for row in c.fetchall():
    print (row)


sql_file = open(ruta+'/SQL_pbi.sql')
sql_as_string = sql_file.read()
c.executescript(sql_as_string)


conn.commit()

conn.close()