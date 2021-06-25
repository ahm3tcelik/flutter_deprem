import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/deprem.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class DepremDetailPage extends StatefulWidget {
  final Deprem deprem;

  const DepremDetailPage({Key? key, required this.deprem}) : super(key: key);

  @override
  _DepremDetailPageState createState() => _DepremDetailPageState();
}

class _DepremDetailPageState extends State<DepremDetailPage> {
  late final MapController controller;

  // Çift tıklayınca haritayı büyüt
  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  // haritayı kaydırma
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  // harita kaydırıldıktan sonra güncelle
  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  void initState() {
    // depremin olduğu alanı göster
    controller = MapController(
      location: LatLng(widget.deprem.enlem, widget.deprem.boylam),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.deprem.baslik),
        ),
        body: _buildLayout());
  }

  Widget _buildLayout() {
    return MapLayoutBuilder(
      controller: controller,
      builder: (context, transformer) {
        final homeLocation = transformer.fromLatLngToXYCoords(
            LatLng(widget.deprem.enlem, widget.deprem.boylam));
        final homeMarkerWidget = _buildMarkerWidget(homeLocation, Colors.red);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                final delta = event.scrollDelta;

                controller.zoom -= delta.dy / 1000.0;
                setState(() {});
              }
            },
            child: Stack(
              children: [
                Map(
                  controller: controller,
                  builder: (context, x, y, z) {
                    //Google Maps
                    final url =
                        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                homeMarkerWidget,
              ],
            ),
          ),
        );
      },
    );
  }

  // Deprem noktasının işaretçisi
  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(13, 13, 13, 0),
                child: Icon(
                  Icons.wifi_tethering,
                  color: color,
                  size: 35,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                child: Text(
                  widget.deprem.buyukluk,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Text(
            'Deprem Noktası',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
