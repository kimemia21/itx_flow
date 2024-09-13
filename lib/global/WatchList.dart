import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/global/AnimatedButton.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, dynamic> data = context.watch<appBloc>().watchList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,

        
        title: Text(
          'Watchlist',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: data.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                 physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<int,dynamic>  content = data[index + 1];
                  return _buildWatchlistItem(content[index+1]);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.watch_later_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Your watchlist is empty",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add items to your watchlist to see them here",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistItem(Map<String,dynamic> content) {
    int contractId = content["contractId"];
    String contractType = content["contractType"];
    String title = content["title"];
    String product = content["product"];
    int qualityGradeId = content["qualityGradeId"];
    DateTime deliveryDate = content["deliveryDate"];
    double price = content["price"];
    String description = content["description"];
    String imageUrl = content["imageUrl"];

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                    _buildContractTypeChip(contractType),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoChip(Icons.grade, "Grade: $qualityGradeId"),
                    _buildInfoChip(Icons.calendar_today,
                        "Delivery: ${DateFormat('MMM d, y').format(deliveryDate)}"),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contract #$contractId",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        _buildPriceTag(price),
                        SizedBox(width: 8),
                        LikeButton(
                          contractId: contractId,
                          data: {contractId: content},
                          onLikeChanged: (isLiked) {
                            print(
                                'Contract $contractId is ${isLiked ? 'liked' : 'unliked'}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractTypeChip(String contractType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        contractType,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green.shade600),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceTag(double price) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "\$${price.toStringAsFixed(2)}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.green.shade700,
        ),
      ),
    );
  }
}