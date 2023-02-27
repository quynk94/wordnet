namespace :import_words do |_|
  task :execute => [:environment] do
    file = File.open('lib/tasks/word.csv')
    words_data = file.readlines

    words_data.each do |line|
      word_name = line.split(' ')[0].strip
      lexname = line.split(' ')[1].strip

      word = Word.find_or_create_by(name: word_name)
      puts "#{word.name} is added" if word.previously_new_record?

      wordnet_hypernym_paths = JSON.parse(`python3 lib/tasks/wordnet.py #{word_name} #{lexname}`)
      tags = wordnet_hypernym_paths.map do |tag_list|
        tag_list.map.with_index do |tag_name, index|
          Tag.find_or_create_by(name: tag_name) do |tag|
            tag.weight = index
          end
        end
      end.flatten.uniq

      word.tags = tags
      word.save!
    end
  end
end
