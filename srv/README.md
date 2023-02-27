# README


* Ruby version 3.2.1

* Rails version 7.0.4

* Mysql version 8.0.32

* Redis version 7.0.8

## How to start development environment
* cp config/application.tmpl.yml /config/application.yml
* cp config/settings/development.tmpl.yml config/settings/development.yml
* script/docker/setup.sh --ssh-key path_to_your_id_rsa_key
* script/docker/start.sh
* access http://localhost:3030

## How to start generate grouping quiz

* Import word: `bundle exec rake import_words:execute`
* Generate quiz: `bundle exec rake generate_grouping:execute[5,3]` For generate 5 words belongs 2 groups with 3 minium distance
