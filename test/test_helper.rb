require "minitest/unit"
require "minitest/autorun"
require "mocha/setup"
require "rack"
require "rack/test"

require_relative "../lib/style_palette"

class MiniTest::Unit::TestCase
  FIXTURES = File.expand_path("#{File.dirname(__FILE__)}/fixtures")
end

