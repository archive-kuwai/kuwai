#coding:utf-8
require './stopwatch.rb'
require 'aws/sts'
require 'aws/dynamo_db'

class Dynamo

  def self.read_aws_keys
    puts __method__
    puts "I will try to read AWS keys from environment variables..."
    
    p ENV['AWS_ACCESS_KEY']
    p ENV['AWS_ACCESS_KEY_ID']
    #keys = [ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY']]
    #keys = [ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']]
    keys = [ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_KEY']]
    
    if(keys[0]==nil) then
      puts "No AWS environment variables here. So I will read local secrets file."
      h = Hash[*File.read('.nao.secrets').split(/[ \n]+/)] 
      keys = [ h['AWS_ACCESS_KEY'], h['AWS_SECRET_KEY'] ]
      if(keys[0]==nil) then puts "No secret file here. So I exit.";exit 1;end
    end
    return keys
  end

  def self.make_session
    puts __method__
    sw = Stopwatch.new("Create AWS session");
    keys = read_aws_keys
    sts = AWS::STS.new(access_key_id:keys[0],secret_access_key:keys[1])
    @@session = sts.new_session(duration:60*15)#Seconds. Must be greater than 900 seconds.
    AWS.config({dynamo_db_endpoint:"dynamodb.ap-northeast-1.amazonaws.com"})
    sw.stop
  end

  def self.connect
    puts __method__
    sw = Stopwatch.new("Connect to DynamoDB");
    @@db = AWS::DynamoDB.new(
      access_key_id: @@session.credentials[:access_key_id],
      secret_access_key: @@session.credentials[:secret_access_key],
      session_token: @@session.credentials[:session_token]
    )
    sw.stop()
    $session = @@session
    sw = Stopwatch.new("Load schemas")
    $kuwai_endusers = Dynamo.db.tables["kuwai_endusers"].load_schema
    $kuwai_endusers2 = Dynamo.db.tables["kuwai_endusers2"].load_schema
    $kuwai_records = Dynamo.db.tables["kuwai_records"].load_schema
    $kuwai_templates = Dynamo.db.tables["kuwai_templates"].load_schema
    $kuwai_tenants = Dynamo.db.tables["kuwai_tenants"].load_schema
    sw.stop
  end
  
  def self.db
    exp = @@session.expires_at - Time.now.utc
    if(exp<=30) then 
      puts "AWS Session will expires in #{exp}, so we will remake session now."
      make_session
      connect
    end
    @@db
  end
  
  make_session
  connect
end

