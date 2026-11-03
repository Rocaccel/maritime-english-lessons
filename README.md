# Maritime English Lessons

Репозиторий для уроков профессионального английского языка для судоводителей и моряков.

## Цель

Систематизировать учебные материалы по Maritime English: навигация, судовые системы, маневрирование, радиосвязь SMCP, безопасность, MARPOL/SOLAS, грузовые операции, метеорология.

## Структура

```
maritime-english-lessons/
├─ README.md            # этот файл
├─ AGENT.md             # инструкции для агента
├─ mkdocs.yml           # конфиг MkDocs
├─ deploy.cmd           # деплой сайта одним кликом (mkdocs gh-deploy)
├─ .gitignore           # игнорирует site/
├─ overrides/           # правки темы MkDocs
├─ docs/                # источник сайта, здесь правим уроки
│  ├─ README.md         # главная страница сайта
│  ├─ Unit-1/
│  │  ├─ unit-1-text.md
│  │  ├─ unit-1_part-1_main_parts_of_a_vessel_ships_hull.md
│  │  ├─ unit-1_part-2_ship_equipment_and_cargo_operations.md
│  │  ├─ image1.md      # страница с иллюстрацией
│  │  ├─ image2.md
│  │  └─ unit-1_part-1.png, unit-1_part-2.png
│  └─ Unit-2/
│     └─ unit-2-text.md
├─ Unit-1/              # копия из docs/ для удобства, в сборке не участвует
├─ Unit-2/              # копия из docs/ для удобства
└─ site/                # собранная статика, не коммитится
```

## Подготовка к экзаменам

Подходит для CES, Marlins, STCW.

## Лицензия

Для внутреннего обучения.
