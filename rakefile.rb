require './tests/jscript/lib/qunit.rb'

task :default => [:dependencies, :unit_tests, :commit, :deploy]
multitask :unit_tests => [:ruby_tests, :qunit] 

task :dependencies do
	sh "bundle install"
end

task :ruby_tests do
	require 'peach'
	Dir["./tests/**/*.rb"].peach do | file |
		sh "ruby #{file}"
	end
end

qunit :qunit do |config|
	config.phantom_exe = './tests/jscript/lib/phantomjs'
	config.qunit_runner = './tests/jscript/lib/run-qunit.js'
	config.test_directory = './tests/jscript'
end

task :commit do
	puts "Committing and Pushing to Git"
	require 'git_repository'
	commit_message = ENV["m"] || 'no commit message'
	git = GitRepository.new
	git.add
	git.commit(:message => 'dashboard commit')
	git.push	
end

task :deploy do
	puts "Deploying to heroku"
	require 'git_repository'
	git = GitRepository.new(:remote => "heroku")
	git.push
end