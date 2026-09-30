#!/bin/bash
~/.cargo/bin/lsof | jc-rs --lsof | jaq -c '.[] | {user, pid, command,type}'|~/.cargo/bin/sort|huniq -c|~/.cargo/bin/sort -k1nr