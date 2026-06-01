import 'package:flutter/material.dart';

/// Border radius constants used throughout KAYAN
abstract class AppBorderRadius {
  static const double _xs  = 4;
  static const double _sm  = 8;
  static const double _md  = 12;
  static const double _lg  = 16;
  static const double _xl  = 20;
  static const double _xxl = 24;
  static const double _pill = 100;

  static BorderRadius get xs   => BorderRadius.circular(_xs);
  static BorderRadius get sm   => BorderRadius.circular(_sm);
  static BorderRadius get md   => BorderRadius.circular(_md);
  static BorderRadius get lg   => BorderRadius.circular(_lg);
  static BorderRadius get xl   => BorderRadius.circular(_xl);
  static BorderRadius get xxl  => BorderRadius.circular(_xxl);
  static BorderRadius get pill => BorderRadius.circular(_pill);

  // Component-specific
  static BorderRadius get card    => BorderRadius.circular(_lg);
  static BorderRadius get button  => BorderRadius.circular(_md);
  static BorderRadius get input   => BorderRadius.circular(_md);
  static BorderRadius get chip    => BorderRadius.circular(_sm);
  static BorderRadius get badge   => BorderRadius.circular(_xs);
  static BorderRadius get image   => BorderRadius.circular(_md);
  static BorderRadius get modal   => const BorderRadius.vertical(top: Radius.circular(_xxl));
  static BorderRadius get dialog  => BorderRadius.circular(_xl);

  // Bottom sheet / modal
  static BorderRadius get bottomSheet => const BorderRadius.vertical(
        top: Radius.circular(_xxl),
      );

  // Rounded top corners only (for stacked cards)
  static BorderRadius get topRounded => const BorderRadius.vertical(
        top: Radius.circular(_lg),
      );
}
