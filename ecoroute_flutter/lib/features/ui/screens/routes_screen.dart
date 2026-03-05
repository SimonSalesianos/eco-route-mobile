import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/eco_route.dart';
import '../../bloc/bloc/routes_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/route_card.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<RoutesBloc>().add(RoutesRequested());

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EcoRoute> _filterRoutes(List<EcoRoute> routes) {
    if (_searchQuery.isEmpty) return routes;
    return routes
        .where((r) => r.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Explorar Rutas',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<RoutesBloc, RoutesState>(
        builder: (context, state) {
          if (state is RoutesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RoutesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<RoutesBloc>().add(RoutesRequested()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is RoutesLoaded) {
            final filteredRoutes = _filterRoutes(state.routes);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar rutas...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredRoutes.isEmpty
                      ? const Center(
                          child: Text('No hay rutas que coincidan'),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredRoutes.length,
                          itemBuilder: (context, index) {
                            final route = filteredRoutes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: RouteCard(route: route),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
