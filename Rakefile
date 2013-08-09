task :default => [:identify]

task :detect_third_party_dependencies do
	puts "Detect third party dependencies"
	require 'yaml'
	depends_dictionary = YAML.load_file('depends.yml')
	Dir['**/*.h', '**/*.cpp'].each do |file|
		depends_dictionary.each do |signature, lib|
			if not File.directory?(file) and open(file).grep(/#{signature}/i).length > 0
				puts "Found dependency #{lib}"
			end
		end
	end
end

task :detect_build_command do
	puts "Detect build command"
end

task :identify => [:detect_third_party_dependencies, :detect_build_command] do
end