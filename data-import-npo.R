# check npo data is ok

# run ons import
source("data-import-ons-population.R")

# load data

npo <- 
  read_excel("data/NPO_2018_22_31032022_0.xlsx") %>% 
  select(c(17, 21))

names(npo) <- 
  c("npo_money",
    "la_name")

# resolve LAs that can't be found in the ONS data

npo <- 
  npo %>% 
  mutate(la_name = 
           fct_recode(la_name,
                      "Buckinghamshire" = 
                        "Aylesbury Vale",
                      "Bournemouth, Christchurch and Poole" = 
                        "Bournemouth",
                      "North Northamptonshire" = 
                        "Corby",
                      "West Suffolk" = 
                        "Forest Heath",
                      "West Northamptonshire" = 
                        "Northampton",
                      "Bournemouth, Christchurch and Poole" = 
                        "Poole",
                      "Dorset" = 
                        "Purbeck",
                      "Folkestone and Hythe" = 
                        "Shepway",
                      "East Suffolk" = 
                        "Suffolk Coastal",
                      "Dorset" = 
                        "West Dorset",
                      "Dorset" = 
                        "Weymouth and Portland"
           ))

npo <- 
  npo %>% 
  group_by(la_name) %>% 
  summarise(npo_money = 
            sum(npo_money)) %>% 
  full_join(ons_population) 
