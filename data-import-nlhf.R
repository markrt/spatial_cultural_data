# more imports
# nlhf

source("data-import_crf.R")

# load 360giving data
nlhf <- 
  read_csv("data/nlhf_360data_01042013-15072022_file.csv",
            name_repair = "universal")

# load ward to LA lookup

lookup <- 
  read_csv("data/Ward_to_Local_Authority_District_to_County_to_Region_to_Country_(December_2020)_Lookup_in_United_Kingdom_V2.csv")

# some have changed
lookup_old <- 
  read_csv("data/Ward_to_Local_Authority_District_to_County_to_Region_to_Country_(December_2016)_Lookup_in_United_Kingdom_(V2).csv")

# add local authorities, get summary data
nlhf <- 
  nlhf %>% 
  mutate(is_ward = 
           case_when(Recipient.Org.Location.Geographic.Code 
                     %in% 
                       lookup$WD20CD 
                     ~
                       "new",
                     (Recipient.Org.Location.Geographic.Code 
                      %in% 
                        lookup_old$WD16CD &
                        !(Recipient.Org.Location.Geographic.Code
                          %in% 
                            lookup$WD20CD)) ~
                       "old"
           ))  %>% 
  left_join(lookup %>% 
              rename(Recipient.Org.Location.Geographic.Code = 
                       WD20CD) %>% 
              select(Recipient.Org.Location.Geographic.Code,
                     LAD20CD,
                     LAD20NM)) %>% 
  left_join(lookup_old %>% 
              rename(Recipient.Org.Location.Geographic.Code = 
                       WD16CD) %>% 
              select(Recipient.Org.Location.Geographic.Code,
                     LAD16CD,
                     LAD16NM)) %>% 
  mutate(local_authority_code = 
           case_when(is_ward == 
                       "new" ~
                       LAD20CD,
                     is_ward == 
                       "old" ~
                       LAD16CD)) %>% 
  mutate(local_authority_name = 
           case_when(is_ward == 
                       "new" ~
                       LAD20NM,
                     is_ward == 
                       "old" ~
                       LAD16NM)) %>% 
  group_by(local_authority_name,
           local_authority_code) %>% 
  summarise(nlhf = 
              sum(Amount.Awarded))


nlhf <- 
  nlhf %>% 
  rename(la_name = 
           local_authority_name) %>% 
  mutate(la_name =
           fct_recode(la_name,
                      "Buckinghamshire" =
                        "South Bucks",
                      "Buckinghamshire" =
                        "Aylesbury Vale",
                      "Buckinghamshire" =
                        "Chiltern",
                      "Bournemouth, Christchurch and Poole" =
                        "Bournemouth",
                      "Bournemouth, Christchurch and Poole" =
                        "Christchurch",
                      "West Northamptonshire" =
                        "Daventry",
                      "North Northamptonshire" =
                        "Corby",
                      "North Northamptonshire" =
                        "Wellingborough",
                      "North Northamptonshire" =
                        "East Northamptonshire",
                      "North Northamptonshire" =
                        "Kettering",
                      "West Suffolk" =
                        "Forest Heath",
                      "West Suffolk" =
                        "St Edmundsbury",
                      "West Northamptonshire" =
                        "Northampton",
                      "West Northamptonshire" =
                        "South Northamptonshire",
                      "Somerset West and Taunton" =
                        "Taunton Deane",
                      "Somerset West and Taunton" =
                        "West Somerset",
                      "Bournemouth, Christchurch and Poole" =
                        "Poole",
                      "Dorset" =
                        "Purbeck",
                      "Dorset" =
                        "East Dorset",
                      "Folkestone and Hythe" =
                        "Shepway",
                      "East Suffolk" =
                        "Suffolk Coastal",
                      "East Suffolk" =
                        "Waveney",
                      "Dorset" =
                        "West Dorset",
                      "Dorset" =
                        "North Dorset",
                      "Dorset" =
                        "Weymouth and Portland",
                      "King’s Lynn and West Norfolk" =
                        "King's Lynn and West Norfolk"
           )) %>%
  filter((str_sub(local_authority_code,
                 1,
                 1)) == "E") %>% 
  full_join(crf_overall) %>% 
  filter(!is.na(population_2021))

