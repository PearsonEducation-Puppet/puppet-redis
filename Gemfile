source 'http://rubygems.org'

puppetversion = ENV['PUPPET_VERSION']
gem 'rake'
gem 'colorize'
gem 'puppet', puppetversion, :require => false
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'serverspec','2.1.0'
gem 'vagrant-aws'
gem 'os'

platforms :mswin, :mingw, :mingw_18, :mingw_19, :mingw_20, :mingw_21, :x64_mingw, :x64_mingw_20, :x64_mingw_21 do
  gem 'win32-dir'
  gem 'windows-pr'
  gem 'sys-admin'
  gem 'win32-security'
  gem 'win32-process'
  gem 'win32-service'
  gem 'win32-taskscheduler'
end
