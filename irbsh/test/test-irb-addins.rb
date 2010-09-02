# mock IRB module
module IRB
  class Irb
  end
  class Context
  end
  def self.conf
    {}
  end
end

require 'rubyunit'
require 'irb-addins.rb'

class TestIRB__InputFilter < RUNIT::TestCase

  def test_s_input_filter
    [ [ "1\n",
        "1\n"],

      [ " ls\n",
        "irbsh_system %Q( ls)\n"],

      [ "defun x(arg) x+1 end\n",
        "self.class.__send__(:define_method,:x) do |arg| x+1 end\n"],

      [ "defun x(arg)\n",
        "self.class.__send__(:define_method,:x) do |arg|\n"],

      [ "x (arg) x+1\n",
        "self.class.__send__(:define_method,:x) do |arg| x+1 end\n"],

      [ %Q[defun ds (s) s.scanf("%d%s"){|v| v} end\n],
        %Q[self.class.__send__(:define_method,:ds) do |s| s.scanf("%d%s"){|v| v} end\n]],

      [ %Q[ds (s) s.scanf("%d%s"){|v| v}\n],
        %Q[self.class.__send__(:define_method,:ds) do |s| s.scanf("%d%s"){|v| v} end\n]],


      [ "foo();\n",
        "Irbsh.disable_output;foo()\n"],

      [ "foo()$\n",
        "Irbsh.enable_dryrun;foo()\n"],

#      [ "cd  /usr/local/bin/ruby \n",
#        "irbsh_cd %q[/usr/local/bin/ruby]\n"],

      [ " cd\n",
        "irbsh_cd\n"],

      [ " pushd\n",
        "irbsh_pushd\n"],

      [ " cd /usr/bin\n",
        "irbsh_cd %q[/usr/bin]\n"],

      [ " pushd /usr/bin\n",
        "irbsh_pushd %q[/usr/bin]\n"],

      [ " cd ~/c/Program Files/Internet Explorer/\n",
        "irbsh_cd %q[~/c/Program Files/Internet Explorer/]\n"],

      [ 'src.gsub(/^class (\S+).+\n/){ $&+"<%=url_stmt #{$1}>"}.writef("w3m.new.rb.r")'<<"\n",
        'src.gsub(/^class (\S+).+\n/){ $&+"<%=url_stmt #{$1}>"}.writef("w3m.new.rb.r")'<<"\n"],

    ].each {|x,y| assert_equal(y,IRB::InputFilter.input_filter(x)) }
  end

end

