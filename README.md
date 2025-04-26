# Группа 3, Финальный проект
## Установка
### Необходимо клонировать репозиторий в нужную директорию

```bash
git clone git@git-intern.digitalleague.ru:sudja900/final_project.git
cd final_project
```

### Необходимо запустить собрать и запустить контейнеры:
```bash
docker compose build

docker compose up
```

Для работы с приложением небходимо сделать запрос на добавление данных:
```bash
curl -X POST "http://localhost:8080/tickets/mass_create" \
    -H "Content-Type: application/json" \
    -d '{
        "category_name": "base",
        "base_price": 1000,
        "count": 10,
        "event_date": "2025-12-12"
    }'
```
!Любые данные можно поменять на собственные!

Теперь можно работать с приложением. Для его тестирования предлагаются несколько curl запросов

## Запросы:

1) GET /tickets/price
```bash
curl "http://localhost:8080/tickets/price?category=base&event_date=2025-12-12"
```

2) GET /tickets/id
```bash
curl "http://localhost:8080/tickets/1"
```

3) POST /tickets/book
```bash
curl -X POST "http://localhost:8080/tickets/book" \
   -H "Content-Type: application/json" \
   -d '{
        "ticket_category_name": "base",
        "event_date": "2025-12-12"
    }'
```

4) POST /tickets/buy
```bash
curl -X POST "http://localhost:8080/tickets/buy" \
   -H "Content-Type: application/json" \
   -d '{
        "book_id": 1,
        "full_name": "Testov Test Testovich",
        "document_type": "passport",
        "document_number": "12345678",
        "email": "test@example.com",
        "date_of_birth": "1990-01-01"
    }'
```

5) POST /tickets/block
```bash
curl -X POST "http://localhost:8080/tickets/block" \
    -H "Content-Type: application/json" \
    -d '{
        "ticket_id": 1,
        "document_number": "12345678",
        "reason": "angry"
    }'
```

6) POST /tickets/cancel
```bash
curl -X POST "http://localhost:8080/tickets/cancel" \
    -H "Content-Type: application/json" \
    -d '{
        "book_id": 2
    }'
```

7) PATCH /visits/enter
```bash
curl -X PATCH "http://localhost:8080/visits/enter" \
    -H "Content-Type: application/json" \
    -d '{
        "visit": {
            "ticket_id": 1,
            "zone": "base",
            "event_date": "2025-12-12",
            "action": "enter"
        }
    }'
```

8) PATCH /visits/exit
```bash
curl -X PATCH "http://localhost:8080/visits/exit" \
    -H "Content-Type: application/json" \
    -d '{
        "visit": {
            "ticket_id": 1,
            "zone": "base",
            "event_date": "2025-12-12",
            "action": "exit"
        }
    }'
```

9) GET /logs
```bash
curl -X GET "http://localhost:8080/logs?ticket_id=2&full_name=Testov%20Test%20Testovich&event_type=enter&page=1"
```
Или
```bash
curl -X GET "http://localhost:8080/logs?ticket_id=2"
```
