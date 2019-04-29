FROM ruby:2.4.1
MAINTAINER Pedro garcia <pedro.garcia@atos.com>

RUN apt-get update && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get install -y nodejs && \
	gem install -q bundler -v 2.0.0 && \
	npm install -g grunt-cli && \
	bower install bower bootstrap jquery popper.js

RUN mkdir -p /etc/jekyll && \
	printf 'source "https://rubygems.org"\ngem "github-pages","198"\ngem "execjs","2.7.0"\ngem "rouge","2.2.1"' > /etc/jekyll/Gemfile && \
	printf "\nBuilding required Ruby gems. Please wait..." && \
	bundle install --gemfile /etc/jekyll/Gemfile --clean --quiet 

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BUNDLE_GEMFILE /etc/jekyll/Gemfile

EXPOSE 4000

ENTRYPOINT ["bundle", "exec"]

CMD ["jekyll", "serve","--host=0.0.0.0"]
