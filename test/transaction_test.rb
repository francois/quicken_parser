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
  
  context "A new transation with identical name and memo" do
    setup do
      @transaction = QuickenParser::Transaction.new(:name => "FONDUE FOLIE SHERBROOKE QC", :memo => "FONDUE FOLIE SHERBROOKE QC")
    end

    should "NOT change the name" do
      assert_equal "FONDUE FOLIE SHERBROOKE QC", @transaction.name
    end

    should "set the memo to nil" do
      assert_nil @transaction.memo
    end
  end
end
