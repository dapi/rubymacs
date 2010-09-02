require 'fileutils'
puts "emacs=#{config('emacs')}"
system config('emacs'), '-no-site-file',  '--batch',  '-l', File.join(srcdir_root,"add-load-path.el"), '-f', 'batch-byte-compile', *Dir[File.join(curr_srcdir(),"*.el")]

