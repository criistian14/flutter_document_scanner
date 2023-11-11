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
  int get value {
    switch (this) {
      case FilterType.natural:
        return 1;

      case FilterType.gray:
        return 2;

      case FilterType.eco:
        return 3;
    }
  }
}
