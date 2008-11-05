require File.dirname(__FILE__) + "/test_helper"

class AccountTest < Test::Unit::TestCase
  context "An account" do
    setup do
      @account = QuickenParser::Account.new
    end

    %w(number bank_id type currency transactions).each do |attr|
      should_respond_to attr
      should_respond_to "#{attr}="
    end
  end
end
