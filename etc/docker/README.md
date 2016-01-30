Docker for ireul-web
======

Setup
-----

    git clone https://github.com/gyng/ireul-web
    cd ireul-web/etc/docker
    git archive --format tar --remote ../.. -o app.tar HEAD
    docker build -t ireul-web .
	docker run -e PASSENGER_APP_ENV=development ireul-web
    sudo nsenter -t SOME_PID_INSIDE_THE_CONTAINER -m -u -i -n -

    # inside the nsenter (until we get a database somewhere)
    sudo -uapp -H /bin/bash -c 'cd /home/app/ireul-web && bundle exec rake db:migrate db:seed && bundle exec rails runner script/create_user.rb'


TODO
----
- database service discovery
- ireul-core service discovery
- file-storage service discovery?
  - We don't have a file storage solution that I like yet.
- move secrets.yml and other config files to a volume?
