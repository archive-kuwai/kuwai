#coding:utf-8
require 'aws/dynamo_db'
require './stopwatch.rb'

def auth(email,key)
  if(email==nil || email=='') then return false end
  if(key==nil || key=='') then return false end
  
  #sw = Stopwatch.new(__method__)
  b = $kuwai_endusers2.items[email,key].exists?
  #sw.stop
  return b
end
