# scraper.rb (première exécution seulement pour créer la table)
require 'sqlite3'

DB_FILE = 'jobs.db'

db = SQLite3::Database.new(DB_FILE)
db.execute <<~SQL
  CREATE TABLE IF NOT EXISTS jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    site TEXT,
    search_city TEXT,
    search_title TEXT,
    job_title TEXT,
    job_snippet TEXT,
    job_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL
puts "Table jobs prête."

