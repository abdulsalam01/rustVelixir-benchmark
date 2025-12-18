defmodule Elx do
  def fibo(0, words), do: {0, words}
  def fibo(1, words), do: {1, words}

  def fibo(n, words) when n >= 2 do
    if n > 30, do: raise("N too large")

    new_words = words <> "abcdefghijklmnopqrstuvwxyz "
    {a, words1} = fibo(n - 2, new_words)
    {b, words2} = fibo(n - 1, words1)

    {a + b, words2}
  end

  def run do
    n = System.get_env("N", "10") |> String.to_integer()

    # Enable scheduler stats.
    :erlang.system_flag(:scheduler_wall_time, true)

    mem_before = :erlang.memory()
    proc_mem_before = Process.info(self(), :memory)
    sched_before = :erlang.statistics(:scheduler_wall_time)

    # CORE
    {time_us, {val, _word}} =
      :timer.tc(fn ->
        fibo(n, "")
      end)

    mem_after = :erlang.memory()
    proc_mem_after = Process.info(self(), :memory)
    sched_after = :erlang.statistics(:scheduler_wall_time)

    # RESULTS
    IO.puts("value=#{val}")

    IO.puts("\n--- METRICS ---")
    IO.puts("time_us=#{time_us} in microseconds")
    IO.inspect(mem_before, label: "vm_memory_before")
    IO.inspect(mem_after, label: "vm_memory_after")
    IO.inspect(proc_mem_before, label: "process_memory_before")
    IO.inspect(proc_mem_after, label: "process_memory_after")
    IO.inspect(sched_before, label: "scheduler_before")
    IO.inspect(sched_after, label: "scheduler_after")
  end
end
