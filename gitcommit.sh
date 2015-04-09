#!/bin/sh
cd /home/susan/Programming/Rprojects/AuburnWeather
R CMD BATCH ./ScrapeWeather.R
git commit -a -m "CRON Auto-Commit after script runs"
git push
