require_relative "test_helper"
require_relative "../lib/style_palette/grille"

class StylePaletteGalleryTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    StylePalette.palettes_config = "#{FIXTURES}/style_palettes.json"
  end

  def app
    StylePaletteGallery::App
  end

  def test_index
    get "/"

    assert_match "<li class=\"label\" style=\"style 1\">{:style=&gt;&quot;style 1&quot;}</li>", last_response.body
  end

  def test_add_word
    get "/add_word", :word => "test", :palette_name => "tags"
    assert_equal "<li><span class=\"label\" style=\"style 9\">test</span></li>", last_response.body
  end
end