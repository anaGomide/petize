import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../shared/models/repository_model.dart';
import '../../shared/widgets/webview_page.dart';

class RepositoryList extends StatelessWidget {
  final List<Repository> repositories;
  final Function(String sort)? onSortChanged;
  final String initialSort;

  const RepositoryList({
    super.key,
    required this.repositories,
    this.onSortChanged,
    required this.initialSort,
  });

  String formatUpdatedAt(DateTime updatedAt) {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return 'Atualizado há ${difference.inDays} dias';
    } else if (difference.inHours > 0) {
      return 'Atualizado há ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Atualizado há ${difference.inMinutes} minutos';
    } else {
      return 'Atualizado agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kIsWeb ? Colors.white : Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Ordenar por:'),
                        DropdownButton<String>(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: initialSort,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'created', child: Text('Data de Criação')),
                            DropdownMenuItem(value: 'updated', child: Text('Última Atualização')),
                            DropdownMenuItem(value: 'pushed', child: Text('Último Push')),
                            DropdownMenuItem(value: 'full_name', child: Text('Nome do Repositório')),
                          ],
                          onChanged: (value) {
                            if (value != null && onSortChanged != null) {
                              onSortChanged!(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nome do repositório
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => WebViewPage(
                                    url: repo.html_url,
                                    title: repo.name,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              repo.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),

                          // Descrição do repositório
                          Text(
                            repo.description ?? 'Sem descrição disponível.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          // Detalhes: Estrelas e data de atualização
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star_border_outlined, size: 20, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${repo.stars}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Text(
                                formatUpdatedAt(repo.updatedAt), // Data formatada
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Linha separadora, exceto para o último item
                    if (index != repositories.length - 1)
                      const Divider(
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE2E8F0),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
