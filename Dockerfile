FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
# COPY copy/ /
ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV JEKYLL_ENV=development
ENV LC_ALL=en_US

RUN apk --update add zlib-dev build-base libxml2-dev libxslt-dev readline-dev \
  libffi-dev ruby-dev yaml-dev zlib-dev libxslt-dev readline-dev libxml2-dev libffi-dev \
  ruby-dev yaml-dev zlib libxml2 build-base ruby-io-console readline libxslt ruby \
  yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc git

RUN gem install --no-ri --no-rdoc jekyll -v3.4.3
RUN if [[ $(getent group jekyll) ]] ; then echo 1; else addgroup -Sg 1000 jekyll && adduser -Su 1000 -g 1000 jekyll; fi

RUN mkdir -p /usr/share/ruby
COPY ./default-gems /usr/share/ruby/
# RUN echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems
RUN gem install bundler --no-ri --no-rdoc
RUN bundle install --gemfile="/usr/share/ruby/default-gems"

RUN mkdir -p /srv/jekyll && chown -R jekyll:jekyll /srv/jekyll
RUN echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers
RUN cleanup
# CMD ["/usr/local/bin/jekyll", "--help"]
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729 4000