import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/constants.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<GlobalKey> keys =
      List.generate(GlobalConsts.categories.length, (index) => GlobalKey());

  int currentSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: const Offset(-2, -1),
                ),
              ],
// color: GlobalStyle.primaryColor.withOpacity(1),
// color: Color(0xFFFFFCF2),
              color: const Color.fromARGB(255, 247, 240, 215),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 76,
                child: Column(
                  children: [
                    const SizedBox(height: 42),
                    ...GlobalConsts.categories
                        .map((e) => InkWell(
                              onTap: () {
                                Scrollable.ensureVisible(
                                  keys[GlobalConsts.categories.indexOf(e)]
                                      .currentContext!,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeOut,
                                );
                                setState(() {
                                  currentSelected =
                                      GlobalConsts.categories.indexOf(e);
                                });
                              },
                              child: Container(
                                width: double.maxFinite,
                                decoration: currentSelected ==
                                        GlobalConsts.categories.indexOf(e)
                                    ? const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      )
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/Categories page/${e.name}.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text(e.name,
                                          textAlign: TextAlign.center,
                                          style: currentSelected ==
                                                  GlobalConsts.categories
                                                      .indexOf(e)
                                              ? const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                )
                                              : const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                )),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  ...GlobalConsts.categories
                      .map(
                        (category) => SliverToBoxAdapter(
                          key: keys[GlobalConsts.categories.indexOf(category)],
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GridView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.8,
// crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  children: category.subCategories
                                      .map((e) => InkWell(
                                            onTap: () {
                                              context.go(
                                                  '/category/${category.name}?subCategory=${e.name}');
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color: const Color(
                                                          0xffe5f3f3)

                                                      // color: Colors.blue.shade50
                                                      //     .withOpacity(0.6),

                                                      // color: GlobalStyle
                                                      //     .tertiaryColor
                                                      //     .withOpacity(0.1))
                                                      ),
                                                  child: Image.asset(
                                                    "assets/images/Categories page/${category.name}/${e.name}.png",
                                                    width: 42,
                                                    height: 42,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    e.name,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const Divider()
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
