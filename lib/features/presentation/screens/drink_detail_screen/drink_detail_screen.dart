import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_bloc.dart';

class DrinkDetailScreen extends StatelessWidget {
  const DrinkDetailScreen({super.key, required this.drink});

  final DrinkListingEntity drink;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrinkDetailBloc, DrinkDetailState>(
      builder: (context, state) {
        final displayDrink = state is DrinkDetailLoadedState
            ? state.drink
            : drink;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: const Color(0xFF1E1E1E),
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
                                    _buildPlaceholder(),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return _buildPlaceholder();
                                },
                              )
                            : _buildPlaceholder(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF121212),
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
                      ? const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent,
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

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: const Center(
        child: Icon(Icons.local_bar_outlined, color: Colors.white24, size: 80),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.drink});

  final DrinkListingEntity drink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (drink.name != null)
          Text(
            drink.name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        const SizedBox(height: 28),
        const Divider(color: Color(0xFF2C2C2C)),
        const SizedBox(height: 20),

        // Description
        if (drink.description != null && drink.description!.isNotEmpty) ...[
          const Text(
            'ABOUT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            drink.description!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
            ),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white38, size: 18),
          SizedBox(width: 10),
          Text(
            'No description available.',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
