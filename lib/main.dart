import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const InsightEditorApp());

class InsightEditorApp extends StatelessWidget {
  const InsightEditorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insight Editor',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const EditorPage(),
    );
  }
}

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});
  @override State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final url = TextEditingController();
  final views = TextEditingController(text: '4582');
  final viewers = TextEditingController(text: '4429');
  final shares = TextEditingController(text: '20');
  final comments = TextEditingController(text: '2');
  final likes = TextEditingController(text: '32');
  bool saved = false;

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('draft');
    if (raw == null) return;
    final d = jsonDecode(raw) as Map<String, dynamic>;
    setState(() {
      url.text = d['url'] ?? '';
      views.text = d['views'] ?? '4582'; viewers.text = d['viewers'] ?? '4429';
      shares.text = d['shares'] ?? '20'; comments.text = d['comments'] ?? '2'; likes.text = d['likes'] ?? '32';
      saved = true;
    });
  }
  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('draft', jsonEncode({'url':url.text,'views':views.text,'viewers':viewers.text,'shares':shares.text,'comments':comments.text,'likes':likes.text}));
    setState(() => saved = true);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved')));
  }
  @override void dispose() { for (final c in [url,views,viewers,shares,comments,likes]) c.dispose(); super.dispose(); }

  Widget field(String label, TextEditingController c) => TextField(controller:c, keyboardType: TextInputType.number, decoration: InputDecoration(labelText:label, border: const OutlineInputBorder()));
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insight Editor'), actions: [IconButton(onPressed:_save, icon: const Icon(Icons.save_outlined))]),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text('Reel Insights', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
          const SizedBox(height:6), const Text('Create and edit a local insights view. No access-code screen is included.'),
          const SizedBox(height:18),
          TextField(controller:url, decoration: const InputDecoration(labelText:'Reel / Post URL', hintText:'Paste a URL', border:OutlineInputBorder(), prefixIcon:Icon(Icons.link))),
          const SizedBox(height:16),
          Row(children:[Expanded(child:field('Likes',likes)), const SizedBox(width:10), Expanded(child:field('Comments',comments))]),
          const SizedBox(height:10),
          Row(children:[Expanded(child:field('Shares',shares)), const SizedBox(width:10), Expanded(child:field('Views',views))]),
          const SizedBox(height:10), field('Viewers',viewers),
          const SizedBox(height:18),
          SizedBox(width:double.infinity, child:FilledButton.icon(onPressed:_save, icon:const Icon(Icons.check), label:Text(saved?'Save changes':'Save'))),
        ]))),
        const SizedBox(height:12),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text('Views over time', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.bold)),
          const SizedBox(height:16), SizedBox(height:150, child: CustomPaint(painter: _ChartPainter())),
        ]))),
      ]),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.deepPurple..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0,size.height*.78)..cubicTo(size.width*.18,size.height*.68,size.width*.23,size.height*.55,size.width*.36,size.height*.6)..cubicTo(size.width*.5,size.height*.67,size.width*.55,size.height*.34,size.width*.68,size.height*.43)..cubicTo(size.width*.8,size.height*.52,size.width*.86,size.height*.2,size.width,size.height*.25);
    canvas.drawPath(path,p);
    final grid=Paint()..color=Colors.grey.withOpacity(.25)..strokeWidth=1;
    for(int i=1;i<4;i++){ final y=size.height*i/4; canvas.drawLine(Offset(0, y), Offset(size.width, y), grid); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
