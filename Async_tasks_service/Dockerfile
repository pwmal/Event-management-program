# Используем базовый образ Ruby версии 3.1 в облегчённом (slim) варианте.
FROM ruby:3.1-slim

# Обновляем списки пакетов и устанавливаем необходимые системные зависимости.
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию внутри контейнера.
WORKDIR /app

# Копируем файлы Gemfile и Gemfile.lock в рабочую директорию.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Выполняем установку Ruby гемов, указанных в Gemfile.
RUN bundle install

# Копируем код сервиса в контейнер
COPY task_consumer.rb /app

# Запускаем код сервиса
CMD ["ruby", "task_consumer.rb"]