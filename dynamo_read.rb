#coding:utf-8
require 'aws/dynamo_db'
require './jsonp_from_dynamo_data.rb'

public
def records(tenant,range_begins_with)
  # Query API
  items = Dynamo.db.tables["kuwai_records"].load_schema.items.query(hash_value:tenant, range_begins_with:range_begins_with)
  Jsonp.jsonp_from_dynamo_items items
end

def record(tenant,range_value)
  item = Dynamo.db.tables["kuwai_records"].load_schema.items[tenant, range_value]
  Jsonp.jsonp_from_dynamo_item_attrs item
end
