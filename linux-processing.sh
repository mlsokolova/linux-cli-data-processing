#!/bin/bash
cat data/quakes/consolidated_data.csv |awk -F'"' '{print $1, $3}'|awk -F',' '{print $16}'|/bin/sort|uniq > /dev/null
