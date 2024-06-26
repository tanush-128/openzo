import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/providers/products_provider.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatefulWidget {
  FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _vegTypeChoiceChips(context),
            const SizedBox(width: 8),
            _buildSortButton(context),
            const SizedBox(width: 8),
            _buildCategoryFilterButton(context),
            const SizedBox(width: 8),
            _buildResetButton(context),
          ],
        ),
      ),
    );
  }

  List<String> vegTypes = [
    'Veg',
    'Egg',
    'Non-Veg',
  ];

  Widget _vegTypeChoiceChips(BuildContext context) {
    if (Provider.of<ProductsProvider>(context).products.firstOrNull?.type !=
        "food") {
      return Container();
    }
    return Wrap(
      spacing: 8,
      children: vegTypes
          .map(
            (e) => ChoiceChip(
              // avatar: null,
              showCheckmark: false,
              label: Text(e),
              selected: context
                  .watch<ProductsProvider>()
                  .selectedVegTypes
                  .contains(e),
              onSelected: (value) {
                if (context.read<ProductsProvider>().selectedVegTypes.length ==
                        1 &&
                    context
                        .read<ProductsProvider>()
                        .selectedVegTypes
                        .contains(e)) {
                  return;
                }
                value
                    ? context.read<ProductsProvider>().updateSelectedVegTypes([
                        e,
                        ...context.read<ProductsProvider>().selectedVegTypes
                      ])
                    : context.read<ProductsProvider>().updateSelectedVegTypes(
                        context
                            .read<ProductsProvider>()
                            .selectedVegTypes
                            .where((element) => element != e)
                            .toList());
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return _buildSortModal(context);
          },
        );
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          children: [
            Text("Sort By"),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildSortModal(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("SORT BY",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              RadioListTile(
                value: 0,
                groupValue: context.watch<ProductsProvider>().sortIndex,
                onChanged: (value) {
                  context
                      .read<ProductsProvider>()
                      .updateSortIndex(value as int);
                  Navigator.pop(context);
                },
                title: const Text("Default"),
              ),
              RadioListTile(
                value: 1,
                groupValue: context.watch<ProductsProvider>().sortIndex,
                onChanged: (value) {
                  context
                      .read<ProductsProvider>()
                      .updateSortIndex(value as int);
                  Navigator.pop(context);
                },
                title: const Text("Price: Low to High"),
              ),
              RadioListTile(
                value: 2,
                groupValue: context.watch<ProductsProvider>().sortIndex,
                onChanged: (value) {
                  context
                      .read<ProductsProvider>()
                      .updateSortIndex(value as int);
                  Navigator.pop(context);
                },
                title: const Text("Price: High to Low"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilterButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return _buildCategoryFilterModal(context);
          },
        );
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          children: [
            Text("Category Filter "),
            Icon(Icons.filter_list),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterModal(BuildContext context) {
    List<String> allCategories = context.watch<ProductsProvider>().categories;
    List<String> selectedCategories =
        context.watch<ProductsProvider>().selectedCategories;
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("CATEGORY FILTER",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text("All",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value:
                              allCategories.length == selectedCategories.length,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                context
                                    .read<ProductsProvider>()
                                    .updateSelectedCategories(allCategories);
                              } else {
                                context
                                    .read<ProductsProvider>()
                                    .updateSelectedCategories([]);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 254,
                child: ListView(
                  children: allCategories
                      .map((e) => CheckboxListTile(
                            value: selectedCategories.contains(e),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  selectedCategories = [
                                    ...selectedCategories,
                                    e
                                  ];
                                } else {
                                  selectedCategories = selectedCategories
                                      .where((element) => element != e)
                                      .toList();
                                }
                                context
                                    .read<ProductsProvider>()
                                    .updateSelectedCategories(
                                        selectedCategories);
                              });
                            },
                            title: Text(e),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Widget _buildSearchBar(BuildContext context) {
  //   return Container(
  //     width: 200,
  //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
  //     decoration: BoxDecoration(
  //       // color: Colors.grey.shade300,
  //       borderRadius: BorderRadius.circular(50),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: searchController,
  //             onChanged: (value) {
  //               context.read<ProductsProvider>().updateSearchQuery(value);
  //             },
  //             decoration: const InputDecoration(
  //                 prefixIcon: Icon(Icons.search),
  //                 border: InputBorder.none,
  //                 hintText: "Search ..."),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildResetButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.read<ProductsProvider>().resetFilters();
        searchController.clear();
      },
      icon: const Icon(Icons.refresh),
      label: const Text('Reset'),
    );
  }
}
