require 'sinatra/base'
require 'rest-client'
require 'sinatra/cross_origin'

module ConsumerComplaints
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

    get '/' do
      return { status: "ok" }.to_json
    end

    get '/proxy' do
      headers 'Access-Control-Allow-Origin' => '*'
      url = params["url"]
      # RestClient.get(url, :Authorization => request.env['HTTP_AUTHORIZATION'])
      RestClient.get(url, :Authorization => 'Basic YW9hOjc5MzJ0cmU', :Accept => "application/json")
    end
  end
end
