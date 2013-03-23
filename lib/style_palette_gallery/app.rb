class StylePaletteGallery::App < Sinatra::Base
  include ERB::Util

  set :raise_errors, true
  set :show_exceptions, true

  get "/" do
    reset_style_palettes_config if StylePalette.palettes_config.nil?
    @palettes = StylePalette.palettes
    erb File.read("#{File.dirname(__FILE__)}/template.html.erb")
  end

  get "/add_word" do
    "<li>#{StylePalette::Helper.label(params[:word], params[:palette_name])}</li>"
  end

  get "/reset" do
    reset_style_palettes_config
    redirect "/"
  end

  post "/config" do
    set_style_palettes_config params[:style_palettes]
    redirect "/"
  end

  def set_style_palettes_config(json)
    response.set_cookie("style_palettes_config", :value => json)
    StylePalette.palettes_config_json(json)
  end

  def reset_style_palettes_config
    style_palettes_config_json = default_config
    set_style_palettes_config(style_palettes_config_json)
  end

  def default_config
    File.read("#{File.dirname(__FILE__)}/../../etc/style_palettes.example.json")
  end
end