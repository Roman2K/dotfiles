def bench(runs=1_000_000)
  t1 = Time.now
  runs.times { yield }
  Time.now - t1
end
