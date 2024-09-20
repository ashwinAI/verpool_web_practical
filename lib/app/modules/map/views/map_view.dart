import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('MapView'),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verloop Web',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From :  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.areaName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To :  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '614, Western Business Park, Udhana - Magdalla Rd, opposite SD Jain School, Vesu, Surat, Gujarat 395007',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distance :  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (controller.distance ?? "").toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                30.verticalSpace,
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: 200,
                  width: double.infinity,
                  child: controller.currentLocation != null
                      ? GoogleMap(
                          initialCameraPosition: controller.initialCameraPosition(),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          onTap: (argument) {
                            controller.launchGoogleMaps();
                          },
                          mapToolbarEnabled: false,
                          onMapCreated: (GoogleMapController mController) {
                            controller.newController = mController;
                          },
                          minMaxZoomPreference: const MinMaxZoomPreference(7.35, 18),
                          markers: Set<Marker>.of(controller.markers),
                          myLocationButtonEnabled: false,
                        )
                      : const SizedBox(
                          height: 60,
                          width: 60,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
