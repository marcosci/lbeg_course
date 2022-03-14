library(lubridate)

ymd("20110604")
mdy("06-04-2011")
dmy("04/06/2011")

arrive <- ymd_hms("2011-06-04 12:00:00")
arrive

leave <- ymd_hms("2011-08-10 14:00:00")
leave

wday(arrive)
wday(arrive, label = TRUE)

x <- c('February 20th 1973',
       "february  14, 2004",
       "Sunday, May 1, 2000",
       "Sunday, May 1, 2000",
       "february  14, 04",
       'Feb 20th 73')

guess_formats(x, "mdy", print_matches = TRUE)

leap_year(arrive)

difftime(leave, arrive)

lubridate::today()  
now()

ymd(date(now()))

mdy("March 6, 1957")
dmy("03/06/2015")


