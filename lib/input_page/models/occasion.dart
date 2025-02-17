import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Occasion {
  birthday('Birthday', Icons.cake),
  wedding('Wedding', CupertinoIcons.heart_fill),
  graduation('Graduation', Icons.school),
  anniversary('Anniversary', Icons.people),
  newJob('New Job', Icons.work),
  other('Other', CupertinoIcons.quote_bubble_fill);

  final String label;
  final IconData icon;

  const Occasion(this.label, this.icon);
}
