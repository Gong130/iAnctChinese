"""
iAnctChinese 分词服务
"""

import uuid
import jieba
from datetime import datetime
from typing import List
from app.schemas.segment import Segment, SegmentCreate, SegmentUpdate

class SegmentationService:
    """分词服务类"""
    
    def create_segmentation(self, segment_create: SegmentCreate) -> Segment:
        """
        创建分词结果
        
        Args:
            segment_create: 分词创建数据
            
        Returns:
            Segment: 创建的分词对象
        """
        # 生成唯一ID
        segment_id = str(uuid.uuid4())
        
        # 创建时间
        now = datetime.now()
        
        # 构造分词对象
        segment = Segment(
            id=segment_id,
            text_id=segment_create.text_id,
            segments=segment_create.segments,
            method=segment_create.method,
            confidence=segment_create.confidence,
            created_at=now
        )
        
        return segment
    
    def update_segmentation(self, segment_id: str, segment_update: SegmentUpdate) -> Segment:
        """
        更新分词结果
        
        Args:
            segment_id: 分词ID
            segment_update: 分词更新数据
            
        Returns:
            Segment: 更新的分词对象
        """
        # 获取当前时间
        now = datetime.now()
        
        # 构造更新后的分词对象（这里简化处理，实际应该从数据库获取原始数据）
        segment = Segment(
            id=segment_id,
            text_id=segment_update.text_id,
            segments=[],  # 在实际应用中应该从数据库获取
            method=segment_update.method,
            confidence=segment_update.confidence,
            created_at=now  # 在实际应用中应该从数据库获取
        )
        
        return segment

class RuleBasedSegmenter:
    """基于规则的分词器"""
    
    def segment(self, text: str) -> List[str]:
        """
        对文本进行分词处理
        
        Args:
            text: 待分词的文本
            
        Returns:
            分词结果列表
            
        Raises:
            ValueError: 当输入文本为空时抛出
        """
        if not text:
            raise ValueError("Text cannot be empty")
        
        print(f"[DEBUG] RuleBasedSegmenter processing text: {text}")
        
        # 简单的规则分词实现（示例）
        # 在实际应用中，这里会实现更复杂的分词逻辑
        segments = []
        i = 0
        while i < len(text):
            # 检查是否是常见的古汉语词汇
            if i + 1 < len(text):
                two_char = text[i:i+2]
                # 这里可以添加更多规则
                if two_char in ["孔子", "孟子", "老子", "庄子", "曰", "之乎", "者也", "也"]:
                    print(f"[DEBUG] Matched 2-char word: {two_char}")
                    segments.append(two_char)
                    i += 2
                    continue
            
            # 检查三字词
            if i + 2 < len(text):
                three_char = text[i:i+3]
                if three_char in ["孟子曰", "孔子曰", "诗云"]:
                    print(f"[DEBUG] Matched 3-char word: {three_char}")
                    segments.append(three_char)
                    i += 3
                    continue
                    
            # 单字分词
            print(f"[DEBUG] Adding single char: {text[i]}")
            segments.append(text[i])
            i += 1
        
        print(f"[DEBUG] RuleBasedSegmenter result: {segments}")
        return segments

class JiebaSegmenter:
    """基于jieba的分词器"""
    
    def segment(self, text: str) -> List[str]:
        """
        使用jieba对文本进行分词处理
        
        Args:
            text: 待分词的文本
            
        Returns:
            分词结果列表
            
        Raises:
            ValueError: 当输入文本为空时抛出
        """
        if not text:
            raise ValueError("Text cannot be empty")
        
        print(f"[DEBUG] JiebaSegmenter processing text: {text}")
        
        # 使用jieba进行分词
        segments = list(jieba.cut(text))
        print(f"[DEBUG] JiebaSegmenter raw result: {segments}")
        
        # 过滤空字符串
        segments = [segment for segment in segments if segment.strip()]
        print(f"[DEBUG] JiebaSegmenter filtered result: {segments}")
        
        return segments43