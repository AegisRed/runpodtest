# RunPod Deployment Guide

## 🐳 Docker Build для RunPod

### Локальная сборка (для тестирования)
```bash
cd trivio_ai/app/deploy
docker build -t trivio-runpod-test .
```

### Запуск локально (для проверки)
```bash
docker run -p 8000:8000 trivio-runpod-test
```

## 🚀 Деплой на RunPod

### Вариант 1: Через RunPod UI
1. Зайдите в RunPod Dashboard
2. Создайте новый Template
3. Выберите "Custom Docker Image"
4. Загрузите собранный образ или используйте Dockerfile

### Вариант 2: Через RunPod API
```bash
# Соберите образ
docker build -t your-registry/trivio-runpod:latest .

# Загрузите в RunPod Registry
docker tag trivio-runpod:latest runpod/trivio-runpod:latest
docker push runpod/trivio-runpod:latest
```

### Вариант 3: Прямая загрузка кода
1. Создайте Template в RunPod UI
2. Выберите базовый образ (например, `python:3.10-slim`)
3. В настройках Template добавьте:
   - **Dockerfile**: содержимое из `Dockerfile`
   - **Start Command**: `python runpod.py`
   - **Port**: 8000 (если нужен)

## 🔧 Настройка Environment Variables

В RunPod Template добавьте:
```
RUNPOD_SERVERLESS=true
PYTHONUNBUFFERED=1
```

## 📊 Проверка работы

После деплоя проверьте:
1. **Логи пода** - должны показать запуск handler
2. **Локальный тест** - запустите `python test_runpod.py`
3. **Health check** - `curl http://localhost:8000/health`

## 🎯 Что происходит в контейнере

1. Устанавливается Python 3.10
2. Устанавливаются только `runpod` и `httpx`
3. Копируется `runpod.py`
4. Запускается `python runpod.py`
5. Handler ждет запросы от Trivio AI

## 📝 Размер образа

Минимальный образ ~150MB (вместо полного приложения ~1GB+)

## 🔄 Обновление

При изменении `runpod.py`:
1. Пересоберите образ
2. Обновите Template в RunPod
3. Перезапустите Endpoint
