#!/bin/bash
cd /Users/bouzenaali/Developer/job/Scrapy-schedule/schedule/schedule
source .venv/bin/activate
scrapy crawl example -o scheduled.csv
deactivate