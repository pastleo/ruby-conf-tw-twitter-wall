# product: -it -p 80:80 -p 8080:8080
# dev: -it -p 80:80 -p 8080:8080 -v $(pwd)/server/:/server -v $(pwd)/client/:/client
# ws_only: -d --restart=always -p 8080:8080 ruby-conf-tw-2014-twitter-wall ruby -I. /server/server.rb
# ws_only_fast: -v (pwd)/server:/server -d --restart=always -p 8080:8080 ruby-conf-tw-2014-twitter-wall ruby -I. /server/server.rb
# dockerRun: -p 127.0.0.1:10000:8080 -v $(pwd)/server/:/server -v $(pwd)/client/:/client
FROM ruby
# FROM debian-bash

RUN mkdir -p /root /client /server
ADD client /client
ADD server /server

WORKDIR /server/

RUN \
apt-get update && apt-get -y install \
less nodejs; \
apt-get clean; \
bundle install

EXPOSE 8080

CMD ["ruby", "-I.", "/server/server.rb"]
# CMD bash
