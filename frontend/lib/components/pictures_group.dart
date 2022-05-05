
import 'package:flutter/material.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/components/picture.dart';
import 'package:frontend/shared/date.dart';
import 'package:frontend/shared/globals.dart';

class PicturesGroup extends StatefulWidget {
  const PicturesGroup({ 
    required this.data,
    required this.monthHasChanged,
    required this.yearHasChanged,
    Key? key 
  }) : super(key: key);

  final PicturesGroupData data;
  final bool yearHasChanged;
  final bool monthHasChanged;

  @override
  State<PicturesGroup> createState() => _PicturesGroupState();
}

class _PicturesGroupState extends State<PicturesGroup> {
  @override
  Widget build(BuildContext context) {
    final bool displayDay = widget.data.type == PictureGroupType.day;
    final bool displayMonth = widget.data.type == PictureGroupType.month || (displayDay && widget.monthHasChanged);
    final bool displayYear = widget.data.type == PictureGroupType.year || (displayMonth && widget.yearHasChanged);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpace * 2, vertical: kSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildTitles(displayDay, displayMonth, displayYear),
          
          if (widget.data.pictures.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: displayDay ? 4 : (displayMonth ? 5 : 6),
                crossAxisSpacing: kSpace,
                mainAxisSpacing: kSpace,
              ),
              itemCount: widget.data.pictures.length,
              itemBuilder: (BuildContext context, int index) {
                return Picture(data: widget.data.pictures[index]);
              },
            ),
        ],
      ),
    );
  }

  List<Widget> _buildTitles(bool displayDay, bool displayMonth, bool displayYear) {
    final List<Widget> widgets = [];

    if (displayYear) {
      widgets.addAll(
        [
          Text(
            widget.data.date.year.toString(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: kSpace),
        ]
      );
    }

    if (displayMonth) {
      widgets.addAll(
        [
          Text(
            Date.getMonthName(widget.data.date.month),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: kSpace),
        ]
      );
    }

    if (displayDay) {
      widgets.addAll(
        [
          Text(
            "${Date.getDayName(widget.data.date.weekday)} ${widget.data.date.weekday}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: kSpace),
        ]
      );
    }

    return widgets;
  }
}