import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/components/globalSearchDelegate.dart';
import 'package:openzo_frontend/constants/styles.dart';
// import 'package/constants/styles.dart';
// import 'package/src/search/globalSearchDelegate.dart';

class GlobalSearchBar extends StatelessWidget {
  const GlobalSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color(0xffffffff),
              border: Border.all(
                color: const Color(0xffdddddd),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0f000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ]),
          child: Center(
            child: TextField(
              onTap: () {
                showSearch(context: context, delegate: GlobalSearchDelegate());
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                // filled: true,
                // fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ImageIcon(
                    AssetImage('assets/icons/search.png'),
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(),
                hintText: 'Search for products, stores ...',

                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                ),
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
