// import 'package:flutter/material.dart';

// class PostList extends StatelessWidget {

//   const PostList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/providers/products_provider.dart';
import 'package:openzo_frontend/src/store_page/widgets/post/post_card.dart';

import 'package:provider/provider.dart';

class PostList extends StatelessWidget {
  PostList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ProductsProvider>(
          builder: (context, productsProvider, child) {
            List<Product> posts = productsProvider.posts;

            return Stack(
              children: [
                Column(
                  children: [
                    // FilterBar(),
                    Expanded(
                      child: posts.isNotEmpty
                          ? ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return PostCard(
                                  product: posts[index],
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error, size: 48),
                                  const SizedBox(height: 6),
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "NO POSTS FOUND",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        // TextSpan(
                                        //     text: "ADD POSTT",
                                        //     style: TextStyle(
                                        //         color: Colors.black,
                                        //         fontWeight: FontWeight.bold)),
                                        // TextSpan(
                                        //     text: " to add a new post",
                                        //     style:
                                        //         TextStyle(color: Colors.black))
                                      ],
                                    ),
                                  ),
                                  const Text(
                                      "The Store has not yet posted anything.")
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            );
          },
          child: const CircularProgressIndicator(),
        ));
  }
}
