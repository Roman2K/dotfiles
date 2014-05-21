# http://www.ruby-doc.org/stdlib-2.0/libdoc/irb/rdoc/IRB/Context.html#method-i-save_history-3D
IRB.conf[:SAVE_HISTORY] = 1000

# http://stackoverflow.com/a/1051411
IRB.conf[:BACK_TRACE_LIMIT] = 100

load Dir.home + '/code/dotfiles/ruby/console_utils.rb'
