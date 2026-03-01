import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/core/utils/debouncer.dart';
import 'package:flutter_clean_arch_template/core/utils/extensions/context_extensions.dart';
import 'package:flutter_clean_arch_template/core/utils/routes.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_bloc.dart';

class DrinkListingScreen extends StatefulWidget {
  const DrinkListingScreen({super.key});

  @override
  State<DrinkListingScreen> createState() => _DrinkListingScreenState();
}

class _DrinkListingScreenState extends State<DrinkListingScreen> {
  late TextEditingController _searchController;
  final Debouncer _debounce = Debouncer(milliseconds: 500);
  bool _showClearIcon = false;
  String? _lastDispatchedSearchText;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _dispatchSearch('');
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              onChanged: (String? value) {
                final hasText = value != null && value.isNotEmpty;
                if (_showClearIcon != hasText) {
                  setState(() => _showClearIcon = hasText);
                }
                if (hasText) {
                  _debounce.run(() {
                    if (!mounted) {
                      return;
                    }
                    _dispatchSearch(value);
                  });
                } else {
                  _debounce.dispose();
                  _dispatchSearch('');
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 5),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _showClearIcon
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _debounce.dispose();
                          _searchController.clear();
                          setState(() => _showClearIcon = false);
                          _dispatchSearch('');
                        },
                      )
                    : const SizedBox(),
                hintText: Constants.appName,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<DrinkListingBloc, DrinkListingState>(
        listener: (BuildContext context, state) {
          if (state is DrinkErrorState) {
            context.showToast('Error Fetching Drinks');
          }
        },
        builder: (BuildContext context, state) {
          if (state is DrinkLoadingState) {
            return const Center(child: Text('Loading...'));
          }

          if (state is DrinkLoadedState) {
            return _DrinkList(drinkList: state.drinkList);
          }

          if (state is DrinkErrorState) {
            return Center(child: Text(state.message));
          }

          // DrinkListingInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _dispatchSearch(String searchText) {
    if (_lastDispatchedSearchText == searchText) {
      return;
    }
    _lastDispatchedSearchText = searchText;
    context.read<DrinkListingBloc>().add(
      SearchDrinkEvent(searchText: searchText),
    );
  }
}

class _DrinkList extends StatelessWidget {
  const _DrinkList({required this.drinkList});

  final List<DrinkListingEntity> drinkList;

  @override
  Widget build(BuildContext context) {
    if (drinkList.isEmpty) {
      return const Center(child: Text('No drinks found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 50, top: 10, left: 10, right: 10),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _DrinkCard(
          drink: drinkList[index],
          onTap: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.drinkDetailScreen, arguments: drinkList[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 30);
      },
      itemCount: drinkList.length,
    );
  }
}

class _DrinkCard extends StatelessWidget {
  const _DrinkCard({required this.drink, required this.onTap});

  final DrinkListingEntity drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Hero image thumbnail
            Hero(
              tag: 'drink-image-${drink.id}',
              child: SizedBox(
                width: 90,
                height: 90,
                child: drink.url != null && drink.url!.isNotEmpty
                    ? Image.network(
                        drink.url!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFF1E1E1E),
                          child: Icon(
                            Icons.local_bar_outlined,
                            color: Colors.white24,
                          ),
                        ),
                      )
                    : const ColoredBox(
                        color: Color(0xFF1E1E1E),
                        child: Icon(
                          Icons.local_bar_outlined,
                          color: Colors.white24,
                        ),
                      ),
              ),
            ),
            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drink.name ?? 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (drink.description != null &&
                        drink.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        drink.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
