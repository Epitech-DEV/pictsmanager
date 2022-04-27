
import 'package:flutter/material.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/components/picture.dart';
import 'package:frontend/shared/date.dart';
import 'package:frontend/shared/globals.dart';

class PicturesGroup extends StatefulWidget {
  const PicturesGroup({ 
    required this.data,
    required this.changeMonth,
    required this.changeYear,
    Key? key 
  }) : super(key: key);

  final PicturesGroupData data;
  final bool changeYear;
  final bool changeMonth;

  @override
  State<PicturesGroup> createState() => _PicturesGroupState();
}

class _PicturesGroupState extends State<PicturesGroup> {
  @override
  Widget build(BuildContext context) {
    final bool displayDay = widget.data.type == GroupType.day;
    final bool displayMonth = widget.data.type == GroupType.month || (displayDay && widget.changeMonth);
    final bool displayYear = widget.data.type == GroupType.year || (displayMonth && widget.changeYear);

    return Column(
      children: [
        if (displayYear)
          Text(
            widget.data.date.year.toString(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        if (displayMonth)
          Text(
            Date.getMonthName(widget.data.date.month),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        if (displayDay)
          Text(
            Date.getDayName(widget.data.date.weekday),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        if (widget.data.pictures.isNotEmpty)
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: displayDay ? 4 : displayMonth ? 5 : 6,
              crossAxisSpacing: kSpace,
              mainAxisSpacing: kSpace,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Picture(data: widget.data.pictures[index]);
              },
              childCount: widget.data.pictures.length,
            ),
          ),
      ],
    );
  }
}