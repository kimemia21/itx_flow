import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

class DocumentsVerification extends StatefulWidget {
  const DocumentsVerification();

  @override
  State<DocumentsVerification> createState() => _DocumentsVerificationState();
}

class _DocumentsVerificationState extends State<DocumentsVerification> {
  Widget _buildDocsType({
    required String title,
    required String subtitle,
    required VoidCallback action,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isSmallScreen = maxWidth < 600;

        return GestureDetector(
          onTap: action,
          child: Container(
            margin: EdgeInsets.only(top: isSmallScreen ? 5 : 10),
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: isSmallScreen ? 40 : 60,
                    width: isSmallScreen ? 40 : 60,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.file_copy, size: isSmallScreen ? 20 : 24),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isSmallScreen ? 12 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Icon(Icons.arrow_forward, size: isSmallScreen ? 20 : 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetching the user role directly from the appBloc using context.watch
    final int user_type = context.watch<appBloc>().user_type;
    final bool isWareHouse = context.watch<appBloc>().user_id == 6;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Documents",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        elevation: 5,
        shadowColor: Colors.greenAccent,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Upload Documents",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildDocsType(
                title: user_type == 3 ? "AuthorizationStatus" : "Compliance",
                subtitle: user_type == 3
                    ? "Add a document to prove you are authorized to buy these products: ${context.watch<appBloc>().userCommodities.join(',')}"
                    : "Add a document to prove these products are eligible for sale: ${context.watch<appBloc>().userCommodities.join(',')}",
                action: () {
                  Globals.switchScreens(
                      context: context,
                      screen: Regulators(
                        isWareHouse: isWareHouse,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
