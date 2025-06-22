import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/features/authentication/view/widgets/custom_text_form_field.dart';
import 'package:meals_app/generated/l10n.dart';

class CitySelector extends StatefulWidget {
  final String? initialCity;
  final String? initialArea;
  final String? initialAddress;
  final ValueChanged<String>? onCityChanged;
  final ValueChanged<String>? onAreaChanged;
  final ValueChanged<String>? onAddressChanged;
  final String? Function(String?)? areaValidator;
  final String? Function(String?)? addressValidator;
  
  const CitySelector({
    Key? key,
    this.initialCity,
    this.initialArea,
    this.initialAddress,
    this.onCityChanged,
    this.onAreaChanged,
    this.onAddressChanged,
    this.areaValidator,
    this.addressValidator,
  }) : super(key: key);

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  late String? _selectedCity;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // City keys for localization
  final List<String> _cityKeys = [
    'cairo',
    'giza',
    'alexandria',
    'qalyubia',
    'monufia',
    'gharbia',
    'kafrElSheikh',
    'dakahlia',
    'sharqia',
    'damietta',
    'portSaid',
    'ismailia',
    'suez',
    'northSinai',
    'southSinai',
    'redSea',
    'faiyum',
    'beniSuef',
    'minya',
    'asyut',
    'sohag',
    'qena',
    'luxor',
    'aswan',
    'matrouh',
    'newValley',
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity ?? _cityKeys[0];
    _areaController.text = widget.initialArea ?? '';
    _addressController.text = widget.initialAddress ?? '';
  }
  
  @override
  void dispose() {
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Helper to get localized city name
  String _getLocalizedCityName(BuildContext context, String cityKey) {
    // Using dart reflection to dynamically access localization properties
    final localization = S.of(context);
    
    switch (cityKey) {
      case 'cairo': return localization.cairo;
      case 'giza': return localization.giza;
      case 'alexandria': return localization.alexandria;
      case 'qalyubia': return localization.qalyubia;
      case 'monufia': return localization.monufia;
      case 'gharbia': return localization.gharbia;
      case 'kafrElSheikh': return localization.kafrElSheikh;
      case 'dakahlia': return localization.dakahlia;
      case 'sharqia': return localization.sharqia;
      case 'damietta': return localization.damietta;
      case 'portSaid': return localization.portSaid;
      case 'ismailia': return localization.ismailia;
      case 'suez': return localization.suez;
      case 'northSinai': return localization.northSinai;
      case 'southSinai': return localization.southSinai;
      case 'redSea': return localization.redSea;
      case 'faiyum': return localization.faiyum;
      case 'beniSuef': return localization.beniSuef;
      case 'minya': return localization.minya;
      case 'asyut': return localization.asyut;
      case 'sohag': return localization.sohag;
      case 'qena': return localization.qena;
      case 'luxor': return localization.luxor;
      case 'aswan': return localization.aswan;
      case 'matrouh': return localization.matrouh;
      case 'newValley': return localization.newValley;
      default: return cityKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = S.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // City dropdown
        Text(
          localization.selectYourCity,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: theme.primaryColor,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCity,
              hint: Text(localization.selectYourCity),
              icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface),
              items: _cityKeys.map((String cityKey) {
                return DropdownMenuItem<String>(
                  value: cityKey,
                  child: Text(_getLocalizedCityName(context, cityKey)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                });
                if (widget.onCityChanged != null && newValue != null) {
                  widget.onCityChanged!(newValue);
                }
              },
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16.sp,
              ),
              dropdownColor: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Area field
        CustomTextFormField(
          controller: _areaController,
          labelText: localization.area,
          hintText: localization.areaHint,
          validator: widget.areaValidator,
          onChanged: widget.onAreaChanged,
          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey),
        ),
        
        SizedBox(height: 16.h),
        
        // Street and building field
        CustomTextFormField(
          controller: _addressController,
          labelText: localization.streetAndBuilding,
          hintText: localization.streetAndBuildingHint,
          validator: widget.addressValidator,
          onChanged: widget.onAddressChanged,
          prefixIcon: Icon(Icons.home_outlined, color: Colors.grey),
          maxLines: 2,
          minLines: 1,
        ),
      ],
    );
  }
} 