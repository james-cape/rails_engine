# README

Welcome to Rales Engine! This project creates over 100 endpoints for API requests. Requests retrieve a variety of sales statistics using included CSVs.

This project practices API production using Rails and is tested with RSpec. All queries are done at the model level using ActiveRecord, and information is passed back via the Model-View-Controller design pattern.

[Rales Engine Project Description](https://backend.turing.io/module3/projects/rails_engine)

#### Ruby Version:
2.4.1p111 (2017-03-22 revision 58053)

#### Rails Version:
Rails 5.2.3

#### How to run the test suite
1. Clone github repo onto your local machine.

1. `$ bundle install`: Configure system dependencies

1. `rake import:data`: Database creation and initialization

1. `bundle exec rspec`: runs test suite

1. `$ rails s`: starts server
