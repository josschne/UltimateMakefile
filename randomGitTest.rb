require 'aws-sdk'    
require 'github_api' #Use version 0.10.1 to avoid nokogiri conflicts for now
require 'net/ssh'

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

def launchEC2()
	ec2 = AWS::EC2.new

	if not ec2.key_pairs["randomGitHubTest"].exists?
		key_pair = ec2.key_pairs.create("randomGitHubTest")
		File.open("#{ENV['HOME']}/.ssh/randomGitHubTest", "wb") do |f|
	  		f.write(key_pair.private_key)
		end
	end

	#instance = ec2.instances.create(:image_id=>'ami-a1d4a2c8', :key_name=>'randomGitHubTest', :instance_type=>'t1.micro')
	instance = ec2.instances['i-87495ce8']
	puts "Waiting for instance to transition to running state..."
	sleep 10 while instance.status == :pending
	puts "Instance state: #{instance.status}"
	return instance
end

def installPrereqs(instance, repo)
	puts "Public DNS: #{instance.dns_name}"
	Net::SSH.start(instance.dns_name, 'ubuntu', :keys=>["#{ENV['HOME']}/.ssh/randomGitHubTest"]) do |session|
		puts "Successfully connected over SSH!"
		puts session.exec!("export DEBIAN_FRONTEND=noninteractive")
		puts session.exec!("sudo apt-get update -y")
		puts session.exec!("sudo apt-get install -y cmake rake git build-essential")
		puts session.exec!("git clone https://github.com/josschne/UltimateMakefile.git")
		puts session.exec!("rm -rf source; git clone #{repo} source")
		puts session.exec!("cd source && ../UltimateMakefile/install.sh && rake")
	end
end

def terminateEC2(instance)
	puts "Terminating instance"
	#instance.terminate
	puts "Done"
end

randomRepo = getRandomRepo
instance = launchEC2
installPrereqs(instance, randomRepo)
terminateEC2(instance)

end