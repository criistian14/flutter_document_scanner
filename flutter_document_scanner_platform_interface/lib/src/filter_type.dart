// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum FilterType {
  natural,
  gray,
  eco,
}

extension FilterTypeExt on FilterType {
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
