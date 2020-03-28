import 'package:test/test.dart';

import '../lib/tmpl.dart';

void main() {
  test('injects values', () {
    final tpl = Template(r'<div>${value}</div>');
    expect(tpl.compile({'value': 42}), equals('<div>42</div>'));
  });

  test('formats dates with default format', () {
    final tpl = Template(r'<div>${date}|date</div>');
    final value =
        tpl.compile({'date': DateTime.parse('2020-03-26T02:59:34.724593')});

    expect(value, equals('<div>2020-03-26 02:59 AM</div>'));
  });

  test('formats dates with defined format', () {
    final tpl = Template(r'<div>${date}|date(yyyy-MM-dd)</div>');
    final value =
        tpl.compile({'date': DateTime.parse('2020-03-26T02:59:34.724593')});

    expect(value, equals('<div>2020-03-26</div>'));
  });

  test('evaluates conditions', () {
    final tpl = Template(r'?((<div>something</div>)(value))');

    expect(tpl.compile({'value': true}), equals('<div>something</div>'));
    expect(tpl.compile({'value': false}), equals(''));
    expect(tpl.compile({'value': null}), equals(''));
  });

  test('evaluates conditions and interpolates values', () {
    final tpl = Template(r'''
?((
  <div>
    ${value}
  </div>
)(condition))''');

    expect(
      tpl.compile({'value': '42', 'condition': true}),
      equals(r'''
  <div>
    42
  </div>
'''),
    );
  });
}
