# Elixir vs Rust – Fibonacci & String Allocation Benchmark

This repository contains a **simple, focused benchmark** to compare **Elixir (BEAM)** and **Rust (native)** behavior when running:

* recursive Fibonacci
* repeated string appends
* runtime metrics (time, memory, CPU)

The goal is **not to prove one language is better**, but to **observe differences in execution model, memory behavior, and observability**.

---

## Repository Structure

```text
.
├── elx/   # Elixir (BEAM) implementation
│   └── mix project
│
├── rsx/   # Rust (native) implementation
│   └── cargo project
│
└── README.md
```

---

## What Is Being Measured

Both implementations run:

* Fibonacci recursion
* String growth during recursion

And collect:

* execution time
* memory usage (before / after)
* CPU usage (best-effort, platform dependent)

️ **Metrics are not 1:1 identical** due to different runtimes:

* Elixir runs on the **BEAM VM**
* Rust runs as a **native OS process**

---

## `elx/` – Elixir Benchmark

### Purpose

Measure:

* BEAM VM memory (`:erlang.memory/0`)
* Process memory
* Scheduler wall time (CPU-like metric)
* Execution time

### Requirements

* Elixir >=  1.18
* Erlang/OTP ≥ 25

### How to Run

```bash
cd elx
mix deps.get
N=10 mix run -e "Elx.run()
```

### What You’ll See

* Fibonacci result
* Final string
* VM memory before / after
* Process memory before / after
* Scheduler wall-time stats
* Execution time (microseconds)

### Notes

* Uses **pure Elixir**
* No external dependencies
* Metrics come directly from the BEAM runtime

---

## `rsx/` – Rust Benchmark

### Purpose

Measure:

* Execution time
* Process memory (RSS)
* CPU usage (OS-reported)

### Requirements

* Rust ≥ 1.70
* Cargo
* Supported OS: Linux / macOS (Windows may vary)

### How to Run

```bash
cd rsx
N=10 cargo run --release
```

> Use `--release` for realistic performance results.

### What You’ll See

* Fibonacci result
* Final string
* Execution time (microseconds)
* Memory usage before / after (KB)
* CPU usage before / after (%)

### Notes

* Uses `sysinfo` crate for metrics
* Memory = **process RSS**
* CPU usage is **sampling-based** (short runs may show `0.0%`)

---

## Important Differences (Expected)

| Aspect          | Elixir                | Rust             |
| --------------- | --------------------- | ---------------- |
| Runtime         | BEAM VM               | Native           |
| Memory model    | GC + immutable        | Manual ownership |
| CPU metric      | Scheduler wall time   | OS CPU usage     |
| Observability   | Very deep             | OS-level         |
| String behavior | Binary allocation     | Heap allocation  |
| Concurrency     | Lightweight processes | OS threads       |

Differences in metrics are **expected and intentional**.

---

## Benchmark Philosophy

* This repo is **educational**
* Fibonacci is intentionally **not optimal**
* String growth is intentionally **allocation-heavy**
* Focus is on **behavior**, not raw speed

---

## Disclaimer

* Results vary by:

  * OS
  * hardware
  * compiler / OTP version
* Do **not** use Fibonacci as a real-world benchmark
* Use this repo to **learn runtime characteristics**

---

## Suggested Experiments

* Increase `n` and observe memory growth
* Switch Elixir to iodata
* Switch Rust to `&mut String`
* Run Rust with jemalloc
* Run Elixir with `:observer.start/0`

---

## License

Abdul Salam (@abdulsalam01)
