@echo off
REM Скрипт для сборки и тестирования RunPod образа (Windows)

echo 🚀 Сборка Docker образа для RunPod...

REM Сборка образа
docker build -t trivio-runpod-test .

if %errorlevel% equ 0 (
    echo ✅ Образ успешно собран!
    
    echo 🧪 Запуск тестового контейнера...
    
    REM Запуск в фоне
    docker run -d --name trivio-test -p 8000:8000 trivio-runpod-test
    
    REM Ждем запуска
    echo ⏳ Ожидание запуска контейнера...
    timeout /t 5 /nobreak > nul
    
    REM Проверяем статус
    docker ps | findstr trivio-test > nul
    if %errorlevel% equ 0 (
        echo ✅ Контейнер запущен!
        echo 📊 Логи контейнера:
        docker logs trivio-test
        
        echo.
        echo 🔍 Проверка health check...
        curl -s http://localhost:8000/health || echo ❌ Health check не работает
        
        echo.
        echo 🧹 Остановка тестового контейнера...
        docker stop trivio-test
        docker rm trivio-test
        
        echo ✅ Тест завершен! Образ готов для RunPod.
    ) else (
        echo ❌ Контейнер не запустился. Проверьте логи:
        docker logs trivio-test
        docker rm trivio-test
    )
) else (
    echo ❌ Ошибка сборки образа!
    exit /b 1
)
