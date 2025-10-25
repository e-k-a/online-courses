workspace "Online Store" {

    model {
        guest = person "Посетитель сайта" "Просматривает курсы без регистрации"
        student = person "Студент" "Проходит обучение, тестирование и получает сертификаты."
        proffesor = person "Преподаватель" "Создает курсы и оценивает студентов"
        support = person "Поддержка" "Отвечает на вопросы студентов и преподавателей."

        paymentSystem = softwareSystem "Оплата курсов" "Обрабатывает онлайн-платежи" {
            tags "External System"
        }

        system = softwareSystem "Онлайн школа" "Веб-приложение для прохождения курсов" {
            guest -> this "Просматривает список курсов"
            student -> this "Обучается, проходит тесты, получает сертификаты"
            proffesor -> this "Создаёт и управляет курсами, оценивает студентов"
            support -> this "Общается с пользователями через чат"
            

            webApp = container "Интерфейс" "Веб-интерфейс для студентов, преподавателей и гостей." "TypeScript + React"
            mobileApp = container "Мобильное прложение" "Мобильное приложение для студентов." "Dart"

            gatewayService = container "API Gateway" "Управление запросами к сервисам" "NGINX"
            userService = container "Профиль пользователей" "Показывает профиль пользователей" "Java" 
            courseService = container "Управление курсами и уроками" "Показывает данные о курсах" "Java"
            mailService = container "Сервис отправки уведомлений" "Отправляет уведомления пользователям" "SMTP"
            analyticsService = container "Сервис аналитики" "Сервис для просмотра результатов и сертификатов студентов" "Java"
            paymentService = container "Сервис оплаты" "Взаимодействует с внешним сервисом" "Java"

            messageBroker = container "Брокер сообщений" "Получение/Отправка сообщений" "Kafka" {
                tags "Message Broker"
            }

            dbUsers = container "База данных по пользователям" "Хранит данные о пользователях" "PostgreSQL" {
                 tags "Database"
                }
            dbCourses = container "База данных по курсам" "Хранит данные об уроках и курсах" "PostgreSQL" {
                 tags "Database"
                }
            dbAnalytics = container "База данных по аналитике" "Хранит данные об результатах прохождения курсов" "PostgreSQL" {
                 tags "Database"
                }
            dbPayment = container "База данных по платежам" "Хранит данные об оплатах" "PostgreSQL" {
                 tags "Database"
                }
            fileStore = container "Хранилище файлов" "Хранит видео, PDF и сертификаты." "S3" {
                 tags "File Storage" 
                 }


            student -> webApp "Взаимодействует с курсами"
            student -> mobileApp "Использует для обучения"
            proffesor -> webApp "Создает материалы"
            proffesor -> mobileApp "Использует для отслеживания прогресса"
            guest -> webApp "Просматривает курсы"
            support -> webApp "Использует админ-панель"

            webApp -> gatewayService """REST API"
            mobileApp -> gatewayService "REST API"

            gatewayService -> userService "Пересылает запросы""REST API"
            gatewayService -> courseService "Пересылает запросы""REST API"
            gatewayService -> analyticsService "Пересылает запросы""REST API"
            gatewayService -> paymentService "Пересылает запросы" "REST API"
            paymentService -> paymentSystem  "Отправляет запросы на оплату""REST API (HTTPS)"

            userService -> dbUsers "Читает/записывает данные ""SQL"
            courseService -> dbCourses "Читает/записывает данные ""SQL"
            analyticsService -> dbAnalytics "Читает/записывает данные ""SQL"
            paymentService -> dbPayment "Читает/записывает данные ""SQL"

            analyticsService -> fileStore "Сохраняет сертификаты" 
            courseService -> fileStore "Сохраняет и читает материалы" 

            paymentService -> messageBroker "Публикует событие 'Курс оплачен'"
            analyticsService -> messageBroker "Публикует событие 'Курс закончен'"

            courseService -> messageBroker "Подписан на событие 'Курс оплачен'"
            mailService -> messageBroker "Подписан на события 'Курс закончен','Курс оплачен'"


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
            autoLayout tb
            title "C2: Диаграмма контейнеров"
        }
        styles {
            element "Database" {
            shape Cylinder
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "File Storage" {
                shape Folder
            }
            element "Message Broker" {
                shape Circle

      }
        }
        theme default
    }
    
}

