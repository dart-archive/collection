// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'unmodifiable_collection_test.dart' as common;

void main() {
  final list1 = const [1, 2, 3];
  final list2 = const [4, 5, 6];
  final list3 = const [7, 8, 9];
  final concat = []..addAll(list1)..addAll(list2)..addAll(list3);

  // In every way possible this should test the same as an UnmodifiableListView.
  common.testUnmodifiableList(concat, new CombinedListView(
    [list1, list2, list3]
  ), 'combineLists');

  common.testUnmodifiableList(concat, new CombinedListView(
    [list1, [], list2, [], list3, []]
  ), 'combineLists');

  test('should function as an empty list when no lists are passed', () {
    var empty = new CombinedListView([]);
    expect(empty, isEmpty);
    expect(empty.length, 0);
    expect(() => empty[0], throwsRangeError);
  });

  test('should function as an empty list when only empty lists are passed', () {
    var empty = new CombinedListView([[], [], []]);
    expect(empty, isEmpty);
    expect(empty.length, 0);
    expect(() => empty[0], throwsRangeError);
  });

  test('should reflect underlying changes back to the combined list', () {
    var backing1 = <int>[];
    var backing2 = <int>[];
    var combined = new CombinedListView([backing1, backing2]);
    expect(combined, isEmpty);
    backing1.addAll(list1);
    expect(combined, list1);
    backing2.addAll(list2);
    expect(combined, backing1.toList()..addAll(backing2));
  });

  test('should reflect underlying changes with a single list', () {
    var backing1 = <int>[];
    var combined = new CombinedListView([backing1]);
    expect(combined, isEmpty);
    backing1.addAll(list1);
    expect(combined, list1);
  });
}
