"""
iAnctChinese 文本服务
"""

import uuid
from datetime import datetime

from app.schemas.text import Text, TextCreate, TextUpdate


class TextService:
    """文本服务类"""

    def create_text(self, text_create: TextCreate) -> Text:
        text_id = str(uuid.uuid4())
        now = datetime.now()
        return Text(
            id=text_id,
            title=text_create.title,
            content=text_create.content,
            created_at=now,
            updated_at=now,
        )

    def update_text(self, text_id: str, text_update: TextUpdate) -> Text:
        now = datetime.now()
        return Text(
            id=text_id,
            title=text_update.title,
            content=text_update.content,
            created_at=now,
            updated_at=now,
        )
