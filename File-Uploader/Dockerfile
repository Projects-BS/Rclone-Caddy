FROM ubuntu:20.04

# - Setting up tzdata configuration
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# index.js is a must but other files are just for a backup
COPY ./index.js /app/index.js
COPY ./index.html /app/index.html
COPY ./upload.js /app/upload.js
COPY ./process.php /app/process.php

RUN chmod 777 /app/index.js
RUN chmod 777 /app/index.html
RUN chmod 777 /app/upload.js
RUN chmod 777 /app/process.php

# - Configuring Environment
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment
RUN echo "NODE_ENV=development" >> /etc/environment
RUN more "/etc/environment"

RUN apt-get update
RUN apt-get install curl htop git zip nano ncdu build-essential chrpath libssl-dev libxft-dev pkg-config glib2.0-dev libexpat1-dev gobject-introspection python-gi-dev apt-transport-https libgirepository1.0-dev libtiff5-dev libjpeg-turbo8-dev libgsf-1-dev fail2ban nginx -y

# - Installing php
RUN apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt -y install php7.4

# - Installing node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install --yes nodejs

# - Running Checks
RUN node -v
RUN npm -v
RUN php -v

# - Cleanup
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y

# - Starting Server
CMD ["node","index.js"]

# - THE END - 
