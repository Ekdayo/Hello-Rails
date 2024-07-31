class PrometheusHttpMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now
    status, headers, response = @app.call(env)
    duration = Time.now - start_time

    PrometheusMetrics.send_json(
      type: 'http_requests_total',
      value: 1,
      labels: { path: env['PATH_INFO'], method: env['REQUEST_METHOD'], status: status }
    )

    PrometheusMetrics.send_json(
      type: 'http_request_duration_seconds',
      value: duration,
      labels: { path: env['PATH_INFO'], method: env['REQUEST_METHOD'] }
    )

    [status, headers, response]
  end
end

