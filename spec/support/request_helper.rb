# frozen_string_literal: true

module RequestHelper
  def mock_request(*args, **kwargs)
    Rack::Request.new(Rack::MockRequest.env_for(*args, **kwargs))
  end

  def kthnxbye
    post '/api/v1/kthnxbye'
  end

  def echo_get
    get '/api/v1/echo_get?foo=bar'
  end

  def samples_tags_count
    sql = 'SELECT count(*) from api_sampler_samples_tags'
    result = ActiveRecord::Base.connection.execute(sql)
    result.first['count']
  end
end
