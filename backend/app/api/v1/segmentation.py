"""
iAnctChinese 自动分词 API
"""

from typing import List

from fastapi import APIRouter, Body, HTTPException, Query

from app.schemas.segment import Segment, SegmentCreate, SegmentUpdate
from app.services.segmentation_service import (
    SegmentationService,
    RuleBasedSegmenter,
    JiebaSegmenter,
    get_qwen_segmenter,
)

router = APIRouter()

# 模拟数据库存储
segments_db = {}
segmentation_service = SegmentationService()

# 初始化分词器
rule_based_segmenter = RuleBasedSegmenter()
jieba_segmenter = JiebaSegmenter()


@router.post("/segmentation/", response_model=Segment)
async def create_segmentation(segment: SegmentCreate):
    """
    执行自动分词
    """
    try:
        # 根据方法选择分词器
        if segment.method == "rule_based":
            segment.segments = rule_based_segmenter.segment(segment.text)
        elif segment.method == "jieba":
            segment.segments = jieba_segmenter.segment(segment.text)
        elif segment.method in {"model", "qwen"}:
            segment.segments = get_qwen_segmenter().segment(segment.text)
            segment.method = "model"
            segment.confidence = 0.9
        elif not segment.segments:
            # 如果没有指定方法且未提供分词结果，默认使用 jieba
            segment.segments = jieba_segmenter.segment(segment.text)

        created_segment = segmentation_service.create_segmentation(segment)
        segments_db[created_segment.id] = created_segment
        return created_segment
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.get("/segmentation/{text_id}", response_model=List[Segment])
async def read_segmentation(text_id: str):
    """
    获取指定文本的分词结果
    """
    try:
        return [seg for seg in segments_db.values() if seg.text_id == text_id]
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.put("/segmentation/{segment_id}", response_model=Segment)
async def update_segmentation(segment_id: str, segment: SegmentUpdate):
    """
    更新分词结果
    """
    try:
        if segment_id not in segments_db:
            raise HTTPException(status_code=404, detail="Segmentation not found")
        updated_segment = segmentation_service.update_segmentation(segment_id, segment)
        segments_db[segment_id] = updated_segment
        return updated_segment
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/segmentation/auto/{text_id}", response_model=Segment)
async def auto_segmentation(
    text_id: str,
    text: str = Body(..., media_type="text/plain"),
    method: str = Query(
        "jieba",
        description="分词方法，可选值: rule_based、jieba、model",
    ),
):
    """
    自动分词接口
    """
    try:
        print(f"[DEBUG] Auto segmentation requested with method: {method}")

        if method in {"rule_based", "rule"}:
            print("[DEBUG] Using RuleBasedSegmenter")
            segments = rule_based_segmenter.segment(text)
            method = "rule_based"
            confidence = 0.8
        elif method == "jieba":
            print("[DEBUG] Using JiebaSegmenter")
            segments = jieba_segmenter.segment(text)
            confidence = 0.95
        elif method in {"model", "qwen"}:
            print("[DEBUG] Using QwenSegmenter")
            segments = get_qwen_segmenter().segment(text)
            method = "model"
            confidence = 0.9
        else:
            print("[DEBUG] Using default JiebaSegmenter")
            segments = jieba_segmenter.segment(text)
            method = "jieba"
            confidence = 0.95

        segment_create = SegmentCreate(
            text_id=text_id,
            text=text,
            segments=segments,
            method=method,
            confidence=confidence,
        )

        created_segment = segmentation_service.create_segmentation(segment_create)
        segments_db[created_segment.id] = created_segment
        return created_segment
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
