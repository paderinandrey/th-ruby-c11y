# frozen_string_literal: true

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

require 'parallel'

def process_files_with_parallel(files)
  Parallel.each(files, in_processes: files.size) do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end

start_time = Time.now
process_files_with_parallel(files)
end_time = Time.now

puts "Время выполнения: #{end_time - start_time} секунд"
