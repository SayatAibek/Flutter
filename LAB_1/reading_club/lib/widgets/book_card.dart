import 'package:flutter/material.dart';

import '../models/book.dart';
import '../utils/format.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    required this.onOpen,
    required this.onToggleFavourite,
    super.key,
  });

  final Book book;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (:taken, :free) = book.places;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      book.genre.coverAsset,
                      width: 78,
                      height: 112,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 78,
                        height: 112,
                        color: colors.surfaceContainerHighest,
                        child: Icon(book.genre.icon, color: colors.primary),
                      ),
                    ),
                  ),
                  if (free == 0)
                    const Positioned(
                      left: 3,
                      top: 3,
                      child: _CapacityBadge(label: 'FULL', color: Colors.red),
                    )
                  else if (free <= 5)
                    Positioned(
                      left: 3,
                      top: 3,
                      child: _CapacityBadge(
                        label: '$free left',
                        color: colors.tertiary,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Icon(Icons.event_outlined, size: 16, color: colors.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatDateTime(book.when),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Icon(book.mode ? Icons.link : Icons.place_outlined,
                            size: 16, color: colors.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            book.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (book.description != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        book.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      '$taken borrowed · $free available',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: book.favourite ? 'Remove from favourites' : 'Add to favourites',
                onPressed: onToggleFavourite,
                icon: Icon(
                  book.favourite ? Icons.favorite : Icons.favorite_border,
                  color: book.favourite ? colors.error : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapacityBadge extends StatelessWidget {
  const _CapacityBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
}