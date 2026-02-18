FROM ruby:4.0-bookworm

RUN apt-get update -qq && apt-get install -y build-essential \
postgresql-contrib \
libpq-dev \
postgresql-client \
imagemagick vim \
sudo \
cron \
systemd \
libvips42

RUN systemctl enable cron

RUN mkdir /blog
WORKDIR /blog

RUN gem install bundler -no-rdoc -no-ri
COPY Gemfile /blog/Gemfile
COPY Gemfile.lock /blog/Gemfile.lock
RUN bundle install

EXPOSE 3000

# Configure the main process to run when running image
CMD ["bundle", "exec", "pumactl", "start"]
