#coding:utf-8
# not available as multi-instance
class Stopwatch
  @start
  @end
  def initialize(s)
    @start = Time.now
    @end = nil
    print "#{[s]}"
  end
  def stop()
    @end = Time.now
    print "#{(@end-@start)*1000}ms/"
  end
end
