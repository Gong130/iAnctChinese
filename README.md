# iAnctChinese 古汉语大模型自动标注平台

iAnctChinese 是一个集成 Flutter 前端与 FastAPI 后端的古汉语文本标注平台，提供自动分词、手动标注以及知识图谱展示等能力。项目已接入 Qwen3-0.6B 大语言模型，用于增强分词效果。

## 目录结构

```
.
├── lib/                 # Flutter 前端代码
│   ├── main.dart        # 应用入口
│   ├── models/          # 前端数据模型
│   ├── screens/         # 各业务页面
│   └── services/        # API 调用封装
├── backend/             # FastAPI 后端
│   ├── app/             # 后端源码
│   ├── model/           # Qwen 模型权重默认位置
│   └── tests/           # 测试用例占位（待完善）
├── pubspec.yaml         # Flutter 依赖清单
└── README.md
```

## 运行说明
自行下载模型放入该路径，例如qwen3-0.6b
backend\model\qwen3-0.6b
### 后端
```powershell
cd D:\JIEDUI\backend
python -m uvicorn app.main:app --reload
```

### 前端
```powershell
cd D:\JIEDUI
flutter pub get
flutter run -d windows
```

## 功能概览
- **自动分词**：支持规则分词、jieba 分词以及基于 Qwen3-0.6B 的大模型分词。
- **手动标注**：支持对分词结果进行词性、实体以及自定义标签标注，并导出 JSON。
- **知识图谱**：提供知识图谱生成的界面占位，后续可扩展调用真实服务。

## 后续工作
- [ ] 完善状态管理与公共组件
- [ ] 结合真实数据库替换当前的内存存储
- [ ] 丰富自动化测试用例
- [ ] 接入真实的知识图谱推理服务
