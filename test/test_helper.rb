require "rubygems"
require "test/unit"

gem "thoughtbot-shoulda", "~> 2.0.5"
require "shoulda"

require "quicken_parser"

module Assertions
  def assert_include(object, collection, message=nil)
    message = build_message(message, "Expected <?> to include <?>", collection, object)
    assert_block do
      collection.include?(object) 
    end
  end
end

module ShouldaMacros
  def should_be(klass)
    klass = self.klass
    should "have #{klass.name} as an ancestor" do
      assert_include klass, klass.ancestors
    end
  end

  def should_respond_to(method)
    model_name = self.model_name
    should "respond_to #{method}" do
      assert_respond_to instance_variable_get("@#{model_name}"), method
    end
  end

  def class_name
    self.name.sub("Test", "")
  end

  def klass
    begin
      Object.const_get(class_name)
    rescue NameError
      QuickenParser.const_get(class_name)
    end
  end

  def model_name
    model_name = class_name.downcase
  end
end

class Test::Unit::TestCase
  include Assertions
  extend ShouldaMacros
end
