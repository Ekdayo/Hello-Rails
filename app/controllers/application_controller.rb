class ApplicationController < ActionController::Base
  rescue_from StandardError do |exception|
    ERROR_COUNTER.observe(1)
    raise exception
  end
end

