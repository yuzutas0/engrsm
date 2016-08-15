# error_handlers
module ErrorHandlers
  extend ActiveSupport::Concern

  # raise 404
  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  # 404
  def render_404(e = nil)
    render_error 404, e, request, params
  end

  # 500
  def render_500(e = nil)
    render_error 500, e, request, params
  end

  private

  # facade
  def render_error(error_code, e = nil, request, params)
    log_exception error_code, e
    render_json error_code, request, params
    render_html error_code
  end

  # logger
  def log_exception(error_code, e = nil)
    logger.warn "Rendering #{error_code.to_s} with exception: #{e.message}" if e
  end

  # json
  def render_json(error_code, request, params)
    render json: { error: "#{error_code.to_s} error" }, status: error_code if request.xhr? || params[:format] == :json
  end

  # html
  def render_html(error_code)
    render file: Rails.root.join("public/#{error_code}.html"), status: error_code, layout: false, content_type: 'text/html'
  end
end
