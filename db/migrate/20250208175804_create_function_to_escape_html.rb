class CreateFunctionToEscapeHtml < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE OR REPLACE FUNCTION escape_html(input_text TEXT) RETURNS TEXT AS $$
      DECLARE
          escaped_text TEXT;
      BEGIN
          -- Replace special HTML characters with their corresponding HTML entities
          escaped_text := REPLACE(input_text, '&', '&amp;');
          escaped_text := REPLACE(escaped_text, '<', '&lt;');
          escaped_text := REPLACE(escaped_text, '>', '&gt;');
          escaped_text := REPLACE(escaped_text, '"', '&quot;');
          escaped_text := REPLACE(escaped_text, '''', '&#39;');

          RETURN escaped_text;
      END;
      $$ LANGUAGE plpgsql IMMUTABLE;
    SQL
  end

  def down
    execute <<~SQL
      DROP FUNCTION escape_html;
    SQL
  end
end
