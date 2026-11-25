import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digitrace/services/sesi.dart';
import 'package:digitrace/services/tracer_service.dart'; 
import 'package:digitrace/models/tracer_study.dart'; 
import 'terima_kasih.dart';

class TracerResult {
  final String status;
  final String namaUniversitas;
  final String programStudi;
  final String perusahaan;
  final String posisi;

  const TracerResult({
    required this.status,
    required this.namaUniversitas,
    required this.programStudi,
    required this.perusahaan,
    required this.posisi,
  });
}

class TracerScreen extends StatefulWidget {
  final Function(TracerResult) onSelesai;

  const TracerScreen({super.key, required this.onSelesai});

  @override
  State<TracerScreen> createState() => _TracerScreenState();
}

class _TracerScreenState extends State<TracerScreen> {
  static const List<String> _fieldNames = [
    'nama',
    'ttl',
    'lulus',
    'jurusan',
    'email',
    'hp',
    'alamat',
    'status',
    'pendidikan',
    'universitas',
    'prodi',
    'masuk',
    'statusPendidikan',
    'statusKerja',
    'perusahaan',
    'posisi',
    'bidang',
    'lokasi',
  ];

  // field wajib diisi
  static const List<String> _requiredNames = [
    'nama',
    'ttl',
    'lulus',
    'jurusan',
    'email',
    'hp',
    'alamat',
    'status',
    'pendidikan',
    'universitas',
    'prodi',
    'masuk',
    'statusPendidikan',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  bool _menyimpan = false; // supaya tombol tidak terpencet dua kali

  final Map<String, TextEditingController> _c = {
    for (final n in _fieldNames) n: TextEditingController(),
  };
  final Map<String, GlobalKey<FormFieldState<String>>> _k = {
    for (final n in _fieldNames) n: GlobalKey<FormFieldState<String>>(),
  };

  bool get _isComplete =>
      _requiredNames.every((n) => _c[n]!.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  // validator
  String? _req(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  String? _year(String? v, String label) {
    final r = _req(v, label);
    if (r != null) return r;
    final t = v!.trim();
    final y = int.tryParse(t);
    if (y == null || t.length != 4 || y < 1980 || y > 2100) {
      return 'Tahun tidak valid';
    }
    return null;
  }

  String? _email(String? v) {
    final r = _req(v, 'Email');
    if (r != null) return r;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v!.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _hp(String? v) {
    final r = _req(v, 'Nomor Hp');
    if (r != null) return r;
    if (v!.trim().length < 9 || v.trim().length > 15) {
      return 'Nomor Hp harus 9-15 digit';
    }
    return null;
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  //ambil isi field, kalau kosong jadi null supaya di supabase kosong juga
  String? _teks(String name) {
    final t = _c[name]!.text.trim();
    return t.isEmpty ? null : t;
  }

  //jadi async supaya bisa menunggu halaman Terima Kasih ditutup
  Future<void> _submit() async {
    if (_menyimpan) return;
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      _showSnack('Lengkapi data yang masih kosong atau salah');

      // scroll ke field pertama yang error
      for (final n in _fieldNames) {
        final state = _k[n]!.currentState;
        final ctx = _k[n]!.currentContext;
        if (state != null && state.hasError && ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.25,
            duration: const Duration(milliseconds: 300),
          );
          break;
        }
      }
      return;
    }

    //simpan ke supabase lewat TracerService
    final sesi = Sesi.akun;
    if (sesi == null) {
      _showSnack('Sesi habis, silakan login ulang');
      return;
    }

    final tracer = TracerStudy(
      idUser: sesi.id,
      statusAktif: _teks('status'),
      pendidikanTerakhir: _teks('pendidikan'),
      namaUniversitas: _teks('universitas'),
      programStudy: _teks('prodi'),
      tahunMasuk: int.tryParse(_c['masuk']!.text.trim()),
      namaPerusahaan: _teks('perusahaan'),
      posisiJabatan: _teks('posisi'),
      bidangPekerjaan: _teks('bidang'),
      lokasiPekerjaan: _teks('lokasi'),
    );

    setState(() => _menyimpan = true);
    try {
      await TracerService().simpan(tracer);
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      _showSnack('Gagal menyimpan data tracer');
      return;
    }
    if (!mounted) return;
    setState(() => _menyimpan = false);

    final hasil = TracerResult(
      status: _c['status']!.text.trim(),
      namaUniversitas: _c['universitas']!.text.trim(),
      programStudi: _c['prodi']!.text.trim(),
      perusahaan: _c['perusahaan']!.text.trim(),
      posisi: _c['posisi']!.text.trim(),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TerimaKasihScreen()),
    );
    if (!mounted) return;
    widget.onSelesai(hasil);
  }

  // pembantu field
  Widget _f(
    String name,
    String label,
    String hint, {
    bool required = true,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    TextCapitalization cap = TextCapitalization.sentences,
    List<TextInputFormatter>? formatters,
  }) {
    return _Field(
      label: label,
      hint: hint,
      controller: _c[name]!,
      fieldKey: _k[name]!,
      autovalidate: _autovalidate,
      keyboardType: keyboard,
      capitalization: cap,
      inputFormatters: formatters,
      validator: validator ?? (required ? (v) => _req(v, label) : null),
    );
  }

  Widget _gap() => const SizedBox(height: 18);

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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Form(
                  key: _formKey,
                  onChanged: () => setState(() {}),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //header
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tracer Study',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF244B73),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Yuk isi data diri kamu!',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF3F5E86),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // data diri alumni
                      const _Heading('Data Diri Alumni'),
                      _SectionCard(children: [
                        _f('nama', 'Nama Lengkap',
                            'Contoh: Suendah Inarti Pratama',
                            cap: TextCapitalization.words),
                        _gap(),
                        _f('ttl', 'Tempat, Tanggal lahir',
                            'Contoh: 0097125163'),
                        _gap(),
                        _f('lulus', 'Tahun Lulus', '2023',
                            keyboard: TextInputType.number,
                            validator: (v) => _year(v, 'Tahun Lulus'),
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ]),
                        _gap(),
                        _f('jurusan', 'Jurusan', 'Rekayasa Perangkat Lunak',
                            cap: TextCapitalization.words),
                      ]),
                      const SizedBox(height: 24),

                      // kontak dan alamat
                      const _Heading('Kontak & Alamat'),
                      _SectionCard(children: [
                        _f('email', 'Email', 'Contoh: endah123@gmail.com',
                            keyboard: TextInputType.emailAddress,
                            cap: TextCapitalization.none,
                            validator: _email),
                        _gap(),
                        _f('hp', 'Nomor Hp', 'Contoh: 08238237257',
                            keyboard: TextInputType.phone,
                            validator: _hp,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ]),
                        _gap(),
                        _f('alamat', 'Alamat Lengkap',
                            'Contoh: Jl Melati gang V',
                            cap: TextCapitalization.words),
                      ]),
                      const SizedBox(height: 24),

                      // status saat ini
                      const _Heading('Status Saat Ini'),
                      _SectionCard(children: [
                        _f('status', 'Status',
                            'Contoh: Bekerja/Wirausaha/kuliah/lainnya'),
                      ]),
                      const SizedBox(height: 24),

                      // data pendidikan
                      const _Heading('Data Pendidikan'),
                      _SectionCard(children: [
                        _f('pendidikan', 'Pendidikan Terakhir',
                            'Contoh: Perguruan tinggi'),
                        _gap(),
                        _f('universitas', 'Nama Universitas',
                            'Contoh: Universitas Negeri Malang',
                            cap: TextCapitalization.words),
                        _gap(),
                        _f('prodi', 'Program Studi',
                            'Contoh: Teknik Informatika',
                            cap: TextCapitalization.words),
                        _gap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 33,
                              child: _f('masuk', 'Tahun Masuk', '2023',
                                  keyboard: TextInputType.number,
                                  validator: (v) => _year(v, 'Tahun Masuk'),
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ]),
                            ),
                            const Expanded(flex: 26, child: SizedBox()),
                            Expanded(
                              flex: 41,
                              child: _f('statusPendidikan',
                                  'Status Pendidikan', 'Sudah Lulus'),
                            ),
                          ],
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // data pekerjaan
                      const _Heading('Data Pekerjaan'),
                      _SectionCard(children: [
                        _f('statusKerja', 'Status saat ini',
                            'Contoh: Sudah Bekerja',
                            required: false),
                        _gap(),
                        _f('perusahaan', 'Nama Perusahaan',
                            'Contoh: PT Malang',
                            required: false, cap: TextCapitalization.words),
                        _gap(),
                        _f('posisi', 'Posisi/Jabatan',
                            'Contoh: Web developer',
                            required: false, cap: TextCapitalization.words),
                        _gap(),
                        _f('bidang', 'Bidang Pekerjaan', 'Contoh: IT',
                            required: false),
                        _gap(),
                        _f('lokasi', 'Lokasi Perusahaan',
                            'Contoh: Jl Melati gang V',
                            required: false, cap: TextCapitalization.words),
                      ]),
                      const SizedBox(height: 36),

                      // tombol selesai
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _menyimpan ? null : _submit, // <-- UBAH
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isComplete
                                ? const Color(0xFF244B73)
                                : const Color(0xFF8DA0BD),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF244B73),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE2EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final GlobalKey<FormFieldState<String>> fieldKey;
  final AutovalidateMode autovalidate;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? inputFormatters;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.fieldKey,
    required this.autovalidate,
    required this.validator,
    required this.keyboardType,
    required this.capitalization,
    required this.inputFormatters,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF2F5A8A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: fieldKey,
          controller: controller,
          validator: validator,
          autovalidateMode: autovalidate,
          keyboardType: keyboardType,
          textCapitalization: capitalization,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 10, color: Color(0xFFB4BAC5)),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: _border(const Color(0xFFE4E8EF)),
            enabledBorder: _border(const Color(0xFFE4E8EF)),
            focusedBorder: _border(const Color(0xFF244B73)),
            errorBorder: _border(const Color(0xFFD9534F)),
            focusedErrorBorder: _border(const Color(0xFFD9534F)),
            errorStyle: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}