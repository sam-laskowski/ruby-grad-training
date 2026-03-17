class ApplicationController < ActionController::Base
  include Authenticated
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def hello
    render html: ""
  end

end
