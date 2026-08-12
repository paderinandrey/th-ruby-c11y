# frozen_string_literal: true

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

def process_files_with_fibers(files)
  fibers = files.map do |file|
    Fiber.new do
      File.open(file, 'r') do |f|
        f.each_line do |line|
          puts line
          Fiber.yield
        end
      end
    end
  end

  while fibers.any?(&:alive?)
    fibers.each do |fiber|
      fiber.resume if fiber.alive?
    end
  end
end

start_time = Time.now
process_files_with_fibers(files)
end_time = Time.now

puts "Время выполнения: #{end_time - start_time} секунд"
