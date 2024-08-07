import 'package:flutter/material.dart';
import '../utils/change_date_format.dart';
import '../utils/constants.dart';
import '../utils/get_address.dart';
import '../utils/styles.dart';
import 'package:eco_picker/data/garbage.dart';

class MapBottomSheet extends StatefulWidget {
  DraggableScrollableController? controller;
  Garbage? garbageDetail;
  final void Function({String? categoryFilter}) onCategorySelected;

  MapBottomSheet({
    Key? key,
    this.controller,
    required this.onCategorySelected,
    this.garbageDetail,
  }) : super(key: key);

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  late Garbage? _garbageDetail;

  @override
  void initState() {
    super.initState();
    _garbageDetail = widget.garbageDetail;
  }

  @override
  void didUpdateWidget(MapBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.garbageDetail != oldWidget.garbageDetail) {
      setState(() {
        _garbageDetail = widget.garbageDetail;
      });
    }
  }

  void _handleCategorySelected(String category) {
    if (widget.controller != null && widget.controller!.size > 0.1) {
      widget.controller!.animateTo(
        0.1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    widget.onCategorySelected(categoryFilter: category);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _garbageDetail != null ? 0.5 : 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.7,
      controller: widget.controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF6BBD6E),
          ),
          child: _garbageDetail != null
              ? _buildGarbageDetail()
              : _buildCategoryList(scrollController),
        );
      },
    );
  }

  Widget _buildCategoryList(ScrollController scrollController) {
    return Column(
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
                  title: Text('Choose Category', style: titleWhiteTextStyle()),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    String category = categories[index];
                    return Container(
                      color: Color(0xFFFAFAFA),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (category != 'Display All')
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      categoryIcons[category]!,
                                      height: 30,
                                    ),
                                  ),
                                Text(
                                  category,
                                  style: titleTextStyle(),
                                ),
                              ],
                            ),
                            onTap: () {
                              _handleCategorySelected(category == 'Display All'
                                  ? 'Display All'
                                  : categoryENUM[category]!);
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGarbageDetail() {
    final garbage = widget.garbageDetail!;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xFF6BBD6E),
          ),
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Garbage Detail',
                  style: headingWhiteTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Color(0xFFFAFAFA),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/${garbage.category}.png',
                      height: 40,
                    ),
                    Text(changeDateFormat(garbage.pickedUpAt),
                        style: titleTextStyle()),
                  ],
                ),
                SizedBox(height: 10),
                Text(garbage.name, style: titleTextStyle()),
                SizedBox(height: 5),
                if (garbage.latitude != null && garbage.longitude != null)
                  FutureBuilder<String>(
                    future: getAddressFromLatLng(
                        garbage.latitude!, garbage.longitude!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data!, style: bodyTextStyle());
                      } else {
                        return Text('No address available',
                            style: bodyTextStyle());
                      }
                    },
                  )
                else
                  Text('No coordinates available', style: bodyTextStyle()),
                Text(garbage.memo ?? '', style: greyTextStyle()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
