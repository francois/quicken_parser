module QuickenParser
  class Transactions
    include Enumerable
    attr_accessor :timespan

    def initialize(args={})
      @txns = Array.new
      args.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def first
      @txns.first
    end

    def last
      @txns.last
    end

    def length
      @txns.length
    end
    alias_method :size, :length

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
