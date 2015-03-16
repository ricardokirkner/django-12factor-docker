FROM python:onbuild

# install system packages
RUN apt-get update && apt-get -y install ruby
RUN gem install -q foreman

# default command
CMD ["make", "start"]
