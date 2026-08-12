# frozen_string_literal: true

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

def process_files_with_ractors(files)
  # Создаем массив Ractor для обработки файлов
  ractors = files.map do |file|
    Ractor.new(file) do |filename|
      File.open(filename, 'r') do |f|
        f.each_line do |line|
          Ractor.yield(line) # Отправляем строки в основной Ractor
        end
      end
    end
  end

  # Считываем строки из всех Ractor
  loop do
    ready_ractors = ractors.select(&:alive?) # Оставляем только активные Ractor
    break if ready_ractors.empty?

    ready_ractors.each do |ractor|
      begin
        puts ractor.take # Получаем строку из Ractor и выводим
      rescue Ractor::ClosedError
        # Игнорируем, если Ractor уже завершен
      end
    end
  end
end

start_time = Time.now
process_files_with_ractors(files)
end_time = Time.now

puts "Время выполнения: #{end_time - start_time} секунд"
