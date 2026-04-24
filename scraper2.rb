# scraper.rb
require 'watir'
require 'sqlite3'

DB_FILE = 'jobs.db'

def db
  @db ||= SQLite3::Database.new(DB_FILE)
end

def save_job(site:, city:, title_query:, job_title:, job_snippet:, job_url:)
  db.execute(
    "INSERT INTO jobs (site, search_city, search_title, job_title, job_snippet, job_url)
     VALUES (?, ?, ?, ?, ?, ?)",
    [site, city, title_query, job_title, job_snippet, job_url]
  )
end

def scrape_francetravail(browser, city, title_query)
  site_name = "France Travail"
  # URL à adapter (exemple générique)
  browser.goto "https://www.francetravail.fr"
  # À adapter selon le HTML réel :
  browser.text_field(name: /motsCles|q/).set(title_query)
  browser.text_field(name: /lieu|l/).set(city)
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.body.text.include?(title_query) rescue true }

  # Exemple de sélecteurs à adapter :
  browser.elements(css: '.result, .offre, .job').each do |card|
    job_title   = card.element(css: 'h2, h3, .title').text rescue nil
    job_snippet = card.element(css: 'p, .description').text[0..300] rescue nil
    job_url     = card.link.href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end

def scrape_indeed(browser, city, title_query)
  site_name = "Indeed"
  browser.goto "https://fr.indeed.com"
  browser.text_field(id: 'text-input-what').set(title_query) rescue nil
  browser.text_field(id: 'text-input-where').set(city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '.jobsearch-SerpJobCard, .job_seen_beacon').exists? rescue true }

  browser.elements(css: '.job_seen_beacon, .jobsearch-SerpJobCard').each do |card|
    job_title   = card.element(css: 'h2 a').text rescue nil
    job_snippet = card.element(css: '.job-snippet, .summary').text[0..300] rescue nil
    job_url     = card.element(css: 'h2 a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#Sites Web gratuits pour votre recherche d'emploi
#
#FRANCETRAVAIL FR
#
#utiliser quotidiennement leur profil de compétences
#
#Ajouter un CV (disponible pour les recruteurs)
#
#- enregistrer des recherches d'offres et créer des alertes (idéalement 5) pour recevoir des offres par email
#
#Autres sites nationaux (pour postuler aux offres en créant son espace personnel et ses alertes) :
#
#INDEED.COM
#
#HELLOWORK.COM
#
def scrape_hellowork(browser, city, title_query)
end
#OPTIONCARRIERE.GF
#
def scrape_optioncarriere(browser, city, title_query)
  site_name = "option carriere"
  browser.goto "https://www.optioncarriere.gf/"
  browser.text_field(id: 's').set(title_query) rescue nil
  browser.text_field(id: 'l').set(city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '.job.clicky').exists? rescue true }

  browser.elements(css: '.job.clicky').each do |card|
    job_title   = card.element(css: 'h2 a').text rescue nil
    job_snippet = card.element(css: '.desc').text[0..300] rescue nil
    job_url     = card.element(css: 'h2 a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#BIENVENUE SUR THEJUNGLE.COM
#
def scrape_welcometothejungle(browser, city, title_query)
  site_name = "welcome to the jungle"
  browser.goto "https://www.welcometothejungle/"
  browser.text_field(id: 'search-query-field').set(title_query+" "+city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '[data-pagetype="jobs_index"]').exists? rescue true }

  browser.elements(css: '[data-pagetype="jobs_index"]').each do |card|
    job_title   = card.element(css: 'h2 a').text rescue nil
    job_snippet = card.element(css: '.desc').text[0..300] rescue nil
    job_url     = card.element(css: 'h2 a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#JOOBLE.COM
#
def scrape_jooble(browser, city, title_query)
  site_name = "welcome to the jungle"
  browser.goto "https://www.welcometothejungle/"
  browser.text_field(id: 'input_:R55j8h:').set(title_query) rescue nil
  browser.text_field(id: 'tbRegion').set(city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '[data-test-name="_jobCard"]').exists? rescue true }

  browser.elements(css: '[data-test-name="_jobCard"]').each do |card|
    job_title   = card.element(css: '.job_card_link a').text rescue nil
    job_snippet = card.element(css: 'span').text[0..300] rescue nil
    job_url     = card.element(css: '.job_card_link a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#JOBIJOBA.COM
#
def scrape_jobijoba(browser, city, title_query)
  site_name = "jobi joba"
  browser.goto "https://www.jobijoba.com/"
  browser.text_field(css: '#form_what_input input').set(title_query) rescue nil
  browser.text_field(css: '#form_where_input input').set(city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '.offer').exists? rescue true }

  browser.elements(css: '.offer').each do |card|
    job_title   = card.element(css: '.offer-header-title').text rescue nil
    job_snippet = card.element(css: '.description').text[0..300] rescue nil
    job_url     = card.element(css: 'a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#BLADA.COM
#
#CHOISIRLESERVICEPUBLIC.GOUV.FR (pour postuler aux offres de service public avec ou sans concurrence)
def scrape_choisirleservicepublic(browser, city, title_query)
  site_name = "choisir le service public"
  browser.goto "https://choisirleservicepublic.gouv.fr"
  browser.text_field(css: '#input').set(title_query+" "+city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '.fr-card--offer').exists? rescue true }

  browser.elements(css: '.fr-card--offer').each do |card|
    job_title   = card.element(css: '.is-same-domain').text rescue nil
    job_snippet = card.element(css: '.fr-icon-calendar-line.fr-icon--sm').text[0..300] rescue nil
    job_url     = card.element(css: 'a.is-same-domain').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#
#RECRUTEMENT.EDUCATION.GOUV.FR
def scrape_recrutementeducationgouv(browser, city, title_query)
  site_name = "jobi joba"
  browser.goto "https://recrutement.education.gouv.fr/"
  browser.text_field(css: '#SearchTerm-67').set(title_query+" "+city) rescue nil
  browser.button(type: 'submit').click

  browser.wait_until { |b| b.div(css: '.fr-card.fr-enlarge-link.fr-card--horizontal.fr-card--horizontal-tier.fr-card--sm').exists? rescue true }

  browser.elements(css: '.fr-card.fr-enlarge-link.fr-card--horizontal.fr-card--horizontal-tier.fr-card--sm').each do |card|
    job_title   = card.element(css: '.fr-card__title').text rescue nil
    job_snippet = card.element(css: '.fr-card__desc').text[0..300] rescue nil
    job_url     = card.element(css: 'a').href rescue nil
    next if job_title.nil? || job_title.empty?

    save_job(
      site: site_name,
      city: city,
      title_query: title_query,
      job_title: job_title,
      job_snippet: job_snippet,
      job_url: job_url
    )
  end
end
#
#(pour postuler aux offres de l'Education Nationale)
#

#
#(pour postuler à des offres en hôtellerie ou restauration)
#
#JOB-INTERIM-GUYANE.FR
def scrape_jobinterimguyane(browser, city, title_query)
end
#
#ANTILLES-GUYANE.FIDERIM.FR
def scrape_antillesguyanefiderim(browser, city, title_query)
end
#
#FOMATGUYANE.FR
def scrape_fomatguyane(browser, city, title_query)
end
#
#GROUPEACTUAL.EU
def scrape_groupeactual(browser, city, title_query)
end
#
#ADECCO.FR
def scrape_adecco(browser, city, title_query)
end
#
#EMPLOIS.INCLUSION.BETA.GOUV.FR/RECHERCHE/EMPLOYEURS (trouver un emploi dans notre Structure d'Activité Economique d'Insertion)
def scrape_emploisinclusion(browser, city, title_query)
end
#
#IMMERSION-FACILE.BETA.GOUV.FR (trouver une entreprise pour réaliser une immersion professionnelle)
def scrape_immersionfacile(browser, city, title_query)
end
#
#Et aussi les réseaux sociaux :
#
#FR.LINKEDIN.COM
def scrape_linkedin(browser, city, title_query)
end
#
#FACEBOOK.COM, TIKTOK.COM, INSTAGRAM.COM
def scrape_facebook(browser, city, title_query)
end
def scrape_tiktok(browser, city, title_query)
end
def scrape_linkedin(browser, city, title_query)
end

# Tu pourras ajouter d’autres méthodes :
# def scrape_hellowork(...); end
# def scrape_welcometothejungle(...); end
# etc.

city        = ARGV[0] || "Cayenne"
title_query = ARGV[1] || "développeur ruby"

browser = Watir::Browser.new :chrome, headless: true

begin
  scrape_francetravail(browser, city, title_query)
  scrape_indeed(browser,        city, title_query)
  # scrape_hellowork(browser,   city, title_query)
  # scrape_wttj(browser,        city, title_query)
ensure
  browser.close
end

puts "Scraping terminé pour #{city} / #{title_query}."

