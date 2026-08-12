# frozen_string_literal: true

# Генерация файлов для примера
class SomeClass
  def self.expensive_calculation(file)
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end


files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

require 'parallel'
require 'debug'


def process_files_with_parallel_rac(files)
  # debugger
  Parallel.map(files, in_ractors: files.size, ractor: [SomeClass, :expensive_calculation]) do
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end

  # results = Parallel.map(['a','b','c'], in_ractors: 3, ractor: [SomeClass, :expensive_calculation])
end

start_time = Time.now
process_files_with_parallel_rac(files)
end_time = Time.now

puts "Время выполнения: #{end_time - start_time} секунд"
