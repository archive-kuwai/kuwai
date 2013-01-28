#encoding:utf-8
require 'sinatra'
def load_backyard
  load './dynamo_read.rb'
  load './dynamo_write.rb'
  load './dynamo_auth.rb'
end
load_backyard

get '/' do "Hello! :)" end

before do
  content_type:json
end


get '/read' do read_table_names end
get '/load' do load_backyard; "Backyard programs are loaded." end
get '/time' do time end


get '/template/*' do |title| template title end


#------------------------------------------
get '/create/*/*' do |tenant,title|
  create_record(tenant,title)
end

get '/list/*/*/*' do |tenant,range_begins_with,verify_count|
  if(verify_by_count(count, [tenant,range_begins_with])) then
    return list_records(tenant,range_begins_with)
  else
    return "Verify by counting is failed..."
  end
end



get '/one/*/*' do |tenant,range_value|
  one tenant,range_value
end
#------------------------------------------

post '/api/*/*' do |ask_by_json, verify_length|
  p ask_by_json.length 
  p verify_length.to_i
  if(ask_by_json.length != verify_length.to_i) then return "Verify failed" end
  ask = JSON.parse(ask_by_json)
  p ask["who"]
  p ask["who"]["email"]
  
end






