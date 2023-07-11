// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts() {
    const allProducts = <Product>[
      Product(
        rating: 3,
        id: 0,
        name: 'Emirates Wolgan Valley',
        location: 'Newnes, New South Wales, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 4,
        id: 1,
        name: 'Groote Eylandt Lodge',
        location: 'Alyangula, Northern Territory, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 5,
        id: 2,
        name: 'Darwin Waterfront Luxury Suites',
        location: 'Darwin, Northern Territory, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 4,
        id: 3,
        name: 'Mitchelton Hotel',
        location: 'Mitchellstown, Victoria, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 3,
        id: 4,
        name: 'Southern Ocean Lodge',
        location: 'Kangaroo Island, South Australia, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 3,
        id: 5,
        name: 'The Louise',
        location: 'Barossa Valley, South Australia, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
      Product(
        rating: 3,
        id: 6,
        name: 'COMO The Treasury',
        location: 'Perth, Western Australia, Australia',
        phone: '+01 234 5678',
        description: 'Description...',
      ),
    ];
    // if (id == id.all) {
    //   return allProducts;
    // } else {
    //   return allProducts.where((Product p) {
    //     return p.id == id;
    //   }).toList();
    return allProducts;
  }
}
