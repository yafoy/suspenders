# Suspenders

Suspenders is the base Rails application used at
[yafoy](https://yafoy.com/). It is heavily inspired from [thoughtbot](https://github.com/thoughtbot/suspenders).

## Installation

First install the suspenders gem:

    gem install suspenders

Then run:

    suspenders projectname

This will create a Rails app in `projectname` using the latest version of Rails.

## Gemfile

To see the latest and greatest gems, look at Suspenders'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile.

It includes application gems like:

* [Figaro](https://laserlemon/figaro) to manage environment variables
* [Flutie](https://github.com/thoughtbot/flutie) for `page_title` and `body_class` view
  helpers
* [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
* [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Title](https://github.com/calebthompson/title) for storing titles in
  translations

And development gems like:

* [Better Errors](https://github.com/charliesome/better_errors) to replace the standard Rails error page with a much better and more useful error page
* [ByeBug](https://github.com/deivid-rodriguez/byebug) for interactively
  debugging behavior
* [Bullet](https://github.com/flyerhzm/bullet) for help to kill N+1 queries and
  unused eager loading
* [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the
  Gemfile for insecure dependencies based on published CVEs
* [Ffaker](https://github.com/ffaker/ffaker) to populate database with dummies
* [Hirb](https://github.com/cldwalker/hirb) to improve ripl(irb)'s default inspect output
* [Letter Opener](https://github.com/ryanb/letter_opener) to preview email in the default browser
* [Quiet Assets](https://github.com/evrone/quiet_assets) for muting assets
  pipeline log messages
* [Rack Mini Profiler](https://github.com/MiniProfiler/rack-mini-profiler) to display speed badge for every html page
* [Spring](https://github.com/rails/spring) for fast Rails actions via
  pre-loading
* [Thin](https://github.com/macournoyer/thin) to serve HTTP requests
* [Web Console](https://github.com/rails/web-console) for better debugging via
  in-browser IRB consoles

And testing gems like:

* [minitest-reporters](https://github.com/kern/minitest-reporters)

And production gems like:

* [Exception Notification](https://github.com/smartinez87/exception_notification) to send notifications when errors occur
* [Unicorn](http://unicorn.bogomips.org) as web server
* [Rails 12 Factor](https://github.com/heroku/rails_12factor) for Heroku deployment


## Configuration

__Production__

- Set up exception notifier


__Development__

- Configure generators
- Create `rake bs` rake task
- Set up `config/database.yml`
- Set up `config/application.yml`
- Set up `db/sample_data.rb`
- Set up `.gitignore`


__Test__

- Set up Minitest
