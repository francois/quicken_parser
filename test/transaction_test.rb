require File.dirname(__FILE__) + "/test_helper"

class TransactionTest < Test::Unit::TestCase
  context "A transaction" do
    setup do
      @transaction = QuickenParser::Transaction.new
    end

    %w(type timestamp amount number name memo).each do |attr|
      should_respond_to attr
      should_respond_to "#{attr}="
    end
  end
end
