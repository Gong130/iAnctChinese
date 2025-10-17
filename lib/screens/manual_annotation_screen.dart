import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ManualAnnotationScreen extends StatefulWidget {
  final List<String>? autoSegmentResult;

  const ManualAnnotationScreen({super.key, this.autoSegmentResult});

  @override
  State<ManualAnnotationScreen> createState() => _ManualAnnotationScreenState();
}

class _ManualAnnotationScreenState extends State<ManualAnnotationScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _annotations = [];
  int _selectedStart = -1;
  int _selectedEnd = -1;
  String _customTag = '';
  String _selectedText = '';

  @override
  void initState() {
    super.initState();
    if (widget.autoSegmentResult != null &&
        widget.autoSegmentResult!.isNotEmpty) {
      _initializeWithAutoSegmentResult();
    }
    _textController.addListener(_onTextChanged);
  }

  void _initializeWithAutoSegmentResult() {
    final segmentedText = widget.autoSegmentResult!.join('    ');
    _textController.text = segmentedText;
  }

  void _onTextChanged() {
    final selection = _textController.selection;
    if (selection.isValid && selection.start != selection.end) {
      final selectedText =
          _textController.text.substring(selection.start, selection.end);
      if (mounted) {
        setState(() {
          _selectedStart = selection.start;
          _selectedEnd = selection.end;
          _selectedText = selectedText;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedStart = -1;
          _selectedEnd = -1;
          _selectedText = '';
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _addAnnotation(String type, String tag) {
    if (_selectedStart >= 0 && _selectedEnd > _selectedStart) {
      setState(() {
        _annotations.add({
          'start': _selectedStart,
          'end': _selectedEnd,
          'content': _selectedText,
          'type': type,
          'tag': tag,
        });
        _selectedStart = -1;
        _selectedEnd = -1;
        _selectedText = '';
        _textController.selection = const TextSelection.collapsed(offset: -1);
      });
    }
  }

  void _addCustomAnnotation() {
    if (_selectedStart >= 0 &&
        _selectedEnd > _selectedStart &&
        _customTag.isNotEmpty) {
      setState(() {
        _annotations.add({
          'start': _selectedStart,
          'end': _selectedEnd,
          'content': _selectedText,
          'type': 'Custom',
          'tag': _customTag,
        });
        _selectedStart = -1;
        _selectedEnd = -1;
        _selectedText = '';
        _customTag = '';
        _textController.selection = const TextSelection.collapsed(offset: -1);
      });
    }
  }

  void _removeAnnotation(int index) {
    setState(() => _annotations.removeAt(index));
  }

  Future<void> _exportAnnotations() async {
    if (_annotations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有标注结果可导出')),
      );
      return;
    }

    try {
      final exportData = {
        'text': _textController.text,
        'annotations': _annotations,
        'exportTime': DateTime.now().toIso8601String(),
      };
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: '请选择保存位置',
        fileName: 'annotations_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (savePath == null) {
        return;
      }

      final file = File(savePath);
      await file.writeAsString(jsonString);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('标注结果已导出到: $savePath')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e')),
      );
    }
  }

  Future<void> _exportToAppDir() async {
    if (_annotations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有标注结果可导出')),
      );
      return;
    }

    try {
      final exportData = {
        'text': _textController.text,
        'annotations': _annotations,
        'exportTime': DateTime.now().toIso8601String(),
      };
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/annotations_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonString);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('标注结果已导出到: ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autoSegmentResult != null &&
        widget.autoSegmentResult!.isNotEmpty &&
        _textController.text.isEmpty) {
      _initializeWithAutoSegmentResult();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '手动标注',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '待标注文本：',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    letterSpacing: 1.0,
                    color: Color(0xFF333333),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _exportAnnotations,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0000),
                      ),
                      child: const Text('导出 JSON'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _exportToAppDir,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006400),
                      ),
                      child: const Text('导出到应用目录'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 5,
              enableInteractiveSelection: true,
              decoration: const InputDecoration(
                labelText: '请输入要标注的文本',
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
            const SizedBox(height: 10),
            if (_selectedText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前选中的文本：',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '[$_selectedText]',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '字符数：${_selectedText.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              '预定义标签：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.0,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _addAnnotation('POS', '名词'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  child: const Text('名词'),
                ),
                ElevatedButton(
                  onPressed: () => _addAnnotation('POS', '动词'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  child: const Text('动词'),
                ),
                ElevatedButton(
                  onPressed: () => _addAnnotation('POS', '形容词'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  child: const Text('形容词'),
                ),
                ElevatedButton(
                  onPressed: () => _addAnnotation('NER', '人物'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                  ),
                  child: const Text('人物'),
                ),
                ElevatedButton(
                  onPressed: () => _addAnnotation('NER', '地点'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                  ),
                  child: const Text('地点'),
                ),
                ElevatedButton(
                  onPressed: () => _addAnnotation('NER', '时间'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                  ),
                  child: const Text('时间'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '自定义标签：',
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
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '输入自定义标签',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _customTag = value),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addCustomAnnotation,
                  child: const Text('添加'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '标注结果：',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    letterSpacing: 1.0,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  '总计: ${_annotations.length} 条',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: _annotations.isEmpty
                  ? const Center(
                      child: Text(
                        '标注结果将显示在这里',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.5,
                          color: Color(0xFF666666),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _annotations.length,
                      itemBuilder: (context, index) {
                        final annotation = _annotations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 2,
                          color: const Color(0xFFFFF8DC),
                          child: ListTile(
                            title: Text('${annotation['content']}'),
                            subtitle: Text(
                              '${annotation['type']}: ${annotation['tag']} '
                              '(${annotation['start']} - ${annotation['end']})',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFFF4500),
                              ),
                              onPressed: () => _removeAnnotation(index),
                            ),
                          ),
                        );
                      },
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
              '• 选择文本：在文本框中点击并拖拽选择要标注的文本\n'
              '• 添加标注：选择预定义标签或输入自定义标签\n'
              '• 导出结果：将标注结果导出为 JSON 格式文件',
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
