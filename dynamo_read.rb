#encoding:utf-8
require 'aws/dynamo_db'
require './dynamo_connect.rb'
require './jsonp_from_dynamo_data.rb'

def list_records(tenant,range_bengins_with)

  # Scan API
  # items = Dynamo.db.tables["notices"].load_schema.items.where(:submit_date).begins_with(s)
  
  # Query API
  items = Dynamo.db.tables["kuwai_records"].load_schema.items.query(hash_value:tenant, range_begins_with:range_bengins_with)

  Jsonp.jsonp_from_dynamo_items items
end


def one(tenant,range_value)
  item = Dynamo.db.tables["kuwai_records"].load_schema.items[tenant, range_value]
  Jsonp.jsonp_from_dynamo_item_attrs item
end

