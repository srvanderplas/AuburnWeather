#!/bin/sh
cd /home/susan/Documents/R\ Projects/AuburnWeather
R CMD BATCH ./ScrapeWeather.R
git commit -m "CRON Auto-Commit after script runs"
git push
