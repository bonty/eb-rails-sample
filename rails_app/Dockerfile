FROM phusion/baseimage:0.9.12

MAINTAINER Hiroshi Kouno <h.kouno@aktsk.jp>

RUN mkdir /setup
ADD docker/install_packages.sh /setup/install_packages.sh

RUN /setup/install_packages.sh && rm -fr /setup

RUN groupadd app && useradd -g app -M -s /bin/false app

# Install Rails
RUN mkdir /app
WORKDIR /app

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Start rails app as service
RUN mkdir /etc/service/rails
ADD docker/rails-run.sh /etc/service/rails/run

ADD . /app
RUN chown -R app:app /app

# Publish port 3000
EXPOSE 3000

CMD ["/sbin/my_init"]
