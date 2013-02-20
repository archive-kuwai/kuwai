#coding:utf-8
require 'aws/dynamo_db'
require './range_key_for_records.rb'

def create_record(tenant,title,others) # 2nd param is range_value, 3rd is KEYVALUE JSON
  attrs = $kuwai_templates.items[tenant,title].attributes
  if(attrs.count==0) then 
    return "[#{title}] is invalid template title for #{tenant}."
  end
  h = {}
  attrs.each_key do |key| h[key] = "（記入なし）" end 
  h[:tenant] = tenant
  h[:range_key] = range_key "太田直宏", title
  h[:"購入金額"] = 1234567890
  $kuwai_records.items.put(h)
  "Done!"
end

