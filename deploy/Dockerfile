# Минимальный Dockerfile для RunPod тестирования
FROM python:3.10-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
WORKDIR /app

# Копируем только необходимые файлы для тестирования
COPY requirements.txt .
COPY runpod.py .

# Устанавливаем только минимальные зависимости для RunPod
RUN pip install --no-cache-dir \
    runpod==1.0.0 \
    httpx==0.24.1

# Создаем простой requirements.txt для RunPod
RUN echo "runpod==1.0.0" > runpod_requirements.txt && \
    echo "httpx==0.24.1" >> runpod_requirements.txt

# Устанавливаем переменные окружения
ENV PYTHONUNBUFFERED=1
ENV RUNPOD_SERVERLESS=true

# Открываем порт (если нужен)
EXPOSE 8000

# Команда запуска
CMD ["python", "runpod.py"]
