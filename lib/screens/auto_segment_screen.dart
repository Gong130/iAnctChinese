import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'manual_annotation_screen.dart';

class AutoSegmentScreen extends StatefulWidget {
  const AutoSegmentScreen({super.key});

  @override
  State<AutoSegmentScreen> createState() => _AutoSegmentScreenState();
}

class _AutoSegmentScreenState extends State<AutoSegmentScreen> {
  String _selectedMethod = 'rule';
  final TextEditingController _textController = TextEditingController();
  List<String> _segmentResult = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _performSegmentation() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入需要分词的文本')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String methodToSend;
      if (_selectedMethod == 'model') {
        methodToSend = 'model';
      } else {
        methodToSend = _selectedMethod;
      }

      final result = await ApiService.autoSegmentation(
        textId: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _textController.text,
        method: methodToSend,
      );

      if (result != null && result['segments'] != null) {
        setState(() {
          _segmentResult = List<String>.from(result['segments']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _segmentResult = ['分词失败，请重试'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _segmentResult = ['发生错误: $e'];
        _isLoading = false;
      });
    }
  }

  void _importToManualAnnotation() {
    if (_segmentResult.isEmpty ||
        _segmentResult.contains('分词失败') ||
        _segmentResult.any((item) => item.startsWith('发生错误'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先成功执行分词')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ManualAnnotationScreen(autoSegmentResult: _segmentResult),
      ),
    );
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
              '自动分词',
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
              '分词方法：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('基于规则的分词'),
                    leading: Radio<String>(
                      value: 'rule',
                      groupValue: _selectedMethod,
                      onChanged: (value) =>
                          setState(() => _selectedMethod = value!),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('基于 jieba 的分词'),
                    leading: Radio<String>(
                      value: 'jieba',
                      groupValue: _selectedMethod,
                      onChanged: (value) =>
                          setState(() => _selectedMethod = value!),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('基于大模型的智能分词'),
                    leading: Radio<String>(
                      value: 'model',
                      groupValue: _selectedMethod,
                      onChanged: (value) =>
                          setState(() => _selectedMethod = value!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '输入文本：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '请输入要分词的文本',
                labelStyle: TextStyle(color: Color(0xFF666666)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF006400)),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.5,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _performSegmentation,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('执行分词'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _importToManualAnnotation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                  ),
                  child: const Text('导入到手动标注'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '分词结果：',
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF006400),
                          ),
                        ),
                      ),
                    )
                  : _segmentResult.isEmpty
                      ? const Text(
                          '分词结果将显示在这里',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            letterSpacing: 0.5,
                            color: Color(0xFF666666),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Text(
                                _segmentResult.join('|'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _segmentResult.map((word) {
                                return Chip(
                                  label: Text(word),
                                  backgroundColor: const Color(0xFFDAA520),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
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
              '• 基于规则的分词：使用预定义规则进行分词\n'
              '• 基于 jieba 的分词：使用 jieba 分词库进行分词\n'
              '• 基于大模型的智能分词：使用大语言模型进行智能分词\n'
              '• 分词结果置信度评估：在后端返回置信度信息',
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
