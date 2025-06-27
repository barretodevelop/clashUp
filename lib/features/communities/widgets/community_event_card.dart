// CommunityEventCard - Card de evento
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_event_card.dart
// CommunityEventCard - Card de evento da comunidade
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/features/communities/models/community_event_model.dart';
import 'package:flutter/material.dart';

enum EventCardStyle {
  compact, // Para listas
  featured, // Para destaque
  detailed, // Para tela de evento
}

class CommunityEventCard extends StatelessWidget {
  final CommunityEventModel event;
  final EventCardStyle style;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;
  final bool isUserParticipating;
  final bool canEdit;
  final bool showActions;

  const CommunityEventCard({
    super.key,
    required this.event,
    this.style = EventCardStyle.compact,
    this.onTap,
    this.onJoin,
    this.onLeave,
    this.onShare,
    this.onEdit,
    this.isUserParticipating = false,
    this.canEdit = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case EventCardStyle.compact:
        return _buildCompactCard(context);
      case EventCardStyle.featured:
        return _buildFeaturedCard(context);
      case EventCardStyle.detailed:
        return _buildDetailedCard(context);
    }
  }

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Data em destaque
              _buildDateBadge(context, compact: true),

              const SizedBox(width: 12),

              // Informações do evento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(context),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Horário e participantes
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(event.startTime!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.people,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${event.participantsCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Localização se disponível
                    if (event.location?.isNotEmpty == true) ...[
                      Row(
                        children: [
                          Icon(
                            event.isOnline ? Icons.videocam : Icons.location_on,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Ações
              if (showActions) _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header com imagem ou placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  // Imagem de fundo
                  if (event.imageUrl?.isNotEmpty == true)
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: event.imageUrl!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildImagePlaceholder(theme),
                        errorWidget: (context, url, error) =>
                            _buildImagePlaceholder(theme),
                      ),
                    )
                  else
                    _buildImagePlaceholder(theme),

                  // Overlay gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),

                  // Data em destaque
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildDateBadge(context),
                  ),

                  // Status badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildStatusBadge(context),
                  ),
                ],
              ),
            ),

            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    event.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Informações principais
                  _buildEventInfo(context),

                  const SizedBox(height: 16),

                  // Botão de ação
                  if (showActions) _buildMainActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header completo
          _buildDetailedHeader(context),

          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título e descrição
                Text(
                  event.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Informações detalhadas
                _buildDetailedInfo(context),

                const SizedBox(height: 20),

                // Ações
                if (showActions) _buildDetailedActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context, {bool compact = false}) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday = _isSameDay(event.startTime!, now);
    final isTomorrow =
        _isSameDay(event.startTime!, now.add(const Duration(days: 1)));

    String dayText;
    if (isToday) {
      dayText = 'HOJE';
    } else if (isTomorrow) {
      dayText = 'AMANHÃ';
    } else {
      dayText = _formatDateShort(event.startTime!);
    }

    final color = isToday
        ? Colors.red
        : isTomorrow
            ? Colors.orange
            : theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayText,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!compact) ...[
            Text(
              event.startTime!.day.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);

    Color color;
    String text;
    IconData icon;

    if (event.isCancelled) {
      color = Colors.red;
      text = 'Cancelado';
      icon = Icons.cancel;
    } else if (event.isFinished) {
      color = Colors.grey;
      text = 'Finalizado';
      icon = Icons.check_circle;
    } else if (event.isLive) {
      color = Colors.green;
      text = 'Ao Vivo';
      icon = Icons.live_tv;
    } else if (event.isStartingSoon) {
      color = Colors.orange;
      text = 'Em Breve';
      icon = Icons.schedule;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    if (isUserParticipating) {
      return IconButton(
        onPressed: onLeave,
        icon: const Icon(Icons.check_circle),
        color: Colors.green,
        tooltip: 'Você vai participar',
      );
    } else {
      return IconButton(
        onPressed: onJoin,
        icon: const Icon(Icons.add_circle_outline),
        color: Theme.of(context).colorScheme.primary,
        tooltip: 'Participar',
      );
    }
  }

  Widget _buildMainActionButton(BuildContext context) {
    final theme = Theme.of(context);

    if (event.isCancelled || event.isFinished) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isUserParticipating ? onLeave : onJoin,
        icon: Icon(isUserParticipating ? Icons.check : Icons.add),
        label: Text(isUserParticipating ? 'Participando' : 'Participar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isUserParticipating
              ? theme.colorScheme.surfaceVariant
              : theme.colorScheme.primary,
          foregroundColor: isUserParticipating
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildEventInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Data e horário
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_formatFullDate(event.startTime!)} às ${_formatTime(event.startTime!)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Localização
        if (event.location?.isNotEmpty == true) ...[
          Row(
            children: [
              Icon(
                event.isOnline ? Icons.videocam : Icons.location_on,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.location!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Participantes
        Row(
          children: [
            Icon(
              Icons.people,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '${event.participantsCount} participantes',
              style: theme.textTheme.bodyMedium,
            ),
            if (event.maxParticipants != null) ...[
              Text(
                ' / ${event.maxParticipants}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedHeader(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Stack(
        children: [
          // Imagem de fundo
          if (event.imageUrl?.isNotEmpty == true)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: event.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          // Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Ações no header
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                if (canEdit && onEdit != null)
                  _buildHeaderAction(Icons.edit, onEdit!),
                const SizedBox(width: 8),
                if (onShare != null) _buildHeaderAction(Icons.share, onShare!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDetailedInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            Icons.schedule,
            'Data e Horário',
            '${_formatFullDate(event.startTime!)} às ${_formatTime(event.startTime!)}',
          ),
          if (event.endTime != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.schedule,
              'Término',
              _formatTime(event.endTime!),
            ),
          ],
          if (event.location?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              event.isOnline ? Icons.videocam : Icons.location_on,
              'Local',
              event.location!,
            ),
          ],
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.people,
            'Participantes',
            event.maxParticipants != null
                ? '${event.participantsCount} / ${event.maxParticipants}'
                : '${event.participantsCount}',
          ),
          if (event.createdBy.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.person,
              'Organizador',
              event.createdBy,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isUserParticipating ? onLeave : onJoin,
            icon: Icon(isUserParticipating ? Icons.check : Icons.add),
            label: Text(isUserParticipating ? 'Saindo...' : 'Participar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUserParticipating ? Colors.red : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          label: const Text('Compartilhar'),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 40,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Evento',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares de formatação
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateShort(DateTime date) {
    final months = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatFullDate(DateTime date) {
    final weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}';
  }
}

/// Widget compacto para lista de eventos
class CommunityEventListTile extends StatelessWidget {
  final CommunityEventModel event;
  final VoidCallback? onTap;
  final bool isUserParticipating;

  const CommunityEventListTile({
    super.key,
    required this.event,
    this.onTap,
    this.isUserParticipating = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityEventCard(
      event: event,
      style: EventCardStyle.compact,
      onTap: onTap,
      isUserParticipating: isUserParticipating,
      showActions: false,
    );
  }
}
