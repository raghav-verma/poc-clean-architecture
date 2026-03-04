import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_bloc.dart';

class DrinkDetailScreen extends StatelessWidget {
  const DrinkDetailScreen({super.key, required this.drink});

  final DrinkListingEntity drink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DrinkDetailBloc, DrinkDetailState>(
      builder: (context, state) {
        final displayDrink = state is DrinkDetailLoadedState
            ? state.drink
            : drink;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: colorScheme.surfaceContainerHighest,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'drink-image-${drink.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        displayDrink.url != null && displayDrink.url!.isNotEmpty
                            ? Image.network(
                                displayDrink.url!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(colorScheme),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return _buildPlaceholder(colorScheme);
                                },
                              )
                            : _buildPlaceholder(colorScheme),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                colorScheme.surface,
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                  child: state is DrinkDetailLoadingState
                      ? Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                      : state is DrinkDetailErrorState
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ErrorBody(message: state.message),
                            const SizedBox(height: 16),
                            _DetailBody(drink: displayDrink),
                          ],
                        )
                      : _DetailBody(drink: displayDrink),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.local_bar_outlined,
        color: colorScheme.onSurface.withValues(alpha: 0.15),
        size: 80,
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.drink});

  final DrinkListingEntity drink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (drink.name != null)
          Text(
            drink.name!,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        const SizedBox(height: 28),
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: 20),

        // Description
        if (drink.description != null && drink.description!.isNotEmpty) ...[
          Text(
            'ABOUT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            drink.description!,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ] else
          const _EmptyDescription(),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.error, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDescription extends StatelessWidget {
  const _EmptyDescription();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.onSurface.withValues(alpha: 0.38),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            'No description available.',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.38),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
