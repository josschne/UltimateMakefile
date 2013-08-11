task :default => [:identify]

depends_dictionary = {'SDL.h'=> 'libsdl-dev'}

task :detect_third_party_dependencies do
	puts "Detect third party dependencies"
	require 'yaml'
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
	if File.exists?('CMakeLists.txt')
		puts "Found CMake build"
		sh "rm -f CMakeCache.txt && mkdir -p build && cd build && cmake .. && make clean && make && make test"
	elsif File.exists?('configure')
		puts "Found automake build"
		sh "mkdir -p build && cd build && ../configure && make clean && make && make test"
	elsif File.exists?('SConscript')
		sh "scons -c && scons"
	end
end

task :identify => [:detect_third_party_dependencies, :detect_build_command] do
end