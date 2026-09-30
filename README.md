# Lean data processing

## Environment:
OS: Fedora 38
Rust: 1.90.0

## Tools

```
cargo install bat #rust cat clone
cargo install awk-rs #rust awk clone
cargo install huniq #rust uniq clone
cargo install gnu-sort #rust sort clone
which sort
~/.cargo/bin/sort
cargo install lsof
which lsof
~/.cargo/bin/lsof
cargo install jaq
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
bat data/quakes/consolidated_data.csv |awk-rs -F'"' '{print $1, $3}'|awk-rs -F',' '{print $16}'|sort|huniq
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
  Time (mean ± σ):     24.759 s ±  1.262 s    [User: 43.930 s, System: 2.018 s]
  Range (min … max):   22.437 s … 26.006 s    10 runs
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
lsof | jc-rs --lsof | jaq -c '.[] | {user, pid, command,type}'|sort|huniq -c|sort -k1nr
```

### Benchmark

#### Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M" ./ex2-linux-processing.sh > /dev/null
time: 24.49
percent of CPU: 91%
maximum resident set size, kb: 761476

./ex2-linux-processing.sh
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
