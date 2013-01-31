#coding:utf-8
require 'sinatra'
require './dynamo_read.rb'
require './dynamo_write.rb'
require './dynamo_auth.rb'

before do
  content_type:json
end

get '/' do "Hello! :)   I'm kuwai, made by Naohiro OHTA" end

def pad(callback_name, content)
  if(callback_name.length == 0) then
    return content
  else
    return "#{callback_name}(#{content})"
  end
end

post '/api/*/*/*' do |callback_name, verify_length, asking_json|
  if(asking_json.length != verify_length.to_i) then 
    return "Verify failed.. Your json has #{asking_json.length} letters. We expected #{verify_length.to_i} letters one."
  end
  
  ask = JSON.parse(asking_json)
  who = ask["who"]
  mthd = ask["method"]
  
  if( ! auth(who[0],who[1])) then return "Wrong email or password" end
  
  case mthd[0]
    when "list" then
      return pad callback_name,records(mthd[1],mthd[2])
    when "one" then
      return pad callback_name,record(mthd[1],mthd[2])
    when "sign_in_gate" then
      content_type :html
      return erb :sign_in_gate
    else
  end
end

get '/sign_in_gate' do
  content_type :txt
  erb:sign_in_gate
end

