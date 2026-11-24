import 'package:flutter/material.dart';

class _Notif {
  final int id;
  final String title;
  final String desc;
  final String tanggal;

  const _Notif({
    required this.id,
    required this.title,
    required this.desc,
    required this.tanggal,
  });
}

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final List<_Notif> _items = [
    const _Notif(
      id: 1,
      title: 'Tracer Study Diperbarui',
      desc: 'Data Tracer study kamu telah berhasil disimpan. '
          'Terimakasih sudah melengkapi',
      tanggal: '25 september 2026',
    ),
    const _Notif(
      id: 2,
      title: 'Tracer Study Diperbarui',
      desc: 'Data Tracer study kamu telah berhasil disimpan. '
          'Terimakasih sudah melengkapi',
      tanggal: '25 september 2026',
    ),
    const _Notif(
      id: 3,
      title: 'Tracer Study Diperbarui',
      desc: 'Data Tracer study kamu telah berhasil disimpan. '
          'Terimakasih sudah melengkapi',
      tanggal: '25 september 2026',
    ),
  ];

  // geser kartu ke kiri and kanan, bisa dibatalkan yeu
  void _hapus(int index) {
    final item = _items[index];
    setState(() => _items.removeAt(index));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Notifikasi dihapus'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Batalkan',
            onPressed: () {
              final at = index > _items.length ? _items.length : index;
              setState(() => _items.insert(at, item));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // kembali
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF244B73),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // judul
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF244B73),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // daftar notifikasi
                    if (_items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Center(
                          child: Text(
                            'Belum ada notifikasi',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8793A8),
                            ),
                          ),
                        ),
                      )
                    else
                      for (int i = 0; i < _items.length; i++)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                          child: Dismissible(
                            key: ValueKey(_items[i].id),
                            onDismissed: (_) => _hapus(i),
                            background: const _SwipeBg(
                                alignment: Alignment.centerLeft),
                            secondaryBackground: const _SwipeBg(
                                alignment: Alignment.centerRight),
                            child: _NotifCard(
                              item: _items[i],
                              colorIndex: _items[i].id % 3 == 0
                                  ? 2
                                  : (_items[i].id % 3) - 1,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final _Notif item;
  final int colorIndex;

  const _NotifCard({required this.item, required this.colorIndex});

  @override
  Widget build(BuildContext context) {
    // warna kartu & lingkaran ikon (biru, kuning, hijau)
    final List<Color> cardColors = [
      const Color(0xFFE6EDFB),
      const Color(0xFFFEF9DE),
      const Color(0xFFE9F0E5),
    ];
    final List<Color> circleColors = [
      const Color(0xFFD3DFF5),
      const Color(0xFFFFF6CF),
      const Color(0xFFCFE0CA),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
      decoration: BoxDecoration(
        color: cardColors[colorIndex],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColors[colorIndex],
            ),
            child: const Icon(
              Icons.note_alt,
              size: 20,
              color: Color(0xFF244B73),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF244B73),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.desc,
                  style: const TextStyle(
                    fontSize: 8.5,
                    height: 1.4,
                    color: Color(0xFF8793A8),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: Color(0xFF8793A8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.tanggal,
                      style: const TextStyle(
                        fontSize: 8.5,
                        color: Color(0xFF8793A8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  final Alignment alignment;
  const _SwipeBg({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D6D6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.delete_outline, color: Color(0xFF7F0A0A)),
    );
  }
}