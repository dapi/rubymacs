$" << "readline.so"
module Readline; def self.complete_proc=(x); end; end
require 'irb/completion'

module Irbsh
  
  module_function

  def make_completion_elisp( stub )
    cands = IRB::InputCompletor::CompletionProc[ stub ]
    ret = ""
#    ret << "; cand = #{cands.inspect}\n"
    ret << "(setq irbsh-tmp-cands '("
    cands.compact.each {|cand|
      ret << '"' << cand.gsub(/["\\]/){ "\\#{$&}" } << '" '
    }
    ret << "))\n"
    puts ret
  end

end
