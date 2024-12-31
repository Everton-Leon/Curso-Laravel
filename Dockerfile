# Imagem do PHP 8.4
FROM php:8.4-fpm-alpine3.21

# Instalando dependencias do sistema
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libzip-dev \
    zlib-dev

# Instalando dependencias do PHP
RUN docker-php-ext-install gd zip pdo_mysql

# Ultima versão do Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalando node e npm
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libzip-dev \
    zlib-dev \
    nodejs \
    npm

# Definindo diretório de trabalho
WORKDIR /var/www

# Copiando código do Laravel
COPY . /var/www
RUN chown -R www-data:www-data /var/www

# Instalando dependências do Laravel e configurando o projeto
RUN npm install && \
    npm run build &&\
    composer install && \
    php artisan key:generate && \
    php artisan storage:link

# Expondo porta 9000
EXPOSE 9000
