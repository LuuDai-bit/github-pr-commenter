FROM ruby:4.0-alpine

RUN apk add --no-cache \
    build-base \
    postgresql-dev\
    vim \
    sudo \
    yaml-dev

RUN mkdir /github-pr-commenter
WORKDIR /github-pr-commenter

RUN gem install bundler -no-rdoc -no-ri
COPY Gemfile /github-pr-commenter/Gemfile
COPY Gemfile.lock /github-pr-commenter/Gemfile.lock
RUN bundle install

EXPOSE 3000

# Configure the main process to run when running image
CMD ["bundle", "exec", "pumactl", "start"]
