# check dycp data is ok

# run ons + npo import
source("data-import-npo.R")

# one at a time
dycp_1 <- 
  read_excel("data/DYCP_Round1_Awards_19072018_0.xlsx",
             2,
             skip = 2) %>% 
  select(c(3, 6))
dycp_2 <- 
  read_excel("data/DYCP_Round_2_successful_applicants_10102018_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_3 <- 
  read_excel("data/DCYP_Round_3_Successful_Applications_17019_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_4 <- 
  read_excel("data/DCYP Round 4 Successful Applications 190418.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_5 <- 
  read_excel("data/DCYP_Round_5_Successful_Applications.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_6 <- 
  read_excel("data/DCYP_Round_6_Successful_Applications_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_7 <- 
  read_excel("data/DCYP_Round_7_Successful_Applications d2.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_8 <- 
  read_excel("data/DCYP_Round_8_Successful_Applications_0 (1).xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_9 <- 
  read_excel("data/DYCP_Round_9_successful_applicants_100521_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_10 <- 
  read_excel("data/DYCP_Round_10_Successful_Applicants_11082021_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_11 <- 
  read_excel("data/DYCP_R11_list_of_successful_applicants_24112021_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_12 <- 
  read_excel("data/DYCP_R12_list_of_successful_applicants_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))
dycp_13 <- 
  read_excel("data/DYCP_R13_list_of_successful_applicants_0.xlsx",
             2,
             skip = 2)%>% 
  select(c(3, 6))

# make a list of all the dycps
all_dycp <- 
  lapply(ls(pattern="dycp"), function(x) get(x))

# bind them together
dycp_overall <- 
  bind_rows(all_dycp)

# change names
names(dycp_overall) <- 
  c("dycp_money",
    "la_name")

# tweak combined LAs
dycp_overall <- 
  dycp_overall %>% 
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
                      # "West Suffolk" = 
                      #   "Forest Heath",
                      "West Suffolk" =
                        "St Edmundsbury",
                      "West Northamptonshire" = 
                        "Northampton",
                      "West Northamptonshire" = 
                        "South Northamptonshire",
                      "Somerset West and Taunton" = 
                        "Taunton Deane",
                      "Bournemouth, Christchurch and Poole" = 
                        "Poole",
                      # "Dorset" = 
                      #   "Purbeck",
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
           ))

# make a lovely combined object
dycp_overall <- 
  dycp_overall %>% 
  group_by(la_name) %>% 
  summarise(dycp_money = 
              sum(dycp_money)) %>% 
  full_join(npo)

rm(dycp_1,
   dycp_2,
   dycp_3,
   dycp_4,
   dycp_5,
   dycp_6,
   dycp_7,
   dycp_8,
   dycp_9,
   dycp_10,
   dycp_11,
   dycp_12,
   dycp_13,
)