require 'rubyunit'
require 'irbsh-util.rb'

class TestOnceProc < RUNIT::TestCase

  def test_call
    x = OnceProc.new { 1 }
    assert_equal(1, x.call)
    assert_equal(nil, x.call)
    assert_equal(nil, x.call)

    x = OnceProc.new {|a| a*2}
    assert_equal(2,x[1])
    assert_equal(nil, x[1])

  end

  def test_s_new
    assert(OnceProc.new{})
    assert_exception(ArgumentError){ OnceProc.new }
  end

end

