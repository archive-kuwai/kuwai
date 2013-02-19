#coding:utf-8
require 'aws/dynamo_db'
require './jsonp_from_dynamo_data.rb'

public
def records(tenant,range_begins_with)
  # Query API
  items = $kuwai_records.items.query(hash_value:tenant, range_begins_with:range_begins_with)
  Jsonp.jsonp_from_dynamo_items items
end

def record(tenant,range_value)
  item = $kuwai_records.items[tenant, range_value]
  Jsonp.jsonp_from_dynamo_item_attrs item
end

def templates(tenant)
  items = $kuwai_templates.items.query(hash_value:tenant)
  #Jsonp.jsonp_from_dynamo_items items
  ary = []
  items.each do |item|
    ary.push(item.range_value)
  end
  ary.sort!
  ary.to_json
end
