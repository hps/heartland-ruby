FROM silvioq/ruby-1.8.7

RUN mkdir /src
WORKDIR /src
RUN gem install bundler

COPY . /src
RUN bundle install \
  && echo '' \
  && echo 'ruby version' && ruby --version \
  && echo 'rubygems version' && gem --version \
  && echo ''
