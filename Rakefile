ENV['TARGET_HOST'] = 'default'
require 'rake'
require 'colorize'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'os'

def put_header (title)
  dashes = ['-']
  dashes = dashes.collect{|x| [x] * title.length}.join
  puts
  if OS.windows? then
    puts dashes
    puts title
    puts dashes
  else
    puts dashes.colorize(:blue)
    puts title.colorize(:light_blue)
    puts dashes.colorize(:blue)
  end
end

def check_doozer_vagrant_box
  system 'vagrant box list | grep -q \'doozer-vagrant\''
  unless $?.to_i.equal?(0) then
    puts
    puts ('No Vagrant box named \'doozer-vagrant\' found! ' +
          'Downloading the box; this will take some time....' +
          '').colorize(:red).on_white.underline
    puts
  end
end

def check_vagrant_machine_status
  system 'vagrant status | grep -q \'not created\''
  unless $?.to_i.equal?(0) then
    vagrant_provision
  end
end

def prompt_integ_test_run
  put_header ('prompt_integ_test_run')
  puts ('Running integration tests on Vagrant image;' +
        ' this will take a few moments...'.colorize(:red).on_white.underline)
  puts
end

def vagrant_provision
  put_header ('vagrant_provision')
  system 'vagrant provision'
end

desc 'Run unit tests'
task :unit do
  Rake::Task[:spec_prep].invoke
  Rake::Task[:spec_standalone].invoke
end
task :spec => []; Rake::Task[:spec].clear
task :spec => :unit

desc 'Run integration tests'
  RSpec::Core::RakeTask.new(:integ) do |t|
  Rake::Task[:spec_prep].invoke

  t.pattern = 'serverspec/**/*_spec.rb'
  t.rspec_opts = ['--color']
  Rake::Task[:spec_prep].invoke

  check_doozer_vagrant_box
  check_vagrant_machine_status
  prompt_integ_test_run
end

desc 'Run all lint, unit, and integration tests'
task :test do
  if OS.windows? then
    put_header ('Determine OS')
    puts 'OS is Windows'
    Rake::Task[:set_windows_testing].invoke
  end

  put_header ('Task Lint')
  Rake::Task[:lint].invoke

  put_header ('Task unit')
  Rake::Task[:unit].invoke

  put_header ('Task integ')
  Rake::Task[:integ].invoke

  if OS.windows? then
    Rake::Task[:reset_windows_testing].invoke
  end
  puts 'done.'
end

desc 'Install git hooks'
task :install_git_hooks do
  put_header ('Task install install_git_hooks')
  source = "#{Dir.pwd}/.git_hooks"
  target = './.git/hooks'
  git_hooks_available = Dir.entries(source)
  git_hooks_available.each do |hook|
    if (hook != '.' and hook != '..' and hook != 'README.md') then
      FileUtils.rm_rf  "#{target}/#{hook}"
      FileUtils::cp "#{source}/#{hook}", "#{target}/#{hook}"
      FileUtils::chmod 0755, "#{target}/#{hook}"
    end
  end
  FileUtils::touch '.git_hooks_installed'
end

# remove undesired rake tasks
task :build => []; Rake::Task[:build].clear
task :clean => []; Rake::Task[:clean].clear
task :coverage => []; Rake::Task[:coverage].clear

task :default => []; Rake::Task[:default].clear
task :default => :test

# puppet-lint options
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp']
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_autoloader_layout')

desc 'Set spec/fixtures/modules for windows'
task :set_windows_testing do
  put_header ('Task set_windows_testing')
  module_path = "#{Dir.pwd}"
  module_name = module_path.split('/')[-1]
  spec_path = "/spec/fixtures/modules/#{module_name}"
  module_spec_path = File.join(module_path,spec_path)
  fixtures_symlink_path = File.join(module_name,spec_path)
  #spec/fixtures/modules/$MODULE_NAME/files

  spec_dirs = ['files', 'manifests', 'templates']
  spec_dirs.each do |dir|
    spec_symlink = module_spec_path + "/" + dir

    #on windows, spec_symlink isn't a 'File.symlink?' returns false
    if File.file?(spec_symlink) then
      puts
      puts "  deleting symlink '#{fixtures_symlink_path}'".sub(module_name, ".")
      File.delete(spec_symlink)

      source = module_path + "/" + dir
      destination = module_spec_path + "/" + dir
      puts "  copying '#{dir}' to '#{fixtures_symlink_path}'".sub(module_name, ".")
      FileUtils.cp_r(source, destination)
    else
      puts "  warning: is not a symlink '#{spec_symlink}'"
    end
  end
end

desc 'Reset spec/fixtures/modules for linux'
task :reset_windows_testing do
  put_header ('Task reset_windows_testing')
  module_path = "#{Dir.pwd}"
  module_name = module_path.split('/')[-1]
  spec_path = "/spec/fixtures/modules/#{module_name}"
  module_spec_path = File.join(module_path,spec_path)
  fixtures_symlink_path = File.join(module_name,spec_path)

  spec_dirs = ['files', 'manifests', 'templates']
  spec_dirs.each do |dir|
    spec_symlink = module_spec_path + "/" + dir

    #on windows, spec_symlink isn't a 'File.symlink?' returns false
    if File.directory?(spec_symlink) then
      puts "  deleting directory '#{fixtures_symlink_path}'".sub(module_name, ".")
      FileUtils.rm_rf(spec_symlink)

      #git checkout symlinks
      puts "  checkout '#{spec_symlink}'".sub(module_path, ".")
      `git checkout #{spec_symlink}`
    else
      puts "  warning: is not a directory '#{spec_symlink}'"
    end
  end
end
