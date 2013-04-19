require './tests/jscript/lib/qunit.rb'
require 'rbconfig'

task :default => [:update, :unit_tests, :commit, :deploy]
multitask :unit_tests => [:ruby_tests, :qunit] 

task :update do
	require 'git_repository'
	git = GitRepository.new
	git.pull
	sh "bundle update"
end

task :ruby_tests do
	require 'peach'
	Dir["./tests/**/*.rb"].peach do | file |
		sh "ruby #{file}"
	end
end

qunit :qunit do |config|
	config.phantom_exe = './tests/jscript/lib/' + get_phantom_exe
	config.qunit_runner = './tests/jscript/lib/run-qunit.js'
	config.test_directory = './tests/jscript'
end

def get_phantom_exe
	phantom_exe = 'phantomjs'
	phantom_exe = "#{phantom_exe}_win.exe" if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/	
	phantom_exe
end

task :commit do
	puts "Committing and Pushing to Git"
	require 'git_repository'
	commit_message = ENV["m"] || 'no commit message'
	git = GitRepository.new
	git.add
	git.commit(:message => 'dashboard_commit')
	git.push	
end

task :deploy do
	puts "Deploying to heroku"
	require 'git_repository'
	git = GitRepository.new(:remote => "heroku")
	git.push
end