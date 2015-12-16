# Production setup

## First run

### On the server
1. Install Ruby, NodeJS (with [rbenv](https://github.com/rbenv/rbenv) or otherwise)
2. `mkdir /var/www`
3. `chown /var/www <deploy>` give permissions to deploying user (in this example, `deploy` is the user)

### On a dev machine
1. `cp config/deploy/production.rb.template config/deploy/production.rb`
2. Configure `config/deploy/production.rb`, `config/deploy.rb`
3. Set up required SSH keys: Put your `id_rsa` in `~/.ssh`
4. `bundle install`
5. `cap -T` to view available tasks
6. `cap production deploy`
7. `cap production bundler:install`
8. `cap production deploy:migrate`
9. `cap production deploy:seed`
10. `cap production deploy:compile_assets`

### Back on the server
1. Set up production secret key: [instructions](http://stackoverflow.com/a/26172408)
2. Configure `config/ireul.yml`
3. Configure `config/database.yml` if not using SQLite. [Guide](http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database)

### Back on the dev machine
1. `cap production passenger:start_sudo`

## Subsequent deploys
(Not fully tried and tested)

### On a dev machine
1. `cap production deploy`
2. Whatever needs running (assets, migrations)
3. `cap production passenger:restart` or `cap production passenger:stop_sudo`, `cap production passenger:start_sudo`
