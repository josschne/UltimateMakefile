require 'rubygems'
require 'bundler/setup'

require 'github_api' #Use version 0.10.1 to avoid nokogiri conflicts for now

begin

def getRandomRepo()
	randomRepoUrl = ""
	search = Github::Search.new
	result = search.repos keyword: '.travis.yml', language: 'c++', sort: 'stars'
	if result.repositories.length > 0
		randomRepoUrl = result.repositories[rand(result.repositories.length)].url
		puts "Repo: #{randomRepoUrl}"
	end
	return randomRepoUrl
end

def installPrereqs(repo)
	shell("export DEBIAN_FRONTEND=noninteractive")
	shell("sudo apt-get update -y")
	shell("sudo apt-get install -y cmake rake git build-essential")
	shell("git clone https://github.com/josschne/UltimateMakefile.git")
	shell("rm -rf source; git clone #{repo} source")
	shell("cd source && ../UltimateMakefile/install.sh && rake")
end

randomRepo = getRandomRepo
installPrereqs(randomRepo)

end