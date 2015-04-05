class NumberFormatter
  def initialize(multiple, units)
    @multiple = multiple
    @units = units
  end

  def format(n)
    @units.each.with_index do |name, index|
      in_unit = n.to_f / @multiple ** index
      next if in_unit > @multiple && index < @units.size - 1
      in_unit = ("%.1f" % in_unit).sub(/\.0$/, '')
      return "#{in_unit}#{name}#{@suffix}"
    end
  end
end

NUM_FMT = NumberFormatter.new(1000, ['', 'k', 'm', 'g', 't'])
TIME_FMT = NumberFormatter.new(1000, ['µs', 'ms', 's'])

def bench(runs=1_000_000)
  t0 = Time.now
  runs.times { yield }
  (Time.now - t0).tap do |total|
    puts "%s runs @ %s/s | %s/iteration" % [
      NUM_FMT.format(runs),
      NUM_FMT.format(runs / total),
      TIME_FMT.format(total / runs * 1_000_000),
    ]
  end
end
