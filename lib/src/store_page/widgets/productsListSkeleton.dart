import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:openzo_frontend/components/skeleton.dart';

class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.blueGrey.shade50),
        child: Accordion(
          disableScrolling: true,
          openAndCloseAnimation: false,
          contentBorderColor: Colors.transparent,
          headerBorderRadius: 0,
          headerBackgroundColor: Colors.white,
          paddingListHorizontal: 0,
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          contentVerticalPadding: 0,
          rightIcon: const Icon(
            Icons.arrow_drop_down,
            size: 32,
          ),
          maxOpenSections: 10,
          children: [1, 2, 3, 4, 5]
              .map(
                (e) => AccordionSection(
                  isOpen: true,
                  header: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Skeleton(
                      width: 100,
                      height: 20,
                    ),
                  ),
                  content: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Skeleton(
                                height: 200,
                                width: (MediaQuery.of(context).size.width * 0.5)
                                    .toInt(),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Skeleton(
                                width: 100,
                                height: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Skeleton(
                                width: 100,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
