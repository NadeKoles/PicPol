# 📱 PicPol — iOS Photo Editor App

PicPol — мобильный фоторедактор, выполненный в архитектуре MVVM. Это тестовое приложение реализует базовые функции редактирования изображений с удобным интерфейсом.

---

## 🚀 Возможности
- 🔐 Регистрация и вход с помощью Email и Google
- 🖼 Загрузка и отображение изображений
- 🔄 Вращение, масштабирование и перемещение
- 🎨 Применение набора фильтров с использованием Core Image (CIFilter)
- ✏️ Рисование поверх изображения с поддержкой Undo/Redo (PencilKit)
- 🔤 Добавление текста поверх изображения
- 💾 Сохранение изображения в фотоплёнку

---

## ⚙️ Как запустить
1. Убедитесь, что у вас установлен Xcode 15+
2. Клонируйте репозиторий:
```bash
git clone https://github.com/NadeKoles/picpol.git
```
3. Откройте файл `PicPol.xcodeproj`
4. Запустите проект на симуляторе или устройстве

> ⚠️ Firebase уже настроен. Для корректной работы аутентификации (email/пароль и Google Sign-In) в проект включён GoogleService-Info.plist.
Если вы клонируете проект и тестируете на своём аккаунте Firebase — замените этот файл своим.

---

## 🔐 Аутентификация
- Вход через Email/Password
- Регистрация с проверкой email
- Вход через Google (GIDSignIn)
- Сброс пароля через email

Все реализовано через `AuthViewModel`, с валидацией email и пароля.

---

## 📚 Архитектура
- MVVM
- Разделение логики редактирования, рисования, текста и аутентификации

### Основные компоненты:
- `PhotoEditorViewModel` — управление изображением и трансформациями
- `DrawingViewModel` — логика рисования и история действий
- `TextOverlayViewModel` — текстовое наложение
- `FilterViewModel` — CIFilter-фильтрация
- `AuthViewModel` — авторизация и регистрация

---

## ✅ Протестировано
- Вход/регистрация и сброс пароля
- Загрузка и отображение изображений
- Все режимы редактирования: фильтры, текст, рисование
- Undo/Redo в трансформациях и рисовании
- Сохранение и возврат к состоянию после фильтров

---

## 🧑🏻 Автор
Проект выполнен как тестовое задание iOS-разработчиком [Nadia K].

---

## 📌 Примечания
- Приложение работает полностью оффлайн, кроме аутентификации
- Интерфейс адаптирован под экран без лишнего скролла/оверлеев
- Код структурирован, логика разбита на модули, компоненты переиспользуемы

Спасибо за просмотр 🙌
