import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydj/components/video_preview.dart';

// Tipe data enum untuk menentukan pilihan apakah foto atau video.
enum MediaType { photo, video }

// Class yang nantinya dipanggil dari halaman lain yang membutuhkan komponen
// pilih media.
class MediaSelector extends StatefulWidget {
  final MediaType mediaType;

  const MediaSelector({super.key, this.mediaType = MediaType.photo});

  @override
  State<StatefulWidget> createState() {
    return _MediaSelectorState();
  }
}

// Class state seperti biasa..
class _MediaSelectorState extends State<MediaSelector> {
  String _mediaPath = ''; // <-- Untuk menyimpan path ke media yang dipilih
  // pengguna

  Widget _mediaPlaceholder() {
    IconData iconData;
    String caption = '';
    Widget placeholderWidget;
    // Cek jenis medianya apakah foto atau video
    if (widget.mediaType == MediaType.photo) {
      iconData = Icons.image_not_supported_outlined;
      caption = 'Belum ada foto';
      placeholderWidget = Image.file(
        File(_mediaPath),
        width: double.infinity, // <-- Isi penuh parent
        fit: BoxFit.fitWidth, // <-- Tinggi otomatis sesuai rasio
      );
    } else {
      iconData = Icons.videocam_off_outlined;
      caption = 'Belum ada video';
      placeholderWidget = VideoPreview(path: _mediaPath); // <-- Di sini,
      // `Column()` Kita ganti dengan widget yang kita buat tadi.
    }
    // Jika path kosong, tampilkan "No Photo/Video".
    if (_mediaPath.isEmpty) {
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      return SizedBox(
        height: 120,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 32, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              caption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    // Jika path ada isinya, tampilkan medianya.
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: double.infinity, child: placeholderWidget),
      );
    }
  }

  Future<XFile?> _retrieveMedia(ImageSource source) async {
    final picker = ImagePicker();
    XFile? media;
    if (widget.mediaType == MediaType.photo) {
      media = await picker.pickImage(source: source);
    } else {
      media = await picker.pickVideo(source: source);
    }
    return media;
  }

  // Memilih media dari kamera.
  void _selectFromCamera() async {
    XFile? media = await _retrieveMedia(ImageSource.camera);
    if (media != null) {
      setState(() {
        _mediaPath = media.path;
      });
    }
  }

  // Memilih media dari galeri.
  void _selectFromGallery() async {
    XFile? media = await _retrieveMedia(ImageSource.gallery);
    if (media != null) {
      setState(() {
        _mediaPath = media.path;
      });
    }
  }

  // Menghilangkan tampilan media yang dipilih.
  void _deleteSelected() {
    setState(() {
      _mediaPath = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: _mediaPlaceholder(), // <-- Fungsi yang kita buat tadi
            // dipanggil di sini.
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          Container(
            padding: const EdgeInsets.all(8),
            color: colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  child: _mediaButton(
                    icon: Icons.photo_camera_outlined,
                    color: colorScheme.onSurfaceVariant,
                    onPressed: _selectFromCamera,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _mediaButton(
                    icon: Icons.photo_library_outlined,
                    color: colorScheme.onSurfaceVariant,
                    onPressed: _selectFromGallery,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _mediaButton(
                    icon: Icons.delete_outline,
                    color: colorScheme.error,
                    onPressed: _deleteSelected,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tombol aksi (kamera, galeri, hapus) dengan gaya seragam.
  Widget _mediaButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
