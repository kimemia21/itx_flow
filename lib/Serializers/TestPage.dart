import 'package:flutter/material.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/requests/HomepageRequest.dart';

class CommodityListPage extends StatelessWidget {
  // final String keyword;

  CommodityListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commodities'),
      ),
      body: FutureBuilder<List<CommodityModel>>(
        future: CommodityService.fetchCommodities(context, "keyword"), // Fetching the data
        builder: (context, snapshot) {
          // Check for loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // Once data is available, build the list
          if (snapshot.hasData) {
            final commodities = snapshot.data!;
            return ListView.builder(
              itemCount: commodities.length,
              itemBuilder: (context, index) {
                final commodity = commodities[index];
                return ListTile(
                  leading: Image.network(
                    commodity.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  title: Text(commodity.name),
                  subtitle: Text(commodity.description),
                  trailing: Text(commodity.packagingName),
                  onTap: () {
                    // Handle tap
                    print('Tapped on ${commodity.name}');
                  },
                );
              },
            );
          }

          // In case there's no data or some other issue
          return Center(child: Text('No commodities found.'));
        },
      ),
    );
  }
}
