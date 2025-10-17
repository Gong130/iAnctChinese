"""
iAnctChinese 标注服务
"""

import uuid
from datetime import datetime

from app.schemas.annotation import Annotation, AnnotationCreate, AnnotationUpdate


class AnnotationService:
    """标注服务类"""

    def create_annotation(self, annotation_create: AnnotationCreate) -> Annotation:
        annotation_id = str(uuid.uuid4())
        now = datetime.now()
        return Annotation(
            id=annotation_id,
            text_id=annotation_create.text_id,
            start_pos=annotation_create.start_pos,
            end_pos=annotation_create.end_pos,
            content=annotation_create.content,
            type=annotation_create.type,
            tag=annotation_create.tag,
            created_at=now,
            updated_at=now,
        )

    def update_annotation(
        self, annotation_id: str, annotation_update: AnnotationUpdate
    ) -> Annotation:
        now = datetime.now()
        return Annotation(
            id=annotation_id,
            text_id=annotation_update.text_id,
            start_pos=annotation_update.start_pos,
            end_pos=annotation_update.end_pos,
            content=annotation_update.content,
            type=annotation_update.type,
            tag=annotation_update.tag,
            created_at=now,
            updated_at=now,
        )
