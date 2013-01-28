#encoding:utf-8
require 'securerandom'

DAY = %w(日 月 火 水 木 金 土)

private
def a_part_of_uuid  #like [e4f0202b-c68c]
  "[#{SecureRandom.uuid[0,13]}]"
end

def tokyo
  Time.now.localtime "+09:00"
end

def ymd(time)
  "#{time.strftime("%Y-%m-%d")}(#{DAY[time.wday]})";
end

def hm(time)
  time.strftime("%H:%M");
end

public
def range_key(creator, title)
  snapshot = tokyo
  "#{ymd snapshot} #{creator} #{title} #{hm snapshot} #{a_part_of_uuid}"
end
