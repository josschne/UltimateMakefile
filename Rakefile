task :default => [:identify]

depends_dictionary = {'SDL.h'=> 'libsdl-dev'}

require 'iconv'

task :detect_third_party_dependencies do
	puts "Detect third party dependencies"
	require 'yaml'
	Dir['**/*.h', '**/*.cpp'].each do |file|
		depends_dictionary.each do |signature, lib|
			if not File.directory?(file)
				ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
				contents = ic.iconv(open(file).read)
				if contents.split('\n').grep(/#{signature}/i).length > 0
					puts "Found dependency #{lib}"
				end
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
		puts "Found Scons build"
		sh "scons -c && scons"
	elsif Dir['*.pro'].length > 0
		puts "Found QMake build"
		sh "qmake #{Dir['*.pro'][0]} -o Makefile && make"
	end
end

task :identify => [:detect_third_party_dependencies, :detect_build_command] do
end