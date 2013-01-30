#coding:utf-8
require 'sinatra'
def load_backyard
  load './dynamo_read.rb'
  load './dynamo_write.rb'
  load './dynamo_auth.rb'
end
load_backyard

get '/' do "Hello! :) I'm made by Naohiro OHTA" end

before do
  content_type :json
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

def pad(callback_name, s)
  if(callback_name.length == 0) then
    return s
  else
    return "#{callback_name}(#{s})"
  end
end

post '/api/*/*/*' do |callback_name, verify_length, ask_json|
  if(ask_json.length != verify_length.to_i) then 
    return "Verify failed.. Your json has #{ask_json.length} letters. We expected #{verify_length.to_i} letters one."
  end
  
  ask = JSON.parse(ask_json)
  who = ask["who"]
  md = ask["method"]
  
  if( ! auth(who[0],who[1])) then return "Wrong email or password" end
  
  case md[0]
    when "list" then
      return pad callback_name,records(md[1],md[2])
    when "one" then
      return pad callback_name,record(md[1],md[2])
    else
  end
end

get '/signin' do
  content_type :txt
  erb :signin

end


__END__

@@signin
<h1>Sign-in!</h1>
  <input id="login_input_uid" type="text" placeholder="email"></input>
  <input id="login_input_pw" type="password" placeholder="password"></input>
  <input type="button" onClick="try">サインインする</input>




