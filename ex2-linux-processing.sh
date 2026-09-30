#!/bin/bash
/usr/bin/lsof | jc --lsof | jq -c '.[] | {user, pid, command,type}' | /usr/bin/sort | uniq -c | /usr/bin/sort -k1nr