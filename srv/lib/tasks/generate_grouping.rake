namespace :generate_grouping do |_|
  task :execute, [:word_num, :min_distance] => [:environment] do |_task, args|
    def generate_similar_words word, word_num
      word_group_ids = []
      word_tags = word.tags.order(:weight).to_a
      word_tags_num = word_tags.size
      similarity = 0

      (0..word_tags_num).each do |i|
        word_tags.pop
        similar_words = WordTag.group(:word_id).where(tag: word_tags).having("COUNT(*) = #{word_tags.size}").pluck(:word_id)
        if similar_words.length >= word_num
          similar_words.delete(word.id)
          word_group_ids = [word.id] + similar_words.sample(word_num - 1)
          similarity = i
          break
        end
      end

      raise 'Can not generate question successfully. Try again' if word_group_ids.length <  1

      return [word_group_ids, similarity, word_tags]
    end

    def generate args
      word_num = args[:word_num].to_i || 5
      min_distance = args[:word_num].to_i || 3
      first_group_num = word_num / 2
      second_group_num = word_num - first_group_num

      first_word = Word.offset(rand(Word.count)).first
      first_word_tags_num = first_word.tags.count

      second_group_ids = []
      first_group_ids, similarity, word_tags = generate_similar_words(first_word, first_group_num)

      # Find second word
      second_word = nil
      max_similar_tag = first_word_tags_num - similarity - min_distance
      (0..max_similar_tag).each do |i|
        different_words = WordTag.group(:word_id).where(tag: word_tags).having("COUNT(*) = #{max_similar_tag - i}").pluck(:word_id)
        if different_words.size >= 1
          second_word = Word.find(different_words.sample(1)[0])
          break
        end
      end

      raise 'Can not generate question successfully. Try again' if second_word.blank?
      second_group_ids, _similarity, _word_tags = generate_similar_words(second_word, second_group_num)

      puts "First group: #{Word.where(id: first_group_ids).pluck(:name)}"
      puts "Second group: #{Word.where(id: second_group_ids).pluck(:name)}"
    end

    def generate_until_success(args, current_time = 1, max_try_times = 10)
      begin
        generate(args)
      rescue => e
        if current_time < max_try_times
          generate_until_success(args, current_time + 1, max_try_times)
        else
          print(current_time)
          raise e
        end
      end
    end

    if args[:word_num].blank?
      puts 'rake generate_grouping:execute[word_num,min_distance]'
      puts 'e.g) generate_grouping:execute[5,2]'
      next
    end

    generate_until_success(args, 1)
  end
end
