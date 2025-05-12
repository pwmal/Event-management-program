# Используем базовый образ Ruby версии 3.1 в облегчённом (slim) варианте.
FROM ruby:3.1-slim

# Обновляем списки пакетов и устанавливаем необходимые системные зависимости.
RUN apt-get update -qq && apt-get install -y build-essential

# Устанавливаем рабочую директорию внутри контейнера.
WORKDIR /app

# Копируем файлы Gemfile и Gemfile.lock в рабочую директорию.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Выполняем установку Ruby гемов, указанных в Gemfile.
RUN bundle install

# Копируем весь исходный код приложения в контейнер.
COPY . /app

# Открываем порт, который указан в конфигурации Puma, например, 4567.
EXPOSE 4567

# Команда запускает Puma с указанной конфигурацией.
CMD ["puma", "-C", "config/puma.rb"]