FROM ruby:$RUBY_VERSION

RUN apt-get clean && apt-get update
RUN apt-get install -y apt-transport-https build-essential qt5-default libqt5webkit5-dev xvfb postgresql postgresql-contrib wget less

ENV BUNDLE_HOME /gems
ENV BUNDLE_PATH /gems
ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3
ENV DOCKERIZE_VERSION v0.3.0
ENV GEM_HOME /gems
ENV GEM_PATH /gems
ENV SECRET_KEY_BASE test123
ENV TERM xterm
ENV QT_VERSION 5.5.1
ENV NODE_VERSION 9
ENV PATH /gems/bin:/usr/local/Qt-$QT_VERSION:/bin$PATH

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install bundler
RUN gem install bundler

# Install yarn & node
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
RUN apt-get update
RUN apt-get install -y yarn nodejs

# Allow SSH to be mounted (mainly for git push)
VOLUME /root/.ssh

# Setup /app for the actual codebase
WORKDIR /app

CMD /bin/bash
