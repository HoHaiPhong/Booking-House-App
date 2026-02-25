import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/property_model.dart';
import '../../services/property_service.dart';
import '../../services/api_service.dart';

class AdminPropertyScreen extends StatefulWidget {
  const AdminPropertyScreen({super.key});

  @override
  State<AdminPropertyScreen> createState() => _AdminPropertyScreenState();
}

class _AdminPropertyScreenState extends State<AdminPropertyScreen> {
  late Future<List<Property>> _propertiesFuture;
  final PropertyService _propertyService = PropertyService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshProperties();
  }

  void _refreshProperties() {
    setState(() {
      _propertiesFuture = _propertyService.getAllProperties();
    });
  }

  Future<void> _deleteProperty(int id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      // Direct API call for delete as PropertyService might lack it currently
      await _apiService.delete('/properties/$id'); 
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Deleted successfully')),
      );
      _refreshProperties();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error deleting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No properties found."));
          }

          final properties = snapshot.data!;
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Dismissible(
                key: Key(property.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you want to delete this specific listing?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  _deleteProperty(property.id);
                },
                child: ListTile(
                  leading: property.images.isNotEmpty 
                    ? Image.network(property.images[0], width: 50, height: 50, fit: BoxFit.cover, 
                        errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported)) 
                    : const Icon(Icons.home),
                  title: Text(property.name),
                  subtitle: Text("${property.price} VND - ${property.address}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Navigate to Edit Screen
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Edit feature coming soon")));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Property feature coming soon")));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
