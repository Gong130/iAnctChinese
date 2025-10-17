"""
iAnctChinese 标注管理 API
"""

from typing import List

from fastapi import APIRouter, HTTPException

from app.schemas.annotation import Annotation, AnnotationCreate, AnnotationUpdate
from app.services.annotation_service import AnnotationService

router = APIRouter()

annotations_db = {}
annotation_service = AnnotationService()


@router.post("/annotations/", response_model=Annotation)
async def create_annotation(annotation: AnnotationCreate):
    try:
        created_annotation = annotation_service.create_annotation(annotation)
        annotations_db[created_annotation.id] = created_annotation
        return created_annotation
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.get("/annotations/{text_id}", response_model=List[Annotation])
async def read_annotations(text_id: str):
    try:
        return [
            ann for ann in annotations_db.values() if ann.text_id == text_id
        ]
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.put("/annotations/{annotation_id}", response_model=Annotation)
async def update_annotation(annotation_id: str, annotation: AnnotationUpdate):
    try:
        if annotation_id not in annotations_db:
            raise HTTPException(status_code=404, detail="Annotation not found")
        updated_annotation = annotation_service.update_annotation(
            annotation_id, annotation
        )
        annotations_db[annotation_id] = updated_annotation
        return updated_annotation
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.delete("/annotations/{annotation_id}")
async def delete_annotation(annotation_id: str):
    try:
        if annotation_id not in annotations_db:
            raise HTTPException(status_code=404, detail="Annotation not found")
        del annotations_db[annotation_id]
        return {"message": "Annotation deleted successfully"}
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
