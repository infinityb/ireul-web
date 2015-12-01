# ireul-web

[![Build Status](https://travis-ci.org/gyng/ireul-web.svg)](https://travis-ci.org/gyng/ireul-web)

A Rails client for [Ireul](https://github.com/infinityb/ireul/).

## Dev setup
1. Clone
2. `bundle update`
3. `bundle install`
4. `rake db:seed`
5. Configure `config/ireul.yml` with Ireul server url/port
6. `bundle exec rails server`

## Test
`rake test`

## Notes and useful commands
* `rake db:fixtures:dump`
* `Gemfile.lock` is in `.gitignore` due to cross-platform issues [1](https://github.com/bundler/bundler-features/issues/4). Also helps with running on Travis CI as local gems are used in this app.

### Installing on Windows
* Ruby22 + bcrypt — [1](https://github.com/codahale/bcrypt-ruby/issues/116), [2](https://www.alib.jp/entries/bcrypt_ext_load_error_on_ruby21x), make sure `git`, DevKit `dk/bin` and `dk/mingw/bin` are in PATH
