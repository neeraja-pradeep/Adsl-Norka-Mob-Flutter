import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/provider/hospital_provider.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  String selectedStateId = '';
  String selectedStateName = 'All States';
  String selectedCityId = '';
  String selectedCityName = 'All Cities';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _hasClickedGetHospitals = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );
    // Only load states if not already loaded
    if (hospitalProvider.statesDetails.isEmpty) {
      await hospitalProvider.getStatesDetails();
    }
  }

  List<Map<String, dynamic>> get states {
    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );
    if (hospitalProvider.statesDetails['data'] != null && 
        hospitalProvider.statesDetails['data']['data'] != null) {
      final statesData = hospitalProvider.statesDetails['data']['data'] as List; 
      return [
        {'STATE_TYPE_ID': '', 'STATE_NAME': 'All States'},
        ...statesData,
      ];
    }
    return [
      {'STATE_TYPE_ID': '', 'STATE_NAME': 'All States'},
    ];
  }

  List<Map<String, dynamic>> get cities {
    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );
    if (selectedStateId.isEmpty) {
      return [
        {'CITY_TYPE_ID': '', 'CITY_DESCRIPTION': 'All Cities'},
      ];
    }

    if (hospitalProvider.citiesDetails['data'] != null && 
        hospitalProvider.citiesDetails['data']['data'] != null) {
      final citiesData = hospitalProvider.citiesDetails['data']['data'] as List;
      return [
        {'CITY_TYPE_ID': '', 'CITY_DESCRIPTION': 'All Cities'},
        ...citiesData,
      ];
    }
    return [
      {'CITY_TYPE_ID': '', 'CITY_DESCRIPTION': 'All Cities'},
    ];
  }

  List<Map<String, dynamic>> get hospitals {
    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );
    if (hospitalProvider.hospitalResponse != null &&
        hospitalProvider.hospitalResponse!['data'] != null) {
      // Check if data is already a List (direct array) or nested in another 'data' key
      var data = hospitalProvider.hospitalResponse!['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['data'] != null && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  List<Map<String, dynamic>> get filteredHospitals {
    // Don't show any hospitals unless user has clicked "Get Hospitals" button
    if (!_hasClickedGetHospitals) {
      return [];
    }

    // Don't show any hospitals if both state and city are not selected
    if (selectedStateId.isEmpty || selectedCityId.isEmpty) {
      return [];
    }

    return hospitals.where((hospital) {
      bool matchesSearch =
          searchQuery.isEmpty ||
          (hospital['hospitalName']?.toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ??
              false) ||
          (hospital['address1']?.toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ??
              false);

      // Filter by state name since stateId is null in API response
      bool matchesState =
          hospital['stateName']?.toString().toUpperCase() ==
          selectedStateName.toUpperCase();

      // Filter by city name
      bool matchesCity =
          hospital['cityName']?.toString().toUpperCase() ==
          selectedCityName.toUpperCase();

      return matchesSearch && matchesState && matchesCity;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoIcons.back
                : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText(
          text: 'Hospitals',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white,
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Consumer<HospitalProvider>(
        builder: (context, hospitalProvider, child) {
          return Column(
            children: [
              // Search and Filter Section
              _buildSearchAndFilterSection(isDarkMode, hospitalProvider),

              // Hospital List
              Expanded(
                child: hospitalProvider.isLoading
                    ? _buildLoadingState(isDarkMode)
                    : filteredHospitals.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredHospitals.length,
                        itemBuilder: (context, index) {
                          return _buildHospitalCard(
                            filteredHospitals[index],
                            isDarkMode,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilterSection(
    bool isDarkMode,
    HospitalProvider hospitalProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : const Color.fromARGB(255, 131, 127, 127).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search hospitals...',
              hintStyle: TextStyle(color: AppConstants.greyColor, fontSize: 16),
              prefixIcon: Icon(Icons.search, color: AppConstants.greyColor),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppConstants.greyColor),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppConstants.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              color: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          // Filter Row
          Row(
            children: [
              // State Filter
              Expanded(
                child: _buildStateFilterDropdown(isDarkMode, hospitalProvider),
              ),

              const SizedBox(width: 12),

              // City Filter
              Expanded(
                child: _buildCityFilterDropdown(isDarkMode, hospitalProvider),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Get Hospitals Button
          CustomButton(
            text: 'Get Hospitals',
            onPressed: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                ? () async {
                    await _fetchHospitals();
                  }
                : () {}, // Empty function when disabled
            color: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                ? AppConstants.primaryColor
                : isDarkMode
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            textColor: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                ? AppConstants.whiteColor
                : isDarkMode
                ? Colors.grey.withOpacity(0.6)
                : Colors.grey.withOpacity(0.7),
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildStateFilterDropdown(
    bool isDarkMode,
    HospitalProvider hospitalProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'State',
          size: 14,
          weight: FontWeight.w500,
          textColor: AppConstants.greyColor,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStateName,
              isExpanded: true,
              dropdownColor: isDarkMode
                  ? AppConstants.boxBlackColor
                  : Colors.white,
              items: states.map((Map<String, dynamic> state) {
                return DropdownMenuItem<String>(
                  value: state['STATE_NAME'],
                  child: AppText(
                    text: state['STATE_NAME'],
                    size: 14,
                    weight: FontWeight.normal,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                );
              }).toList(),
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    selectedStateName = value;
                    selectedStateId = states.firstWhere(
                      (s) => s['STATE_NAME'] == value,
                    )['STATE_TYPE_ID'];
                    selectedCityName = 'All Cities';
                    selectedCityId = '';
                    _hasClickedGetHospitals =
                        false; // Reset flag when state changes
                  });

                  if (selectedStateId.isNotEmpty) {
                    await hospitalProvider.getCitiesDetails(selectedStateId);
                  }
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppConstants.greyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityFilterDropdown(
    bool isDarkMode,
    HospitalProvider hospitalProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'City',
          size: 14,
          weight: FontWeight.w500,
          textColor: AppConstants.greyColor,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCityName,
              isExpanded: true,
              dropdownColor: isDarkMode
                  ? AppConstants.boxBlackColor
                  : Colors.white,
              items: cities.map((Map<String, dynamic> city) {
                return DropdownMenuItem<String>(
                  value: city['CITY_DESCRIPTION'],
                  child: AppText(
                    text: city['CITY_DESCRIPTION'],
                    size: 14,
                    weight: FontWeight.normal,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                );
              }).toList(),
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    selectedCityName = value;
                    selectedCityId = cities.firstWhere(
                      (c) => c['CITY_DESCRIPTION'] == value,
                    )['CITY_TYPE_ID'];
                    _hasClickedGetHospitals =
                        false; // Reset flag when city changes
                  });
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppConstants.greyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchHospitals() async {
    // Only fetch hospitals if both state and city are selected
    if (selectedStateId.isEmpty || selectedCityId.isEmpty) {
      return;
    }

    // Set flag to indicate user has clicked "Get Hospitals"
    setState(() {
      _hasClickedGetHospitals = true;
    });

    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );
    final requestData = {
      'hospital_name': '',
      'state_id': selectedStateId, 
      'city_id': selectedCityId
    };
    await hospitalProvider.getHospitals(requestData);
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Name and Preferred Badge
            Row(
              children: [
                Expanded(
                  child: AppText(
                    text:
                        hospital['hospitalName'] ??
                        'Hospital Name Not Available',
                    size: 18,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
                if (hospital['preferredYN'] == 'Y')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.greenColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: AppText(
                      text: 'Preferred',
                      size: 12,
                      weight: FontWeight.w500,
                      textColor: AppConstants.greenColor,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Address
            if (hospital['address1'] != null &&
                hospital['address1'].toString().isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppConstants.greyColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: AppText(
                      text: hospital['address1'],
                      size: 14,
                      weight: FontWeight.normal,
                      textColor: AppConstants.greyColor,
                    ),
                  ),
                ],
              ),

            if (hospital['address1'] != null &&
                hospital['address1'].toString().isNotEmpty)
              const SizedBox(height: 8),

            // Phone
            if (hospital['phHosp1'] != null &&
                hospital['phHosp1'].toString().isNotEmpty)
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: AppConstants.greyColor),
                  const SizedBox(width: 4),
                  AppText(
                    text: hospital['phHosp1'],
                    size: 14,
                    weight: FontWeight.normal,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ),

            if (hospital['phHosp1'] != null &&
                hospital['phHosp1'].toString().isNotEmpty)
              const SizedBox(height: 8),

            // Email
            if (hospital['hospEmailID'] != null &&
                hospital['hospEmailID'].toString().isNotEmpty)
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: AppConstants.greyColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: AppText(
                      text: hospital['hospEmailID'],
                      size: 14,
                      weight: FontWeight.normal,
                      textColor: AppConstants.greyColor,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Location and Pincode
            Row(
              children: [
                // City and State
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 16,
                        color: AppConstants.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          text:
                              '${hospital['cityName'] ?? ''}, ${hospital['stateName'] ?? ''}',
                          size: 14,
                          weight: FontWeight.w500,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Pincode
                if (hospital['pincode'] != null &&
                    hospital['pincode'].toString().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: AppText(
                      text: 'PIN: ${hospital['pincode']}',
                      size: 12,
                      weight: FontWeight.w500,
                      textColor: AppConstants.primaryColor,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppConstants.primaryColor),
          const SizedBox(height: 16),
          AppText(
            text: 'Loading hospitals...',
            size: 16,
            weight: FontWeight.w500,
            textColor: AppConstants.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital_outlined,
            size: 80,
            color: AppConstants.greyColor,
          ),
          const SizedBox(height: 16),
          AppText(
            text: 'No hospitals found',
            size: 18,
            weight: FontWeight.w500,
            textColor: AppConstants.greyColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'Try selecting a different state or city',
            size: 14,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
        ],
      ),
    );
  }
}
