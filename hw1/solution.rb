require 'memory_profiler'

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

# puts Sequentially
def process_files_sequentially(files)
  files.each do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end

def with_threads(files)
  files.each do |file|
    Thread.new do
      File.open(file, 'r') do |f|
        f.each_line { |line| puts line }
      end
    end
  end
end

def with_fiber(files)
  files.each do |file|
    Fiber.new do
      File.open(file, 'r') do |f|
        f.each_line { |line| puts line }
      end
    end
  end
end

def with_ractor(files)
  files.each do |file|
    Ractor.new(file) do |file|
      File.open(file, 'r') do |f|
        f.each_line { |line| puts line }
      end
    end
  end
end





# require 'async'
# def with_async(files)
#   files.each do |file|
#     Async do |task|
#       File.open(file, 'r') do |f|
#         f.each_line { |line| puts line }
#       end
#     end
#   end
# end



require 'parallel'

def with_parallel(files)
  # Parallel.each(files, in_processes: files.size) do |file|
  #   File.open(file, 'r') do |f|
  #     f.each_line { |line| puts line }
  #   end
  # end

  # Parallel.each(files, in_threads: files.size) do |file|
  #   File.open(file, 'r') do |f|
  #     f.each_line { |line| puts line }
  #   end
  # end

  Parallel.each(files, in_ractors: files.size) do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end

  # files.each do |file|
  #   Ractor.new(file) do |file|
  #     File.open(file, 'r') do |f|
  #       f.each_line { |line| puts line }
  #     end
  #   end
  # end
end

# 2 CPUs -> work in 2 processes (a,b + c)
# results = Parallel.map(['a','b','c']) do |one_letter|
#   SomeClass.expensive_calculation(one_letter)
# end

# # 3 Processes -> finished after 1 run
# results = Parallel.map(['a','b','c'], in_processes: 3) { |one_letter| SomeClass.expensive_calculation(one_letter) }

# # 3 Threads -> finished after 1 run
# results = Parallel.map(['a','b','c'], in_threads: 3) { |one_letter| SomeClass.expensive_calculation(one_letter) }

# # 3 Ractors -> finished after 1 run
# results = Parallel.map(['a','b','c'], in_ractors: 3, ractor: [SomeClass, :expensive_calculation])



report = MemoryProfiler.report do
  start_time = Time.now
  process_files_sequentially(files)
  end_time = Time.now
  puts "Время выполнения Sequentially: #{end_time - start_time} секунд" # Время выполнения Sequentially: 2.596501 секунд
end
report.pretty_print



report = MemoryProfiler.report do
start_time = Time.now
with_threads(files)
end_time = Time.now
puts "Время выполнения thread: #{(end_time - start_time).to_f.to_s} секунд" # Время выполнения Sequentially: 2.596501 секунд
end
report.pretty_print


report = MemoryProfiler.report do
start_time = Time.now
with_fiber(files)
end_time = Time.now
puts "Время выполнения fiber: #{(end_time - start_time).to_f.to_s} секунд" # Время выполнения Sequentially: 2.596501 секунд
end

report.pretty_print

# start_time = Time.now
# with_ractor(files)
# end_time = Time.now

# puts "Время выполнения ractor: #{(end_time - start_time).to_f.to_s} секунд" # Время выполнения Sequentially: 2.596501 секунд


# start_time = Time.now
# with_async(files)
# end_time = Time.now

# puts "Время выполнения async: #{(end_time - start_time).to_f.to_s} секунд" # Время выполнения Sequentially: 2.596501 секунд


# start_time = Time.now
# with_parallel(files)
# end_time = Time.now

# puts "Время выполнения parallel: #{(end_time - start_time).to_f.to_s} секунд" # Время выполнения Sequentially: 2.596501 секунд


# require 'memory_profiler'
# report = MemoryProfiler.report do
#   # run your code here
# end

# report.pretty_print
