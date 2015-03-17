class NumberFormatter
  UNITS = ['', *%w(k m g t)]

  def initialize(multiple=1000, suffix='')
    @multiple = multiple
    @suffix = suffix
  end

  def format(n)
    UNITS.each.with_index do |name, index|
      in_unit = n.to_f / @multiple ** index
      next if in_unit > @multiple && index < UNITS.size - 1
      in_unit = ("%.1f" % in_unit).sub(/\.0$/, '')
      return "#{in_unit}#{name}#{@suffix}"
    end
  end
end

def bench(runs=1_000_000)
  t0 = Time.now
  runs.times { yield }
  (Time.now - t0).tap do |total|
    f = NumberFormatter.new
    puts "%s runs @ %s/s" % [f.format(runs), f.format(runs / total)]
  end
end
