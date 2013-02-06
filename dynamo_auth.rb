#coding:utf-8
require 'aws/dynamo_db'
require './stopwatch.rb'

def auth(email,key)
  if(email==nil || email=='') then return false end
  if(key==nil || key=='') then return false end
  
  sw = Stopwatch.new("auth")
  attrs = $kuwai_endusers.items[email].attributes
  if(attrs.count>=1 && attrs["key"]==key) then
    sw.stop
    return true
  else
    sw.stop
    return false
  end
end



def auth2(email,key)
  if(email==nil || email=='') then return false end
  if(key==nil || key=='') then return false end
  
  sw = Stopwatch.new("auth2")
  b = $kuwai_endusers2.items[email,key].exists?
  sw.stop
  return b
end
