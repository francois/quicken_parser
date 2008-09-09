module QuickenParser
  class Transactions
    attr_accessor :timespan

    def initialize(args={})
      @txns = Array.new
      args.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def <<(txn)
      @txns << txn
    end

    def each
      @txns.each do |txn|
        yield txn
      end
    end
  end
end
