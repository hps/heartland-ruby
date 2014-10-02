task :console do
  require 'bundler/gem_tasks'
  require 'hps'
  begin
    require 'pry'
    ARGV.clear
    Pry.start
  rescue LoadError
    #pry was not found so loading irb
    require 'irb'
    require 'irb/completion'
    ARGV.clear
    IRB.start
  end
end
