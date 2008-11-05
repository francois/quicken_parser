module QuickenParser
  class Transaction
    attr_accessor :type, :timestamp, :amount, :number, :name, :memo

    def initialize(args={})
      args.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def to_s
      "%s: %s %s %s" % [timestamp.to_s, type, name, amount.to_s]
    end
  end
end
