// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:clmgpx/screens/offlin_region_map.dart';

final LatLngBounds capeTownBounds = LatLngBounds(
  southwest: const LatLng(-34.6503, 18.2324),
  northeast: const LatLng(-33.5992, 20.1664),
);

List<OfflineRegionDefinition> regionDefinitions = [
  OfflineRegionDefinition(
    bounds: capeTownBounds,
    minZoom: 10,
    maxZoom: 15,
    mapStyleUrl: "mapbox://styles/arazetdesign/clij33z5j00c201r17cdrejen",
  ),
];

List<String> regionNames = ['CapeTown'];

class OfflineRegionListItem {
  OfflineRegionListItem({
    required this.offlineRegionDefinition,
    required this.downloadedId,
    required this.isDownloading,
    required this.name,
    required this.estimatedTiles,
  });

  final OfflineRegionDefinition offlineRegionDefinition;
  final int? downloadedId;
  final bool isDownloading;
  final String name;
  final int estimatedTiles;

  OfflineRegionListItem copyWith({
    int? downloadedId,
    bool? isDownloading,
  }) =>
      OfflineRegionListItem(
        offlineRegionDefinition: offlineRegionDefinition,
        name: name,
        estimatedTiles: estimatedTiles,
        downloadedId: downloadedId,
        isDownloading: isDownloading ?? this.isDownloading,
      );

  bool get isDownloaded => downloadedId != null;
}

final List<OfflineRegionListItem> allRegions = [
  OfflineRegionListItem(
    offlineRegionDefinition: regionDefinitions[0],
    downloadedId: null,
    isDownloading: false,
    name: regionNames[0],
    estimatedTiles: 61,
  ),
];

class OfflineRegionBody extends StatefulWidget {
  const OfflineRegionBody({super.key});

  @override
  _OfflineRegionsBodyState createState() => _OfflineRegionsBodyState();
}

class _OfflineRegionsBodyState extends State<OfflineRegionBody> {
  final List<OfflineRegionListItem> _items = [];

  @override
  void initState() {
    super.initState();
    _updateListOfRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: _items.length,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => _goToMap(_items[index]),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _items[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Est. tiles: ${_items[index].estimatedTiles}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _items[index].isDownloading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : IconButton(
                        icon: Icon(
                          _items[index].isDownloaded
                              ? Icons.delete
                              : Icons.file_download,
                        ),
                        onPressed: _items[index].isDownloaded
                            ? () => _deleteRegion(_items[index], index)
                            : () => _downloadRegion(_items[index], index),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateListOfRegions() async {
    List<OfflineRegion> offlineRegions =
        await getListOfRegions(accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN']);
    List<OfflineRegionListItem> regionItems = [];
    for (var item in allRegions) {
      final offlineRegion = offlineRegions.firstWhereOrNull(
          (offlineRegion) => offlineRegion.metadata['name'] == item.name);
      if (offlineRegion != null) {
        regionItems.add(item.copyWith(downloadedId: offlineRegion.id));
      } else {
        regionItems.add(item);
      }
    }
    setState(() {
      _items.clear();
      _items.addAll(regionItems);
    });
  }

  void _downloadRegion(OfflineRegionListItem item, int index) async {
    setState(() {
      _items.removeAt(index);
      _items.insert(index, item.copyWith(isDownloading: true));
    });

    try {
      final downloadingRegion = await downloadOfflineRegion(
        item.offlineRegionDefinition,
        metadata: {
          'name': regionNames[index],
        },
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
      );
      setState(() {
        _items.removeAt(index);
        _items.insert(
            index,
            item.copyWith(
              isDownloading: false,
              downloadedId: downloadingRegion.id,
            ));
      });
    } on Exception catch (_) {
      setState(() {
        _items.removeAt(index);
        _items.insert(
            index,
            item.copyWith(
              isDownloading: false,
              downloadedId: null,
            ));
      });
      return;
    }
  }

  void _deleteRegion(OfflineRegionListItem item, int index) async {
    setState(() {
      _items.removeAt(index);
      _items.insert(index, item.copyWith(isDownloading: true));
    });

    await deleteOfflineRegion(
      item.downloadedId!,
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
    );

    setState(() {
      _items.removeAt(index);
      _items.insert(
          index,
          item.copyWith(
            isDownloading: false,
            downloadedId: null,
          ));
    });
  }

  _goToMap(OfflineRegionListItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OfflineRegionMap(item),
      ),
    );
  }
}
