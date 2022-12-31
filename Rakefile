require 'rake'
require 'erb'

namespace :install do
  desc "Update crontab with classics"
  task :crontab do |t, args|
    # install dotfiles checker
    puts "Updating crontab..."
    update_crontab("check_dotfiles_repo", "# Check dotfiles twice a week\n3 2 * * 2,5 $HOME/.bin/check_dotfiles_repo > $HOME/.dotfiles-msg 2>&1")
  end

  desc "Install minimal packages set"
  task :packages do |t, args|
    kernel=`uname`.chomp
    puts "Kernel: #{kernel}"
    if kernel == 'Linux'
      puts "Install packages"
      system('cat packages.list | grep -v -e "^#" -e "brew" -e "cask$" -e "app-store" | sed "s/ .*//" | xargs sudo apt-get install -y ')
    else
      puts "Ensure brew is installed"
      system('brew -h >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
      puts "Install brew packages"
      system('cat packages.list | grep -v -e "^#" -e "debian" -e "cask$" -e "app-store" | sed "s/#.*//" | xargs brew install -q')
      puts "Install brew casks"
      system('cat packages.list | grep -v -e "^#" | grep "brew.*cask" | sed "s/#.*//" | xargs brew install -q --cask')
      puts "Install app.store apps"
      system('cat packages.list | grep -v -e "^#" | grep "app-store" | sed "s/#.*//" | xargs mas install')
    end
  end
end

desc "install the dot files into user's home directory"
task :install, [:replace_all] do |t, args|
  replace_all = !!args[:replace_all] || false

  # Install minimal brew packages
  Rake::Task["install:packages"].invoke

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

  # Update crontab
  Rake::Task["install:crontab"].invoke

end

task :update do
  system %Q{git submodule foreach git pull origin master}

  # update vim's plugins
  update_plugins

  # Update crontab
  Rake::Task["install:crontab"].invoke
end

def update_crontab(regex, new_lines)
  crontab = `crontab -l`
    require 'tempfile'
  unless crontab.match regex
    tmpfilepath = Tempfile.new('foo').path
    open(tmpfilepath, 'a'){ |f|
      f << crontab unless crontab.empty?
      f << "\n" unless crontab.empty?
      f << new_lines.chomp
      f << "\n"
    }
    system %Q{crontab #{tmpfilepath}}
  end
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
