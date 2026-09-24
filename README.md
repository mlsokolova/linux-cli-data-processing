## Tools

```
cargo install bat
cargo install awk-rs
cargo install huniq
cargo install gnu-sort
which sort
~/.cargo/bin/sort
```

## Data
https://www.kaggle.com/datasets/danielpe/earthquakes

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

