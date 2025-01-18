// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// Filter types
enum FilterType {
  /// Without filter
  natural,

  /// Gray scale filter
  gray,

  /// Threshold filter
  eco,
}

/// Extension with utilities to FilterType
extension FilterTypeExt on FilterType {
  /// Return value of the enum
  String get value {
    switch (this) {
      case FilterType.natural:
        return 'NATURAL_FILTER';

      case FilterType.gray:
        return 'GRAY_FILTER';

      case FilterType.eco:
        return 'ECO_FILTER';
    }
  }
}
