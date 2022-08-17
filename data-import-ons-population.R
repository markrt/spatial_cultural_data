## check ons population data is ok

# load packages
library(tidyverse)
library(readxl)

# load data
ons_population <- 
 read_excel("data/census2021firstresultsenglandwales1.xlsx",
            sheet = 4,
            skip = 6) %>% 
  select(1:3)

# apply names

names(ons_population) <- 
  c("la_code",
    "la_name",
    "population_2021")

# cut "note" (for merge)
ons_population <- 
  ons_population %>% 
  mutate(la_name = 
           fct_recode(la_name,
                      "North Northamptonshire" = 
                        "North Northamptonshire [note 3]",
                      "West Northamptonshire" = 
                        "West Northamptonshire [note 4]",
                      "East Suffolk" = 
                        "East Suffolk [note 5]",
                      "West Suffolk" = 
                        "West Suffolk [note 6]",
                      "Buckinghamshire" = 
                        "Buckinghamshire [note 7]",
                      "Folkestone and Hythe" = 
                        "Folkestone and Hythe [note 8]",
                      "Bournemouth, Christchurch and Poole" = 
                        "Bournemouth, Christchurch and Poole [note 9]",
                      "Dorset" = 
                        "Dorset [note 10]",
                      "Somerset West and Taunton" = 
                        "Somerset West and Taunton [note 11]"))

# nb this contains larger units
# like "England and Wales"
# i'm hoping these will be cut in the merges

table(ons_population$la_name)
