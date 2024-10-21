import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/repositories/product_repository.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/store/widgets/post/post_card.dart';
import 'package:provider/provider.dart';

class BytesPage extends StatefulWidget {
  const BytesPage({super.key});

  @override
  State<BytesPage> createState() => _BytesPageState();
}

class _BytesPageState extends State<BytesPage> {
  @override
  Widget build(BuildContext context) {
    String pincode =
        Provider.of<UserProvider>(context).user?.pincode ?? '123456';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Bytes'),
      ),
      body: FutureBuilder(
          future: ProductRepository.fetchPostByPincode(pincode),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(
                    product: snapshot.data![index].post,
                    store: snapshot.data![index].store,
                  );
                },
              );
            }
          }),
    );
  }
}
