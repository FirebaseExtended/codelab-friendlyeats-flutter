// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

typedef FilterChangedCallback<T> = void Function(T newValue);

class Filter {
  final String city;
  final int price;
  final String category;
  final String sort;

  bool get isDefault {
    return (city == null && price == null && category == null && sort == null);
  }

  Filter({this.city, this.price, this.category, this.sort});
}
