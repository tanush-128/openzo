import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/models/store.dart';

class StoreCard extends StatefulWidget {
  Store store;
  StoreCard({super.key, required this.store});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        context.go('/store/${widget.store.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
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
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  // image: AssetImage('assets/images/store.jpeg'),
                  image: NetworkImage(widget.store.image),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.s
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(widget.store.storeType.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ))),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    child: isFavourite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
            // const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 280,
                          child: Text(
                            widget.store.name,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                overflow: TextOverflow.visible,
                              ),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 55,
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Row(children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 5),
                            Text(
                              '4.5',
                              style: TextStyle(
                                // overflow: TextOverflow.fade,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Text(
                          'Store Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
