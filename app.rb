require 'json'
require 'sinatra'
require 'sinatra/activerecord'

require './config/database'

Dir["./app/models/*.rb"].each {|file| require file }
Dir["./app/services/**/*.rb"].each {|file| require file }

class App < Sinatra::Base
  get '/sinatra' do
    'Hello world Sinatra!'
  end

  post '/webhook' do
    result = JSON.parse(request.body.read)["result"]
    if result["contexts"].present?
      response = InterpretService.call(result["action"], result["contexts"][0]["parameters"])
    else
      response = InterpretService.call(result["action"], result["parameters"])
    end
    response += request.body.read.to_s
    response += 'olákkk'
    content_type :json
    {
      "speech": response,
      "displayText": response,
      "source": "OneBitBot"
    }.to_json
  end
end
