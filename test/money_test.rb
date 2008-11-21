require File.dirname(__FILE__) + "/test_helper"

class MoneyTest < Test::Unit::TestCase
  should "parse '-14.24 EUR' as 14.24 EUR" do
    assert_equal Money.new(-1424, "EUR"), "-14.24 EUR".to_money
  end

  should "parse '14.24 CAD' as 14.24 CAD" do
    assert_equal Money.new(1424, "CAD"), "14.24 CAD".to_money
  end
end
