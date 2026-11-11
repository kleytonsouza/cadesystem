import 'package:flutter/material.dart';

import '../buscar/buscar_view.dart';
import '../configuracoes/configuracoes_view.dart';
import '../registrar/registrar_view.dart';
import '../inventario/inventario_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadê?')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/branding/cade-drawer.png',
                    height: 150,
                    cacheWidth: 360,
                    semanticLabel: 'Ilustração do aplicativo Cadê',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'O que você deseja fazer?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  _OptionCard(
                    icon: Icons.save_alt_rounded,
                    title: 'Registrar',
                    subtitle: 'Salvar um item novo no seu aparelho.',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const RegistrarView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _OptionCard(
                    icon: Icons.image_search_outlined,
                    title: 'Inventário por foto',
                    subtitle: 'Veja sugestões de objetos em uma foto.',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const InventarioView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _OptionCard(
                    icon: Icons.history_edu_rounded,
                    title: 'Histórico',
                    subtitle: 'Ver itens salvos e o histórico de alterações.',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const HistoricoView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _OptionCard(
                    icon: Icons.settings_outlined,
                    title: 'Configurações',
                    subtitle: 'Ver espaço usado e exportar backup.',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ConfiguracoesView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
