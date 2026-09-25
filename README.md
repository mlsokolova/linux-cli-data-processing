# CLI tools(Linux-native vs Rust) for data processing

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
```

## Data
https://www.kaggle.com/datasets/danielpe/earthquakes

Dataset size: 609M
Rows: 3272775

## Processing

### Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M"  cat data/quakes/consolidated_data.csv |awk -F'"' '{print $1, $3}'|awk -F',' '{print $16}'|/bin/sort|uniq > /dev/null
```

### Rust Clones of the Linux CLI Tools
```
/usr/bin/time --format="time: %e\npercent of CPU: %P\nmaximum resident set size, kb: %M"  bat data/quakes/consolidated_data.csv |awk-rs -F'"' '{print $1, $3}'|awk-rs -F',' '{print $16}'|sort|huniq > /dev/null
```

## Benchmarking
```
hyperfine ./linux-processing.sh 
hyperfine ./rust-processing.sh
```

## Results
Linux CLI tools take 44% longer than the faster one.
Rust rewritings take 3 times more CPU and memory

