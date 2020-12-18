library(dslabs)
data("research_funding_rates")
research_funding_rates 

library("pdftools")
temp_file <- tempfile()
url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file)
txt <- pdf_text(temp_file)
file.remove(temp_file)

# If we examine the object text we notice that it is a character vector with an
# entry for each page. So we keep the page we want using the following code:
raw_data_research_funding_rates <- txt[2]


#steps above can be skipped because it is already loaded in dslabs package
data("raw_data_research_funding_rates")
raw_data_research_funding_rates %>% head

# we see that it is a long string. Each line on the page, including the table 
# rows, is separated by the symbol for newline: \n.

# We can therefore can create a list with the lines of the text as elements
tab <- str_split(raw_data_research_funding_rates, "\n")

# because we start off with just one element in the string, we end up with just one entry
tab <- tab[[1]]

# after examining we see that the information for the column names is the third and fourth entires:
tab %>% head

the_names_1 <- tab[3]
the_names_2 <- tab[4]

#examining the first one
the_names_1

# We want to remove the leading space and everything following the comma. 
# We can use regex for the latter. Then we can obtain the elements by splitting 
# using the space. 
# We want to split only when there are 2 or more spaces to avoid splitting 
# success rate. So we use the regex \\s{2,} as follows:
the_names_1 <- the_names_1 %>%
  str_trim() %>%
  str_replace_all(",\\s.", "") %>%
  str_split("\\s{2,}", simplify = TRUE)
the_names_1

#examining the second one
the_names_2

# Here we want to trim the leading space and then split by space as we did 
# for the first line:
the_names_2 <- the_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE)
the_names_2

# joining to generate one name for each column
tmp_names <- str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_")

the_names <- c(the_names_2[1], tmp_names) %>%
  str_to_lower() %>%
  str_replace_all("\\s", "_")
the_names

# examining tab again, the data is in lines 6 - 14. Use str_split to separate by spaces
new_research_funding_rates <- tab[6:14] %>%
  str_trim %>%
  str_split("\\s{2,}", simplify = TRUE) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  setNames(the_names) %>%
  mutate_at(-1, parse_number)
new_research_funding_rates %>% head()

# checking to make sure we got the same data given to us in class
identical(research_funding_rates, new_research_funding_rates)

