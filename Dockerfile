FROM ubuntu:trusty

# install system packages
RUN apt-get -qq update && apt-get -qy install ruby python-pip python-dev libpq-dev postgresql-client
RUN gem install -q foreman

# prepare directories
RUN mkdir /code
WORKDIR /code

# install python packages
ADD requirements.txt /code/
RUN pip install -r requirements.txt

# add code to image
ADD . /code/
