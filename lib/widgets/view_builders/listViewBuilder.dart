import 'package:flutter/material.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/widgets/widgets.dart';

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    Key? key,
    required this.photo,
    required this.isAdded,
  }) : super(key: key);

  final Photo photo;
  final bool isAdded;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPhoto(widget.photo, context, 17),
            DetailedBlock(widget.photo, likeButton: true,),
            // BuildInfo(data: widget.photo, isAdded: widget.isAdded),
            buildAbout(widget.photo),
          ]
      ),
    );
}
