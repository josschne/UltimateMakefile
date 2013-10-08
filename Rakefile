task :default => [:identify]

depends_dictionary = {'SDL.h'=> 'libsdl-dev'}

task :detect_third_party_dependencies do
	puts "Detect third party dependencies"
	Dir['**/*.h', '**/*.cpp'].each do |file|
		depends_dictionary.each do |signature, lib|
			if not File.directory?(file)
				contents = open(file).read
				contents = contents.encode('UTF-32', :invalid=>:replace, :replace=>'').encode('UTF-8')
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
	elsif File.exists?('Makefile')
		puts "Found automake build"
		maketargets = `make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'`.split
		puts "Found make targets: #{maketargets}"
		build_cmd = []
		if maketargets.include?("clean")
			build_cmd << "make clean"
		end
		build_cmd << "make"
		if maketargets.include?("test")
			build_cmd << "make test"
		end
		build_cmd = build_cmd.join(" && ")
		puts "Build cmd: #{build_cmd}"
		sh build_cmd
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