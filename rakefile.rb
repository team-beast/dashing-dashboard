task :default => [:dependencies, :unit_tests, :commit, :deploy]

task :dependencies do
	sh "bundle install"
end

task :unit_tests do
	require 'peach'
	Dir["./tests/**/*.rb"].peach do | file |
		sh "ruby #{file}"
	end
end

task :commit do
	require 'git_repository'	
	git = GitRepository.new
	git.add
	git.commit(:message => 'dashboard commit')
	git.push	
end

task :deploy do
	require 'git_repository'
	git = GitRepository.new(:remote => "heroku")
	git.push
end