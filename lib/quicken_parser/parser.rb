require "money"
require "time"

module QuickenParser
  class Parser #:nodoc:
    def initialize(source)
      @input = source.respond_to?(:read) ? source.read : source
    end

    def parse
      normalize_line_endings!
      add_xml_decl!
      close_sgml_decl!
      remove_sgml_options!

      @doc = REXML::Document.new(@input)
      self
    end

    def accounts
      return @account if @account
      @accounts = Array.new
      REXML::XPath.each(@doc.root, "//STMTRS") do |xml|
        @accounts << account_from_xml(xml)
      end

      @accounts
    end

    def account_from_xml(xml)
      currency     = REXML::XPath.first(xml, ".//CURDEF").text
      bank_id      = REXML::XPath.first(xml, ".//BANKID").text
      account_id   = REXML::XPath.first(xml, ".//ACCTID").text
      account_type = REXML::XPath.first(xml, ".//ACCTTYPE").text

      account = Account.new(:currency => currency, :bank_id => bank_id, :number => account_id, :type => account_type, :transactions => Transactions.new)

      xmldatefrom  = REXML::XPath.first(xml, ".//DTSTART").text
      xmldateto    = REXML::XPath.first(xml, ".//DTEND").text
      account.transactions.timespan = parse_date(xmldatefrom)..parse_date(xmldateto)

      REXML::XPath.each(xml, ".//STMTTRN") do |xmltxn|
        type        = text_or_nil(xmltxn, ".//TRNTYPE")
        date_posted = text_or_nil(xmltxn, ".//DTPOSTED")
        amount      = text_or_nil(xmltxn, ".//TRNAMT")
        txnid       = text_or_nil(xmltxn, ".//FITID")
        name        = text_or_nil(xmltxn, ".//NAME")
        memo        = text_or_nil(xmltxn, ".//MEMO")

        account.transactions << Transaction.new(:type => type, :timestamp => parse_date(date_posted), :amount => "#{account.currency} #{amount}".to_money, :number => txnid, :name => name, :memo => memo)
      end

      account
    end

    def parse_date(xmldate)
      if timestamp = Time.parse(xmldate) then
        timestamp
      else
        raise DateParsingError, "Could not parse XML formatted date #{xmldate.inspect}"
      end
    end

    def normalize_line_endings!
      @input.gsub!("\r\n", "\n")
      @input.gsub!("\r", "\n")
    end

    def add_xml_decl!
      encoding = nil
      match = @input.match(/CHARSET:(.+)/)
      if match then
        case match[1]
        when "1252"
          encoding = "windows-1252"
        else
          raise UnsupportedEncodingException, "Could not parse encoding with name #{match[1]}"
        end
      else
        encoding = "US-ASCII"
      end

      @input = "<?xml version=\"1.0\" encoding=\"#{encoding}\"?>\n#{@input}"
    end

    def close_sgml_decl!
      @input.gsub!(/<([A-Z.]+)>(.+)$/, "<\\1>\\2</\\1>")
    end

    def remove_sgml_options!
      @input.gsub!(/^[A-Z]+:[0-9A-Z]+$/, "")
    end

    protected
    def text_or_nil(root, xpath)
      if node = REXML::XPath.first(root, xpath) then
        node.text.chomp.strip
      end
    end

    class UnsupportedEncodingException < RuntimeError; end
  end
end
