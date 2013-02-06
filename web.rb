#coding:utf-8

require 'sinatra'
require './dynamo_connect.rb'
require './dynamo_read.rb'
require './dynamo_write.rb'
require './dynamo_auth.rb'

get '/' do 
  p Time.now.utc
  p $session.expires_at
  p $session.expires_at - Time.now.utc
  content_type:txt
  return <<'EOS'
Hello! :)   I'm kuwai, made by Naohiro OHTA

Try to send HTTP GET Method with below URLs.
(this server)/api/0/{"method":["auth"],"who":["test@t.com","7b18ae007dab03abd77b397bf5058aa795a7352def052831629d2087c3bb8cba","browser1"]}
(this server)/api/0/{"method":["auth"],"who":["test@t.com","7b18ae007dab03abd77b397bf5058aa795a7352def052831629d2087c3bb8cba","browser1"]}?callback=Yay
(this server)/api/0/{"method":["list","Good Company","2013-01"],"who":["test@t.com","7b18ae007dab03abd77b397bf5058aa795a7352def052831629d2087c3bb8cba","browser1"]}

0 is length of jsop-string( "{" to "}" ) to verify on server.
0 means "Do no verify".

kuwai is not REST.
Although request is data changing one, kuwai use HTTP GET Method 'Cos wanna use jsonp.
Mmm... but.. is this ok?...  with Chrome Prerendering...
https://developers.google.com/chrome/whitepapers/prerender

EOS
end


def pad(callback_name, content)
  if(callback_name==nil || callback_name.strip.length==0) then
    return content
  else
    return "#{callback_name}(#{content})"
  end
end


# Why get, not post - 'cas wanna use jsonp
get '/api/*/*' do |verify_length_as_string, asking_json|
  content_type:json
  verify_length = verify_length_as_string.to_i
  puts "verify_length is,#{verify_length}. asking_json.length is,#{asking_json.length}."
  puts "asking_json is,"
  puts asking_json
  
  if(verify_length == 0) then
    # Do no verification.
  else
    if(asking_json.length != verify_length) then 
      return "Verify failed.. We expected #{verify_length} letters json-string. But Your json has #{asking_json.length} letters."
    end
  end
  
  ask = JSON.parse(asking_json)
  who = ask["who"]
  mthd = ask["method"]
  p who
  
  begin
    result = ""
    sw = Stopwatch.new("auth2")
    if( ! auth2(who[0],who[1])) then return pad params[:callback],'["Wrong_email_or_password"]' end
    sw.stop
    case mthd[0]
      when "list" then
        result = pad params[:callback],records(mthd[1],mthd[2])
      when "one" then
        result = pad params[:callback],record(mthd[1],mthd[2])
      when "auth" then
        result = pad params[:callback],'["Authed"]'
      else
    end
  rescue AWS::STS::Errors
    Dynamo.make_session
    Dynamo.connect
    p result = "AWS::STS::Errors ERROR OCCUERED============="
  rescue
    Dynamo.make_session
    Dynamo.connect
    p result = "STANDARD ERROR OCCUERED========================================"
  else
    Dynamo.make_session
    Dynamo.connect
    p result = "OTHER ERROR OCCUERED========================================"
  ensure
    return result
  end
end
