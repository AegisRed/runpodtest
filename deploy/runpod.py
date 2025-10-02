import runpod
import json
import os
from typing import Dict, Any, List

def handler(event: Dict[str, Any]) -> Dict[str, Any]:
    """
    RunPod Serverless Handler для Trivio AI
    
    Ожидаемый input:
    {
        "messages": [{"role": "user", "content": "..."}],
        "temperature": 0.7,
        "max_tokens": 1000,
        "model": "gpt-3.5-turbo"
    }
    
    Возвращает:
    {
        "choices": [{"message": {"content": "ответ модели"}}]
    }
    """
    
    try:
        # Извлекаем параметры из event
        input_data = event.get("input", {})
        messages = input_data.get("messages", [])
        temperature = input_data.get("temperature", 0.7)
        max_tokens = input_data.get("max_tokens", 1000)
        model = input_data.get("model", "gpt-3.5-turbo")
        
        print(f"🤖 RunPod Handler получил запрос:")
        print(f"   Model: {model}")
        print(f"   Temperature: {temperature}")
        print(f"   Max tokens: {max_tokens}")
        print(f"   Messages: {len(messages)} сообщений")
        
        # Пока что возвращаем заглушку, так как модель не установлена
        if not messages:
            return {
                "error": "No messages provided",
                "choices": []
            }
        
        # Простая заглушка для тестирования
        last_message = messages[-1].get("content", "") if messages else ""
        
        # Имитируем ответ модели
        response_text = f"RunPod Handler получил: '{last_message[:50]}...' (заглушка - модель не установлена)"
        
        # Возвращаем в формате OpenAI API
        result = {
            "choices": [
                {
                    "message": {
                        "role": "assistant",
                        "content": response_text
                    }
                }
            ],
            "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 20,
                "total_tokens": 30
            },
            "model": model,
            "runpod_status": "handler_working_but_no_model"
        }
        
        print(f"✅ RunPod Handler вернул ответ: {response_text[:100]}...")
        return result
        
    except Exception as e:
        error_msg = f"RunPod Handler error: {str(e)}"
        print(f"❌ {error_msg}")
        return {
            "error": error_msg,
            "choices": []
        }

# Запуск RunPod сервера
if __name__ == "__main__":
    print("🚀 Запуск RunPod Serverless Handler...")
    print("📝 Ожидайте запросы от Trivio AI...")
    runpod.serverless.start({"handler": handler})
