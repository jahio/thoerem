# SmartAC

Zero to testing:

`alias be="bundle exec"`

1. `git clone` this repo;
1. `be rake db:create && be rake db:migrate && be rake db:seed && be rake notifications:generate`
1. `bundle exec rspec` to run tests

Project requirements:

+ PostgreSQL w/ 'uuid-ossp' and 'pgcrypto' extensions
  + As long as you have a regular pgsql install going on, the migrations
  will create these extensions for you.