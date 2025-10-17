"""
iAnctChinese 分词数据模型
"""

from datetime import datetime
from typing import List

from pydantic import BaseModel


class SegmentBase(BaseModel):
    text_id: str
    method: str
    confidence: float


class SegmentCreate(SegmentBase):
    segments: List[str]


class SegmentUpdate(SegmentBase):
    pass


class SegmentInDBBase(SegmentBase):
    id: str
    segments: List[str]
    created_at: datetime

    class Config:
        orm_mode = True


class Segment(SegmentInDBBase):
    pass


class SegmentInDB(SegmentInDBBase):
    pass
