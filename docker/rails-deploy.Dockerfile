FROM rails:$RUBY_VERSION

ONBUILD COPY Gemfile* /app/
ONBUILD COPY vendor/bundle /app/vendor/bundle
ONBUILD RUN bundle install --deployment --quiet

ONBUILD ARG RAILS_ENV
ONBUILD ENV RAILS_ENV $RAILS_ENV

ONBUILD ARG RAILS_MASTER_KEY
ONBUILD ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY

ONBUILD ARG GIT_COMMIT=UNKNOWN
ONBUILD ENV GIT_COMMIT $GIT_COMMIT

ONBUILD COPY . /app
ONBUILD RUN bin/rake assets:precompile

CMD bin/rake db:create && \
    bin/rake db:migrate && \
    bin/rake db:seed && \
    bin/puma -C config/puma.rb
