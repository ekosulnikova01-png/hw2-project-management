-- Часть 2. Демонстрация 5 типов нарушений ограничений

-- 1. Нарушение CHECK: отрицательное количество часов
DO $$
BEGIN
    INSERT INTO tasks (project_id, assignee_id, title, status, priority, estimated_hours, created_date)
    VALUES (1, 1, 'Тестовая задача', 'new', 'low', -5, CURRENT_DATE);
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'Ошибка: нельзя указать отрицательное количество часов (%). Оценка должна быть положительной. Технически: %', -5, SQLERRM;
END;
$$;

-- 2. Нарушение FOREIGN KEY: несуществующий проект
DO $$
BEGIN
    INSERT INTO tasks (project_id, assignee_id, title, status, priority, estimated_hours, created_date)
    VALUES (999, 1, 'Задача для несуществующего проекта', 'new', 'low', 10, CURRENT_DATE);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Ошибка: нельзя создать задачу для проекта, которого не существует (id=999). Сначала создайте проект. Технически: %', SQLERRM;
END;
$$;

-- 3. Нарушение UNIQUE: дубликат email сотрудника
DO $$
BEGIN
    INSERT INTO employees (first_name, last_name, email, hire_date, is_active)
    VALUES ('Тест', 'Тестов', 'ivan@company.com', CURRENT_DATE, true);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Ошибка: сотрудник с таким email уже существует (ivan@company.com). Email должен быть уникальным. Технически: %', SQLERRM;
END;
$$;

-- 4. Нарушение NOT NULL: задача без названия
DO $$
BEGIN
    INSERT INTO tasks (project_id, assignee_id, title, status, priority, estimated_hours, created_date)
    VALUES (1, 1, NULL, 'new', 'low', 10, CURRENT_DATE);
EXCEPTION
    WHEN not_null_violation THEN
        RAISE NOTICE 'Ошибка: у задачи обязательно должно быть название (title). Нельзя оставлять пустым. Технически: %', SQLERRM;
END;
$$;

-- 5. Нарушение составного CHECK: статус не изменился
DO $$
BEGIN
    INSERT INTO task_history (task_id, old_status, new_status, changed_by)
    VALUES (1, 'in_progress', 'in_progress', 1);
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'Ошибка: статус задачи должен измениться. Нельзя записать, что статус был "%" и стал "%". Технически: %', 'in_progress', 'in_progress', SQLERRM;
END;
$$;