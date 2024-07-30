import 'package:build_app/page/main/custom_main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class accountPage extends StatefulWidget {
  const accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

class _accountPageState extends State<accountPage> {
  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 36.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    Center(
                      child: Text(
                        'Status Peminjaman',
                        style: GoogleFonts.inter(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    // --- header --
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- Searchbar ---
                        searchbar(),
                        // --- Filter ---
                        filterbar()
                      ],
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

// --- Kelas Filter ---
class filterbar extends StatelessWidget {
  const filterbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.0,
      width: 82.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: const Color(0xFFDDDEE3),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10.0,
          ),
          const Icon(
            MingCute.filter_line,
            color: Color(0xFF09244B),
            size: 12.0,
          ),
          const SizedBox(
            width: 4.5,
          ),
          Text(
            "Filter",
            style: GoogleFonts.inter(
              color: const Color(0xFF999999),
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }
}

// --- Kelas Searchbar ---
class searchbar extends StatefulWidget {
  const searchbar({
    super.key,
  });

  @override
  State<searchbar> createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 253.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
        border: Border.all(
          color: const Color(0xFFDDDEE3),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10.0,
          ),
          const Icon(
            MingCute.search_line,
            size: 12.0,
            color: Color(0xFF09244B),
          ),
          const SizedBox(
            width: 4.45,
          ),
          Text(
            "Cari keperluan",
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF999999),
            ),
          )
        ],
      ),
    );
  }
}
