import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/components/skeleton.dart';
import 'package:openzo_frontend/constants/styles.dart';

class StoreDetailsSkeleton extends StatelessWidget {
  const StoreDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              // color: Colors.white,
              color: const Color(0xFFCFCDCA),
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.photo, color: Colors.grey.shade300, size: 32),
          ),
          const SizedBox(height: 5),
          Skeleton(
            height: 24,
          ),
          const SizedBox(height: 8),
          Skeleton(
            height: 20,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    GlobalStyle.secondaryColor.withOpacity(0.5),
                    Colors.white
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
