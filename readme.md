# Задание по рефакторингу

### Инструкции

Для выполнения задания требуется:

- Отрефакторить данный пример в тот вид, который считаешь приемлимым
- Добавить описание:
  - того, что изменилось и почему
  - с какими проблемами столкнулся в процессе
  - любые идеи и мысли, чтобы еще сделал при наличии дополнительного времени, и т.д.

### История

Нам захотелось попробовать возможность отправки различных промо сообщений новым пользователям.
Поэтому, мы разработали функционал, который позволяет администраторам:

- Создавать и отправлять промо сообщения пользователям, которые опубликовали 
  свое первое объявление в указанный промежуток времени.
- Скачать CSV файл со списком получателей.

Для упрощения модели и контроллеры находятся в одном файле (example.rb), что должно дать 
общее представление для выполнения задания.



# Общие коментарии

Я предполагал что логика протестирована и не заморачивался над бизнес логикой и соответствию интерфейса клиенской части.
Постарался все мысли оставить в комментариях в коде. Имея больше информации и понимания процеса улучшать можно куда больше
Не заметил никаких проверок авторизации, типа pundit или еще чего, что бы могло ограничивать права доступа только администраторам
Мне сказали что на задание должно уйти ~час. Я потратил 1,75 часа