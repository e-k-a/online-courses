workspace "Online Store" {

    model {
        guest = person "Посетитель сайта" "Просматривает курсы без регистрации"
        student = person "Студент" "Проходит обучение, тестирование и получает сертификаты."
        proffesor = person "Преподаватель" "Создает курсы и оценивает студентов"
        support = person "Поддержка" "Отвечает на вопросы студентов и преподавателей."

        system = softwareSystem "Онлайн школа" "Веб-приложение для прохождения курсов" {
            guest -> this "Просматривает список курсов"
            student -> this "Обучается, проходит тесты, получает сертификаты"
            proffesor -> this "Создаёт и управляет курсами, оценивает студентов"
            support -> this "Общается с пользователями через чат"
            

            webApp = container "Интерфейс" "Веб-интерфейс для студентов, преподавателей и гостей." "TypeScript + React"
            mobileApp = container "Мобильное прложение" "Мобильное приложение для студентов." "Dart"
            api = container "Бэкенд" "Обрабатывает бизнес-логику и доступ к данным." "Java"
            db = container "База данных" "Хранит данные о пользователях, курсах, тестах и результатах." "PostgreSQL"
            fileStore = container "Хранилище файлов" "Хранит видео, PDF и сертификаты." "S3"
            mailService = container "Сервис отправки уведомлений" "Отправляет уведомления пользователям" "SMTP"


            student -> webApp "Взаимодействует с курсами"
            student -> mobileApp "Использует для обучения"

            proffesor -> webApp "Создает материалы"
            proffesor -> mobileApp "Использует для отслеживания прогресса"

            guest -> webApp "Просматривает курсы"
            support -> webApp "Использует админ-панель"

            webApp -> api "Отправляет REST-запросы"
            api -> db "Сохраняет и читает данные"
            api -> fileStore "Сохраняет и загружает файлы"
            api -> mailService "Отправляет уведомления"
        }
    }

    views {

        systemContext system "C1" {
            include *
            autoLayout lr
            title "C1: Контекст системы"
        }

        container system "C2" {
            include *
            autoLayout lr
            title "C2: Диаграмма контейнеров"
        }
        theme default
    }
}
