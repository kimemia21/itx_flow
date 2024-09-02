import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Regulator.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class DocumentsVerification extends StatefulWidget {
  const DocumentsVerification();

  @override
  State<DocumentsVerification> createState() => _DocumentsVerificationState();
}

class _DocumentsVerificationState extends State<DocumentsVerification> {
  Future<String?> _fetchRole() async {
    try {
      await context.read<CurrentUserProvider>().changeRole(context: context);
      return context.read<CurrentUserProvider>().role;
    } catch (e) {
      print("Error fetching role: $e");
      return null;
    }
  }

  Widget _buildDocsType({
    required String title,
    required String subtitle,
    required VoidCallback action,
  }) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.file_copy),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Center(child: Icon(Icons.arrow_forward)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Documents",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _fetchRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No role found"));
          } else {
            final _role = snapshot.data!;
            return Container(
              margin: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "Upload Documents",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _buildDocsType(
                      title: _role == "Buyer" ? "Authorization" : "Compliance",
                      subtitle: _role == "Buyer"
                          ? "Add a document to prove you are authorized to buy these products: ${context.watch<appBloc>().userCommodities.join(',')}"
                          : "Add a document to prove these products are eligible for sale: ${context.watch<appBloc>().userCommodities.join(',')}",
                      action: () {
                        Globals.switchScreens(
                            context: context, screen: Regulators());
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
