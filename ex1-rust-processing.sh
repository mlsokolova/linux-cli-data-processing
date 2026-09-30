#!/bin/bash
bat data/quakes/consolidated_data.csv |awk-rs -F'"' '{print $1, $3}'|awk-rs -F',' '{print $16}'|sort|huniq
