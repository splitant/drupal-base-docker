FROM wodby/drupal-php:$PHP_TAG

WORKDIR /var/www/html

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip vim curl

RUN echo 'alias ll="ls -alF"' >> ~/.bashrc
RUN echo 'alias la="ls -A"' >> ~/.bashrc
RUN echo 'alias l="ls -CF"' >> ~/.bashrc
RUN echo 'bak() { cp "$1"{,.bak};}' >> ~/.bashrc
RUN echo 'mcd() { mkdir -p "$1"; cd "$1";}' >> ~/.bashrc

ADD ./scripts/setup_project .
ADD .env .


