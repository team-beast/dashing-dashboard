task :default => [:dependencies, :unit_tests, :commit, :deploy]

task :dependencies do
	sh "bundle install"
end

task :unit_tests do
	Dir["./tests/**/*.rb"].each do | file |
		sh "ruby #{file}"
	end
end

task :commit do
	require 'git_repository'
	commit_message = ENV["m"] || 'no commit message'
	git = GitRepository.new
	git.add
	git.commit(:message => 'commit_message')
	git.push	
end

task :deploy do
	require 'git_repository'
	git = GitRepository.new(:remote => "heroku")
	git.push
end