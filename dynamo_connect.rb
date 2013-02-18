#coding:utf-8
require './stopwatch.rb'
require 'aws/sts'
require 'aws/dynamo_db'

class Dynamo

  private
  def self.make_session
    keys = read_aws_keys
    sw = Stopwatch.new(__method__);
    sts = AWS::STS.new(access_key_id:keys[0],secret_access_key:keys[1])
    $session = sts.new_session(duration:60*60*36)#Seconds. Must be greater than 900 seconds.
    AWS.config({dynamo_db_endpoint:"dynamodb.ap-northeast-1.amazonaws.com"})
    sw.stop
  end

  def self.connect
    sw = Stopwatch.new(__method__);
    @@db = AWS::DynamoDB.new(
      access_key_id: $session.credentials[:access_key_id],
      secret_access_key: $session.credentials[:secret_access_key],
      session_token: $session.credentials[:session_token]
    )
    sw.stop
    load_schemas
  end
  
  def self.load_schemas
    sw = Stopwatch.new(__method__)
    $kuwai_endusers = Dynamo.db.tables["kuwai_endusers"].load_schema
    $kuwai_endusers2 = Dynamo.db.tables["kuwai_endusers2"].load_schema
    $kuwai_records = Dynamo.db.tables["kuwai_records"].load_schema
    $kuwai_templates = Dynamo.db.tables["kuwai_templates"].load_schema
    $kuwai_tenants = Dynamo.db.tables["kuwai_tenants"].load_schema
    sw.stop
  end
  
  def self.read_aws_keys
    sw = Stopwatch.new(__method__)
    print "Will read AWS keys from env ... "
    keys = [ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_KEY']]
    if(keys[0]==nil) then
      puts "No AWS environment variables here. So I will read local secrets file."
      begin
        h = Hash[*File.read('.nao.secrets').split(/[ \n]+/)] 
        keys = [ h['AWS_ACCESS_KEY'], h['AWS_SECRET_KEY'] ]
        if(keys[0]==nil) then sw.stop;puts "Secret file is here, but no key variables. So I exit.";exit 1;end
      rescue
        sw.stop;puts "No secret file is here. So I exit.";exit 1;end
    end
    sw.stop
    return keys
  end
  
  public
  def self.db
    exp = $session.expires_at - Time.now.utc
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
