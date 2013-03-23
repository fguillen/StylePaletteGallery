require_relative "test_helper"

class StylePaletteGalleryTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    StylePalette.reset
    StylePaletteGallery::App.any_instance.stubs(:default_config).returns(File.read("#{FIXTURES}/style_palettes.json"))
  end

  def app
    StylePaletteGallery::App
  end

  def test_index
    get "/"

    assert_match "<li class=\"label\" style=\"style 1\">{:style=&gt;&quot;style 1&quot;}</li>", last_response.body
    assert_equal(File.read("#{FIXTURES}/style_palettes.json"), rack_mock_session.cookie_jar["style_palettes_config"])
  end

  def test_add_word
    StylePalette.palettes_config_json(File.read("#{FIXTURES}/style_palettes.json"))
    get "/add_word", :word => "test", :palette_name => "tags"
    assert_equal "<li><span class=\"label\" style=\"style 9\">test</span></li>", last_response.body
  end

  def test_config
    post(
      "/config",
      :style_palettes => File.read("#{FIXTURES}/style_palettes_2.json")
    )

    follow_redirect!

    assert_match "<li class=\"label\" style=\"style alternative\">{:style=&gt;&quot;style alternative&quot;}</li>", last_response.body
    assert_equal(File.read("#{FIXTURES}/style_palettes_2.json"), rack_mock_session.cookie_jar["style_palettes_config"])
  end

  def test_reset
    StylePalette.palettes_config_json("{}")

    get "/reset"

    follow_redirect!

    assert_match "<li class=\"label\" style=\"style 1\">{:style=&gt;&quot;style 1&quot;}</li>", last_response.body
    assert_equal(File.read("#{FIXTURES}/style_palettes.json"), rack_mock_session.cookie_jar["style_palettes_config"])
  end
end