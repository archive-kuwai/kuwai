#coding:utf-8
require 'aws/dynamo_db'
require './dynamo_connect.rb'

def auth(email,key)
  attrs = Dynamo.db.tables["kuwai_endusers"].load_schema.items[email].attributes
  if(attrs.count>=1 && attrs["key"]==key) then
    return true
  else
    return false
  end
end


puts "Testing auth..."
puts auth "naohta@gmail.com","XYZ123456789"
