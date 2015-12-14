# ireul-web

[![Build Status](https://travis-ci.org/gyng/ireul-web.svg)](https://travis-ci.org/gyng/ireul-web)

Rails (with React) client for [Ireul](https://github.com/infinityb/ireul/), a radio backend.

![Screenshot](http://i.imgur.com/SgSDlBG.png)

## Dev setup
0. [Install NodeJS](https://nodejs.org/en/download/)
1. [Install ImageMagick](http://www.imagemagick.org/index.php)
2. Clone
3. `bundle update`
4. `bundle install`
5. `rake db:migrate`
6. `rake db:seed`
7. Configure `config/ireul.yml` with Ireul server url/port
8. `cp config/fake_secrets.yml config/secrets.yml`
9. `rails runner script/create_user.rb`
10. `bundle exec rails server`

## Features
* Song database (48kHz OGG)
* Song requests with cooldowns
* Frosted background images for each song
* Cool interface

## Notes and useful commands
* Login at `http://example.com/login`
* `rake db:fixtures:dump` dumps existing DB as fixtures
* `rails runner script/ingest.rb`
* `Gemfile.lock` is in `.gitignore` due to cross-platform issues [1](https://github.com/bundler/bundler-features/issues/4). Also helps with running on Travis CI as local gems are used in this app.

### Test
`rake test`

### Windows
* Ruby22 + bcrypt — [1](https://github.com/codahale/bcrypt-ruby/issues/116), [2](https://www.alib.jp/entries/bcrypt_ext_load_error_on_ruby21x), make sure `git`, DevKit `dk/bin`, `dk/mingw/bin` are in PATH
* [ImageMagick](http://www.imagemagick.org/script/binary-releases.php#windows)
