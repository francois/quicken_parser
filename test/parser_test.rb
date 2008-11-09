require File.dirname(__FILE__) + "/test_helper"

class ParserTest < Test::Unit::TestCase
  context "A Quicken file with 2 accounts" do
    setup do
      @content = fixture(:two_accounts)
      @parser = QuickenParser::Parser.new(@content.dup)
      @parser.parse
    end

    should "return two accounts" do
      assert_equal 2, @parser.accounts.length
    end

    should "have one transaction per account" do
      assert @parser.accounts.all? {|account| account.transactions.length == 1}
    end
  end

  context "A Quicken file whose transactions don't have memos" do
    setup do
      @content = fixture(:no_memo)
      @parser = QuickenParser::Parser.new(@content.dup)
      @parser.parse
      @account = @parser.accounts.first
      @transaction = @account.transactions.first
    end

    should "return nil as the memo on the transaction" do
      assert_nil @transaction.memo
    end
  end

  context "A Quicken file with one credit card" do
    setup do
      @content = fixture(:one_cc)
    end

    context "that was parsed" do
      setup do
        @parser = QuickenParser::Parser.new(@content.dup)
        @parser.parse
        @account = @parser.accounts.first
      end


      should "have a single account" do
        assert_equal 1, @parser.accounts.length
      end

      should "have no bank ID" do
        assert_nil @account.bank_id
      end

      should "be from account 4510912839238" do
        assert_equal "4510912839238", @account.number
      end

      should "be a credit card account" do
        assert_equal "CREDITCARD", @account.type
      end

      should "return 'CAD' as the currency" do
        assert_equal "CAD", @account.currency
      end

      should "have a single transaction" do
        assert_equal 1, @account.transactions.length
      end

      should "have transactions covering 2008-07-08 noon to 2008-10-28 noon" do
        span = Time.local(2008, 7, 8, 12, 0, 0) .. Time.local(2008, 10, 28, 12, 0, 0)
        assert_equal span, @account.transactions.timespan
      end

      context "the transaction" do
        setup do
          @transaction = @account.transactions.first
        end
      end
    end
  end

  context "A Quicken file with one bank account" do
    setup do
      @content = fixture(:one_account)
    end

    context "that was parsed" do
      setup do
        @parser = QuickenParser::Parser.new(@content.dup)
        @parser.parse
        @account = @parser.accounts.first
      end

      should "have a single account" do
        assert_equal 1, @parser.accounts.length
      end

      should "be from bank id 302010140" do
        assert_equal "302010140", @account.bank_id
      end

      should "be from account 065412036771" do
        assert_equal "065412036771", @account.number
      end

      should "be a checking account" do
        assert_equal "CHECKING", @account.type
      end

      should "return 'CAD' as the currency" do
        assert_equal "CAD", @account.currency
      end

      should "have a single transaction" do
        assert_equal 1, @account.transactions.length
      end

      should "have transactions covering 2008-07-08 noon to 2008-10-28 noon" do
        span = Time.local(2008, 7, 8, 12, 0, 0) .. Time.local(2008, 10, 28, 12, 0, 0)
        assert_equal span, @account.transactions.timespan
      end

      context "the transaction" do
        setup do
          @transaction = @account.transactions.first
        end

        should "dated 2008-07-08 noon" do
          assert_equal Time.local(2008, 7, 8, 12, 0, 0), @transaction.timestamp
        end

        should "have an ID of 90000010020080708C00131479599" do
          assert_equal "90000010020080708C00131479599", @transaction.number
        end

        should "be a DEBIT" do
          assert_equal "DEBIT", @transaction.type
        end

        should "have a name of 'PAIEMENT DIVERS'" do
          assert_equal "PAIEMENT DIVERS", @transaction.name
        end

        should "have a memo of 'PAYPAL PTE LTD'" do
          assert_equal "PAYPAL PTE LTD", @transaction.memo
        end

        should "be of an amount of -14.24" do
          assert_equal Money.new(-1424, "CAD"), @transaction.amount
        end
      end
    end
  end

  protected
  def fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.txt")
  end
end
