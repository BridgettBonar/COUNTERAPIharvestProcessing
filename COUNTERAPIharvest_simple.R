library(tidyverse)

#Import Job report as "SUSHI_Month"
#Change "_Jan" below to the current month
SUSHI <- SUSHI_Jan %>%
#Rename columns
  rename("Interface" = "...1") %>%
  rename("Report" = "...2") %>%
  rename("Date" = "...3") %>%
  rename("Result" = "...4") %>%
#Simplify Interface and report names
  separate(Interface, sep = " - ", into = c("Interface", NA)) %>%
  separate(Report, sep = ":", into = c("Report", NA)) 

#pulls completed reports
completed <- SUSHI %>%
  filter(str_starts(Result, pattern = "Completed")) 

#Pulls failed reports
failed <- SUSHI %>%
  filter(str_detect(Result, "Failed - Server"))

#removes completed and failed reports from full list  
nodata <- anti_join(SUSHI, completed) %>%
  anti_join(failed)

library(openxlsx)
#create list of tables
list = list("Failed" = failed,
     "noData" = nodata,
     "Complete" = completed)
#export tables to Excel
write.xlsx(list, "SUSHIharvest_2025January.xlsx")

