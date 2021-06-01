require 'sinatra/base'
require 'rest-client'
require 'sinatra/cross_origin'

module MyProxy
  class API < Sinatra::Base
    require 'json'
    require 'net/http'

    configure :development, :test do
      require 'sinatra/reloader'
      require 'byebug'
      register Sinatra::Reloader

    end

    set :server, 'puma'

    before do
      if @request.content_type == 'application/json'
        @request.body.rewind
        @request_payload = JSON.parse(request.body.read) rescue nil
      end
    end

    post '/register/payload' do
      request.body.rewind
      status 200
    end

    get '/' do
      return { status: "ok" }.to_json
    end

    get '/proxy' do
      return status 403 unless request.env['HTTP_AUTHORIZATION'] == ENV['INTEGRATION_KEY']
      begin
        headers 'Access-Control-Allow-Origin' => '*'
        url = params["url"]
        return RestClient.get(url, :Authorization => 'Basic YW9hOjc5MzJ0cmU', :Accept => "application/json")
      rescue => e
        status 500
      end
    end
  end
end
