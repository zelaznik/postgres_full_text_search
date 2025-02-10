class CreateTextSearchThesaurus < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      -- Create the thesaurus dictionary
      CREATE TEXT SEARCH DICTIONARY my_thesaurus ( TEMPLATE = thesaurus, DictFile = my_thesaurus, Dictionary = english_stem );

      -- Alter the configuration to use the thesaurus dictionary
      ALTER TEXT SEARCH CONFIGURATION english
      ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
      WITH my_thesaurus, english_stem;
    SQL
  end

  def down
    execute <<~SQL
      -- Alter the configuration to use the thesaurus dictionary
      ALTER TEXT SEARCH CONFIGURATION english
      ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
      WITH english_stem;

      DROP TEXT SEARCH DICTIONARY my_thesaurus;
    SQL
  end
end
