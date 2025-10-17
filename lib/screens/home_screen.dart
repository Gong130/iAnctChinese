import 'package:flutter/material.dart';
import 'auto_segment_screen.dart';
import 'manual_annotation_screen.dart';
import 'knowledge_graph_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iAnctChinese 古汉语大模型自动标注平台'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF5F5DC),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF8B0000),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'iAnctChinese',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '古汉语大模型自动标注平台',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFF8B0000)),
                title: const Text('首页'),
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_format, color: Color(0xFF8B0000)),
                title: const Text('自动分词'),
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF006400)),
                title: const Text('手动标注'),
                selected: _selectedIndex == 2,
                onTap: () {
                  setState(() => _selectedIndex = 2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_tree, color: Color(0xFFDAA520)),
                title: const Text('知识图谱'),
                selected: _selectedIndex == 3,
                onTap: () {
                  setState(() => _selectedIndex = 3);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeContent(),
          AutoSegmentScreen(),
          ManualAnnotationScreen(),
          KnowledgeGraphScreen(),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '欢迎使用 iAnctChinese 古汉语大模型自动标注平台',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '本平台提供以下核心功能：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),
            Text(
              '• 自动分词：基于规则、jieba 和大模型的智能分词\n'
              '• 手动标注：可视化标注界面，支持多种标注类型\n'
              '• 知识图谱：实体关系抽取和图谱可视化展示',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.5,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '使用指南：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),
            Text(
              '1. 选择左侧导航栏的“自动分词”功能\n'
              '2. 输入古汉语文本并选择分词方法\n'
              '3. 查看分词结果并进行手动调整\n'
              '4. 使用“导入到手动标注”功能将分词结果导入\n'
              '5. 在手动标注界面进行详细标注\n'
              '6. 导出标注结果用于后续分析',
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                letterSpacing: 0.5,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '技术特点：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 15),
            Text(
              '• 多种分词算法：规则、jieba 和大模型分词\n'
              '• 可视化标注界面：直观易用的手动标注工具\n'
              '• 灵活的标注类型：支持词性标注和命名实体识别\n'
              '• 结果导出功能：支持 JSON 格式导出标注结果\n'
              '• 知识图谱构建：实体关系抽取和图谱可视化',
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
