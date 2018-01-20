require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install, [:replace_all] do |t, args|
  replace_all = !!args[:replace_all] || false
  Dir['*'].each do |file|

    next if file =~ /^install_/

    next if %w[Rakefile README.markdown LICENSE].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end

  # get submodules
  system %Q{git submodule init}
  system %Q{git submodule update}

  # update vim's plugins
  update_plugins

  # install fzf (fuzzy matcher)
  system %Q{git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf}
  system %Q{~/.fzf/install}

end

task :update do
  system %Q{git submodule foreach git pull origin master}

  # update vim's plugins
  update_plugins
end

def update_plugins
  system %Q{vim +PlugInstall +qall}
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end
