"""
iAnctChinese 分词数据 Schema
"""

from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel


class SegmentBase(BaseModel):
    text_id: str
    text: Optional[str] = None
    method: str
    confidence: float


class SegmentCreate(SegmentBase):
    segments: List[str]


class SegmentUpdate(SegmentBase):
    segments: Optional[List[str]] = None


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
