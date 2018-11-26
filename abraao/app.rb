require 'sinatra/base'
require 'mailgun-ruby'
require 'sinatra'
require 'sendgrid-ruby'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base

include SendGrid

  get '/' do

    erb :contact

  end

  post '/contact' do

    from = Email.new(email: params[:email])
    to = Email.new(email: 'caio.dscamara@gmail.com')
    subject = params[:subject]
    content = Content.new(type: 'text/plain', value: params[:message])
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: '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')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers

    erb :contact_response
  end


end