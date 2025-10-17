"""
iAnctChinese 分词服务
"""

import logging
import os
import threading
import uuid
from datetime import datetime
from pathlib import Path
from typing import List, Optional

import jieba

from app.schemas.segment import Segment, SegmentCreate, SegmentUpdate

logger = logging.getLogger(__name__)


class SegmentationService:
    """分词服务类"""

    def create_segmentation(self, segment_create: SegmentCreate) -> Segment:
        segment_id = str(uuid.uuid4())
        now = datetime.now()
        return Segment(
            id=segment_id,
            text_id=segment_create.text_id,
            segments=segment_create.segments,
            method=segment_create.method,
            confidence=segment_create.confidence,
            created_at=now,
        )

    def update_segmentation(
        self, segment_id: str, segment_update: SegmentUpdate
    ) -> Segment:
        now = datetime.now()
        return Segment(
            id=segment_id,
            text_id=segment_update.text_id,
            segments=[],
            method=segment_update.method,
            confidence=segment_update.confidence,
            created_at=now,
        )


class RuleBasedSegmenter:
    """基于规则的分词器"""

    def segment(self, text: str) -> List[str]:
        if not text:
            raise ValueError("Text cannot be empty")

        segments: List[str] = []
        i = 0
        while i < len(text):
            if i + 1 < len(text):
                two_char = text[i : i + 2]
                if two_char in {"孔子", "孟子", "老子", "庄子", "之乎", "者也"}:
                    segments.append(two_char)
                    i += 2
                    continue

            if i + 2 < len(text):
                three_char = text[i : i + 3]
                if three_char in {"孟子曰", "孔子曰", "诗云"}:
                    segments.append(three_char)
                    i += 3
                    continue

            segments.append(text[i])
            i += 1

        return segments


class JiebaSegmenter:
    """基于 jieba 的分词器"""

    def segment(self, text: str) -> List[str]:
        if not text:
            raise ValueError("Text cannot be empty")

        segments = list(jieba.cut(text))
        return [segment for segment in segments if segment.strip()]


class QwenSegmenter:
    """基于 Qwen 模型的分词器"""

    def __init__(
        self,
        model_path: Optional[str] = None,
        max_new_tokens: int = 256,
        temperature: float = 0.7,
    ) -> None:
        self._lock = threading.Lock()
        self._pipeline = None
        self.max_new_tokens = max_new_tokens
        self.temperature = temperature
        backend_root = Path(__file__).resolve().parents[2]
        default_path = backend_root / "model" / "qwen3-0.6b"
        self.model_path = Path(
            model_path or os.getenv("QWEN_MODEL_PATH", str(default_path))
        )
        self.device = os.getenv("QWEN_DEVICE", "auto")

    def _ensure_pipeline(self):
        if self._pipeline is not None:
            return self._pipeline

        with self._lock:
            if self._pipeline is not None:
                return self._pipeline

            try:
                from transformers import (
                    AutoModelForCausalLM,
                    AutoTokenizer,
                    pipeline,
                )
            except ImportError as exc:  # pragma: no cover
                raise RuntimeError(
                    "QwenSegmenter 需要 transformers，请先安装：pip install transformers accelerate sentencepiece"
                ) from exc

            if not self.model_path.exists():
                raise FileNotFoundError(f"未找到 Qwen 模型目录：{self.model_path}")

            torch_dtype = None
            device_idx = -1

            try:
                import torch
            except ImportError:  # pragma: no cover
                torch = None  # type: ignore

            if self.device == "cuda" and torch and torch.cuda.is_available():
                device_idx = 0
                torch_dtype = torch.float16
            elif self.device == "auto" and torch and torch.cuda.is_available():
                device_idx = 0
                torch_dtype = torch.float16
            else:
                device_idx = -1
                if torch:
                    torch_dtype = torch.float32

            tokenizer = AutoTokenizer.from_pretrained(
                self.model_path,
                trust_remote_code=True,
            )
            model = AutoModelForCausalLM.from_pretrained(
                self.model_path,
                trust_remote_code=True,
                torch_dtype=torch_dtype,
            )

            if device_idx == 0 and torch:
                model.to("cuda")

            self._pipeline = pipeline(
                "text-generation",
                model=model,
                tokenizer=tokenizer,
                device=device_idx,
                trust_remote_code=True,
            )
            return self._pipeline

    def segment(self, text: str) -> List[str]:
        if not text:
            raise ValueError("Text cannot be empty")

        generator = self._ensure_pipeline()
        prompt = (
            "你是一名古汉语分词助手。请将以下古文进行分词，"
            "只输出使用竖线(|)分隔的结果，不要添加其他说明。\n古文："
            f"{text}\n分词："
        )

        outputs = generator(
            prompt,
            max_new_tokens=self.max_new_tokens,
            do_sample=False,
            temperature=self.temperature,
            top_p=0.9,
            repetition_penalty=1.05,
            return_full_text=False,
        )

        generated = outputs[0]["generated_text"].strip() if outputs else ""
        first_line = generated.splitlines()[0] if generated else ""
        normalized = (
            first_line.replace("、", "|")
            .replace("/", "|")
            .replace(" ", "|")
            .replace("，", "|")
            .replace("。", "|")
        )
        segments = [word.strip() for word in normalized.split("|") if word.strip()]

        if not segments:
            logger.warning("QwenSegmenter 未能解析有效的分词结果，回退至按字切分。")
            segments = list(text)

        return segments


_qwen_segmenter: Optional[QwenSegmenter] = None


def get_qwen_segmenter() -> QwenSegmenter:
    global _qwen_segmenter
    if _qwen_segmenter is None:
        _qwen_segmenter = QwenSegmenter()
    return _qwen_segmenter
