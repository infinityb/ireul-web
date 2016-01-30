# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby22:0.9.18

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down


RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/ireul-web.conf
RUN mkdir /home/app/ireul-web
ADD app.tar /home/app/ireul-web
WORKDIR /home/app/ireul-web
RUN chown app:app -R /home/app/ireul-web
RUN sudo -u app -H bundle install --path vendor/bundle
RUN sudo -u app -H bundle exec rake assets:precompile


# Add secrets
COPY ireul.yml /home/app/ireul-web/config/ireul.yml
COPY database.yml /home/app/ireul-web/config/database.yml
COPY secrets.yml /home/app/ireul-web/config/secrets.yml



# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
