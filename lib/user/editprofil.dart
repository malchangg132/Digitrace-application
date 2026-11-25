import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digitrace/services/sesi.dart'; // <-- BARU
import 'package:digitrace/services/user_service.dart'; // <-- BARU
import 'package:digitrace/services/alumni_service.dart'; // <-- BARU

// WARNA
const Color _kBlueDark = Color(0xFF264D7A);
const Color _kMuted = Color(0xFF7D8BA3);
const Color _kDivider = Color(0xFFDCE1EA);
const Color _kButton = Color(0xFF7F0A0A);


class ProfilData {
  final String nama;
  final String ttl;
  final String jurusan;
  final String tahunLulus;
  final String email;
  final String noHp;

  const ProfilData({
    required this.nama,
    required this.ttl,
    required this.jurusan,
    required this.tahunLulus,
    required this.email,
    required this.noHp,
  });

  ProfilData copyWith({String? noHp}) => ProfilData(
        nama: nama,
        ttl: ttl,
        jurusan: jurusan,
        tahunLulus: tahunLulus,
        email: email,
        noHp: noHp ?? this.noHp,
      );
}

class EditProfilScreen extends StatefulWidget {
  final ProfilData data;
  const EditProfilScreen({super.key, required this.data});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  // Nomor HP
  final TextEditingController _hpC = TextEditingController();
  final GlobalKey<FormFieldState<String>> _hpKey =
      GlobalKey<FormFieldState<String>>();
  late String _hpSaved;
  bool _editingHp = false;

  // Password
  final TextEditingController _pwC = TextEditingController();
  final GlobalKey<FormFieldState<String>> _pwKey =
      GlobalKey<FormFieldState<String>>();
  String _pwSaved = ''; // <-- UBAH: kosong, isinya password baru yang belum disimpan
  bool _editingPw = false;
  bool _showPassword = false;
  bool _pwChanged = false;

  @override
  void initState() {
    super.initState();
    _hpSaved = widget.data.noHp;
  }

  @override
  void dispose() {
    _hpC.dispose();
    _pwC.dispose();
    super.dispose();
  }

  // VALIDATOR
  String? _validateHp(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Nomor HP wajib diisi';
    if (t.length < 9 || t.length > 15) return 'Nomor HP harus 9-15 digit';
    return null;
  }

  String? _validatePw(String? v) {
    if (v == null || v.isEmpty) return null; // kosong = batal ganti
    if (v.length < 8) return 'Password minimal 8 karakter';
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

  // NOMOR HP
  bool _commitHp() {
    if (!_editingHp) return true;
    if (!(_hpKey.currentState?.validate() ?? false)) return false;
    setState(() {
      _hpSaved = _hpC.text.trim();
      _editingHp = false;
    });
    return true;
  }

  void _toggleHp() {
    if (_editingHp) {
      _commitHp();
    } else {
      setState(() {
        _hpC.text = _hpSaved == '-' ? '' : _hpSaved; // <-- UBAH: "-" jangan masuk ke kolom isian
        _editingHp = true;
      });
    }
  }

  // PASSWORD
  bool _commitPw() {
    if (!_editingPw) return true;
    if (!(_pwKey.currentState?.validate() ?? false)) return false;
    setState(() {
      if (_pwC.text.isNotEmpty) {
        _pwSaved = _pwC.text;
        _pwChanged = true;
      }
      _pwC.clear();
      _editingPw = false;
    });
    return true;
  }

  void _togglePw() {
    if (_editingPw) {
      _commitPw();
    } else {
      setState(() {
        _pwC.clear();
        _editingPw = true;
      });
    }
  }

  // SIMPAN
  Future<void> _simpan() async { // <-- UBAH: jadi async
    FocusScope.of(context).unfocus();

    if (!_commitHp() || !_commitPw()) {
      _showSnack('Periksa kembali data yang kamu ubah');
      return;
    }

    final hpBerubah = _hpSaved != widget.data.noHp; // <-- BARU
    if (!hpBerubah && !_pwChanged) { // <-- UBAH
      _showSnack('Tidak ada perubahan');
      return;
    }

    // <-- BARU: simpan ke supabase lewat service
    final sesi = Sesi.akun;
    if (sesi == null) {
      _showSnack('Sesi habis, silakan login ulang');
      return;
    }

    try {
      if (hpBerubah) {
        await AlumniService().ubahNoHp(sesi.id, _hpSaved);
      }
      if (_pwChanged) {
        await UserService().ubahPassword(sesi.id, _pwSaved);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal menyimpan perubahan');
      return;
    }

    if (!mounted) return;
    Navigator.pop(context, widget.data.copyWith(noHp: _hpSaved));
  }

  Widget _readOnly(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: _kBlueDark,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 10.5, color: _kMuted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      errorStyle: const TextStyle(fontSize: 9),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _kMuted, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _kBlueDark, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9534F), width: 1),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9534F), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    const divider = Divider(height: 1, thickness: 1, color: _kDivider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== PANAH KEMBALI =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.maybePop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back, size: 20, color: _kBlueDark),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ===== JUDUL =====
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _kBlueDark,
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // ===== CARD DATA PRIBADI =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 17, 18, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2E000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 22, color: _kBlueDark),
                          SizedBox(width: 10),
                          Text(
                            'Data Pribadi',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: _kBlueDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // --- baris yang tidak bisa diubah ---
                      _EditRow(label: 'Nama Lengkap', value: _readOnly(d.nama)),
                      divider,
                      _EditRow(
                          label: 'Tempat, Tanggal lahir',
                          value: _readOnly(d.ttl)),
                      divider,
                      _EditRow(label: 'Jurusan', value: _readOnly(d.jurusan)),
                      divider,
                      _EditRow(
                          label: 'Tahun Lulus', value: _readOnly(d.tahunLulus)),
                      divider,
                      _EditRow(label: 'Email', value: _readOnly(d.email)),
                      divider,

                      // --- Nomor HP (bisa diubah) ---
                      _EditRow(
                        label: 'Nomor HP',
                        value: _editingHp
                            ? TextFormField(
                                key: _hpKey,
                                controller: _hpC,
                                autofocus: true,
                                validator: _validateHp,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _kBlueDark,
                                ),
                                decoration: _inputDecoration('Nomor HP baru'),
                              )
                            : _readOnly(_hpSaved),
                        actions: [
                          _ActionIcon(
                            icon: _editingHp
                                ? Icons.check
                                : Icons.edit_outlined,
                            color: _kBlueDark,
                            onTap: _toggleHp,
                          ),
                        ],
                      ),
                      divider,

                      // --- Password akun (bisa diubah) ---
                      _EditRow(
                        label: 'Password akun',
                        value: _editingPw
                            ? TextFormField(
                                key: _pwKey,
                                controller: _pwC,
                                autofocus: true,
                                obscureText: !_showPassword,
                                validator: _validatePw,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _kBlueDark,
                                ),
                                decoration:
                                    _inputDecoration('Password baru'),
                              )
                            // <-- UBAH: password lama tidak diambil dari supabase,
                            // jadi yang bisa dilihat hanya password baru yang barusan diketik
                            : _readOnly(_showPassword && _pwSaved.isNotEmpty
                                ? _pwSaved
                                : '********'),
                        actions: [
                          _ActionIcon(
                            icon: _showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _kMuted,
                            onTap: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                          _ActionIcon(
                            icon: _editingPw
                                ? Icons.check
                                : Icons.edit_outlined,
                            color: _kBlueDark,
                            onTap: _togglePw,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // ===== TOMBOL SIMPAN =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kButton,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET PEMBANTU

class _EditRow extends StatelessWidget {
  final String label;
  final Widget value;
  final List<Widget> actions;

  const _EditRow({
    required this.label,
    required this.value,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 31),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: 46,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: _kBlueDark),
                ),
              ),
            ),
            Expanded(
              flex: 54,
              child: Row(
                children: [
                  Expanded(child: value),
                  ...actions,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}