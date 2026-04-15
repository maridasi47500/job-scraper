# render.rb
require 'sqlite3'
require 'erb'

DB_FILE = 'jobs.db'

city        = ARGV[0] || "%"
title_query = ARGV[1] || "%"

db = SQLite3::Database.new(DB_FILE)
db.results_as_hash = true

rows = db.execute(
  "SELECT site, search_city, search_title, job_title, job_snippet, job_url
   FROM jobs
   WHERE search_city LIKE ? AND search_title LIKE ?
   ORDER BY created_at DESC",
  [city, title_query]
)

jobs = rows.map do |r|
  {
    site:    r['site'],
    city:    r['search_city'],
    title_q: r['search_title'],
    title:   r['job_title'],
    snippet: r['job_snippet'],
    url:     r['job_url']
  }
end

template = File.read(File.join('views', 'index.html.erb'))
erb      = ERB.new(template)

# variables pour la vue
city        = city
title_query = title_query

html = erb.result(binding)
File.write('jobs.html', html)
puts "Fichier jobs.html généré."

