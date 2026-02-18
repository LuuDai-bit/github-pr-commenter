FROM ruby:4.0-bookworm

RUN apt-get update -qq && apt-get install -y build-essential \
postgresql-contrib \
libpq-dev \
postgresql-client \
vim \
sudo \
systemd \
libvips42

RUN mkdir /github-pr-commenter
WORKDIR /github-pr-commenter

RUN gem install bundler -no-rdoc -no-ri
COPY Gemfile /github-pr-commenter/Gemfile
COPY Gemfile.lock /github-pr-commenter/Gemfile.lock
RUN bundle install

EXPOSE 3000

# Configure the main process to run when running image
CMD ["bundle", "exec", "pumactl", "start"]
