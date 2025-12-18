use std::{env, time::Instant};
use sysinfo::{System};

fn fibo(n: i32, words: &mut String) -> i32 {
    if n > 30 {
        panic!("N too large");
    }
    if n <= 2 {
        return 1
    }

    words.push_str("abcdefghijklmnopqrstuvwxyz ");

    let a = fibo(n - 2, words);
    let b = fibo(n - 1, words);

    a + b
}

fn main() {
    let n: i32 = env::var("N")
        .unwrap_or_else(|_| "10".to_string())
        .parse()
        .unwrap();

    let mut sys = System::new_all();
    sys.refresh_all();

    let pid = sysinfo::get_current_pid().unwrap();
    let process = sys.process(pid).unwrap();

    // --------- METRICS WRAPPER ---------
    let mem_before = process.memory();      // KB
    let cpu_before = process.cpu_usage();   // %
    let start = Instant::now();

    // CORE
    let mut word = String::new();
    let val = fibo(n, &mut word);

    // --------- METRICS AFTER ---------
    let duration = start.elapsed();

    sys.refresh_all();
    let process = sys.process(pid).unwrap();

    let mem_after = process.memory();        // KB
    let cpu_after = process.cpu_usage();     // %

    // --------- RESULTS ---------
    println!("value={}", val);

    println!("\n--- METRICS ---");
    println!("time_us={} in microseconds", duration.as_micros());
    println!("memory_before_kb={}", mem_before);
    println!("memory_after_kb={}", mem_after);
    println!("cpu_before_percent={}", cpu_before);
    println!("cpu_after_percent={}", cpu_after);
}
