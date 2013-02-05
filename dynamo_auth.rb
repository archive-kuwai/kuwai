#coding:utf-8
require 'aws/dynamo_db'
require './dynamo_connect.rb'
require './stopwatch.rb'

def auth(email,key)
  if(email==nil || email=='') then return false end
  if(key==nil || key=='') then return false end
  
  sw = Stopwatch.new("auth")
  attrs = @@kuwai_endusers.items[email].attributes
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
  b = @@kuwai_endusers2.items[email,key].exists?
  sw.stop
  return b
end


sw = Stopwatch.new("Load schema of kuwai_endusers")
@@kuwai_endusers = Dynamo.db.tables["kuwai_endusers"].load_schema
sw.stop
sw = Stopwatch.new("Load schema of kuwai_endusers2")
@@kuwai_endusers2 = Dynamo.db.tables["kuwai_endusers2"].load_schema
sw.stop



puts "Testing auth..."
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"
puts auth2 "naohta@gmail.com","xxx"

p @@kuwai_records
