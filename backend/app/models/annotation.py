"""
iAnctChinese 标注数据模型
"""

from datetime import datetime

from pydantic import BaseModel


class AnnotationBase(BaseModel):
    text_id: str
    start_pos: int
    end_pos: int
    content: str
    type: str
    tag: str


class AnnotationCreate(AnnotationBase):
    pass


class AnnotationUpdate(AnnotationBase):
    pass


class AnnotationInDBBase(AnnotationBase):
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


class Annotation(AnnotationInDBBase):
    pass


class AnnotationInDB(AnnotationInDBBase):
    pass
