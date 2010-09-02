#!/usr/bin/env ruby
require 'irbsh-sub'

=begin
= irbsh-util.rb
Utility functions for irbsh.

=end

=begin
--- function#readf( filename )
      Read the contents of ((|filename|)).
=end
def readf( filename )
  open( File::expand_path(filename) ) do |f|
    f.read
  end
end

=begin
--- function#writef( filename, content )
      Write ((|content|)) to ((|filename|)).
=end
class Object
  def writef(filename, content=nil)
    x = content || self
    open(File.expand_path(filename), "w"){|f| f.write(x.to_s)}
  end
end


=begin
--- function#rw( filename )
      rewrite $_
=end
def rw(fn, &block)
  open(fn, 'r+') do |f|
    str=f.read
    eval "$_=#{str.dump}", block
    newstr = block.call(str)
    f.rewind
    f.write newstr
    f.truncate newstr.length
  end
end



=begin
--- function#appendf( filename, content )
      Append ((|content|)) to ((|filename|)).
=end
def appendf( filename, content )
  open( File::expand_path( filename ), 'a' ) do |f|
    f.write content
  end
end
public :appendf

=begin
--- function#tmpf( content )
      Write ((|content|)) to temporary file, and return the temporary file object.
=end
def tmpf( content )
  require 'tempfile'
  tmp = Tempfile.new 'irbshtmp'
  tmp.write content
  tmp.close

  tmp.instance_eval do
    @content = content
  end

  class << tmp
    attr :content
    alias_method :string, :content
  end

  tmp
end
alias :tempf :tmpf
public :tmpf

=begin
--- String#tmpf
      Same as function#tmpf(string)
=end
class String
  def tmpf
    Object.tmpf self
  end
  alias :tempf :tmpf

#  def writef( filename )
#    Object.writef filename, self
#  end

  def appendf( filename )
    Object.appendf filename, self
  end
  
end

class OnceProc
  NULLPROC = lambda{}

  def initialize(&block)
    if block_given?
      @proc = block
    else
      raise ArgumentError, "must have a block"
    end
  end

  def call(*args)
    begin
      @proc.call(*args)
    ensure
      @proc = NULLPROC
    end
  end
  alias :[] :call
end

