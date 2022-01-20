require "rexml/document"
require "rexml/xpath"
Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|f| require f}

require "money"

module QuickenParser
  # New API (in version 0.3.0), to allow direct access to the Parser
  # object, which (now) has other (potentially) useful methods than just
  # #accounts (notably: #metadata):
  def self.parser(stream_or_string)
    Parser.new(stream_or_string).parse
  end

  # For backwards compatability, we still provide a version (by the
  # original name) that gives #accounts back:
  def self.parse(stream_or_string)
    parser(stream_or_string).accounts
  end
end
