import 'package:eco_picker/data/garbage.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';

class MapBottomSheet extends StatefulWidget {
  final GarbageLocation? garbageLocation;

  MapBottomSheet({required this.garbageLocation});

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        key: _sheet,
        initialChildSize: 0.10,
        maxChildSize: 1,
        minChildSize: 0,
        expand: true,
        snap: true,
        snapSizes: [
          60 / constraints.maxHeight,
          0.5,
        ],
        controller: _controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Color(0xFF6BBD6E),
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Color(0xFF6BBD6E),
                        surfaceTintColor: Color(0xFF6BBD6E),
                        expandedHeight: 45,
                        collapsedHeight: 45,
                        toolbarHeight: 45,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text('Garbage List',
                              style: headingWhiteTextStyle()),
                        ),
                      ),
                      SliverList.builder(
                        itemCount:
                            widget.garbageLocation?.garbageLocations.length ??
                                0,
                        itemBuilder: (BuildContext context, int index) {
                          final garbage =
                              widget.garbageLocation!.garbageLocations[index];
                          return Container(
                            color: Color(0xFFFAFAFA),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Image.asset(
                                      'assets/images/${garbage.garbageCategory}.png',
                                      height: 50),
                                  title: Text('garbage.name',
                                      style: titleTextStyle()),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('garbage.pickedUpAt',
                                          style: greyTextStyle()),
                                      Text('garbage.memo',
                                          style: bodyTextStyle()),
                                    ],
                                  ),
                                  trailing: Text(
                                    '+10',
                                    style: midTextStyle(),
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
