# frozen_string_literal: true

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

def process_files_with_threads(files)
  threads = files.map do |file|
    Thread.new do
      File.open(file, 'r') do |f|
        f.each_line do |line|
          puts line # Вывод строки в консоль
        end
      end
    end
  end
  threads.each(&:join)
end

start_time = Time.now
process_files_with_threads(files)
end_time = Time.now

puts "Время выполнения: #{end_time - start_time} секунд"
