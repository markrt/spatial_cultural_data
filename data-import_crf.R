# more imports
# now, cultural recovery fund

source("data-import-dycp.R")

crf_money_round1 <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             2,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_grants_round_1")
crf_money_capital_kickstart <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             3,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_capital_kickstart")
crf_money_emergency_grassroots <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             4,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_emergency_grassroots")
crf_money_round2 <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             5,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_grants_round_2")
crf_money_3_continuity_support <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             6,
             .name_repair = "universal") %>% 
  select(c(2, 7)) %>% 
  mutate(source = "CRF_ACE_3_Continuity_Support")
crf_money_3_ers_round_1 <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             7,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_3_ERS_Round_1")
crf_money_3_ers_round_2 <- 
  read_excel("data/ACE_CRF_investment_data_31032022.xlsx", 
             8,
             .name_repair = "universal") %>% 
  select(c(2, 6)) %>% 
  mutate(source = "CRF_ACE_3_ERS_Round_2")

crf_overall <- 
  bind_rows(crf_money_3_continuity_support,
          crf_money_3_ers_round_1,
          crf_money_3_ers_round_2,
          crf_money_capital_kickstart,
          crf_money_emergency_grassroots,
          crf_money_round1,
          crf_money_round2) %>% 
  group_by(Local.Authority,
           source) %>% 
  summarise(..Awarded = 
              sum(..Awarded)) %>% 
  pivot_wider(names_from = source,
              values_from = ..Awarded)

rm(crf_money_3_continuity_support,
    crf_money_3_ers_round_1,
    crf_money_3_ers_round_2,
    crf_money_capital_kickstart,
    crf_money_emergency_grassroots,
    crf_money_round1,
    crf_money_round2) 

# add to big object

names(crf_overall)

crf_overall <- 
  crf_overall %>%
  rename(la_name = 
           Local.Authority) %>% 
  mutate(la_name = 
           fct_recode(la_name,
                      "King’s Lynn and West Norfolk" =
                        "King's Lynn and West Norfolk")) %>% 
  full_join(dycp_overall)


