"""
iAnctChinese 后端应用入口文件
基于 FastAPI 框架实现
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1 import annotation, segmentation, text

app = FastAPI(
    title="iAnctChinese API",
    description="基于大语言模型的古汉语自动标注平台 API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(text.router, prefix="/api/v1", tags=["text"])
app.include_router(segmentation.router, prefix="/api/v1", tags=["segmentation"])
app.include_router(annotation.router, prefix="/api/v1", tags=["annotation"])


@app.get("/")
async def root():
    return {"message": "Welcome to iAnctChinese API"}


@app.get("/health")
async def health_check():
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
