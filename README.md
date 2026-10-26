# Домашнее задание №2 (Project Management)

**Схема БД:** Управление проектами (employees, projects, tasks, tags, task_tags)

## Часть 1. Новые таблицы

Добавлены две таблицы:
- **comments** — комментарии к задачам (связь с `tasks` и `employees`).
- **task_history** — история изменения статусов задач (связь с `tasks` и `employees`).

Обе таблицы используют `ON DELETE CASCADE` для задач: если задача удаляется, все её комментарии и записи истории удаляются автоматически.

## Часть 2. Демонстрация нарушений (см. `errors_demo.sql`)

Скрипт содержит 5 блоков `DO $$ ... EXCEPTION ... END $$`, перехватывающих ошибки CHECK, FOREIGN KEY, UNIQUE, NOT NULL и составного CHECK.

## Часть 3. Таблица нарушений

| № | Ограничение | Выполняемый запрос (SQL) | Сообщение СУБД | Понятное сообщение для пользователя | Как исправить |
|---|---|---|---|---|---|
| 1 | CHECK | `INSERT INTO tasks (... estimated_hours) VALUES (..., -5, ...)` | `violates check constraint "tasks_estimated_hours_check"` | «Оценка в часах должна быть положительным числом. Отрицательное значение недопустимо» | Указать корректное значение > 0 |
| 2 | FOREIGN KEY | `INSERT INTO tasks (project_id, ...) VALUES (999, ...)` | `violates foreign key constraint "tasks_project_id_fkey"` | «Нельзя создать задачу для несуществующего проекта. Сначала создайте проект с таким ID» | Указать существующий `project_id` |
| 3 | UNIQUE | `INSERT INTO employees (... email ...) VALUES (..., 'ivan@company.com', ...)` | `duplicate key value violates unique constraint "employees_email_key"` | «Сотрудник с таким email уже зарегистрирован. Email должен быть уникальным» | Указать другой email |
| 4 | NOT NULL | `INSERT INTO tasks (... title ...) VALUES (..., NULL, ...)` | `null value in column "title" violates not-null constraint` | «У задачи обязательно должно быть название» | Указать непустое название |
| 5 | CHECK (составной) | `INSERT INTO task_history (..., old_status, new_status, ...) VALUES (..., 'in_progress', 'in_progress', ...)` | `violates check constraint "chk_status_change"` | «Статус задачи должен измениться» | Указать разные значения для `old_status` и `new_status` |

## Выводы

1. Добавлены две таблицы с соблюдением целостности.
2. Скрипт демонстрирует 5 типов ошибок с понятными сообщениями на русском языке.
3. Все ограничения соответствуют бизнес-логике системы управления проектами.