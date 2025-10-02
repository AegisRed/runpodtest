#!/bin/bash

# Скрипт для сборки и тестирования RunPod образа

echo "🚀 Сборка Docker образа для RunPod..."

# Сборка образа
docker build -t trivio-runpod-test .

if [ $? -eq 0 ]; then
    echo "✅ Образ успешно собран!"
    
    echo "🧪 Запуск тестового контейнера..."
    
    # Запуск в фоне
    docker run -d --name trivio-test -p 8000:8000 trivio-runpod-test
    
    # Ждем запуска
    echo "⏳ Ожидание запуска контейнера..."
    sleep 5
    
    # Проверяем статус
    if docker ps | grep -q trivio-test; then
        echo "✅ Контейнер запущен!"
        echo "📊 Логи контейнера:"
        docker logs trivio-test
        
        echo ""
        echo "🔍 Проверка health check..."
        curl -s http://localhost:8000/health || echo "❌ Health check не работает"
        
        echo ""
        echo "🧹 Остановка тестового контейнера..."
        docker stop trivio-test
        docker rm trivio-test
        
        echo "✅ Тест завершен! Образ готов для RunPod."
    else
        echo "❌ Контейнер не запустился. Проверьте логи:"
        docker logs trivio-test
        docker rm trivio-test
    fi
else
    echo "❌ Ошибка сборки образа!"
    exit 1
fi
