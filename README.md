# SmartAC

Zero to testing:

1. `git clone` this repo;
1. `bundle exec rake db:create`
1. `bundle exec rake db:migrate`
1. `bundle exec rspec` to run tests

Project requirements:

+ PostgreSQL w/ 'uuid-ossp' and 'pgcrypto' extensions
  + As long as you have a regular pgsql install going on, the migrations
  will create these extensions for you.