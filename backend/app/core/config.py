"""
iAnctChinese 配置管理模块
"""

import os
from typing import List


class Settings:
    PROJECT_NAME: str = "iAnctChinese"
    PROJECT_VERSION: str = "1.0.0"
    PROJECT_DESCRIPTION: str = "基于大语言模型的古汉语自动标注平台"

    MONGODB_URL: str = os.getenv(
        "MONGODB_URL", "mongodb://localhost:27017/iAnctChinese"
    )
    NEO4J_URL: str = os.getenv("NEO4J_URL", "bolt://localhost:7687")
    NEO4J_USERNAME: str = os.getenv("NEO4J_USERNAME", "neo4j")
    NEO4J_PASSWORD: str = os.getenv("NEO4J_PASSWORD", "password")

    OLLAMA_BASE_URL: str = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")

    API_V1_STR: str = "/api/v1"

    BACKEND_CORS_ORIGINS: List[str] = [
        "http://localhost",
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:8080",
    ]


settings = Settings()
