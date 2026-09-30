# Lean data processing

Troubleshooting and RCA are often data-processing jobs: slice and filter large files, count unique values. The useful tools are already on the machine and can be composed with pipes, with no cluster, notebook, or custom program.

This repo looks for **out-of-the-box** pipelines that make that work faster, and checks whether popular Rust clones of those tools (`bat`, `awk-rs`, `huniq`, `gnu-sort`, `jaq`, etc) actually shorten wall time on realistic inputs.

Experiment 1 is bulk file processing (a 609 MB earthquake CSV). 

Experiment 2 is a live system snapshot, count of the open files by user, PID, command and file type  (`lsof` → JSON → counts), closer to an incident loop.

## Results

Wall time is the `hyperfine` mean of 10 runs. CPU % and max RSS are from a single `/usr/bin/time` run.

| Experiment | Pipeline | Wall time | CPU % | Max RSS |
|---|---|---|---|---|
| 1. Earthquake CSV | GNU (`cat`, `awk`, `sort`, `uniq`) | 25.2 s ± 2.2 s | 185% | 10 MB |
| 1. Earthquake CSV | Rust (`bat`, `awk-rs`, `sort`, `huniq`) | 16.3 s ± 0.7 s | 244% | 176 MB |
| 2. Live `lsof` | GNU (`lsof`, `jc`, `jq`, `sort`, `uniq`) | 25.9 s ± 1.5 s | 91% | 761 MB |
| 2. Live `lsof` | Rust (`lsof`, `jc-rs`, `jaq`, `sort`, `huniq`) | 4.2 s ± 0.5 s | 43% | 60 MB |

Rust pipelines finished sooner on both workloads. On the CSV they used more CPU and memory; on `lsof` they used less of both.

## Environment:
OS: Fedora 38  
Rust: 1.90.0  

### Rust utils
bat v0.26.1 #rust cat clone  
awk-rs v0.2.0 #rust awk clone  
huniq v2.7.0 #rust uniq clone  
gnu-sort v1.0.5 #rust sort clone  
lsof v4.10.0  
jaq 3.1.1 #rust jq clone  
jc-rs 0.5.1 #rust jc clone  

### Linux utils
cat (GNU coreutils) 9.1  
GNU Awk 5.1.1  
uniq (GNU coreutils) 9.1  
lsof 4.96.3  
sort (GNU coreutils) 9.1  
jq-1.6  
jc 1.25.2  

## Install Rust crates

```
cargo install bat awk-rs huniq gnu-sort lsof jaq jc-rs
```

## Experiment 1
### Data
https://www.kaggle.com/datasets/danielpe/earthquakes

Dataset size: 609M
Rows: 3272775

### Processing

#### Linux CLI Tools
```
cat data/quakes/consolidated_data.csv |awk -F'"' '{print $1, $3}'|awk -F',' '{print $16}'|/bin/sort|uniq
```

#### Rust Clones of the Linux CLI Tools
```
bat data/quakes/consolidated_data.csv |awk-rs -F'"' '{print $1, $3}'|awk-rs -F',' '{print $16}'|~/.cargo/bin/sort|huniq
```

### Benchmarking

#### Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M"  ./ex1-linux-processing.sh > /dev/null
time: 21.43
percent of CPU: 185%
maximum resident set size, kb: 10240
 
hyperfine ./ex1-linux-processing.sh 
Benchmark 1: ./ex1-linux-processing.sh
  Time (mean ± σ):     25.225 s ±  2.211 s    [User: 44.021 s, System: 2.049 s]
  Range (min … max):   21.446 s … 27.673 s    10 runs
```

#### Rust Clones of the Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M"  ./ex1-rust-processing.sh > /dev/null
time: 13.63
percent of CPU: 244%
maximum resident set size, kb: 176000

hyperfine ./ex1-rust-processing.sh
Benchmark 1: ./ex1-rust-processing.sh
  Time (mean ± σ):     16.299 s ±  0.735 s    [User: 23.051 s, System: 16.033 s]
  Range (min … max):   14.409 s … 16.998 s    10 runs
```

## Experiment 2

### Processing

#### Linux CLI Tools
```
/usr/bin/lsof | jc --lsof | jq -c '.[] | {user, pid, command,type}' | /usr/bin/sort | uniq -c | /usr/bin/sort -k1nr
```

#### Rust Clones of the Linux CLI Tools
```
~/.cargo/bin/lsof | jc-rs --lsof | jaq -c '.[] | {user, pid, command,type}'|~/.cargo/bin/sort|huniq -c|~/.cargo/bin/sort -k1nr
```

### Benchmark

#### Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M" ./ex2-linux-processing.sh > /dev/null
time: 24.49
percent of CPU: 91%
maximum resident set size, kb: 761476

hyperfine ./ex2-linux-processing.sh
  Time (mean ± σ):     25.893 s ±  1.519 s    [User: 19.391 s, System: 4.006 s]
  Range (min … max):   25.085 s … 30.098 s    10 runs
```

#### Rust Clones of the Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M" ./ex2-rust-processing.sh > /dev/null
time: 3.77
percent of CPU: 43%
maximum resident set size, kb: 59616

hyperfine ./ex2-rust-processing.sh 
Benchmark 1: ./ex2-rust-processing.sh
  Time (mean ± σ):      4.188 s ±  0.457 s    [User: 0.917 s, System: 0.688 s]
  Range (min … max):    3.394 s …  5.006 s    10 run
```
