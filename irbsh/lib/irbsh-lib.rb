#!/usr/bin/env ruby
=begin
= irbsh
$Id: irbsh-lib.rb 1542 2010-04-05 23:39:57Z rubikitch $
=end

require 'pathname'
# To avoid executing a block when testing
# (to "startup1")
# (to "startup2")
irbsh_startup_p = ($0=='irb')
require 'irbsh-util'
require 'irbsh-sub'

# startup1
if irbsh_startup_p

  $IRBSH = true

  ##
  # deceive ruby
  #
  $" << "readline.so"
  module Readline
    def self.complete_proc=(x); end
    def self.completion_proc=(x); end
    def self.completion_append_character=(x); end

  end
  require 'irb/completion'


  ##
  # irb hack
  #
  module IRB

    @CONF[:IRB_NAME] = "irbsh"

    def self.prompt=( fmt )
      @CONF[:PROMPT][:INF_RUBY][:PROMPT_I] = fmt
    end

    def self.prompt
      @CONF[:PROMPT][:INF_RUBY][:PROMPT_I]
    end

    self.prompt = "%N[%t](%m):%03n:%i> "

    def self.return_format=( fmt )
      @CONF[:PROMPT][:INF_RUBY][:RETURN] = fmt
    end

    class Context
      def return_format
        if IRB.conf[:PROMPT_MODE] == :INF_RUBY
          IRB.conf[:PROMPT][:INF_RUBY][:RETURN].sub( /\$PWD\$/, irbsh_pwd.gsub(/%/, '%%') )
        else
          IRB.conf[:PROMPT][prompt_mode][:RETURN]
        end
      end
    end

    class Irb
      def prompt(prompt, ltype, indent, line_no)
        now = Time.now
        p = prompt.dup
        p.gsub!(/%([0-9]+)?([a-zA-Z])/) do
          case $2
          when "D"
            now.strftime "%y/%m/%d"
          when "d"
            now.strftime "%m/%d"
          when "e"
            now.strftime "%d"
          when "T"
            now.strftime "%H:%M:%S"
          when "t"
            now.strftime "%H:%M"
          when "N"
            @context.irb_name
          when "m"
            @context.main.to_s
          when "M"
            @context.main.inspect
          when "l"
            ltype
          when "i"
            if $1 
              format("%" + $1 + "d", indent)
            else
              indent.to_s
            end
          when "n"
            if $1 
              format("%" + $1 + "d", line_no)
            else
              line_no.to_s
            end
          when "%"
            "%"
          end
        end
        p
      end
    end
  end
end

module IRB; end
module Irbsh
  include IfTest
  extend IfTest
  @@conf = {}
  DEFAULT_RETURN_FORMAT = "%s\n[pwd:$PWD$]\n"
  @@path_hash = nil

  ## for EvalList
  class << (DisableOutput=Object.new)
    def inspect
      "(Output is disabled.)"
    end
  end
  

  def self.config_yes_or_no( id )
    name = id.id2name
    module_eval %-
      def enable_#{name}
        @@conf[:#{name}] = true
      end
      module_function :enable_#{name}
        
      def disable_#{name}
        @@conf[:#{name}] = false
      end
      module_function :disable_#{name}

      def #{name}?
        @@conf[:#{name}]
      end
      module_function :#{name}?
    -       
  end
 
  config_yes_or_no :dryrun
  config_yes_or_no :pushdignoredups
  config_yes_or_no :systemecho

  
  def IRB.this_return_format(fmt)
    IRB.return_format = fmt
    IRB.conf[:POST_PROC] = OnceProc.new { Irbsh.enable_output}
  end
    
  def self.enable_output
#    puts "enable output"
    IRB.conf[:output] = true
    IRB.return_format = if IRB.conf[:nopwd]
                          "%s\n"
                        else
                          DEFAULT_RETURN_FORMAT
                        end
    IRB.conf[:nopwd] = false
  end


  def self.disable_output
    IRB.conf[:output] = false
    IRB.this_return_format(IRB.conf[:nopwd] ? "" : "[pwd:$PWD$] (Output is disabled.)\n")
    IRB.conf[:nopwd] = false
  end

  def self.no_output
    IRB.conf[:output] = false
    IRB.this_return_format ""
    IRB.conf[:nopwd] = false
  end

  def self.nopwd_output
    IRB.conf[:nopwd] = true
    IRB.conf[:output] = true
    IRB.this_return_format "%s\n"
  end


  def self.prompt=( fmt )
    IRB.prompt = fmt
  end
      
  def self.prompt
    IRB.prompt
  end
      

  module Command
    include IfTest
    # ruby-mode.el hack
    1; module_function

    ##
    # pwd
    #
    def irbsh_pwd
      p = Dir::pwd
      ENV['HOME'] and p.sub!(/^#{Pathname.new(ENV['HOME']).realpath}/,'~')
      p
    end  
    alias :pwd :irbsh_pwd

    ##
    # cd, pushd
    #
    def irbsh_cd( dir = '~' )
      oldpwd = Dir::pwd
      Dir::chdir( File::expand_path(dir) )
      if block_given?
        begin
          yield
        ensure
          Dir::chdir oldpwd
        end
      else
        Thread.current[:irb_directory_stack] ||= []
        dirs = Thread.current[:irb_directory_stack]
        unless pushdignoredups? and dirs.include? dir
          dirs << oldpwd
        end
        pwd
      end
    end
    public :irbsh_cd
    alias :cd :irbsh_cd
    alias :pushd :irbsh_cd
    
    ##
    # popd
    #
    def irbsh_popd
      dir = Thread.current[:irb_directory_stack].pop
      if dir
        Dir::chdir dir
        dir
      else
        raise "directory stack empty!"
      end
    end
    alias :popd :irbsh_popd  

    ##
    # ls
    #
    def irbsh_ls( *argv )
      if argv.empty?
        argv << "*"
      end

      argv.collect{|glob| Dir[File::expand_path(glob)].sort }.flatten
    end
    alias :ls :irbsh_ls

    ##
    # ll (ls -l)
    #
    def irbsh_ll( *argv )
      if_test(""){ system "ls -l #{argv.join ' '}" }
      Irbsh.disable_output
      irbsh_ls *argv
    end
    alias :ll :irbsh_ll

    ##
    # rehash
    #
    #    def irbsh_rehash
    #      path_hash = {}
    #      ENV['PATH'].split(':').reverse.each{|p|
    #        Dir[ File::join p, "*"].each{|f|
    #          path_hash[ File::basename f ] = f if File::executable? f
    #        }
    #      }
    #      @@path_hash = path_hash
    #      nil
    #    end
    #    alias :rehash :irbsh_rehash


    def irbsh_expand_exec_path( cmdname, env_path=ENV['PATH'] )
      env_path.split(':').each do|dir|
        path = File::join dir, cmdname
        return path if File::executable? path
      end
      nil
    end


    ##
    # system
    #
    def irbsh_system( cmd )
      cmd.strip!
      cmd.gsub!(/(^|\s)=(\S+)/){ "#{$1}#{irbsh_expand_exec_path($2)}" }
      m, sharg = cmd.split( /\s+/, 2 )
      if respond_to?( id = "nq_#{m}".intern, true )
        args = sharg
        arity = method( id ).arity
        if arity == 1
          argv = args
        elsif arity >= 2
          argv = args.split( /\s+/, arity )
        elsif arity == 0
          return __send__(id)
        else
          argv = args.split
        end
        __send__( id, *argv )
      elsif Irbsh.dryrun?
        puts "#{pwd}(dryrun) $ #{cmd}"
      elsif cmd =~ /^(.+)&\s*$/
        EmacsLisp.el %Q[(irbsh-bg #{str2lstr $1})]
      else
        puts "#{pwd} $ #{cmd}" if systemecho?
        system cmd
        IRB.this_return_format "[pwd:$PWD$] (status = #{$?.exitstatus})\n"
        $?.exitstatus
      end
    end

    # reload .irbrc, .irbshrc, irbsh-lib.rb
    def reinit
      load "~/.irbrc"
      load "~/.irbshrc"
  #    load "irbsh-lib.rb"
    end

    def restart
      EmacsLisp.el "(call-interactively 'irbsh-restart)" # '
    end

  end

  include Command

  ##
  # Commands used without quotation
  #
  # ls
  #
  module NoQuoteCommand
    def nq1_ls( *args )
      Irbsh.disable_output
      cmd = 'ls ' + args.join(' ')
      system cmd
      args.grep(/^[^-]/).empty? and args << '.'
      args.collect {|file|
        if File::directory? file
          Dir[ File::join( file.chomp('/'), '*' ) ]
        elsif File::file? file
          Dir[ file ]
        else 
          []
        end
      }.flatten.compact
    end
  end
  
  ##
  # method/variable completion
  #
  # output completion table in EmacsLisp
  def make_completion_elisp( input, ret=$>, cands=nil )
    re = /[ \t\n\"\\'`@$><=;|&{(]/
    stub = input.split(re).last
    if input == ""
      stub = ""
      cands = []
    else
      cands = IRB::InputCompletor::CompletionProc[ stub ]   unless cands
    end
    ret << %Q[(setq string #{str2lstr(stub)})\n]
    ret << %[(setq irbsh-tmp-cands '("__region__" ] # '
    cands.compact.each {|cand|
      ret << str2lstr( cand ) << ' '
    }
    ret << "))\n"
  end

  ##
  # Ruby String -> Elisp String
  #
  def str2lstr( string )
    "\"" << string.gsub(/["\\]/){ "\\#{$&}" } << "\""
  end
  ##
  # glob expansion
  #
  def irbsh_expand_glob( glob, output=$> )
    if glob =~ /~/
      glob = File::expand_path glob
    end
    unless (files = Dir[ glob ]).empty?
      output.puts( files.join(' ') )
    else
      output.puts glob
    end
  end
  
    

  ##
  # simple alias definition
  #
  @@alias = {}
  def irbsh_alias( arias, expand )
    @@alias[arias]=expand
    
    self.class.__send__(:define_method, "nq_#{arias}") {|*args|
      cmd = "#{expand} #{args.join ' '}"
      if_test(cmd){ irbsh_system cmd}
    }

  end

  ##
  # which
  #
  def nq_which(*args)
    ret = args.collect{|arg|
      if @@alias[arg]
        "#{arg}: aliased to #{@@alias[arg]}"
      elsif eval "defined? nq_#{arg}"
        "#{arg}: nq_#{arg}"
      else
        if_test("#{arg}: external"){ ("#{arg}: "+`which #{arg}`).chomp }
      end
    }.join("\n")
    if_test(ret){ ret.ni}
  end

  # running config (imported from irb/init.rb)
  def run_irbshrc
    rcs = []
    rcs.push File.expand_path("~/.irbshrc") if ENV.key?("HOME")
    rcs.push ".irbshrc"
    rcs.push "irbsh.rc"
    rcs.push "_irbshrc"
    rcs.push "$irbshrc"
    catch(:EXIT) do
      for rc in rcs
        begin
          load rc
          throw :EXIT
        rescue LoadError, Errno::ENOENT
        rescue
          print "load error: #{rc}\n"
          print $!.class, ": ", $!, "\n"
          for err in $@[0, $@.size - 2]
            print "\t", err, "\n"
          end
          throw :EXIT
        end
      end
    end
  end


  #
  def eval_and_cat_multi_line_file( filename, bind, output=$> )
    open( filename ) do |f|
      s = f.read
      output.puts "\n#### MULTI-LINE BEGIN ####"
      output.puts s
      output.puts "#### MULTI-LINE END ####"
      eval s, bind
    end
  end

  #
  def irbsh_source( arg )
    begin
      IRB.initialize_loader
      irb_context.load_file( File::expand_path(arg) )
    rescue NameError            # 0.9x
      irb_source( File::expand_path(arg) )
    end
  end


  def irbsh_eval_eval_list( filename )
    Irbsh::nopwd_output

    prompt_i_org = IRB.prompt
    prompt_c_org = irb_context.prompt_c
    set_eval_list_prompt
    irbsh_source filename
    irb_context.prompt_i = prompt_i_org
    irb_context.prompt_c = prompt_c_org

    Irbsh::enable_output
    nil
  end


  def set_eval_list_prompt
    Irbsh.nopwd_output
    irb_context.prompt_i = "EvalList(%m):%03n:%i> "
    irb_context.prompt_c = "EvalList(%m):%03n:%i> "
  end
  


  def irbsh_load_script_and_eval_eval_list( script, eval_list )
    print "\n"
    load script if script
    if eval_list
      open( File::expand_path(eval_list) ) do |ev|
        unless ev.read.strip.empty?
          irbsh_eval_eval_list eval_list
        end
      end
    end
  end


  module EmacsLisp
    def el(lisp)
      print %Q[\001\001\002#{lisp}\001\001\003]
      nil
    end
    module_function :el
    public :el

    alias :nq_el :el

  end


end

class Object
  ##
  # ni (no inspect)
  #
  def irbsh_no_inspect( arg = nil )
    value = if block_given?
              yield
            elsif arg
              arg
            else
              self              # [2002/08/25]change
            end
    IRB::Irb.module_eval do
      printf "%s\n", value.to_s
    end
    #Irbsh.disable_output
    Irbsh.no_output
    value
  end
  alias :ni :irbsh_no_inspect

end

#### edit an object using yaml
class Object
  def edit
    require 'yaml'
    tmpfile = "/tmp/yaml"
    to_yaml.writef(tmpfile)
    EmacsLisp.el %Q[(irbsh-edit-object "#{tmpfile}")]
    gets
    YAML.load(File.read(tmpfile))
  end
end



# deceive ruby
class << STDIN
  def tty?
    true
  end
end


# startup2
if irbsh_startup_p
  # delete tmp-files at exit
  at_exit do
    tmpdir=ENV['TMPDIR']||ENV['TMP']||ENV['TEMP']||'/tmp'
    Dir[ File::join(tmpdir, 'irbshtmp*' ) ].each {|f| File::unlink f if File::writable? f}
  end

  include Irbsh
  include Irbsh::NoQuoteCommand
  include Irbsh::EmacsLisp


  #IRB.conf[:POST_PROC] = lambda{ puts 1;Irbsh.enable_output}

  #el "(setq xx 123)"
  #el "nil"

  run_irbshrc

  module Irbsh
    enable_output
    enable_pushdignoredups
    enable_systemecho
  end
  ##
  # startup irbsh
  #
  puts "[pwd:#{pwd}]"
  
end

if $0 == 'irb'
  # startup
end

