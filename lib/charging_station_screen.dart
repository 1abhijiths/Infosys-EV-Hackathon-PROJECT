import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChargingStationHomePage extends StatefulWidget {
  @override
  _ChargingStationHomePageState createState() => _ChargingStationHomePageState();
}

class _ChargingStationHomePageState extends State<ChargingStationHomePage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  
  // Replace 'YOUR_API_KEY_HERE' with your actual Gemini API key
  static const String _apiKey = 'AIzaSyBEh_7G_0LKAu9sPMuOgxe0AfEfQQm6yOw';
  
  String _selectedVehicleType = 'Tesla';
  String _selectedPriority = 'Fastest Service';
  String _selectedServiceType = 'Both';
  bool _prioritizeRenewable = false;
  bool _showSDGMode = true;
  bool _isLoading = false;
  List<ChargingStation> _recommendations = [];
  
  // SDG tracking variables
  double _totalCO2Saved = 0;
  double _renewableEnergyUsed = 0;
  int _sustainableTrips = 0;

  final List<String> _vehicleTypes = [
    'Tesla',
    'Nissan Leaf',
    'Chevrolet Bolt',
    'BMW i3',
    'Audi e-tron',
    'Hyundai Kona Electric',
    'Ford Mustang Mach-E',
    'Volkswagen ID.4',
    'NIO ES8',
    'NIO ES6',
    'Gogoro Scooter',
    'Other CCS',
    'Other CHAdeMO'
  ];

  final List<String> _priorities = [
    'Fastest Service',
    'Shortest Detour',
    'Most Amenities',
    'Highest Rated',
    'Cheapest Price',
    'Greenest Energy', // SDG-focused priority
    'Community Impact' // SDG-focused priority
  ];

  final List<String> _serviceTypes = [
    'Both',
    'Charging Only',
    'Battery Swapping Only'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sustainable EV Journey Planner'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showSDGMode ? Icons.eco : Icons.eco_outlined),
            onPressed: () {
              setState(() {
                _showSDGMode = !_showSDGMode;
              });
            },
            tooltip: 'Toggle SDG Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showSDGMode) _buildSDGHeader(),
            if (_showSDGMode) SizedBox(height: 20),
            _buildDestinationInputs(),
            SizedBox(height: 20),
            _buildVehicleSelection(),
            SizedBox(height: 20),
            _buildServiceTypeSelection(),
            SizedBox(height: 20),
            _buildPrioritySelection(),
            if (_showSDGMode) SizedBox(height: 20),
            if (_showSDGMode) _buildSustainabilityOptions(),
            SizedBox(height: 30),
            _buildSearchButton(),
            SizedBox(height: 30),
            if (_showSDGMode) _buildSDGImpactTracker(),
            if (_showSDGMode) SizedBox(height: 20),
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildSDGHeader() {
    return Card(
      elevation: 4,
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.public, color: Colors.green[700], size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Supporting UN Sustainable Development Goals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSDGBadge('SDG 7', 'Clean Energy', Icons.wb_sunny, Colors.orange),
                _buildSDGBadge('SDG 11', 'Sustainable Cities', Icons.location_city, Colors.blue),
                _buildSDGBadge('SDG 13', 'Climate Action', Icons.eco, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSDGBadge(String sdg, String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          sdg,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSustainabilityOptions() {
    return Card(
      elevation: 4,
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sustainability Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Prioritize Renewable Energy Sources'),
              subtitle: Text('Choose stations powered by solar, wind, or other clean energy'),
              value: _prioritizeRenewable,
              onChanged: (bool? value) {
                setState(() {
                  _prioritizeRenewable = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSDGImpactTracker() {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue[700]),
                SizedBox(width: 8),
                Text(
                  'Your Environmental Impact',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImpactCard(
                    'CO₂ Saved',
                    '${_totalCO2Saved.toStringAsFixed(1)} kg',
                    Icons.cloud_off,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildImpactCard(
                    'Renewable Energy',
                    '${_renewableEnergyUsed.toStringAsFixed(1)} kWh',
                    Icons.wb_sunny,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildImpactCard(
                    'Sustainable Trips',
                    '$_sustainableTrips',
                    Icons.directions_car,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationInputs() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _startController,
              decoration: InputDecoration(
                labelText: 'Starting Location',
                hintText: 'Enter city, address, or landmark',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _endController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Enter city, address, or landmark',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedVehicleType,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.electric_car),
              ),
              items: _vehicleTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedVehicleType = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeSelection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedServiceType,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.swap_horiz),
              ),
              items: _serviceTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedServiceType = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Priority',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: _priorities.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Row(
                    children: [
                      Text(priority),
                      if (priority == 'Greenest Energy' || priority == 'Community Impact')
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.eco, size: 16, color: Colors.green),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _searchChargingStations,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
                Text('Finding Sustainable Stations...'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(width: 8),
                Text('Find Sustainable Charging Stations', style: TextStyle(fontSize: 16)),
              ],
            ),
    );
  }

  Widget _buildRecommendations() {
    if (_recommendations.isEmpty && !_isLoading) {
      return SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Sustainable Stations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ..._recommendations.map((station) => _buildStationCard(station)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStationCard(ChargingStation station) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  station.isCompatible ? Icons.check_circle : Icons.warning,
                  color: station.isCompatible ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        station.address,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            
            // Service badges row with wrapping
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Service type badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: station.isBatterySwapping ? Colors.blue[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    station.isBatterySwapping ? 'SWAP' : 'CHARGE',
                    style: TextStyle(
                      color: station.isBatterySwapping ? Colors.blue[800] : Colors.green[800],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (station.isRenewablePowered)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '100% RENEWABLE',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (station.supportsCommunity)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'COMMUNITY+',
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Info grid
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoItem(Icons.location_on, '${station.distance} km'),
                if (station.isBatterySwapping) ...[
                  _buildInfoItem(Icons.swap_horiz, '${station.estimatedTime} min swap'),
                  _buildInfoItem(Icons.battery_full, '${station.availableBatteries} batteries'),
                ] else ...[
                  _buildInfoItem(Icons.electric_bolt, '${station.chargingSpeed} kW'),
                  _buildInfoItem(Icons.access_time, '${station.estimatedTime} min'),
                ],
                _buildInfoItem(Icons.star, '${station.rating}/5.0'),
                _buildInfoItem(Icons.reviews, '${station.reviews} reviews'),
              ],
            ),
            
            if (_showSDGMode) ...[
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SDG Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildInfoItem(Icons.eco, '${station.co2Reduction} kg CO₂'),
                        if (station.isRenewablePowered)
                          _buildInfoItem(Icons.wb_sunny, station.renewableEnergyType),
                      ],
                    ),
                    if (station.supportsCommunity) ...[
                      SizedBox(height: 8),
                      Text(
                        'Community: ${station.communityBenefits}',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            
            SizedBox(height: 8),
            if (station.isBatterySwapping)
              Text(
                'Compatible: ${station.compatibleModels.join(', ')}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            else
              Text(
                'Connectors: ${station.connectorTypes.join(', ')}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            
            if (!station.isCompatible) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Not fully compatible with your vehicle',
                  style: TextStyle(color: Colors.orange[800], fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Future<void> _searchChargingStations() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      _showSnackBar('Please enter both starting location and destination');
      return;
    }

    if (_apiKey == 'YOUR_API_KEY_HERE') {
      _showSnackBar('Please replace YOUR_API_KEY_HERE with your actual Gemini API key in the code');
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendations.clear();
    });

    try {
      final recommendations = await _getChargingStationRecommendations();
      setState(() {
        _recommendations = recommendations;
        // Update SDG impact metrics
        _updateSDGMetrics();
      });
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateSDGMetrics() {
    // Calculate environmental impact based on recommendations
    double co2Saved = 0;
    double renewableEnergy = 0;
    
    for (var station in _recommendations) {
      co2Saved += station.co2Reduction;
      if (station.isRenewablePowered) {
        renewableEnergy += station.chargingSpeed * (station.estimatedTime / 60);
      }
    }
    
    setState(() {
      _totalCO2Saved += co2Saved;
      _renewableEnergyUsed += renewableEnergy;
      _sustainableTrips += 1;
    });
  }

  Future<List<ChargingStation>> _getChargingStationRecommendations() async {
    final sustainabilityContext = _prioritizeRenewable ? 
      'Prioritize stations using renewable energy sources (solar, wind, hydro).' : 
      'Include a mix of conventional and renewable energy stations.';
    
    final sdgContext = _showSDGMode ? 
      'Include SDG-related information like CO2 reduction, renewable energy types, and community benefits.' : 
      '';

    final prompt = '''
    I need exactly 3 station recommendations for a sustainable electric vehicle trip. Here are the details:

    Starting Location: ${_startController.text}
    Destination: ${_endController.text}
    Vehicle Type: $_selectedVehicleType
    Priority: $_selectedPriority
    Service Type: $_selectedServiceType
    Sustainability Focus: $sustainabilityContext
    SDG Context: $sdgContext

    Please provide exactly 3 realistic stations along the route. Include a mix of charging and battery swapping stations based on the service type preference.

    For charging stations, provide:
    - Station name (Tesla Supercharger, Electrify America, ChargePoint, etc.)
    - Complete address with city and state
    - Distance from route (0.5-10 km)
    - Charging speed (50-350 kW)
    - Estimated charging time (10-60 minutes)
    - Connector types (CCS, CHAdeMO, Tesla Supercharger, Type 2)
    - Compatibility with specified vehicle
    - Rating (3.5-5.0)
    - Reviews (50-500)
    - CO2 reduction impact (5-50 kg)
    - Renewable energy powered (true/false)
    - Renewable energy type (Solar, Wind, Hydro, Mixed, or empty if not renewable)
    - Community support (true/false)
    - Community benefits description

    For battery swapping stations, provide:
    - Station name (NIO Power Swap, Gogoro GoStation, Ample Station, etc.)
    - Complete address with city and state
    - Distance from route (0.5-10 km)
    - Estimated swapping time (3-8 minutes)
    - Available batteries count (5-20)
    - Compatible models (NIO ES8, NIO ES6, Gogoro Scooter, etc.)
    - Compatibility with specified vehicle
    - Rating (3.5-5.0)
    - Reviews (50-500)
    - CO2 reduction impact (5-50 kg)
    - Renewable energy powered (true/false)
    - Renewable energy type (Solar, Wind, Hydro, Mixed, or empty if not renewable)
    - Community support (true/false)
    - Community benefits description

    IMPORTANT: Respond with ONLY a valid JSON array. Format:
    [
      {
        "name": "Station Name",
        "address": "Complete Address",
        "distance": 2.5,
        "chargingSpeed": 150,
        "estimatedTime": 25,
        "connectorTypes": ["CCS", "CHAdeMO"],
        "isCompatible": true,
        "rating": 4.2,
        "reviews": 156,
        "isBatterySwapping": false,
        "availableBatteries": 0,
        "compatibleModels": [],
        "co2Reduction": 25.5,
        "isRenewablePowered": true,
        "renewableEnergyType": "Solar",
        "supportsCommunity": true,
        "communityBenefits": "Local job creation, educational programs"
      }
    ]
    ''';

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': _apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      
      // Extract JSON from the response
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(text);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0)!;
        final List<dynamic> stationsData = jsonDecode(jsonString);
        
        return stationsData.map((station) => ChargingStation.fromJson(station)).toList();
      } else {
        // If no JSON found, create mock data based on the response
        return _createMockStations();
      }
    } else {
      throw Exception('Failed to get recommendations from Gemini API. Status: ${response.statusCode}');
    }
  }

  List<ChargingStation> _createMockStations() {
    // Create mock stations based on vehicle type compatibility and service type
    bool teslaCompatible = _selectedVehicleType == 'Tesla';
    bool ccsCompatible = _selectedVehicleType != 'Nissan Leaf';
    bool chademoCompatible = _selectedVehicleType == 'Nissan Leaf' || _selectedVehicleType.contains('CHAdeMO');
    bool nioCompatible = _selectedVehicleType.contains('NIO');
    bool gogoroCompatible = _selectedVehicleType.contains('Gogoro');

    List<ChargingStation> stations = [];

    // Add charging stations if needed
    if (_selectedServiceType == 'Both' || _selectedServiceType == 'Charging Only') {
      stations.addAll([
        ChargingStation(
          name: 'Tesla Solar Supercharger',
          address: 'Green Energy Plaza, Exit 42',
          distance: 1.2,
          chargingSpeed: 250,
          estimatedTime: 15,
          connectorTypes: ['Tesla Supercharger'],
          isCompatible: teslaCompatible,
          rating: 4.8,
          reviews: 324,
          isBatterySwapping: false,
          availableBatteries: 0,
          compatibleModels: [],
          co2Reduction: 35.2,
          isRenewablePowered: true,
          renewableEnergyType: 'Solar',
          supportsCommunity: true,
          communityBenefits: 'Local job creation, educational programs',
        ),
        ChargingStation(
          name: 'Electrify America WindPower',
          address: 'Sustainable Mall, 1234 Green St',
          distance: 3.8,
          chargingSpeed: 150,
          estimatedTime: 30,
          connectorTypes: ['CCS', 'CHAdeMO'],
          isCompatible: ccsCompatible || chademoCompatible,
          rating: 4.2,
          reviews: 187,
          isBatterySwapping: false,
          availableBatteries: 0,
          compatibleModels: [],
          co2Reduction: 28.7,
          isRenewablePowered: true,
          renewableEnergyType: 'Wind',
          supportsCommunity: false,
          communityBenefits: '',
        ),
      ]);
    }

    // Add battery swapping stations if needed
    if (_selectedServiceType == 'Both' || _selectedServiceType == 'Battery Swapping Only') {
      stations.addAll([
        ChargingStation(
          name: 'NIO Power Swap EcoStation',
          address: 'Innovation Park, 789 Tech Dr',
          distance: 2.5,
          chargingSpeed: 0,
          estimatedTime: 5,
          connectorTypes: [],
          isCompatible: nioCompatible,
          rating: 4.6,
          reviews: 142,
          isBatterySwapping: true,
          availableBatteries: 15,
          compatibleModels: ['NIO ES8', 'NIO ES6', 'NIO ET7'],
          co2Reduction: 42.1,
          isRenewablePowered: true,
          renewableEnergyType: 'Solar',
          supportsCommunity: true,
          communityBenefits: 'Workforce development, local partnerships',
        ),
        ChargingStation(
          name: 'Gogoro Green GoStation',
          address: 'Eco Center, 456 Sustainable Ave',
          distance: 4.1,
          chargingSpeed: 0,
          estimatedTime: 3,
          connectorTypes: [],
          isCompatible: gogoroCompatible,
          rating: 4.4,
          reviews: 89,
          isBatterySwapping: true,
          availableBatteries: 8,
          compatibleModels: ['Gogoro Scooter', 'Gogoro VIVA'],
          co2Reduction: 15.3,
          isRenewablePowered: true,
          renewableEnergyType: 'Mixed',
          supportsCommunity: true,
          communityBenefits: 'Urban mobility solutions, air quality improvement',
        ),
      ]);
    }

    // If we don't have enough stations, add a generic one
    if (stations.length < 3) {
      stations.add(
        ChargingStation(
          name: 'ChargePoint Community Hub',
          address: 'Downtown Center, 567 Oak Ave',
          distance: 5.2,
          chargingSpeed: 50,
          estimatedTime: 60,
          connectorTypes: ['CCS', 'Type 2'],
          isCompatible: ccsCompatible,
          rating: 4.0,
          reviews: 93,
          isBatterySwapping: false,
          availableBatteries: 0,
          compatibleModels: [],
          co2Reduction: 18.9,
          isRenewablePowered: false,
          renewableEnergyType: '',
          supportsCommunity: true,
          communityBenefits: 'Community events, local business support',
        ),
      );
    }

    return stations.take(3).toList();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}

class ChargingStation {
  final String name;
  final String address;
  final double distance;
  final int chargingSpeed;
  final int estimatedTime;
  final List<String> connectorTypes;
  final bool isCompatible;
  final double rating;
  final int reviews;
  final bool isBatterySwapping;
  final int availableBatteries;
  final List<String> compatibleModels;
  final double co2Reduction;
  final bool isRenewablePowered;
  final String renewableEnergyType;
  final bool supportsCommunity;
  final String communityBenefits;

  ChargingStation({
    required this.name,
    required this.address,
    required this.distance,
    required this.chargingSpeed,
    required this.estimatedTime,
    required this.connectorTypes,
    required this.isCompatible,
    required this.rating,
    required this.reviews,
    required this.isBatterySwapping,
    required this.availableBatteries,
    required this.compatibleModels,
    required this.co2Reduction,
    required this.isRenewablePowered,
    required this.renewableEnergyType,
    required this.supportsCommunity,
    required this.communityBenefits,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      name: json['name'] ?? 'Unknown Station',
      address: json['address'] ?? 'Address not available',
      distance: (json['distance'] ?? 0).toDouble(),
      chargingSpeed: json['chargingSpeed'] ?? 0,
      estimatedTime: json['estimatedTime'] ?? 0,
      connectorTypes: List<String>.from(json['connectorTypes'] ?? []),
      isCompatible: json['isCompatible'] ?? false,
      rating: (json['rating'] ?? 4.0).toDouble(),
      reviews: json['reviews'] ?? 0,
      isBatterySwapping: json['isBatterySwapping'] ?? false,
      availableBatteries: json['availableBatteries'] ?? 0,
      compatibleModels: List<String>.from(json['compatibleModels'] ?? []),
      co2Reduction: (json['co2Reduction'] ?? 0).toDouble(),
      isRenewablePowered: json['isRenewablePowered'] ?? false,
      renewableEnergyType: json['renewableEnergyType'] ?? '',
      supportsCommunity: json['supportsCommunity'] ?? false,
      communityBenefits: json['communityBenefits'] ?? '',
    );
  }
}