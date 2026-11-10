import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlaybackButton extends StatefulWidget {
  const AudioPlaybackButton({required this.caminho, super.key});

  final String caminho;

  @override
  State<AudioPlaybackButton> createState() => _AudioPlaybackButtonState();
}

class _AudioPlaybackButtonState extends State<AudioPlaybackButton> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _fim;
  bool _tocando = false;

  @override
  void initState() {
    super.initState();
    _fim = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _tocando = false);
    });
  }

  @override
  void didUpdateWidget(AudioPlaybackButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caminho != widget.caminho) {
      unawaited(_player.stop());
      _tocando = false;
    }
  }

  @override
  void dispose() {
    unawaited(_fim?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _alternar() async {
    try {
      if (_tocando) {
        await _player.stop();
      } else {
        if (!await File(widget.caminho).exists()) {
          throw const FileSystemException('Áudio não encontrado');
        }
        await _player.play(DeviceFileSource(widget.caminho));
      }
      if (mounted) setState(() => _tocando = !_tocando);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível reproduzir o áudio.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _alternar,
      icon: Icon(_tocando ? Icons.stop_outlined : Icons.play_arrow_outlined),
      label: Text(_tocando ? 'Parar áudio' : 'Ouvir áudio'),
    );
  }
}
