$:.unshift __dir__

require 'minitest/autorun'
require 'console_utils'

class NumberFormatterTest < Minitest::Unit::TestCase
  def test_format
    fmt = NumberFormatter.new(1000, ['', 'k', 'm'])
    assert_equal "-1", fmt.format(-1)
    assert_equal "0", fmt.format(0)
    assert_equal "1", fmt.format(1)
    assert_equal "999", fmt.format(999)
    assert_equal "1k", fmt.format(1000)
    assert_equal "1.5k", fmt.format(1500)
    assert_equal "1.9k", fmt.format(1900)
    assert_equal "2k", fmt.format(1950)
    assert_equal "1000m", fmt.format(1_000_000_000)
    assert_equal "1000m", fmt.format(1_000_000_001)
  end
end
