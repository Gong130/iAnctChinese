"""
iAnctChinese 文本数据模型
"""

from datetime import datetime

from pydantic import BaseModel


class TextBase(BaseModel):
    title: str
    content: str


class TextCreate(TextBase):
    pass


class TextUpdate(TextBase):
    pass


class TextInDBBase(TextBase):
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


class Text(TextInDBBase):
    pass


class TextInDB(TextInDBBase):
    pass
