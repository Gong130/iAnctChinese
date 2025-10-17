import 'package:flutter/material.dart';

class KnowledgeGraphScreen extends StatefulWidget {
  const KnowledgeGraphScreen({super.key});

  @override
  State<KnowledgeGraphScreen> createState() => _KnowledgeGraphScreenState();
}

class _KnowledgeGraphScreenState extends State<KnowledgeGraphScreen> {
  bool _isGraphVisible = false;

  void _generateKnowledgeGraph() {
    setState(() => _isGraphVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '知识图谱',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '实体关系抽取：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _generateKnowledgeGraph,
              child: const Text('生成知识图谱'),
            ),
            const SizedBox(height: 20),
            const Text(
              '知识图谱可视化：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: _isGraphVisible
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_tree,
                          size: 100,
                          color: Color(0xFF006400),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '知识图谱可视化展示',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• 实体关系抽取\n'
                          '• 知识图谱构建\n'
                          '• 图谱可视化展示',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        '点击“生成知识图谱”按钮查看可视化结果',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.5,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              '功能说明：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• 实体关系抽取\n'
              '• 知识图谱构建\n'
              '• 图谱可视化展示',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.5,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
