"""
iAnctChinese 文本管理 API
"""

from typing import List

from fastapi import APIRouter, HTTPException

from app.schemas.text import Text, TextCreate, TextUpdate
from app.services.text_service import TextService

router = APIRouter()

texts_db = {}
text_service = TextService()


@router.post("/texts/", response_model=Text)
async def create_text(text: TextCreate):
    try:
        created_text = text_service.create_text(text)
        texts_db[created_text.id] = created_text
        return created_text
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.get("/texts/", response_model=List[Text])
async def read_texts(skip: int = 0, limit: int = 100):
    try:
        return list(texts_db.values())[skip : skip + limit]
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.get("/texts/{text_id}", response_model=Text)
async def read_text(text_id: str):
    try:
        if text_id not in texts_db:
            raise HTTPException(status_code=404, detail="Text not found")
        return texts_db[text_id]
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.put("/texts/{text_id}", response_model=Text)
async def update_text(text_id: str, text: TextUpdate):
    try:
        if text_id not in texts_db:
            raise HTTPException(status_code=404, detail="Text not found")
        updated_text = text_service.update_text(text_id, text)
        texts_db[text_id] = updated_text
        return updated_text
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.delete("/texts/{text_id}")
async def delete_text(text_id: str):
    try:
        if text_id not in texts_db:
            raise HTTPException(status_code=404, detail="Text not found")
        del texts_db[text_id]
        return {"message": "Text deleted successfully"}
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
