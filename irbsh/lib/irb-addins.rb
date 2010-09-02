require 'irb/ruby-lex'
require 'test/unit/assertions'
require 'stringio'

$nullout = StringIO.new
$debugout = $nullout

class Module
  public :define_method
end

module IRB

  
  module InputFilter
    extend Test::Unit::Assertions

    FilterNotFound = Class.new(RuntimeError)

    FILTERS_DEFAULT = [
      [ /^cd +(.+?)\s*$/, proc{|l,m|
          "irbsh_cd %q[#{m[1]}]\n"}],
      [ /^ +(cd|pushd)\s*$/, proc{|l,m|
          "irbsh_#{m[1]}\n"}],
      [ /^ +(cd|pushd) +(.+)\s*$/, proc{|l,m|
          "irbsh_#{m[1]} %q[#{m[2]}]\n"}],
      [ /;$/, proc{|l,m|
          "Irbsh.disable_output;#{m.pre_match}\n"
        }],
      [ /\$$/, proc{|l,m|
          "Irbsh.enable_dryrun;#{m.pre_match}\n"
        }],
      [ /^ /, proc{|l,m|
          "irbsh_system %Q(#{l.chomp})\n"
        }],
      [/^defun +(\S+)\s*\(([^\)]*)\)/, proc{|l,m|
          %Q!self.class.__send__(:define_method,:#{m[1]}) do |#{m[2]}|#{m.post_match}!
        }],
      [ /^([a-z][a-zA-z0-9]*)\s+\(([^\)]*)\)/, proc{|l,m|
          %Q!self.class.__send__(:define_method,:#{m[1]}) do |#{m[2]}|#{m.post_match.chomp} end\n!
        }],
    ]

    # @pre: l[-1,1] == "\n"
    def self.input_filter(l)
      raise Exception unless "\n" == l[-1,1]
      begin
        match = nil
        x = FILTERS_DEFAULT.find{|re, str| match = l.match(re)}[1]
      rescue
        return l
      end
      s = x.call(l,match)
      $debugout.puts "input_filter:#{s}"
      s
    end
  end
end  


class RubyLex

# (find-fline "/usr/local/lib/ruby/1.8/irb/ruby-lex.rb" '(1451 "  def set_input(" " # io functions\n"))

  alias :set_input_original :set_input
  def set_input(*args,&block)
    set_input_original(*args,&block)
    input_original = @input
    @input = lambda{
      l = input_original.call
      if self.indent == 0 && l.respond_to?(:replace)
        l.replace(IRB::InputFilter.input_filter(l))
      end
      l
    }
  end

end



module IRB
  NULLPROC = lambda{}
  IRB.conf[:PRE_PROC]=NULLPROC
  IRB.conf[:POST_PROC]=NULLPROC

  IrbOriginal = Irb
  remove_const :Irb
  class Irb < IrbOriginal
    def prompt(prompt, ltype, indent, line_no)
      if prompt==@context.prompt_i && indent == 0
        super
      else
        ""
      end
    end

  end

  ContextOriginal = Context
  remove_const :Context
  class Context < ContextOriginal
    def evaluate(line, lineno)
      line.replace "IRB.conf[:POST_PROC].call; IRB.conf[:PRE_PROC].call; #{line}"
      super
    end
  end

end



